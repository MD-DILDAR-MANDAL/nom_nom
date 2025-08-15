import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:nom_nom/model/history_item.dart';
import 'package:nom_nom/theme_profile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    var box = Hive.box('detection_history');
    List<History> items = box.values.cast<History>().toList();

    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: primary,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset("assets/icons/History.svg", height: 78),
                SvgPicture.asset("assets/icons/History.svg", height: 78),
                SvgPicture.asset("assets/icons/History.svg", height: 78),
                SvgPicture.asset("assets/icons/History.svg", height: 78),
              ],
            ),
          ],
        ),
      ),
      body: _list(items),
    );
  }

  Widget _list(items) {
    return items.isEmpty
        ? Center(child: Text("No History yet"))
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[items.length - index - 1];
                return Row(
                  children: [
                    SvgPicture.asset(
                      index % 2 == 1
                          ? "assets/icons/flower1.svg"
                          : "assets/icons/flower2.svg",
                      width: 50,
                    ),
                    Expanded(
                      child: Card(
                        color: secondary,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(item.location),
                                  height: 130,
                                  width: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      item.labels.join(', '),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      _formatTime(item.timeStamp),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
  }

  String _formatTime(DateTime time) {
    return "${time.day}/${time.month}/${time.year}-${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }
}
