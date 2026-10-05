import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../provider/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtenemos el usuario conectado (o el primero de prueba si entra directo)
    final user = ref.watch(currentUserProvider) ?? ref.watch(userProvider).first;

    // Controladores con los datos actuales
    final nameController = TextEditingController(text: user.name);
    final ageController = TextEditingController(text: user.age?.toString() ?? '');
    final imageController = TextEditingController(text: user.image ?? '');
    final newPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. Imagen del usuario
                            // Imagen circular protegida contra errores de carga
              ClipOval(
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: Image.network(
                    user.image ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Si la imagen falla (error 0, sin internet, link roto), muestra el ícono
                      return const Icon(Icons.person, size: 50);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Email: BLOQUEADO (el mail no se edita)
              TextField(
                controller: TextEditingController(text: user.email),
                enabled: false,
                decoration: const InputDecoration(labelText: 'Email (no editable)'),
              ),

              // Nombre: editable
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),

              // Edad: editable
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Edad'),
              ),

              // URL Imagen: editable
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'URL de Imagen'),
              ),

              // Contraseña: no se muestra nunca (obscureText: true)
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nueva Contraseña (dejar vacío si no cambiás)',
                ),
              ),

              const SizedBox(height: 20),

              // FUNCIÓN 1 y 3: Guardar cambios de datos y cambiar contraseña
              ElevatedButton(
                onPressed: () {
                  user.name = nameController.text;
                  user.age = int.tryParse(ageController.text);
                  user.image = imageController.text;

                  // Si escribió una contraseña nueva, la actualiza (nunca se mostró)
                  if (newPasswordController.text.isNotEmpty) {
                    user.password = newPasswordController.text;
                  }

                  // Notifica al provider
                  ref.read(currentUserProvider.notifier).state = user;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Datos guardados')),
                  );
                },
                child: const Text('Guardar Cambios'),
              ),

              const SizedBox(height: 10),

              // FUNCIÓN 2: Cerrar sesión
              ElevatedButton(
                onPressed: () {
                  ref.read(currentUserProvider.notifier).state = null;
                  context.go('/login');
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
                child: const Text('Cerrar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}