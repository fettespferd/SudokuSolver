import 'package:smusy_v2/app/module.dart';

part 'models.freezed.dart';

@freezed
abstract class ChallengeMode with _$ChallengeMode {
  const factory ChallengeMode.quickplay() = QuickplayMode;
  const factory ChallengeMode.schoolDuel() = SchoolDuelMode;
  const factory ChallengeMode.topic(String topic) = TopicMode;
}
