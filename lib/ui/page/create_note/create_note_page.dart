import 'package:app_note_sqflite/database/notes_database.dart';
import 'package:app_note_sqflite/model/note_entity.dart';
import 'package:app_note_sqflite/ui/common/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../notes_provider.dart';
import '../../../common/app_colors.dart';
import '../../../common/app_images.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({Key? key}) : super(key: key);

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotesProvider>(
      create: (_) => NotesProvider(),
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10 + MediaQuery.of(context).padding.top, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<NotesProvider>(
                    builder: (context, note, child) {
                      return TextField(
                        enabled: note.enabledTextFiled,
                        controller: titleController,
                        onChanged: (value) {
                          note.checkTitle(value);
                        },
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.timeTextColor,
                        ),
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.timeTextColor,
                          ),
                          hintText: "Write title here ...",
                          border: InputBorder.none,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    DateTime.now().toString().split(' ').first,
                    style: const TextStyle(
                      color: AppColors.timeTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Consumer<NotesProvider>(
                      builder: (context, note, child) {
                        return TextField(
                          enabled: note.enabledTextFiled,
                          controller: contentController,
                          onChanged: (value) {
                            note.checkContent(value);
                          },
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 2.1,
                              color: AppColors.timeTextColor,
                            ),
                            hintText: 'Write content here ...',
                            border: InputBorder.none,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 55,
              right: 30,
              left: 30,
              child: _optionNote,
            ),
          ],
        ),
      ),
    );
  }

  Widget get _optionNote {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButtons(
              urlBtn: AppImages.btnBack,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            const Expanded(
              child: SizedBox(),
            ),
            //
            Row(
              children: [
                Visibility(
                  visible: notesProvider.enabledEdit & !notesProvider.confirmDeleteDetail,
                  child: AppButtons(
                    urlBtn: AppImages.btnDelete,
                    onTap: () {
                      notesProvider.confirmDeleteDetailPage();
                    },
                  ),
                ),
              ],
            ),
            Visibility(
              visible: notesProvider.confirmDeleteDetail,
              child: Row(
                children: [
                  AppButtons(
                    urlBtn: AppImages.btnClose,
                    onTap: () {},
                  ),
                  const SizedBox(width: 20),
                  AppButtons(
                    urlBtn: AppImages.btnConfirm,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(width: 25),
            Visibility(
              visible: !notesProvider.confirmDeleteDetail,
              child: AppButtons(
                urlBtn: titleController.text.isNotEmpty && contentController.text.isNotEmpty
                    ? !notesProvider.enabledEdit
                        ? AppImages.btnSaveActive
                        : AppImages.btnEdit
                    : AppImages.btnSaveInActive,
                onTap: () {
                  NoteEntity note = NoteEntity(
                    title: titleController.text,
                    createdAt: DateTime.now().toString().split(' ').first,
                    lastEdit: DateTime.now().toString().split(' ').first,
                    content: contentController.text,
                  );
                  NotesDatabase.instance.create(note);
                  //notesProvider.enabledInputText();
                  notesProvider.enableEditText();
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }
}
