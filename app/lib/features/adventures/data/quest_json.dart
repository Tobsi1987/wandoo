import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/adventures/domain/quest.dart';

/// Wandelt Abenteuer in JSON und zurück, für die Datenbank.
abstract final class QuestJson {
  static Map<String, Object?> encode(Quest q) => {
    'kind': q.kind.name,
    'goal': q.goal,
    'progress': q.progress,
    'environment': q.environment?.name,
    'reward': q.rewardEnvironment?.name,
    'rewardCount': q.rewardCount,
  };

  /// Null bei unbekannten oder kaputten Einträgen.
  static Quest? decode(Object? raw) {
    if (raw is! Map<String, dynamic>) return null;
    final kind = QuestKind.values.asNameMap()[raw['kind']];
    final goal = raw['goal'];
    if (kind == null || goal is! int || goal <= 0) return null;
    return Quest(
      kind: kind,
      goal: goal,
      progress: raw['progress'] is int ? raw['progress'] as int : 0,
      environment: _place(raw['environment']),
      rewardEnvironment: _place(raw['reward']),
      rewardCount: raw['rewardCount'] is int ? raw['rewardCount'] as int : 1,
    );
  }

  static EnvironmentType? _place(Object? name) =>
      EnvironmentType.values.asNameMap()[name];
}
