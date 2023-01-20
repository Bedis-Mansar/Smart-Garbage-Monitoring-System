import 'package:flutter/material.dart';
import 'package:wastescale/services/services.dart';
import 'package:wastescale/theme/colors.dart';
import 'package:wastescale/widgets/sidebaritem.dart';

class SideBar extends StatelessWidget {
  String name = '';
  String email = '';
  SideBar({Key? key,
  required this.name, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(horizontal: 20);
    return Drawer(
      child: Material(
        color: GetColor.primaryGreen,
        child: ListView(
          children: [
            buildHeader(
                name: name,
                email: email,
                onClicked: () {
                  Navigator.pushNamed(context, '/screens/profil');
                }),
            Container(
              padding: padding,
              child: Column(
                children: [
                  Divider(color: Colors.white70),
                  const SizedBox(height: 30),
                  buildMenuItem(
                    text: 'Profile',
                    icon: Icons.person,
                    onClicked: () {
                      Navigator.pushNamed(context, '/screens/profil');
                    },
                  ),
                  const SizedBox(height: 16),
                  /*buildMenuItem(
                    text: 'About',
                    icon: Icons.workspaces_outline,
                    onClicked: () {},
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Help',
                    icon: Icons.help_outline,
                    onClicked: () {},
                  ),*/
                  const SizedBox(height: 24),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.logout_outlined,
                    onClicked: () async{
                      logout();
                      Navigator.pushNamed(context, '/screens/login');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildHeader({
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40,horizontal: 20.0),
          child: Row(
            children: [
              Icon(Icons.person, size: 60.0,color: GetColor.white1),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: GetColor.white1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: GetColor.white1),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

}
