import 'package:flutter/material.dart';

import 'package:languageassistant/utils/app_enum.dart';

import 'package:languageassistant/utils/app_style.dart';

class UserLeaderBoardItem extends StatelessWidget {
  final RankItem userRank;

  const UserLeaderBoardItem({
    Key? key,
    required this.userRank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: AppStyle.tabUnselectedColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppStyle.primaryColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(
                5), // Adjust the radius to match your image
            child: Image.network(
              userRank.avatarUrl,
              width: 120,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            userRank.name,
            style: AppStyle.body2_bold,
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.timer_outlined,
                color: AppStyle.primaryColor,
              ),
              Text(
                userRank.time + "s",
                style: AppStyle.active,
              ),
            ],
          ),
          Text(userRank.date),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors
                  .red, // Change color based on the userRank or other logic
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              userRank.rank,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
