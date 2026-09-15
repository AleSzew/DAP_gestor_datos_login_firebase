import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../entities/player.dart'; 

// Agregando 'final' al principio se va el error por completo
final StateProvider<List<Player>> playerProvider = StateProvider<List<Player>>((ref) => [
  Player(
    name: "Lionel Messi",
    description:
        "Nacido en Rosasrio jugó profesionalemnte en el Barcelona(2004-2021), Paris Saint Germain (2021-2023) e Inter de Miamia(2023-presente), ademas de esto es el capitan de la Seleccion Argentina y el mejor jugador de todos los tiempos.",
    image:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKjSMEx8zlf433jxyKEP9DiOBJVXDg-CpvHar3BFrHLEao10Xrti0IJ4EO&s=10.jpg",
  ),
  Player(
    name: "Lautaro Martinez",
    description:
        "Nacido en Bahia Blanca jugo profesionalmente en Racing Club (2015-2018) y el Inter de Milán (2018-presente) club del cual es el 10 y capitán ",
    image:
        "https://assets.goal.com/images/v3/blt909c98575cff6814/GOAL%20-%20Blank%20WEB%20-%20Facebook%20-%202024-07-13T191231.216.jpg?auto=webp&format=pjpg&width=3840&quality=60",
  ),
  Player(
    name: "Lisandro Lopez",
    description:
        "EX jugador de Racing, autor del golazo de chilena a Independiente en 2016",
    image:
        "https://media.ambito.com/p/211a5e74849cb90bc796e70304d351e0/adjuntos/239/imagenes/036/347/0036347985/lisandro-lopez.jpg",
  ),
]);