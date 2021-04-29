import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cbah/user.dart';
import 'package:cbah/components/button.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _firestore = FirebaseFirestore.instance;

  int slots = 100;
  static final NUMBER_SLOTS = 50;

  bool bookButtonEnabled = true;

  DateTime dateFriday;
  String dateFridayString;

  /// @param dayOfWeek equivalent to number of the week (Monday=1...Sunday=7);
  DateTime getDates(int dayOfWeek){
    var now = DateTime.now();

    var returnDate = now.add(Duration(days: (dayOfWeek - now.weekday + 7)%7));

    return returnDate;
  }

  String getDateString(DateTime dateTime){
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  void setSlots(String dateTimeId) async{
    var temp = await _firestore.collection('slots').doc(dateTimeId).snapshots().first;
    setState(() {
      if(temp.data() == null){
        slots = NUMBER_SLOTS;
        _firestore.collection('slots').doc(dateTimeId).set({
          'number': slots,
          'attendants': [],
        });
      }
      else{
        print(temp.data());
        print(dateTimeId);
        slots = temp.data()['number'];
      }
    });

  }

  void setAttendance(String dateTimeId)async{
    var temp = await _firestore.collection('slots').doc(dateTimeId).snapshots().first;

    List<String> listAttendants = List.from(temp.data()['attendants']);
    print(listAttendants);
    setState(() {
      Usr.attending = listAttendants.contains(Usr.email);
      if (Usr.attending){
        bookButtonEnabled = false;
      }
    });
  }

  void book(String dateTimeId) async{
    var temp = await _firestore.collection('slots').doc(dateTimeId).snapshots().first;
    slots = temp.data()['number'];

    setState(() {
      slots = temp.data()['number'];
      if(slots <= 0){
        bookButtonEnabled = false;
        return;
      }
      slots -= 1;

      _firestore.collection('slots').doc(dateTimeId).set({
        'number': slots,
        'attendants': temp.data()['attendants'] + [Usr.email],
      });

      bookButtonEnabled = false;
      Usr.attending = true;
    });
  }

  void unbook(String dateTimeId) async{
    var temp = await _firestore.collection('slots').doc(dateTimeId).snapshots().first;
    slots = temp.data()['number'];

    setState(() {
      slots = temp.data()['number'];
      if(!Usr.attending){
        return;
      }
      slots += 1;

      List<String> listAttendants = List.from(temp.data()['attendants']);
      listAttendants.removeWhere((element) => element == Usr.email);

      _firestore.collection('slots').doc(dateTimeId).set({
        'number': slots,
        'attendants': listAttendants,
      });

      bookButtonEnabled = true;
      Usr.attending = false;
    });
  }

  String getDateId(DateTime dateTime){
    return '${dateTime.day}${dateTime.month}${dateTime.year}b';
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      dateFriday =  getDates(5);
      dateFridayString = getDateString(dateFriday);
      setSlots(getDateId(dateFriday));
      setAttendance(getDateId(dateFriday));

      if (slots <= 0 || Usr.attending){
        bookButtonEnabled = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Hello ${Usr.name}!'),
        Text('Next volunteering day is on $dateFridayString!'),
        Text('There are $slots available!'),
        Button(
          tag: 'book',
          enabled: bookButtonEnabled,
          function: (){book(getDateId(dateFriday));},
          text: 'Book slot',
        ),
        Button(
          tag: 'unbook',
          enabled: (!bookButtonEnabled && Usr.attending),
          function: (){unbook(getDateId(dateFriday));},
          text: 'Unbook slot',
        ),
      ],
    );
  }
}
