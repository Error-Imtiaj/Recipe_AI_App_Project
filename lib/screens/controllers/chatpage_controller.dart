import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_ai/models/recipe_model.dart';
import 'package:recipe_ai/utils/api.dart';

class ChatController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final Box userBox = Hive.box('user');

  var botResponses = <RecipeModel>[].obs; // Reactive list of bot responses
  var isLoading = false.obs; // Reactive loading state

  final String _baseUrl = 'https://api.api-ninjas.com/v1/recipe';
  final String _apiKey = Apis.api;

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  // Fetch recipes from the API
  Future<void> fetchRecipes(String query) async {
    try {
      isLoading(true); // Set loading state to true
      botResponses.clear(); // Clear previous responses

      final response = await http.get(
        Uri.parse('$_baseUrl?query=$query'),
        headers: {'X-Api-Key': _apiKey},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        for (Map<String, dynamic> item in data) {
          botResponses.add(RecipeModel.fromJson(item));
        }
      } else {
        // Handle error from the API
        botResponses.add(RecipeModel(
          title: 'Error',
          ingredients: 'Failed to fetch recipes.',
          instructions: '',
          servings: '',
        ));
      }
    } on SocketException {
      showNoInternetSnackbar();
      handleError('No internet connection.');
      botResponses.add(RecipeModel(
        error: "No internet Connection",
        title: '',
        ingredients: '',
        instructions: '',
        servings: '',
      ));
    } catch (e) {
      // Catch any errors in case of network failure or other issues
      botResponses.add(RecipeModel(
        title: 'Error',
        ingredients: 'Error fetching data. Please try again.',
        instructions: '',
        servings: '',
      ));
    } finally {
      isLoading(false); // Set loading state to false
    }
  }

  void showNoInternetSnackbar() {
    Get.snackbar(
      'No Internet',
      'Please check your internet connection.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
    );
  }

  // Convert the first recipe to a formatted string
  String formatRecipe(List<RecipeModel> botResponses) {
    if (botResponses.isEmpty) {
      return 'No recipes found. Please try again.';
    }
    final recipe = botResponses[0];
    return 'Title: ${recipe.title}\n\n'
        'Ingredients: ${recipe.ingredients}\n\n'
        'Instructions: ${recipe.instructions}\n\n'
        'Servings: ${recipe.servings}';
  }

  // Add user and bot messages to the Hive box
  Future<void> addMessage(String message) async {
    // Save user message
    await userBox.add({
      'user': message,
      'time': _getCurrentTime(),
      'isMe': true,
    });

    // Fetch bot response
    await fetchRecipes(message);

    // Save bot message
    final botMessage = formatRecipe(botResponses);
    await userBox.add({
      'user': botMessage,
      'time': _getCurrentTime(),
      'isMe': false,
    });
  }

  // Clear all chat messages
  void clearChat() {
    userBox.clear();
  }

  // Helper: Get current time
  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
  }

  // New method to handle errors
  void handleError(String message) {
    botResponses.add(RecipeModel(
      title: 'Error',
      ingredients: message,
      instructions: '',
      servings: '',
    ));
  }

  // New method to handle API responses
  void handleApiResponse(http.Response response) {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      for (Map<String, dynamic> item in data) {
        botResponses.add(RecipeModel.fromJson(item));
      }
    } else {
      handleError('Failed to fetch recipes.');
    }
  }

  // New method to handle network errors
  void handleNetworkError() {
    handleError('Error fetching data. Please try again.');
  }

  // New method to handle unknown errors
  void handleUnknownError() {
    handleError('An unknown error occurred.');
  }
}
