import 'package:flutter/material.dart';
import 'package:wastescale/screens/changepasswordsuccess.dart';
import 'package:wastescale/screens/code.dart';
import 'package:wastescale/screens/home.dart';
import 'package:wastescale/screens/login.dart';
import 'package:wastescale/screens/newpassword.dart';
import 'package:wastescale/screens/profil.dart';
import 'package:wastescale/screens/registersuccess.dart';
import 'package:wastescale/screens/sendmail.dart';
import 'package:wastescale/screens/signup.dart';
import 'package:wastescale/screens/splashscreen.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const SplashScreen(),
      initialRoute: '/',
      routes:  {
        '/screens/login': (context) => const Login(),
        '/screens/signup': (context) => const Signup(),
        '/screens/registersuccess': (context) => const RegisterSuccess(),
        '/screens/home': (context) => const Home(),
        '/screens/sendmail': (context) => const SendMail(),
        '/screens/code': (context) => const Code(),
        '/screens/newpassword': (context) => const ChangePassword(),
        '/screens/changepasswordsuccess': (context) => const ChangePasswordSuccess(),
        '/screens/profil': (context) => const Profil(),

      },
    );
  }


}