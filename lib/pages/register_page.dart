import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:letschat_app/consts.dart';
import 'package:flutter/material.dart';
import 'package:letschat_app/models/user_profile.dart';
import 'package:letschat_app/services/alert_service.dart';
import 'package:letschat_app/services/auth_service.dart';
import 'package:letschat_app/services/database_service.dart';
import 'package:letschat_app/services/media_service.dart';
import 'package:letschat_app/services/navigation_service.dart';
import 'package:letschat_app/services/storage_service.dart';
import 'package:letschat_app/widgets/customFormField.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final GlobalKey<FormState> _registerFormKey = GlobalKey();
  final GetIt _getit = GetIt.instance;
  late AlertService _alertService;
  late DatabaseService _databaseService;
  late StorageService _storageService;
  late MediaService _mediaService;
  late NavigationService _navigationService;
  late AuthService _authService;
  String? email, password, name;
  File? selectedImage;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mediaService = _getit.get<MediaService>();
    _navigationService = _getit.get<NavigationService>();
    _authService = _getit.get<AuthService>();
    _storageService = _getit.get<StorageService>();
    _databaseService = _getit.get<DatabaseService>();
    _alertService = _getit.get<AlertService>();
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
            if (!isLoading) RegisterForm(),
            if (!isLoading) alreadyHaveAnAccount(),
            if (isLoading)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
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
        key: _registerFormKey,
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
                  email = value;
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
                  password = value;
                });
              },
            ),

            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_registerFormKey.currentState!.validate()) {
                    _registerFormKey.currentState!.save();
                    if (selectedImage == null) {
                      print('Error shoing the profile picture');
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        bool result = await _authService.signup(email!, password!);
                        if (result) {
                          String ? pfpURL = await _storageService.uploadUserPFP(file: selectedImage!, uid: _authService.user!.uid);
                          if (pfpURL != null) {
                           await _databaseService.createUserProfile(
                              userProfile: UserProfile(
                                  uid: _authService.user!.uid,
                                  name: name,
                                  pfpURL: pfpURL),
                            );
                            _alertService.ShowToast(text: 'User Registered Successfully', icon: Icons.check);
                            _navigationService.goBack();
                            _navigationService.pushReplacementNamed('/home');
                          }else{
                            throw Exception('Unable to upload user profile picture');
                          }
                        }
                        else{
                          throw Exception('Unable to register the user');
                        }
                        print(result);
                      } catch (e) {
                        print(e);
                        _alertService.ShowToast(text: 'Failed to register, Please try again!',icon: Icons.error);
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
                child: Text('Sign up'),
              ),
            )
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
    return Expanded(
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
