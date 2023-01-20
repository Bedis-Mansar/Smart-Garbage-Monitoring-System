import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wastescale/data/models/user.dart';
import 'package:wastescale/screens/sidebar.dart';
import 'package:wastescale/services/authservices.dart';
import 'package:wastescale/services/services.dart';
import 'package:wastescale/widgets/can.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double val1 = 0;
  double val2=70;
  double distance =0.0;
  User user=User(name: '', email: '');
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://mqtt.smartgarbagecot.me/pushes'),
  );
  Timer? timer;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  initState() {
    initUser();
    super.initState();
    timer = Timer.periodic(Duration(minutes: 15), (Timer t) => refreshToken());
  }

  Future<void> initUser()  async {
    setState(() async{
      user = await getUser();
      print(user.name);
    });

  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _globalKey,
        drawer: SideBar(name : user.name,email :user.email),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: screenSize.height * 0.2,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/header.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Welcome',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(
                                user.name,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {

                              });
                              _globalKey.currentState!.openDrawer();
                            },
                            icon: const Icon(
                              Icons.menu_rounded,
                              color: Colors.white,
                              size: 30.0,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                child: Column(
                  children: [

                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Nearby trash cans',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff404040)),
                        )),
                    const SizedBox(
                      height: 20.0,
                    ),
                    StreamBuilder(
                      stream: channel.stream,
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          distance = jsonDecode(snapshot.data)["value"];
                          var val = (100.0-((distance/25.0)*100));
                          String inString = val.toStringAsFixed(2);
                          val1 = double.parse(inString);
                        }
                        else val1=0.0;

                        return Can(val: val1,id: 0,);
                      },
                    ),
                    SizedBox(height: 20.0,),
                    Can(val: val2,id: 1,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    channel.sink.close();
    timer?.cancel();
    super.dispose();
  }
}
