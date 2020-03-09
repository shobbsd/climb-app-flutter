import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final DocumentSnapshot user;
  final List<Widget> pages = [];

  Dashboard({Key key, @required this.user}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    String firstName = widget.user.data['firstName'];
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Container(
        child: Text('hello $firstName from Dashboard'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('hello')),
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on), title: Text('holla'))
        ],
      ),
    );
  }
}
