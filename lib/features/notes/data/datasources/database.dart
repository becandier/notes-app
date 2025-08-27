import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 255)();

  TextColumn get content => text()();

  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;

  /// Получить все заметки, отсортированные по дате создания (по убыванию)
  Future<List<Note>> getAllNotes() =>
      (select(notes)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();

  /// Поиск заметок по запросу
  Future<List<Note>> searchNotes(String query) {
    return (select(notes)
          ..where((t) => t.title.contains(query) | t.content.contains(query))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Получить заметку по идентификатору
  Future<Note> getNoteById(int id) =>
      (select(notes)..where((t) => t.id.equals(id))).getSingle();

  /// Создать новую заметку
  Future<int> createNote(NotesCompanion note) => into(notes).insert(note);

  /// Обновить существующую заметку
  Future<bool> updateNote(NotesCompanion note) => update(notes).replace(note);

  /// Удалить заметку
  Future<int> deleteNote(int id) =>
      (delete(notes)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'notes.db'));
    return NativeDatabase.createInBackground(file);
  });
}
