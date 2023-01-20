import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wastescale/services/services.dart';
import '../screens/location.dart';

class Can extends StatefulWidget {
  int id=0;
  late double val;
  Can({Key? key,
  required this.val,
    required this.id,
  }) : super(key: key);

  @override
  State<Can> createState() => _CanState();
}

class _CanState extends State<Can> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff1DB954)),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.val < 30)
            Image.asset(
              'assets/vide.png',
              height: 71.0,
            ),
          if (widget.val >= 30 && widget.val< 70)
            Image.asset(
              'assets/moy.png',
              height: 71.0,
            ),
          if (widget.val >= 70)
            Image.asset(
              'assets/plein.png',
              height: 71.0,
            ),
          Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/location.png',
                    height: 21,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  FutureBuilder(
                      future: getAddress(widget.id),
                      builder: (context,snapshot){return Text(
                        snapshot.hasData ? snapshot.data! : '',
                        softWrap: true,
                        style: const TextStyle(
                            color: Color(0xff038E4C),
                            fontSize: 8.5),
                      );}
                  )
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/pourcentage.png',
                    height: 21,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                 Text('${widget.val}',
                        style: const TextStyle(
                            color: Color(0xff038E4C),
                            fontSize: 18.0),
                      ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 20.0,),
          IconButton(onPressed: ()async{
            final coordinates = await getLongLat(widget.id);
            double lat = coordinates[0];
            print(lat);
            double long = coordinates[1];
            print(long);
            LatLng pos = LatLng(lat, long);
            Navigator.push(context, MaterialPageRoute(builder: (context) => Location(pos : pos)));},
            icon: const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.black,
              size: 20.0,
            ),),
        ],
      ),
    );
  }
}
