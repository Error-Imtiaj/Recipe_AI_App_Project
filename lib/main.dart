import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_ai/app.dart';
import 'package:recipe_ai/models/recipe_model.dart';

void main() async {
  // INITIALIZATION HIVE
  await Hive.initFlutter();

  // OPEN A BOX FOR STORAGE
  await Hive.openBox<RecipeModel>('recipes');

  // OPEN BOX FOR USER
  await Hive.openBox('user');

  runApp(const RecipeApp());
}
