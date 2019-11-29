import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_agenda/Screens/performanceTab.dart';
import 'package:student_agenda/Utilities/auth.dart';
import 'package:student_agenda/Utilities/goal.dart';
import 'dart:async';
import 'package:student_agenda/Utilities/util.dart';
import "package:student_agenda/FirestoreManager.dart";

class PerformanceScreen extends StatefulWidget {
  PerformanceScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> with
    SingleTickerProviderStateMixin{

  TabController _tabController;
  ScrollController _scrollController;


  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 3);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new MenuDrawer(),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool boxScrolled){
          return <Widget>[
            SliverAppBar(
              title: Text("Performance"),
              pinned: true,
              floating: true,
              forceElevated: boxScrolled,
              bottom: TabBar(
                onTap: (int idx){
                  _scrollController.animateTo(
                      _scrollController.position.minScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.decelerate);
                },
                tabs: <Widget>[
                  Tab(
                    text: "4 Months",
                  ),
                  Tab(
                    text: "8 Months",
                  ),
                  Tab(
                    text: "12 Months"
                  ),
                ],
                controller: _tabController,
              ),
            )
          ];
        },
        body: TabBarView(
          children: <Widget>[
            PerformanceTab(4),
            PerformanceTab(8),
            PerformanceTab(12)
          ],
          controller: _tabController,
        ),
      ),
    );
  }


}

class TotalTasks extends StatelessWidget {
  const TotalTasks({
    Key key,
    @required this.onTimeNum,
    @required this.text,
  }) : super(key: key);

  final int onTimeNum;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: Container(
                child: Text(
                  '$onTimeNum',
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LegendEntry extends StatelessWidget {
  const LegendEntry({
    Key key,
    @required this.onTimeLegendFont,
    @required this.color,
    @required this.text,
  }) : super(key: key);

  final double onTimeLegendFont;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 100,
        ),
        Container(
          height: 15,
          width: 15,
          color: color,
        ),
        Text(
          text,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: onTimeLegendFont,
          ),
        ),
      ],
    );
  }
}
