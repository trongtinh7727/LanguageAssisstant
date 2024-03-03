import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/routes/name_routes.dart';
import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/view_model/folder_view_model.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/folder_card_widget.dart';
import 'package:languageassistant/widget/personal_topic_card.dart';

class LibFolderWidget extends StatelessWidget {
  const LibFolderWidget({
    super.key,
    required ScrollController scrollController,
    required this.folderViewModel,
    required FirebaseAuth auth,
  })  : _scrollController = scrollController,
        _auth = auth;

  final ScrollController _scrollController;
  final FolderViewModel folderViewModel;
  final FirebaseAuth _auth;

  @override
  Widget build(BuildContext context) {
    if (folderViewModel.folders.length < 1) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: folderViewModel.folders.length,
      itemBuilder: (context, index) {
        final folder = folderViewModel.folders[index];
        return FolderCard(
          foler: folder,
          onContinue: () {
            folderViewModel.setFolder(folder);
            folderViewModel.fetchUserTopicsByFolder(
                _auth.currentUser!.uid, folder, 200);

            Navigator.pushNamed(
              context,
              RouteName.folderDetailScreen,
            );
          },
        );
      },
    );
  }
}
