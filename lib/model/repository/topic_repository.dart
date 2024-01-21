import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/repository/base_repository.dart';

class TopicRepository extends BaseRepository<TopicModel> {
  TopicRepository()
      : super(
          collectionPath: 'topics',
          fromMap: TopicModel.fromMap,
          toMap: (topic) => topic.toMap(),
        );
}
