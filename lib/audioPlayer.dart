
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
class Music extends StatefulWidget {
   SongModel songModel;
  List<SongModel> allSongList;
   int index;
//  Function changeTrack;
   Music({Key? key, required this.songModel,required this.allSongList, required this.index}) : super(key: key);

  @override
  State<Music> createState() => _MusicState();

}
class _MusicState extends State<Music> {
  AudioPlayer audioPlayer= AudioPlayer();
  bool isPlaying =false;
  Duration duration=Duration.zero;
  Duration position=Duration.zero;
  String formatTime(int seconds){
  return '${(Duration(seconds:seconds))}'.split('.')[0].padLeft(8,'0');
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer.play(
        UrlSource(widget.songModel.data),
        mode: PlayerMode.mediaPlayer
    );
     audioPlayer.onPlayerStateChanged.listen((state) {
       setState(() {
         isPlaying = state == PlayerState.playing;
       });
     });
      audioPlayer.onDurationChanged.listen((newDuration) {
        setState(() {
          duration=newDuration;
          print("duration--->> $newDuration");
        });
      });
      audioPlayer.onPositionChanged.listen((newPosition) {
        setState(() {
          position= newPosition;
          print("position--->> $position");
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
                  radius: 1,
                  focal: Alignment.topCenter,
                  tileMode: TileMode.mirror,
                  //  begin: Alignment.topCenter,
                  //end: Alignment.bottomCenter,
                  stops: [0.2,1.0],
                  colors:[Color(0xffdecba4),
                    Color(0xff3e5151)]
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QueryArtworkWidget(
                keepOldArtwork: true,
                artworkHeight: 250,
                artworkWidth: 330,
                id:widget.songModel.id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Container(
                  height: 250,
                  width: 330,
                  padding:EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: AssetImage('assets/Micon.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(height:10),
              Text(widget.songModel.displayName,
                style: TextStyle(fontSize: 24,color: Colors.black),
              textAlign: TextAlign.center,
              ),
              Text(widget.songModel.artist.toString(),
                  style: TextStyle(fontSize: 15,color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50,
              ),
              Slider(
                activeColor: Colors.black,
                inactiveColor: Colors.black12,
                thumbColor: Colors.black38,
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) {
                  final position = Duration(seconds: value.toInt());
                  audioPlayer.seek(position);
                  audioPlayer.resume();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatTime(position.inSeconds)),
                    Text(formatTime((duration-position).inSeconds)),
                  ],
                ),
              ),
              SizedBox(
              ),
              Container(
                height: 120,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(onPressed: (){},
                        icon:Icon(Icons.playlist_add_sharp,size: 30),color: Colors.black),
                    CircleAvatar(
                      backgroundColor: Colors.black26,
                      radius: 20,
                      child: IconButton(
                        onPressed: (){
                          widget.songModel.id == widget.allSongList[widget.index].id? {
                            widget.index--,
                            widget.songModel = widget.allSongList[widget.index]
                          }
                              :null;
                          setState(() {
                          });

                        },
                        icon: Icon(Icons.fast_rewind_outlined,color: Colors.black,),
                        iconSize:25,
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.black26,
                      radius: 30,
                      child: IconButton(
                        onPressed: (){
                          if(isPlaying){
                            audioPlayer.pause();
                          }else{
                            audioPlayer.play(
                                UrlSource(widget.songModel.data),
                               // mode: PlayerMode.mediaPlayer
                            );
                          }
                          setState(() {
                            isPlaying=!isPlaying;
                          });
                        },
                        icon: Icon(isPlaying? Icons.pause:Icons.play_arrow,color: Colors.black,),
                        iconSize:40,
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.black26,
                      radius:20,
                      child:InkWell(
                          onTap: (){

                            widget.songModel.id == widget.allSongList[widget.index].id? {
                            print('hello'),
                            widget.index++,
                                    widget.songModel = widget.allSongList[widget.index]
                                  }
                                :null;
                            setState(() {
                            });
                          },
                          child: Icon(Icons.fast_forward_outlined,color: Colors.black)),
                    ),
                    IconButton(onPressed: (){},
                        icon:Icon(Icons.more_horiz_outlined,size: 30),color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
