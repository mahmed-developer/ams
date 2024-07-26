import 'package:ams/Home.dart';
import 'package:ams/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ams/models/users.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAubyTWlCTygPiYlW5XzxuCGgbQma2SmKI",
          appId: "1:722105435344:android:2f63a78d66e8f52f270ad5",
          messagingSenderId: "722105435344",
          projectId: "management-sys-73239"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthCheck(),
    );
  }
}


class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable= false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser() async{
  SharedPreferences sp= await SharedPreferences.getInstance();
  try{
    String? email=sp.getString('emailidsp');
    if(email != null){
     setState(() {
       Users.userName=email;
       userAvailable=true;
     });
    }
  }
  catch(e){
    setState(() {
      userAvailable=false;
    });
  }
  }
  @override
  Widget build(BuildContext context) {
    return userAvailable ? const HomeScreen(): const Login();
  }
}
