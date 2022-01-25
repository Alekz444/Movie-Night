import 'dart:convert';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_night/data/event_dao.dart';
import 'package:movie_night/event_widget.dart';


import './menuDrawer.dart';
import 'MovieReader.dart';
import 'event_list.dart';
import 'data/event.dart' as ev;
import './event_widget.dart';




class AdminPage extends StatefulWidget {
  const AdminPage({ Key? key }) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}
  
class _AdminPageState extends State<AdminPage> {
  Future<List<ev.Event>>? futureEvents;
  List<EventWidget> eventCards = [];
  EventDao eventDao = new EventDao();
  List<ev.Event> events = [];
  List<Movie> currentEventMovies = [];
  @override
  void initState() {
    // TODO: implement initState
   // currentEventMovies = getCurrentEventMovies();
  
    
    futureEvents = eventDao.getEventQuery().once().then((DataSnapshot data){
    List<ev.Event> events = [];
     
     ///data.value.forEach((element) {
      // events.add(element);
     //});
     var jsonData = data.value as Map<dynamic, dynamic>;;
     print(jsonData);
      return events;                 
   });
    super.initState();
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page')
      ),
      drawer: MenuDrawer(),
      body: Center(
        //child: EventList()
        child: Column(
          children: [
            // The button that takes you to the event creation page
            Container(
              margin: EdgeInsets.all(15),
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                  backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                  textStyle: MaterialStateProperty.all(TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 35,
                  ))
                ),
              
              onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                            
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventList(events: events)),
                            );
                }, 
              child: Text(
                'Create new event', 
                style: TextStyle(
                  color: Colors.white,
                ),              
              ),
                
                ),
            ),
            
            /*Column(
              children: eventsToCards(futureEvents),
            )*/
            Expanded(
              
              //returns list of event widgets
              child: FirebaseAnimatedList(              
                query: eventDao.getEventQuery(),
                itemBuilder: (context, snapshot, animation, index) {
                final json = snapshot.value as Map<dynamic, dynamic>;
               //print(json);
               ev.Event event = ev.Event.fromJson(json);
               events.add(event);
                return EventWidget(title: event.title, startDate: event.endDate, endDate: event.endDate, movieDate: event.movieDate, movies: event.movies,);
      },
    ),
            )            
          ],
        ),
      )
    );
  }

  List<Widget> eventsToCards(ev.Events? events) {
    List<Widget> eventCards = [];
    events!.events!.forEach((element) {
      EventWidget eventCard = EventWidget(title: element.title, startDate: element.startDate, endDate: element.endDate, movieDate: element.endDate, movies: element.movies,);
      eventCards.add(eventCard);
    });
    return eventCards;
  }

  List<Movie> getCurrentEventMovies() {
    late ev.Event currentEvent ;
    events.forEach((element) {
      if(element.isActive) {
        currentEvent = element;
      }
    });
    List<Movie> currentMovies = [];
    
    if(currentEvent == null) {
      return [];
    }
    currentEvent.movies.forEach((element) {
      currentMovies.add(element);
    });
    return currentMovies;
  }

 
}

