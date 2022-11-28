import 'dart:io';

import 'package:flutter/material.dart';
import 'package:musicapp/repository_api/repository_musiclist.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/music_list.dart';
import 'package:http/http.dart' as http;

class MusicSongs extends StatefulWidget {
  int? trackId;
  Track? models;
  MusicSongs({Key? key, this.trackId, this.models}) : super(key: key);

  @override
  State<MusicSongs> createState() => _MusicSongsState(trackId, models);
}

class _MusicSongsState extends State<MusicSongs> {
  _MusicSongsState(this.trackId, this.models);
  int? trackId;
  Track? models;
  bool isLock = false;
  double width = 0.0;
  double height = 0.0;
  bool isLoading = false;
  bool isSyncLock = false;
  List<TrackList> trackLists = [];
  late final Uri _url;
  @override
  void initState() {
    _url = Uri.parse(widget.models!.trackShareUrl!);

    super.initState();
    songFunction();
    lyricsFunction();
    _launchUrl();
  }

  songFunction() {
    try {
      setState(() {
        isLoading = true;
      });
      songsMusic(trackId!).then((value) {
        if (value.message!.header!.statusCode == 200) {
          setState(() {});
        }
        setState(() {
          isLoading = false;
        });
      });
    } on SocketException catch (e) {
      // toast('No internet connection');
    }
  }

  lyricsFunction() {
    setState(() {
      isLoading = true;
    });
    lyricsMusic(trackId!).then((value) {
      if (value.message!.header!.statusCode == 200) {
        setState(() {
          trackLists = value.message!.body!.trackList!;
        });
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw '$_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text(widget.trackId.toString())),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              _launchUrl();
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Text(widget.models!.artistName!.toString(),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Text(widget.models!.trackName!.toString(),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Text(widget.models!.albumName!.toString(),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
