import 'package:app_note_sqflite/common/app_images.dart';
import 'package:app_note_sqflite/database/notes_database.dart';
import 'package:app_note_sqflite/notes_provider.dart';
import 'package:app_note_sqflite/ui/common/app_buttons.dart';
import 'package:app_note_sqflite/ui/page/create_note/create_note_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/app_colors.dart';
import '../../../model/note_entity.dart';
import '../detail/detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
                  const Text(
                    "MY NOTES",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _buildSearchBar,
                  const Text(
                    "Note List",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Consumer<NotesProvider>(
                      builder: (context, notesProvider, child) {
                        notesProvider.getListNote(keyWord: textController.text);
                        List<NoteEntity> listNotes = notesProvider.listNote;
                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return _buildItemNote(
                              id: listNotes[index].id ?? 0,
                              title: listNotes[index].title,
                              createdAt: listNotes[index].createdAt,
                              lastEdit: listNotes[index].lastEdit,
                              content: listNotes[index].content,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container(
                              height: 20,
                            );
                          },
                          itemCount: listNotes.length,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 55,
              right: 30,
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
              urlBtn: notesProvider.enabledDelete || notesProvider.confirmDelete
                  ? AppImages.btnConfirm
                  : AppImages.btnDelete,
              onTap: () {
                !notesProvider.confirmDelete
                    ? notesProvider.enableDeleteBtn()
                    : {
                        notesProvider.enableDeleteBtn(),
                        notesProvider.confirmDeleteBtn(),
                      };
              },
            ),
            const SizedBox(width: 20),
            Visibility(
              visible: !notesProvider.enabledDelete,
              child: AppButtons(
                urlBtn: AppImages.btnAdd,
                onTap: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => const CreateNotePage(),
                    ),
                  )
                      .then((value) async {
                    notesProvider.getListNote();
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget get _buildSearchBar {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, child) {
        return Container(
          height: 52,
          width: MediaQuery.of(context).size.width - 40,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          margin: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: AppColors.lightSecondary,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    hintText: 'Search your note’s title here ...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(),
                  ),
                ),
              ),
              AppButtons(
                urlBtn: AppImages.icSearch,
                onTap: () {},
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemNote({
    required int id,
    required String title,
    required String createdAt,
    required String lastEdit,
    required String content,
  }) {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, child) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailPage(
                  id: id,
                  lastEdit: lastEdit,
                  title: title,
                  content: content,
                  createdAt: createdAt,
                ),
              ),
            );
          },
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 40,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.lightSecondary,
                  borderRadius: notesProvider.enabledDelete || notesProvider.confirmDelete
                      ? const BorderRadius.only(
                          topRight: Radius.circular(5),
                          topLeft: Radius.circular(5),
                        )
                      : BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      content,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Visibility(
                    visible: notesProvider.enabledDelete,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: AppColors.redAccent,
                        borderRadius: notesProvider.enabledDelete
                            ? const BorderRadius.only(
                                bottomRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              )
                            : BorderRadius.circular(5),
                      ),
                      child: AppButtons(
                        onTap: () {
                          notesProvider.confirmDeleteBtn();
                        },
                        urlBtn: AppImages.icDelete,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: notesProvider.confirmDelete,
                    child: Container(
                      height: 50,
                      width: (MediaQuery.of(context).size.width - 40),
                      decoration: BoxDecoration(
                        color: AppColors.redAccent,
                        borderRadius: notesProvider.confirmDelete
                            ? const BorderRadius.only(
                                bottomRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              )
                            : BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            decoration: const BoxDecoration(
                              color: AppColors.greenAccent,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                            child: AppButtons(
                              onTap: () {
                                notesProvider.confirmDeleteBtn();
                              },
                              urlBtn: AppImages.icClose,
                            ),
                          ),
                          Container(
                            height: 50,
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            decoration: const BoxDecoration(
                              color: AppColors.redAccent,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            child: AppButtons(
                              onTap: () {
                                notesProvider.deleteNote(id);
                                notesProvider.confirmDeleteBtn();
                              },
                              urlBtn: AppImages.icConfirm,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
