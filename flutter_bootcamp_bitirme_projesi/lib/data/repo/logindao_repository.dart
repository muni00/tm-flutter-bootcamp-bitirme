import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginDaoRepository {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      var auth = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((kullanici) {
        firestoreIlkKayit(email, password);
      });
      return auth.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> firestoreIlkKayit(String email, String password) {
    return firebaseFirestore.collection("kullanicilar").doc(email).set({
      "kullaniciEmail": email,
      "kullaniciSifre": password
    }).whenComplete(() => print("kayıt alındı"));
  }

  Future<User?> signIn(String email, String password) async {
    try {
      var auth = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return auth.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> isSignedIn() async {
    var currentUser = await firebaseAuth.currentUser;
    await currentUser != null;
  }

  Future<User?> geturrentUser() async {
    return await firebaseAuth.currentUser;
  }
}
