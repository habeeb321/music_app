import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/view/screens/homescreen/view/library/mostly/controller/get_mostlyplayed_controller.dart';
import 'package:music_app/view/screens/homescreen/view/library/mostly/controller/mostly_controller.dart';
import 'package:music_app/model/functions/favorite_db.dart';
import 'package:music_app/view/screens/favoritescreen/view/favorite_button.dart';
import 'package:music_app/view/screens/musicplayingscreen/view/music_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MostlyPlayed extends StatelessWidget {
  MostlyPlayed({super.key});

  final OnAudioQuery _audioQuery = OnAudioQuery();

  MostlyController mostlyController = Get.put(MostlyController());

  @override
  Widget build(BuildContext context) {
    mostlyController.init();
    FavoriteDb.favoriteSongs;
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF01C3CC),
            Color(0xFF2A89DA),
            Color(0xFF7D2AE7),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Most Played Songs'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: GetMostlyPlayedController.getMostlyPlayedSongs(),
                  builder: (BuildContext context, items) {
                    return ValueListenableBuilder(
                      valueListenable:
                          GetMostlyPlayedController.mostlyPlayedNotifier,
                      builder: (BuildContext context, List<SongModel> value,
                          Widget? child) {
                        if (value.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Center(
                              child: Column(
                                children: [
                                  Image.asset('assets/images/no songs.png'),
                                  const Text(
                                    'Most played songs are not available',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          //GetMostlyPlayedController.mostlyPlayedSong.toSet().toList();
                          return FutureBuilder<List<SongModel>>(
                            future: _audioQuery.querySongs(
                              sortType: null,
                              orderType: OrderType.ASC_OR_SMALLER,
                              uriType: UriType.EXTERNAL,
                              ignoreCase: true,
                            ),
                            builder: (context, item) {
                              if (item.data == null) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (item.data!.isEmpty) {
                                return const Center(
                                    child: Text(
                                  'No Songs Available',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ));
                              }
                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minVerticalPadding: 10.0,
                                    tileColor: const Color.fromARGB(
                                        255, 212, 231, 255),
                                    contentPadding: const EdgeInsets.all(0),
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: QueryArtworkWidget(
                                        id: GetMostlyPlayedController
                                            .mostlyPlayedSong[index].id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 5, 5, 5),
                                          child: Icon(Icons.music_note),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      GetMostlyPlayedController
                                          .mostlyPlayedSong[index]
                                          .displayNameWOExt,
                                      maxLines: 1,
                                    ),
                                    subtitle: Text(
                                      '${GetMostlyPlayedController.mostlyPlayedSong[index].artist == "<unknown>" ? "Unknown Artist" : GetMostlyPlayedController.mostlyPlayedSong[index].artist}',
                                      maxLines: 1,
                                    ),
                                    trailing: FavoriteButton(
                                        songFavorite: GetMostlyPlayedController
                                            .mostlyPlayedSong[index]),
                                    onTap: () {
                                      GetAllSongController.audioPlayer
                                          .setAudioSource(
                                              GetAllSongController
                                                  .createSongList(
                                                      GetMostlyPlayedController
                                                          .mostlyPlayedSong),
                                              initialIndex: index);
                                      GetAllSongController.audioPlayer.play();
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return MusicPlayingScreen(
                                          songModelList:
                                              GetAllSongController.playingSong,
                                        );
                                      }));
                                    },
                                  );
                                },
                                itemCount: GetMostlyPlayedController
                                    .mostlyPlayedSong.length,
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    height: 10.0,
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}