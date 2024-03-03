import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/routes/name_routes.dart';
import 'package:languageassistant/view_model/folder_view_model.dart';
import 'package:languageassistant/widget/folder_card_widget.dart';

class LibFolderWidget extends StatefulWidget {
  const LibFolderWidget({
    Key? key,
    required this.scrollController,
    required this.folderViewModel,
    required this.auth,
  }) : super(key: key);

  final ScrollController scrollController;
  final FolderViewModel folderViewModel;
  final FirebaseAuth auth;

  @override
  _LibFolderWidgetState createState() => _LibFolderWidgetState();
}

class _LibFolderWidgetState extends State<LibFolderWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.folderViewModel.isLoading &&
        widget.folderViewModel.folders.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      controller: widget.scrollController,
      itemCount: widget.folderViewModel.folders.length,
      itemBuilder: (context, index) {
        final folder = widget.folderViewModel.folders[index];
        return FolderCard(
          folder: folder,
          onContinue: () {
            widget.folderViewModel.setFolder(folder);
            widget.folderViewModel.fetchUserTopicsByFolder(
              widget.auth.currentUser!.uid,
              folder,
              200,
            );

            Navigator.pushNamed(
              context,
              RouteName.folderDetailScreen,
            ).then((_) {
              setState(() {});
            });
          },
        );
      },
    );
  }
}
