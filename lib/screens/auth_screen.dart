import 'package:chat/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth_Screen extends StatefulWidget {
  const Auth_Screen({Key? key}) : super(key: key);
  @override
  State<Auth_Screen> createState() => _Auth_ScreenState();
}

class _Auth_ScreenState extends State<Auth_Screen> {
  // Déclaration des variables
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future SignInFonction() async{
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if(googleUser == null){
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    DocumentSnapshot userExist = await firestore.collection("users").doc(userCredential.user!.uid).get();

    if(userExist.exists){
      print("Users already exists in database!");
    }else{
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'email':userCredential.user!.email,
        'name':userCredential.user!.displayName,
        'image':userCredential.user!.photoURL,
        'uid':userCredential.user!.uid,
        'date':DateTime.now()
      }); 
    }

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/chat.png"),
                  )
                ),
              ),
            ),
            RichText(text: TextSpan(
              children: [
                TextSpan(text: "Nos", style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 18)),
                TextSpan(text: " Message", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ]
            )),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ElevatedButton(
                  onPressed: ()async{
                    await SignInFonction();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 20, child: Image.asset("assets/google.png",),),
                      SizedBox(width: 10,),
                      Text("Se connecte avec Google", style: TextStyle(fontSize: 20),)
                    ],
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10)),
                  ),
                ),
            ),
          ],
        ),
      )
    );
  }
}
