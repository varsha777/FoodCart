import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodcart/models/MenuModel.dart';

class MenuListAPI {
  static const String BREAK_FAST = "1";
  static const String LUNCH = "2";
  static const String SNACKS = "3";
  static const String DINNER = "4";

  Future<List<MenuItemModel>> getMenuItemsList(String type) {
    List<MenuItemModel> _menuItemList = List();
    Firestore.instance
        .collection("MenuItems")
        .where("type", isEqualTo: type)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
          print("-----${snapshot.documents.length}");
      if (snapshot.documents.length > 0) {
        List<DocumentSnapshot> list = snapshot.documents;
        for (int i = 0; i < list.length; i++) {
          DocumentSnapshot document = list[i];
          _menuItemList.add(MenuItemModel.fromJson(document.data));
        }
      }
      return _menuItemList;
    });
  }
}
