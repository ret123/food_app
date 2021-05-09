import 'package:auth/src/domain/auth_service_contract.dart';
import 'package:auth/src/infra/adapters/email_auth.dart';
import 'package:auth/src/infra/adapters/google_auth.dart';
import 'package:auth/src/infra/api/auth_api_contract.dart';
import 'package:flutter/foundation.dart';

class AuthManager {
  IAuthApi _api;

  AuthManager(this._api);

  IAuthService get google => GoogleAuth(_api);
  IAuthService email({@required String email, @required String password}) {
    final emailAuth = EmailAuth(_api);
    emailAuth.credential(email: email, password: password);
    return emailAuth;
  }
}
