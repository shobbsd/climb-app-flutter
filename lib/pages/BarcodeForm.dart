import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarcodeForm extends StatefulWidget {
  final String barcodeStr;
  final Firestore firestore = Firestore.instance;
  final Map user;

  @override
  _BarcodeFormState createState() => _BarcodeFormState();

  BarcodeForm(this.barcodeStr, this.user);
}

class _BarcodeFormState extends State<BarcodeForm> {
  final List<String> formValues = ['barcode', 'nickname', 'city'];
  final List<IconData> icons = [
    Icons.payment,
    Icons.label,
    Icons.location_city
  ];
  final List<FocusNode> nodes = [];

  @override
  void initState() {
    // TODO: implement initState
    for (String val in formValues) {
      nodes.add(FocusNode(debugLabel: val));
    }
    print(widget.user);
    super.initState();
  }

  Future handleSave(Map cardVals, BuildContext context) async {
    if (cardVals.length == 3) {
      try {
        await widget.firestore
            .collection('users')
            .document(widget.user['uid'])
            .collection('cards')
            .add(cardVals);
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
    } else {
      print('here');

      final SnackBar snackbar = SnackBar(
        content: Text('missing properties'),
      );
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String barcodeStr = widget.barcodeStr;
    final Map<String, String> cardVals = {"barcode": barcodeStr};

    return Scaffold(
      appBar: AppBar(
        title: Text('Save your code'),
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(15),
          itemCount: formValues.length,
          itemBuilder: (BuildContext context, int index) {
            final bool isBarcode = index == 0;
            final bool isEnd = index == formValues.length - 1;

            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                textInputAction:
                    isEnd ? TextInputAction.done : TextInputAction.next,
                readOnly: isBarcode,
                onChanged: (v) {
                  final String key = formValues[index];
                  cardVals[key] = v;
                },
                initialValue: isBarcode ? barcodeStr : "",
                decoration: InputDecoration(
                  prefixIcon: Icon(icons[index]),
                  labelText: formValues[index],
                  border: OutlineInputBorder(),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          handleSave(cardVals, context);
        },
      ),
    );
  }
}
