import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../../../data/models/ambience.dart';
import '../../../data/models/session_state_model.dart';
import '../../../data/repositories/session_repository.dart';

class PlayerState {
  final Ambience? activeAmbience;
  final Duration elapsed;
  final bool isPlaying;
  final bool sessionEnded;
  final bool isLoading;

  const PlayerState({
    this.activeAmbience,
    this.elapsed = Duration.zero,
    this.isPlaying = false,
    this.sessionEnded = false,
    this.isLoading = false,
  });

  Duration get total => activeAmbience != null
      ? Duration(seconds: activeAmbience!.durationSeconds)
      : Duration.zero;

  double get progress {
    if (total.inMilliseconds == 0) return 0;
    return (elapsed.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
  }

  PlayerState copyWith({
    Ambience? activeAmbience,
    Duration? elapsed,
    bool? isPlaying,
    bool? sessionEnded,
    bool? isLoading,
    bool clearAmbience = false,
  }) {
    return PlayerState(
      activeAmbience: clearAmbience ? null : (activeAmbience ?? this.activeAmbience),
      elapsed: elapsed ?? this.elapsed,
      isPlaying: isPlaying ?? this.isPlaying,
      sessionEnded: sessionEnded ?? this.sessionEnded,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PlayerNotifier extends StateNotifier<PlayerState> {
  final SessionRepository _sessionRepository;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer;

  PlayerNotifier(this._sessionRepository) : super(const PlayerState()) {
    _initAudioSession();
    _restoreSession();
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
    ));
  }

  Future<void> _restoreSession() async {
    final saved = _sessionRepository.getLastSession();
    if (saved != null) {
      // Just restore the mini-player state without audio
      // Will need to call startSession to actually play audio
    }
  }

  Future<void> startSession(Ambience ambience) async {
    // Stop any existing session
    await _stopAudio();
    _timer?.cancel();

    state = state.copyWith(
      activeAmbience: ambience,
      elapsed: Duration.zero,
      isPlaying: true,
      sessionEnded: false,
      isLoading: true,
    );

    try {
      await _audioPlayer.setAsset('assets/audio/loop.mp3');
      await _audioPlayer.setLoopMode(LoopMode.one);
      await _audioPlayer.play();

      state = state.copyWith(isLoading: false, isPlaying: true);
      _startTimer();
      _saveSession();
    } catch (e) {
      state = state.copyWith(isLoading: false, isPlaying: false);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isPlaying) return;

      final newElapsed = state.elapsed + const Duration(seconds: 1);
      if (newElapsed >= state.total) {
        state = state.copyWith(
          elapsed: state.total,
          isPlaying: false,
          sessionEnded: true,
        );
        _stopAudio();
        _timer?.cancel();
        _sessionRepository.clearSession();
      } else {
        state = state.copyWith(elapsed: newElapsed);
        _saveSession();
      }
    });
  }

  Future<void> play() async {
    await _audioPlayer.play();
    state = state.copyWith(isPlaying: true);
    _startTimer();
    _saveSession();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _timer?.cancel();
    state = state.copyWith(isPlaying: false);
    _saveSession();
  }

  Future<void> seek(Duration position) async {
    state = state.copyWith(elapsed: position);
    _saveSession();
  }

  Future<void> endSession() async {
    _timer?.cancel();
    await _stopAudio();
    state = state.copyWith(sessionEnded: true, isPlaying: false);
    await _sessionRepository.clearSession();
  }

  void clearSession() {
    _timer?.cancel();
    _stopAudio();
    state = const PlayerState();
    _sessionRepository.clearSession();
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
  }

  void _saveSession() {
    final ambience = state.activeAmbience;
    if (ambience == null) return;
    _sessionRepository.saveSession(SessionStateModel(
      ambienceId: ambience.id,
      ambienceTitle: ambience.title,
      elapsedSeconds: state.elapsed.inSeconds,
      isPlaying: state.isPlaying,
      totalDurationSeconds: ambience.durationSeconds,
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}

final playerProvider = StateNotifierProvider<PlayerNotifier, PlayerState>((ref) {
  final repo = SessionRepository();
  return PlayerNotifier(repo);
});
