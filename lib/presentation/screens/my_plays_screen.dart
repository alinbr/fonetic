import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/my_plays_controller.dart';
import 'package:fonetic/presentation/widgets/loading_center.dart';

class MyPlaysScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final myPlays = watch(myPlaysProvider('1'));

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            'My plays',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: myPlays.when(
            data: (data) {
              return ListView.builder(
                itemBuilder: (ctx, i) {
                  return Text(data[i].playStatus.toString());
                },
                itemCount: data.length,
              );
            },
            loading: () => LoadingCenter(),
            error: (error, _) => Container()));
  }
}
