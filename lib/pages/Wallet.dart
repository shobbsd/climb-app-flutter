import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barcode_flutter/barcode_flutter.dart';

class Wallet extends StatefulWidget {
  final Map<String, dynamic> user;
  final Firestore firestore = Firestore.instance;

  Wallet({@required this.user, Key key}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    final String firstName = widget.user['firstName'];
    final Future cards = widget.firestore
        .collection('users')
        .document(widget.user['uid'])
        .collection('cards')
        .getDocuments();

    return Container(
        color: Colors.red,
        child: FutureBuilder(
          future: cards,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> cards = snapshot.data.documents;
              if (cards.length < 1) {
                return Center(
                  child: Text('No cards yet'),
                );
              }
              return GridView.builder(
                itemCount: cards.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showSameVal(context, cards[index]);
                    },
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          BarCodeImage(
                            params: EAN13BarCodeParams(
                                cards[index].data['barcode'],
                                lineWidth:
                                    1.8, // width for a single black/white bar (default: 2.0)
                                barHeight: 90.0,
                                withText: true),
                          ),
                          SizedBox(height: 10),
                          Text('Name: ' + cards[index].data['nickname']),
                          SizedBox(height: 10),
                          Text('City: ' + cards[index].data['city'])
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
            }
            return Text('data');
          },
        ));
  }
}

Future<String> showSameVal(
    BuildContext context, DocumentSnapshot cardInfo) async {
  Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 300,
        child: Center(
          child: BarCodeImage(
            params: EAN13BarCodeParams(
              cardInfo.data['barcode'],
              lineWidth: 2.2,
              barHeight: 90.0,
              withText: true,
            ),
          ),
        ),
      ));
  print('yu');
  final res = await showDialog(
      context: context,
      builder: (BuildContext context) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: simpleDialog));
  return res;
}
