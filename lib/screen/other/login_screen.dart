import 'package:next_app/widgets/dismiss_keyboard.dart';
import 'package:flutter/material.dart';

import 'package:next_app/provider/user/user_provider.dart';
import 'package:next_app/service/service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants.dart';
import '../../core/shared_pref.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var urlController = TextEditingController();
  final textFieldFocusNode = FocusNode();
  bool _passwordVisible = false;
  final APIService service  = APIService();
  SharedPref pref= SharedPref();
  String? usr;
  String? pass;
  String? url;
  bool _isLoading = false;

  bool rememberMe = false;

  void _login() async{
    if (userNameController.text.isEmpty || passwordController.text.isEmpty || urlController.text.isEmpty)
      Fluttertoast.showToast(msg: tr("login_err"));
    else {
      setState(() => _isLoading = true);

      try {
        await context.read<UserProvider>().login(userNameController.text, passwordController.text, urlController.text, rememberMe);
      }
      // on ServerException catch(e){
      //   setState(() => _isLoading = false);
      //   Fluttertoast.showToast(msg: e.message);
      // }
      catch (e) {
        setState(() => _isLoading = false);
        print(e);
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return DismissKeyboard(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xffF2F4F5),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            height: screenHeight,
            child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 40),
                  Image.asset("assets/logo.png", width: 280, height: screenHeight / 4, fit: BoxFit.contain),
                  SizedBox(height: 10),
                  Container(
                    // width: screenWidth - 30,
                    //height: screenHeight / 1.7,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.transparent, width: 1.5),
                        borderRadius: new BorderRadius.all(
                          const Radius.circular(10.0),
                        )),
                    child: Column(
                      children: [
                        Padding(padding: const EdgeInsets.all(8.0), child: Text("Welcome")),
                        Text("To Next App"),
                        Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                                controller: urlController,
                                decoration: textFieldDecoration.copyWith(
                                  labelText: "Url",
                                ))),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                                controller: userNameController,
                                decoration: textFieldDecoration.copyWith(
                                  labelText: "User Name",
                                ))),
                        Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: passwordController,
                                    obscureText: !_passwordVisible,
                                    //This will obscure text dynamically
                                    decoration: textFieldDecoration.copyWith(
                                      labelText: tr("Password"),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                          color: Theme.of(context).primaryColorDark,
                                        ),
                                        onPressed: () {
                                          // Update the state i.e. toogle the state of passwordVisible variable
                                          setState(() {
                                            _passwordVisible = !_passwordVisible;
                                          });
                                        },
                                      ),
                                    )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [Checkbox(value: rememberMe, onChanged: (value)=> setState(()=>rememberMe = !rememberMe)), Text(tr("remember_me"))],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        tr("for_pass"),
                                        style: TextStyle(color: Color(0xff0488FA)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        !_isLoading
                            ? InkWell(
                          onTap: _login,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              height: 50,
                              child: Center(
                                child: Text(
                                  "Log in",
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Color(0xff0488FA),
                                  border: Border.all(color: Color(0xffE8E8E8), width: 1.5),
                                  borderRadius: new BorderRadius.all(
                                    const Radius.circular(10.0),
                                  )),
                            ),
                          ),
                        )
                            : Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                            height: 50,
                            child: Center(child: CircularProgressIndicator(
                              color: CIRCULAR_PROGRESS_COLOR,
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     mainAxisSize: MainAxisSize.min,
                     children: [
                   Text('Powered by'),
                   TextButton(
                     onPressed: (){
                       launchUrl(Uri.parse('https://www.erpcloud.systems/'));
                     } ,
                       child:Text('ERPCloud.systems',style: TextStyle(color: Colors.blue),),
                   ),

                     ],
                   ),
                  SizedBox(height: 10),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final textFieldDecoration = InputDecoration(
  floatingLabelBehavior: FloatingLabelBehavior.auto,
  //Hides label on focus or if filled
  filled: true,
  // Needed for adding a fill color
  fillColor: Color(0xffF6F6F6),
  isDense: true,
  // Reduces height a bit
  border: OutlineInputBorder(
    borderSide: BorderSide.none, // No border
    borderRadius: BorderRadius.circular(12), // Apply corner radius
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xffE8E8E8)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xffE8E8E8)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.redAccent),
  ),
);
