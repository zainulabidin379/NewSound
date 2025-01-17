import 'dart:convert';
import 'dart:io';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'package:newsound/Models/channel_model.dart';
import 'package:newsound/Models/video_model.dart';
import 'package:flutter_config/flutter_config.dart';

class APIService {
  APIService._instantiate();
  static final APIService instance = APIService._instantiate();

  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<Channel> fetchChannel({required String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': FlutterConfig.get('API_KEY'),
    };

    Uri uri = Uri.https(
      _baseUrl,
      'youtube/v3/channels',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    //Get channel
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMaP(data);

      //Fetch first batch of videos from uploads playlist
      channel.videos = await fetchVideosFromPlaylist(
        playlistId: channel.uploadPlaylistId!,
      );
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchVideosFromPlaylist(
      {required String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': FlutterConfig.get('API_KEY'),
    };

    Uri uri = Uri.https(
      _baseUrl,
      'youtube/v3/playlistItems',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'applicaiton/json',
    };

    //Get playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      //Fetch first eight videos from upload playlist
      List<Video> videos = [];
      videosJson.forEach((json) => videos.add(
            Video.fromMap(json['snippet']),
          ));
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
