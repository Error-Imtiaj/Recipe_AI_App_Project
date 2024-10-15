import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_ai/app.dart';
import 'package:recipe_ai/models/recipe_model.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  // INITIALIZATION HIVE
  await Hive.initFlutter();

  // // REGISTER ADAPTER FOR RECIPE MODEL
  // Hive.registerAdapter(RecipeModel());

  // OPEN A BOX FOR STORAGE
  await Hive.openBox<RecipeModel>('recipes');

  // OPEN BOX FOR USER
  await Hive.openBox('user');

  // SCREEN UTILS INITIALIZATION
  await ScreenUtil.ensureScreenSize();

  runApp(const RecipeApp());
}
