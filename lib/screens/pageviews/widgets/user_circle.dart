import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisper/provider/user_provider.dart';
import 'package:whisper/screens/pageviews/widgets/user_details.dart';
import 'package:whisper/utils/universal_constants.dart';
import 'package:whisper/utils/utils.dart';

class UserCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: UniversalVariables.blackColor,
        builder: (context) => UserDetailsContainer(),
        isScrollControlled: true,
      ),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: UniversalVariables.separatorColor,
        ),
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundColor: UniversalVariables.separatorColor,
                  backgroundImage: CachedNetworkImageProvider(
                      userProvider.getUser.userPhoto),
                )),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 13,
                width: 13,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: UniversalVariables.blackColor,
                      width: 2.0,
                    ),
                    color: UniversalVariables.onlineDotColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Text(
//               Utils.getInitials(userProvider.getUser.name),
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: UniversalVariables.lightBlueColor,
//                 fontSize: 20.0,
//               ),
//             ),
