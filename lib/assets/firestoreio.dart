// firestoreio.dart - Functions to comunicate with Google Firestore
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestoredata.dart' as FirestoreData;
import 'firestoreobject.dart' as FirestoreObject;
import 'components.dart' as Components;

Future<bool> getProducts() async {
  // Get all products in the database
  print("START getProducts()");
  bool ret = false;
  await Firestore.instance.collection("products").getDocuments().then((docs) {
    if(docs.documents.isNotEmpty) {
      FirestoreData.productsList.clear();
      for(int i = 0; i < docs.documents.length; i++) {
        
        FirestoreObject.Products p = new FirestoreObject.Products();
        p.name = docs.documents[i]["name"];
        p.price = docs.documents[i]["price"].toDouble();
        p.producer = docs.documents[i]["producer"];
        p.pic = docs.documents[i]["pic"];

        FirestoreData.productsList[docs.documents[i].documentID] = p; // Save in FirestoreData
        FirestoreData.productsListWidget.add(new Text(p.name));
      }
      ret = true;
      print("END getProducts() [" + FirestoreData.productsList.length.toString() + "]");
    }
  }).catchError((error) {
    print("+-----------------------------+ Firestore getProducts() error +-----------------------------+");
    print(error);
  });
  return ret;
} // End getProducts()


Future<bool> getLots() async {
  // Get all lots in the database
  print("START getLots()");
  bool ret = false;
  await Firestore.instance.collection("lots").getDocuments().then((docs) {
    if(docs.documents.isNotEmpty) {
      FirestoreData.lotsList.clear();
      for(int i = 0; i < docs.documents.length; i++) {
        
        FirestoreObject.Lots p = new FirestoreObject.Lots();
        p.idProduct = docs.documents[i]["idProducts"];
        p.expiry = docs.documents[i]["expiry"].toDate().toString();

        FirestoreData.lotsList[docs.documents[i].documentID] = p; // Save in FirestoreData
      }
      ret = true;
      print("END getLots() [" + FirestoreData.lotsList.length.toString() + "]");
    }
  }).catchError((error) {
    print("+-----------------------------+ Firestore getLots() error +-----------------------------+");
    print(error);
  });
  return ret;
} // End getProducts()


Future<bool> getMyReceipts(String userId) async {
  // Get all my receipts from the database
  print("START getMyReceipts()");
  bool ret = false;
  await Firestore.instance.collection("receipts").where("userId", isEqualTo: FirestoreData.userLogged).getDocuments().then((docs) {
    if(docs.documents.isNotEmpty) {
      FirestoreData.receiptsList.clear();
      for(int i = 0; i < docs.documents.length; i++) {
        
        // Save all data in Map<String(ID), BusLine>
        FirestoreObject.Receipts p = new FirestoreObject.Receipts();
        p.idUser = docs.documents[i]["userId"];
        p.timestamp = docs.documents[i]["timestamp"].toDate().toString();
        
        Map<dynamic, dynamic> s = docs.documents[i]["shop"];
        s.forEach((id, qty) {
          p.shop[id] = qty; // Save my shop like a Map of LotsId and quantity
        });

        if(docs.documents[i]["used"] == null) {
          s.forEach((id, qty) {
            p.used[id] = 0;
          });
        }
        else {
          Map<dynamic, dynamic> u = docs.documents[i]["used"];
          u.forEach((id, qty) {
            p.used[id] = qty; // Save my shop like a Map of LotsId and quantity
          });
        }

        FirestoreData.receiptsList[docs.documents[i].documentID] = p; // Save in FirestoreData
      }
      ret = true;
      print("END getMyReceipts() [" + FirestoreData.receiptsList.length.toString() + "]");
    }
  }).catchError((error) {
    print("+-----------------------------+ Firestore getMyReceipts() error +-----------------------------+");
    print(error);
  });
  return ret;
} // End getProducts()


Future<bool> openMyFridge() async {
  // Prepare flutter ListView component
  print("START openMyFridge()");
  bool ret = false;
  var now = new DateTime.now();
  FirestoreData.myFridgeList.clear();
  FirestoreData.myFridgeListWidget.clear();

  FirestoreData.myFridgeExpiryList.clear();
  FirestoreData.myFridgeExpiryListWidget.clear();

  await FirestoreData.receiptsList.forEach((id, item) { // Scroll all my receipts
    item.shop.forEach((lotId, qty) { // Scoll all products bought in this receipts
      FirestoreObject.ProductsInFridge p = new FirestoreObject.ProductsInFridge();
      p.idProduct = FirestoreData.lotsList[lotId].idProduct;
      p.expiry = FirestoreData.lotsList[lotId].expiry.toString();
      p.quantity = item.shop[lotId] - item.used[lotId];

      FirestoreData.myFridgeList[p.idProduct.toString() + p.expiry.toString()] = p; // Save in FirestoreData

      String eYear = p.expiry;
      String eMonth = p.expiry;
      eYear = eYear.substring(0,4); // Year
      eMonth = eMonth.substring(5,7); // Month
      if(eYear == now.year.toString() && eMonth == now.month.toString()) {
        // Products that will expire soon
        FirestoreData.myFridgeExpiryList[p.idProduct.toString() + p.expiry.toString()] = p; // Save in FirestoreData
        FirestoreData.myFridgeExpiryListWidget.add(
          Components.MyFridgeElement(picUrl: FirestoreData.productsList[p.idProduct].pic, name: FirestoreData.productsList[p.idProduct].name, expiry: p.expiry, qty: p.quantity)
        );
      }

      FirestoreData.myFridgeListWidget.add(
        Components.MyFridgeElement(picUrl: FirestoreData.productsList[p.idProduct].pic, name: FirestoreData.productsList[p.idProduct].name, expiry: p.expiry, qty: p.quantity)
      );

    });
    ret = true;
  });
  print("END openMyFridge() [" + FirestoreData.myFridgeList.length.toString() + "]");
  return ret;
} // End getProducts()


Future<bool> metchMyReceipts(String receiptsId, String userId) async {
  // Add to receipts my userId
  print("START metchMyReceipts()");
  bool ret = true;

  print("NEW RECEIPTS " + receiptsId + " userId " + userId);

  await Firestore.instance.collection('receipts').document(receiptsId).updateData({
    'userId': userId, 
  }).catchError((error) {
    print("+-----------------------------+ Firestore metchMyReceipts() error +-----------------------------+");
    print(error);
    ret = false;
  });

  print("END metchMyReceipts()");
  return ret;
} // End getProducts()