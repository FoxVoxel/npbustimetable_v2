import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:npbustimetable_v2/src/screens/DetailScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Расписание Автобусов"),
      ),
      body: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        builder: (context, snapshot) {
          var showData = json.decode(snapshot.data.toString());
          return _buildListView(showData);
        },
        future: DefaultAssetBundle.of(context)
            .loadString("assets/data/NPBus_routes.json"),
      ),
    );
  }

  ListView _buildListView(showData) {
    return ListView.builder(
      itemCount: showData.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            child: Text(showData[index]['label']),
          ),
          title: Text(showData[index]['routes'][0]['direction']),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (build) {
                return ListView.builder(
                  itemCount: showData[index]['routes'].length,
                  itemBuilder: (context, inx) => ListTile(
                    title: Text(showData[index]['routes'][inx]['direction']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => DetailScreen(
                              sKey: showData[index]['routes'][inx]['s_key']),
                        ),
                      );
                    },
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
