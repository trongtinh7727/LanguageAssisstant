import 'package:flutter/material.dart';
import 'package:languageassistant/utils/app_style.dart';

class BottomSheetWidget extends StatefulWidget {
  // const BottomSheetWidget({Key key}) : super(key: key);
  final Widget bottomSheetItems;
  final double menuItemCount;
  const BottomSheetWidget(
      {super.key, required this.bottomSheetItems, required this.menuItemCount});

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
      // height: widget.menuItemCount,
      height: 100 * widget.menuItemCount,
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
              child: widget.bottomSheetItems)
        ],
      ),
    );
  }
}

class BottomSheetItem extends StatelessWidget {
  final Icon? icon;
  final String text;
  final Widget child;
  final VoidCallback onTap;
  final bool isLoading; // Thêm trường này

  const BottomSheetItem({
    Key? key,
    this.icon,
    this.child = const Text(""),
    this.text = "",
    required this.onTap,
    this.isLoading = false, // Khởi tạo giá trị mặc định cho trường isLoading
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: icon,
      // subtitle: Text('dsjagdgsa'),
      title: text.isNotEmpty
          ? Text(
              text,
              style: AppStyle.title,
            )
          : child,
    );
  }
}
