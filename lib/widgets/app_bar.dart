import 'package:flutter/material.dart';
import 'package:shopping_list/profile/profile.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title = '',
    this.profileButton = false,
    this.actions,
    this.heroTag,
  });

  final String title;
  final bool profileButton;
  final List<Widget>? actions;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    List<Widget>? appActions = profileButton
        ? [
            IconButton(
              onPressed: () => Navigator.push(context, ProfilePage.route()),
              icon: const Icon(Icons.account_circle, size: 30),
            ),
          ]
        : [];

    if (actions != null) appActions.addAll(actions!);

    return AppBar(
      title: heroTag == null
          ? Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            )
          : Hero(
              tag: heroTag!,
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
      centerTitle: true,
      actions: appActions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
