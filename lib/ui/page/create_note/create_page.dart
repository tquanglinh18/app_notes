import 'package:app_note_sqflite/model/note_entity.dart';
import 'package:app_note_sqflite/ui/common/app_buttons.dart';
import 'package:app_note_sqflite/ui/page/create_note/create_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return ChangeNotifierProvider<CreateProvider>(
      create: (_) => CreateProvider(),
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10 + MediaQuery.of(context).padding.top, 20, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleTextField,
                  const SizedBox(height: 24),
                  _createdAt,
                  const SizedBox(height: 24),
                  Expanded(
                    child: _contentTextField,
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

  Widget get _contentTextField {
    return Consumer<CreateProvider>(
      builder: (context, createProvider, child) {
        return TextField(
          controller: contentController,
          minLines: 1,
          maxLines: null,
          onChanged: (value) {
            createProvider.onChangedContent(value);
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
    );
  }

  Widget get _titleTextField {
    return Consumer<CreateProvider>(
      builder: (context, createProvider, child) {
        return TextField(
          controller: titleController,
          onChanged: (value) {
            createProvider.onChangedTitle(value);
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
    );
  }

  Widget get _createdAt {
    return Text(
      DateTime.now().toString().split('.').first,
      style: const TextStyle(
        color: AppColors.timeTextColor,
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
    );
  }

  Widget get _optionNote {
    return Consumer<CreateProvider>(
      builder: (context, createProvider, child) {
        return Row(
          children: [
            _backBtn,
            const Spacer(),
            _saveBtn,
          ],
        );
      },
    );
  }

  Widget get _backBtn {
    return AppButtons(
      urlBtn: AppImages.btnBack,
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget get _saveBtn {
    return Consumer<CreateProvider>(
      builder: (context, createProvider, child) {
        return AppButtons(
          active: createProvider.title.isNotEmpty && createProvider.content.isNotEmpty,
          urlBtn: createProvider.title.isNotEmpty && createProvider.content.isNotEmpty
              ? AppImages.btnSaveActive
              : AppImages.btnSaveInActive,
          onTap: () {
            NoteEntity note = NoteEntity(
              title: titleController.text,
              createdAt: DateTime.now().toString().split('.').first,
              lastEditAt: DateTime.now().toString().split('.').first,
              content: contentController.text,
            );
            createProvider.createNote(note);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}