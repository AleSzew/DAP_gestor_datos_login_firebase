import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String id; 
  String name;
  String description;
  String image;
  String status; // <-- 1. Nuevo campo de estado

  Player({
    required this.id, 
    required this.name,
    required this.description,
    required this.image,
    this.status = 'active', // 2. Por defecto activo
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'status': status, // <-- 3. Lo guardamos en Firestore
    };
  }

  factory Player.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Player(
      id: data?['id'] ?? snapshot.id, 
      name: data?['name'] ?? '',
      description: data?['description'] ?? '',
      image: data?['image'] ?? '',
      // Si tiene 'status' o 'status ' con espacio, lo lee igual
      status: data?['status'] ?? data?['status '] ?? 'enabled',
    );
  }
  }
