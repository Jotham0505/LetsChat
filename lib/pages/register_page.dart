import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:letschat_app/consts.dart';
import 'package:flutter/material.dart';
import 'package:letschat_app/services/auth_service.dart';
import 'package:letschat_app/services/media_service.dart';
import 'package:letschat_app/services/navigation_service.dart';
import 'package:letschat_app/widgets/customFormField.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final GetIt _getit = GetIt.instance;
  late MediaService _mediaService;
  late NavigationService _navigationService;
  late AuthService _authService;
  String ? email, password, name;
  File ? selectedImage;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mediaService = _getit.get<MediaService>();
    _navigationService = _getit.get<NavigationService>();
    _authService = _getit.get<AuthService>();
  }

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
            alreadyHaveAnAccount()
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PrflPicSelectionField(),
            CustomFormField(
              height: MediaQuery.sizeOf(context).height * 0.1,
              hintText: 'Name',
              validationRegEx: NAME_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            CustomFormField(
              height: MediaQuery.sizeOf(context).height * 0.1,
              hintText: 'Email',
              validationRegEx: EMAIL_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  name = email;
                });
              },
            ),
            CustomFormField(
              obscureText: true,
              height: MediaQuery.sizeOf(context).height * 0.1,
              hintText: 'Password',
              validationRegEx: PASSWORD_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  name = password;
                });
              },
            ),

            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Sign up'),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget PrflPicSelectionField(){
    return GestureDetector(
      onTap: () async{
        File ? file = await _mediaService.getImageFromGallery();
        if(file != null){
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget alreadyHaveAnAccount(){
    return Expanded( // this is the create an account function
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text("Already have an account?",),
          GestureDetector(child: Text('Log in',style: TextStyle(fontWeight: FontWeight.w800),),onTap: (){_navigationService.pushNamed('/login');},)
        ],
      ),
    );
  }
}