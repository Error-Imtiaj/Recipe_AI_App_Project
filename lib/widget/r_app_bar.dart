import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_ai/utils/colors.dart';
import 'package:recipe_ai/utils/icons.dart';

class RappBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onClearChat; // Callback for clear chat

  const RappBar({super.key, required this.onClearChat});

  @override
  State<RappBar> createState() => _RappBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(100);
}

class _RappBarState extends State<RappBar> {
  @override
  Widget build(BuildContext context) {
    var userBox = Hive.box('user');

    return AppBar(
      toolbarHeight: 100,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.elliptical(70, 40),
              bottomRight: Radius.elliptical(70, 40))),
      backgroundColor: ColorsUtil.appBarColor,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // PICTURE

            CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.065,
              child: Image.asset(IconsPng.botPng),
            ),

            // BOT NAME
            Gap(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recipe AI",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                Gap(5),

                // ONLINE
                Row(
                  children: [
                    // Green Dot
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gap(8),

                    // Online text
                    Text(
                      "Online",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.grey),
                    )
                  ],
                )
              ],
            ),
            Spacer(),
            // Edit
            IconButton(
                onPressed: () {
                  showBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: Icon(
                                          Icons.close,
                                          color: ColorsUtil
                                              .userChatBackgroundColor,
                                        ))
                                  ],
                                ),
                                Expanded(
                                  child: Center(
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor:
                                                ColorsUtil.backgroundColor,
                                            shape: ContinuousRectangleBorder()),
                                        onPressed: () {
                                          widget
                                              .onClearChat(); // Trigger callback
                                          Navigator.pop(
                                              context); // Close bottom sheet
                                        },
                                        child: Text(
                                          "Clear Chat",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                icon: Icon(
                  Icons.more_vert_rounded,
                  size: 30,
                ))
          ],
        ),
      ),
    );
  }
}
