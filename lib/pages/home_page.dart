import 'dart:io';

import 'package:band_names_rt/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Su ta gar', votes: 6),
    Band(id: '3', name: 'Berritxarrak', votes: 7),
    Band(id: '4', name: 'Etsaiak', votes: 3),
  ];
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Musika Taldeak / Grupos de música', style: TextStyle( color: Colors.black87 ),),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i)  => _bandTile(bands[i])
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 2,
        child: Icon( Icons.add ),
      ),
    );
  }

  Widget _bandTile( Band band) {
    return Dismissible(
      key: Key( band.id ),
      direction: DismissDirection.startToEnd,
      onDismissed: ( DismissDirection direction ) {
        print('direction: $direction');
        print('band: ${ band.id }');
        // TODO: delete from server call
      },
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
            onTap: () {
              print( band.name );
            }
          ),
    );
  }

  addNewBand() {

    final textController = new TextEditingController();

    if ( Platform.isAndroid ) {
      // Android:
        showDialog(
            context: context, 
            builder: (context) {
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
    print( '$name   ${name.length}' );

    if (name.length > 1) {
      // podemos agregar
      this.bands.add(
        new Band(
          id: DateTime.now().toString(),
          name: name,
          votes: 0
        )
      );

      setState(() {
      
      });
    }
    

    Navigator.pop(context);
  }


}