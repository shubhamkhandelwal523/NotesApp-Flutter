import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_database_example/Providers/ad_providers.dart';
import 'package:sqflite_database_example/db/notes_database.dart';
import 'package:sqflite_database_example/model/note.dart';
import 'package:sqflite_database_example/page/edit_note_page.dart';
import 'package:sqflite_database_example/page/fav_page.dart';
import 'package:sqflite_database_example/page/note_detail_page.dart';
import 'package:sqflite_database_example/widget/note_card_widget.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> with WidgetsBindingObserver {
  late List<Note> notes;
  bool isLoading = false;
  bool showField = false;
  late List<Note> filteredNotes = [];
  TextEditingController searchController = TextEditingController();
  AdProvider adProvider = AdProvider();
  bool isAuthenticated = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    adProvider = Provider.of<AdProvider>(context, listen: false);
    adProvider.initializeHomePageBanner();
    refreshNotes();
  }

  @override
  void dispose() {
    adProvider.homePageBanner.dispose();
    WidgetsBinding.instance.removeObserver(this);
    NotesDatabase.instance.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      adProvider.initializeHomePageBanner();
    }
  }

  Future refreshNotes() async {
    filteredNotes.clear();
    searchController.clear();
    setState(() => isLoading = true);
    this.notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text(
            'Notes',
            style: TextStyle(fontSize: 24),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => FavPage()));
                },
                icon: Icon(Icons.star_rate_rounded)),
            IconButton(
                onPressed: () {
                  setState(() {
                    showField = !showField;
                  });
                },
                icon: showField
                    ? const Icon(Icons.close)
                    : const Icon(Icons.search))
          ],
          bottom: showField
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: CupertinoSearchTextField(
                          controller: searchController,
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 25,
                          ),
                          suffixIcon: const Icon(
                            Icons.cancel_rounded,
                            size: 25,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 5),
                          onSuffixTap: () {
                            searchController.clear();
                            setState(() {
                              filteredNotes.clear();
                            });
                          },
                          onChanged: (value) {
                            filteredNotes = notes
                                .where((note) => note.title
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                            setState(() {});
                          },
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        )),
                  ),
                )
              : PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Container(height: 0),
                ),
        ),
        bottomNavigationBar:
            Consumer<AdProvider>(builder: (context, adprovider, child) {
          return adprovider.isHomePageBannerLoaded
              ? Container(
                  color: Colors.transparent,
                  height: adprovider.homePageBanner.size.height.toDouble(),
                  child: AdWidget(ad: adprovider.homePageBanner),
                )
              : Container(
                  height: 0,
                );
        }),
        body: RefreshIndicator(
          color: Colors.redAccent,
          onRefresh: () {
            return refreshNotes();
          },
          child: Center(
            child: isLoading
                ? CircularProgressIndicator(
                    color: Colors.redAccent,
                  )
                : notes.isEmpty
                    ? Text(
                        'No Notes',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      )
                    : buildNotes(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 35,
          ),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditNotePage()),
            );

            refreshNotes();
          },
        ),
      );

  Widget buildNotes() {
    List<Note> notesToDisplay =
        searchController.text.isEmpty ? notes : filteredNotes;
    return notesToDisplay.isEmpty
        ? Center(
            child: Text(
              'No Record Found',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          )
        : StaggeredGridView.countBuilder(
            padding: EdgeInsets.all(8),
            itemCount: notesToDisplay.length,
            staggeredTileBuilder: (index) => StaggeredTile.fit(2),
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemBuilder: (context, index) {
              final note = notesToDisplay[index];
              final originalNoteIndex = notes.indexOf(note);
              return GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NoteDetailPage(noteId: note.id!),
                  ));

                  refreshNotes();
                },
                child: NoteCardWidget(
                    note: note,
                    index: originalNoteIndex,
                    isImportant: note.isImportant),
              );
            },
          );
  }
}
