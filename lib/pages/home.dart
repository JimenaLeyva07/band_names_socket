import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/band_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BandModel> bands = <BandModel>[
    const BandModel(id: '1', name: 'Florence', votes: 5),
    const BandModel(id: '2', name: 'Hozier', votes: 7),
    const BandModel(id: '3', name: 'Tamino', votes: 10),
    const BandModel(id: '4', name: 'Laufey', votes: 3),
    const BandModel(id: '5', name: 'November', votes: 1),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: const Text(
          'Artists Names',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) =>
            _bandTile(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1.5,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(BandModel bandModel) {
    return Dismissible(
      key: Key(bandModel.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        bands.removeWhere((BandModel element) => element.id == bandModel.id);
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Text(
                ' Delete',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(bandModel.name.substring(0, 2)),
        ),
        title: Text(bandModel.name),
        trailing: Text('${bandModel.votes}'),
        onTap: () {
          print(bandModel.name);
        },
      ),
    );
  }

  Future<dynamic> addNewBand() async {
    final TextEditingController textController = TextEditingController();
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('New Artist Name'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => addArtistToList(textController.text),
                elevation: 5,
                textColor: Colors.blue,
                child: const Text('Add'),
              )
            ],
          );
        },
      );
    }
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('New Artist Name'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Add'),
              onPressed: () => addArtistToList(textController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Dismiss'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  void addArtistToList(String name) {
    if (name.length > 1) {
      bands.add(BandModel(id: DateTime.now().toString(), name: name));
    }
    setState(() {});
    Navigator.pop(context);
  }
}
