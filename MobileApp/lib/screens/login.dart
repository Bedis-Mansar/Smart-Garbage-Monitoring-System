import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pkce/pkce.dart';
import 'package:wastescale/data/models/storage.dart';
import 'package:wastescale/services/authservices.dart';
import 'package:wastescale/theme/colors.dart';
import 'package:wastescale/widgets/button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wastescale/widgets/textfield.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}
final SecureStorage secureStorage = SecureStorage();

class _LoginState extends State<Login> {
  bool isHidden = true;
  bool loading = false;
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
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
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: screenSize.height * 0.35,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/deco.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
                child: Column(
                  children: const [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                    //SizedBox(height: 10.0,),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'to access the app!',
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
                height: screenSize.height * 0.6,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Textfield(text: 'Email', controller: mailController,hintText: 'xxxxx@gmail.com',password: false,),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Textfield(text: 'Password', controller: passwordController,hintText: '**************',password:true,),
                        const SizedBox(
                          height: 20.0,
                        ),
                        MyButton(
                            boxWidth: screenSize.width * 0.75,
                            boxColor: const Color(0xff1DB954),
                            text: 'Login',
                            textColor: Colors.white,
                            boxFunc: () async {
                              //validation();
                              try {
                                final pkcePair = PkcePair.generate();
                                final codeVerifier = pkcePair.codeVerifier;
                                final codeChallenge = pkcePair.codeChallenge;
                                String signInId= await requestLoginId(codeChallenge);
                                String authCode = await requestAuthCode(mailController, passwordController,signInId);
                                final token = await requestToken(authCode, codeVerifier);
                                secureStorage.writeSecureData('accessToken', token["accessToken"]);
                                secureStorage.writeSecureData("refreshToken", token["refreshToken"]);
                              }catch (error) {
                                Fluttertoast.showToast(
                                  msg: 'Invalid Login',
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: GetColor.red,
                                );
                              setState(() {
                                loading=true;
                              });
                              }

                              setState(() {
                                if (loading==false){
                                Navigator.pushNamed(context, '/screens/home');}
                              });
                            }),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/screens/sendmail');
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: Color(0xff535353), fontSize: 10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'You don’t have an account?',
                              style: TextStyle(
                                  color: Color(0xff535353), fontSize: 12),
                            ),
                            Builder(
                              builder: (context) => Container(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/screens/signup');
                                  },
                                  child: const Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                        color: Color(0xff00A3FF), fontSize: 12),
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
