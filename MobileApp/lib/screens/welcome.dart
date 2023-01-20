import 'package:flutter/material.dart';
import 'package:wastescale/theme/colors.dart';
import 'package:wastescale/widgets/button.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'WasteScale',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                Column(
                  children: [
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Welcome',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: GetColor.white1),
                        )),
                    //SizedBox(height: 10.0,),
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Think outside the trash',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: GetColor.white1),
                        )),
                    const SizedBox(
                      height: 40.0,
                    ),
                    MyButton(
                        boxWidth: screenSize.width * 0.75,
                        boxColor: GetColor.white1,
                        text: 'Login',
                        textColor: GetColor.primaryGreen,
                        boxFunc: () {
                          Navigator.pushNamed(context, '/screens/login');
                        }),
                    const SizedBox(
                      height: 20.0,
                    ),
                    MyButton(
                        boxWidth: screenSize.width * 0.75,
                        boxColor: GetColor.primaryGreen,
                        text: 'Sign Up',
                        textColor: GetColor.white1,
                        boxFunc: () {
                          Navigator.pushNamed(context, '/screens/signup');
                        }),
                  ],
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
