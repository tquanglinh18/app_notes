import 'package:app_note_sqflite/common/app_images.dart';
import 'package:app_note_sqflite/common/app_text_style.dart';
import 'package:app_note_sqflite/ui/common/app_buttons.dart';
import 'package:app_note_sqflite/ui/common/flush_bar.dart';
import 'package:app_note_sqflite/ui/page/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/app_colors.dart';
import '../../../model/note_entity.dart';
import '../create_note/create_note_page.dart';
import '../detail/detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.watch<HomeViewModel>().getListNote();
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10 + MediaQuery.of(context).padding.top, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MY NOTES",
                  style: AppTextStyle.blackS36Bold,
                ),
                _searchBar,
                Text(
                  "Note List",
                  style: AppTextStyle.blackS24Bold,
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: context.watch<HomeViewModel>().listNote.isNotEmpty
                      ? _notEmptyData(context.watch<HomeViewModel>().listNote)
                      : context.watch<HomeViewModel>().keyWord.isEmpty
                          ? _emptyData
                          : _emptySearch,
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
    );
  }

  Widget _notEmptyData(
    List<NoteEntity> listNotes,
  ) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return Column(
          children: [
            _buildItemNote(
              id: listNotes[index].id ?? 0,
              title: listNotes[index].title,
              createdAt: listNotes[index].createdAt,
              lastEditAt: listNotes[index].lastEditAt,
              content: listNotes[index].content,
            ),
            _deleteNoteItem(index: index, id: listNotes[index].id ?? 0),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          height: 20,
        );
      },
      itemCount: listNotes.length,
    );
  }

  Widget _deleteNoteItem({
    required int index,
    required int id,
  }) {
    return Stack(
      children: [
        Visibility(
          visible: context.watch<HomeViewModel>().enableDelete,
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
              color: AppColors.redAccent,
              borderRadius: context.watch<HomeViewModel>().enableDelete
                  ? const BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    )
                  : BorderRadius.circular(5),
            ),
            child: AppButtons(
              onTap: () {
                context.read<HomeViewModel>().showConfirmDelete();
                context.read<HomeViewModel>().changeSelectedIndex(index);
              },
              urlBtn: AppImages.icDelete,
            ),
          ),
        ),
        Visibility(
          visible:
              context.watch<HomeViewModel>().confirmDelete && context.watch<HomeViewModel>().selectedIndex == index,
          child: Container(
            height: 50,
            width: (MediaQuery.of(context).size.width - 40),
            decoration: BoxDecoration(
              color: AppColors.redAccent,
              borderRadius: context.watch<HomeViewModel>().confirmDelete
                  ? const BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    )
                  : BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                _btnClose,
                _btnConfirm(id: id),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget get _emptyData {
    return Text(
      "Add your first note please :D",
      style: AppTextStyle.redAccentS18,
    );
  }

  Widget get _emptySearch {
    return Text(
      "Không có dữ liệu tìm kiếm :(",
      style: AppTextStyle.redAccentS18,
    );
  }

  Widget get _optionNote {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        context.watch<HomeViewModel>().listNote.isNotEmpty ? _btnDelete : const SizedBox(),
        const SizedBox(width: 20),
        _btnAdd,
      ],
    );
  }

  Widget get _btnDelete {
    return AppButtons(
      urlBtn: context.watch<HomeViewModel>().enableDelete || context.watch<HomeViewModel>().confirmDelete
          ? AppImages.btnConfirm
          : AppImages.btnDelete,
      onTap: () {
        !context.read<HomeViewModel>().confirmDelete
            ? context.read<HomeViewModel>().showDelete()
            : {
                context.read<HomeViewModel>().showDelete(),
                context.read<HomeViewModel>().showConfirmDelete(),
              };
      },
    );
  }

  Widget get _btnAdd {
    return Visibility(
      visible: !context.watch<HomeViewModel>().enableDelete || context.watch<HomeViewModel>().listNote.isEmpty,
      child: AppButtons(
        urlBtn: AppImages.btnAdd,
        onTap: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => const CreateNotePage(),
            ),
          )
              .then(
            (value) async {
              context.read<HomeViewModel>().getListNote();
              context.read<HomeViewModel>().enableDelete = false;
            },
          );
        },
      ),
    );
  }

  Widget get _searchBar {
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
            child: _searchTextField,
          ),
          context.watch<HomeViewModel>().keyWord.isEmpty
              ? AppButtons(
                  urlBtn: AppImages.icSearch,
                  onTap: () {},
                )
              : InkWell(
                  onTap: () {
                    context.read<HomeViewModel>().keyWord = '';
                    textController.text = '';
                  },
                  child: const Icon(
                    Icons.close,
                  ),
                ),
        ],
      ),
    );
  }

  Widget get _searchTextField {
    return TextField(
      controller: textController,
      onChanged: (key) {
        context.read<HomeViewModel>().saveKeyWord(key);
      },
      enabled: !context.read<HomeViewModel>().enableDelete & !context.read<HomeViewModel>().confirmDelete,
      decoration: InputDecoration(
        hintText: 'Search your note’s title here ...',
        border: InputBorder.none,
        hintStyle: AppTextStyle.lightPlaceholderS14,
      ),
    );
  }

  Widget _buildItemNote({
    required int id,
    required String title,
    required DateTime createdAt,
    required DateTime lastEditAt,
    required String content,
  }) {
    return InkWell(
      onTap: () {
        context.read<HomeViewModel>().enableDelete || context.read<HomeViewModel>().confirmDelete
            ? null
            : Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    id: id,
                    title: title,
                    createdAt: createdAt,
                    lastEditAt: lastEditAt,
                    content: content,
                  ),
                ),
              );
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.lightSecondary,
          borderRadius: context.watch<HomeViewModel>().enableDelete || context.watch<HomeViewModel>().confirmDelete
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
    );
  }

  Widget _btnConfirm({
    required int id,
  }) {
    return Container(
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
          context.read<HomeViewModel>().showConfirmDelete();
          context.read<HomeViewModel>().deleteNote(id).then(
            (value) {
              DxFlushBar.showFlushBar(
                context,
                type: FlushBarType.SUCCESS,
                title: "Xoá thành công !",
              );
            },
          );
        },
        urlBtn: AppImages.icConfirm,
      ),
    );
  }

  Widget get _btnClose {
    return Container(
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
          context.read<HomeViewModel>().showConfirmDelete();
        },
        urlBtn: AppImages.icClose,
      ),
    );
  }
}
