import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/cache/local_store.dart';
import 'package:food_app/cache/local_store_contract.dart';
import 'package:food_app/state_management/auth/auth_cubit.dart';
import 'package:food_app/ui/pages/auth/auth_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompositionRoot {
  static SharedPreferences _sharedPreferences;
  static ILocalStore _localStore;
  static String _baseUrl;
  static Client _client;

  static configure() {
    _localStore = LocalStore(_sharedPreferences);
    _client = Client();
    _baseUrl = "http://10.0.2.2:3000";
  }

  static Widget composeAuthUi() {
    IAuthApi _api = AuthApi(_baseUrl, _client);
    AuthManager _manager = AuthManager(_api);
    AuthCubit _authCubit = AuthCubit(_localStore);
    ISignUpService _signUpService = SignUpService(_api);

    return BlocProvider(
      create: (BuildContext context) => _authCubit,
      child: AuthPage(_manager, _signUpService),
    );
  }
}
