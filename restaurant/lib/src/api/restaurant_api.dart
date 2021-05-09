import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:restaurant/src/api/api_contract.dart';
import 'package:restaurant/src/api/mapper.dart';
import 'package:restaurant/src/api/page.dart';
import 'package:restaurant/src/domain/menu.dart';
import 'package:restaurant/src/domain/restaurant.dart';
import 'package:http/http.dart';
import 'package:common/common.dart';

class RestaurantApi implements IRestaurantApi {
  final IHttpClient httpClient;
  final String baseUrl;

  RestaurantApi(this.baseUrl, this.httpClient);

  @override
  Future<Page> findRestaurants(
      {@required int page,
      @required int pageSize,
      @required String searchTerm}) async {
    final endpoint = baseUrl +
        '/restuarants/search/page=$page&limit=$pageSize&term=$searchTerm';
    final result = await httpClient.get(endpoint);
    return _parseRestaurantsJson(result);
  }

  @override
  Future<Page> getAllRestaurants(
      {@required int page, @required int pageSize}) async {
    final endpoint = baseUrl + '/restaurants/page=$page&limit=$pageSize';
    final result = await httpClient.get(endpoint);
    return _parseRestaurantsJson(result);
  }

  @override
  Future<Restaurant> getRestaurant({String id}) async {
    final endpoint = baseUrl + '/restaurant/$id';
    final result = await httpClient.get(endpoint);
    if (result.status == Status.failure) return null;
    final json = jsonDecode(result.data);
    return Mapper.fromJson(json);
  }

  @override
  Future<Page> getRestaurantsByLocation(
      {@required int page,
      @required pageSize,
      @required Location location}) async {
    final endpoint = baseUrl +
        '/restaurant/page=$page&limit=$pageSize&longitude=${location.longitude}&latitude=${location.latitude}';
    final result = await httpClient.get(endpoint);
    return _parseRestaurantsJson(result);
  }

  @override
  Future<List<Menu>> getRestaurantMenu({String restaurantId}) async {
    final endpoint = baseUrl + '/restaurant/menu/$restaurantId';
    final result = await httpClient.get(endpoint);
    return _parseRestaurantMenu(result);
  }

  Page _parseRestaurantsJson(HttpResult result) {
    if (result.status == Status.failure) return null;
    final json = jsonDecode(result.data);
    final restaurants =
        json['restaurants'] != null ? _restaurantsFromJson(json) : [];
    return Page(
        currentPage: json['metadata']['page'],
        totalPages: json['metadata']['totalPages'],
        restaurants: restaurants);
  }

  List<Menu> _parseRestaurantMenu(HttpResult result) {
    if (result.status == Status.failure) return [];

    final json = jsonDecode(result.data);
    if (json['menus'] == null) return [];
    final List menus = json['menus'];
    return menus.map((e) => Mapper.menuFromJson(e)).toList();
  }

  List<Restaurant> _restaurantsFromJson(Map<String, dynamic> json) {
    final List restaurants = json['restaurants'];
    return restaurants.map<Restaurant>((ele) => Mapper.fromJson(ele)).toList();
  }
}
