/// Parses modifier values from strings like "(+3)" or "(-2/+1)".
class ModifierParser {
  static final _singlePattern = RegExp(r'\(([-+]?\d+)\)');
  static final _dualPattern = RegExp(r'\(([-+]?\d+)/([-+]?\d+)\)');

  /// Parse "(+X)" -> X
  static int parseSingle(String s) {
    final match = _singlePattern.firstMatch(s);
    if (match == null) return 0;
    final raw = match.group(1)!;
    return int.tryParse(raw.startsWith('+') ? raw.substring(1) : raw) ?? 0;
  }

  /// Parse "(+X/+Y)" -> (X, Y)
  static (int, int) parseDual(String s) {
    final match = _dualPattern.firstMatch(s);
    if (match == null) return (0, 0);
    final raw1 = match.group(1)!;
    final raw2 = match.group(2)!;
    final v1 = int.tryParse(raw1.startsWith('+') ? raw1.substring(1) : raw1) ?? 0;
    final v2 = int.tryParse(raw2.startsWith('+') ? raw2.substring(1) : raw2) ?? 0;
    return (v1, v2);
  }
}
