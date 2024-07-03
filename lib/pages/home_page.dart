import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:letschat_app/models/user_profile.dart';
import 'package:letschat_app/services/alert_service.dart';
import 'package:letschat_app/services/auth_service.dart';
import 'package:letschat_app/services/database_service.dart';
import 'package:letschat_app/services/navigation_service.dart';
import 'package:letschat_app/widgets/chat_tile.dart';

class HomePage extends StatefulWidget {   // this is the home page which consists of the list of chats 
  const HomePage({super.key});   

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GetIt _getIt =GetIt.instance;
  late DatabaseService _databaseService;
  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseService = _getIt.get<DatabaseService>();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Messages',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed: () async{
              bool result = await _authService.logout();
              if (result) {
                _alertService.ShowToast(
                  text: 'Successfully logged out!',
                  icon: Icons.check,
                );
                _navigationService.pushReplacementNamed("/login");
              }
            },
            icon: Icon(
              Icons.logout,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: _buildUI(),
    );
  }


  Widget _buildUI () {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: _chatsList(),
      ),
    );
  }


  Widget _chatsList(){
    return StreamBuilder(
      stream: _databaseService.getUserProfile(),
      builder: (context,snapshot){
        if (snapshot.hasError) {
          return Center(
            child: Text("Unable to load data"),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context,index){
              UserProfile user = users[index].data();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical:10.0),
                child: ChatTile( // creates a chat tile to retrieve data from firebase
                  userProfile: user,
                  onTap: () {},
                ),
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}