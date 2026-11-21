import '../../../../core/widgets/widgets.dart';
import '../providers/dictionary_models.dart';

/// Figma SignListTile: Learned = success, Practising = accent, New = neutral.
extension SignStatusTone on SignStatus {
  IsharaChipTone get chipTone => switch (this) {
    SignStatus.learned => IsharaChipTone.success,
    SignStatus.practising => IsharaChipTone.accent,
    SignStatus.newSign => IsharaChipTone.neutral,
  };
}
