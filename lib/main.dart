import 'package:band_names_rt/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names_rt/pages/home_page.dart';
import 'package:band_names_rt/pages/status.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService() )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Musika Taldeak App',
        initialRoute: 'home',
        routes: {
          'home': ( _ ) => HomePage(),
          'status': ( _ ) => StatusPage(),
        }
      ),
    );
  }
}