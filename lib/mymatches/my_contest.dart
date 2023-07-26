import 'package:fantasyapp/mymatches/leaderboard.dart';
import 'package:fantasyapp/mymatches/guidelines.dart';
import 'package:fantasyapp/mymatches/myteam.dart';
import 'package:fantasyapp/widgets/app_text.dart';
import 'package:flutter/material.dart';

class MyContest extends StatefulWidget {
  final Map<String, dynamic> contestData;
  const MyContest({super.key, required this.contestData});

  @override
  State<MyContest> createState() => _MyContestState();
}

class _MyContestState extends State<MyContest> {
  late TabController controller;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 176, 144, 229),
          title: const AppText(text: 'My Contest'),
          bottom: const TabBar(tabs: [
            Tab(
              text: 'Guidelines',
            ),
            Tab(
              text: 'My Team',
            ),
            Tab(
              text: 'Leaderboard',
            ),
          ]),
        ),
        body: TabBarView(
          physics: const ScrollPhysics(parent: ScrollPhysics()),
          children: [
            const Guidelines(),
            MyTeam(contestData: widget.contestData),
            Leaderboard(
              contestId: widget.contestData['id'],
            ),
          ],
        ),
      ),
    );
  }
}
