import 'package:ramadancompanionapp/tools/typedefs.dart';

class AppUser {
  final String uid;
  final String email;
  final String name;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
  });

  // convert AppUser to Map json
  JsonMap toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }

  // convert Map json to AppUser
  factory AppUser.fromJson(JsonMap jsonUser) {
    return AppUser(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      name: jsonUser['name'],
    );
  }
}
