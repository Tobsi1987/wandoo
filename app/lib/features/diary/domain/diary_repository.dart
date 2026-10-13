import 'package:wandoo/features/diary/domain/diary.dart';

/// Speichert die Tagebücher. Die Umsetzung liegt in `data/`.
abstract interface class DiaryRepository {
  /// Trägt einen Gang mit seinen Erinnerungen ein.
  Future<void> add(DiaryWalk walk, List<Memory> memories);

  Future<Diary> load(String creatureKey);

  Stream<Diary> watch(String creatureKey);
}
