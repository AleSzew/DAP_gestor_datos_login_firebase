import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../entities/player.dart';

class PlayerNotifier extends StateNotifier<List<Player>> {
  PlayerNotifier() : super([]) {
    getAllPlayers();
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Trae los jugadores de Firestore filtrando los que no estén 'disabled'
  Future<void> getAllPlayers() async {
    try {
      final docs = db.collection('players').withConverter(
            fromFirestore: Player.fromFirestore,
            toFirestore: (Player player, _) => player.toFirestore(),
          );

      final snapshot = await docs.get();

      // FILTRO: Solo dejamos los que NO sean 'disabled'
      state = snapshot.docs
          .map((doc) => doc.data())
          .where((player) => player.status != 'disabled')
          .toList();
    } catch (e) {
      print("Error al traer jugadores de Firestore: $e");
    }
  }

  void addPlayer(Player player) {
    state = [...state, player];
  }

  void updatePlayer(Player oldPlayer, Player newPlayer) {
    state = state.map((p) => p == oldPlayer ? newPlayer : p).toList();
  }

  // Al borrar, actualiza Firestore a 'disabled' y lo saca de la pantalla
    Future<void> deletePlayer(Player player) async {
    try {
      await db.collection('players').doc(player.id).update({
        'status': 'disabled',
        'status ': FieldValue.delete(), // Borra automáticamente el que tenía espacio si existía
      });

      state = state.where((p) => p.id != player.id).toList();
    } catch (e) {
      print("Error al deshabilitar en Firestore: $e");
    }
  }
}

final playerProvider =
    StateNotifierProvider<PlayerNotifier, List<Player>>((ref) {
  return PlayerNotifier();
});