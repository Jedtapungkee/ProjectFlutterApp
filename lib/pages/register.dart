import 'package:flutter/material.dart';
import '../pages/login.dart';
import '../database/auth.dart'; // Assuming you will use Firebase authentication

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _email = '';
  String _passwd = '';

  Future _showAlert(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18.0)),
            ),
            actions: [
              ElevatedButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
              )
            ],
          );
        });
  }

  Future _showAlertss(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18.0)),
            ),
            actions: [
              ElevatedButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ));
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 155.0,
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                const SizedBox(height: 45.0),
                TextFormField(
                  key: UniqueKey(),
                  obscureText: false,
                  autofocus: true,
                  onChanged: (value) => _email = value,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0))),
                ),
                const SizedBox(height: 25.0),
                TextFormField(
                  key: UniqueKey(),
                  obscureText: true,
                  onChanged: (value) => _passwd = value,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0))),
                ),
                const SizedBox(
                  height: 35.0,
                ),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.deepPurpleAccent,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () async {
                      // Firebase Authentication registration process
                      await UserAuthentications()
                          .registerWithEmailAndPassword(_email, _passwd)
                          .then((res) {
                        if (res == true) {
                          _showAlertss(context, 'Registration successful!');
                        } else {
                          _showAlert(context, 'Registration failed!');
                        }
                      });
                    },
                    child: const Text(
                      "Register",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
