import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_database_example/Providers/ad_providers.dart';
import 'package:sqflite_database_example/db/notes_database.dart';
import 'package:sqflite_database_example/model/note.dart';
import 'package:sqflite_database_example/widget/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);
  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  AdProvider adProvider = AdProvider();
  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
    WidgetsBinding.instance.addObserver(this);
    adProvider = Provider.of<AdProvider>(context, listen: false);
    adProvider.initializeEditAndAddPageBanner();
    adProvider.initializeFullPageForAddAndEditAd();
  }

  @override
  void dispose() {
    adProvider.addEditPageBanner.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      adProvider.initializeEditAndAddPageBanner();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text(
            widget.note?.id != null ? "Edit Note" : " Add Note",
            style: TextStyle(fontSize: 24),
          ),
          actions: [buildButton()],
        ),
        bottomNavigationBar:
            Consumer<AdProvider>(builder: (context, adprovider, child) {
          return adprovider.isAddEditPageBannerLoaded
              ? Container(
                  color: Colors.transparent,
                  height: adprovider.addEditPageBanner.size.height.toDouble(),
                  child: AdWidget(ad: adprovider.addEditPageBanner),
                )
              : Container(
                  height: 0,
                );
        }),
        body: Form(
          key: _formKey,
          child: NoteFormWidget(
            isImportant: isImportant,
            title: title,
            description: description,
            onChangedImportant: (isImportant) =>
                setState(() => this.isImportant = isImportant),
            onChangedNumber: (number) => setState(() => this.number = number),
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor:
              isFormValid ? Colors.redAccent : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
      adProvider = Provider.of<AdProvider>(context, listen: false);

      if (adProvider.isFullPageAdEditAndAddLoaded) {
        adProvider.fullPageAdEditAndAdd.show();
      }
      return;
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );

    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      isImportant: isImportant,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
  }
}
