import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'assets/firestoreio.dart' as FirestoreIO;
import 'assets/firestoredata.dart' as FirestoreData;
import 'pages/firstpage.dart';
import 'pages/secondpage.dart';
import 'pages/thirdpage.dart';


Future main() async {

  try {
    bool retA = await FirestoreIO.getProducts(); // Download products from Firestore and save in FirestoreData
    bool retB = await FirestoreIO.getLots(); // Download lots from Firestore and save in FirestoreData
    bool retC = await FirestoreIO.getMyReceipts(FirestoreData.userLogged); // Download my receipts from Firestore and save in FirestoreData
    bool retD = await FirestoreIO.openMyFridge(); // Use just downloaded data to show what is in my fridge

    if(retA == false || retB == false ||  retC == false || retD == false) runApp(ErrorApp()); // Check if it's all ok

    if(retA == true && retB == true && retC == true && retD == true) {
      // Start application
      runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bottom Navigation',
        home: HOME(),
      ));
    }

  } catch(err) {
    // Catch error and print to debug console
    print("+-----------------------------+ ERROR +-----------------------------+");
    print(err);
    runApp(ErrorApp());
  }
  
}

class HOME extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomNavState();
  }
}

class _BottomNavState extends State<HOME> {
  var _page = 0;
  String _currentQq;
  bool _loading = false;
   
  Future<String> getQrCode() async {
    String _qrString;
    print("Start QR code scanning");
    _qrString = await new QRCodeReader()
        .setAutoFocusIntervalInMs(200)
        .setForceAutoFocus(true)
        .setTorchEnabled(true)
        .setHandlePermissions(true)
        .setExecuteAfterPermissionGranted(true)
        .scan();
    print("QR code find");
    print(_qrString);
    return _qrString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Fridge", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () async {
              // QR code scanning
              _currentQq = await getQrCode(); // await until qr code found
              if(_currentQq != null){
                setState(() {
                  _loading = true;
                });
                await FirestoreIO.metchMyReceipts(_currentQq, FirestoreData.userLogged); // Match QR code with my user id
                
                try {
                  // Download new receipts data
                  bool retC = await FirestoreIO.getMyReceipts(FirestoreData.userLogged); // Download my receipts from Firestore and save in FirestoreData
                  bool retD = await FirestoreIO.openMyFridge(); // Use just downloaded data to show what is in my fridge
                  
                  if(retC == false || retD == false) print("+--------------+ ERROR WHILE DOWNLOADING NEW DATA +--------------+");

                  if(retC == true && retD == true) {
                    setState(() {
                      FirestoreData.myFridgeListWidget = FirestoreData.myFridgeListWidget;
                      _loading = false;
                    });
                  }

                } catch(err) {
                  // Catch error and print to debug console
                  print("+-----------------------------+ ERROR WHILE SHOWING NEW DATA +-----------------------------+");
                }

              }
            },
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        items: <Widget>[
          // Navigation bar icons
          Icon(Icons.list, size: 30),
          Icon(Icons.alarm, size: 30),
          Icon(Icons.kitchen, size: 30),
        ],
        onTap: (index) {
          // Handle button tap
          setState(() {
            _page = index;
          });
        },
        animationDuration: Duration(milliseconds: 215),
        color: Colors.orange,
      ),
      body: Container(
        color: Colors.white,
        child: pageTransaction(),
      ),
    );
  }

  Widget pageTransaction() {
    if (_page == 0) {
      return _loading ? 
      Center(
        child: Text("Loading new data...",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      )
      : FirstPage();
    } else if (_page == 1) {
      return _loading ? 
      Center(
        child: Text("Loading new data...",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      )
      : SecondPage();
    } else if (_page == 2) {
      return thirdPage();
    }
    else return null;
  }
}

class ErrorApp extends StatelessWidget {
  // Application root (if databse is not available)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application error',
      home: Scaffold(
        body: Center(
          child: Text("Ops, Something went wrong :( Look at the debug console.", 
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18)
          ),
        ),
      ),
    );
  }
}

