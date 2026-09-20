import 'package:dap_gester_datos_login/screen/detail_screen.dart';
import 'package:dap_gester_datos_login/screen/login_screen.dart';
import 'package:dap_gester_datos_login/screen/new_edit_player_screen.dart';
import 'package:dap_gester_datos_login/screen/new_user_screen.dart';
import 'package:dap_gester_datos_login/screen/player_screen.dart';
import 'package:go_router/go_router.dart';
import '../entities/player.dart';


final appRouter = GoRouter(

  initialLocation: '/players',

  routes: [

    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),

    GoRoute(
      path: '/players',
      builder: (context, state) => PlayerScreen(),
    ),

    GoRoute(
      path: '/detail',
      builder: (context, state)  => DetailScreen(
        player: state.extra as Player,
      ),
    ),
    GoRoute(
      path: '/new_edit_players',
      builder: (context, state) => NewEditPlayerScreen(
        player: state.extra as Player?,
      ),
    ),
     GoRoute(
      path: '/new_user',
      builder: (context, state) => NewUserScreen(),
    ),

  ],

);