import 'package:flutter/material.dart';
import 'package:letschat_app/pages/home_page.dart';
import 'package:letschat_app/pages/login_page.dart';
import 'package:letschat_app/pages/register_page.dart';
import 'package:path/path.dart';

class NavigationService {
  late GlobalKey<NavigatorState> _navigatorkey; // creating a navigator key 

  final Map<String,Widget Function(BuildContext)> _routes ={ // creating a map for the routes
    "/login" : (context) => LoginPage(),
    "/register" : (context) => RegisterPage(),
    "/home" : (context) => HomePage(),
  };

  GlobalKey<NavigatorState> ? get navigatorKey{ // creating a getter function to access the navigator key
    return _navigatorkey;
  }

  Map<String,Widget Function(BuildContext)> get routes{ // creating a getter function to access the routes
    return _routes;
  }

  NavigationService(){
    _navigatorkey = GlobalKey<NavigatorState>(); // Navigation Service constructor withe navigator key
  }

  // Pushing named route onto the navigator
  void pushNamed(String routename){
    _navigatorkey.currentState?.pushNamed(routename);
  }

  //Replace the current route of the navigator by pushing the route named
  void pushReplacementNamed(String routename){
    _navigatorkey.currentState?.pushReplacementNamed(routename);
  }

  //Pop the top-most route off the navigator.
  void goBack(){
    _navigatorkey.currentState?.pop();
  }
}