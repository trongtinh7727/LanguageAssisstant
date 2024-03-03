import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/folder_model.dart';
import 'package:languageassistant/model/models/topic_model.dart';

import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/date_time_util.dart';
import 'package:languageassistant/widget/custom_button.dart';

class FolderCard extends StatelessWidget {
  final FolderModel foler;
  final VoidCallback onContinue;

  const FolderCard({
    Key? key,
    required this.foler,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String word = "Chi Tiết";
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: AppStyle.primaryColor, width: 2)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.folder_outlined),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        foler.title!,
                        style: AppStyle.body2_bold,
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  DateTimeUtil.getDateFromTimestamp(foler.updateTime),
                  style: AppStyle.caption,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  '${foler.topicCount} topics',
                  style: AppStyle.caption,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  onContinue: onContinue,
                  word: word,
                  textColor: AppStyle.activeText,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
