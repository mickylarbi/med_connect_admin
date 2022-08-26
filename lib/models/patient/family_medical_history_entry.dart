import 'dart:ui';

class FamilyMedicalHistoryEntry {
  String? condition;
  String? relation;

  FamilyMedicalHistoryEntry({this.condition, this.relation});

  FamilyMedicalHistoryEntry.fromMap(Map map) {
    condition = map['condition'] as String?;
    relation = map['relation'] as String?;
  }

  Map<String, String?> toFirestore() {
    return {'condition': condition, 'relation': relation};
  }

  @override
  String toString() {
    return '$condition ($relation)';
  }

  @override
  bool operator ==(other) =>
      other is FamilyMedicalHistoryEntry &&
      other.condition == condition &&
      other.relation == relation;

  @override
  int get hashCode => hashValues(condition, relation);
}
