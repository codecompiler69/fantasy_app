import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasyapp/widgets/app_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/influencer.dart';

class TeamManagementScreen extends StatefulWidget {
  final List<String> selectedInfluencers;
  final Map<String, dynamic> contestData;
  const TeamManagementScreen(
      {Key? key, required this.selectedInfluencers, required this.contestData})
      : super(key: key);

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> {
  List<Influencer> influencers = [];
  String teamName = 'Enter your Team Name';
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    fetchInfluencerDetails();
  }

  Future<void> fetchInfluencerDetails() async {
    final List<String> usernames = widget.selectedInfluencers;

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('influencers')
        .where('username', whereIn: usernames)
        .get();

    final List<Influencer> fetchedInfluencers = querySnapshot.docs.map((doc) {
      final influencerData = doc.data() as Map<String, dynamic>;
      return Influencer(
        username: influencerData['username'],
        profilePicture: influencerData['profilePicture'],
        followerCount: influencerData['followerCount'],
        engagementRate: influencerData['engagementRate']?.toDouble(),
        creditPoints: influencerData['creditPoints']?.toDouble(),
        name: influencerData['name'] ?? '',
        niche: influencerData['niche'] ?? '',
      );
    }).toList();

    setState(() {
      influencers = fetchedInfluencers;
    });
  }

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void updateTeamName(String newName) {
    setState(() {
      teamName = newName;
    });
  }

  Future<void> onSaveTeam() async {
    if (teamName == 'Enter your Team Name') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please change the team name before saving!'),
        ),
      );
    } else {
      final List<Map<String, dynamic>> selectedInfluencerData =
          influencers.map((influencer) {
        return {
          'username': influencer.username,
          'profilePicture': influencer.profilePicture,
          'followerCount': influencer.followerCount,
          'engagementRate': influencer.engagementRate,
          'creditPoints': influencer.creditPoints,
          'name': influencer.name,
          'niche': influencer.niche,
        };
      }).toList();

      final String? currentUser = FirebaseAuth.instance.currentUser!.email;
      final String contestId = widget.contestData['id'];

      // Fetch the current user's data
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser)
          .get();

      final userData = userSnapshot.data() as Map<String, dynamic>;
      final int walletAmount = userData['wallet_amount'];
      final int entryFee = widget.contestData['entryFee'];

      if (walletAmount < entryFee) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Insufficient funds. Please add more credits to your wallet.'),
          ),
        );
        return;
      }

      final int updatedWalletAmount = walletAmount - entryFee;

      final Map<String, dynamic> teamData = {
        'teamName': teamName,
        'selectedInfluencers': selectedInfluencerData,
        'userId': currentUser,
        'contestId': contestId,
      };

      try {
        final DocumentReference teamRef =
            await FirebaseFirestore.instance.collection('teams').add(teamData);

        // Update the user's wallet_amount
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser)
            .update({
          'wallet_amount': updatedWalletAmount,
          'teams': FieldValue.arrayUnion([teamRef.id]),
          'registeredContests': FieldValue.arrayUnion([contestId]),
        });

        // Update the contest data
        await FirebaseFirestore.instance
            .collection('contests')
            .doc(contestId)
            .update({
          'registeredUsers': FieldValue.arrayUnion([currentUser]),
          'teams': FieldValue.arrayUnion([teamRef.id]),
        });

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Changes saved successfully!'),
          ),
        );
      } catch (error) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Management'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        children: [
          Card(
            child: ListTile(
              title: isEditing
                  ? TextField(
                      onChanged: updateTeamName,
                      decoration: const InputDecoration(
                          labelText: 'Team Name', border: InputBorder.none),
                    )
                  : AppText(
                      text: teamName,
                      fontWeight: FontWeight.bold,
                      size: 20,
                    ),
              trailing: IconButton(
                icon: Icon(isEditing ? Icons.save : Icons.edit),
                onPressed: toggleEditing,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: influencers.length,
            itemBuilder: (context, index) {
              final influencer = influencers[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(influencer.profilePicture),
                  ),
                  title: AppText(
                    text: influencer.name,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: influencer.username,
                      ),
                      AppText(
                        text:
                            'Followers: ${influencer.followerCount.toString()}',
                      ),
                    ],
                  ),
                  trailing: AppText(
                    text: 'Engagement Rate: ${influencer.engagementRate}%',
                    size: 12,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onSaveTeam,
        child: const Icon(Icons.save),
      ),
    );
  }
}
