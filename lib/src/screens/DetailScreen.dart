import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final dynamic sKey;
  const DetailScreen({Key key, this.sKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("autobus")),
      body: Container(
        child: Text(sKey),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  DetailPage({Key key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [],
          ),
        ),
      ],
    );
  }
}
