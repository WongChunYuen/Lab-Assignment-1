import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_moviereview/views/moviedetails.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies Review Application',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const MyMovieReview(),
    );
  }
}

class MyMovieReview extends StatefulWidget {
  const MyMovieReview({super.key});

  @override
  State<MyMovieReview> createState() => _MyMovieReviewState();
}

class _MyMovieReviewState extends State<MyMovieReview> {
  TextEditingController searchMovie = TextEditingController();
  var title = "",
      res = "",
      poster = "",
      year = "",
      runTime = "",
      genre = "",
      director = "",
      country = "";
  String desc = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movies Review Application"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Search Movie",
            style: TextStyle(fontSize: 24),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: searchMovie,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Movies Name',
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
          ElevatedButton(onPressed: _showMyDialog, child: const Text("Search")),
        ],
      )),
    );
  }

//method to show confirmation dialog
  void _showMyDialog() {
    var movie = searchMovie.text;
    if (movie == "") {
      showDialog(
          context: context,
          builder: (context) =>
              const AlertDialog(title: Text('Please enter movie name!')));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure to find "$movie"'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _loadProgress();
                },
                child: const Text("Yes")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"))
          ],
        ),
      );
    }
  }

// method to show the progress when searching for a movie
  void _loadProgress() {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    Timer(const Duration(seconds: 3), () {
      _getMovieList();
      Navigator.pop(context);
    });
  }

// method that get the jsonData from the url
  void _getMovieList() async {
    var apiid = "1f4eb317";
    var movie = searchMovie.text;
    var url = Uri.parse('https://www.omdbapi.com/?t=$movie&apikey=$apiid');
    var response = await http.get(url);
    var jsonData = response.body;
    var parsedJson = json.decode(jsonData);
    setState(() {
      res = parsedJson['Response'];
    });
    if (res == "True") {
      setState(() {
        title = parsedJson['Title'];
        poster = parsedJson['Poster'];
        year = parsedJson['Year'];
        runTime = parsedJson['Runtime'];
        genre = parsedJson['Genre'];
        director = parsedJson['Director'];
        country = parsedJson['Country'];
        desc =
            "Title: $title\nYear: $year\nRuntime: $runTime\nGenre: $genre\nDirector: $director\nCountry: $country";
        _search();
      });
    } else {
      setState(() {
        showDialog(
            context: context,
            builder: (context) =>
                const AlertDialog(title: Text("Movie not found!")));
      });
    }
  }

//method that pass data and nagivate to second screen
  void _search() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => MovieDetails(
                valueTitle: title, valuePoster: poster, valueDes: desc)));
    setState(() {});
  }
}
