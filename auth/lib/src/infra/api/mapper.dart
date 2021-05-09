import 'package:auth/src/domain/credential.dart';

class Mapper {
  static Map<String, dynamic> toJson(Credential credential) => {
        "authType": credential.type.toString().split('.').last,
        "name": credential.name,
        "email": credential.email,
        "password": credential.password
      };
}
