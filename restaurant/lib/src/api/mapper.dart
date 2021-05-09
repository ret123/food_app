import 'package:restaurant/src/domain/menu.dart';
import 'package:restaurant/src/domain/restaurant.dart';

class Mapper {
  static fromJson(Map<String, dynamic> json) {
    return Restaurant(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        displayImgUrl: json['image_url'] ?? '',
        location: Location(
            latitude: json['location']['latitude'],
            longitude: json['location']['longitude']),
        address: Address(
            city: json['address']['city'],
            street: json['address']['street'],
            parish: json['address']['parish'],
            zone: json['address']['zone'] ?? ''));
  }

  static Menu menuFromJson(Map<String, dynamic> json) {
    return Menu(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        displayImgUrl: json['image_url'],
        items: json['items'] != null
            ? json['items']
                .map<MenuItem>((item) => MenuItem(
                    name: item['name'],
                    imageUrls: item['image_urls'].cast<String>(),
                    description: item['description'],
                    unitPrice: item['unit_price']))
                .toList()
            : []);
  }
}
