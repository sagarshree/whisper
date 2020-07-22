import 'package:flutter/material.dart';
import 'package:whisper/screens/search_screen.dart';
import 'package:whisper/utils/universal_constants.dart';

class QuietBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'This is where all the contacts are listed',
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
                'Search for your friends and family members to get connected with them',
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
