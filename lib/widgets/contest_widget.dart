import 'package:flutter/material.dart';

import 'package:fantasyapp/widgets/app_text.dart';

class ConstestWidget extends StatefulWidget {
  final String prizepool;
  final ImageProvider<Object> image;
  final String entryfees;
  final String category;
  final String contestStatus;

  const ConstestWidget({
    Key? key,
    required this.image,
    required this.prizepool,
    required this.entryfees,
    required this.category,
    required this.contestStatus,
  }) : super(key: key);

  @override
  State<ConstestWidget> createState() => _ConstestWidgetState();
}

class _ConstestWidgetState extends State<ConstestWidget> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 20),
      child: Container(
        height: 150,
        width: width * 0.95,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: width * 0.6,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.image,
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.amber,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  const AppText(
                    text: 'Prize Pool',
                    fontWeight: FontWeight.bold,
                  ),
                  AppText(text: '${widget.prizepool}k'),
                  const SizedBox(
                    height: 10,
                  ),
                  const AppText(
                    text: 'Entry Fee',
                    fontWeight: FontWeight.bold,
                  ),
                  AppText(text: widget.entryfees),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
