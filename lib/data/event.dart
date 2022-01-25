import 'dart:convert';

import '../MovieReader.dart';

class Event {
  late bool isActive = true;
  late String title; 
  late DateTime startDate;
  late DateTime endDate;
  late DateTime movieDate;
  late List<Movie> movies;
  //final List

  Event({required this.title, required this.startDate, required this.endDate, required this.movieDate, required this.movies});

//Add two JSON converter methods to the bottom of your class:

//will help you transform the JSON you receive from the Realtime Database, into an Event
  Event.fromJson(Map<dynamic, dynamic> jsonData)
    { startDate = DateTime.parse(jsonData['startDate'] as String);
      endDate = DateTime.parse(jsonData['endDate'] as String);
      movieDate = DateTime.parse(jsonData['movieDate'] as String);
      title = jsonData['title'] as String;
       
       if(jsonData["movies"]!= null){
      List<Movie> _movies = [];
      var moviesJson = json.decode(jsonData["movies"]);
      for(int i = 0;i<moviesJson.length;i++){
        _movies.add(Movie.fromJson(moviesJson[i]));
      }
      movies = _movies;
    }
    }

//The second will do the opposite — transform the Event into JSON, for saving.
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
      'startDate': startDate.toString(),
      'endDate': endDate.toString(),
      'movieDate': movieDate.toString(),
      'title': title,
      'movies' : moviesToString(),
    };

  String moviesToString () {
    String jsonMovies = jsonEncode(movies);
    return jsonMovies;
  }

  void setActive(bool active) {
    isActive = active;
  }

}

class Events {
  List<Event>? events;

  Events({
    required this.events,
  } );

  Events.fromJson(Map<String, dynamic> json) {
    events = [];
    for(int i = 0; i < json['events'].length; ++i){
      print(json[i]);
      events!.add(Event.fromJson(json['events'][i]));
    }
  } 
}