import 'package:languageassistant/model/models/folder_model.dart';
import 'package:languageassistant/model/repository/base_repository.dart';

class FolderRepository extends BaseRepository<FolderModel> {
  FolderRepository()
      : super(
          collectionPath: 'folders',
          fromMap: FolderModel.fromMap,
          toMap: (folder) => folder.toMap(),
        );
}
