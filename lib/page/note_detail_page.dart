import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_database_example/Providers/ad_providers.dart';
import 'package:sqflite_database_example/db/notes_database.dart';
import 'package:sqflite_database_example/model/note.dart';
import 'package:sqflite_database_example/page/edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage>
    with WidgetsBindingObserver {
  late Note note;
  bool isLoading = false;
  AdProvider adProvider = AdProvider();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    adProvider = Provider.of<AdProvider>(context, listen: false);
    adProvider.initializeDetailPageBanner();
    adProvider.initializeFullPageAd();
    refreshNote();
  }

  @override
  void dispose() {
    adProvider.detailPageBanner.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      adProvider
          .initializeDetailPageBanner(); // Reload the ad when the app is resumed
    }
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    this.note = await NotesDatabase.instance.readNote(widget.noteId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          adProvider = Provider.of<AdProvider>(context, listen: false);

          if (adProvider.isFullPageAdLoaded) {
            adProvider.fullPageAd.show();
          }
          return true;
        },
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: Text(
              "Note Details",
              style: TextStyle(fontSize: 24),
            ),
            actions: [editButton(), deleteButton()],
          ),
          bottomNavigationBar:
              Consumer<AdProvider>(builder: (context, adprovider, child) {
            return adprovider.isDetailsPageBannerLoaded
                ? Container(
                    color: Colors.transparent,
                    height: adprovider.detailPageBanner.size.height.toDouble(),
                    child: AdWidget(ad: adprovider.detailPageBanner),
                  )
                : Container(
                    height: 0,
                  );
          }),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.redAccent,
                ))
              : Padding(
                  padding: EdgeInsets.all(12),
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    children: [
                      Text(
                        note.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        DateFormat.yMMMd().format(note.createdTime),
                        style: TextStyle(color: Colors.white38),
                      ),
                      SizedBox(height: 8),
                      Text(
                        note.description,
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      )
                    ],
                  ),
                ),
        ),
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) {
              return Platform.isAndroid
                  ? AlertDialog(
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "CANCEL",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.transparent)),
                        ),
                        TextButton(
                          onPressed: () {
                            NotesDatabase.instance.delete(widget.noteId);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.transparent)),
                        ),
                      ],
                      title: Text(
                        "Delete",
                      ),
                      content: Text("Are you sure you want to delete ?"),
                    )
                  : CupertinoAlertDialog(
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "CANCEL",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.transparent)),
                        ),
                        TextButton(
                          onPressed: () {
                            NotesDatabase.instance.delete(widget.noteId);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.transparent)),
                        ),
                      ],
                      title: Text(
                        "Delete",
                      ),
                      content: Text("Are you sure you want to delete ?"),
                    );
            },
          );
        },
      );
}
