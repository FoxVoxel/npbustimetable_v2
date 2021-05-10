import 'package:flutter/material.dart';
import 'dart:convert';

class DetailScreen extends StatelessWidget {
  final dynamic sKey;
  final dynamic way;
  final dynamic titlePage;
  const DetailScreen({Key key, this.sKey, this.way, this.titlePage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titlePage),
      ),
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
    return Container(
      child: FutureBuilder(
        builder: (context, snapshot) {
          List<dynamic> jsonData = json.decode(snapshot.data.toString());
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text("Load...");
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else {
                var sortData =
                    jsonData.firstWhere((el) => el['bus'] == widget.sKey);
                return ListView.builder(
                  itemCount: sortData['routes'][widget.way.toString()].length,
                  itemBuilder: (ctx, inx) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          (inx + 1).toString(),
                        ),
                      ),
                      title: Text(
                        sortData['routes'][widget.way.toString()][inx]['title'],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            var busTime = sortData['routes']
                                    [widget.way.toString()][inx]['time']
                                .toString()
                                .split('|');
                            return AlertDialog(
                              title: Text("Время прибытия"),
                              content: Container(
                                height: 150,
                                child: ListView.builder(
                                  itemCount: busTime.length,
                                  itemBuilder: (ctx, inx) => ListTile(
                                    title: Text(busTime[inx]),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              }
          }
        },
        future: DefaultAssetBundle.of(context)
            .loadString('assets/data/bus_stops.json'),
      ),
    );
  }
}
