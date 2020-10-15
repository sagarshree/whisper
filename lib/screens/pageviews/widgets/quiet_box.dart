import 'package:flutter/material.dart';
import 'package:whisper/screens/search_screen.dart';
import 'package:whisper/utils/universal_constants.dart';

class QuietBox extends StatelessWidget {
  final String title;
  final String subtitle;

  const QuietBox({@required this.title, @required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          decoration: BoxDecoration(
            color: UniversalVariables.separatorColor,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Colors.white),
              ),
              SizedBox(
                height: 25,
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: UniversalVariables.lightBlueColor,
                child: Text(
                  'Search Contacts',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return SearchScreen();
                })),
              )
            ],
          ),
        ),
      ),
    );
  }
}
