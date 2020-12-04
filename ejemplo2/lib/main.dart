import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Database miBaseDatos;

  @override
  void initState() {
    crearBaseDatos().then((value) => miBaseDatos = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Datos'),
          ),
          body: RaisedButton(
            child: Text('Aceptar'),
            onPressed: () {
              miBaseDatos
                  .rawDelete("DELETE  FROM  MarioKart WHERE  jugador = 'Tod'");
              miBaseDatos.rawInsert(
                  "INSERT INTO MarioKart (jugador,vidas, puntuacion) VALUES ('Yoshi',3,0.0)");

              miBaseDatos
                  .rawQuery("SELECT * FROM MarioKart")
                  .then((value) => print(value));

              miBaseDatos.rawUpdate(
                  "UPDATE MarioKart SET jugador = ?  WHERE jugador = ? ",
                  ['Yoshi', 'Mario']);
            },
          )),
    );
  }
}

Future<Database> crearBaseDatos() async {
  var ruta = await getDatabasesPath();
  String rutaCompleta = join(ruta, "nintendo.db");

  Database baseDatos = await openDatabase(rutaCompleta, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE MarioKart (jugador TEXT, vidas INTEGER, puntuacion REAL)");
      });

  return await baseDatos;
}
