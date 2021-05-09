import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:restaurant/src/api/restaurant_api.dart';
import 'package:restaurant/src/domain/restaurant.dart';
import 'package:common/common.dart';

class HttpClient extends Mock implements IHttpClient {}

void main() {
  RestaurantApi sut;
  HttpClient client;

  setUp(() {
    client = HttpClient();
    sut = RestaurantApi('baseUrl', client);
  });

  group('getAllRstaurants', () {
    test('returns an empty list when no restaurants are found', () async {
      when(client.get(any)).thenAnswer((_) async => HttpResult(
          jsonEncode({
            "metadata": {"page": 1, "limit": 2},
            "restaurants": []
          }),
          Status.success));
      final page = await sut.getAllRestaurants(page: 1, pageSize: 2);

      expect(page.restaurants, []);
    });
    test('returns list of restaurants when success', () async {
      when(client.get(any)).thenAnswer((_) async =>
          HttpResult(jsonEncode(_restaurantsJson()), Status.success));
      final page = await sut.getAllRestaurants(page: 1, pageSize: 2);

      expect(page.restaurants.length, 2);
    });
  });

  group('getRestaurant', () {
    test('returns null when restaurant is not found', () async {
      when(client.get(any)).thenAnswer((_) async =>
          http.Response(jsonEncode({'error': 'restaurant not found'}), 404));
      final result = await sut.getRestaurant(id: '1234567');
      expect(result, null);
    });
    test('returns restaurant when success', () async {
      when(client.get(any)).thenAnswer((_) async =>
          HttpResult(jsonEncode(_restaurantsJson()[0]), Status.success));
      final result = await sut.getRestaurant(id: '12345');
      expect(result, isNotNull);
      expect(result.id, '12345');
    });
  });

  group('getRestaurantsByLocation', () {
    test('returns an empty list when no restaurants are found', () async {
      when(client.get(any)).thenAnswer((_) async => HttpResult(
          jsonEncode({
            "metadata": {"page": 1, "limit": 2},
            "restaurants": []
          }),
          Status.success));
      final page = await sut.getRestaurantsByLocation(
          page: 1,
          pageSize: 2,
          location: Location(longitude: 1233, latitude: 545454));

      expect(page.restaurants, []);
    });
    test('returns list of restaurants when success', () async {
      when(client.get(any)).thenAnswer((_) async =>
          HttpResult(jsonEncode(_restaurantsJson()), Status.success));
      final page = await sut.getRestaurantsByLocation(
          page: 1,
          pageSize: 2,
          location: Location(longitude: 345.33, latitude: 345.23));

      expect(page.restaurants.length, 2);
    });
  });
}

_restaurantsJson() {
  return {
    "metadata": {"page": 1, "totalPages": 2},
    "restaurants": [
      {
        "id": "12345",
        "name": "Restuarant Name",
        "type": "Fast Food",
        "image_url": "restaurant.jpg",
        "location": {"longitude": 345.33, "latitude": 345.23},
        "address": {
          "street": "Road 1",
          "city": "City",
          "parish": "Parish",
          "zone": "Zone"
        }
      },
      {
        "id": "12666",
        "name": "Restuarant Name",
        "type": "Fast Food",
        "imageUrl": "restaurant.jpg",
        "location": {"longitude": 345.33, "latitude": 345.23},
        "address": {
          "street": "Road 1",
          "city": "City",
          "parish": "Parish",
          "zone": "Zone"
        }
      }
    ]
  };
}

_restaurantMenuJson() {
  return [
    {
      "id": "12345",
      "name": "Lunch",
      "description": "a fun menu",
      "image_url": "menu.jpg",
      "items": [
        {
          "name": "nuff food",
          "description": "awasome!!",
          "image_urls": ["url1", "url2"],
          "unit_price": 12.99
        },
        {
          "name": "nuff food",
          "description": "awasome!!",
          "image_urls": ["url1", "url2"],
          "unit_price": 12.99
        }
      ]
    }
  ];
}
