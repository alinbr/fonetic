import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final lineRecorderProvider =
    StateNotifierProvider<LineRecorderController, RecordingState>((ref) {
  return LineRecorderController();
});

enum RecordingState { READY_TO_RECORD, RECORDING, RECORDED, PLAYING }

class LineRecorderController extends StateNotifier<RecordingState> {
  late FlutterSoundRecorder _recorder;
  late FlutterSoundPlayer _player;

  late int lineOrder;

  LineRecorderController() : super(RecordingState.READY_TO_RECORD) {
    _player = FlutterSoundPlayer();
    _recorder = FlutterSoundRecorder();
  }

  Future<void> init() async {
    await openTheRecorder();
    await _player.openAudioSession();
  }

  void setLineOrder(int order) {
    lineOrder = order;
  }

  int getLineOrder() {
    return lineOrder;
  }

  void startRecording() async {
    await init();
    Directory tempDir = await getTemporaryDirectory();
    File outputFile = File('${tempDir.path}/flutter_sound-tmp.aac');
    _recorder.startRecorder(toFile: outputFile.path);
    state = RecordingState.RECORDING;
  }

  void stopRecording() async {
    _recorder.stopRecorder();
    state = RecordingState.RECORDED;
  }

  void playRecorded() async {
    Directory tempDir = await getTemporaryDirectory();
    File outputFile = File('${tempDir.path}/flutter_sound-tmp.aac');
    _player.startPlayer(
        fromURI: outputFile.path,
        whenFinished: () {
          state = RecordingState.RECORDED;
        });
    state = RecordingState.PLAYING;
  }

  void stopPlayer() async {
    _player.stopPlayer();
    state = RecordingState.RECORDED;
  }

  void resetState() async {
    state = RecordingState.READY_TO_RECORD;
  }

  Future<void> openTheRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _recorder.openAudioSession();
  }

  Future<String> uploadFile(playId) async {
    Directory tempDir = await getTemporaryDirectory();
    File outputFile = File('${tempDir.path}/flutter_sound-tmp.aac');

    var snapshot = await FirebaseStorage.instance
        .ref()
        .child('$playId/$lineOrder')
        .putFile(outputFile, SettableMetadata(contentType: "audio/aac"));

    return await snapshot.ref.getDownloadURL();
  }

  @override
  void dispose() {
    _player.closeAudioSession();
    _recorder.closeAudioSession();
    super.dispose();
  }
}
