import 'package:firebase_database/firebase_database.dart' as firebase;
import 'event.dart';

//create a DatabaseReference which references a node called events
//This code looks for a JSON document inside your Realtime Database called events. 
//If it doesn’t exist, Firebase will create it.
class EventDao {
  final firebase.DatabaseReference _eventsRef =
      firebase.FirebaseDatabase.instance.reference().child('events');

//Now you need MessageDao to perform two functions: saving and retrieving.
//This function takes a Message as a parameter and uses your DatabaseReference to save the JSON message to your Realtime Database.

void saveEvent(Event event) {
  _eventsRef.push().set(event.toJson());
}

//For the retrieval method you only need to expose a Query since you’ll use a cool widget called a FirebaseAnimatedList
// which interacts directly with your DatabaseReference.

firebase.Query getEventQuery() {
  return _eventsRef;
}
//Alright, now you have your message DAO. As the name states, the data access object helps you access whatever data you have 
//stored at the given Realtime Database reference. It will also let you store new data, as you send messages. 


}