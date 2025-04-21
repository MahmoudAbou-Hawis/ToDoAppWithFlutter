import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String email;
  final String name;
  final String id;
  final bool isCompleted;
  final DateTime start;
  final DateTime end;
  final String notes;

  Task({
    required this.name,
    this.email = '',
    this.id = '',
    this.isCompleted = false,
    DateTime? start,
    DateTime? end,
    this.notes = '',
  })  : start = start ?? DateTime.now(),
        end = end ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'id': id,
      'isCompleted': isCompleted,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'notes': notes,
    };
  }

  Task copyWith({
    String? email,
    String? name,
    String? id,
    bool? isCompleted,
    DateTime? start,
    DateTime? end,
    String? notes,
  }) {
    return Task(
      email: email ?? this.email,
      name: name ?? this.name,
      id: id ?? this.id,
      isCompleted: isCompleted ?? this.isCompleted,
      start: start ?? this.start,
      end: end ?? this.end,
      notes: notes ?? this.notes,
    );
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      start: map['start'] != null ? DateTime.parse(map['start']) : DateTime.now(),
      end: map['end'] != null ? DateTime.parse(map['end']) : DateTime.now(),
      notes: map['notes'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        email,
        name,
        id,
        isCompleted,
        start,
        end,
        notes,
      ];
}
