import 'dart:io';
import 'package:letschat_app/consts.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  File ? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: buildUI(),
    );
  }

  Widget buildUI(){
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20
        ),
        child: Column(
          children: [
            headertext(),
            RegisterForm(),
          ],
        ),
      ),
    );
  }

  Widget headertext(){
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Let's get going!", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
          Text("Register an account using the form below", style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
        ],
      ),
    );
  }

  Widget RegisterForm(){
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.60,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05
      ),
      child: Form(
        child: Column(
          children: [
            PrflPicSelectionField(),
          ],
        ),
      ),
    );
  }


  Widget PrflPicSelectionField(){
    return CircleAvatar(
      radius: MediaQuery.of(context).size.width * 0.15,
      backgroundImage: selectedImage != null ? FileImage(selectedImage!) : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
    );
  }
}