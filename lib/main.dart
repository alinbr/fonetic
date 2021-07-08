import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fonetic/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(428, 926),
      builder: () => MaterialApp(
        title: 'Fonetic',
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
          scaffoldBackgroundColor: const Color(0xFF131418),
          backgroundColor: const Color(0xFF1d212b),
          accentColor: const Color(0xFF1A112F),
          primaryColor: const Color(0xFF121212),
          iconTheme: const IconThemeData().copyWith(color: Colors.white),
          fontFamily: 'Montserrat',
          textTheme: TextTheme(
            headline2: TextStyle(
              color: Colors.white,
            ),
            headline4: TextStyle(
              color: Colors.white,
            ),
            bodyText1: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
            ),
            bodyText2: TextStyle(
              color: const Color(0xFF505366),
              fontSize: 16.sp,
            ),
          ),
        ),
        themeMode: ThemeMode.dark,
        home: HomeScreen(),
      ),
    );
  }
}
