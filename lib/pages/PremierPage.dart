import 'dart:async';

import 'package:chat/pages/DeuxiemePage.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class PremierPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<PremierPage> {

  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
    subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async{
              if(!isDeviceConnected && isAlertSet == false){
                showDialogBox();
                setState(() {
                  isAlertSet = false;
                });
              }
            }
    );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Premier Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () {

                }, child: Text("Next Page")),
              ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  showDialogBox() => showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context){
        return CupertinoAlertDialog(
          title: Text("Pas connection"),
          content: Text("Please check your internet connection!"),
          actions: [
            TextButton(
                onPressed: () async{
                  Navigator.pop(context);
                  setState(() {
                    isAlertSet = false;
                  });
                  isDeviceConnected = await InternetConnectionChecker().hasConnection;
                },
                child: Text("Ok")),
          ],
        );
      });
}