import 'package:flutter/material.dart';
import 'package:wastescale/widgets/button.dart';
class ChangePasswordSuccess extends StatelessWidget {
  const ChangePasswordSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF6F7FB),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: screenSize.height*0.15),
            child: Center(
              child: Column(
                children: [
                  Image.asset('assets/ok.gif',height: 200.0,),
                  SizedBox(height: 20.0,),
                  Text('Congratulations',style: TextStyle(fontSize: 24,fontWeight:FontWeight.bold,color: Color(0xff1DB954)),),
                  SizedBox(height: 20.0,),
                  Text('Password changed successfully',style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500,color: Color(0xff404040)),),
                  SizedBox(height: 10.0,),
                  Text('Please login again',style: TextStyle(fontSize: 12,color: Color(0xff535353)),),
                  SizedBox(height: screenSize.height*0.1),
                  MyButton(boxWidth: screenSize.width*0.75, boxColor: const Color(0xff1DB954), text: 'Continue', textColor:Colors.white , boxFunc: (){
                    Navigator.pushNamed(context, '/screens/login');
                  }),
                ],
              ),
            ),
          ),
        ),
      ), );
  }
}
