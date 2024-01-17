import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model.dart';
import 'network.dart';

class PersonCard extends StatelessWidget {
  const PersonCard({
    Key? key,
    required this.person,
    required this.delete,
    required this.update,
  }) : super(key: key);
  final VoidCallback delete;
  final VoidCallback update;
  final Person person;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('ID: ${person.id}'),
                  Text('Name: ${person.name}'),
                  Text('Surname: ${person.surName}'),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    update();
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    CupertinoIcons.arrow_clockwise_circle,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                IconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    await Network().delete(person).whenComplete(delete);
                  },
                  icon: const Icon(
                    CupertinoIcons.delete,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
