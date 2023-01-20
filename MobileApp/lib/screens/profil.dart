import 'package:flutter/material.dart';
import 'package:wastescale/data/models/user.dart';
import 'package:wastescale/services/services.dart';
import 'package:wastescale/theme/colors.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  User user=User(name: '', email: '');
  @override
  void initState() {
    initUser();
    print(user.name);
  }
  Future<void> initUser() async {
    setState(() async{
      user = await getUser();
    });

  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: GetColor.primaryGreen,
            title: Text('Profil',style: TextStyle(fontWeight:FontWeight.w400,fontSize: 24,color: GetColor.white1),),
          ),
          backgroundColor: GetColor.white1,
            body: Padding(
              padding: EdgeInsets.only(top: screenSize.height*0.1),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    child: Image(image: AssetImage('assets/person.png',)),
                  ),
                  SizedBox(height: 60.0,),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30.0,horizontal: 40.0),
                  //margin: EdgeInsets.symmetric(horizontal: 40.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: GetColor.primaryGreen,
                  ),
                  child: Column(
                    children: [
                      Text('Name :',textAlign: TextAlign.left,style: TextStyle(fontWeight:FontWeight.w300,fontSize: 18,color: GetColor.white2),),
                      SizedBox(height: 10.0,),
                      Text(user.name,textAlign: TextAlign.left,style: TextStyle(fontWeight:FontWeight.w400,fontSize: 24,color: GetColor.white1),),
                      SizedBox(height: 20.0,),
                      Text('Email :',textAlign: TextAlign.left,style: TextStyle(fontWeight:FontWeight.w300,fontSize: 18,color: GetColor.white2),),
                      SizedBox(height: 10.0,),
                      Text(user.email,textAlign: TextAlign.left,style: TextStyle(fontWeight:FontWeight.w400,fontSize: 18,color: Colors.white),),

                    ],
                  ),),
              ),
                ],
    ),
            )));
  }
}
