import 'package:flutter/foundation.dart';

class Menu {
  final String id;
  final String name;
  final String description;
  final String displayImgUrl;
  List<MenuItem> items;

  Menu(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.items,
      this.displayImgUrl});
}

class MenuItem {
  String name;
  String description;
  List<String> imageUrls;
  double unitPrice;

  MenuItem(
      {@required this.name,
      @required this.description,
      this.imageUrls,
      @required this.unitPrice});
}
