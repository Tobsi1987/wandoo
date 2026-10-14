/// Stimmlage eines Wesens: Kleine und flinke Arten piepsen hoch, große
/// brummen tief.
enum Voice { high, mid, low }

const Map<String, Voice> _voices = {
  'funkel': Voice.high,
  'pustel': Voice.high,
  'schnirp': Voice.high,
  'brummli': Voice.high,
  'zapfi': Voice.high,
  'blitzmaus': Voice.high,
  'sternschnuppe': Voice.high,
  'moosel': Voice.mid,
  'pfuetzling': Voice.mid,
  'kieselchen': Voice.mid,
  'laternchen': Voice.mid,
  'pilzling': Voice.mid,
  'kristallis': Voice.mid,
  'fluffeule': Voice.mid,
  'glutling': Voice.mid,
  'wolkenwuff': Voice.low,
  'blaetterdrache': Voice.low,
  'nebelfuchs': Voice.low,
  'wellenwal': Voice.low,
  'aurora': Voice.low,
};

/// Die Stimme von [speciesId]; unbekannte Arten klingen mittel.
Voice voiceFor(String? speciesId) => _voices[speciesId] ?? Voice.mid;
