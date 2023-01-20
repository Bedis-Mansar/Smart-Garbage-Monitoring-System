import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:dio/dio.dart';

import '../screens/login.dart';

Dio dio=Dio();

Future<String> requestLoginId(String codeChallenge) async{
  String preLoginUrl="https://api.smartgarbagecot.me/api/authorize";
  final clientId = randomAlphaNumeric(10);
  final encoded = base64Url.encode(utf8.encode(clientId + "#" + codeChallenge));
  final request = RequestOptions(
    method: 'POST',
    path: '/',
    contentType: 'application/json',
    headers: {"Pre-Authorization": "Bearer $encoded"},
  );
  return dio.request(preLoginUrl,
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          contentType: request.contentType,
          headers: request.headers,
          method: request.method))
      .then((value) {
        print(value.data["signInId"]);
    return value.data["signInId"];
  });
}

Future<String> requestAuthCode(TextEditingController username, TextEditingController password, String signInId) async {
  String preLoginUrl="https://api.smartgarbagecot.me/api/authenticate/";
  final request = RequestOptions(
    method: 'POST',
    path: '/',
    contentType: 'application/json',
  );
  return dio.request(preLoginUrl,
      data: {"mail": username.text,"password":password.text,"signInId":signInId},
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          contentType: request.contentType,
          method: request.method))
      .then((value) {
    return value.data["authCode"];
  });
}

requestToken(String authCode,String codeVerifier) async{
  String preLoginUrl='https://api.smartgarbagecot.me/api/oauth/token';
  final encoded = base64Url.encode(utf8.encode(authCode + "#" + codeVerifier));
  final request = RequestOptions(
    method: 'GET',
    path: '/',
    contentType: 'application/json',
    headers: {"Post-Authorization": "Bearer $encoded"},
  );
  return dio.request(preLoginUrl,
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          contentType: request.contentType,
          headers: request.headers,
          method: request.method))
      .then((value) {
    return (value.data);
  });
}

refreshToken() async{
  final accessToken = await secureStorage.readSecureData("accessToken");
  final refreshToken = await secureStorage.readSecureData("refreshToken");
  print('accessToken1 : $accessToken');
  final deleted1 = await secureStorage.deleteSecureData("accessToken");
  final deleted2 = await secureStorage.deleteSecureData("refreshToken");
  var url = "https://api.smartgarbagecot.me/api/oauth/token/refresh";
  final request = RequestOptions(
    method: 'GET',
    path: '/',
    contentType: 'application/json',
    headers: {"Refresh-Authorization": refreshToken,"Authorization":"Bearer $accessToken"},
  );
  return dio.request(url,
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          contentType: request.contentType,
          headers: request.headers,
          method: request.method))
      .then((value) async {
    var responseData = value.data;
    print('response : $responseData');
    secureStorage.writeSecureData('accessToken', responseData["accessToken"]);
    secureStorage.writeSecureData("refreshToken", responseData["refreshToken"]);
    final accessToken = await secureStorage.readSecureData("accessToken");
    print('accessToken2 : $accessToken');
});}

