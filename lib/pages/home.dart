import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:socket_io_client/src/socket.dart';

import '../models/band_model.dart';
import '../services/socket_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<BandModel> bands = <BandModel>[];

  @override
  void initState() {
    super.initState();
    ref.read(socketServiceProvider).socket.on('active-bands',
        (dynamic payload) {
      _handleActiveBands(payload);
    });
  }

  dynamic _handleActiveBands(dynamic payload) {
    bands = (payload as List<dynamic>)
        .map(
          (dynamic band) => BandModel.fromJson(band as Map<String, dynamic>),
        )
        .toList();
    setState(() {});
  }

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
        actions: <Widget>[
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final ServerStatus serverStatus =
                  ref.watch(socketServiceProvider).serverStatus;
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: serverStatus == ServerStatus.Online
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green[300],
                      )
                    : Icon(
                        Icons.offline_bolt,
                        color: Colors.red[300],
                      ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          _showPieChartWidet(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (BuildContext context, int index) =>
                  _bandTile(bands[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1.5,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(BandModel bandModel) {
    final Socket socketRead = ref.read(socketServiceProvider).socket;
    return Dismissible(
      key: Key(bandModel.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) =>
          socketRead.emit('delete-band', <String, String>{'id': bandModel.id}),
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
        onTap: () =>
            socketRead.emit('vote-band', <String, dynamic>{'id': bandModel.id}),
      ),
    );
  }

  Future<dynamic> addNewBand() async {
    final TextEditingController textController = TextEditingController();
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) {
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
      ref
          .read(socketServiceProvider)
          .socket
          .emit('add-band', <String, String>{'name': name});
    }
    Navigator.pop(context);
  }

  Widget _showPieChartWidet() {
    final Map<String, double> dataMap = <String, double>{};

    for (final BandModel band in bands) {
      final Map<String, double> newEntrie = <String, double>{
        band.name: band.votes.toDouble()
      };
      dataMap.addEntries(newEntrie.entries);
    }

    final List<Color> colorList = <Color>[
      const Color(0xFF0671B7),
      const Color(0xFF67A3D9),
      const Color(0xFFC8E7F5),
      const Color.fromARGB(255, 238, 180, 203),
      const Color.fromARGB(255, 250, 139, 176),
    ];

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 30,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        legendOptions: const LegendOptions(
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: false,
          decimalPlaces: 0,
          showChartValuesInPercentage: true,
          chartValueStyle: TextStyle(color: Colors.black, fontSize: 11),
        ),
      ),
    );
  }
}

// class PieChartWidget extends StatelessWidget {
//   const PieChartWidget({
//     required this.bands,
//     super.key,
//   });
//   final List<BandModel> bands;

//   @override
//   Widget build(BuildContext context) {
//     final Map<String, double> dataMap = <String, double>{};

//     print('BANDAS $bands');
//     for (final BandModel band in bands) {
//       final Map<String, double> newEntrie = <String, double>{
//         band.name: band.votes.toDouble()
//       };
//       print('ENTRIE: $newEntrie');
//       dataMap.addEntries(newEntrie.entries);
//     }
//     print('DATAMAP : $dataMap');

//     return SizedBox(
//       height: 200,
//       width: double.infinity,
//       child: PieChart(dataMap: dataMap),
//     );
//   }
// }
