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

  @override
  void dispose() {
    // TODO: implement dispose
    sTextController.dispose();
    super.dispose();
  }

  // BOX OF USER DATA
  var userBox = Hive.box('user');

  // FETCH RECIPE FROM THE API
  Future<List<RecipeModel>> getReq(String query, String api) async {
    botReturn.clear(); // Clear botReturn before making a new API request
    final response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/recipe?query=$query'),
      headers: {'X-Api-Key': api},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      for (Map<String, dynamic> i in data) {
        RecipeModel recipe = RecipeModel.fromJson(i);
        botReturn.add(recipe);
      }
    }
    return botReturn;
  }

  // CREATE A STRING OF THE FIRST RECIPE
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

  // ADD MESSAGE TO THE HIVE BOX AND UPDATE THE UI
  void _writeToUser(String message) async {
    // TRACK INDEX FOR STORING DATA
    int index = userBox.length;

    // SAVE USER MESSAGE
    userBox.put(index, {
      'user': message,
      'time': '${DateTime.now().hour}:${DateTime.now().minute}',
      'isMe': true,
      'index': index,
    });
    index++;

    // FETCH RESPONSE AND SAVE TO A VARIABLE
    await getReq(message, Apis.api);
    String responseMessage = addtoString(botReturn);

    // SAVE BOT MESSAGE TO THE BOX
    userBox.put(index, {
      'user': responseMessage,
      'time': '${DateTime.now().hour}:${DateTime.now().minute}',
      'isMe': false,
      'index': index,
    });
    index++;

    setState(() {});
  }

// CLEAR ALL BOX DATA FUNCTION
  void clearChat() {
    setState(() {
      userBox.clear(); // CLEAR ALL MESSAGE FROM THE HIVE
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
          // SOME GAME FROM THE APPBAR
          const Gap(5),

          // CHAT MESSAGE
          _chatMessagesSection(),

          // BOTTOM SECTION OF THE TEXTFIELD AND SEND BUTTON
          _bottomSection(),
        ],
      ),
    );
  }

  // CHAT MESSAGE SECTION WIDGET
  Widget _chatMessagesSection() {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: userBox.length,
        itemBuilder: (BuildContext context, int index) {
          int netIndex = userBox.length - 1 - index;
          var message = userBox.get(netIndex);
          // CHAT BUBBLE WIDGET
          return ChatBubble(
            textOutput: message['user'].toString(),
            time: message['time'].toString(),
            isMe: message['isMe'] ?? true,
          );
        },
      ),
    );
  }

  // BOTTOM SECTION WIDGET [ INPUT FIELD AND SEND BUTTON]
  Widget _bottomSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 24, right: 24, top: 5),
      child: Row(
        children: [
          // TEXT FIELD
          Expanded(
            child: _inputText(sTextController),
          ),
          const Gap(10),

          // SEND BUTTON
          _sendButton(),
        ],
      ),
    );
  }

  // SEND BUTTON WIDGET
  Widget _sendButton() {
    return IconButton.filled(
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
    );
  }

  // INPUT TEXT WIDGET
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
