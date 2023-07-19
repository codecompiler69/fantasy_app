import 'package:fantasyapp/contests/team_management.dart';
import 'package:fantasyapp/models/influencer.dart';
import 'package:fantasyapp/widgets/app_text.dart';
import 'package:flutter/material.dart';

class MyTeam extends StatefulWidget {
  const MyTeam({super.key});

  @override
  State<MyTeam> createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: AppText(
              text: 'My Team',
              size: 40,
            ),
          ),
          Container(
            child: AppText(
              text: 'Team Name',
              size: 25,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              Influencer tile = influencers[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(tile.profilePicture),
                  ),
                  title: Text(tile.username),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Followers: ${tile.followerCount}'),
                      Text('Engagement Rate: ${tile.engagementRate}%'),
                      Text('Niche: ${tile.niche}'),
                    ],
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
