import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:letschat_app/widgets/customFormField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          vertical: 20,
        ),
        child: Column(
          children: [
            headertext(),
            loginForm()
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
          Text('Hi,Welcome Back!', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
          Text("Hello again, you've been missed", style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
        ],
      ),
    );
  }

  Widget loginForm(){
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomFormField(hintText: 'Email',),
            SizedBox(height: 10,),
            CustomFormField(hintText: 'PassWord',),
          ],
        ),
      ),
    );
  }
}