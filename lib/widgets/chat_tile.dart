import 'package:flutter/material.dart';
import 'package:letschat_app/models/user_profile.dart';

class ChatTile extends StatelessWidget {
  final Function onTap;
  final UserProfile userProfile;
  const ChatTile({super.key, required this.userProfile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){onTap();},
      dense: false,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userProfile.pfpURL!),
      ),
      title: Text(userProfile.name!,style: TextStyle(color: Colors.white),),
    );
  }
}