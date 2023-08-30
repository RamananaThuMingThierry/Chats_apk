import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityPage extends StatefulWidget {
  @override
  _ConnectivityPageState createState() => _ConnectivityPageState();
}

class _ConnectivityPageState extends State<ConnectivityPage> {
  var connectionStatus;
  late InternetConnectionChecker connectionChecker;

  @override
  void initState() {
    super.initState();
    connectionChecker = InternetConnectionChecker();
    connectionChecker.onStatusChange.listen((status) {
      setState(() {
        connectionStatus = status.toString();
      });
      if(connectionStatus == InternetConnectionStatus.disconnected.toString()){
        showDialog(
            context: context,
            builder: (BuildContext ctx){
              return AlertDialog(
                title: Text("No connection"),
                actions: [
                  TextButton(
                      onPressed: (){Navigator.pop(context);},
                      child: Text("OK")),
                ],
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connectivity Demo'),
      ),
      body: (connectionStatus == InternetConnectionStatus.connected.toString())
          ?  Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Connection Status:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              '$connectionStatus',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}
