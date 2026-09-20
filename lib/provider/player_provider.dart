import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../entities/player.dart';

// Definimos el Notifier propio que maneja el estado y las operaciones asincrónicas
class PlayerNotifier extends StateNotifier<List<Player>> {
  PlayerNotifier() : super([]) {
    // Al instanciarse, va a buscar automáticamente los jugadores a Firebase
    getAllPlayers();
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Función asíncrona (Future) para traer los documentos desde Firestore
  Future<void> getAllPlayers() async {
    try {
      final docs = db.collection('players').withConverter(
            fromFirestore: Player.fromFirestore,
            toFirestore: (Player player, _) => player.toFirestore(),
          );

      // Traemos todos los documentos de la colección
      final snapshot = await docs.get();

      // Mapeamos los datos a una lista de jugadores y actualizamos el state
      state = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error al traer jugadores de Firestore: $e");
    }
  }

  // Métodos auxiliares para agregar, editar o eliminar localmente
  void addPlayer(Player player) {
    state = [...state, player];
  }

  void updatePlayer(Player oldPlayer, Player newPlayer) {
    state = state.map((p) => p == oldPlayer ? newPlayer : p).toList();
  }

  void deletePlayer(Player player) {
    state = state.where((p) => p != player).toList();
  }
}

// Declaramos el StateNotifierProvider
final playerProvider =
    StateNotifierProvider<PlayerNotifier, List<Player>>((ref) {
  return PlayerNotifier();
});