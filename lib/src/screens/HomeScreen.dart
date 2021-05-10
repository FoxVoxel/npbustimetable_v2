import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:npbustimetable_v2/src/screens/DetailScreen.dart';

//Главная страница приложения
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
  // Получение числового значения дня недели
  final int getDayOnWeek = DateTime.now().day;
  //Вывод текста в зависимости от дня недели
  String workbleDay(day) {
    if (day > 0 && day < 4) {
      return "Будни";
    } else {
      return "Выходные";
    }
  }

  // Проверка является ли день будним или выходным
  bool isWorkbleWay(day) {
    if (day > 0 && day < 4) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Парсинг данных из .json объекта и ввывод асинхронных данных
      child: FutureBuilder(
        builder: (context, snapshot) {
          // Конвертация из json в массив данных
          var showData = json.decode(snapshot.data.toString());
          // Проверка загруженны ли данные
          switch (snapshot.connectionState) {
            // Вывод текста об ожиданнии, пока данные загружаются
            case ConnectionState.waiting:
              return Text("Load...");
            default:
              // Стандартная проверка на ошибки при загрузке
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                // Вывод информации на экран после загрузки и отсутствии ошибки
                return _buildListView(showData);
          }
        },
        future: DefaultAssetBundle.of(context)
            .loadString("assets/data/bus_routes.json"),
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
            // Построение нижнего диалогового окна
            showModalBottomSheet(
              context: context,
              builder: (build) {
                return ListView.builder(
                    itemCount: showData[index]['routes'].length,
                    itemBuilder: (context, inx) {
                      return ListTile(
                        title:
                            Text(showData[index]['routes'][inx]['direction']),
                        subtitle: Text(
                          showData[index]['routes'][inx]['way'] == 0 ||
                                  showData[index]['routes'][inx]['way'] == 1
                              ? "Будни"
                              : "Выходные",
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            // Переход к DetailScreen по средствам маршрутизации
                            MaterialPageRoute(
                              builder: (ctx) => DetailScreen(
                                titlePage: showData[index]['routes'][inx]
                                    ['direction'],
                                sKey: showData[index]['routes'][inx]['s_key'],
                                way: showData[index]['routes'][inx]['way'],
                              ),
                            ),
                          );
                        },
                      );
                    });
              },
            );
          },
        );
      },
    );
  }
}
