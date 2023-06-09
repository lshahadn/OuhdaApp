import 'package:bustracking/data/models/body/bus_model.dart';
import 'package:bustracking/data/models/body/user_model.dart';
import 'package:bustracking/data/repository/auth_repo.dart';
import 'package:bustracking/helper/route_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firebase = FirebaseFirestore.instance;
  Rxn<User> _firebaseUser = Rxn<User>();
  bool _isLoading = false;
  List<BusModel> buss = [BusModel(id: "0", bus_number: "select bus")];

  @override
  void onInit() {
    super.onInit();
    _firebaseUser.bindStream(_auth.authStateChanges());
  }

  User? get user => _firebaseUser.value;
  bool get isLoading => _isLoading;

  List<String> accountType = ['select account type', 'driver', 'parent'];
  String? selectedAccountType;

  Future<Map> signUp(UserModel user) async {
    _isLoading = true;
    update();

    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      )
          .then((value) {
        print(value.user!.uid);
        print(value.user!.uid);
        FirebaseMessaging.instance.getToken().then((token) {
          UserModel model = UserModel(
              id: value.user!.uid,
              fullName: user.fullName,
              phone: user.phone,
              email: user.email,
              password: user.password,
              accountType: selectedAccountType,
              busNumber: selectedAccountType == 'driver'
                  ? selectedBus!.bus_number
                  : null,
              date: DateTime.now().toIso8601String(),
              fcmToken: token);

          _firebase
              .collection('users')
              .doc(value.user!.uid.toString())
              .set(model.toJson())
              .then((value2) {
            print("Done Register");
            // saveUserData(model.id!, model.fullName!, model.email!,
            //     model.password!, model.accountType!);
            selectedAccountType = accountType[0];
          });
        });
      });
      _isLoading = false;
      update();
      return {"status": true};
    } catch (e) {
      print(e);
      _isLoading = false;
      update();
      return {"status": false, "error": e.toString()};
    }
  }

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  Future getUserData() async {
    try {
      final doc = await usersRef.doc(getUserID()).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson(data);
      } else {
        print('User data does not exist');
        return null;
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      return null;
    }
  }

  Future<Map> updateProfile(String id, _fullName, _email, _number) async {
    _isLoading = true;
    update();

    try {
      print(id.replaceAll(' ', ''));
      _firebase.collection('users').doc(id.replaceAll(' ', '')).update({
        'fullName': _fullName,
        'email': _email,
        'phone': _number,
      }).then((value2) {
        print("Done update");
      });
      _isLoading = false;
      update();
      return {"status": true};
    } catch (e) {
      print(e);
      _isLoading = false;
      update();
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    String accountType = '';
    bool isLoading = true;
    update();

    try {
      // Sign in with email and password
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user document from Firestore
      final DocumentSnapshot userSnapshot = await _firebase
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // Retrieve account type from user document
      final Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      accountType = userData['accountType'];

      // Save user data
      saveUserData(userCredential.user!.uid, userData['fullName'], email,
          password, accountType, userData['phone']);
      selectedAccountType = accountType;

      isLoading = false;
      update();

      // Return success status and account type
      return {"status": true, "accountType": accountType};
    } catch (e) {
      isLoading = false;
      update();
      print(e);

      // Return error status
      return {"status": false};
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      authRepo.clearUserInfo();
      Get.offAndToNamed(RouteHelper.getSignInRoute());
    } catch (e) {
      Get.snackbar(
        'Error signing out',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String getUserNumber() {
    return authRepo.getUserNumber();
  }

  saveUserData(String id, String username, String email, String password,
      String accountType, String phone) {
    authRepo.saveUserData(id, username, password, email, accountType, phone);
  }

  String getUserPassword() {
    return authRepo.getUserPassword();
  }

  Future<bool> clearUserInfo() async {
    return authRepo.clearUserInfo();
  }

  String getUserID() {
    return authRepo.getUserID();
  }

  String getUserEmail() {
    return authRepo.getUserEmail();
  }

  String getUserAccountType() {
    return authRepo.getUserAccountType();
  }

  void selectAccountType(val) {
    selectedAccountType = val;
    if (selectedAccountType == 'driver') getBuss();
    update();
  }

  BusModel? selectedBus;

  void selectBus(val) {
    selectedBus = val;
    update();
  }

  Future getBuss() async {
    _isLoading = true;
    update();

    authRepo.getBuss().then((value) {
      buss = [BusModel(id: "0", bus_number: "select bus")];
      print(value);
      value.forEach((element) {
        print(element);
        buss.add(BusModel.fromJson(element.data()));
      });
      print("dddddd");
      _isLoading = false;
      update();
    }).catchError((err) {
      _isLoading = false;
      update();
    });
  }

  String getUsername() {
    return authRepo.getUsername();
  }
}
