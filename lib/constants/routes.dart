import 'package:hptracker/login/login_screen.dart';
import 'package:hptracker/login/registration_form_screen.dart';
import 'package:hptracker/pages/home_screen.dart';
import 'package:hptracker/pages/med_history.dart';
import 'package:hptracker/pages/page_navigator.dart';
import 'package:hptracker/pages/profile_screen.dart';
import 'package:hptracker/pages/settings_screen.dart';
import 'package:hptracker/pages/splash_screen.dart';
import 'package:hptracker/pages/add_medicine_screen.dart';

final routes = {
        "/homeScreen" :(context) => const Homescreen(),
        "/loginScreen" : (context) => const Login(),
        "/registerScreen" : (context) => const RegistrationFormScreen(),
        "/profileScreen" : (context) => const ProfilePage(),        
        "/splashScreen" : (context) => const SplashScreen(),        
        "/paymentScreen" : (context) => const AddMedicineScreen(),        
        "/suggestionScreen" : (context) => const MedHistory(),        
        "/navigatorScreen" : (context) => const PageNavigator(),  
        "/settingsScreen" : (context) => const SettingsScreen(),
        "/navigator": (context) => const PageNavigator(),
      
      };