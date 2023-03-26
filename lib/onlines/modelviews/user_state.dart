import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserState extends GetxController {
  final isEmailVerified = false.obs;
  final userinfo = Rxn<UserCredential>();

  void checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    print(user?.emailVerified);
    if (user?.emailVerified != false) {
      isEmailVerified.value = true;
    }else{
      isEmailVerified.value = false;
    }
  }
}