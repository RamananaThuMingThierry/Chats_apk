import 'package:chat/models/user.dart';
import 'package:chat/screens/auth_screen.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {

  UserModel? userModel;
  HomeScreen(this.userModel);
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }

}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text("Nos Messages"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        actions: [
          Icon(Icons.message),
          SizedBox(width: 8,)
        ],
      ),
      drawer: ClipPath(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        clipper: OvalRightBorderClipper(),
        child: Drawer(
          width: 275.0,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(widget.userModel!.image!),
                ),
                accountName: Text(widget.userModel!.name! ?? "Aucun"),
                accountEmail: Text(widget.userModel!.email! ?? "Aucun"),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/no_image.jpg"),
                        fit: BoxFit.cover
                    )
                ),
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text("Messages",style: TextStyle(color: Colors.blueGrey),),
                onTap: () =>Navigator.pop(context),
              ),
              Divider(
                color: Colors.blueGrey,
                thickness: 1,
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("Apropos", style: TextStyle(color: Colors.blueGrey)),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (BuildContext buildContext){
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          elevation: 0.0,
                          backgroundColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black26,blurRadius: 10.0, offset: Offset(0.0,10.0)),
                              ],
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(16.0),
                                    alignment: Alignment.centerRight,
                                    child: Icon(Icons.close),
                                  ),
                                ),
                                Text("Apropos", style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Colors.blueGrey),),
                                Padding(
                                  padding: EdgeInsets.only(top:16.0, left: 16.0,right: 16.0, bottom: 16.0),
                                  child: Text(
                                    "Cette application consiste à transmettre une information à quelqu'un d'autre.",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 16.0,right: 16.0, bottom: 16.0),
                                  child: Text(
                                    "Réalisée par RAMANANA Thu Ming Thierry",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
              Divider(
                color: Colors.blueGrey,
                thickness: 1,
              ),
              ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Déconnection", style: TextStyle(color: Colors.blueGrey)),
                  onTap: () async{
                    Navigator.pop(context);
                    _deconnectionAlertDialog();
                    print("Déconnection");
                  }
              ),
              Divider(
                color: Colors.blueGrey,
                thickness: 1,
              ),
              Padding(padding: EdgeInsets.only(top: 250.0)),
              Text("RAMANANA Thu Ming Thierry \n Version 1.0", style: TextStyle(color: Colors.lightBlue),textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(widget.userModel!.uid).collection('messages').snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(snapshot.data.docs.length < 1){
              return Center(
                child: Text("Aucun message!"),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, i){
                  var friendId = snapshot.data.docs[i].id;
                  var lastMessage = snapshot.data.docs[i]['last_msg'];
                  return FutureBuilder(
                      future: FirebaseFirestore.instance.collection('users').doc(friendId).get(),
                      builder: (context, AsyncSnapshot asyncSnapshot){
                        if(asyncSnapshot.hasData){
                          var friend = asyncSnapshot.data;
                          return Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Card(
                              elevation: 1,
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: CachedNetworkImage(
                                    imageUrl: friend['image'],
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    height: 40,
                                  ),
                                ),
                                title: Text("${friend['name']}"),
                                subtitle: Container(
                                  child: Text("${lastMessage}", style: TextStyle(color: Colors.grey),overflow: TextOverflow.ellipsis,),
                                ),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
                                      currentUser: widget.userModel,
                                      friendId: friend['uid'],
                                      friendName: friend['name'],
                                      friendImage: friend['image']
                                  )));
                                },
                              ),
                            ),
                          );
                        }
                        return LinearProgressIndicator();
                      });
                });
          }
          return Center(child: CircularProgressIndicator(),);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () async{
            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(widget.userModel)));
        },
      ),
    );
  }

  // Alert pour la déconnection
  Future<Null> _deconnectionAlertDialog() async{
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext buildContext){
          return AlertDialog(
            title: Text("Déconnection", textAlign:TextAlign.center,style: TextStyle(color: Colors.blueGrey),),
            content: Text("Voulez-vous vraiment la déconnecter ?", textAlign: TextAlign.center,style: TextStyle(color: Colors.grey),),
            contentPadding: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    print("Annuler");
                  },
                  child: Text("Annuler", style: TextStyle(color: Colors.redAccent),)),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    _onLoading();
                  }, child: Text("Ok",style: TextStyle(color: Colors.blueGrey),)),
            ],
          );
        });
  }

  void _onLoading(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          Future.delayed(Duration(seconds: 3), () async{
            Navigator.pop(context);
            await GoogleSignIn().signOut();
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Auth_Screen()), (route) => false);

          });
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            contentPadding: EdgeInsets.all(0.0),
            insetPadding: EdgeInsets.symmetric(horizontal: 100),
            content: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.blueGrey,),
                  SizedBox(height: 16,),
                  Text("Déconnection...", style: TextStyle(color: Colors.grey),)
                ],
              ),
            ),
          );
        });
  }
}

class OvalRightBorderClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 50, 0);
    path.quadraticBezierTo(size.width, size.height / 4, size.width, size.height /2);
    path.quadraticBezierTo(size.width, size.height - (size.height / 4), size.width - 40, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}
