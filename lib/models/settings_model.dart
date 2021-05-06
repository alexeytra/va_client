class Settings {
  bool voice;
  bool generateAnswer;

  Settings(this.voice, this.generateAnswer);

  @override
  String toString() {
    return 'Settings{voice: $voice, generateAnswer: $generateAnswer}';
  }
}