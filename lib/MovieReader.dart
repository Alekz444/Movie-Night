

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

import 'data/event.dart' as ev;
import 'data/event_dao.dart';
import 'event_widget.dart';



Future<MovieList> fetchMovieList() async {
  final response = await http
      .get(Uri.parse('https://imdb-api.com/en/API/Top250Movies/k_wxk2kaeh'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return MovieList.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load movie');
  }
}

class Movie {
  final String id;
  final String rank;
  final String title;
  final String fullTitle;
  final String year;
  final String image;
  final String crew;
  final String imDbRating;
  final String imDbRatingCount; //this is a number tho

  Movie({
    required this.id,
    required this.rank,
    required this.title,
    required this.fullTitle,
    required this.year,
    required this.image,
    required this.crew,
    required this.imDbRating,
    required this.imDbRatingCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      rank: json['rank'],
      title: json['title'],
      fullTitle: json['fullTitle'],
      year: json['year'],
      image: json['image'],
      crew: json['crew'],
      imDbRating: json['imDbRating'],
      imDbRatingCount: json['imDbRatingCount'],
    );
  } 

  Map toJson() => {
    'id': id,
    'rank': rank,
    'title': title,
    'fullTitle': fullTitle,
    'year': year,
    'image': image,
    'crew': crew,
    'imDbRating': imDbRating,
    'imDbRatingCount': imDbRatingCount,
  };
 
}

class MovieList {
  List<Movie> ?movieList;

  MovieList({
    required this.movieList,
  } );

  MovieList.fromJson(Map<String, dynamic> json) {
    movieList = []; 
    for(int i = 0; i < json['items'].length; ++i){
      print(json[i]);
      movieList!.add(Movie.fromJson(json['items'][i]));
    }
  } 
}

// void main() => runApp(const MyAppH()); ???

class MyAppH extends StatefulWidget {
  
   MyAppH({ dynamic});

  @override
  _MyAppHState createState() => _MyAppHState();
}

class _MyAppHState extends State<MyAppH> {
  late Future<MovieList> futureMovieList;
  late Map<String, int> movies;
  List<MovieCard> movieCards = [];
  Future<List<ev.Event>>? futureEvents;
  EventDao eventDao = new EventDao();
  List<ev.Event> events = [];

  //bool eventFound = false;

 // List<Movie> movieList = []; //IDK if this is okay PROBLEM?

  @override
  void initState() {
    super.initState();
    //futureMovieList = fetchMovieList();
    //movies = new Map<String, int>();
  @override
  void initState() {
    // TODO: implement initState
   // currentEventMovies = getCurrentEventMovies(); 
    futureEvents = eventDao.getEventQuery().once().then((DataSnapshot data){
    List<ev.Event> events = [];
     
     var jsonData = data.value as Map<dynamic, dynamic>;;
     print(jsonData);
      return events;                 
   });
    super.initState();      
  }

  }
  
 @override
  Widget build(BuildContext context) {
    
      return Container( 
          child: Center(
            child: FirebaseAnimatedList(         
              
              shrinkWrap: true,     
              physics: NeverScrollableScrollPhysics(),
                query: eventDao.getEventQuery(),
                itemBuilder: (context, snapshot, animation, index) {
                final json = snapshot.value as Map<dynamic, dynamic>;
               //print(json);
               ev.Event event = ev.Event.fromJson(json);
               
               //events.add(event);
               if(DateTime.now().isAfter(event.startDate) && DateTime.now().isBefore(event.endDate)) {
                 //eventFound = true;
                 
                 List<MovieCard> movieCards = [];
                 event.movies.forEach((element) {
                   MovieCard movieCard = new MovieCard(id: element.id, title: element.title, image: element.image, year: element.year);
                   movieCards.add(movieCard);
                 });
                Widget movieCardList = Container(
                  
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: movieCards,
                  ),
                );
                return movieCardList;
               }
               return Container(child: Text('No events going on'),);
                //return EventWidget(title: event.title, startDate: event.endDate, endDate: event.endDate, movieDate: event.movieDate, movies: event.movies,);
      },
    ),
            
          ),
        
    
    );
  } 
}

class MovieCard extends StatefulWidget {
  final String id;
  final String title;
  final String image;
  final String year;

  const MovieCard({ Key? key, required this.id, required this.title, required this.image, required this.year }) : super(key: key);

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {

  bool _selected = false;
  int _votes = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10), 
    child: Column(
      children: [
        Image.network(widget.image, fit: BoxFit.cover),
        Container(
          width: MediaQuery.of(context).size.width/1.5, // marimea ecranului
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [             
                Flexible(
                  child: Column(
                  children: [
                      
                        Text(                
                          widget.title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500
                          )
                        ,),
                    
                     
                    Text(
                      widget.year,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w300
                      )
                    )
                  ],
                  
                            ),
                ),
              
              Container(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(          
                        Icons.favorite,          
                        color: _selected == true
                          ? Colors.teal
                          : Colors.grey,
                    ),
                  onPressed: (){
                    setState(() {
                      if(_selected == false){
                        _selected = true;
                        _votes ++;
                      }
                      else {
                       _selected = false;
                       _votes --;
                      }
                    }
                    );
                  },
                      ),
                ),
              )
            ],
          
          ),
        )
      ], 
      
     
    )
  );
  }
} 