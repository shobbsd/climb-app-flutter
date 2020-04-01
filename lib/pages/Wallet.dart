import 'package:flutter/material.dart';

class Wallet extends StatefulWidget {
  final Map<String, dynamic> user;

  Wallet({@required this.user, Key key}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    String firstName = widget.user['firstName'];

    return Container(
      color: Colors.red,
      child: Column(
        children: [
          Text(
            'Hey $firstName select the pass you would like to use',
            textScaleFactor: 2,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }
}
