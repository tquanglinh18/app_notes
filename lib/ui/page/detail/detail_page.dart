import 'package:app_note_sqflite/common/app_text_style.dart';
import 'package:app_note_sqflite/model/note_entity.dart';
import 'package:app_note_sqflite/ui/page/detail/detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_images.dart';
import '../../common/app_buttons.dart';
import '../../common/flush_bar.dart';

class DetailPage extends StatefulWidget {
  final int id;
  final String title;
  final DateTime createdAt;
  final DateTime lastEditAt;
  final String content;

  const DetailPage({
    Key? key,
    required this.id,
    required this.title,
    required this.createdAt,
    required this.lastEditAt,
    required this.content,
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
    return ChangeNotifierProvider<DetailProvider>(
      create: (_) => DetailProvider(),
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Consumer<DetailProvider>(
                builder: (context, detailProvider, child) {
                  return Padding(
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
                  );
                },
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
      ),
    );
  }

  Widget get _titleField {
    return Consumer<DetailProvider>(
      builder: (context, detailProvider, child) {
        return TextField(
          controller: titleController,
          enabled: detailProvider.isEnableTextField,
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
      },
    );
  }

  Widget get _lastEditAt {
    return Text(
      DateFormat('d MMM yyyy HH:mm').format(widget.lastEditAt),
      style: AppTextStyle.lightPlaceholderS12,
    );
  }

  Widget get _contentField {
    return Consumer<DetailProvider>(
      builder: (context, detailProvider, child) {
        return TextField(
          controller: contentController,
          minLines: 1,
          maxLines: null,
          enabled: detailProvider.isEnableTextField,
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
      },
    );
  }

  Widget get _optionNote {
    return Consumer<DetailProvider>(
      builder: (context, detailProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppButtons(
              urlBtn: AppImages.btnBack,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            detailProvider.isConfirmDelete ? _confirmDelete() : _optionDeleteOrEdit(),
          ],
        );
      },
    );
  }

  Widget _optionDeleteOrEdit() {
    return Consumer<DetailProvider>(
      builder: (context, detailProvider, child) {
        return Row(
          children: [
            Visibility(
              visible: !detailProvider.isEnableTextField,
              child: AppButtons(
                urlBtn: AppImages.btnDelete,
                onTap: () {
                  detailProvider.confirmDelete();
                },
              ),
            ),
            const SizedBox(width: 20),
            AppButtons(
              urlBtn: detailProvider.isEnableTextField ? AppImages.btnSaveActive : AppImages.btnEdit,
              onTap: () async {
                NoteEntity note = NoteEntity(
                  id: widget.id,
                  title: titleController.text,
                  createdAt: widget.createdAt,
                  lastEditAt: DateTime.now(),
                  content: contentController.text,
                );
                if (detailProvider.isEnableTextField) {
                  await detailProvider.updateNote(note).then(
                    (value) {
                      DxFlushBar.showFlushBar(
                        context,
                        type: FlushBarType.SUCCESS,
                        title: "Sửa thành công!",
                      );
                    },
                  );
                  detailProvider.enableTextField();
                } else {
                  detailProvider.enableTextField();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _confirmDelete() {
    return Consumer<DetailProvider>(
      builder: (context, detailProvider, child) {
        return Row(
          children: [
            AppButtons(
              urlBtn: AppImages.btnClose,
              onTap: () {
                detailProvider.confirmDelete();
              },
            ),
            const SizedBox(width: 20),
            AppButtons(
              urlBtn: AppImages.btnConfirm,
              onTap: () async {
                detailProvider.deleteNote(widget.id).then(
                  (value) {
                    DxFlushBar.showFlushBar(
                      context,
                      type: FlushBarType.SUCCESS,
                      title: "Xoá thành công!",
                    );
                  },
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
