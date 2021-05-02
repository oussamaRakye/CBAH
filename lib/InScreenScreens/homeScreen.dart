import 'package:cbah/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cbah/user.dart';
import 'package:cbah/components/button.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _firestore = FirebaseFirestore.instance;

  static int slots = 100;
  int maxSlots;

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
    var slotsDetails = await _firestore.collection('slotsDetails').doc('details').snapshots().first;
    maxSlots = slotsDetails.data()['slots'];
    setState(() {
      if(temp.data() == null){
        slots = slotsDetails.data()['slots'];
        _firestore.collection('slots').doc(dateTimeId).set({
          'attendants': [],
        });
      }
      else{
        print(temp.data());
        print(dateTimeId);
        slots = maxSlots - List.from(temp.data()['attendants']).length;
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

    setState(() {
      slots = maxSlots - List.from(temp.data()['attendants']).length;
      if(slots <= 0){
        bookButtonEnabled = false;
        return;
      }
      slots -= 1;

      _firestore.collection('slots').doc(dateTimeId).set({
        'attendants': temp.data()['attendants'] + [Usr.email],
      });

      bookButtonEnabled = false;
      Usr.attending = true;
    });
  }

  void unbook(String dateTimeId) async{
    var temp = await _firestore.collection('slots').doc(dateTimeId).snapshots().first;

    setState(() {
      if(!Usr.attending){
        return;
      }
      slots += 1;

      List<String> listAttendants = List.from(temp.data()['attendants']);
      listAttendants.removeWhere((element) => element == Usr.email);

      _firestore.collection('slots').doc(dateTimeId).set({
        'attendants': listAttendants,
      });

      bookButtonEnabled = true;
      Usr.attending = false;
    });
  }

  String getDateId(DateTime dateTime){
    return '${dateTime.day}${dateTime.month}${dateTime.year}bb';
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
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hello ${Usr.name}!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40.0),
            ),
            Text(
              'Next volunteering day is on $dateFridayString!',
              textAlign: TextAlign.center,
            ),
            //Text('There are $slots available!'),
            // Button(
            //   tag: 'book',
            //   enabled: bookButtonEnabled,
            //   function: (){book(getDateId(dateFriday));},
            //   text: 'Book slot',
            // ),
            Button(
              tag: 'book',
              enabled: bookButtonEnabled,
              height: MediaQuery.of(context).size.width*0.75,
              shapeBorder: CircleBorder(side: BorderSide.none),
              function: (){book(getDateId(dateFriday));},
              child: Column(
                children: [
                  Text('You are${Usr.attending ? ' ' : ' not '}attending', style: TextStyle(color: background)),
                  Text('Book slot', style: TextStyle(color: background, fontSize: 30.0)),
                  Text('$slots slots available', style: TextStyle(color: background)),
                ],
              ),
            ),
            Button(
              tag: 'unbook',
              enabled: (!bookButtonEnabled && Usr.attending),
              function: !(!bookButtonEnabled && Usr.attending) ? null : (){unbook(getDateId(dateFriday));},
              text: 'Unbook slot',
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Button(
              tag: 'directions',
              text: 'Get me there!',
              function: () async {
                double lat = 51.509514;
                double lng = -0.124244;
                //var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
                var uri = Uri.parse("geo:$lat,${lng}?q=$lat,$lng");
                //var uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
                if (await canLaunch(uri.toString())) {
                  await launch(uri.toString());
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
