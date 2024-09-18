import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pantallas/pantalla_reserva.dart';
import 'provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ReservaProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Jubert Hotel',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomePage(),
          routes: {
            '/home': (context) => const HomePage(),
          },
        ));
  }
}
