import 'package:chat/models/user.dart';
import 'package:chat/screens/auth_screen.dart';
import 'package:chat/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> userSignedIn() async{
    User? user = FirebaseAuth.instance.currentUser;
    print('----------------------------------- ${user}');
    if(user != null){
      print("Je suis dans le page principale ${user.uid}");
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      print("************ User Data **************** ${userData}");
      UserModel userModel = UserModel.fromJson(userData);
      print("------------------user Model ************* ${userModel.name} ***************----------------");
      return HomeScreen(userModel);
    }else{
      print("Je suis dans l'authentification");
      print("Je suis dans l'authentification");
      print("Je suis dans l'authentification");
      print("Je suis dans l'authentification");
      return Auth_Screen();
    }
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nos Message',
      color: Colors.lightBlue,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: userSignedIn(),
        builder: (context, AsyncSnapshot<Widget> snapshot){
          if(snapshot.hasData){
            return snapshot.data!;
          }else{
            return Auth_Screen();
          }
        },
      ),
    );
  }
}


//
// import 'package:chat/pages/PremierPage.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown
//     ]);
//
//     return MaterialApp(
//       title: "Note n'aka",
//       home:  PremierPage(),
//       color: Colors.blueGrey,
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
