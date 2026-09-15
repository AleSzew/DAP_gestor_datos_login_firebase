import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Importar Riverpod
import '/entities/user.dart';
import '../provider/user_provider.dart'; // 2. Importar tu provider (ajusta la ruta según tus carpetas)

// 3. Cambiar StatefulWidget por ConsumerStatefulWidget
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  // 4. Cambiar State por ConsumerState
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

// 5. Cambiar State por ConsumerState
class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: SizedBox(
          width: 900,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  hintText: "Email",
                ),
              ),
              SizedBox(height: 20, width: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Contraseña",
                ),
              ),
              SizedBox(height: 20, width: 10),
              ElevatedButton(
                onPressed: () {
                  // Leer la lista actualizada de usuarios usando ref.read()
                  final List<User> currentUsers = ref.read(userProvider);
                  
                  bool correcto = false;

                  // Iterar sobre la lista obtenida del provider
                  for (User i in currentUsers) {
                    if (i.email == emailController.text &&
                        i.password == passwordController.text) {
                      correcto = true;
                      break; 
                    }
                  }

                  if (correcto) {
                    context.go('/players');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Datos incorrectos"),
                      ),
                    );
                  }
                },
                child: Text("Ingresar"),
              ),
              ElevatedButton(
                onPressed: () {
                  context.go('/new_user');
                },
                child: Text("Registrarse"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Traemos la lista del provider
                  List<User> listaActual = ref.read(userProvider);
                  // Creamos una copia modificable
                  List<User> listaNueva = List.from(listaActual);
                  //  Sacamos al jugador de la lista
                  listaNueva.remove(User);
                  //  Guardamos los cambios en el provider usando el .state
                  ref.read(userProvider.notifier).state = listaNueva;
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
                child: Text("Cerrar sesion"),    
              )
            ],
          ),
        ),
      ),
    );
  }
}