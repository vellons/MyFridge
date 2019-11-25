// firestoredata.dart - File to store all database data to show inside the app
import 'package:flutter/material.dart';
import 'firestoreobject.dart' as FirestoreObject;

String userLogged = "oDA2YPLyuP7klEc12w1H"; // Current user -> TODO: login

Map<String, FirestoreObject.Products> productsList = {};
List<Widget> productsListWidget = new List();

Map<String, FirestoreObject.Lots> lotsList = {};

Map<String, FirestoreObject.Receipts> receiptsList = {};

Map<String, FirestoreObject.ProductsInFridge> myFridgeExpiryList = {};
List<Widget> myFridgeExpiryListWidget = new List();

Map<String, FirestoreObject.ProductsInFridge> myFridgeList = {};
List<Widget> myFridgeListWidget = new List();