import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List _movies = [];
  Map _genres = {};
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    fetchMovies();
    fetchGenres();
  }

  Future<void> fetchMovies() async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=87bca15c73004df695cec71532308f7c'));

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      setState(() {
        _movies = mapResponse['results'];
      });
    } else {
      throw Exception('Error al cargar las películas');
    }
  }

  Future<void> fetchGenres() async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/genre/movie/list?api_key=87bca15c73004df695cec71532308f7c'));

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      setState(() {
        for (var genre in mapResponse['genres']) {
          _genres[genre['id']] = genre['name'];
        }
      });
    } else {
      throw Exception('Error al cargar los géneros');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('apk_peli77'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Perfil()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Buscar',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                var movie = _movies[index];
                if (_searchText.isEmpty || movie['title'].toLowerCase().contains(_searchText.toLowerCase())) {
                  return ListTile(
                    leading: Image.network('https://image.tmdb.org/t/p/w500/${movie['poster_path']}'),
                    title: Text(movie['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Descripción: ${movie['overview']}'),
                        Text('Género: ${movie['genre_ids'].map((id) => _genres[id]).join(', ')}'),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(movie['title']),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Container(
                                    height: 200,
                                    child: Image.network('https://image.tmdb.org/t/p/w500/${movie['poster_path']}'),
                                  ),
                                  Text('Descripción: ${movie['overview']}'),
                                  Text('Género: ${movie['genre_ids'].map((id) => _genres[id]).join(', ')}'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cerrar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Perfil extends StatelessWidget {
  final TextEditingController nombreController = TextEditingController(text: "neider");
  final TextEditingController asignaturaController = TextEditingController(text: "desarrollo de aplicacion");
  final TextEditingController jornadaController = TextEditingController(text: "noche");
  final TextEditingController docenteController = TextEditingController(text: "jose bolaño");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Image.asset('assets/imagenes/Logo.png'),
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            TextField(
              controller: asignaturaController,
              decoration: InputDecoration(
                labelText: 'Asignatura',
              ),
            ),
            TextField(
              controller: jornadaController,
              decoration: InputDecoration(
                labelText: 'Jornada',
              ),
            ),
            TextField(
              controller: docenteController,
              decoration: InputDecoration(
                labelText: 'docente',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
