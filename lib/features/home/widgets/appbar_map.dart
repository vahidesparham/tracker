import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class appbar_map extends StatelessWidget implements PreferredSizeWidget {
  late final double height;
  late final String title;
  late final Function action;
  appbar_map({this.height = kToolbarHeight, required this.title,required this.action});
  @override
  Size get preferredSize => Size.fromHeight(height);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomLeft,
                child: IconButton(
                    icon: Image.asset(
                      "assets/images/png/filter.png",
                      fit: BoxFit.fitHeight,
                    ),
                    onPressed: () {
                      action();
                    }),
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}