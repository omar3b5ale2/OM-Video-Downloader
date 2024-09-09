import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:videovdownloader/constants/custom_colors.dart';
import 'package:videovdownloader/models/video_download_model.dart';
import 'package:intl/intl.dart';
import 'package:videovdownloader/repository/video_downloader_repository.dart';

import '../models/video_quality_model.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key, required this.onDownloadCompleted})
      : super(key: key);
  final VoidCallback onDownloadCompleted;
  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final _controller = TextEditingController();
  var _progressValue = 0.0;
  var _isDownloading = false;
  List<VideoQualityModel>? _qualities = [];
  VideoDownloadModel? _video;
  bool _isLoading = false;
  int _selectedQualityIndex = 0;
  String _filleName = '';
  bool _isSearching = false;
  VideoType _videoType = VideoType.none;

  IconData? get _getBrandIcon {
    switch (_videoType) {
      case VideoType.facebook:
        return FontAwesome.facebook;
      case VideoType.youtube:
        return FontAwesome.youtube_play;
      case VideoType.twitter:
        return FontAwesome.twitter;
      case VideoType.instagram:
        return FontAwesome.instagram;
      case VideoType.tiktok:
        return const IconData(0xf058c, fontFamily: 'MaterialIcons');
      default:
        return null;
    }
  }

  String? get _getFilePrefix {
    switch (_videoType) {
      case VideoType.facebook:
        return "Facebook";
      case VideoType.youtube:
        return "Youtube";
      case VideoType.twitter:
        return "Twitter";
      case VideoType.instagram:
        return "Instagram";
      case VideoType.tiktok:
        return "Tiktok";
      default:
        return null;
    }
  }

  void _setVideoType(String url) {
    if (url.isEmpty) {
      setState(() => _videoType = VideoType.none);
    } else if (url.contains("facebook.com") || url.contains("fb.watch")) {
      setState(() => _videoType = VideoType.facebook);
    } else if (url.contains("youtube.com") || url.contains("youtu.be")) {
      setState(() => _videoType = VideoType.youtube);
    } else if (url.contains("twitter.com")) {
      setState(() => _videoType = VideoType.twitter);
    } else if (url.contains("instagram.com")) {
      setState(() => _videoType = VideoType.instagram);
    } else if (url.contains("tiktok.com")) {
      setState(() => _videoType = VideoType.tiktok);
    } else {
      setState(() => _videoType = VideoType.none);
    }
  }

  _showSnackBar(String title, int duration) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: duration),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.w),
        ),
        margin: EdgeInsets.all(15.w),
        backgroundColor: CustomColors.backGroundColor,
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: CustomColors.white,
              size: 30.w,
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.fade,
                style: GoogleFonts.poppins(
                  fontSize: 18.0,
                  color: CustomColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performDownloading(String url) async {
    Dio dio = Dio();
    var permissions = await [Permission.storage].request();

    if (permissions[Permission.storage]!.isGranted) {
      var dir = await getApplicationDocumentsDirectory();
      setState(() {
        _filleName =
            "/$_getFilePrefix-${(DateFormat("yyyyMMddHHmmss").format(DateTime.now()))}.mp4";
      });

      var path = dir.path + _filleName;

      try {
        setState(() => _isDownloading = true);
        await dio.download(
          url,
          path,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() => _progressValue = (received / total * 100));
            }
          },
          deleteOnError: true,
        ).then((_) async {
          widget.onDownloadCompleted();

          setState(() {
            _isDownloading = false;
            _progressValue = 0.0;
            _videoType = VideoType.none;
            _isLoading = false;
            _qualities = [];
            _video = null;
          });
          _controller.text = "";
          _showSnackBar("video downloaded successfully.", 2);
        });
      } on DioException catch (value) {
        setState(() {
          _videoType = VideoType.none;
          _isDownloading = false;
          _qualities = [];
          _video = null;
        });
        _showSnackBar("Download failed.", 2);
      }
    } else {
      _showSnackBar("No permission to read or write!!", 2);
    }
  }

  Future<void> _onLinkPasted(String url) async {
    var response = await VideoDownloaderRepository().getVideos(url);
    setState(() => _video = response);
    if (_video != null) {
      for (var _quality in _video!.videos!) {
        _qualities!.add(_quality);
      }
      _showBottomModel();
    } else {
      _qualities = null;
    }
    setState(() => _isSearching = false);
  }

  _showBottomModel() {
    showModelBottomSheet(
        context: context,
        backgroundColor: CustomColors.backGroundColor,
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.w),
            topRight: Radius.circular(15.w),
          ),
        ),
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Video Quality",
                        style: GoogleFonts.poppins(
                          fontSize: 20.0,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.menu))
                    ],
                  ),
                ),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

enum VideoType { youtube, facebook, instagram, twitter, tiktok, none }
