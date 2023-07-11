import 'package:fantasyapp/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'influencer_selection_screen.dart';

class ContestInfo extends StatefulWidget {
  const ContestInfo({super.key});

  @override
  State<ContestInfo> createState() => _ContestInfoState();
}

class _ContestInfoState extends State<ContestInfo> {
  bool termsAndConditionsAccepted = false;

  final List<String> rules = [
    'Overview ',
    'Join the Influencer Showdown and build your dream team of Instagram influencers to compete for the highest engagement rate. The team with the most likes, comments, and shares wins exciting prizes!',
    'Team Creation',
    'Each user can create a team of 5 Instagram influencers to represent them in the contest.',
    'Influencer Eligibility',
    'Participants can select influencers from a curated list of eligible Instagram accounts provided in the app.',
    'Engagement Metrics',
    'The contest will consider likes, comments, and shares on the influencers\' posts to calculate the engagement rate.',
    'Scoring',
    'The engagement rate will be calculated based on the total number of likes, comments, and shares divided by the number of followers for each influencer in the team.',
    'Contest Prizes',
    'The team with the highest engagement rate at the end of the contest will win exciting prizes, including cash rewards, brand collaborations, and special recognition.',
    'Fair Play',
    'Any attempt to manipulate engagement or use of unauthorized methods to gain an advantage will result in disqualification.',
    'Contest Updates',
    'Contest rankings and updates will be available in real-time, allowing participants to track their team\'s progress throughout the week.',
    'Sharing',
    'Participants are encouraged to share their team selections, contest participation, and current rankings on social media platforms to engage their followers and attract more participants.'
  ];

  void toggleAcceptance(bool? value) {
    setState(() {
      termsAndConditionsAccepted = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const AppText(
              text: 'Influencer Showdown',
              size: 30,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            const AppText(
              text: 'Duration',
              fontWeight: FontWeight.w600,
              size: 15,
            ),
            const AppText(
              text: 'July 10th - July 17th',
              size: 15,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: rules.length,
                itemBuilder: (context, index) {
                  final rule = rules[index];
                  final isBold = index % 2 == 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: AppText(
                      text: rule,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Checkbox(
                    value: termsAndConditionsAccepted,
                    onChanged: toggleAcceptance,
                  ),
                ),
                const Text('I have read and accept the'),
                const SizedBox(
                  width: 5,
                ),
                const AppText(
                  text: 'Terms and Conditions',
                  color: Colors.blue,
                ),
                const AppText(
                  text: '.',
                ),
              ],
            ),
            ElevatedButton(
              onPressed: termsAndConditionsAccepted
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const InfluencerScreen(),
                        ),
                      );
                    }
                  : null,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
