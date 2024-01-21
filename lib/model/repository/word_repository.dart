import 'package:languageassistant/model/models/word_model.dart';
import 'package:languageassistant/model/repository/base_repository.dart';

class WordRepository extends BaseRepository<WordModel> {
  WordRepository()
      : super(
          collectionPath: 'words',
          fromMap: WordModel.fromMap,
          toMap: (word) => word.toMap(),
        );
}
