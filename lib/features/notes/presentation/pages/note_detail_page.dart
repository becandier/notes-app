import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/notes/domain/entities/note.dart';
import 'package:notes_app/features/notes/presentation/bloc/note_detail_cubit.dart';
import 'package:notes_app/features/notes/presentation/bloc/notes_list_cubit.dart';
import 'package:notes_app/features/notes/presentation/bloc/note_detail_state.dart';

/// Страница создания/редактирования заметки
class NoteDetailPage extends StatefulWidget {
  final int? noteId;

  const NoteDetailPage({super.key, this.noteId});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  Note? _currentNote;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.noteId != null;
    
    if (_isEditing) {
      // Если редактируем существующую заметку, загружаем её данные
      context.read<NoteDetailCubit>().getNoteById(widget.noteId!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Редактирование заметки' : 'Новая заметка'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: BlocConsumer<NoteDetailCubit, NoteDetailState>(
        listener: (context, state) {
          if (state is NoteActionCompleted) {
            if (state.isSuccess) {
              if (state.note != null && _isEditing) {
                // Заполняем поля данными из загруженной заметки
                _currentNote = state.note;
                _titleController.text = state.note!.title;
                _contentController.text = state.note!.content;
              } else if (state.message != null) {
                // Показываем сообщение об успешном сохранении и возвращаемся назад
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message!),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              }
            } else if (state.message != null) {
              // Показываем сообщение об ошибке
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          if (state is NoteDetailLoading && _isEditing && _currentNote == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Заголовок',
                      hintText: 'Введите заголовок заметки',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Заголовок не может быть пустым';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Содержание',
                        hintText: 'Введите текст заметки',
                        alignLabelWithHint: true,
                      ),
                      maxLines: null,
                      expands: true,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveNote() {
    // Проверяем валидность формы
    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text;
      final content = _contentController.text;
      
      if (_isEditing && _currentNote != null) {
        // Обновляем существующую заметку
        final updatedNote = Note(
          id: _currentNote!.id,
          title: title,
          content: content,
          createdAt: _currentNote!.createdAt,
        );
        
        context.read<NoteDetailCubit>().updateNote(updatedNote);
        // Обновляем список заметок после обновления
        context.read<NotesListCubit>().refreshNotes();
      } else {
        // Создаем новую заметку
        final newNote = Note(
          title: title,
          content: content,
          createdAt: DateTime.now(),
        );
        
        context.read<NoteDetailCubit>().createNote(newNote);
        // Обновляем список заметок после создания
        context.read<NotesListCubit>().refreshNotes();
      }
    }
  }
}
