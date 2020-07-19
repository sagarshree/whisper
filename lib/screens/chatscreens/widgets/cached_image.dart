import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whisper/screens/chatscreens/widgets/full_screen_Image.dart';
import 'package:whisper/utils/universal_constants.dart';

class CachedImage extends StatelessWidget {
  final String url;
  CachedImage({
    @required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FullScreenImage(url: url);
      })),
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        width: 200.0,
        height: 250.0,
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                url,
              ),
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: UniversalVariables.separatorColor),
      ),
    );
  }
}

// return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       child: GestureDetector(
//         onTap: () =>
//             Navigator.push(context, MaterialPageRoute(builder: (context) {
//           return FullScreenImage(url: url);
//         })),
//         child: CachedNetworkImage(
//           imageUrl: url,
//           placeholder: (context, url) => Center(
//             child: CircularProgressIndicator(),
//           ),
//         ),
//       ),
//     );
