import 'package:dsa_elements_summons_flutter/l10n/app_localizations.dart';
import 'package:dsa_elements_summons_flutter/core/models/element.dart';
import 'package:dsa_elements_summons_flutter/core/models/character_class.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_type.dart';

extension DsaElementL10n on DsaElement {
  String localized(AppLocalizations l10n) => switch (this) {
        DsaElement.fire => l10n.fire,
        DsaElement.water => l10n.water,
        DsaElement.life => l10n.life,
        DsaElement.ice => l10n.ice,
        DsaElement.stone => l10n.stone,
        DsaElement.air => l10n.air,
      };
}

extension CharacterClassL10n on CharacterClass {
  String localized(AppLocalizations l10n) => switch (this) {
        CharacterClass.mage => l10n.classMage,
        CharacterClass.druid => l10n.classDruid,
        CharacterClass.geode => l10n.classGeode,
        CharacterClass.cristalomant => l10n.classCristalomant,
        CharacterClass.shaman => l10n.classShaman,
      };
}

extension SummoningTypeL10n on SummoningType {
  String localized(AppLocalizations l10n) => switch (this) {
        SummoningType.servant => l10n.elementalServant,
        SummoningType.djinn => l10n.djinn,
        SummoningType.master => l10n.masterOfElement,
      };
}

String placeLabel(int index, AppLocalizations l10n) => switch (index) {
      0 => l10n.place0,
      1 => l10n.place1,
      2 => l10n.place2,
      3 => l10n.place3,
      4 => l10n.place4,
      5 => l10n.place5,
      6 => l10n.place6,
      7 => l10n.place7,
      8 => l10n.place8,
      9 => l10n.place9,
      10 => l10n.place10,
      11 => l10n.place11,
      12 => l10n.place12,
      13 => l10n.place13,
      _ => '${l10n.place} ${index + 1}',
    };

String timeLabel(int index, AppLocalizations l10n) => switch (index) {
      0 => l10n.time0,
      1 => l10n.time1,
      2 => l10n.time2,
      3 => l10n.time3,
      4 => l10n.time4,
      5 => l10n.time5,
      6 => l10n.time6,
      _ => '${l10n.time} ${index + 1}',
    };

String giftLabel(int index, AppLocalizations l10n) => switch (index) {
      0 => l10n.gift0,
      1 => l10n.gift1,
      2 => l10n.gift2,
      3 => l10n.gift3,
      4 => l10n.gift4,
      5 => l10n.gift5,
      6 => l10n.gift6,
      7 => l10n.gift7,
      8 => l10n.gift8,
      9 => l10n.gift9,
      10 => l10n.gift10,
      11 => l10n.gift11,
      12 => l10n.gift12,
      13 => l10n.gift13,
      14 => l10n.gift14,
      _ => '${l10n.gift} ${index + 1}',
    };

String deedLabel(int index, AppLocalizations l10n) => switch (index) {
      0 => l10n.deed0,
      1 => l10n.deed1,
      2 => l10n.deed2,
      3 => l10n.deed3,
      4 => l10n.deed4,
      5 => l10n.deed5,
      6 => l10n.deed6,
      7 => l10n.deed7,
      8 => l10n.deed8,
      9 => l10n.deed9,
      10 => l10n.deed10,
      11 => l10n.deed11,
      12 => l10n.deed12,
      13 => l10n.deed13,
      14 => l10n.deed14,
      _ => '${l10n.deed} ${index + 1}',
    };
