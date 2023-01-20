import 'package:flutter/material.dart';
import 'package:wastescale/services/services.dart';
import 'package:wastescale/theme/colors.dart';
import 'package:wastescale/widgets/button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wastescale/widgets/textfield.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isHidden = true;
  bool isHidden1 = true;
  bool loading = true;

  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  void validation() {
    if (nameController.text.isEmpty ) {
      Fluttertoast.showToast(msg: 'Please Enter your name',gravity: ToastGravity.BOTTOM,backgroundColor: Colors.red,);
      loading = true;
      return;
    }

    if (mailController.text.isEmpty ) {
      Fluttertoast.showToast(msg: 'Please Enter your email',gravity: ToastGravity.BOTTOM,backgroundColor: Colors.red,);
      loading = true;
      return;
    }
    if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(mailController.text)) {
      Fluttertoast.showToast(msg: 'Please Enter a valid email',gravity: ToastGravity.BOTTOM,backgroundColor: Colors.red,);
      loading = true;
      return;
    }

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
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: screenSize.height * 0.35,
                //width: screenSize.width*2,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/deco.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
                child: Column(
                  children: const [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                    //SizedBox(height: 10.0,),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'to get an account!',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        )),
                  ],
                ),
              ),
              Container(
                width: screenSize.width * 0.8,
                height: screenSize.height * 0.75,
                margin: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.1,
                    vertical: screenSize.height * 0.2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ],
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Textfield(text: 'Full Name', controller: nameController,hintText: 'Full Name',password: false,),
                        SizedBox(height: 20.0,),
                        Textfield(text: 'Email', controller: mailController,hintText: 'xxxxx@gmail.com',password: false,),
                        SizedBox(height: 20.0,),
                        Textfield(text: 'Password', controller: passwordController,hintText: '**************',password:true),
                        SizedBox(height: 20.0,),
                        Textfield(text: 'Password Confirmation', controller: passwordConfirmationController,hintText: '**************',password:true),
                        SizedBox(height: 20.0,),
                        MyButton(boxWidth: screenSize.width*0.75, boxColor: const Color(0xff1DB954), text: 'Register', textColor: Colors.white, boxFunc: (){
                          validation();
                          print(loading);
                          try {
                            requestSignup(mailController.text, nameController.text, passwordController.text, 1);
                          }catch (error) {
                            Fluttertoast.showToast(
                              msg: 'Invalid Sinup',
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: GetColor.red,
                            );
                            setState(() {
                              loading=true;
                            });
                          }
                          if (loading==false){
                            Navigator.pushNamed(
                                context, '/screens/registersuccess');
                          }
                        }),
                        SizedBox(height: 20.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                  color: Color(0xff535353), fontSize: 12),
                            ),
                            Builder(
                              builder: (context) => Container(
                                child: TextButton(
                                  onPressed: () {Navigator.pushNamed(context, '/screens/login');},
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Color(0xff00A3FF),
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
