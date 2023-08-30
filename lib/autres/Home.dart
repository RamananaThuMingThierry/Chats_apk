import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityPages extends StatefulWidget {
  @override
  _ConnectivityPageState createState() => _ConnectivityPageState();
}

class _ConnectivityPageState extends State<ConnectivityPages> {
  var connectionStatus;
  late Connectivity connectivity;

  @override
  void initState() {
    super.initState();
    connectivity = Connectivity();
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        connectionStatus = result.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connectivity Demo'),
      ),
      body: Center(
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
      ),
    );
  }
}
