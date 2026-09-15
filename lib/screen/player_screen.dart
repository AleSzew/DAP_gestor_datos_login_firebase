import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importamos Riverpod
import 'package:go_router/go_router.dart';
import '../entities/player.dart';
import '../provider/player_provider.dart'; // Importamos tu provider


class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key}); 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
    final List<Player> players = ref.watch(playerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Jugadores"),
      ),
      body: Column(
        children: [
          
       
          Expanded(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 100,
                  child: Card(
                    child: ListTile(
                      leading: SizedBox(
                        height: 300, 
                        child: Image.network(
                          players[index].image,        
                        ),
                      ),
                      title: Text(
                        players[index].name,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward,
                      ),
                      onTap: () {
                      
                        context.push(
                          '/detail',
                          extra: players[index],
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