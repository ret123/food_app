import 'package:faker/faker.dart' as fk;
import 'package:restaurant/restaurant.dart';

class FakeRestaurantApi implements IRestaurantApi {
  List<Restaurant> _restaurants;
  FakeRestaurantApi(int numberOfRestaurants) {
    final faker = fk.Faker();
    _restaurants = List.generate(
        numberOfRestaurants,
        (index) => Restaurant(
            id: index.toString(),
            name: faker.company.name(),
            type: faker.food.cuisine(),
            displayImgUrl: faker.internet.httpUrl(),
            address: Address(
              street: faker.address.streetName(),
              city: faker.address.city(),
              parish: faker.address.country(),
            ),
            location: Location(
                latitude: faker.randomGenerator.integer(5).toDouble(),
                longitude: faker.randomGenerator.integer(5).toDouble())));
  }
  @override
  Future<Page> findRestaurants({int page, int pageSize, String searchTerm}) {
    // TODO: implement findRestaurants
    throw UnimplementedError();
  }

  @override
  Future<Page> getAllRestaurants({int page, int pageSize}) async {
    return _paginatedRestaurants(page, pageSize);
  }

  @override
  Future<Restaurant> getRestaurant({String id}) {}

  @override
  Future<List<Menu>> getRestaurantMenu({String restaurantId}) {
    // TODO: implement getRestaurantMenu
    throw UnimplementedError();
  }

  @override
  Future<Page> getRestaurantsByLocation(
      {int page, int pageSize, Location location}) {
    // TODO: implement getRestaurantsByLocation
    throw UnimplementedError();
  }

  Page _paginatedRestaurants(int page, int pageSize,
      {Function(Restaurant) filter}) {
    final int offset = (page - 1) * pageSize;
    final restaurants = filter == null
        ? this._restaurants
        : this._restaurants.where(filter).toList();
    final totalPages = (restaurants.length / pageSize).ceil();

    final result = restaurants.skip(offset).take(pageSize).toList();

    return Page(currentPage: page, totalPages: totalPages, restaurants: result);
  }
}
