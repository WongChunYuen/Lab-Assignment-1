import 'package:flutter/material.dart';

// Second screen that shows movie poster and details
class MovieDetails extends StatefulWidget {
  final String valueTitle, valuePoster, valueDes;
  const MovieDetails(
      {super.key,
      required this.valueTitle,
      required this.valuePoster,
      required this.valueDes});

  @override
  State<MovieDetails> createState() => _MovieListState();
}

class _MovieListState extends State<MovieDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.valueTitle,
      )),
      body: SingleChildScrollView(
        child: Center(
            child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.network(widget.valuePoster, scale: 0.9),
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.valueDes,
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.left,
              )
            ],
          ),
        )),
      ),
    );
  }
}
