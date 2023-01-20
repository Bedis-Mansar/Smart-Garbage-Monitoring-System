import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:wastescale/services/services.dart';

class Location extends StatefulWidget {
  LatLng? pos;
  Location({
    Key? key,
    required this.pos,
  }) : super(key: key);
  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  LatLng pos = const LatLng(45.521563, -122.677433);
  final initialCameraPosition = const CameraPosition(
    target: LatLng(36.80278, 10.17972),
    zoom: 8.0,
  );
  bool getdistance = false;
  double distance = 0.0;
  String googleAPiKey = "AIzaSyDUGiag9iFzA4Tft5rEXqRfdlQNbZKrerY";
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  @override
  void initState() {
    // TODO: implement initState
    pos = this.widget.pos!;
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  getCurrentLocation() async {
    LatLng pos = await getUserCurrentLocation();
    print('pos : $pos');
    CameraPosition cameraPosition = new CameraPosition(
      target: pos,
      zoom: 14,
    );
    final GoogleMapController controller = await mapController;
    if(getdistance==false) controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {
      addMarker(pos);
    });
  }

  getLocation(LatLng pos) async {
    CameraPosition cameraPosition = new CameraPosition(
      target: LatLng(pos.latitude, pos.longitude),
      zoom: 14,
    );
    final GoogleMapController controller = await mapController;
    if (getdistance==false) controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {
      addMarker(LatLng(pos.latitude, pos.longitude));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Maps'),
          backgroundColor: Colors.green[700],
          actions: [
            IconButton(
              onPressed: () {
                getLocation(pos);
              },
              icon: Icon(
                Icons.location_on,
                size: 30,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              initialCameraPosition: initialCameraPosition,
              onLongPress: addMarker,
              markers: _markers,
              polylines: Set<Polyline>.of(polylines.values),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange.shade100, // button color
                      child: InkWell(
                        splashColor: Colors.orange, // inkwell color
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.route),
                        ),
                        onTap: () async {
                          setState(() {
                            getdistance=!getdistance;
                          });
                          if (getdistance==true){
                          getCurrentLocation();
                          getLocation(pos);
                          final GoogleMapController controller =  mapController;
                          final cameraPosition = CameraPosition(
                            target: LatLng(35.80278, 10.17972),
                            zoom: 8.0,
                          );
                          controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
                          LatLng startpos = await getUserCurrentLocation();
                          getDirections(startpos, pos);
                          }
                          //Navigator.pushNamed(context, '/screens/distance');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if(getdistance==true)
              SafeArea(child: Container(
                  child: Card(
                    child: Container(
                        padding: EdgeInsets.all(20),
                        child: Text("Total Distance: " + distance.toStringAsFixed(2) + " KM",
                            style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold))
                    ),
                  )
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: () {
            getCurrentLocation();
          },
          child: const Icon(Icons.location_searching),
        ),
      ),
    );
  }

  void addMarker(LatLng pos) {
    int i = _markers.length;
    Marker marker = Marker(markerId: MarkerId('0'));
    setState(() {
      marker = Marker(
          markerId: MarkerId("$i"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: pos);
      _markers.add(marker);
    });
  }
  getDirections(LatLng startLocation, LatLng endLocation) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );
    bool a= result.points.isNotEmpty ;
    print('result : $a');
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    print(polylineCoordinates);

    //polulineCoordinates is the List of longitute and latidtude.
    double totalDistance = 0;
    for(var i = 0; i < polylineCoordinates.length-1; i++){
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i+1].latitude,
          polylineCoordinates[i+1].longitude);
    }
    print(totalDistance);

    setState(() {
      distance = totalDistance;
    });

    //add to the list of poly line coordinates
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }
}
