import 'package:fantasyapp/mymatches/my_contest.dart';
import 'package:fantasyapp/widgets/app_text.dart';
import 'package:flutter/material.dart';

import '../widgets/contest_widget.dart';

class MyMatches extends StatefulWidget {
  const MyMatches({super.key});

  @override
  State<MyMatches> createState() => _MyMatchesState();
}

class _MyMatchesState extends State<MyMatches> {
  List<String> categories = [
    'All',
    'Finance',
    'Gaming',
    'Technology',
    'Business',
    'Science',
    'Fitness',
    'Politics'
  ];
  int selectedIndex = 0;
  List<ConstestWidget> allContestWidgets = const [
    ConstestWidget(
      image: AssetImage('assets/images/gaming.webp'),
      prizepool: '10',
      entryfees: '220',
      category: 'Gaming',
      contestStatus: 'live',
    ),
    ConstestWidget(
      image: AssetImage('assets/images/finance.jpg'),
      prizepool: '50',
      entryfees: '100',
      category: 'Finance',
      contestStatus: 'live',
    ),
  ];
  List<ConstestWidget> get filteredContestWidgets {
    if (selectedIndex == 0) {
      return allContestWidgets;
    } else {
      String selectedCategory = categories[selectedIndex];
      return allContestWidgets
          .where((contest) => contest.category == selectedCategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 176, 144, 229),
        title: AppText(
          text: 'My Matches',
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContestWidgets.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyContest()));
                  },
                  child: filteredContestWidgets[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
