import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../entities/player.dart';
import '../provider/player_provider.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Player> players = ref.watch(playerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Jugadores"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Llamada manual al método del notifier como explicó el profe
              ref.read(playerProvider.notifier).getAllPlayers();
            },
          ),
        ],
      ),
      body: players.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      return SizedBox(
                        height: 100,
                        child: Card(
                          child: ListTile(
                            leading: SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.network(
                                player.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.person),
                              ),
                            ),
                            title: Text(player.name),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              context.push(
                                '/detail',
                                extra: player,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/new_edit_players');
                    },
                    child: const Text("Agregar"),
                  ),
                )
              ],
            ),
    );
  }
}