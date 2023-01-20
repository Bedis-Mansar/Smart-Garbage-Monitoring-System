import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wastescale/screens/code.dart';
import 'package:wastescale/services/services.dart';
import 'package:wastescale/widgets/button.dart';
import 'package:wastescale/widgets/textfield.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool loading = true;
    void validation() {
      if (passwordController.text.trim().isEmpty || !RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(passwordController.text) && passwordController.text.length < 8 ) {
        Fluttertoast.showToast(msg: 'Please Enter a strong password',gravity: ToastGravity.BOTTOM,backgroundColor: Colors.red,webPosition: "center");
        loading = true;
        return;
      }
      if (passwordConfirmationController.text.isEmpty  || passwordConfirmationController.text.trim() != passwordController.text.trim()) {
        Fluttertoast.showToast(msg: 'Invalid password Confirmation',gravity: ToastGravity.BOTTOM,backgroundColor: Colors.red,);
        loading = true;
        return;
      }
      else {
        setState(() {
          loading = false;
        });
        return;
      }}
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: screenSize.height*0.1,horizontal:screenSize.width*0.1),
            child: Center(
              child: Column(
                children: [
                  Image.asset('assets/newpass.png',),
                  SizedBox(height: 20.0,),
                  Text('Enter new Password',style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500,color: Color(0xff404040)),),
                  SizedBox(height: 20.0,),
                  Text('Use the new password to reset your account',style: TextStyle(fontSize: 12,color: Color(0xff535353)),),
                  SizedBox(height: 20.0,),
                  Textfield(text: 'Password', controller: passwordController,hintText: '**************',password:true),
                  SizedBox(height: 20.0,),
                  Textfield(text: 'Password Confirmation', controller: passwordConfirmationController,hintText: '**************',password:true),
                  SizedBox(height: 20.0,),
                  MyButton(boxWidth: screenSize.width*0.75, boxColor: const Color(0xff1DB954), text: 'Update', textColor: Colors.white, boxFunc: (){
                    validation();
                    if (loading == false){
                      changePassword(codeContoller.text, passwordController.text);
                      Navigator.pushNamed(context, '/screens/changepasswordsuccess');
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
