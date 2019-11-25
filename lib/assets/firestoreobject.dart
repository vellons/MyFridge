// firestoreobject.dart - File to create Class for better access to the data

class Products {
  String name;
  String pic;
  String producer;
  double price;
}

class Lots {
  String idProduct;
  String expiry; // TODO: use datatime
}

class Receipts {
  String idUser;
  String timestamp; // TODO: use datatime
  Map<String, int> shop = {}; // LotId, quantity bought
  Map<String, int> used = {}; // LotId, quantity used
}

class ProductsInFridge {
  String idProduct;
  String expiry; // TODO: use datatime
  int quantity;
}