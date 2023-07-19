import 'package:fantasyapp/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fantasyapp/widgets/app_text.dart';
import 'package:fantasyapp/widgets/contest_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../contests/contest_info.dart';
import '../contests/create_new_contest.dart';
import '../widgets/category_container.dart';
import '../widgets/wallet_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateContest(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          drawer: const Drawer(),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 176, 144, 229),
            title: const AppText(
              text: 'CONTESTS',
              fontWeight: FontWeight.bold,
            ),
            actions: [
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const WalletContainer(amount: 0);
                  }
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final int walletAmount = userData['wallet_amount'];
                  return WalletContainer(amount: walletAmount);
                },
              ),
              InkWell(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const WelcomeScreen()),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Icon(
                    Icons.logout_rounded,
                    weight: 100,
                  ),
                ),
              ),
            ],
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.live_tv_rounded),
                text: 'Live',
              ),
              Tab(
                icon: Icon(Icons.calendar_month_outlined),
                text: 'Upcoming',
              ),
              Tab(
                icon: Icon(Icons.emoji_events_outlined),
                text: 'Results',
              ),
            ]),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('contests').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: AppText(
                    text: 'Error: ${snapshot.error}',
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final contestDocs = snapshot.data?.docs ?? [];
              List<Map<String, dynamic>> filteredContests = contestDocs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

              if (selectedCategory != 'All') {
                filteredContests = filteredContests
                    .where((contest) => contest['category'] == selectedCategory)
                    .toList();
              }

              return Column(
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 30,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: ((context, index) {
                        return CategoryContainer(
                          text: categories[index],
                          onPressed: () {
                            setState(() {
                              selectedIndex = index;
                              selectedCategory = categories[index];
                            });
                          },
                          isSelected: selectedIndex == index,
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredContests.length,
                      itemBuilder: (context, index) {
                        final contestData = filteredContests[index];
                        return GestureDetector(
                          onTap: () {
                            print('contestdata: ${contestData}');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContestInfo(
                                  contestData: contestData,
                                ),
                              ),
                            );
                          },
                          child: ConstestWidget(
                            image:
                                const AssetImage('assets/images/finance.jpg'),
                            prizepool: contestData['prizePool'],
                            entryfees: contestData['entryFee'],
                            category: contestData['category'],
                            contestStatus: contestData['status'],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
