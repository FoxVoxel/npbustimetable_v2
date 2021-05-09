import 'package:flutter/material.dart';
import 'dart:convert';

class DetailScreen extends StatelessWidget {
  final dynamic sKey;
  final dynamic way;
  const DetailScreen({Key key, this.sKey, this.way}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("autobus")),
      body: Container(
        child: DetailPage(
          sKey: sKey,
          way: way,
        ),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final dynamic sKey;
  final dynamic way;
  DetailPage({Key key, this.sKey, this.way}) : super(key: key);

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
            children: [
              Container(),
              FutureBuilder(
                builder: (context, snapshot) {
                  var detailData = json.decode(snapshot.data.toString());
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text("Load...");
                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else {
                        List<dynamic> bus = detailData
                            .firstWhere((b) => b['bus'] == widget.sKey);
                        return Container(
                          child: ListView.builder(
                            itemCount: bus[widget.way].length,
                            itemBuilder: (ctx, inx) {
                              return Text(bus[widget.sKey]['routes'][widget.way]
                                  ['title']);
                            },
                          ),
                        );
                      }
                  }
                },
                future: DefaultAssetBundle.of(context)
                    .loadString('assets/data/bus_stops.json'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
