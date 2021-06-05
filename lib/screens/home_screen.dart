import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/controllers/script_template_controller.dart';
import 'package:fonetic/models/script_template.dart';

const cardColors = [
  Colors.teal,
  Colors.redAccent,
  Colors.orangeAccent,
  Colors.blue,
  Colors.green,
  Colors.purpleAccent,
];

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'fonetic',
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: Colors.teal),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.settings),
                  )
                ],
              ),
              SizedBox(
                height: 24,
              ),
              _DiscoverPlays()
            ],
          ),
        ),
      ),
    );
  }
}

class _DiscoverPlays extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final scriptTemplates = watch(scriptTemplateProvider);

    return Column(children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        child: Text(
          'Discover plays',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      Container(
          height: 350,
          width: double.infinity,
          child: scriptTemplates.when(data: (data) {
            return ListView.builder(
                itemCount: data.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return _DiscoverPlayCard(template: data[index]);
                });
          }, loading: () {
            return Center(child: CircularProgressIndicator());
          }, error: (e, st) {
            return Container();
          }))
    ]);
  }
}

class _DiscoverPlayCard extends StatelessWidget {
  final ScriptTemplate template;

  const _DiscoverPlayCard({Key? key, required this.template}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rng = new Random();

    return Container(
      width: 250,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF242526),
        gradient: LinearGradient(
            colors: [
              cardColors[rng.nextInt(cardColors.length)].withOpacity(0.3),
              const Color(0xFF242526),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 0.25]),
      ),
      margin: EdgeInsets.only(right: 16),
      child: Container(
          child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                  image: NetworkImage(template.cover), fit: BoxFit.cover),
            ),
            width: 100,
            height: 100,
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 35,
            child: Text(
              template.name,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: Text(
              template.description,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 8,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _PlayData(
                    icon: Icons.schedule, text: '${template.duration} min'),
                SizedBox(
                  width: 16,
                ),
                _PlayData(icon: Icons.people, text: template.roles.toString())
              ],
            ),
          )
        ],
      )),
    );
  }
}

class _PlayData extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PlayData({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color(0xFFb0b3b0),
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.caption,
        )
      ],
    );
  }
}
