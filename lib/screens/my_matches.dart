import 'package:fantasyapp/mymatches/my_contest.dart';
import 'package:flutter/material.dart';
import 'package:fantasyapp/widgets/contest_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyMatches extends StatefulWidget {
  const MyMatches({super.key});

  @override
  State<MyMatches> createState() => _MyMatchesState();
}

class _MyMatchesState extends State<MyMatches> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const Drawer(),
        appBar: AppBar(
          title: const Text('My Matches'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('contests')
                .where('registeredUsers',
                    arrayContains: FirebaseAuth.instance.currentUser!.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final contestDocs = snapshot.data?.docs ?? [];
              final contests = contestDocs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

              return ListView.builder(
                itemCount: contests.length,
                itemBuilder: (context, index) {
                  final contestData = contests[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyContest(
                            contestData: contestData,
                          ),
                        ),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
