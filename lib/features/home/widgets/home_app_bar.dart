import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final Widget? leading;
  final String titleText;
  final Color backgroundColor;
  final TextStyle? titleStyle;
  final bool centerTitle;

  const HomeAppBar({
    super.key,
    this.actions,
    this.leading,
    this.titleText = "Mythica",
    this.backgroundColor = Colors.deepPurple,
    this.titleStyle,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leading: leading ??
          IconButton(
            icon: const Icon(Icons.menu_book_rounded),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
      title: Text(
        titleText,
        style: titleStyle ??
            const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
      ),
      centerTitle: centerTitle,
      actions: actions ??
          [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: const Icon(Icons.person, color: Colors.black87),
              ),
            ),
          ],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
