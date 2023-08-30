import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{

  String? image;
  Timestamp? date;
  String? uid;
  String? email;
  String? name;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.image,
    required this.date
  });

  factory UserModel.fromJson(DocumentSnapshot snapshot){
    return UserModel(
        uid: snapshot['uid'],
        name: snapshot['name'],
        email: snapshot['email'],
        image: snapshot['image'],
        date: snapshot['date']);
  }
}