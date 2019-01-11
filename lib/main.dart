import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:custom_chewie/custom_chewie.dart';
import 'package:image_firebase/camera.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';


// A List of Cameras
List<CameraDescription> cameras;

void main() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e);
  }
  runApp(MaterialApp(
    home: MyApp(),
  ));
}


/*
  Page: Main Page that get Video From Firebase Storage and Play it in Video Player
*/
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // Video Player Controller Must contain URL
  VideoPlayerController url;

  String video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final StorageReference storageReference =
              FirebaseStorage.instance.ref().child('samplevideo.mp4');
          var videoURL = await storageReference.getDownloadURL();
          setState(() {
            url = VideoPlayerController.network(videoURL);
          });
        },
        child: new Icon(Icons.video_library),
      ),
      body: Center(
          child: url == null
              ? InkWell(
                  child:
                      video == null ? Text('Capture Video') : Text('Uploaded'),
                  onTap: () {
                    setState(() {
                      video = 'Not Null';
                    });
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CameraApp()));
                  },
                )
              : new Chewie(
                  url,
                  aspectRatio: 3 / 2,
                  autoPlay: true,
                  looping: true,
                  showControls: true,
                )),
    );
  }
}
