import 'package:fantasyapp/contests/contest_info.dart';
import 'package:fantasyapp/contests/leaderboard.dart';
import 'package:fantasyapp/mymatches/guidelines.dart';
import 'package:fantasyapp/mymatches/myteam.dart';
import 'package:fantasyapp/widgets/app_text.dart';
import 'package:flutter/material.dart';

class MyContest extends StatefulWidget {
  const MyContest({super.key});

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
            backgroundColor: Color.fromARGB(255, 176, 144, 229),
            title: AppText(text: 'My Contest'),
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
            children: [Guidelines(), MyTeam(), Leaderboard()],
          ),
        ));
  }
}
