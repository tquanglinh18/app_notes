import 'package:app_note_sqflite/common/app_text_style.dart';
import 'package:app_note_sqflite/model/note_entity.dart';
import 'package:app_note_sqflite/ui/page/detail/detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../common/app_images.dart';
import '../../common/app_buttons.dart';
import '../../common/flush_bar.dart';

class DetailPage extends StatefulWidget {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime lastEditAt;

  const DetailPage({
    required this.id,
    Key? key,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.lastEditAt,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController contentController;
  late TextEditingController titleController;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<DetailViewModel>().getNote(widget.id);
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10 + MediaQuery.of(context).padding.top, 20, 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleField,
                  const SizedBox(height: 24),
                  _lastEditAt,
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _contentField,
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

  Widget get _titleField {
    return TextField(
      controller: titleController,
      enabled: context.read<DetailViewModel>().isEnableTextField,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintStyle: AppTextStyle.greyHintS14,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      style: AppTextStyle.blackS24Bold,
    );
  }

  Widget get _lastEditAt {
    return Text(
      DateFormat('d MMM yyyy HH:mm a').format(widget.lastEditAt),
      style: AppTextStyle.lightPlaceholderS12,
    );
  }

  Widget get _contentField {
    return TextField(
      controller: contentController,
      minLines: 1,
      maxLines: null,
      enabled: context.read<DetailViewModel>().isEnableTextField,
      decoration: InputDecoration(
        hintStyle: AppTextStyle.greyHintS14,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      style: AppTextStyle.black,
    );
  }

  Widget get _optionNote {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppButtons(
          urlBtn: AppImages.btnBack,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        context.watch<DetailViewModel>().isConfirmDelete ? _confirmDelete() : _optionDeleteOrEdit(),
      ],
    );
  }

  Widget _optionDeleteOrEdit() {
    return Row(
      children: [
        Visibility(
          visible: !context.watch<DetailViewModel>().isEnableTextField,
          child: AppButtons(
            urlBtn: AppImages.btnDelete,
            onTap: () {
              context.read<DetailViewModel>().confirmDelete();
            },
          ),
        ),
        const SizedBox(width: 20),
        AppButtons(
          urlBtn: context.read<DetailViewModel>().isEnableTextField ? AppImages.btnSaveActive : AppImages.btnEdit,
          onTap: () async {
            if (context.read<DetailViewModel>().isEnableTextField) {
              NoteEntity note = NoteEntity(
                id: widget.id,
                title: titleController.text,
                createdAt: widget.createdAt,
                lastEditAt: DateTime.now(),
                content: contentController.text,
              );
              context.read<DetailViewModel>().updateNote(note).then(
                (value) {
                  DxFlushBar.showFlushBar(
                    context,
                    type: FlushBarType.SUCCESS,
                    title: "Sửa thành công!",
                  );
                },
              );
              context.read<DetailViewModel>().enableTextField();
            } else {
              context.read<DetailViewModel>().enableTextField();
            }
          },
        ),
      ],
    );
  }

  Widget _confirmDelete() {
    return Row(
      children: [
        AppButtons(
          urlBtn: AppImages.btnClose,
          onTap: () {
            context.read<DetailViewModel>().confirmDelete();
          },
        ),
        const SizedBox(width: 20),
        AppButtons(
          urlBtn: AppImages.btnConfirm,
          onTap: () async {
            context.read<DetailViewModel>().deleteNote(widget.id).then(
              (value) {
                DxFlushBar.showFlushBar(
                  context,
                  type: FlushBarType.SUCCESS,
                  title: "Xoá thành công!",
                );
              },
            );
            context.read<DetailViewModel>().confirmDelete();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

