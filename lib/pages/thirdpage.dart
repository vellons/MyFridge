import 'package:flutter/material.dart';

Widget thirdPage() {
  // TODO: use StatefulWidget

  return Container(
    child: Center( 
      child:
      Padding(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: Text("Ricette",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        )
      ),
    )
  );
}
