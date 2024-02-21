import 'package:flutter/material.dart';
import 'package:languageassistant/utils/app_style.dart';

class BottomSheetWidget extends StatefulWidget {
  // const BottomSheetWidget({Key key}) : super(key: key);

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            // height: 125,
            width: 500,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      color: AppStyle.lightText,
                      spreadRadius: 5)
                ]),
            child: Column(
              children: <Widget>[
                BottomSheetItem(
                  icon: Icons.add,
                  onTap: () => {},
                  text: "Thêm",
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BottomSheetItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const BottomSheetItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(16),
          child: TextButton.icon(
            icon: Icon(icon),
            onPressed: onTap,
            label: Text(
              text,
              style: AppStyle.title,
            ),
          )),
    );
  }
}
