import 'package:flutter/material.dart';

class LoadingCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.tealAccent[700]!,
      ),
    );
  }
}
