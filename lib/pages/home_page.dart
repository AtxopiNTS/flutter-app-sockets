import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:provider/provider.dart';

import 'package:band_names_rt/models/band.dart';
import 'package:band_names_rt/services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    // Band(id: '1', name: 'Metallica', votes: 5),
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  void _handleActiveBands( payload ) {
      print( payload );

      this.bands = ( payload as List )
        .map( (band) => Band.fromMap(band) )
        .toList();

      setState(() {}); //repaint
  }  

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');

    super.dispose();
  }
   
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Musika Taldeak / Grupos de música', style: TextStyle( color: Colors.black87 ),),
        backgroundColor: Colors.white,
        elevation: 2,
        actions: [
          Container(
            margin: EdgeInsets.only( right: 10),
            child: 
            socketService.serverStatus == ServerStatus.Online
              ? Icon( Icons.check_circle_rounded, color: Colors.green[300] )
              : Icon( Icons.offline_bolt, color: Colors.red ),
          )
        ],
      ),
      body: Column(
        children: [

          _showGraphPie(),

          Expanded(
            child: ListView.builder(
                    itemCount: bands.length,
                    itemBuilder: (context, i)  => _bandTile(bands[i])
                  ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 2,
        child: Icon( Icons.add ),
      ),
    );
  }

  Widget _bandTile( Band band) {

    final socketService = Provider.of<SocketService>(context);

    return Dismissible(
      key: Key( band.id ),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ) => socketService.socket.emit('delete-band', { 'id': band.id } ),
      background: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon( Icons.delete_forever_outlined, color: Colors.white70 ),
                Text('Ezabatu?',  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70 ) ),
              ],
            )
          ),
        )
      ),
      child: ListTile(
            leading: CircleAvatar(
              child: Text( band.name.substring(0,2) ) ,
              backgroundColor: Colors.blue[100],
            ),
            title: Text( band.name ),
            trailing: Text('${ band.votes }', style: TextStyle( fontSize: 20 )),
            onTap: () => socketService.socket.emit('vote-band', { 'id': band.id } ),
          ),
    );
  }

  addNewBand() {

    final textController = new TextEditingController();

    if ( Platform.isAndroid ) {
      // Android:
        showDialog(
            context: context, 
            builder: ( _ ) {
              return AlertDialog(
                title: Text('Talde berria:'),
                content: TextField(
                  controller: textController,
                ),
                actions: [
                  MaterialButton(
                    child: Text('Gehitu'),
                    elevation: 5,
                    textColor: Colors.blue,
                    onPressed: () {
                      addBandToList( textController.text );
                    }
                  )
                ],
              );
            }
          );
    }

    if ( Platform.isIOS ) {
      // iOS
      showCupertinoDialog(
        context: context, 
        builder: ( _ ) {
          return CupertinoAlertDialog(
            title: Text('Talde berriaren izena: '),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('+'),
                onPressed: () {
                    addBandToList( textController.text );
                }
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Dismiss'),
                onPressed: () {
                    Navigator.pop(context);
                }
              ),
            ],
          );
        }
      );

    }


  }


    

  void addBandToList( String name) {
    // print( '$name   ${name.length}' );

    if (name.length > 1) {
      /// podemos agregar
      final socketService = Provider.of<SocketService>(context, listen: false);

      socketService.socket.emit('add-band', { 'name': name });

      // this.bands.add(
      //   new Band(
      //     id: DateTime.now().toString(),
      //     name: name,
      //     votes: 0
      //   )
      // );

      // setState(() {});
    }
    Navigator.pop(context);
  }
  
  Widget _showGraphPie() {

    Map<String, double> dataMap = new Map();
    bands.forEach( (band) {
      dataMap.putIfAbsent( band.name, () => band.votes.toDouble() );
    });

    final List<Color> colorList = [
            Colors.black12,
      Colors.black54,
      Colors.green.shade200,
      Colors.green.shade600,
      Colors.blue.shade200,
      Colors.blue.shade600,
      Colors.amber.shade200,
      Colors.amber.shade600,
      Colors.redAccent.shade200,
      Colors.redAccent.shade700,
      Colors.purple.shade200,
      Colors.purple.shade700,

    ];

    return Container(
      width: double.infinity,
      height: 225,
      child: PieChart(dataMap: dataMap,
        // animationDuration: Duration(milliseconds: 800),
        // chartLegendSpacing: 32,
        // chartRadius: MediaQuery.of(context).size.width / 3.2,
        colorList: colorList,
        // initialAngleInDegree: 0,
        // chartType: ChartType.ring,
        // ringStrokeWidth: 32,
        centerText: "🎧",
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: false,
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
          decimalPlaces: 0,
      ),
      )
    );
  }


}