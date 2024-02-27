// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';

import 'package:languageassistant/utils/app_icons.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/view_model/learning_view_model.dart';
import 'package:languageassistant/widget/bottomsheet_widget.dart';

class FillterMenu extends StatelessWidget {
  final LearningViewModel learningViewModel;

  const FillterMenu({
    Key? key,
    required this.learningViewModel,
  }) : super(key: key);

  void _showModalBottomSheet(BuildContext context) {
    BottomSheetItem _shuffle = BottomSheetItem(
      icon: Icon(LAIcons.shuffle, color: Colors.black),
      onTap: () {
        learningViewModel.shuffle();
        Navigator.pop(context);
      },
      text: "Trộn từ",
    );

    BottomSheetItem _autoPlayVoice = BottomSheetItem(
      icon: Icon(Icons.volume_up_rounded, color: Colors.black),
      onTap: () {
        learningViewModel.toggleAutoPlayVoice();
        Navigator.pop(context);
        _showModalBottomSheet(context);
      },
      child: Row(
        children: [
          Text(
            'Trạng thái: ',
            style: AppStyle.title,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            learningViewModel.autoPlayVoice ? 'Đang bật' : 'Đang tắt',
            style: TextStyle(
                color: learningViewModel.autoPlayVoice
                    ? AppStyle.successColor
                    : AppStyle.redColor),
          ),
        ],
      ),
    );

    const List<String> list = <String>[
      'Tất cả',
      'Đã học',
      'Chưa học',
      'Đã đánh dấu',
      'Đã thành thạo',
    ];

    BottomSheetItem _fillter = BottomSheetItem(
      icon: Icon(Icons.volume_up_rounded, color: Colors.black),
      onTap: () {
        learningViewModel.toggleAutoPlayVoice();
        Navigator.pop(context);
        _showModalBottomSheet(context);
      },
      child: Row(
        children: [
          Text('Bộ lọc: ', style: AppStyle.textTheme.headline6),
          DropdownMenu<String>(
            initialSelection: learningViewModel.currentFillter,
            width: 150,
            inputDecorationTheme: InputDecorationTheme(
              isDense: true,
              floatingLabelAlignment: FloatingLabelAlignment.center,
              constraints: const BoxConstraints(maxHeight: 40),
            ),
            onSelected: (String? value) {
              learningViewModel.fillter(
                  value!, FirebaseAuth.instance.currentUser!.uid);
            },
            dropdownMenuEntries: list
                .map<DropdownMenuEntry<String>>(
                  (String value) => DropdownMenuEntry<String>(
                    value: value,
                    label: value,
                  ),
                )
                .toList(),
            textStyle: AppStyle.body2,
          ),
        ],
      ),
    );

    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return BottomSheetWidget(
          bottomSheetItems:
              Column(children: [_shuffle, _autoPlayVoice, _fillter]),
          menuItemCount: 2,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showModalBottomSheet(context),
      icon: Icon(Icons.more_vert_rounded),
    );
  }
}
