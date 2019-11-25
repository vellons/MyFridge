import 'package:flutter/material.dart';
import '../assets/firestoredata.dart' as FirestoreData;

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FirstPage();
  }
}

class _FirstPage extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Text("La tua dispensa",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            )
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              children: FirestoreData.myFridgeListWidget
            ),
          )
          
        ],
      )  
    );
  }
}

