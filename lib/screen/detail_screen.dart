import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../entities/player.dart';
import '../provider/player_provider.dart';

class DetailScreen extends ConsumerWidget {
  final Player player;
  
  const DetailScreen({
    super.key,
    required this.player,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(player.name),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                player.image,
                width: 150,
              ),
              const SizedBox(height: 20),
              Text(
                player.name,
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 20),
              Text(player.description),
              const SizedBox(height: 20),
              
              // Botón Editar (Lleva los datos cargados)
              ElevatedButton(
                onPressed: () {
                  context.push('/new_edit_players', extra: player);
                },
                child: const Text("Editar"),
              ),
              
              const SizedBox(height: 10),
              
              // Botón Eliminar 
              ElevatedButton(
                onPressed: () {
                  // Traemos la lista del provider
                  List<Player> listaActual = ref.read(playerProvider);
                  // Creamos una copia modificable
                  List<Player> listaNueva = List.from(listaActual);
                  //  Sacamos al jugador de la lista
                  listaNueva.remove(player);
                  //  Guardamos los cambios en el provider usando el .state
                  ref.read(playerProvider.notifier).deletePlayer(player);

                  context.pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
                child: const Text("Eliminar")),
            ],
          ),
        ),
      ),
    );
  }
}