import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'data_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => Noter())],
    child: MyApp(),
  ));
}

class Noter with ChangeNotifier, DiagnosticableTreeMixin {
  List notes = ['Provider used!'];

  void add(value) {
    notes.add(value);
    notifyListeners();
  }

  void clear() {
    notes.clear();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Notes')),
        body: SingleChildScrollView(
          child: Column(
            children: [AddNote(), NotesList(), ElevatedButton(onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => DataScreen()));
            }, child: Text('Get data!'))],
          ),
        ));
  }
}

class AddNote extends StatelessWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return Card(
      child: Column(
        children: [
          Text('Add a note'),
          TextField(
            onEditingComplete: () {
              context.read<Noter>().add(textEditingController.text);
            },
            controller: textEditingController,
          ),
          ElevatedButton(
              onPressed: () {
                context.read<Noter>().add(textEditingController.text);
              },
              child: Text('Add'))
        ],
      ),
    );
  }
}

class NotesList extends StatelessWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Notes:'),
        ListView.builder(
          itemCount: context.watch<Noter>().notes.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Card(child: Text('${context.watch<Noter>().notes[index]}'));
          },
        ),
        ElevatedButton(
            onPressed: () {
              context.read<Noter>().clear();
            },
            child: Text('Clean'))
      ],
    );
  }
}
