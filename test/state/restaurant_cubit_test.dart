import 'package:flutter_test/flutter_test.dart';
import 'package:food_app/state_management/restaurant/restaurant_cubit.dart';
import 'package:food_app/state_management/restaurant/restaurant_state.dart';
import 'package:matcher/matcher.dart' as matcher;

import '../features/fake_restaurant_api.dart';

void main() {
  RestaurantCubit sut;
  FakeRestaurantApi api;

  setUp(() {
    api = FakeRestaurantApi(20);
    sut = RestaurantCubit(api, defaultPageSize: 10);
  });

  tearDown(() {
    sut.close();
  });

  group('getAllRestaurants', () {
    test('returns first page with correct number of restaurants', () async {
      sut.getAllRestaurants(page: 1);
      await expectLater(sut, emits(matcher.TypeMatcher<PageLoaded>()));
      final state = sut.state as PageLoaded;
      expect(state.nextPage, equals(2));
      expect(state.restaurants.length, 10);
    });

    test('returns last page with correct number of restaurants', () async {
      sut.getAllRestaurants(page: 2);
      await expectLater(sut, emits(matcher.TypeMatcher<PageLoaded>()));
      final state = sut.state as PageLoaded;
      expect(state.nextPage, equals(null));
      expect(state.restaurants.length, 10);
    });
  });
}
