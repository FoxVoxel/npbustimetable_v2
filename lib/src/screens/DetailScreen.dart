import 'package:flutter/material.dart';
import 'dart:convert';

// Детальное отображения движения автобуса по маршруту
class DetailScreen extends StatelessWidget {
  // Специальный ключ <Маршрут автобуса>
  final dynamic sKey;
  // Направление автобуса
  final dynamic way;
  // Заголовок страницы исходя из маршрута
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
  // Переданный параметр маршрута и направления
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
      // Парсинг остановок и времени прибытия автобуса на них
      child: FutureBuilder(
        builder: (context, snapshot) {
          // Перевод из json в массив данных
          List<dynamic> jsonData = json.decode(snapshot.data.toString());
          // Проверка загруженны ли данные
          switch (snapshot.connectionState) {
            // Вывод текста об ожиданнии, пока данные загружаются
            case ConnectionState.waiting:
              return Text("Load...");
            default:
              // Стандартная проверка на ошибки при загрузке
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              // Вывод информации на экран после загрузки и отсутствии ошибки
              else {
                // Сортировка по маршруту
                var sortData =
                    jsonData.firstWhere((el) => el['bus'] == widget.sKey);
                //Создание листа из полученных данных
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
                        // Вывод времени в диалоговом окне
                        showDialog(
                          context: context,
                          builder: (context) {
                            // Разделение строки в массив по спец символу
                            var busTime = sortData['routes']
                                    [widget.way.toString()][inx]['time']
                                .toString()
                                .split('|');
                            return AlertDialog(
                              title: Text("Время прибытия"),
                              content: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.height * 0.2,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(

                                          itemCount: busTime.length,
                                          itemBuilder: (ctx, inx) => ListTile(
                                            title: Text(busTime[inx]
                                            ),
                                      ),
                                    ),
                                    ),
                                  ],
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
