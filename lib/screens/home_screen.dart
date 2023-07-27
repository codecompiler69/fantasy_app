import 'package:fantasyapp/screens/main_page.dart';

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
  const HomeScreen({Key? key}) : super(key: key);

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

  Future<void> _checkIfRegistered(
      String contestId, Map<String, dynamic> contestData) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .get();

    final List<String> registeredContests =
        List<String>.from(userData.get('registeredContests'));

    if (registeredContests.contains(contestId)) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Thank You!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('You have already registered for this contest.'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainPage(
                          currentScreen: 1,
                        ),
                      ),
                    );
                  },
                  child: const Text('My Matches'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      goToContest(contestData);
    }
  }

  void goToContest(Map<String, dynamic> contestData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContestInfo(
          contestData: contestData,
        ),
      ),
    );
  }

   Future<void> _addMoneyToWallet(int amountToAdd) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .get();

    int currentAmount = userData.get('wallet_amount');
    int newAmount = currentAmount + amountToAdd;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .update({'wallet_amount': newAmount});
  }

 
  Future<void> _showAddMoneyDialog() async {
    int amountToAdd = 0;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Money to Wallet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amountToAdd = int.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addMoneyToWallet(amountToAdd);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                  return WalletContainer(
                    amount: 0,
                    onTap: _showAddMoneyDialog,
                  );
                }
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final int walletAmount = userData['wallet_amount'];
                return WalletContainer(
                  amount: walletAmount,
                  onTap: _showAddMoneyDialog,
                );
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
              icon: Icon(Icons.emoji_events_outlined),
              text: 'Results',
            ),
          ]),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('contests').snapshots(),
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
                      final contestId = contestData['id'];

                      return InkWell(
                        onTap: () {
                          _checkIfRegistered(
                            contestId,
                            contestData,
                          );
                        },
                        child: ConstestWidget(
                          image: const AssetImage('assets/images/finance.jpg'),
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
    );
  }
}
