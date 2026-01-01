import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as db_path;
import 'package:sqflite/sqlite_api.dart';

class DatabaseService {
  static final String _databaseName = 'emcube.db';
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static sql.Database? _database;

  void _createTable(sql.Batch batch, String sql) {
    batch.execute(sql);
  }

  void _alterTable(
      Transaction txn, String table, String field, String fieldType) {
    txn.execute('ALTER TABLE $table ADD $field $fieldType');
  }

  void _createTableOnUpdate(String sql, Transaction txn) {
    txn.execute(sql);
  }

  Future<void> _performVersionSpecificUpgrade(Database db, int version) async {
    switch (version) {
      case 2:
        db.transaction((txn) async {
          _alterTable(txn, 'mobile_sales_details', 'shopId', 'TEXT');
          _alterTable(txn, 'user_details', 'shopId', 'TEXT');
          _alterTable(txn, 'user_details', 'servedBy', 'TEXT');
          final String sql =
              'CREATE TABLE IF NOT EXISTS staff_details(serialNo INTEGER PRIMARY KEY AUTOINCREMENT, staffId TEXT,shopId TEXT,staffName TEXT,UNIQUE (staffId))';
          _createTableOnUpdate(sql, txn);
        });
        break;  
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    var batch = db.batch();

    final String itemsTable =
        'CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT, description TEXT)';

    final String productsDetailsTable =
        'CREATE TABLE IF NOT EXISTS product_details(serialNo INTEGER PRIMARY KEY AUTOINCREMENT,productId TEXT,productName TEXT,categoryId TEXT,statusId INTEGER,sellingPrice REAL,purchasePrice REAL, UNIQUE (productId))';

    final String productsCategoryTable =
        'CREATE TABLE IF NOT EXISTS product_category(serialNo INTEGER PRIMARY KEY AUTOINCREMENT,categoryId TEXT,categoryName TEXT)';

    final String saleDetailsTable =
        'CREATE TABLE IF NOT EXISTS mobile_sales_details(serialNo INTEGER PRIMARY KEY AUTOINCREMENT,cartId TEXT,receiptId TEXT,productId TEXT,quantity INTEGER,sellingPrice REAL,postedBy TEXT,statusId INTEGER,transactionDate INTEGER,paymentMethod TEXT, transactionId TEXT,shopId TEXT,servedBy TEXT)';

    final String userDetailsTable =
        'CREATE TABLE IF NOT EXISTS user_details(userId TEXT,accessCode TEXT,passCode TEXT,firstName TEXT,lastName TEXT,otherName TEXT,roleId INTEGER, shopId TEXT, UNIQUE (userId))';

    final String staffDetailsTable =
        'CREATE TABLE IF NOT EXISTS staff_details(serialNo INTEGER PRIMARY KEY AUTOINCREMENT, staffId TEXT,shopId TEXT,staffName TEXT,UNIQUE (staffId))';

    _createTable(batch, itemsTable);
    _createTable(batch, productsDetailsTable);
    _createTable(batch, productsCategoryTable);
    _createTable(batch, saleDetailsTable);
    _createTable(batch, userDetailsTable);
    _createTable(batch, staffDetailsTable);

    await batch.commit();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (int version = oldVersion + 1; version <= newVersion; version++) {
      await _performVersionSpecificUpgrade(db, version);
    }
  }

  Future<sql.Database> _initDatabase() async {
    final databasePath = await sql.getDatabasesPath();
    final path = db_path.join(databasePath, _databaseName);

    return await sql.openDatabase(path,
        version: 1, 
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onDowngrade: onDatabaseDowngradeDelete);
  }

  Future<sql.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> insert(String table, Map<String, dynamic> item) async {
    final db = await database;
    await db.insert(table, item,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> get(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future clear() async {
    final dbPath = await sql.getDatabasesPath();
    await sql.deleteDatabase(dbPath);
  }

  Future<int> update(
    String table,
    Map<String, dynamic> data,
    String where,
    List<Object?> whereArgs,
  ) async {
    final db = await database;
    return db.update(table, data, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, String field, String value) async {
    final db = await database;
    return db.delete(table, where: '$field = ?', whereArgs: [value]);
  }

  Future<List<Map<String, dynamic>>> getWhere(
      String table, String field, dynamic value) async {
    final db = await database;
    return await db.query(table, where: '$field = ?', whereArgs: [value]);
  }

  Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<Object?>? arguments]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }

  Future<List<Map<String, dynamic>>> rawGetAllRows(String table) async {
    return await rawQuery('SELECT * FROM $table');
  }

  Future<int> rawUpdate(String sql, [List<Object?>? arguments]) async {
    final db = await database;
    return await db.rawUpdate(sql, arguments);
  }

  Future<int> rawInsert(String sql, [List<Object?>? arguments]) async {
    final db = await database;
    return await db.rawInsert(sql, arguments);
  }

  Future<int> rawDelete(String sql, [List<Object?>? arguments]) async {
    final db = await database;
    return await db.rawDelete(sql, arguments);
  }
}
