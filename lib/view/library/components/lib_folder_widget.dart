import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/folder_model.dart';
import 'package:languageassistant/routes/name_routes.dart';
import 'package:languageassistant/view_model/folder_view_model.dart';
import 'package:languageassistant/widget/folder_card_widget.dart';

class LibFolderWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return StreamBuilder<List<FolderModel>>(
      stream: folderViewModel.streamFoldersByUser(FirebaseAuth.instance
          .currentUser!.uid), // Assuming you have a stream in your ViewModel
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final folders = snapshot.data!;

        return ListView.builder(
          controller: scrollController,
          itemCount: folders.length,
          itemBuilder: (context, index) {
            final folder = folders[index];
            return FolderCard(
              folder: folder,
              onContinue: () {
                folderViewModel.setFolder(folder);
                folderViewModel.fetchUserTopicsByFolder(
                  auth.currentUser!.uid,
                  folder,
                  200,
                );

                Navigator.pushNamed(
                  context,
                  RouteName.folderDetailScreen,
                ).then((_) {
                  // No need to setState with StreamBuilder
                });
              },
            );
          },
        );
      },
    );
  }
}
