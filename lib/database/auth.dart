import 'package:firebase_auth/firebase_auth.dart';

class UserAuthentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _success = false;

  Future<bool> signInWithEmailAndPassword(
      String email, String password) async {
        try {
          final User? user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
              .user;
          if (user != null) {
            _success = true;
          } 
        } on FirebaseAuthException catch (e) {
          _success = false;
        }
        return _success;
      }
      
}

class UserAuthentications {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true; // ลงทะเบียนสำเร็จ
    } catch (e) {
      return false; // เกิดข้อผิดพลาด
    }
  }
}
