import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:just_audio/just_audio.dart';

final postProductionProvider = FutureProvider<void>((ref) async {
  final playId = ref.watch(currentPlayIdProvider).state;

  var snapshot =
      await FirebaseStorage.instance.ref().child('$playId').listAll();

  List<String> urlDownloadFiles = [];

  for (var item in snapshot.items) {
    String url = await item.getDownloadURL();
    urlDownloadFiles.add(url);
  }

  final player = AudioPlayer();

  player.setAudioSource(
    // Loop child 4 times
    LoopingAudioSource(
      count: 1,
      // Play children one after the other
      child: ConcatenatingAudioSource(
          children: urlDownloadFiles.map((e) {
        return ProgressiveAudioSource(Uri.parse(e));
      }).toList()),
    ),
  );

  player.play();

  print(snapshot.items.length);
});
