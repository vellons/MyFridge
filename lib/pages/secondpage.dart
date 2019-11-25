import 'package:flutter/material.dart';
import '../assets/firestoredata.dart' as FirestoreData;

class SecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SecondPage();
  }
}

class _SecondPage extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Text("Prossime scadenze",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            )
          ),
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: FirestoreData.myFridgeExpiryListWidget
          ),
        ],
      )  
    );
  }
}
