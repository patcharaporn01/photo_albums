import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photo_list/models/photo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  List<PhotoItem>? _itemList;
  String? _error;

  void getAlbums() async {
    try {
      setState(() {
        _error = null;
      });

      final response = await _dio.get('https://jsonplaceholder.typicode.com/albums');
      debugPrint(response.data.toString());

      List list = jsonDecode(response.data.toString());
      setState(() {
        _itemList = list.map((item) => PhotoItem.fromJson(item)).toList();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      debugPrint(' ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getAlbums();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_error == null) {
      body = Column(
        children: [
          Text(
            "Photo Albums",
            style: TextStyle(
              fontSize: 20, // Increase the font size
              fontWeight: FontWeight.bold, // You can make it bold if desired
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _itemList!.length,
              itemBuilder: (context, index) {
                var todoItem = _itemList![index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Expanded(child: Text(todoItem.title)),
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      body = Column(
        children: [
          Text(
            "Error: $_error", // Display the error message
            style: TextStyle(
              fontSize: 24, // You can adjust the font size
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              getAlbums();
            },
            child: const Text('RETRY'),
          ),
        ],
      );
    }

    return Scaffold(body: body);
  }
}
