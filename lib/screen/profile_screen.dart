import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/user.dart';
import '../provider/user_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController imageController;
  late TextEditingController newPasswordController;

  bool _cargandoImagen = false;
  bool _inicializado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cargamos los datos del usuario actual una sola vez al inicio
    if (!_inicializado) {
      final user = ref.read(currentUserProvider) ?? ref.read(userProvider).first;
      nameController = TextEditingController(text: user.name);
      ageController = TextEditingController(text: user.age?.toString() ?? '');
      imageController = TextEditingController(text: user.image ?? '');
      newPasswordController = TextEditingController();
      _inicializado = true;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    imageController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  // Función que abre la cámara o la galería y sube la foto a Supabase
  Future<void> _seleccionarYSubirFoto(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();

      // 1. Abre cámara o galería
      final XFile? imagen = await picker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 85,
      );

      // Si el usuario canceló
      if (imagen == null) return;

      setState(() {
        _cargandoImagen = true;
      });

      // 2. Lee los datos de la imagen y genera un nombre único
      final bytes = await imagen.readAsBytes();
      final extension = imagen.name.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';

      // 3. Sube la foto al bucket 'avatars' de Supabase
      await Supabase.instance.client.storage
          .from('avatars')
          .uploadBinary(fileName, bytes);

      // 4. Obtiene el enlace público de internet
      final String publicUrl = Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl(fileName);

      // 5. Actualiza la pantalla y el campo de texto con la nueva URL
      setState(() {
        imageController.text = publicUrl;
        _cargandoImagen = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Foto subida! Toca "Guardar Cambios" para confirmar.')),
        );
      }
    } catch (e) {
      setState(() {
        _cargandoImagen = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir la imagen: $e')),
        );
      }
    }
  }

  // Muestra el menú inferior con las 2 opciones: Cámara o Galería
  void _mostrarOpcionesDeFoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Colors.blue),
                title: const Text('Tomar foto con la cámara'),
                onTap: () {
                  context.pop();
                  _seleccionarYSubirFoto(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text('Elegir foto de la galería'),
                onTap: () {
                  context.pop();
                  _seleccionarYSubirFoto(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider) ?? ref.watch(userProvider).first;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // FOTO DE PERFIL CON BOTÓN DE CÁMARA
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 110,
                        height: 110,
                        child: _cargandoImagen
                            ? const Center(child: CircularProgressIndicator())
                            : Image.network(
                                imageController.text.isNotEmpty
                                    ? imageController.text
                                    : (user.image ?? ''),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.person, size: 60, color: Colors.grey),
                                  );
                                },
                              ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _cargandoImagen ? null : _mostrarOpcionesDeFoto,
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: _cargandoImagen ? null : _mostrarOpcionesDeFoto,
                icon: const Icon(Icons.edit),
                label: const Text('Cambiar foto'),
              ),

              const SizedBox(height: 15),

              // Email: Bloqueado
              TextField(
                controller: TextEditingController(text: user.email),
                enabled: false,
                decoration: const InputDecoration(labelText: 'Email (no editable)'),
              ),

              // Nombre
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),

              // Edad
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Edad'),
              ),

              // URL de la imagen (se completa sola al elegir la foto)
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'URL de Imagen'),
              ),

              // Contraseña
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nueva Contraseña (dejar vacío si no cambiás)',
                ),
              ),

              const SizedBox(height: 20),

              // Botón Guardar Cambios
              ElevatedButton(
                onPressed: () {
                  user.name = nameController.text;
                  user.age = int.tryParse(ageController.text);
                  user.image = imageController.text;

                  if (newPasswordController.text.isNotEmpty) {
                    user.password = newPasswordController.text;
                  }

                  ref.read(currentUserProvider.notifier).state = user;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Datos guardados correctamente')),
                  );
                },
                child: const Text('Guardar Cambios'),
              ),

              const SizedBox(height: 10),

              // Botón Cerrar Sesión
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