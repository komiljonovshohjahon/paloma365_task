import 'package:paloma365_task/core/db/db.dart';

class Di {
  static final Di _singleton = Di._internal();

  Di._internal();

  factory Di() {
    return _singleton;
  }

  late final Db db;

  Future<void> init() async {
    //init database
    final db = Db();
    await db.init();
    this.db = db;
  }
}
