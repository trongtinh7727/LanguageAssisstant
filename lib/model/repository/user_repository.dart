import 'package:languageassistant/model/models/user_model.dart';
import 'package:languageassistant/model/repository/base_repository.dart';

class UserRepository extends BaseRepository<UserModel> {
  UserRepository()
      : super(
          collectionPath: 'users',
          fromMap: UserModel.fromMap,
          toMap: (user) => user.toMap(),
        );
}
