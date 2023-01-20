import 'package:flutter/material.dart';
import 'package:wastescale/screens/welcome.dart';
import 'package:wastescale/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome()async{
    await Future.delayed(Duration(milliseconds: 5000),(){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Welcome()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 70.0,),
              Container(
                  alignment: Alignment.center,
                  child: Image.asset('assets/Logo.png'),),
              SizedBox(height: 70.0,),
              Text('Maintain cleanliness,\nto gain health and happiness',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontFamily: 'Lato',color: GetColor.tertiaryGreen)),
              SizedBox(height: 50.0,),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(GetColor.primaryGrey),
              ),
            ],
          ),
        ),
      );
  }
}
