import 'package:flutter/foundation.dart';
import 'package:restaurant/src/api/page.dart';
import 'package:restaurant/src/domain/menu.dart';
import 'package:restaurant/src/domain/restaurant.dart';

abstract class IRestaurantApi {
  Future<Page> getAllRestaurants({@required int page, @required int pageSize});
  Future<Page> getRestaurantsByLocation({
    @required int page,
    @required int pageSize,
    @required Location location,
  });
  Future<Page> findRestaurants({
    @required int page,
    @required int pageSize,
    @required String searchTerm,
  });
  Future<Restaurant> getRestaurant({@required String id});
  Future<List<Menu>> getRestaurantMenu({@required String restaurantId});
}
