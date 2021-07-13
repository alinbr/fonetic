import 'package:flutter/material.dart';

var defaultCardDecoration = (BuildContext context) => BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      color: Theme.of(context).backgroundColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          spreadRadius: 2,
          blurRadius: 4,
        )
      ],
    );
