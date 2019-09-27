import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String usersTable = "usersTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String passwordColumn = "passwordColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

//padrão singleton para ter apenas um objeto da classe
class UserHelper {
  static final UserHelper _instance = UserHelper.internal();

  factory UserHelper() => _instance;

  UserHelper.internal();

  Database _db;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    } else { //inicializar DB
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath(); // caminho para o bd
    final path = join(databasesPath, "adsnew.db"); // nome do arquivo bd

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async { //abrir e criar bd
      await db.execute(
          "CREATE TABLE $usersTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $passwordColumn TEXT,"
              "$phoneColumn TEXT, $imgColumn TEXT)"
      );
    });
  }

  Future<User> saveUser(User user) async {
    Database dbUser = await db;
    user.id = await dbUser.insert(usersTable, user.toMap());
    return user;
  }

  Future<User> getUser(int id) async {
    Database dbUser = await db;
    List<Map> maps = await dbUser.query(usersTable,
        columns: [idColumn, nameColumn, emailColumn, passwordColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if(maps.length > 0){
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteUser(int id) async {
    Database dbUser = await db;
    return await dbUser.delete(usersTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateUser(User user) async {
    Database dbUser = await db;
    return await dbUser.update(usersTable,
        user.toMap(),
        where: "$idColumn = ?",
        whereArgs: [user.id]);
  }

  Future<List> getAllUsers() async {
    Database dbUser = await db;
    List listMap = await dbUser.rawQuery("SELECT * FROM $usersTable");
    List<User> listUser = List();
    for(Map m in listMap){
      listUser.add(User.fromMap(m));
    }
    return listUser;
  }

  Future<int> getNumber() async {
    Database dbAd = await db;
    return Sqflite.firstIntValue(await dbAd.rawQuery("SELECT COUNT(*) FROM $usersTable"));
  }

  Future close() async {
    Database dbUser = await db;
    dbUser.close();
  }

}
//molde para anuncios
class User {

  int id;
  String name;
  String email;
  String password;
  String phone;
  String img;

  User();
// construtor mapa para anuncio
  User.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    password = map[passwordColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }
// anuncio para mapa --- não precisa de id pq o bd fornece e pode ser null
  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      passwordColumn: password,
      phoneColumn: phone,
      imgColumn: img
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Ad(id: $id, name: $name, email: $email, password: $password, phone: $phone, img: $img)";
  }

}