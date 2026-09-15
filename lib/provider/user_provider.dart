import 'package:dap_gester_datos_login/entities/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final StateProvider<List<User>> userProvider = StateProvider<List<User>>((ref) => [

  User(
      name: "ale",
      email: "ale@gmail.com",
      password: "szew",
    ),

  User(
      name: "alejandro",
      email: "ale.szew@gmail.com",
      password: "alejandro",
    ),
  
]);