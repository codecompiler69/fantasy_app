import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/app_text.dart';
import '../models/influencer.dart';

class MyTeam extends StatefulWidget {
  final Map<String, dynamic> contestData;

  const MyTeam({Key? key, required this.contestData}) : super(key: key);

  @override
  State<MyTeam> createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  String? teamName;

  @override
  void initState() {
    super.initState();
    fetchTeamName();
  }

  Future<void> fetchTeamName() async {
    final String? currentUser = FirebaseAuth.instance.currentUser?.email;
    final String contestId = widget.contestData['id'];

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('teams')
        .where('contestId', isEqualTo: contestId)
        .where('userId', isEqualTo: currentUser)
        .get();

    final List<QueryDocumentSnapshot> teamDocs = querySnapshot.docs;
    if (teamDocs.isNotEmpty) {
      final teamData = teamDocs.first.data() as Map<String, dynamic>;
      setState(() {
        teamName = teamData['teamName'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? currentUser = FirebaseAuth.instance.currentUser?.email;
    final String contestId = widget.contestData['id'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 22,
        ),
        teamName != null
            ? AppText(
                text: teamName!,
                size: 25,
              )
            : const Text('My Team'),
        const SizedBox(
          height: 30,
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('teams')
                .where('contestId', isEqualTo: contestId)
                .where('userId', isEqualTo: currentUser)
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

              final teamDocs = snapshot.data?.docs ?? [];
              final List<Map<String, dynamic>> teams = teamDocs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

              return ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  final teamData = teams[index];
                  final List<dynamic> selectedInfluencersData =
                      teamData['selectedInfluencers'];

                  return Card(
                    child: Column(
                      children: selectedInfluencersData
                          .map((influencerId) =>
                              StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('influencers')
                                    .doc(influencerId)
                                    .snapshots(),
                                builder: (context, influencerSnapshot) {
                                  if (influencerSnapshot.hasError) {
                                    return const Text('Error');
                                  }
                                  if (influencerSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  final influencerData = influencerSnapshot.data
                                      ?.data() as Map<String, dynamic>?;

                                  if (influencerData == null) {
                                    return const AppText(
                                        text: 'No data available');
                                  }

                                  final Influencer influencer = Influencer(
                                    username: influencerData['username'],
                                    profilePicture: 'assets/images/dummy.jpg',
                                    followerCount:
                                        influencerData['followerCount'],
                                    engagementRate:
                                        influencerData['engagementRate']
                                            ?.toDouble(),
                                    creditPoints: influencerData['creditPoints']
                                        ?.toDouble(),
                                    name: influencerData['name'] ?? '',
                                    niche: influencerData['niche'] ?? '',
                                    shareCount: influencerData['shareCount'],
                                    likesCount: influencerData['likesCount'],
                                    commentsCount:
                                        influencerData['commentsCount'],
                                  );

                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          AssetImage(influencer.profilePicture),
                                    ),
                                    title: Text(
                                      influencer.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          influencer.username,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          'Followers: ${influencer.followerCount}',
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                    trailing: Text(
                                      " Engagement Rate: ${influencer.engagementRate}%",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                },
                              ))
                          .toList(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
