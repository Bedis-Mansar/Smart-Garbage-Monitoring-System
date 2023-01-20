import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wastescale/data/models/user.dart';
import 'package:wastescale/screens/login.dart';
import 'package:wastescale/data/models/location.dart' show Location;
import 'package:geocoder/geocoder.dart' show Coordinates, Geocoder;
import 'package:geolocator/geolocator.dart' show Geolocator;
import 'package:dio/dio.dart';

Dio dio=Dio();

Future getRequest() async {
  final accessToken = await secureStorage.readSecureData("accessToken");
  //print('accesstoken : $accessToken');
  var url = "https://api.smartgarbagecot.me/api/sensor";
  final request = RequestOptions(
    method: 'GET',
    path: '/',
    contentType: 'application/json',
    headers: {"Authorization": "Bearer $accessToken"},
  );
  return dio.request(url,
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          contentType: request.contentType,
          headers: request.headers,
          method: request.method))
      .then((value) {
    var responseData = value.data;
    //print('response : $responseData');
    return (responseData);
});}

Future<Location> getLocations(int id) async {
  List<Location> locations = [];
  var responseData = await getRequest();
  for (var singleLoc in responseData){
    Location location = Location(
      id: singleLoc["id"],
      latitude: singleLoc["latitude"],
      longitude: singleLoc["longitude"],);
    locations.add(location);
  }
  return locations[id];
}

getLongLat(int id) async {
  var loc = await getLocations(id);
  double lat = loc.latitude;
  double long = loc.longitude;
  final coordinates = [lat, long];
  return (coordinates);
}

Future<String> getAddress(int id) async {
  final coord = await getLongLat(id);
  final coordinates = Coordinates(coord[0], coord[1]);
  var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  var first = addresses[0];
  return("${first.addressLine}");
}

Future getUserCurrentLocation() async {
  await Geolocator.requestPermission().then((value){
  }).onError((error, stackTrace) async {
    await Geolocator.requestPermission();
  });
  var val= await Geolocator.getCurrentPosition();
  LatLng pos= await LatLng(val.latitude, val.longitude);
  //print('pos : $pos');
  return pos;
}

double calculateDistance(lat1, lon1, lat2, lon2){
  var p = 0.017453292519943295;
  var a = 0.5 - cos((lat2 - lat1) * p)/2 +
      cos(lat1 * p) * cos(lat2 * p) *
          (1 - cos((lon2 - lon1) * p))/2;
  return 12742 * asin(sqrt(a));
}

requestSignup(String mail, String name, String password, int permission){
  String preLoginUrl="https://api.smartgarbagecot.me/api/user";
  final data = {"mail": mail,"fullname":name,"password":password,"permissionLevel":permission};
  print("data : $data");
  final request = RequestOptions(
    method: 'POST',
    path: '/',
    contentType: 'application/json',
  );
  return dio.request(preLoginUrl,
      data: data,
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          contentType: request.contentType,
          method: request.method)).then((value) {
    var responseData = value.data;
    print('response : $responseData');
});
}

getUser()async{
  final accessToken = await secureStorage.readSecureData("accessToken");
  print(accessToken);
  String foo = accessToken.split('.')[1];
  List<int> res = base64.decode(base64.normalize(foo));
  final decoded = jsonDecode(utf8.decode(res));
  print('decoded : $decoded');
  final mail = decoded["sub"];

  String url='https://api.smartgarbagecot.me/api/profile/'+'$mail';
  print(url);
  final request = RequestOptions(
    method: 'GET',
    path: '/',
    contentType: 'application/json',
    headers: {"Authorization":"Bearer $accessToken"},
  );
  return dio.request(url,
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          contentType: request.contentType,
          headers: request.headers,
          method: request.method))
      .then((value) {
        final data = value.data;
        print('data : $data');
    User user = User(name: data["fullname"], email: mail);
    final name = user.name;
   // print(name);
    return user;
  });
}

sendMail(String mail){
  var url = "https://api.smartgarbagecot.me/api/mail/"+mail;
  final request = RequestOptions(
    method: 'GET',
    path: '/',
    contentType: 'application/json',
  );
  return dio.request(url,
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          contentType: request.contentType,
          method: request.method));
}

verifCode (String code){
  var url = "https://api.smartgarbagecot.me/api/mail/"+code;
  final request = RequestOptions(
    method: 'POST',
    path: '/',
    contentType: 'application/json',
  );
  return dio.request(url,
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          contentType: request.contentType,
          method: request.method))
      .then((value) {
    var responseData = value.data;
    var data = responseData.toString();
    var data1 = data.substring(30, 66);
    //print('response : $data1');
    return(data1);
  });
}

changePassword(String code, String password){
  var url = "https://api.smartgarbagecot.me/api/mail/"+code+"/"+password;
  final request = RequestOptions(
    method: 'POST',
    path: '/',
    contentType: 'application/json',
  );
  return dio.request(url,
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          contentType: request.contentType,
          method: request.method))
      .then((value) {
    var responseData = value.data;
    print('response : $responseData');
  });
}

logout() async {
  final deleted1 = await secureStorage.deleteSecureData("accessToken");
  final deleted2 = await secureStorage.deleteSecureData("refreshToken");
}