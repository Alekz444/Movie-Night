import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'MovieReader.dart';
import 'data/event.dart';

class EventWidget extends StatefulWidget {
  final String title; 
  final DateTime startDate;
  final DateTime endDate;
  final DateTime movieDate;
  final List<Movie> movies;

  
  
  EventWidget({required this.title, required this.startDate, required this.endDate, required this.movieDate, required this.movies,});
  
   @override
  EventWidgetState createState() => EventWidgetState();
}

class EventWidgetState extends State<EventWidget> {
 

  bool _isSelected = false;

  

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
      color: Colors.blueGrey
      ),
    
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Card(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20,
                      backgroundColor: Colors.blue[100],
                    ),
                  ),
                  
                  /*ElevatedButton(
                    child: 
                      Icon(
                        Icons.movie_rounded,
                        color: (_isSelected) ? Colors.blueGrey : Colors.grey,
                        ),
                      onPressed: () {
                        if(_isSelected == false) {
                          setState(() {
                            _isSelected = true;
                          });
                        }
                        else {
                         setState(() {
                            _isSelected = false;
                         });
                         
                        }
                      },
                    )*/

                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                Row(
                  children: [
                  Text('Start date:'),
                  Text(widget.startDate.toString())
                  ],
                ),
                Row(
                  children: [
                  Text('End date:'),
                  Text(widget.endDate.toString())
                  ],
                ),
                Row(
                  children: [
                  Text('Movie date:'),
                  Text(widget.movieDate.toString())
                ],
                )]
              ),)
            
          ],
        ),
      ),
    );
  }
}
