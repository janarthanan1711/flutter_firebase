import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/home_screen.dart';
import 'package:flutter_firebase/screens/register_screen.dart';
import 'package:flutter_firebase/services/auth_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCkLRC_89o0puycEjwJCqEJFmAqLQ7GY_g",
          appId: "1:39229914794:web:a1c4f5ae9c48fd9a8f1ad3",
          messagingSenderId: "39229914794",
          projectId: "flutterfirebase-f77f1"),
    );
  }else{
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Firebase',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark
        ),
        home: StreamBuilder(
          stream: AuthService().firebaseAuth.authStateChanges(),
          builder: (context,AsyncSnapshot snapshot){
            if(snapshot.hasData){
              return HomeScreen(snapshot.data);
            }else{
              return RegisterScreen();
            }
          },
        )
    );
  }
}
