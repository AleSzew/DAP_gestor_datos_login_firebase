import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../entities/user.dart';
import '../provider/user_provider.dart';

class NewUserScreen extends ConsumerStatefulWidget {

  const NewUserScreen({super.key});

  @override
  ConsumerState<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends ConsumerState<NewUserScreen> {
 
   TextEditingController nameController = TextEditingController();
   TextEditingController emailController = TextEditingController();
   TextEditingController passwordController = TextEditingController();
   TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress, // Muestra el teclado con el "@" en celulares
            ),
            
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirmar Contraseña'),
            ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {

                if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Por favor, completa todos los campos.'),
                      ),
                    );
                  return; 
                }

                
                if (!emailController.text.contains('@')) { //si el mail no tiene arroba
                 ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Por favor, ingresa un @ en el mail.'),
                      ),
                    );
                  return;
                }

              
                if (passwordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Las contraseñas no coinciden'),
                      ),
                    );
                  return;
                }                
                final newUser = User(
                  name: nameController.text, 
                  email: emailController.text,
                  password: passwordController.text,
                );

                ref.read(userProvider.notifier).update((state) {
                  List<User> updatedList = List.from(state);
                  updatedList.add(newUser);
                  return updatedList;
                });
                
                // Volvemos al login después de registrar
                context.go('/login'); 
              },
              child: const Text('Guardar'),
            )
          ],
        ),
      ),
    );
  }
}