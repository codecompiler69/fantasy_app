import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard extends StatefulWidget {
  final String contestId;

  const Leaderboard({Key? key, required this.contestId}) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<Map<String, dynamic>> leaderboardData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboardData();
  }

  void _fetchLeaderboardData() async {
    try {
      DocumentSnapshot contestSnapshot = await FirebaseFirestore.instance
          .collection('contests')
          .doc(widget.contestId)
          .get();

      List<dynamic> teamIds = List<dynamic>.from(contestSnapshot['teams']);
      print('team id: $teamIds');

      for (var teamId in teamIds) {
        DocumentSnapshot teamSnapshot = await FirebaseFirestore.instance
            .collection('teams')
            .doc(teamId)
            .get();

        List<dynamic> selectedInfluencers =
            List<dynamic>.from(teamSnapshot['selectedInfluencers']);
        print('selected: ${selectedInfluencers}');

        double totalPoints = 0;
        for (var influencerId in selectedInfluencers) {
          
          DocumentSnapshot influencerSnapshot = await FirebaseFirestore.instance
              .collection('influencers')
              .doc(influencerId)
              .get();

          double shares = influencerSnapshot['shareCount']?.toDouble() ?? 0.0;
          double comments =
              influencerSnapshot['commentsCount']?.toDouble() ?? 0.0;
          double likes = influencerSnapshot['likesCount']?.toDouble() ?? 0.0;

          totalPoints += (shares * 1.5) + (comments * 1.0) + (likes * 0.5);
        }

        
        String userId = teamSnapshot['userId'];
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        String username = userSnapshot['username'];

        leaderboardData.add({'username': username, 'totalPoints': totalPoints});
      }

      leaderboardData
          .sort((a, b) => b['totalPoints'].compareTo(a['totalPoints']));

      setState(() {
        leaderboardData = leaderboardData;
        print('leaderboard $leaderboardData');
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching leaderboard data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: leaderboardData.length,
            itemBuilder: (context, index) {
              final teamData = leaderboardData[index];
              return ListTile(
                leading: Text((index + 1).toString()),
                title: Text(teamData['username']),
                trailing: Text(teamData['totalPoints'].toString()),
              );
            },
          );
  }
}
