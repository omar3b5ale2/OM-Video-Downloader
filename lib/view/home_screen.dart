import 'dart:io';

import 'package:file_manager/controller/file_manager_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:videovdownloader/constants/custom_colors.dart';
import 'package:videovdownloader/constants/custom_texts.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final FileManagerController _controller = FileManagerController();
  List<VideoData> _videoData = [];
  List<FileSystemEntity> _downloads = [];
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _getDownloads() async {
    setState(() {
      _downloads = [];
      _videoData = [];
    });
    final videoInfo = FlutterVideoInfo();
    final directory = await getApplicationDocumentsDirectory();
    final dir = directory.path;
    final myDir = Directory(dir);
    final List<FileSystemEntity> _folders =
        myDir.listSync(recursive: true, followLinks: false);
    List<FileSystemEntity> _data = [];

    for(var item in _folders )
    {
      if(item.path.contains('.mp4'))
      {
        _data.add(item);
        var _info = await videoInfo.getVideoInfo(item.path);
        _videoData.add(_info!);
      }
    }
    setState(() {
      _downloads = _data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:CustomColors.backGroundColor,
      appBar: AppBar
        (
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.backGroundColor,
        elevation: 0,
        title: Text
          (
          CustomTexts.appBarTittle,
          style: GoogleFonts.poppins
            (
            fontSize: 26.0,
            color: CustomColors.white,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const[
          SizedBox(),
          SizedBox(),
          SizedBox(),
          SizedBox(),
        ],
      ),
      bottomNavigationBar:WaterDropNavBar(
        backgroundColor: CustomColors.backGroundColor,
        bottomPadding: 12.h,
        waterDropColor: CustomColors.primary,
        inactiveIconColor: CustomColors.primary,
        iconSize: 28.w,
        onItemSelected: (int index)
        {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.jumpToPage(_selectedIndex);
        },
        selectedIndex: _selectedIndex,
        barItems:
        [
         BarItem(filledIcon: Icons.home,outlinedIcon: Icons.home_outlined),
         BarItem(filledIcon: Icons.file_download,outlinedIcon: Icons.file_download_outlined),
         BarItem(filledIcon: Icons.video_library_rounded,outlinedIcon: Icons.video_library_outlined),
         BarItem(filledIcon: Icons.info,outlinedIcon: Icons.info_outline),
        ],
      )
      ,
    );
  }
}
