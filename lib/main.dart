import 'firebase_options.dart';
import 'package:cs_310_project/views/my_closet/closet_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cs_310_project/views/planner/planner_provider.dart';
import 'package:cs_310_project/views/my_outfits/outfits_provider.dart';
import 'package:cs_310_project/views/login_register/login_register_provider.dart';
import 'package:cs_310_project/views/item_creator/item_creator_provider.dart';

//Main Screens
import 'package:cs_310_project/views/login_register/login_register.dart';
import 'package:cs_310_project/views/home/home.dart';
import 'package:cs_310_project/views/profile/profile.dart';

//Closet
import 'package:cs_310_project/views/my_closet/my_closet_page.dart';
import 'package:cs_310_project/views/item_detail/item_detail_page.dart';
import 'package:cs_310_project/views/item_creator/item_creator.dart';

//Outfits
import 'package:cs_310_project/views/my_outfits/my_outfit_page.dart';
import 'package:cs_310_project/views/outfit_creator/outfit_creator_page.dart';
import 'package:cs_310_project/views/outfit_detail/outfit_detail_page.dart';

//Planner
import 'package:cs_310_project/views/planner/planner_page.dart';

//Bottom Navigator Bar
import 'package:cs_310_project/widgets/bottom_nav_bar.dart';

import 'package:shared_preferences/shared_preferences.dart';

//Application entry point
//Initializes Firebase and injects all global providers
void main() async {
  
  //Required for async initialization before runApp
  WidgetsFlutterBinding.ensureInitialized();

  //Initializes Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Registers global providers used across the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginRegisterProvider()),
        ChangeNotifierProvider(create: (_) => ItemCreatorProvider()),
        ChangeNotifierProvider(create: (_) => PlannerProvider()),
        ChangeNotifierProvider(create: (_) => ClosetProvide_
