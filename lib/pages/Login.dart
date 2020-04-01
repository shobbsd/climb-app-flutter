import 'package:climbAppFlutter/pages/Dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode passwordNode = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  final Map<String, String> login = {
    "email": "",
    "password": "",
  };

  _handleSubmit([str]) async {
    showSimpleCustomDialog(context);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        final user = (await _auth.signInWithEmailAndPassword(
                email: login['email'], password: login['password']))
            .user;

        final userProfile =
            await _firestore.collection('users').document(user.uid).get();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard(user: userProfile)),
          (Route<dynamic> route) => false,
        );
      } catch (err) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  enableSuggestions: true,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (str) {
                    FocusScope.of(context).requestFocus(passwordNode);
                  },
                  onSaved: (val) {
                    login['email'] = val.trim();
                  },
                  validator: (String val) {
                    if (!val.contains('@')) return "Must be a valid email";
                  },
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  obscureText: true,
                  onSaved: (str) {
                    login['password'] = str;
                  },
                  onFieldSubmitted: _handleSubmit,
                  focusNode: passwordNode,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock)),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  RaisedButton(
                    child: Text('Submit'),
                    onPressed: _handleSubmit,
                  ),
                ],
              )
            ],
          )),
    );
  }
}

void showSimpleCustomDialog(BuildContext context) {
  Dialog simpleDialog = Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: 300.0,
      width: 300.0,
      child: Center(child: CircularProgressIndicator()),
    ),
  );
  showDialog(context: context, builder: (BuildContext context) => simpleDialog);
}
