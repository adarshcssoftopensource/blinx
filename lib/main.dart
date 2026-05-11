import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/screens/authentication/controller/auth_controller.dart';
import 'package:blinx_mobile/screens/authentication/sign_in/view/sign_in_screen.dart';
import 'package:blinx_mobile/screens/splash/view/splash_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/deep_link/services/deep_link_service.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp();

  try {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await StoreServices.saveFcmToken(token);
    }
  } catch (e) {}

  Get.put(AuthController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DeepLinkService _deepLinkService = DeepLinkService();

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blinx',

      theme: ThemeData(
        primaryColor: ColorConstants.primaryColor,
        scaffoldBackgroundColor: ColorConstants.white,
      ),

      initialRoute: '/splash',

      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/sign-in', page: () => SignInScreen()),
      ],

      builder: (context, child) {
        return child!;
      },

      onInit: () {
        _deepLinkService.init();
      },
    );
  }
}
