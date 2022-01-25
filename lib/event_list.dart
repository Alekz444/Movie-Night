

import 'package:flutter/foundation.dart';
import 'package:movie_night/menuDrawer.dart';

import 'data/event.dart' as event;
import 'data/event.dart';
import 'data/event_dao.dart';
import 'event_widget.dart';
import 'MovieReader.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';


class EventListState extends State<EventList> {
  
  //ValueNotifier<List<Movie>> _ = ValueNotifier(selectedMovies);
  TextEditingController _titleController = TextEditingController();
  DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now();
  late DateTime movieDate = DateTime.now();

  List<Movie> selectedMovies = [];
  bool _moviesVisible = false;
  //bool _eventReady = false;
  late Card moviesPicked = Card();
  final _formKey = GlobalKey<FormState>();

  
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    //ValueNotifier<List<Movie>> _movieListener = ValueNotifier(selectedMovies);
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
      return Scaffold(
        appBar: AppBar(title: Text("Create event")),
        drawer: MenuDrawer(),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey, 
            child: Center(
              child: Column(
                children: <Widget> [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 40, 20, 10),
                    child: TextFormField(
                      controller: _titleController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                              fillColor: Color.fromARGB(1, 176, 211, 245),
                              border: OutlineInputBorder(),
                              labelText: 'Title of event',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              if(!_titleIsAvailable(value)) {
                                return 'Title is already taken';
                              }
                              return null;
                            },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      children: <Widget> [
                        Text('Start date of event', style: myTextStyle),
                        Text(startDate.toString()),
                        ElevatedButton(
                          onPressed: () => _selectStartDate(context),
                          child: Text('Select start date'),
                        ),
                      ],
                    ),
                  ),
                   Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      children: <Widget> [
                        Text('End date of event', style: myTextStyle),
                        Text(startDate.toString()),
                        ElevatedButton(
                          onPressed: () => _selectEndDate(context),
                          child: Text('Select end date'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      children: <Widget> [
                        Text('Movie date of event', style: myTextStyle),
                        Text(startDate.toString()),
                        ElevatedButton(
                          onPressed: () => _selectMovieDate(context),
                          child: Text('Select movie date'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: FloatingActionButton(
                      onPressed: () {                           
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieSelector()),
                            );*/
                             
                               _navigateAndDisplaySelection(context);
                          
                             
                      },
                      child: Icon(Icons.add),
                      tooltip: 'Pick movies',
                      backgroundColor: Colors.blueGrey,
                    )
                  ),
                  Visibility(
                    visible: _moviesVisible,
                    
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                      padding: EdgeInsets.all(15),
                      child: moviesPicked,
                    ),
                  ),
        
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: ElevatedButton(
                        child: Text ('Create event'),
                        onPressed: () {
                          if (_formKey.currentState == null)
                          print("CurrentState is null");
                        //if (_formKey.currentState != null || _formKey.currentState!.validate()) {
                        if (_formKey.currentState != null) {
                          if (_formKey.currentState!.validate() && _eventReady()) {
                            event.Event ev = new event.Event(title: _titleController.text ,startDate: startDate, endDate: endDate, movieDate: movieDate, movies: selectedMovies);
                            EventDao eventDao = new EventDao();
                            eventDao.saveEvent(ev);  
                          }
                        }
                         
                          /*if(_eventReady()){
                            event.Event ev = new event.Event(title: _titleController.text ,startDate: startDate, endDate: endDate, movieDate: movieDate, movies: selectedMovies);
                            EventDao eventDao = new EventDao();
                            eventDao.saveEvent(ev);                                             
                          }*/
                          
                        },
                      )
                    ),
                  
                  
                ],
              ),
            )
          )
        ),
      );
     
    
  }

   void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => MovieSelector(selectedMovies: selectedMovies)),
    );

    setState(() {
    selectedMovies = result;
    List<Widget> movies = [];
    result.forEach((element){
      Row row = new Row(children: [Text(element.title)],);
      movies.add(row);
    });
    moviesPicked = Card(
      child: Column(
        children: movies,
      ),);
    _moviesVisible = true;
    });
    
    
  }

//This code creates a new Message with the _messageController text populated by a TextField 
//in your widget tree. It then uses your MessageDao to save that message to your Realtime Database.
  void _sendEvent() {
    if (_canSendEvent()) {
      final message = event.Event(title: _titleController.text, startDate: startDate, endDate: endDate, movieDate: movieDate, movies: selectedMovies );
      widget.eventDao.saveEvent(message);
      _titleController.clear();
      setState(() {});
    }
  }

  bool _eventReady() {
    if(_titleOk() && startDate.isBefore(endDate) && movieDate.isAfter(endDate) && selectedMovies.isNotEmpty) {
      return true;
    }
    return false;
  }

  

  bool _titleOk() {
    String title = _titleController.text;
    if(title == null || title.isEmpty || !_titleIsAvailable(title)) {
      return false;
    }
    return true;
  }

  bool _titleIsAvailable(String value) {
    bool taken = false;
    widget.events.forEach((element) { 
      if(element.title == value) {
        taken = true;
      }
    });
    return !taken;
  }
