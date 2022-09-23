import 'package:app_note_sqflite/model/note_entity.dart';
import 'package:app_note_sqflite/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_images.dart';
import '../../common/app_buttons.dart';

class DetailPage extends StatefulWidget {
  final int id;
  final String title;
  final String createdAt;
  final String lastEdit;
  final String content;

  const DetailPage({
    Key? key,
    required this.id,
    required this.title,
    required this.createdAt,
    required this.lastEdit,
    required this.content,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController contentController;

  @override
  void initState() {
    contentController = TextEditingController(text: widget.content);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotesProvider>(
      create: (_) => NotesProvider(),
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Consumer<NotesProvider>(
                builder: (context, notesProvider, child) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(20, 10 + MediaQuery.of(context).padding.top, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          widget.createdAt,
                          style: const TextStyle(
                            color: AppColors.timeTextColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: TextField(
                            controller: contentController,
                            minLines: 1,
                            maxLines: null,
                            enabled: notesProvider.editText,
                            decoration: const InputDecoration(
                              hintText: "Enter Your Text...",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 2.1,
                                color: Colors.grey,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 2.1,
                            ),
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

  Widget get _optionNote {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppButtons(
              urlBtn: AppImages.btnBack,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            Row(
              children: [
                Visibility(
                  visible: !notesProvider.enabledEdit,
                  child: AppButtons(
                    urlBtn: AppImages.btnDelete,
                    onTap: () {
                      notesProvider.confirmDeleteDetailPage();
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Visibility(
                  child: AppButtons(
                    urlBtn: notesProvider.enabledEdit ? AppImages.btnSaveActive : AppImages.btnEdit,
                    onTap: () {
                      // if(notesProvider.editText){
                      //   NoteEntity note = NoteEntity(
                      //     title: widget.title,
                      //     createdAt: widget.createdAt,
                      //     lastEdit: DateTime.now().toString().split(' ').first,
                      //     content: contentController.text,
                      //   );
                      //   notesProvider.updateNote(note);
                      // }
                      // else{
                      //   notesProvider.editingText();
                      // }
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
