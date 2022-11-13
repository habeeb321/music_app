import 'package:hive/hive.dart';
part 'muzic_model.g.dart';

@HiveType(typeId: 1)
class MuzicModel extends HiveObject {
  MuzicModel({
    required this.name,
    required this.songId,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  List<int> songId;

  add(int id) async {
    songId.add(id);
    save();
  }

  deleteData(int id) {
    songId.remove(id);
    save();
  }

  bool isValueIn(int id) {
    return songId.contains(id);
  }
}

@HiveType(typeId: 2)
class EditModel extends HiveObject {
  EditModel({
    required this.id,
    required this.name,
  });

  @HiveField(0)
  int id;

  @HiveField(1)
  String name;
}