/*
  Widget _getEventList() {
    return Expanded(
      child: FirebaseAnimatedList(
        controller: _scrollController,
        query: widget.eventDao.getEventQuery(),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final event1 = event.Event.fromJson(json);
          return EventWidget(title: event1.title, startDate: event1.startDate, endDate: event1.endDate, movieDate: event1.movieDate, movies: event1.movies, previousEvents: events,);
        },
      ),
    );
  }*/

  bool _canSendEvent() {
    if(_titleController.text.length <= 0){
      return false;
    }
    if(startDate == null) {
      return false;
    }
    if(endDate == null) {
      return false;
    }
    if(movieDate == null){
      return false;
    }
    return true;
  }
  //bool _canSendEvent() => _eventController.text.length > 0;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  TextStyle myTextStyle = TextStyle(
    color: Colors.blue[800],
    fontSize: 20,
    fontWeight: FontWeight.w300
  );

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime ?pickedDate = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
        //errorInvalidText: ,
    
    );
        
   
    if (pickedDate != null && pickedDate != startDate){
      DateTime latestEventEndDate = DateTime.now();

      widget.events.forEach((element) {
        if(element.endDate.isAfter(latestEventEndDate)) {
          latestEventEndDate = element.endDate;
        }
      });

      if (pickedDate.isAfter(latestEventEndDate)) {
        setState(() {
        startDate = pickedDate;
      });
      }  
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime ?pickedDate = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2030));
   
    if (pickedDate != null && pickedDate != endDate) {
       DateTime latestEventEndDate = DateTime.now();
       widget.events.forEach((element) {
        if(element.endDate.isAfter(latestEventEndDate)) {
          latestEventEndDate = element.endDate;
        }
      });

      if (pickedDate.isAfter(latestEventEndDate)) {
        setState(() {
        endDate = pickedDate;
      });
      }  
    }
  }

  Future<void> _selectMovieDate(BuildContext context) async {
    final DateTime ?pickedDate = await showDatePicker(
        context: context,
        initialDate: movieDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2030));
   
    if (pickedDate != null && pickedDate != movieDate) {
       DateTime latestEventEndDate = DateTime.now();
       widget.events.forEach((element) {
        if(element.endDate.isAfter(latestEventEndDate)) {
          latestEventEndDate = element.endDate;
        }
      });

      if (pickedDate.isAfter(latestEventEndDate)) {
        setState(() {
        movieDate = pickedDate;
      });
      }  
    }
  }
}

class EventList extends StatefulWidget {
  final List<Event> events;
  EventList({Key? key, required this.events}) : super(key: key);

  final eventDao = EventDao();

  @override
  EventListState createState() => EventListState();
}

typedef CallbackFunction = void Function(int, bool);

class MovieSelector extends StatefulWidget {
  final List<Movie> selectedMovies;
  const MovieSelector({ Key? key, required this.selectedMovies }) : super(key: key);

  @override
  _MovieSelectorState createState() => _MovieSelectorState();
}


class _MovieSelectorState extends State<MovieSelector> {
  Future<MovieList> futureMovieList = fetchMovieList();
  List<MovieTile> movieTiles = [];
  bool _selected = false;

  List<Movie> _selectedMovies = [];
  bool isSelected = false;
  
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _selectedMovies = widget.selectedMovies;
    });   
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick movies'), 
        leading: IconButton (
          icon:Icon(
            Icons.arrow_back),
            onPressed:() {
              Navigator.pop(context, widget.selectedMovies);
            },
        ),
      actions: <Widget> [
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: IgnorePointer(
            ignoring: _selected,
            child: GestureDetector(
            onTap: () {
              setState(() {
                if(_selectedMovies.isNotEmpty){                  
                  _selected = true;
                  Navigator.pop(context, _selectedMovies);
                }
                
             });
             
            },
            child: Icon(
              Icons.verified,
              size: 26.0,
            ),
            
            ),
          )
        )
      ],  
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<MovieList>(
                future: futureMovieList,
                builder: (context, snapshot) {
                  
                  if (snapshot.hasData) {
                    int index = 0;
                    List<Widget> movieTitles = [];
                    movieTiles.clear();
                    snapshot.data!.movieList!.forEach((element) { 
                      Movie movie = element;
                     isSelected = false;
                      _selectedMovies.forEach((element) {
                      if(element.title == movie.title){                       
                          isSelected = true;                                        
                      } 
                      });
                      
                                     
                      movieTitles.add(Text(element.title));  
                     
                      MovieTile movieTile = new MovieTile(title: element.title, movie:  element, index: index, callback: (movieId, isAdded) {
                        if(isAdded) {                          
                          setState(() {
                             _selectedMovies.add(element);
                          });
                         
                        }
                        else {                        
                          setState(() {
                            _selectedMovies.remove(element);
                          });
                          
                        }
                      },isSelected: isSelected,);
                      movieTiles.add(movieTile);
                      index ++;
                    });
                    //return Text(snapshot.data!.title);
                    return Column(children: movieTiles,);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
          
                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
      ),
    );

    
  }



    
}



List<Row> _moviesToTitles(List<Movie> _selectedMovies){
      List<Row> movieRows = [];
      _selectedMovies.forEach((element) {
        Row row = new Row(
          children: [
            Text(
              element.title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w200,
                fontSize: 15
              ),
            ),
          ],
        ); 
        movieRows.add(row);
      });
      return movieRows;
    }


class MovieTile extends StatefulWidget {
  final String title;
  final Movie movie;
  final CallbackFunction callback;
  final int index;
  final bool isSelected;
 
  const MovieTile({ Key? key, required this.title, required this.movie, required this.index, required this.callback, required this.isSelected} ) : super(key: key);

  @override
  _MovieTileState createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  
  @override
  Widget build(BuildContext context) {
    print(widget.isSelected);
    return CheckboxListTile(
      title: Text(widget.title),
      value: widget.isSelected,
      onChanged: (bool? value) {
        setState((){          
           widget.callback(widget.index, value!);
        }
          
        );
      },
    activeColor: Colors.blueGrey,
    checkColor: Colors.white
    );
  }
}
