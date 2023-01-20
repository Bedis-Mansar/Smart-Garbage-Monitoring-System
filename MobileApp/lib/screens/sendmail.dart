import 'package:flutter/material.dart';
import 'package:wastescale/services/services.dart';
import 'package:wastescale/theme/colors.dart';
import 'package:wastescale/widgets/button.dart';
import 'package:wastescale/widgets/textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SendMail extends StatefulWidget {
  const SendMail({Key? key}) : super(key: key);

  @override
  State<SendMail> createState() => _SendMailState();
}

class _SendMailState extends State<SendMail> {
  TextEditingController mailController = TextEditingController();
  bool loading = true;

  void validation() {
    if (mailController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please Enter your email',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: GetColor.red,
      );
      return;
    }
    if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(mailController.text)) {
      Fluttertoast.showToast(
        msg: 'Please Enter a valid email',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: GetColor.red,
      );
      return;
    } else {
      setState(() {
        loading = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: screenSize.height*0.15,horizontal:screenSize.width*0.1),
            child: Center(
              child: Column(
                children: [
                  Image.asset('assets/email.png'),
                  SizedBox(height: 20.0,),
                  Text('Enter your email',style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500,color: Color(0xff404040)),),
                  SizedBox(height: 20.0,),
                  Text('We\'ll send you the code on the email associated with your account',style: TextStyle(fontSize: 12,color: Color(0xff535353)),),
                  SizedBox(height: 20.0,),
                  Textfield(text: 'Email', controller: mailController,hintText: 'xxxxx@gmail.com',password: false,),
                  SizedBox(height: 20.0,),
                  MyButton(boxWidth: screenSize.width*0.75, boxColor: const Color(0xff1DB954), text: 'Send code', textColor: Colors.white, boxFunc: (){
                    validation();
                    if(loading == false){
                      sendMail(mailController.text);
                      Navigator.pushNamed(context, '/screens/code');
                    }

                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
