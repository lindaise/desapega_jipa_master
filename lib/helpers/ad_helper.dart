//padrão singleton para ter apenas um objeto da classe
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String adTable = "adTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class AdHelper {
  static final AdHelper _instance = AdHelper.internal();

  factory AdHelper() => _instance;

  AdHelper.internal();

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
          "CREATE TABLE $adTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT,"
              "$phoneColumn TEXT, $imgColumn TEXT)"
      );
    });
  }

  Future<Ad> saveAd(Ad ad) async {
    Database dbAd = await db;
    ad.id = await dbAd.insert(adTable, ad.toMap());
    return ad;
  }

  Future<Ad> getAd(int id) async {
    Database dbAd = await db;
    List<Map> maps = await dbAd.query(adTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if(maps.length > 0){
      return Ad.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteAd(int id) async {
    Database dbAd = await db;
    return await dbAd.delete(adTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateAd(Ad ad) async {
    Database dbAd = await db;
    return await dbAd.update(adTable,
        ad.toMap(),
        where: "$idColumn = ?",
        whereArgs: [ad.id]);
  }

  Future<List> getAllAds() async {
    Database dbAd = await db;
    List listMap = await dbAd.rawQuery("SELECT * FROM $adTable");
    List<Ad> listAd = List();
    for(Map m in listMap){
      listAd.add(Ad.fromMap(m));
    }
    return listAd;
  }

  Future<int> getNumber() async {
    Database dbAd = await db;
    return Sqflite.firstIntValue(await dbAd.rawQuery("SELECT COUNT(*) FROM $adTable"));
  }

  Future close() async {
    Database dbAd = await db;
    dbAd.close();
  }

}
//molde para anuncios
class Ad {

  int id;
  String name;
  String email;
  String phone;
  String img;

  Ad();

// construtor mapa para anuncio
  Ad.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

// anuncio para mapa --- não precisa de id pq o bd fornece e pode ser null
  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Ad(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}
