import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Dashboard.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {
    'firstName': '',
    'lastName': '',
    'email': '',
    'password': '',
    'passwordRepeat': ''
  };

  final focusLastName = FocusNode();
  final focusEmail = FocusNode();
  final focusPassword = FocusNode();
  final focusRepeatPassword = FocusNode();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _store = Firestore.instance;

  Future<String> _handleSignUp(String email, String password) async {
    // print(password);
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    return user.uid;
  }

  _handleCreateUser(String userUid) async {
    final userData = {
      'firstName': formData['firstName'],
      'lastName': formData['lastName'],
      'email': formData['email']
    };
    try {
      await _store.collection('users').document(userUid).setData(userData);
      final userProfile =
          await _store.collection('users').document(userUid).get();
      return userProfile;
    } catch (err) {
      print(err);
    }
  }

  handleSubmit([str]) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _formKey.currentState.reset();
      String email = formData['email'].trim();
      String password = formData['password'];
      try {
        final userUid = await _handleSignUp(email, password);
        final userProfile = await _handleCreateUser(userUid);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Dashboard(user: userProfile)),
        );
      } catch (Err) {
        print(Err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "First Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person)),
                validator: (value) {
                  if (value.length < 5) {
                    return "Name is not long enough.";
                  }
                  return null;
                },
                onSaved: (val) {
                  formData['firstName'] = val;
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focusLastName);
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                focusNode: focusLastName,
                decoration: InputDecoration(
                    labelText: "Last Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person)),
                validator: (value) {
                  if (value.length < 2) {
                    return "Name is not long enough.";
                  }
                  return null;
                },
                onSaved: (val) {
                  formData['lastName'] = val;
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focusEmail);
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                focusNode: focusEmail,
                decoration: InputDecoration(
                    labelText: "Email Address",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email)),
                validator: (value) {
                  if (!value.contains('@')) return "must be a valid email";
                  return null;
                },
                onSaved: (val) {
                  formData['email'] = val;
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focusPassword);
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                focusNode: focusPassword,
                decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock)),
                obscureText: true,
                validator: (value) {
                  if (value.length < 8) {
                    return "Password is not long enough.";
                  }
                  return null;
                },
                onChanged: (val) {
                  formData['password'] = val;
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focusRepeatPassword);
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                focusNode: focusRepeatPassword,
                decoration: InputDecoration(
                    labelText: "Repeat Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock)),
                obscureText: true,
                validator: (value) {
                  if (value != formData['password']) {
                    return "Passwords must match.";
                  }
                  return null;
                },
                onSaved: (val) {
                  formData['passwordRepeat'] = val;
                },
                onFieldSubmitted: handleSubmit,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  RaisedButton(
                    onPressed: handleSubmit,
                    child: Text('Submit'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
