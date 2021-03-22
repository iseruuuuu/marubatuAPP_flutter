//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//別ファイルから読み込む
import 'model.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'まるばつゲーム！'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //playerの設定。。。。◯->true   ,✖︎→false
  bool turnOfCirlce = true;

  //ボタンの設定。。
  List<PieceStatus> statusList = List.filled(9, PieceStatus.none);
  GameStatus gameStatus = GameStatus.play;
  List<Widget> buildLine = [Container()];
  double lineThickness = 4.0;
  double lineWidth;

  final List<List<int>> settlementListHorizontal = [
    //横の勝ち方
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8]
  ];

  //横の勝ち方
  final List<List<int>> settlementListVertical = [
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8]
  ];

  final List<List<int>> settlementListDiagonal = [
    //斜めの勝ち方
    [0, 4, 8],
    [2, 4, 6]
  ];

  @override
  Widget build(BuildContext context) {
    //ここに定義する。
    lineWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.circle,
              color: Colors.green,
              size: 30,
            ),
            Icon(
              Icons.clear,
              color: Colors.red,
              size: 40,
            ),
            Text("ゲーム")
          ],
        ),
      ),
      //メソット化した。
      body: Column(
        children: [
          //ターン
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildRow(),
                OutlineButton(
                  borderSide: BorderSide(),
                  child: Text("クリア"),
                  onPressed: () {
                    setState(() {
                      turnOfCirlce = true;
                      statusList = List.filled(9, PieceStatus.none);
                      gameStatus = GameStatus.play;
                      buildLine = [Container()];
                    });
                  },
                )
              ],
            ),
          ),
          buildColumn(),
        ],
      ),
    );
  }

  Widget buildRow() {
    switch (gameStatus) {
      case GameStatus.play:
        return Row(
          children: [
            turnOfCirlce ? Icon(FontAwesomeIcons.circle) : Icon(Icons.clear),
            Text('のターン'),
          ],
        );
        break;
      case GameStatus.draw:
        return Text("引き分けです。");
        break;
      case GameStatus.settlement:
        return Row(
          children: [
            !turnOfCirlce ? Icon(FontAwesomeIcons.circle) : Icon(Icons.clear),
            Text("の勝ちです。"),
          ],
        );

        break;
      default:
        return Container();
    }
  }

  Widget buildColumn() {
    //縦の３列を作成するメソッド
    List<Widget> _columeChildren = [
      Divider(
        height: 0.0,
        color: Colors.black,
      )
    ];
    //横の３列のメソッド
    List<Widget> _rowChildren = [];

    for (int j = 0; j < 3; j++) {
      //横の行を作成するもの
      for (int i = 0; i < 3; i++) {
        int _index = j * 3 + i;
        _rowChildren.add(
          Expanded(
              //押せるようにするもの
              child: InkWell(
            onTap: gameStatus == GameStatus.play
                ? () {
                    if (statusList[_index] == PieceStatus.none) {
                      statusList[_index] =
                          turnOfCirlce ? PieceStatus.cirlce : PieceStatus.cross;
                      turnOfCirlce = !turnOfCirlce;
                      confirmResult();
                    }
                    setState(() {});
                  }
                : null,
            child: AspectRatio(
                aspectRatio: 1.0,
                child: Row(
                  children: [
                    Expanded(child: build1(statusList[_index])),
                    (i == 2)
                        ? Container()
                        : VerticalDivider(
                            width: 0.0,
                            color: Colors.black,
                          ),
                  ],
                )),
          )),
        );
      }
      _columeChildren.add(Row(
        children: _rowChildren,
      ));
      _columeChildren.add(Divider(
        height: 0.0,
        color: Colors.black,
      ));
      //一度殻にしておかないと永遠ループしてします。。。→初期化する。
      _rowChildren = [];
    }

    return Stack(
      children: [
        Column(children: _columeChildren),
        Stack(
          children: buildLine,
        )
      ],
    );
  }

  /*
      children: [
        Row(
          children: [
            Expanded(
                child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Row(
                      children: [
                        Expanded(child: Container(color: Colors.grey)),
                        //VerticalDivider()は、横に線を引く。。
                        VerticalDivider(
                          width: 0.0,
                          color: Colors.black,
                        ),
                      ],
                    ))),
            Expanded(
                child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Row(
                      children: [
                        Expanded(child: Container(color: Colors.grey)),
                        VerticalDivider(
                          width: 0.0,
                          color: Colors.black,
                        ),
                      ],
                    ))),
            Expanded(
                child: AspectRatio(
                    aspectRatio: 1.0, child: Container(color: Colors.grey))),
          ],
        ),
        Divider(
          height: 0.0,
          color: Colors.black,
        ),
        Row(
          children: [
            Expanded(
                child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Row(
                      children: [
                        Expanded(child: Container(color: Colors.grey)),
                        //VerticalDivider()は、横に線を引く。。
                        VerticalDivider(
                          width: 0.0,
                          color: Colors.black,
                        ),
                      ],
                    ))),
            Expanded(
                child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Row(
                      children: [
                        Expanded(child: Container(color: Colors.grey)),
                        VerticalDivider(
                          width: 0.0,
                          color: Colors.black,
                        ),
                      ],
                    ))),
            Expanded(
                child: AspectRatio(
                    aspectRatio: 1.0, child: Container(color: Colors.grey))),
          ],
        ),
        Divider(
          height: 0.0,
          color: Colors.black,
        ),
        Row(
          children: [
            Expanded(
                child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Row(
                      children: [
                        Expanded(child: Container(color: Colors.grey)),
                        //VerticalDivider()は、横に線を引く。。
                        VerticalDivider(
                          width: 0.0,
                          color: Colors.black,
                        ),
                      ],
                    ))),
            Expanded(
                child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Row(
                      children: [
                        Expanded(child: Container(color: Colors.grey)),
                        VerticalDivider(
                          width: 0.0,
                          color: Colors.black,
                        ),
                      ],
                    ))),
            Expanded(
                child: AspectRatio(
                    aspectRatio: 1.0, child: Container(color: Colors.grey))),
          ],
        ),
      ],
    );

       */

  Container build1(PieceStatus pieceStatus) {
    switch (pieceStatus) {
      case PieceStatus.none:
        return Container();
        break;
      case PieceStatus.cirlce:
        return Container(
          child: Icon(
            FontAwesomeIcons.circle,
            color: Colors.blue,
            size: 60,
          ),
        );
        break;
      case PieceStatus.cross:
        return Container(
          child: Icon(
            Icons.clear,
            size: 60,
            color: Colors.red,
          ),
        );
        break;

      default:
        return Container();
    }
  }

  void confirmResult() {
    if (!statusList.contains(PieceStatus.none)) {
      gameStatus = GameStatus.draw;
    }

    //行における勝敗のパターン
    for (int i = 0; i < settlementListHorizontal.length; i++) {
      if (statusList[settlementListHorizontal[i][0]] ==
              statusList[settlementListHorizontal[i][1]] &&
          statusList[settlementListHorizontal[i][1]] ==
              statusList[settlementListHorizontal[i][2]] &&
          statusList[settlementListHorizontal[i][0]] != PieceStatus.none) {
        buildLine.add(Container(
          width: lineWidth,
          height: lineThickness,
          color: Colors.black.withOpacity(0.3),
          margin: EdgeInsets.only(
              top: lineWidth / 3 * i + lineWidth / 6 - lineThickness / 2),
        ));
        gameStatus = GameStatus.settlement;
      }
    }
    //行における勝敗のパターン
    for (int i = 0; i < settlementListVertical.length; i++) {
      if (statusList[settlementListVertical[i][0]] ==
              statusList[settlementListVertical[i][1]] &&
          statusList[settlementListVertical[i][1]] ==
              statusList[settlementListVertical[i][2]] &&
          statusList[settlementListVertical[i][0]] != PieceStatus.none) {
        buildLine.add(Container(
          width: lineThickness,
          height: lineWidth,
          color: Colors.black.withOpacity(0.3),
          margin: EdgeInsets.only(
              left: lineWidth / 3 * i + lineWidth / 6 - lineThickness / 2),
        ));
        gameStatus = GameStatus.settlement;
      }
    }
    //斜めにおける勝敗パターン
    for (int i = 0; i < settlementListDiagonal.length; i++) {
      if (statusList[settlementListDiagonal[i][0]] ==
              statusList[settlementListDiagonal[i][1]] &&
          statusList[settlementListDiagonal[i][1]] ==
              statusList[settlementListDiagonal[i][2]] &&
          statusList[settlementListDiagonal[i][0]] != PieceStatus.none) {
        buildLine.add(Transform.rotate(
          alignment: i == 0 ? Alignment.topLeft : Alignment.topRight,
          angle: i == 0 ? -pi / 4 : pi / 4,
          child: Container(
            width: lineThickness,
           /// height: lineWidth * sqrt(2),
            height: lineWidth * sqrt(1.7),
            color: Colors.black.withOpacity(0.5),
            margin:
                EdgeInsets.only(left: i == 0 ? 0.0 : lineWidth - lineThickness),
          ),
        ));
        gameStatus = GameStatus.settlement;
      }
    }
  }
}

//todo タイトル ->OK!
//todo フィールドのUI -> OK!
//todo UIを簡単に＝＞OK!
//todo ターンの表示とクリアボタンの作成-> OK!
//todo マス目をタップ可能にする。-> OK!
//todo まるばつを表示-> OK!
//todo 勝敗パターンを書き出す。-> OK!
//todo 勝敗判定を出す。
//todo リセットでリスタート
