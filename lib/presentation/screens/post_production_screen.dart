import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/post_production/post_production_controller.dart';

class PostProductionScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    watch(postProductionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post production'),
      ),
      body: Text("Your play is ready for post production"),
    );
  }
}
