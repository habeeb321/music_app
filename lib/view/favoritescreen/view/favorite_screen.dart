import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/controller/get_all_song.dart';
import 'package:music_app/view/homescreen/view/library/recently/controller/get_recent_song_controller.dart';
import 'package:music_app/model/functions/favorite_db.dart';
import 'package:music_app/view/musicplayingscreen/view/music_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteDb.favoriteSongs,
      builder: (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Favorite'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Favorites',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  ValueListenableBuilder(
                    valueListenable: FavoriteDb.favoriteSongs,
                    builder: (BuildContext ctx, List<SongModel> favoriteData,
                        Widget? child) {
                      if (favoriteData.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 70, left: 10),
                          child: Column(
                            children: [
                              Image.asset('assets/images/nofavorites.png'),
                              const Text(
                                'No Favorite Songs',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: favoriteData.length,
                          itemBuilder: (ctx, index) {
                            return ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minVerticalPadding: 10.0,
                              tileColor:
                                  const Color.fromARGB(255, 212, 231, 255),
                              contentPadding: const EdgeInsets.all(0),
                              onTap: () {
                                List<SongModel> favoriteList = [
                                  ...favoriteData
                                ];
                                GetAllSongController.audioPlayer.stop();
                                GetAllSongController.audioPlayer.setAudioSource(
                                    GetAllSongController.createSongList(
                                        favoriteList),
                                    initialIndex: index);
                                GetAllSongController.audioPlayer.play();
                                GetRecentSongController.addRecentlyPlayed(
                                    favoriteList[index].id);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => MusicPlayingScreen(
                                      songModelList: favoriteList,
                                    ),
                                  ),
                                );
                              },
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: QueryArtworkWidget(
                                  id: favoriteData[index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: const Padding(
                                    padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                                    child: Icon(Icons.music_note),
                                  ),
                                ),
                              ),
                              title: Text(
                                favoriteData[index].displayNameWOExt,
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                favoriteData[index].artist.toString(),
                                maxLines: 1,
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    FavoriteDb.favoriteSongs.notifyListeners();
                                    FavoriteDb.delete(favoriteData[index].id);
                                    Get.snackbar('Favorites',
                                        'Song Deleted From Your Favorites',
                                        colorText: Colors.white,
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red.shade400);
                                  },
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )),
                            );
                          },
                          separatorBuilder: (BuildContext context, index) {
                            return const Divider(
                              height: 10.0,
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
