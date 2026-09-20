import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../entities/player.dart';
import '../provider/player_provider.dart';

class NewEditPlayerScreen extends ConsumerWidget {
  // Recibimos el jugador. Puede ser null (si venimos del botón agregar)
  final Player? player;

  const NewEditPlayerScreen({super.key, this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  // Si player existe, saca el valor; si es null, usa ''
  final TextEditingController nameController = TextEditingController(
    text: player?.name ?? '',
  );
  final TextEditingController descController = TextEditingController(
    text: player?.description ?? '',
  );
  final TextEditingController imageController = TextEditingController(
    text: player?.image ?? '',
  );

    return Scaffold(
      appBar: AppBar(
        // Cambiamos el título dependiendo de si es null o no
        title: Text(player == null ? 'Nuevo Jugador' : 'Editar Jugador'),
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
              controller: descController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: 'URL de la Imagen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Creamos el objeto con lo que haya en los campos de texto
               final newPlayer = Player(
               id: player?.id ?? DateTime.now().millisecondsSinceEpoch.toString(), // Si es nuevo, le genera un id único
                name: nameController.text,
              description: descController.text,
            image: imageController.text,
                );

                
                if (player == null) {
                  ref.read(playerProvider.notifier).addPlayer(newPlayer);
                  context.pop(); // Volvemos a la lista
                } else {
                  // --- ESTAMOS EDITANDO ---
                  ref.read(playerProvider.notifier).updatePlayer(player!, newPlayer);
                  context.go('/players'); // Volvemos directo a la pantalla principal
                }
              },
              // Cambiamos el texto del botón
              child: Text(player == null ? 'Guardar' : 'Actualizar'), //si no hay jugador, es guardar, si hay jugador, es actualizar
            )
          ],
        ),
      ),
    );
  }
}