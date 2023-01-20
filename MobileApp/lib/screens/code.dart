import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wastescale/services/services.dart';
import 'package:wastescale/theme/colors.dart';
import 'package:wastescale/widgets/button.dart';
import 'package:wastescale/widgets/textfield.dart';

class Code extends StatefulWidget {
  const Code({Key? key}) : super(key: key);

  @override
  State<Code> createState() => _CodeState();
}
TextEditingController codeContoller = TextEditingController();
class _CodeState extends State<Code> {

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
                  Image.asset('assets/code.png'),
                  SizedBox(height: 20.0,),
                  Text('Enter Code',style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500,color: Color(0xff404040)),),
                  SizedBox(height: 20.0,),
                  Text('We have sent a code to your email for authentication.',style: TextStyle(fontSize: 12,color: Color(0xff535353)),),
                  SizedBox(height: 20.0,),
                  Textfield(text: '', controller: codeContoller,hintText: 'jnkKroelLTferref',password: false,),
                  SizedBox(height: 20.0,),
                  MyButton(boxWidth: screenSize.width*0.75, boxColor: const Color(0xff1DB954), text: 'Verify', textColor: Colors.white, boxFunc: () async {
                    var coode = codeContoller.text;
                    print('code1 : $coode');
                    var codeverif = await verifCode(codeContoller.text);
                    print('code2 : $codeverif');
                    bool test = (codeverif==coode);
                    print('test : $test');
                    if(codeverif == codeContoller.text){
                      Navigator.pushNamed(context, '/screens/newpassword');
                    }
                    else{
                      Fluttertoast.showToast(
                        msg: 'Invalid code',
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: GetColor.red,
                      );
                      //return;
                    }
                   //
                  }),
                  SizedBox(height: 50.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Didn\'t receive your email?',
                        style: TextStyle(
                            color: Color(0xff535353), fontSize: 12),
                      ),
                      Builder(
                        builder: (context) => Container(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/screens/sendmail');
                            },
                            child: const Text(
                              'Resend',
                              style: TextStyle(
                                  color: Color(0xff00A3FF), fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
