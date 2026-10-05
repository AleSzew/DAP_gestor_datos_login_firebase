import 'package:dap_gester_datos_login/entities/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final StateProvider<List<User>> userProvider = StateProvider<List<User>>((ref) => [
  User(
    name: "ale",
    email: "ale@gmail.com",
    password: "szew",
    age: 25,
    image: "https://i.pravatar.cc/300?img=12",
  ),
  User(
    name: "alejandro",
    email: "ale.szew@gmail.com",
    password: "alejandro",
    age: 30,
    image: "https://i.pravatar.cc/300?img=68",
  ),
]);

// Guardamos al usuario actual conectado
final currentUserProvider = StateProvider<User?>((ref) => null);