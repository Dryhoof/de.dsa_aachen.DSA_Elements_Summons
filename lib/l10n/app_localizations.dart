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

  /// No description provided for @properAttire.
  ///
  /// In en, this message translates to:
  /// **'Proper Attire (-2 summoning)'**
  String get properAttire;

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

  /// No description provided for @astralSenseCost.
  ///
  /// In en, this message translates to:
  /// **'5 ZfP*'**
  String get astralSenseCost;

  /// No description provided for @longArm.
  ///
  /// In en, this message translates to:
  /// **'Long arm'**
  String get longArm;

  /// No description provided for @longArmCost.
  ///
  /// In en, this message translates to:
  /// **'3 ZfP*'**
  String get longArmCost;

  /// No description provided for @lifeSense.
  ///
  /// In en, this message translates to:
  /// **'Life sense'**
  String get lifeSense;

  /// No description provided for @lifeSenseCost.
  ///
  /// In en, this message translates to:
  /// **'4 ZfP*'**
  String get lifeSenseCost;

  /// No description provided for @regeneration.
  ///
  /// In en, this message translates to:
  /// **'Regeneration'**
  String get regeneration;

  /// No description provided for @regenerationCostI.
  ///
  /// In en, this message translates to:
  /// **'4 ZfP*'**
  String get regenerationCostI;

  /// No description provided for @regenerationCostII.
  ///
  /// In en, this message translates to:
  /// **'7 ZfP*'**
  String get regenerationCostII;

  /// No description provided for @additionalActions.
  ///
  /// In en, this message translates to:
  /// **'Additional actions'**
  String get additionalActions;

  /// No description provided for @additionalActionsCostI.
  ///
  /// In en, this message translates to:
  /// **'3 ZfP*'**
  String get additionalActionsCostI;

  /// No description provided for @additionalActionsCostII.
  ///
  /// In en, this message translates to:
  /// **'7 ZfP*'**
  String get additionalActionsCostII;

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
  /// **'Summoning modifier'**
  String get summoningModifier;

  /// No description provided for @controlTestModifier.
  ///
  /// In en, this message translates to:
  /// **'Control test modifier'**
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
  /// **'Personality'**
  String get personality;

  /// No description provided for @element.
  ///
  /// In en, this message translates to:
  /// **'Element:'**
  String get element;

  /// No description provided for @weakAgainst.
  ///
  /// In en, this message translates to:
  /// **'Weak against'**
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

  /// No description provided for @unsavedChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get unsavedChangesTitle;

  /// No description provided for @unsavedChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. What would you like to do?'**
  String get unsavedChangesMessage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @elementalTemplates.
  ///
  /// In en, this message translates to:
  /// **'Elemental templates'**
  String get elementalTemplates;

  /// No description provided for @newTemplate.
  ///
  /// In en, this message translates to:
  /// **'New template'**
  String get newTemplate;

  /// No description provided for @editTemplate.
  ///
  /// In en, this message translates to:
  /// **'Edit template'**
  String get editTemplate;

  /// No description provided for @templateName.
  ///
  /// In en, this message translates to:
  /// **'Template name'**
  String get templateName;

  /// No description provided for @loadTemplate.
  ///
  /// In en, this message translates to:
  /// **'Load template'**
  String get loadTemplate;

  /// No description provided for @saveAsTemplate.
  ///
  /// In en, this message translates to:
  /// **'Save as template'**
  String get saveAsTemplate;

  /// No description provided for @noTemplates.
  ///
  /// In en, this message translates to:
  /// **'No templates yet. Create one first!'**
  String get noTemplates;

  /// No description provided for @deleteTemplate.
  ///
  /// In en, this message translates to:
  /// **'Delete template'**
  String get deleteTemplate;

  /// No description provided for @templateSaved.
  ///
  /// In en, this message translates to:
  /// **'Template saved'**
  String get templateSaved;

  /// No description provided for @templateLoaded.
  ///
  /// In en, this message translates to:
  /// **'Template loaded'**
  String get templateLoaded;

  /// No description provided for @templateDeleted.
  ///
  /// In en, this message translates to:
  /// **'Template deleted'**
  String get templateDeleted;

  /// No description provided for @elementals.
  ///
  /// In en, this message translates to:
  /// **'Elementals'**
  String get elementals;

  /// No description provided for @errorTemplateName.
  ///
  /// In en, this message translates to:
  /// **'You need to enter a template name!'**
  String get errorTemplateName;

  /// No description provided for @place0.
  ///
  /// In en, this message translates to:
  /// **'Elemental citadel (-7/-2)'**
  String get place0;

  /// No description provided for @place1.
  ///
  /// In en, this message translates to:
  /// **'Near elemental citadel (-5/-1)'**
  String get place1;

  /// No description provided for @place2.
  ///
  /// In en, this message translates to:
  /// **'Place of elemental purity (-3/-1)'**
  String get place2;

  /// No description provided for @place3.
  ///
  /// In en, this message translates to:
  /// **'Element strongly present (-2/0)'**
  String get place3;

  /// No description provided for @place4.
  ///
  /// In en, this message translates to:
  /// **'Element slightly present (-1/0)'**
  String get place4;

  /// No description provided for @place5.
  ///
  /// In en, this message translates to:
  /// **'No connection to element (0/0)'**
  String get place5;

  /// No description provided for @place6.
  ///
  /// In en, this message translates to:
  /// **'Neutral (0/0)'**
  String get place6;

  /// No description provided for @place7.
  ///
  /// In en, this message translates to:
  /// **'Counter element slightly present (+1/0)'**
  String get place7;

  /// No description provided for @place8.
  ///
  /// In en, this message translates to:
  /// **'Counter element strongly present (+2/0)'**
  String get place8;

  /// No description provided for @place9.
  ///
  /// In en, this message translates to:
  /// **'Place of counter element (+3/+1)'**
  String get place9;

  /// No description provided for @place10.
  ///
  /// In en, this message translates to:
  /// **'Elemental node of counter element (+5/+1)'**
  String get place10;

  /// No description provided for @place11.
  ///
  /// In en, this message translates to:
  /// **'Citadel of counter element (+7/+2)'**
  String get place11;

  /// No description provided for @place12.
  ///
  /// In en, this message translates to:
  /// **'Gate of horror (Blakharaz) (+5/+1)'**
  String get place12;

  /// No description provided for @place13.
  ///
  /// In en, this message translates to:
  /// **'Gate of horror (Agrimoth) (+7/+2)'**
  String get place13;

  /// No description provided for @time0.
  ///
  /// In en, this message translates to:
  /// **'1 on D20 (-3/-1)'**
  String get time0;

  /// No description provided for @time1.
  ///
  /// In en, this message translates to:
  /// **'2-5 on D20 (-2/-1)'**
  String get time1;

  /// No description provided for @time2.
  ///
  /// In en, this message translates to:
  /// **'6-9 on D20 (-1/0)'**
  String get time2;

  /// No description provided for @time3.
  ///
  /// In en, this message translates to:
  /// **'10-11 on D20 (0/0)'**
  String get time3;

  /// No description provided for @time4.
  ///
  /// In en, this message translates to:
  /// **'12-15 on D20 (+1/0)'**
  String get time4;

  /// No description provided for @time5.
  ///
  /// In en, this message translates to:
  /// **'16-19 on D20 (+2/+1)'**
  String get time5;

  /// No description provided for @time6.
  ///
  /// In en, this message translates to:
  /// **'20 on D20 / Nameless days (+3/+1)'**
  String get time6;

  /// No description provided for @gift0.
  ///
  /// In en, this message translates to:
  /// **'Outstanding gift (-7/-2)'**
  String get gift0;

  /// No description provided for @gift1.
  ///
  /// In en, this message translates to:
  /// **'Very valuable gift (-6/-2)'**
  String get gift1;

  /// No description provided for @gift2.
  ///
  /// In en, this message translates to:
  /// **'Valuable gift (-5/-1)'**
  String get gift2;

  /// No description provided for @gift3.
  ///
  /// In en, this message translates to:
  /// **'Good gift (-4/-1)'**
  String get gift3;

  /// No description provided for @gift4.
  ///
  /// In en, this message translates to:
  /// **'Appropriate gift (-3/-1)'**
  String get gift4;

  /// No description provided for @gift5.
  ///
  /// In en, this message translates to:
  /// **'Acceptable gift (-2/0)'**
  String get gift5;

  /// No description provided for @gift6.
  ///
  /// In en, this message translates to:
  /// **'Small gift (-1/0)'**
  String get gift6;

  /// No description provided for @gift7.
  ///
  /// In en, this message translates to:
  /// **'No gift (0/0)'**
  String get gift7;

  /// No description provided for @gift8.
  ///
  /// In en, this message translates to:
  /// **'Unsuitable gift (+1/0)'**
  String get gift8;

  /// No description provided for @gift9.
  ///
  /// In en, this message translates to:
  /// **'Insulting gift (+2/0)'**
  String get gift9;

  /// No description provided for @gift10.
  ///
  /// In en, this message translates to:
  /// **'Bad gift (+3/+1)'**
  String get gift10;

  /// No description provided for @gift11.
  ///
  /// In en, this message translates to:
  /// **'Very bad gift (+4/+1)'**
  String get gift11;

  /// No description provided for @gift12.
  ///
  /// In en, this message translates to:
  /// **'Offensive gift (+5/+1)'**
  String get gift12;

  /// No description provided for @gift13.
  ///
  /// In en, this message translates to:
  /// **'Reprehensible gift (+6/+2)'**
  String get gift13;

  /// No description provided for @gift14.
  ///
  /// In en, this message translates to:
  /// **'Abominable gift (+7/+2)'**
  String get gift14;

  /// No description provided for @deed0.
  ///
  /// In en, this message translates to:
  /// **'Outstanding deed (-7/-2)'**
  String get deed0;

  /// No description provided for @deed1.
  ///
  /// In en, this message translates to:
  /// **'Very good deed (-6/-2)'**
  String get deed1;

  /// No description provided for @deed2.
  ///
  /// In en, this message translates to:
  /// **'Good deed (-5/-1)'**
  String get deed2;

  /// No description provided for @deed3.
  ///
  /// In en, this message translates to:
  /// **'Helpful deed (-4/-1)'**
  String get deed3;

  /// No description provided for @deed4.
  ///
  /// In en, this message translates to:
  /// **'Appropriate deed (-3/-1)'**
  String get deed4;

  /// No description provided for @deed5.
  ///
  /// In en, this message translates to:
  /// **'Acceptable deed (-2/0)'**
  String get deed5;

  /// No description provided for @deed6.
  ///
  /// In en, this message translates to:
  /// **'Small deed (-1/0)'**
  String get deed6;

  /// No description provided for @deed7.
  ///
  /// In en, this message translates to:
  /// **'No deed (0/0)'**
  String get deed7;

  /// No description provided for @deed8.
  ///
  /// In en, this message translates to:
  /// **'Unsuitable deed (+1/0)'**
  String get deed8;

  /// No description provided for @deed9.
  ///
  /// In en, this message translates to:
  /// **'Insulting deed (+2/0)'**
  String get deed9;

  /// No description provided for @deed10.
  ///
  /// In en, this message translates to:
  /// **'Bad deed (+3/+1)'**
  String get deed10;

  /// No description provided for @deed11.
  ///
  /// In en, this message translates to:
  /// **'Very bad deed (+4/+1)'**
  String get deed11;

  /// No description provided for @deed12.
  ///
  /// In en, this message translates to:
  /// **'Offensive deed (+5/+1)'**
  String get deed12;

  /// No description provided for @deed13.
  ///
  /// In en, this message translates to:
  /// **'Reprehensible deed (+6/+2)'**
  String get deed13;

  /// No description provided for @deed14.
  ///
  /// In en, this message translates to:
  /// **'Abominable deed (+7/+2)'**
  String get deed14;

  /// No description provided for @overwriteTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Overwrite template?'**
  String get overwriteTemplateTitle;

  /// No description provided for @overwriteTemplateMessage.
  ///
  /// In en, this message translates to:
  /// **'A template with this name already exists. Do you want to overwrite it?'**
  String get overwriteTemplateMessage;

  /// No description provided for @overwrite.
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get overwrite;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteCharacterConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete this character?'**
  String get deleteCharacterConfirm;

  /// No description provided for @deleteTemplateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete this template?'**
  String get deleteTemplateConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @overwriteCharacterTitle.
  ///
  /// In en, this message translates to:
  /// **'Overwrite character?'**
  String get overwriteCharacterTitle;

  /// No description provided for @overwriteCharacterMessage.
  ///
  /// In en, this message translates to:
  /// **'A character with this name already exists. Do you want to overwrite it?'**
  String get overwriteCharacterMessage;

  /// No description provided for @specialProperties.
  ///
  /// In en, this message translates to:
  /// **'Special Properties'**
  String get specialProperties;

  /// No description provided for @elementSpecificProperties.
  ///
  /// In en, this message translates to:
  /// **'Element-Specific Properties'**
  String get elementSpecificProperties;

  /// No description provided for @valueModifications.
  ///
  /// In en, this message translates to:
  /// **'Value Modifications'**
  String get valueModifications;

  /// No description provided for @zfpCost.
  ///
  /// In en, this message translates to:
  /// **'ZfP* cost'**
  String get zfpCost;

  /// No description provided for @totalZfpCost.
  ///
  /// In en, this message translates to:
  /// **'Total ZfP* cost'**
  String get totalZfpCost;

  /// No description provided for @causeFear.
  ///
  /// In en, this message translates to:
  /// **'Cause Fear'**
  String get causeFear;

  /// No description provided for @causeFearCost.
  ///
  /// In en, this message translates to:
  /// **'5 ZfP*'**
  String get causeFearCost;

  /// No description provided for @artifactAnimation.
  ///
  /// In en, this message translates to:
  /// **'Artifact Animation'**
  String get artifactAnimation;

  /// No description provided for @artifactAnimationCost.
  ///
  /// In en, this message translates to:
  /// **'3 ZfP*/level'**
  String get artifactAnimationCost;

  /// No description provided for @aura.
  ///
  /// In en, this message translates to:
  /// **'Aura (Element)'**
  String get aura;

  /// No description provided for @auraCost.
  ///
  /// In en, this message translates to:
  /// **'5 ZfP*'**
  String get auraCost;

  /// No description provided for @blinkingInvisibility.
  ///
  /// In en, this message translates to:
  /// **'Blinking Invisibility'**
  String get blinkingInvisibility;

  /// No description provided for @blinkingInvisibilityCost.
  ///
  /// In en, this message translates to:
  /// **'6 ZfP*'**
  String get blinkingInvisibilityCost;

  /// No description provided for @elementalShackle.
  ///
  /// In en, this message translates to:
  /// **'Elemental Shackle'**
  String get elementalShackle;

  /// No description provided for @elementalShackleCost.
  ///
  /// In en, this message translates to:
  /// **'5 ZfP*'**
  String get elementalShackleCost;

  /// No description provided for @elementalGrip.
  ///
  /// In en, this message translates to:
  /// **'Elemental Grip'**
  String get elementalGrip;

  /// No description provided for @elementalGripCost.
  ///
  /// In en, this message translates to:
  /// **'7 ZfP*/level'**
  String get elementalGripCost;

  /// No description provided for @elementalInferno.
  ///
  /// In en, this message translates to:
  /// **'Elemental Inferno'**
  String get elementalInferno;

  /// No description provided for @elementalInfernoCost.
  ///
  /// In en, this message translates to:
  /// **'8 ZfP*'**
  String get elementalInfernoCost;

  /// No description provided for @elementalGrowth.
  ///
  /// In en, this message translates to:
  /// **'Elemental Growth'**
  String get elementalGrowth;

  /// No description provided for @elementalGrowthCost.
  ///
  /// In en, this message translates to:
  /// **'7 ZfP*'**
  String get elementalGrowthCost;

  /// No description provided for @drowning.
  ///
  /// In en, this message translates to:
  /// **'Drowning'**
  String get drowning;

  /// No description provided for @drowningCost.
  ///
  /// In en, this message translates to:
  /// **'4 ZfP*'**
  String get drowningCost;

  /// No description provided for @areaAttack.
  ///
  /// In en, this message translates to:
  /// **'Area Attack with Element'**
  String get areaAttack;

  /// No description provided for @areaAttackCost.
  ///
  /// In en, this message translates to:
  /// **'7 ZfP*'**
  String get areaAttackCost;

  /// No description provided for @flight.
  ///
  /// In en, this message translates to:
  /// **'Flight'**
  String get flight;

  /// No description provided for @flightCost.
  ///
  /// In en, this message translates to:
  /// **'5 ZfP*'**
  String get flightCost;

  /// No description provided for @frost.
  ///
  /// In en, this message translates to:
  /// **'Frost'**
  String get frost;

  /// No description provided for @frostCost.
  ///
  /// In en, this message translates to:
  /// **'3 ZfP*'**
  String get frostCost;

  /// No description provided for @ember.
  ///
  /// In en, this message translates to:
  /// **'Ember'**
  String get ember;

  /// No description provided for @emberCost.
  ///
  /// In en, this message translates to:
  /// **'3 ZfP*'**
  String get emberCost;

  /// No description provided for @criticalImmunity.
  ///
  /// In en, this message translates to:
  /// **'Immunity to Critical Hits'**
  String get criticalImmunity;

  /// No description provided for @criticalImmunityCost.
  ///
  /// In en, this message translates to:
  /// **'2 ZfP*'**
  String get criticalImmunityCost;

  /// No description provided for @boilingBlood.
  ///
  /// In en, this message translates to:
  /// **'Boiling Blood'**
  String get boilingBlood;

  /// No description provided for @boilingBloodCost.
  ///
  /// In en, this message translates to:
  /// **'5 ZfP*'**
  String get boilingBloodCost;

  /// No description provided for @fog.
  ///
  /// In en, this message translates to:
  /// **'Fog'**
  String get fog;

  /// No description provided for @fogCost.
  ///
  /// In en, this message translates to:
  /// **'2 ZfP*'**
  String get fogCost;

  /// No description provided for @smoke.
  ///
  /// In en, this message translates to:
  /// **'Smoke'**
  String get smoke;

  /// No description provided for @smokeCost.
  ///
  /// In en, this message translates to:
  /// **'4 ZfP*'**
  String get smokeCost;

  /// No description provided for @stasis.
  ///
  /// In en, this message translates to:
  /// **'Stasis'**
  String get stasis;

  /// No description provided for @stasisCost.
  ///
  /// In en, this message translates to:
  /// **'5 ZfP*'**
  String get stasisCost;

  /// No description provided for @stoneEating.
  ///
  /// In en, this message translates to:
  /// **'Stone Eating'**
  String get stoneEating;

  /// No description provided for @stoneEatingCost.
  ///
  /// In en, this message translates to:
  /// **'2 ZfP*/level'**
  String get stoneEatingCost;

  /// No description provided for @stoneSkin.
  ///
  /// In en, this message translates to:
  /// **'Stoneskin'**
  String get stoneSkin;

  /// No description provided for @stoneSkinCost.
  ///
  /// In en, this message translates to:
  /// **'2 ZfP*/level'**
  String get stoneSkinCost;

  /// No description provided for @mergeWithElement.
  ///
  /// In en, this message translates to:
  /// **'Merge with Element'**
  String get mergeWithElement;

  /// No description provided for @mergeWithElementCost.
  ///
  /// In en, this message translates to:
  /// **'7 ZfP*'**
  String get mergeWithElementCost;

  /// No description provided for @sinking.
  ///
  /// In en, this message translates to:
  /// **'Sinking'**
  String get sinking;

  /// No description provided for @sinkingCost.
  ///
  /// In en, this message translates to:
  /// **'6 ZfP*'**
  String get sinkingCost;

  /// No description provided for @wildGrowth.
  ///
  /// In en, this message translates to:
  /// **'Wild Growth'**
  String get wildGrowth;

  /// No description provided for @wildGrowthCost.
  ///
  /// In en, this message translates to:
  /// **'7 ZfP*'**
  String get wildGrowthCost;

  /// No description provided for @burst.
  ///
  /// In en, this message translates to:
  /// **'Burst'**
  String get burst;

  /// No description provided for @burstCost.
  ///
  /// In en, this message translates to:
  /// **'4 ZfP*'**
  String get burstCost;

  /// No description provided for @shatteringArmor.
  ///
  /// In en, this message translates to:
  /// **'Shattering Armor'**
  String get shatteringArmor;

  /// No description provided for @shatteringArmorCost.
  ///
  /// In en, this message translates to:
  /// **'3 ZfP*'**
  String get shatteringArmorCost;

  /// No description provided for @modLeP.
  ///
  /// In en, this message translates to:
  /// **'LeP +5'**
  String get modLeP;

  /// No description provided for @modLePCost.
  ///
  /// In en, this message translates to:
  /// **'2 ZfP*'**
  String get modLePCost;

  /// No description provided for @modINI.
  ///
  /// In en, this message translates to:
  /// **'INI +1'**
  String get modINI;

  /// No description provided for @modINICost.
  ///
  /// In en, this message translates to:
  /// **'3 ZfP*'**
  String get modINICost;

  /// No description provided for @modRS.
  ///
  /// In en, this message translates to:
  /// **'RS +1'**
  String get modRS;

  /// No description provided for @modRSCost.
  ///
  /// In en, this message translates to:
  /// **'3 ZfP*'**
  String get modRSCost;

  /// No description provided for @modGS.
  ///
  /// In en, this message translates to:
  /// **'GS +1'**
  String get modGS;

  /// No description provided for @modGSCost.
  ///
  /// In en, this message translates to:
  /// **'3 ZfP*'**
  String get modGSCost;

  /// No description provided for @modMR.
  ///
  /// In en, this message translates to:
  /// **'MR +1'**
  String get modMR;

  /// No description provided for @modMRCost.
  ///
  /// In en, this message translates to:
  /// **'3 ZfP*'**
  String get modMRCost;

  /// No description provided for @modAT.
  ///
  /// In en, this message translates to:
  /// **'AT +1'**
  String get modAT;

  /// No description provided for @modATCost.
  ///
  /// In en, this message translates to:
  /// **'4 ZfP*'**
  String get modATCost;

  /// No description provided for @modPA.
  ///
  /// In en, this message translates to:
  /// **'PA +1'**
  String get modPA;

  /// No description provided for @modPACost.
  ///
  /// In en, this message translates to:
  /// **'4 ZfP*'**
  String get modPACost;

  /// No description provided for @modTP.
  ///
  /// In en, this message translates to:
  /// **'TP +1'**
  String get modTP;

  /// No description provided for @modTPCost.
  ///
  /// In en, this message translates to:
  /// **'4 ZfP*'**
  String get modTPCost;

  /// No description provided for @modAttribute.
  ///
  /// In en, this message translates to:
  /// **'Attribute +1'**
  String get modAttribute;

  /// No description provided for @modAttributeCost.
  ///
  /// In en, this message translates to:
  /// **'5 ZfP*'**
  String get modAttributeCost;

  /// No description provided for @modNewTalent.
  ///
  /// In en, this message translates to:
  /// **'New Talent'**
  String get modNewTalent;

  /// No description provided for @modNewTalentCost.
  ///
  /// In en, this message translates to:
  /// **'4 ZfP*'**
  String get modNewTalentCost;

  /// No description provided for @modTaWZfW.
  ///
  /// In en, this message translates to:
  /// **'TaW/ZfW +2'**
  String get modTaWZfW;

  /// No description provided for @modTaWZfWCost.
  ///
  /// In en, this message translates to:
  /// **'1 ZfP*'**
  String get modTaWZfWCost;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @perApplication.
  ///
  /// In en, this message translates to:
  /// **'per application'**
  String get perApplication;

  /// No description provided for @predefinedSummonings.
  ///
  /// In en, this message translates to:
  /// **'Predefined summonings'**
  String get predefinedSummonings;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @unhide.
  ///
  /// In en, this message translates to:
  /// **'Unhide'**
  String get unhide;

  /// No description provided for @hiddenPredefined.
  ///
  /// In en, this message translates to:
  /// **'Hidden predefined summonings'**
  String get hiddenPredefined;

  /// No description provided for @noHiddenPredefined.
  ///
  /// In en, this message translates to:
  /// **'No hidden summonings'**
  String get noHiddenPredefined;

  /// No description provided for @managePredefined.
  ///
  /// In en, this message translates to:
  /// **'Manage hidden'**
  String get managePredefined;
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
