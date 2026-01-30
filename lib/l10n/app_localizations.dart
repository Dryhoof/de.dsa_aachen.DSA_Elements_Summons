import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'DSA Elements Summons'**
  String get appTitle;

  /// No description provided for @createCharacter.
  ///
  /// In en, this message translates to:
  /// **'Create character'**
  String get createCharacter;

  /// No description provided for @editCharacter.
  ///
  /// In en, this message translates to:
  /// **'Edit character'**
  String get editCharacter;

  /// No description provided for @summonElemental.
  ///
  /// In en, this message translates to:
  /// **'Summon elemental'**
  String get summonElemental;

  /// No description provided for @characterCreation.
  ///
  /// In en, this message translates to:
  /// **'Character creation:'**
  String get characterCreation;

  /// No description provided for @characterName.
  ///
  /// In en, this message translates to:
  /// **'Character name:'**
  String get characterName;

  /// No description provided for @characterClass.
  ///
  /// In en, this message translates to:
  /// **'Character class:'**
  String get characterClass;

  /// No description provided for @chooseClass.
  ///
  /// In en, this message translates to:
  /// **'Choose the class:'**
  String get chooseClass;

  /// No description provided for @errorCharName.
  ///
  /// In en, this message translates to:
  /// **'You need to enter a character name!'**
  String get errorCharName;

  /// No description provided for @attributes.
  ///
  /// In en, this message translates to:
  /// **'Attributes:'**
  String get attributes;

  /// No description provided for @statCourage.
  ///
  /// In en, this message translates to:
  /// **'Courage:'**
  String get statCourage;

  /// No description provided for @statWisdom.
  ///
  /// In en, this message translates to:
  /// **'Wisdom:'**
  String get statWisdom;

  /// No description provided for @statCharisma.
  ///
  /// In en, this message translates to:
  /// **'Charisma:'**
  String get statCharisma;

  /// No description provided for @statIntuition.
  ///
  /// In en, this message translates to:
  /// **'Intuition:'**
  String get statIntuition;

  /// No description provided for @talents.
  ///
  /// In en, this message translates to:
  /// **'Talents'**
  String get talents;

  /// No description provided for @talentCallElementalServant.
  ///
  /// In en, this message translates to:
  /// **'Call elemental servant:'**
  String get talentCallElementalServant;

  /// No description provided for @talentCallDjinn.
  ///
  /// In en, this message translates to:
  /// **'Call djinn:'**
  String get talentCallDjinn;

  /// No description provided for @talentCallMasterOfElement.
  ///
  /// In en, this message translates to:
  /// **'Call master of element:'**
  String get talentCallMasterOfElement;

  /// No description provided for @elementFire.
  ///
  /// In en, this message translates to:
  /// **'Element fire'**
  String get elementFire;

  /// No description provided for @elementWater.
  ///
  /// In en, this message translates to:
  /// **'Element water'**
  String get elementWater;

  /// No description provided for @elementLife.
  ///
  /// In en, this message translates to:
  /// **'Element life'**
  String get elementLife;

  /// No description provided for @elementStone.
  ///
  /// In en, this message translates to:
  /// **'Element stone'**
  String get elementStone;

  /// No description provided for @elementIce.
  ///
  /// In en, this message translates to:
  /// **'Element ice'**
  String get elementIce;

  /// No description provided for @elementAir.
  ///
  /// In en, this message translates to:
  /// **'Element air'**
  String get elementAir;

  /// No description provided for @talentedFor.
  ///
  /// In en, this message translates to:
  /// **'Talented for'**
  String get talentedFor;

  /// No description provided for @talentedDemonic.
  ///
  /// In en, this message translates to:
  /// **'No. of demonic talents:'**
  String get talentedDemonic;

  /// No description provided for @knowledgeOfAttribute.
  ///
  /// In en, this message translates to:
  /// **'Knowledge of attribute'**
  String get knowledgeOfAttribute;

  /// No description provided for @knowledgeDemonic.
  ///
  /// In en, this message translates to:
  /// **'No. of demonic knowledges:'**
  String get knowledgeDemonic;

  /// No description provided for @specialCharacteristics.
  ///
  /// In en, this message translates to:
  /// **'Special characteristics'**
  String get specialCharacteristics;

  /// No description provided for @affinityToElementals.
  ///
  /// In en, this message translates to:
  /// **'Affinity to elementals'**
  String get affinityToElementals;

  /// No description provided for @demonicCovenant.
  ///
  /// In en, this message translates to:
  /// **'Demonic covenant'**
  String get demonicCovenant;

  /// No description provided for @cloakedAura.
  ///
  /// In en, this message translates to:
  /// **'Cloaked aura'**
  String get cloakedAura;

  /// No description provided for @powerlineMagicI.
  ///
  /// In en, this message translates to:
  /// **'Powerlinemagic I'**
  String get powerlineMagicI;

  /// No description provided for @weakPresence.
  ///
  /// In en, this message translates to:
  /// **'Weak presence'**
  String get weakPresence;

  /// No description provided for @strengthOfStigma.
  ///
  /// In en, this message translates to:
  /// **'Strength of stigma'**
  String get strengthOfStigma;

  /// No description provided for @saveCharacter.
  ///
  /// In en, this message translates to:
  /// **'Save character'**
  String get saveCharacter;

  /// No description provided for @deleteCharacter.
  ///
  /// In en, this message translates to:
  /// **'Delete character'**
  String get deleteCharacter;

  /// No description provided for @elementalServant.
  ///
  /// In en, this message translates to:
  /// **'Elemental servant'**
  String get elementalServant;

  /// No description provided for @djinn.
  ///
  /// In en, this message translates to:
  /// **'Djinn'**
  String get djinn;

  /// No description provided for @masterOfElement.
  ///
  /// In en, this message translates to:
  /// **'Master of element'**
  String get masterOfElement;

  /// No description provided for @selectSummoningType.
  ///
  /// In en, this message translates to:
  /// **'Select summoning type:'**
  String get selectSummoningType;

  /// No description provided for @equipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment:'**
  String get equipment;

  /// No description provided for @equipmentMage1.
  ///
  /// In en, this message translates to:
  /// **'White summoning robe (-1)'**
  String get equipmentMage1;

  /// No description provided for @equipmentMage2.
  ///
  /// In en, this message translates to:
  /// **'Barefoot (-1)'**
  String get equipmentMage2;

  /// No description provided for @equipmentDruid1.
  ///
  /// In en, this message translates to:
  /// **'Naked (-1)'**
  String get equipmentDruid1;

  /// No description provided for @equipmentDruid2.
  ///
  /// In en, this message translates to:
  /// **'Ritual cleansing (-1)'**
  String get equipmentDruid2;

  /// No description provided for @equipmentCristalomant1.
  ///
  /// In en, this message translates to:
  /// **'First potent cristal (-1)'**
  String get equipmentCristalomant1;

  /// No description provided for @equipmentCristalomant2.
  ///
  /// In en, this message translates to:
  /// **'Second potent cristal (-1)'**
  String get equipmentCristalomant2;

  /// No description provided for @equipmentShaman1.
  ///
  /// In en, this message translates to:
  /// **'First Equipment (-1)'**
  String get equipmentShaman1;

  /// No description provided for @equipmentShaman2.
  ///
  /// In en, this message translates to:
  /// **'Second Equipment (-1)'**
  String get equipmentShaman2;

  /// No description provided for @qualityOfMaterial.
  ///
  /// In en, this message translates to:
  /// **'Quality of material:'**
  String get qualityOfMaterial;

  /// No description provided for @qualityOfTrueName.
  ///
  /// In en, this message translates to:
  /// **'Quality of true name:'**
  String get qualityOfTrueName;

  /// No description provided for @circumstancesOfPlace.
  ///
  /// In en, this message translates to:
  /// **'Circumstances of place:'**
  String get circumstancesOfPlace;

  /// No description provided for @powernode.
  ///
  /// In en, this message translates to:
  /// **'Strength of Powernode (with Powerlinemagic I)'**
  String get powernode;

  /// No description provided for @circumstancesOfTime.
  ///
  /// In en, this message translates to:
  /// **'Circumstances of time'**
  String get circumstancesOfTime;

  /// No description provided for @qualityOfGift.
  ///
  /// In en, this message translates to:
  /// **'Quality of gift'**
  String get qualityOfGift;

  /// No description provided for @qualityOfDeed.
  ///
  /// In en, this message translates to:
  /// **'Quality of deed'**
  String get qualityOfDeed;

  /// No description provided for @astralSense.
  ///
  /// In en, this message translates to:
  /// **'Astral sense'**
  String get astralSense;

  /// No description provided for @longArm.
  ///
  /// In en, this message translates to:
  /// **'Long arm'**
  String get longArm;

  /// No description provided for @lifeSense.
  ///
  /// In en, this message translates to:
  /// **'Life sense'**
  String get lifeSense;

  /// No description provided for @regeneration.
  ///
  /// In en, this message translates to:
  /// **'Regeneration'**
  String get regeneration;

  /// No description provided for @additionalActions.
  ///
  /// In en, this message translates to:
  /// **'Additional actions'**
  String get additionalActions;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @romanOne.
  ///
  /// In en, this message translates to:
  /// **'I'**
  String get romanOne;

  /// No description provided for @romanTwo.
  ///
  /// In en, this message translates to:
  /// **'II'**
  String get romanTwo;

  /// No description provided for @resistanceAgainstMagicAttacks.
  ///
  /// In en, this message translates to:
  /// **'Resistance against magic attacks'**
  String get resistanceAgainstMagicAttacks;

  /// No description provided for @immunityAgainstMagicAttacks.
  ///
  /// In en, this message translates to:
  /// **'Immunity against magic attacks'**
  String get immunityAgainstMagicAttacks;

  /// No description provided for @resistanceAgainstTrait.
  ///
  /// In en, this message translates to:
  /// **'Resistance against trait'**
  String get resistanceAgainstTrait;

  /// No description provided for @immunityAgainstTrait.
  ///
  /// In en, this message translates to:
  /// **'Immunity against trait'**
  String get immunityAgainstTrait;

  /// No description provided for @damage.
  ///
  /// In en, this message translates to:
  /// **'Damage'**
  String get damage;

  /// No description provided for @resistanceAgainstElementalAttacks.
  ///
  /// In en, this message translates to:
  /// **'Resistance against elemental attacks'**
  String get resistanceAgainstElementalAttacks;

  /// No description provided for @immunityAgainstElementalAttacks.
  ///
  /// In en, this message translates to:
  /// **'Immunity against elemental attacks'**
  String get immunityAgainstElementalAttacks;

  /// No description provided for @fire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get fire;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @life.
  ///
  /// In en, this message translates to:
  /// **'Life'**
  String get life;

  /// No description provided for @ice.
  ///
  /// In en, this message translates to:
  /// **'Ice'**
  String get ice;

  /// No description provided for @stone.
  ///
  /// In en, this message translates to:
  /// **'Stone'**
  String get stone;

  /// No description provided for @air.
  ///
  /// In en, this message translates to:
  /// **'Air'**
  String get air;

  /// No description provided for @specialGmStuff.
  ///
  /// In en, this message translates to:
  /// **'Special GM stuff'**
  String get specialGmStuff;

  /// No description provided for @bloodMagicUsed.
  ///
  /// In en, this message translates to:
  /// **'Bloodmagic used'**
  String get bloodMagicUsed;

  /// No description provided for @summonedLesserDemon.
  ///
  /// In en, this message translates to:
  /// **'Summoned a lesser demon (last 7h)'**
  String get summonedLesserDemon;

  /// No description provided for @summonedHornedDemon.
  ///
  /// In en, this message translates to:
  /// **'Summoned a horned demon (last 24h)'**
  String get summonedHornedDemon;

  /// No description provided for @calculateSummoning.
  ///
  /// In en, this message translates to:
  /// **'Calculate summoning'**
  String get calculateSummoning;

  /// No description provided for @summoningModifier.
  ///
  /// In en, this message translates to:
  /// **'Summoning modifier:'**
  String get summoningModifier;

  /// No description provided for @controlTestModifier.
  ///
  /// In en, this message translates to:
  /// **'Control test modifier:'**
  String get controlTestModifier;

  /// No description provided for @additionalModifications.
  ///
  /// In en, this message translates to:
  /// **'Additional Modifications'**
  String get additionalModifications;

  /// No description provided for @additionalSummon.
  ///
  /// In en, this message translates to:
  /// **'Summon'**
  String get additionalSummon;

  /// No description provided for @additionalControl.
  ///
  /// In en, this message translates to:
  /// **'Control'**
  String get additionalControl;

  /// No description provided for @personality.
  ///
  /// In en, this message translates to:
  /// **'Personality:'**
  String get personality;

  /// No description provided for @element.
  ///
  /// In en, this message translates to:
  /// **'Element:'**
  String get element;

  /// No description provided for @weakAgainst.
  ///
  /// In en, this message translates to:
  /// **'Weak against:'**
  String get weakAgainst;

  /// No description provided for @summoning.
  ///
  /// In en, this message translates to:
  /// **'Summoning:'**
  String get summoning;

  /// No description provided for @noCharacters.
  ///
  /// In en, this message translates to:
  /// **'No characters yet. Create one first!'**
  String get noCharacters;

  /// No description provided for @characterDeleted.
  ///
  /// In en, this message translates to:
  /// **'Character deleted'**
  String get characterDeleted;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @classMage.
  ///
  /// In en, this message translates to:
  /// **'Mage'**
  String get classMage;

  /// No description provided for @classDruid.
  ///
  /// In en, this message translates to:
  /// **'Druid'**
  String get classDruid;

  /// No description provided for @classGeode.
  ///
  /// In en, this message translates to:
  /// **'Geode'**
  String get classGeode;

  /// No description provided for @classCristalomant.
  ///
  /// In en, this message translates to:
  /// **'Cristalomant'**
  String get classCristalomant;

  /// No description provided for @classShaman.
  ///
  /// In en, this message translates to:
  /// **'Shaman'**
  String get classShaman;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @summon.
  ///
  /// In en, this message translates to:
  /// **'Summon'**
  String get summon;

  /// No description provided for @newCharacter.
  ///
  /// In en, this message translates to:
  /// **'New character'**
  String get newCharacter;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Attributes'**
  String get stats;

  /// No description provided for @elementAndType.
  ///
  /// In en, this message translates to:
  /// **'Element & Type'**
  String get elementAndType;

  /// No description provided for @circumstances.
  ///
  /// In en, this message translates to:
  /// **'Circumstances'**
  String get circumstances;

  /// No description provided for @abilities.
  ///
  /// In en, this message translates to:
  /// **'Abilities'**
  String get abilities;

  /// No description provided for @resistances.
  ///
  /// In en, this message translates to:
  /// **'Resistances'**
  String get resistances;

  /// No description provided for @immunities.
  ///
  /// In en, this message translates to:
  /// **'Immunities'**
  String get immunities;

  /// No description provided for @gmModifiers.
  ///
  /// In en, this message translates to:
  /// **'GM Modifiers'**
  String get gmModifiers;

  /// No description provided for @materialPurity.
  ///
  /// In en, this message translates to:
  /// **'Quality of material'**
  String get materialPurity;

  /// No description provided for @trueName.
  ///
  /// In en, this message translates to:
  /// **'True name'**
  String get trueName;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get place;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @gift.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get gift;

  /// No description provided for @deed.
  ///
  /// In en, this message translates to:
  /// **'Deed'**
  String get deed;

  /// No description provided for @quality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get quality;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistance'**
  String get resistance;

  /// No description provided for @immunity.
  ///
  /// In en, this message translates to:
  /// **'Immunity'**
  String get immunity;

  /// No description provided for @resistanceMagic.
  ///
  /// In en, this message translates to:
  /// **'Resistance against magic attacks'**
  String get resistanceMagic;

  /// No description provided for @resistanceTraitDamage.
  ///
  /// In en, this message translates to:
  /// **'Resistance against trait damage'**
  String get resistanceTraitDamage;

  /// No description provided for @immunityMagic.
  ///
  /// In en, this message translates to:
  /// **'Immunity against magic attacks'**
  String get immunityMagic;

  /// No description provided for @immunityTraitDamage.
  ///
  /// In en, this message translates to:
  /// **'Immunity against trait damage'**
  String get immunityTraitDamage;

  /// No description provided for @summonLabel.
  ///
  /// In en, this message translates to:
  /// **'Summon'**
  String get summonLabel;

  /// No description provided for @controlLabel.
  ///
  /// In en, this message translates to:
  /// **'Control'**
  String get controlLabel;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @additionalSummonMod.
  ///
  /// In en, this message translates to:
  /// **'Additional summon modifier'**
  String get additionalSummonMod;

  /// No description provided for @additionalControlMod.
  ///
  /// In en, this message translates to:
  /// **'Additional control modifier'**
  String get additionalControlMod;

  /// No description provided for @equipmentGeode1.
  ///
  /// In en, this message translates to:
  /// **'Naked (-1)'**
  String get equipmentGeode1;

  /// No description provided for @equipmentGeode2.
  ///
  /// In en, this message translates to:
  /// **'Ritual cleansing (-1)'**
  String get equipmentGeode2;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
