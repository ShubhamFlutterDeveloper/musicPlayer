import 'package:flutter/material.dart';
import 'package:musicplayer/audioPlayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';


class SongList extends StatefulWidget {
  const SongList({Key? key}) : super(key: key);

  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {

  List<SongModel> allSongList = [];
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool isLoading = true;
 // int currentIndex=0;
  @override
  void initState() {
    super.initState();
   // permissions().then((value) => getAllSongList());
    getAllSongList();
  }

 /* Future<void> permissions()async{
    await Permission.storage.request();
  }*/

  getAllSongList() async {
    allSongList = await _audioQuery.querySongs();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(
          backgroundColor: Colors.grey,
          title: Text('Playlist'),
        ),
      //   backgroundColor: Colors.blue.shade200,
        body: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 1,
                  focal: Alignment.topCenter,
                  tileMode: TileMode.clamp,
                //  begin: Alignment.topCenter,
                  //end: Alignment.bottomCenter,
                  stops: [0.2,1.0],
                  colors:[Color(0xffdecba4),
                    Color(0xff3e5151)]
              )
          ),
          child: ListView.builder(
            itemCount: allSongList.length,
              itemBuilder: (context, i) =>
                  InkWell(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(
                    builder: (context) => Music(songModel:allSongList[i], allSongList: allSongList, index: i,),));
                },
                child: Container(
                    key: ValueKey(allSongList[i]),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          QueryArtworkWidget(
                            id:allSongList[i].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: Container(
                              height: 55,
                              width: 55,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                                image: DecorationImage(
                                  image: AssetImage('assets/Micon.png'),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 50),

                          SizedBox(
                            width: 210,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${allSongList[i].title}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height:2),
                                Text(
                                  "${allSongList[i].artist}",
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                     color: Colors.black38,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.more_vert_outlined)
                        ],
                      ),
                    ),
        ),
              ),
    ),
        )
    )
    );
  }
/*  void changeTrack(bool isNext) {
    if(isNext)  {
      if(currentIndex!=allSongList.length-1)  {
        currentIndex++;
      }
    } else  {
      if(currentIndex!=0) {
        currentIndex--;
      }
    }
  }*/
}

