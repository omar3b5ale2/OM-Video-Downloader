import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import '../constants/custom_colors.dart';
import '../constants/custom_texts.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppUpdateInfo? _updateInfo;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _showSnake([String? text]) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(text!),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
      InAppUpdate.performImmediateUpdate().catchError((e) {
        _showSnake(e.toString());
        return e;
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backGroundColor,
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //1
                  Text(
                    CustomTexts.stText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 80.0,
                      color: CustomColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //2
                  Text(
                    CustomTexts.ndText,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontSize: 35.0,
                      color: CustomColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //3
                  Text(
                    CustomTexts.rdText,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontSize: 20.0,
                      color: CustomColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  //4
                  Text(
                    CustomTexts.rthText,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontSize: 50.0,
                      color: CustomColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Multiple',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 35.0,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        'Source',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 45.0,
                          color: CustomColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  //5
                  Text(
                    CustomTexts.ethText,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontSize: 20.0,
                      color: CustomColors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
