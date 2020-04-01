import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  final Map<String, dynamic> user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');
  int chosenVal;

  Account({Key key, @required this.user}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final Map updates = {};

  void handleFieldSubmit(String v, String key, String val) async {
    if (updates[key] == null && v == val) {
      await showSameVal(context);
    } else if (v == updates[key]) {
      await showSameVal(context);
    } else {
      final String newVal = v.trim();

      // final String oldVal = updates[key] ? updates[key] : val;
      String oldVal = updates[key] == null ? val : updates[key];

      final String result = await showChangeName(context,
          field: key, oldVal: oldVal, newVal: newVal);
      if (result == 'save') {
        updates[key] = newVal;
        final String userUid = (await widget._auth.currentUser()).uid;
        final List<Future> futuresList = [];
        final Future collectionUpdate = widget.usersCollection
            .document(userUid)
            .updateData({"$key": newVal});
        futuresList.add(collectionUpdate);
        if (key == 'email') {
          final Future authUpdate =
              (await widget._auth.currentUser()).updateEmail(newVal);
          futuresList.add(authUpdate);
        }
        Future.wait(futuresList).catchError((e) {
          print(e);
        });
        // widget._store.collection(users)
      }
    }
    setState(() {
      widget.chosenVal = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<List> list = widget.user.entries
        .where((element) => element.key != 'uid')
        .map((element) => [element.key, element.value])
        .toList();

    return Container(
        child: ListView.builder(
      padding: EdgeInsets.all(5),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final String key = list[index][0];
        final String val = list[index][1];

        // print(item[1]);
        print(updates);
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            child: widget.chosenVal == index
                ? TextFormField(
                    keyboardAppearance: Brightness.dark,
                    autofocus: true,
                    initialValue: updates[key] == null ? val : updates[key],
                    // textInputAction: ,
                    onFieldSubmitted: (v) =>
                        this.handleFieldSubmit(v, key, val),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: key,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      if (widget.chosenVal == null) {
                        setState(() {
                          widget.chosenVal = index;
                        });
                      }
                    },
                    child: Container(
                        child: Center(
                            child: updates[key] == null
                                ? Text(
                                    "$key: $val",
                                  )
                                : Text("$key: " + updates[key])),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8.0),
                        ))),
          ),
        );
      },
    ) // Text('hello'),
        );
  }
}

Future<String> showChangeName(BuildContext context,
    {String field, String oldVal, String newVal}) async {
  print(field);
  Dialog simpleDialog = Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: 300.0,
      width: 300.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Text(
                  'You are changing your $field from:',
                  // style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Old: '),
                    Text(oldVal, style: TextStyle(color: Colors.red)),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('New: '),
                    Text(newVal, style: TextStyle(color: Colors.green)),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.of(context).pop('save');
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop('cancel');
                  },
                  child: Text(
                    'Cancel!',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
  final res = await showDialog(
      context: context, builder: (BuildContext context) => simpleDialog);
  return res;
}

Future<String> showSameVal(BuildContext context) async {
  Dialog simpleDialog = Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: 300.0,
      width: 300.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Text(
                  'There was no change',
                  // style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.of(context).pop('no action');
                  },
                  child: Text(
                    'Okay',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  final res = await showDialog(
      context: context, builder: (BuildContext context) => simpleDialog);
  return res;
}
