import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:letschat_app/consts.dart';
import 'package:letschat_app/services/alert_service.dart';
import 'package:letschat_app/services/auth_service.dart';
import 'package:letschat_app/services/navigation_service.dart';
import 'package:letschat_app/widgets/customFormField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance; // creating a getit inctance 
  
  late AuthService _authService; // creating an authentication variable 
  late NavigationService _navigationService;
  late AlertService _alertService;

  final GlobalKey<FormState> _loginFormKey = GlobalKey();
  String ? email, password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authService = _getIt.get<AuthService>(); // to initialize the authentication variable to the getit instance
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
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
          vertical: 20,
        ),
        child: Column(
          children: [
            headertext(),
            loginForm(),
            createAnAccount()
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
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomFormField(hintText: 'Email',
              height: MediaQuery.sizeOf(context).height * 0.1,
              validationRegEx: EMAIL_VALIDATION_REGEX, onSaved: (value) {
                setState(() {
                  email = value; // store the email in the email variable 
                });
              },
            ),
            SizedBox(height: 10,),
            CustomFormField(
              hintText: 'Password',
              height: MediaQuery.sizeOf(context).height * 0.1,
              validationRegEx: PASSWORD_VALIDATION_REGEX, obscureText: true,
              onSaved: (value) {
                setState(() {
                  password = value; // store the password in the password variabble
                });
              },
            ),
            LoginButton()
          ],
        ),
      ),
    );
  }

  Widget LoginButton(){
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        onPressed: () async{
          if (_loginFormKey.currentState?.validate() ?? false) {
            _loginFormKey.currentState?.save();
            bool result =  await _authService.login(email!,password!); // this is used to get the result from the firebase and authentucate the login and check if the email and the password is correct in the database
            print(result);
            if (result) {
              _navigationService.pushReplacementNamed("/home");
            } else {
              _alertService.ShowToast(text: "Failed to login, Please try again",icon: Icons.error);
            }
          }
        },
        color: Theme.of(context).colorScheme.primary,
        child: Text('Login',style: TextStyle(color: Colors.white),),
      ),
    );
  }

  Widget createAnAccount(){
    return Expanded( // this is the create an account function
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text("Don't have an account?",),
          GestureDetector(child: Text('Sign Up',style: TextStyle(fontWeight: FontWeight.w800),),onTap: (){_navigationService.pushNamed('/register');},)
        ],
      ),
    );
  }
}