import 'package:paloma365_task/core/db/daos/order_dao.dart';
import 'package:paloma365_task/core/db/daos/products_dao.dart';
import 'package:paloma365_task/core/db/daos/tables_dao.dart';
import 'package:sqflite/sqflite.dart';

class Db {
  late final Database _db;

  late final RestaurantTableDao tableDao;
  late final CategoryDao categoryDao;
  late final ProductDao productDao;
  late final OrderDao orderDao;

  Future<void> init() async {
    _db = await openDatabase(
      'paloma365_db.db',
      version: 1,
      onCreate: (db, version) async {
        await Future.wait([
          db.execute(createTableRestaurantTables),
          db.execute(createTableCategories),
          db.execute(createTableProducts),
          db.execute(createTableOrders),
        ]);

        await Future.forEach(_initialDataQueries, db.execute);
      },
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );

    tableDao = RestaurantTableDao(_db);
    categoryDao = CategoryDao(_db);
    productDao = ProductDao(_db);
    orderDao = OrderDao(_db);

    // ignore: avoid_print
    print('Database initialized $_db');
  }

  final String tableRestaurantTables = 'restaurant_tables';
  late final String createTableRestaurantTables = '''
    CREATE TABLE IF NOT EXISTS $tableRestaurantTables (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL UNIQUE,
      ordered_products TEXT 
    )
  ''';

  final String tableCategories = 'categories';
  late final String createTableCategories = '''
    CREATE TABLE IF NOT EXISTS $tableCategories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL UNIQUE,
      description TEXT
    )
  ''';

  final String tableProducts = 'products';
  late final String createTableProducts = '''
    CREATE TABLE IF NOT EXISTS $tableProducts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      category_id INTEGER,
      price REAL NOT NULL,
      description TEXT,
      is_available INTEGER DEFAULT 1,
      stock_quantity REAL DEFAULT 0,
      FOREIGN KEY (category_id) REFERENCES $tableCategories(id)
    )
  ''';

  final String tableOrders = 'orders';
  late final String createTableOrders = '''
    CREATE TABLE IF NOT EXISTS $tableOrders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      table_id INTEGER NOT NULL,
      order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
      total_amount REAL DEFAULT 0,
      -- 'paid'
      status TEXT DEFAULT 'open', 
      FOREIGN KEY (table_id) REFERENCES $tableRestaurantTables(id)
    )
  ''';

  late final List<String> _initialDataQueries = [
    '''
    INSERT INTO $tableCategories (name, description) VALUES 
    ('Drinks', 'Refreshing beverages'),
    ('Main Dishes', 'Hearty main course meals'),
    ('Desserts', 'Sweet treats and desserts'),
    ('Appetizers', 'Starters and small plates')
    ''',
    '''
    INSERT INTO $tableProducts (name, category_id, price, description, stock_quantity) VALUES 
    ('Coca Cola', 1, 2.50, 'Classic cola drink', 100),
    ('Fanta', 1, 2.50, 'Orange flavored soda', 80),
    ('Pasta Carbonara', 2, 12.99, 'Creamy pasta with bacon', 50),
    ('Caesar Salad', 2, 8.50, 'Classic salad with chicken', 30),
    ('Chocolate Cake', 3, 6.99, 'Rich chocolate dessert', 20),
    ('Chicken Wings', 4, 7.50, 'Spicy chicken wings', 40)
    ''',
    '''
    INSERT INTO $tableRestaurantTables (name, ordered_products) VALUES 
    ('Table 1', ''),
    ('Table 2', ''),
    ('Table 3', ''),
    ('Table 4', ''),
    ('Table 5', '')
    '''
  ];
}
