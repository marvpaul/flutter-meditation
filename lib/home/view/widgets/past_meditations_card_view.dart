import 'package:flutter/material.dart';

class PastMeditationsCardView extends StatelessWidget {
  const PastMeditationsCardView({
    Key? key,
    required this.meditationSessionEntries,
    this.onPressed,
  }) : super(key: key);

  final int meditationSessionEntries;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Icon(
                    Icons.timeline_rounded,
                    size: 40,
                  ),
                  const SizedBox(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Show Past Meditation Sessions',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 5),
                      Text('$meditationSessionEntries ${meditationSessionEntries == 1 ? 'entry' : 'entries'}',
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded)
                ]),
          ),
        ),
      ),
    );
  }
}
