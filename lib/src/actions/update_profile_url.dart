part of actions;

@freezed
class UpdateProfileUrl with _$UpdateProfileUrl implements AppAction {
  const factory UpdateProfileUrl(String path) = UpdateProfileUrlStart;

  const factory UpdateProfileUrl.successful(String url) = UpdateProfileUrlSuccessful;

  @Implements(ErrorAction)
  const factory UpdateProfileUrl.error(Object error, StackTrace stackTrace) = UpdateProfileUrlError;
}
