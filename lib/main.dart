import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/services.dart';
import 'package:chandrhas/theme/settings.dart';
import 'package:chandrhas/theme/themes.dart';
import 'Cart.dart';
import 'Profile.dart';
import 'WishList.dart';
import 'theme/variables.dart';
import 'Login.dart';
import 'business/AuthService.dart';
import 'Notification.dart';
import 'theme/themeProvider.dart';
import 'theme/themes.dart';
import 'package:firebase_core/firebase_core.dart';




// void main() => runApp(
//   // ChangeNotifierProvider<ThemeNotifier>(
//   //   builder: (_) => ThemeNotifier(),
//   //   child: MyApp(),
//   // ),
//  MyApp(),
//  );

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // Set portrait orientation
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
      
    return MaterialApp(
      title: 'Vivlin Mart',
      
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      color: primary,
  //  theme: Provider.of<Settings>(context).isDarkMode
  //         ? setDarkTheme
  //         : setLightTheme,
    theme: ThemeData(
      
        primaryColor: primary,
        textTheme: TextTheme(
          title: TextStyle(fontFamily: "Roboto-Slab"),
          body1: TextStyle(fontFamily: "Roboto-Slab"),
        ),
      ),
   
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new MyHomePage(),
        '/login': (BuildContext context) => new Login(),
        '/wishlist': (BuildContext context) => new WishList(),
        '/cart': (BuildContext context) => new Cart(),
        '/profile': (BuildContext context) => new Profile(),
        '/notification': (BuildContext context) => new Notifications(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var a = AuthService().checkLogin();

    print("State : $a");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SplashScreen(
          seconds: 4,
          routeName: "/",
         gradientBackground: LinearGradient(
           begin: Alignment.topCenter,
           end: Alignment.bottomCenter,
           colors: [primary,Color(0xffcc0002)],
           ),
          // backgroundColor: Colors.red[300].withOpacity(0.8),
          // imageBackground: AssetImage("assets/LoadImage.jpg"),          
          image: Image.asset("assets/LoadImage.png",fit: BoxFit.cover,),
          photoSize: 100.0,
          onClick: () => print("Welcome To Chandrhas"),
          loadingText: Text(
            "Welcome To Chandrhas",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          loaderColor: Colors.white,
          navigateAfterSeconds: AuthService().handleAuth(),
        ),
      ),
    );
  }
}


class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}

ThemeData _buildLightTheme() {
  return ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    accentColor: Colors.black,
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
  );
}

ThemeData _buildDarkTheme() {
  return ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
  );
}
