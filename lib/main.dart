import 'package:flutter/material.dart';
import 'package:flutter_app_course/scr/providers/app.dart';
import 'package:flutter_app_course/scr/providers/category.dart';
import 'package:flutter_app_course/scr/providers/product.dart';
import 'package:flutter_app_course/scr/providers/restaurant.dart';
import 'package:flutter_app_course/scr/providers/user.dart';
import 'package:flutter_app_course/scr/screens/home.dart';
import 'package:flutter_app_course/scr/screens/login.dart';
import 'package:flutter_app_course/scr/screens/splash.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppProvider()),
        ChangeNotifierProvider.value(value: UserProvider.initialize()),
        ChangeNotifierProvider.value(value: CategoryProvider.initialize()),
        ChangeNotifierProvider.value(value: RestaurantProvider.initialize()),
        ChangeNotifierProvider.value(value: ProductProvider.initialize()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Food App',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: ScreensController())));
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserProvider>(context);
    switch (auth.status) {
      case Status.Uninitialized:
        return Splash();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return LoginScreen();
      case Status.Authenticated:
        return Home();
      default:
        return LoginScreen();
    }
  }
}
