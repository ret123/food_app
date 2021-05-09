import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/domain/token.dart';
import 'package:auth/src/infra/api/auth_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  http.Client client;
  AuthApi sut;
  String baseUrl = 'http://localhost:3000';
  setUp(() {
    client = http.Client();
    sut = AuthApi(baseUrl, client);
  });

  var credential = Credential(
      type: AuthType.email, email: 'ret@demo.com', password: 'fedora11');

  group('signin', () {
    test('should return json web token when successful', () async {
      var result = await sut.signIn(credential);
      expect(result.asValue.value, isNotEmpty);
    });
  });

  group('signout', () {
    test('should signout user and return true', () async {
      var res = await sut.signIn(credential);
      var token = Token(res.asValue.value);
      var result = await sut.signOut(token);
      expect(result.asValue.value, true);
    });
  });
}
