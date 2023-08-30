import 'package:chat/models/user.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {

  UserModel? userModel;
  SearchScreen(this.userModel);

  @override
  State<StatefulWidget> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {
  // Déclaration des variables
  TextEditingController searchController = TextEditingController();
  List<Map> seachResult = [];
  bool isLoading  = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recherche votre amis"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Type d'utilisateur...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: ()async{
                    onSearch();
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          if(seachResult.length > 0)
            Expanded(child: ListView.builder(
                itemCount: seachResult.length,
                shrinkWrap: true,
                itemBuilder: (context ,i){
                    return ListTile(
                      leading: CircleAvatar(
                        child: Image.network(seachResult[i]['image']),
                      ),
                      title: Text(seachResult[i]['name']),
                      subtitle: Text(seachResult[i]['email']),
                      trailing: IconButton(
                        onPressed: (){
                          setState(() {
                            searchController.text = "";
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
                              currentUser: widget.userModel,
                              friendId: seachResult[i]['uid'],
                              friendName: seachResult[i]['name'],
                              friendImage: seachResult[i]['image'])));
                        },
                        icon: Icon(Icons.message),
                      ),
                    );
            }))
          else if(isLoading == true)
            Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }

  void onSearch() async{
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance.collection('users').where("name", isEqualTo: searchController.text).get().then((value){
      if(value.docs.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Aucun n'utilisateur")));
        setState(() {
          seachResult = [];
          isLoading = false;
        });
        return;
      }
      for (var user in value.docs) {
        if(user.data()['email'] != widget.userModel!.email){
          seachResult.add(user.data());
        }
      }
    });
  }
}
