import 'package:hive/hive.dart';

part 'history_item.g.dart';

@HiveType(typeId: 0)
class History extends HiveObject {
  History({
    required this.location,
    required this.labels,
    required this.timeStamp,
  });
  @HiveField(0)
  String location;
  @HiveField(1)
  List<String> labels;
  @HiveField(2)
  DateTime timeStamp;
}
