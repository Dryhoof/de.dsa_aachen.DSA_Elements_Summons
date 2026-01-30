import 'package:dsa_elements_summons_flutter/core/models/element.dart';

/// Material purity modifiers per element.
/// Each list has 7 entries mapping to spinner index, value is single summon modifier.
const Map<DsaElement, List<int>> materialPurityModifiers = {
  DsaElement.fire: [-3, -2, -1, 0, 1, 2, 3],
  DsaElement.water: [-3, -2, -1, 0, 1, 2, 3],
  DsaElement.life: [-3, -2, -1, 0, 1, 2, 3],
  DsaElement.ice: [-3, -2, -1, 0, 1, 2, 3],
  DsaElement.stone: [-3, -2, -1, 0, 1, 2, 3],
  DsaElement.air: [-3, -2, -1, 0, 1, 2, 3],
};

/// Quality of true name: (summon, control)
const List<(int, int)> trueNameModifiers = [
  (0, 0),     // no true name
  (-1, 0),    // Quality 1
  (-2, -1),   // Quality 2
  (-3, -1),   // Quality 3
  (-4, -1),   // Quality 4
  (-5, -2),   // Quality 5
  (-6, -2),   // Quality 6
  (-7, -2),   // Quality 7
];

/// Circumstances of place: (summon, control)
const List<(int, int)> placeModifiers = [
  (-7, -2),  // elemental citadel of used element
  (-5, -1),  // elemental node of used element
  (-3, -1),  // place typical for used element
  (-2, 0),   // element strongly represented
  (-1, 0),   // element slightly represented
  (0, 0),    // no connection to any element
  (0, 0),    // neutral (default)
  (1, 0),    // counter element slightly represented
  (2, 0),    // counter element strongly represented
  (3, 1),    // place typical for counter element
  (5, 1),    // elemental node of counter element
  (7, 2),    // elemental citadel of counter element
  (5, 1),    // gate of horror (Blakharaz)
  (7, 2),    // gate of horror (Agrimoth)
];

/// Powernode strength: single summon modifier
const List<int> powernodeModifiers = [
  0,   // PS 0-1
  -1,  // PS 2-5
  -2,  // PS 6-9
  -3,  // PS 10-13
  -4,  // PS 14-17
  -5,  // PS 18-21
  -6,  // PS 22-25
  -7,  // PS 26-29
  -8,  // PS 30-33
  -9,  // PS 34-37
];

/// Circumstances of time: (summon, control)
const List<(int, int)> timeModifiers = [
  (-3, -1),  // 1 on D20
  (-2, -1),  // 2-5 on D20
  (-1, 0),   // 6-9 on D20
  (0, 0),    // 10-11 on D20
  (1, 0),    // 12-15 on D20
  (2, 1),    // 16-19 on D20
  (3, 1),    // 20 on D20 (or nameless days)
];

/// Quality of gift: (summon, control)
const List<(int, int)> giftModifiers = [
  (-7, -2),
  (-6, -2),
  (-5, -1),
  (-4, -1),
  (-3, -1),
  (-2, 0),
  (-1, 0),
  (0, 0),   // neutral (default index 7)
  (1, 0),
  (2, 0),
  (3, 1),
  (4, 1),
  (5, 1),
  (6, 2),
  (7, 2),
];

/// Quality of deed: (summon, control)
const List<(int, int)> deedModifiers = [
  (-7, -2),
  (-6, -2),
  (-5, -1),
  (-4, -1),
  (-3, -1),
  (-2, 0),
  (-1, 0),
  (0, 0),   // neutral (default index 7)
  (1, 0),
  (2, 0),
  (3, 1),
  (4, 1),
  (5, 1),
  (6, 2),
  (7, 2),
];

/// Personality traits per element
const Map<DsaElement, List<String>> personalitiesEn = {
  DsaElement.fire: [
    'tempered', 'unsettled', 'vindictive', 'raving mad', 'irascible',
    'aggressive', 'short-lived', 'zealously', 'brave', 'disobeys',
    'truthful', 'demanding', 'freedom-loving', 'mocking',
  ],
  DsaElement.water: [
    'unsettled', 'profound', 'unfathomable', 'inspiring', 'changeable',
    'strong-willed', 'flattering', 'adaptable', 'ruthless', 'thoughtless',
    'wroth', 'melancholic', 'forgetful', 'insane',
  ],
  DsaElement.life: [
    'life-giving', 'changeable', 'friendly', 'youthful', 'cozy',
    'lively', 'creative', 'patient', 'optimistic', 'merciful', 'cheerful',
  ],
  DsaElement.ice: [
    'rationally', 'emotionally cold', 'egoistic', 'calculating',
    'perfectionistic', 'orderly', 'detached', 'ruthless',
    'despising life', 'precise', 'timeless',
  ],
  DsaElement.stone: [
    'strong-willed', 'tradition-conscious', 'patient', 'dutiful',
    'truthful', 'stubborn', 'calm', 'unyielding', 'immovable',
    'not moldable', 'sluggish', 'reliable', 'prolific',
  ],
  DsaElement.air: [
    'cheerful', 'fleeting', 'impermanent', 'restless', 'nimble',
    'illusionistic', 'playful', 'hypocritical', 'deceptive',
    'confusing', 'fickle', 'flattering',
  ],
};

const Map<DsaElement, List<String>> personalitiesDe = {
  DsaElement.fire: [
    'aufbrausend', 'unruhig', 'rachsüchtig', 'rasend', 'jähzornig',
    'aggressiv', 'kurzlebig', 'eifrig', 'mutig', 'ungehorsam',
    'wahrheitsliebend', 'fordernd', 'freiheitsliebend', 'spöttisch',
  ],
  DsaElement.water: [
    'unruhig', 'tiefgründig', 'unergründlich', 'inspirierend', 'wandelbar',
    'willensstark', 'schmeichelnd', 'anpassungsfähig', 'rücksichtslos',
    'gedankenlos', 'zornig', 'melancholisch', 'vergesslich', 'wahnsinnig',
  ],
  DsaElement.life: [
    'lebensspendend', 'wandelbar', 'freundlich', 'jugendlich', 'gemütlich',
    'lebhaft', 'kreativ', 'geduldig', 'optimistisch', 'barmherzig', 'fröhlich',
  ],
  DsaElement.ice: [
    'rational', 'emotional kalt', 'egoistisch', 'berechnend',
    'perfektionistisch', 'ordentlich', 'distanziert', 'rücksichtslos',
    'lebensverachtend', 'präzise', 'zeitlos',
  ],
  DsaElement.stone: [
    'willensstark', 'traditionsbewusst', 'geduldig', 'pflichtbewusst',
    'wahrheitsliebend', 'stur', 'ruhig', 'unnachgiebig', 'unbeweglich',
    'nicht formbar', 'träge', 'zuverlässig', 'fruchtbar',
  ],
  DsaElement.air: [
    'fröhlich', 'flüchtig', 'vergänglich', 'rastlos', 'flink',
    'illusionistisch', 'verspielt', 'heuchlerisch', 'trügerisch',
    'verwirrend', 'wankelmütig', 'schmeichelnd',
  ],
};

/// Demon names for resistance/immunity
const List<String> demonNames = [
  'Blakharaz',
  'Belhalhar',
  'Lolgramoth',
  'Amazeroth',
  'Asfaloth',
  'Belzhorash',
  'Agrimoth',
  'Thargunitoth',
];
