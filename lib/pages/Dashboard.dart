import 'package:climbAppFlutter/pages/Account.dart';
import 'package:climbAppFlutter/pages/Scanner.dart';
import 'package:climbAppFlutter/pages/Wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final DocumentSnapshot user;

  int currentIndex = 0;

  Dashboard({Key key, @required this.user}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  onTapped(int) {
    setState(() {
      widget.currentIndex = int;
    });
  }

  void handleCameraCancel() {
    setState(() {
      widget.currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user.data;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: [
        Wallet(user: user),
        Account(user: user),
        Scanner(
          user: user,
          changeScreen: onTapped,
        )
      ][widget.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey,
        onTap: onTapped,
        currentIndex: widget.currentIndex,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            title: Text('Wallet'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Account'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt), title: Text('Add Pass'))
        ],
      ),
    );
  }
}

class BodyWidget extends StatelessWidget {
  final String name;

  BodyWidget(this.name);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('hello $name from dashboard'),
    );
  }
}
