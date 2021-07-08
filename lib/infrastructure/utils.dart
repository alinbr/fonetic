import 'package:flutter/material.dart';
import 'package:fonetic/infrastructure/dtos/play.dart';

String fromStatusToText(PlayStatus status) {
  switch (status) {
    case PlayStatus.IN_PROGRESS:
      return "in progress";
    case PlayStatus.POST_PRODUCTION:
      return "in post production";
    case PlayStatus.FINISHED:
      return "published";
  }
}

Color fromStatusToColor(PlayStatus status) {
  switch (status) {
    case PlayStatus.IN_PROGRESS:
      return Colors.green;
    case PlayStatus.POST_PRODUCTION:
      return Colors.blue;
    case PlayStatus.FINISHED:
      return Colors.cyan;
  }
}
