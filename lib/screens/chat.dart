import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_ai/models/recipe_model.dart';
import 'package:recipe_ai/utils/api.dart';
import 'package:recipe_ai/utils/colors.dart';
import 'package:recipe_ai/widget/chat_bubble.dart';
import 'package:recipe_ai/widget/r_app_bar.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController sTextController = TextEditingController();
  Map<String, dynamic> textUserInput = {};
  List<RecipeModel> botReturn = [];

  // Box for user data
  var userBox = Hive.box('user');

  // Fetch recipes from the API
  Future<List<RecipeModel>> getReq(String query, String API) async {
    botReturn.clear(); // Clear botReturn before making a new API request
    final response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/recipe?query=$query'),
      headers: {'X-Api-Key': API},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      for (Map<String, dynamic> i in data) {
        RecipeModel recipe = RecipeModel.fromJson(i);
        botReturn.add(recipe);
      }
    } else {
      print('Error fetching recipes: ${response.statusCode}');
    }

    return botReturn;
  }

  // Create a string representation of the first recipe
  String addtoString(List<RecipeModel> botReturn) {
    if (botReturn.isEmpty) {
      return 'No recipes found. Please try again.';
    }

    // Create a formatted string from the first recipe
    return 'Title: ${botReturn[0].title}\n\n'
        'Ingredients: ${botReturn[0].ingredients}\n\n'
        'Instructions: ${botReturn[0].instructions}\n\n'
        'Servings: ${botReturn[0].servings}';
  }

  // Add message to the Hive box and update the UI
  void _writeToUser(String message) async {
    // Track index for storing messages
    int index = userBox.length;

    // Save user message
    userBox.put(index, {
      'user': message,
      'time': '${DateTime.now().hour}:${DateTime.now().minute}',
      'isMe': true,
      'index': index,
    });
    index++;

    // Fetch response from API and save bot message
    await getReq(message, Apis.API); // Wait for the API response
    String responseMessage = addtoString(botReturn);

    userBox.put(index, {
      'user': responseMessage,
      'time': '${DateTime.now().hour}:${DateTime.now().minute}',
      'isMe': false,
      'index': index,
    });
    index++;

    setState(() {});
  }

// clear dialogue
  void clearChat() {
    setState(() {
      userBox.clear(); // Clear chat messages from Hive
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.backgroundColor,
      appBar: RappBar(
        onClearChat: clearChat,
      ),
      body: Column(
        children: [
          const Gap(5),
          // Chat messages
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: userBox.length,
              itemBuilder: (BuildContext context, int index) {
                int netIndex = userBox.length - 1 - index;
                var message = userBox.get(netIndex);
                return ChatBubble(
                  textOutput: message['user'].toString(),
                  time: message['time'].toString(),
                  isMe: message['isMe'] ?? true,
                );
              },
            ),
          ),

          // Input field
          Padding(
            padding:
                const EdgeInsets.only(bottom: 10, left: 24, right: 24, top: 5),
            child: Row(
              children: [
                // Text field
                Expanded(
                  child: _inputText(sTextController),
                ),
                const Gap(10),
                // Send button
                IconButton.filled(
                  iconSize: 40,
                  style: IconButton.styleFrom(
                      backgroundColor: ColorsUtil.userChatBackgroundColor),
                  onPressed: () {
                    if (sTextController.text.isNotEmpty) {
                      setState(() {
                        _writeToUser(sTextController.text);
                        sTextController.clear();
                      });
                    }
                  },
                  icon: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Icon(
                      Iconsax.directbox_send,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Input text widget
  Widget _inputText(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintText: "Recipe Name pls...",
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: Colors.grey),
        fillColor: const Color(0xffFFFFFF),
        filled: true,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
