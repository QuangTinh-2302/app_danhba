import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_qly_danhba/model/contacts.dart';
import 'package:app_qly_danhba/ui/themscreen.dart';
import 'package:app_qly_danhba/model/url.dart';
import 'package:app_qly_danhba/ui/contact_detail.dart';
import 'package:app_qly_danhba/ui/home.dart';
void main() {
  runApp(MaterialApp(home: Login(),debugShowCheckedModeBanner: false,));
}
class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Login();
}
class _Login extends State<Login>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Opacity(
                opacity: 0.3,
                child:Image.asset(
                'assets/img/back_ground.webp',
                fit: BoxFit.cover,
                )
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(50),
                    child: Center(
                      child: Text('LOGIN',style: TextStyle(fontSize: 40),),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    child: PasswordForm()
                  )
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
class PasswordForm extends StatefulWidget {
  @override
  _PasswordFormState createState() => _PasswordFormState();
}
class _PasswordFormState extends State<PasswordForm> {
  final _usercontroler = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  String? _errorMessage;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _usercontroler,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                    borderRadius : BorderRadius.circular(30)
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên tài khoản !';
                }
                return null;
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius : BorderRadius.circular(30)
                ),
                labelText: 'Password',
                errorText: _errorMessage,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: (){
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập mật khẩu !';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              height: 47,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final username = _usercontroler.text;
                    final password = _passwordController.text;
                    if(username == 'admin' && password == 'admin' || username == 'username' && password == 'password'){
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(
                          builder: (context) => MyApp()
                        )
                      );
                    }else{
                      setState(() {
                        _errorMessage = 'Sai tài khoản hoặc mật khẩu !';
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 20,
                  backgroundColor: Colors.blueGrey,
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                  )
                ),
                child: Text('Login',style: TextStyle(fontSize: 22,color: Colors.white),)
              ),
            ),
          ),
        ],
      ),
    );
  }
}

