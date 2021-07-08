import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mem_game/data/data.dart';
import 'package:mem_game/model/tile_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MemoryGame',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // List<TileModel>? pairs = <TileModel>[];
  // List<TileModel>? visible = <TileModel>[];
  static AudioCache player = AudioCache();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pairs = getPairs();
    pairs!.shuffle();

    visible = pairs;
    selected = true;

    Future.delayed(const Duration(microseconds: 1), (){
      setState(() {
        visible = getQuestions();
        selected = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: Column(
          children: <Widget>[
            AppBar(title: Text("MemoryGame",
            style: TextStyle(

            ),),

            ),
            SizedBox(height: 15,),
            Text('Punkte:',
                  style: TextStyle(
                  fontSize: 18,
                  ),),
            Text('$punkte/8',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ) ,),
            SizedBox(height: 5,),
            GridView(
              shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 0.0, maxCrossAxisExtent: 100
                ),
                children: List.generate(visible!.length, (index){
                  return Tile(
                    imageAssetPath: visible![index].getImageAssetPath(),
                    //selected: visible![index].getIsSelected(),
                    parent: this,
                    i: index,
                  );
                }),
            ),
            punkte == 8 ? Text(
                "YOU WON", style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Colors.green,
            ))
            : Text(""),
            ElevatedButton(onPressed: () => {
              // setState(() {
              //   visible = getQuestions();
              //   selected = false;
              // }),
              // pairs!.shuffle(),
              // selected = false,
              punkte = 0,
            },
                child: Text(
                  "RestartGame", style: TextStyle(
                  color: Colors.black,
                )
                ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.yellowAccent;
                    return Colors.yellow; // Use the component's default.
                  },
                ),

              ),
            )
          ],
        ),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  String imageAssetPath;
  //bool? selected;
  int? i;
  _HomeState? parent;

  Tile({required this.imageAssetPath, this.parent, this.i});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(!selected){
          if(selectedImageAssetPath != ""){

            if(selectedImageAssetPath == pairs![widget.i!].getImageAssetPath()){
              //correct
              print("yes");
              selected = true;
              Future.delayed(const Duration(seconds: 2),(){
                punkte = punkte+1;
                setState(() {
                });
                selected = false;
                widget.parent!.setState(() {
                  pairs![widget.i!].setImageAssetPath("");
                  pairs![selectedTileIndex!].setImageAssetPath("");
                });
                selectedImageAssetPath = "";
              });

            }else{
              //wrong
              print("no");
              selected = true;
              Future.delayed(const Duration(seconds: 2),(){
                selected = false;
                widget.parent!.setState(() {
                  pairs![widget.i!].setIsSelected(false);
                  pairs![selectedTileIndex!].setIsSelected(false);
                });

                selectedImageAssetPath = "";
              });
            }

          } else {
            selectedTileIndex = widget.i;
            selectedImageAssetPath = pairs![widget.i!].getImageAssetPath();
          }
          setState(() {
            pairs![widget.i!].setIsSelected(true);
          });
          print('click');
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: pairs![widget.i!].getImageAssetPath() != "" ?
        Image.asset(pairs![widget.i!].getIsSelected() ?
        pairs![widget.i!].getImageAssetPath(): widget.imageAssetPath)
            : Image.asset("assets/haken.png")
      ),
    );
  }
}
