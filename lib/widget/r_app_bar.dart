import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:recipe_ai/utils/colors.dart';
import 'package:recipe_ai/utils/icons.dart';

class RappBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onClearChat; // CALLBACK FOR CLEAR CHAT

  const RappBar({super.key, required this.onClearChat});

  @override
  State<RappBar> createState() => _RappBarState();

  @override
  //  IMPLEMENT PREFERREDSIZE
  Size get preferredSize => const Size.fromHeight(100);
}

class _RappBarState extends State<RappBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(70, 40),
          bottomRight: Radius.elliptical(70, 40),
        ),
      ),
      backgroundColor: ColorsUtil.appBarColor,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // PICTURE OF BOT
            _botPicture(),
            const Gap(20),

            // BOT NAME AND ONLINE SECTION
            _botNameSection(),
            const Spacer(),

            // RIGHT ICON BUTTON
            _rightIconButton(),
          ],
        ),
      ),
    );
  }

  // BOT PICTURE WIDGET
  Widget _botPicture() {
    return CircleAvatar(
      radius: MediaQuery.of(context).size.width * 0.065,
      child: Image.asset(IconsPng.botPng),
    );
  }

  // BOT NAME AND ONLINE COLUMN WIDGET
  Widget _botNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recipe AI",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w900),
        ),
        const Gap(5),

        // ONLINE SECTION
        Row(
          children: [
            // Green Dot
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const Gap(8),

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
    );
  }

  // RIGHT ICON BUTTON WIDGET
  Widget _rightIconButton() {
    return IconButton(
      onPressed: () {
        _showBottomSheet();
      },
      icon: const Icon(
        Icons.more_vert_rounded,
        size: 30,
      ),
    );
  }

  // BOTTOM SHEET
  PersistentBottomSheetController _showBottomSheet() {
    return showBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Gap(5),
                Divider(
                  thickness: 4,
                  indent: 150,
                  endIndent: 150,
                  color: Colors.grey.shade300,
                ),

                // CLEAR CHAT BUTTON
                _clearChatButton(),

                // DEVELOPER TEXT
                _developerText(),
              ],
            ),
          ),
        );
      },
    );
  }

  // CLEAR CHAT BUTTON WIDGET
  Widget _clearChatButton() {
    return Expanded(
      child: Center(
        child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: ColorsUtil.backgroundColor,
                shape: const ContinuousRectangleBorder()),
            onPressed: () {
              widget.onClearChat(); // Trigger callback
              Navigator.pop(context); // Close bottom sheet
            },
            child: Text(
              "Clear Chat",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
            )),
      ),
    );
  }

  // DEVELOPER TEXT WIDGET
  Widget _developerText() {
    return Text(
      'Delevoped by Imtiaj',
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Colors.grey,
          fontWeight: FontWeight.normal,
          fontSize: 10,
          letterSpacing: 1.2),
    );
  }
}
