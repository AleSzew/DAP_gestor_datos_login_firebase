import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String id; 
  String name;
  String description;
  String image;

  Player({
    required this.id, 
    required this.name,
    required this.description,
    required this.image,
  });

  // Convierte un objeto Player a un Map para Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'id': id, // Guarda el id como atributo adentro del documento
      'name': name,
      'description': description,
      'image': image,
    };
  }

  // Convierte el documento de Firebase al objeto Player
  factory Player.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Player(
      // Si en los campos de Firebase pusiste 'id', usa ese; si no, usa el ID propio del documento (snapshot.id)
      id: data?['id'] ?? snapshot.id, 
      name: data?['name'] ?? '',
      description: data?['description'] ?? '',
      image: data?['image'] ?? '',
    );
  }
}