import 'package:app_note_sqflite/common/app_text_style.dart';
import 'package:app_note_sqflite/model/note_entity.dart';
import 'package:app_note_sqflite/ui/common/app_buttons.dart';
import 'package:app_note_sqflite/ui/page/create_note/create_note_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../common/app_colors.dart';
import '../../../common/app_images.dart';
import '../../common/flush_bar.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({Key? key}) : super(key: key);

  @override
  State<CreateNotePage> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNotePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget get _contentTextField {
    return TextField(
      controller: contentController,
      minLines: 1,
      maxLines: null,
      onChanged: (value) {
        context.read<CreateNoteViewModel>().onChangedContent(value);
      },
      decoration: InputDecoration(
        hintStyle: AppTextStyle.lightPlaceholderS14,
        hintText: 'Write content here ...',
        border: InputBorder.none,
      ),
    );
  }

  Widget get _titleTextField {
    return TextField(
      controller: titleController,
      onChanged: (value) {
        context.read<CreateNoteViewModel>().onChangedTitle(value);
      },
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.timeTextColor,
      ),
      decoration: InputDecoration(
        hintStyle: AppTextStyle.lightPlaceholderS24Bold,
        hintText: "Write title here ...",
        border: InputBorder.none,
      ),
    );
  }

  Widget get _createdAt {
    return Text(
      DateFormat('d MMM yyyy HH:mm a').format(DateTime.now()),
      style: AppTextStyle.lightPlaceholderS12,
    );
  }

  Widget get _optionNote {
    return Row(
      children: [
        _backBtn,
        const Spacer(),
        _saveBtn,
      ],
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
    return AppButtons(
      active: context.watch<CreateNoteViewModel>().title.isNotEmpty &&
          context.watch<CreateNoteViewModel>().content.isNotEmpty,
      urlBtn: context.watch<CreateNoteViewModel>().title.isNotEmpty &&
              context.watch<CreateNoteViewModel>().content.isNotEmpty
          ? AppImages.btnSaveActive
          : AppImages.btnSaveInActive,
      onTap: () {
        NoteEntity note = NoteEntity(
          title: titleController.text,
          createdAt: DateTime.now(),
          lastEditAt: DateTime.now(),
          content: contentController.text,
        );
        context.read<CreateNoteViewModel>().createNote(note).then(
          (value) {
            DxFlushBar.showFlushBar(
              context,
              type: FlushBarType.SUCCESS,
              title: "Thêm thành công!",
            );
          },
        );
        Navigator.of(context).pop();
      },
    );
  }
}
