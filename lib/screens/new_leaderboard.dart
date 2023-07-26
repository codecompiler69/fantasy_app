import 'package:fantasyapp/models/winners.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  AssetImage('assets/images/logo.png'),
                            ),
                            Positioned(
                              top: -13,
                              left: -15,
                              child: Image.asset(
                                'assets/images/2nd_badge.png',
                                width: 55,
                                height: 55,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '8699',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.merriweather().fontFamily,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'jamie_tewst',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.merriweather().fontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            const CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  AssetImage('assets/images/logo.png'),
                            ),
                            Positioned(
                              top: -7,
                              left: -12,
                              child: Image.asset(
                                'assets/images/1st_badge.png',
                                width: 62,
                                height: 62,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '8699',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.merriweather().fontFamily,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'jamie_tewst',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.merriweather().fontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  AssetImage('assets/images/logo.png'),
                            ),
                            Positioned(
                              top: -13,
                              left: -15,
                              child: Image.asset(
                                'assets/images/3rd_badge.png',
                                width: 55,
                                height: 55,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '8699',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.merriweather().fontFamily,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'jamie_tewst',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.merriweather().fontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: ListView.builder(
                itemCount: winners.length,
                itemBuilder: ((context, index) {
                  Winners currentwinner = winners[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 228, 224, 236),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ListTile(
                        leading: Text(
                          (index + 4).toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: GoogleFonts.merriweather().fontFamily,
                            fontSize: 20,
                          ),
                        ),
                        title: Row(
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundImage:
                                  AssetImage('assets/images/logo.png'),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              currentwinner.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily:
                                    GoogleFonts.merriweather().fontFamily,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          currentwinner.score.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: GoogleFonts.merriweather().fontFamily,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
