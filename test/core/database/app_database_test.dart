import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dsa_elements_summons_flutter/core/database/app_database.dart';

AppDatabase _createInMemoryDb() {
  return AppDatabase(NativeDatabase.memory());
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = _createInMemoryDb();
  });

  tearDown(() async {
    await db.close();
  });

  group('Characters CRUD', () {
    test('insert and retrieve character', () async {
      final id = await db.insertCharacter(
        CharactersCompanion.insert(characterName: 'Gandolf'),
      );
      expect(id, greaterThan(0));

      final chars = await db.getAllCharacters();
      expect(chars.length, 1);
      expect(chars.first.characterName, 'Gandolf');
      expect(chars.first.characterClass, 0); // default
    });

    test('get character by id', () async {
      final id = await db.insertCharacter(
        CharactersCompanion.insert(characterName: 'Alrik'),
      );

      final c = await db.getCharacterById(id);
      expect(c.characterName, 'Alrik');
      expect(c.id, id);
    });

    test('update character', () async {
      final id = await db.insertCharacter(
        CharactersCompanion.insert(characterName: 'Old Name'),
      );

      var c = await db.getCharacterById(id);
      c = Character(
        id: c.id,
        characterName: 'New Name',
        characterClass: 2,
        statCourage: c.statCourage,
        statWisdom: c.statWisdom,
        statCharisma: c.statCharisma,
        statIntuition: c.statIntuition,
        talentCallElementalServant: c.talentCallElementalServant,
        talentCallDjinn: c.talentCallDjinn,
        talentCallMasterOfElement: c.talentCallMasterOfElement,
        talentedFire: c.talentedFire,
        talentedWater: c.talentedWater,
        talentedLife: c.talentedLife,
        talentedIce: c.talentedIce,
        talentedStone: c.talentedStone,
        talentedAir: c.talentedAir,
        talentedDemonic: c.talentedDemonic,
        knowledgeFire: c.knowledgeFire,
        knowledgeWater: c.knowledgeWater,
        knowledgeLife: c.knowledgeLife,
        knowledgeIce: c.knowledgeIce,
        knowledgeStone: c.knowledgeStone,
        knowledgeAir: c.knowledgeAir,
        knowledgeDemonic: c.knowledgeDemonic,
        affinityToElementals: c.affinityToElementals,
        demonicCovenant: c.demonicCovenant,
        cloakedAura: c.cloakedAura,
        weakPresence: c.weakPresence,
        strengthOfStigma: c.strengthOfStigma,
        powerlineMagicI: c.powerlineMagicI,
      );

      final updated = await db.updateCharacter(c);
      expect(updated, true);

      final fetched = await db.getCharacterById(id);
      expect(fetched.characterName, 'New Name');
      expect(fetched.characterClass, 2);
    });

    test('delete character', () async {
      final id = await db.insertCharacter(
        CharactersCompanion.insert(characterName: 'ToDelete'),
      );

      final deleted = await db.deleteCharacter(id);
      expect(deleted, 1);

      final chars = await db.getAllCharacters();
      expect(chars, isEmpty);
    });

    test('insert character with all fields', () async {
      final id = await db.insertCharacter(
        CharactersCompanion.insert(
          characterName: 'FullChar',
          characterClass: Value(1),
          statCourage: Value(14),
          statWisdom: Value(13),
          statCharisma: Value(12),
          statIntuition: Value(11),
          talentCallElementalServant: Value(7),
          talentCallDjinn: Value(5),
          talentCallMasterOfElement: Value(3),
          talentedFire: Value(true),
          knowledgeWater: Value(true),
          affinityToElementals: Value(true),
          powerlineMagicI: Value(true),
        ),
      );

      final c = await db.getCharacterById(id);
      expect(c.characterClass, 1);
      expect(c.statCourage, 14);
      expect(c.talentedFire, true);
      expect(c.knowledgeWater, true);
      expect(c.affinityToElementals, true);
      expect(c.powerlineMagicI, true);
      // Defaults
      expect(c.talentedWater, false);
      expect(c.demonicCovenant, false);
    });

    test('watchAllCharacters emits updates', () async {
      final stream = db.watchAllCharacters();

      // Initial should be empty
      expect(await stream.first, isEmpty);

      await db.insertCharacter(
        CharactersCompanion.insert(characterName: 'Watched'),
      );

      final chars = await stream.first;
      expect(chars.length, 1);
      expect(chars.first.characterName, 'Watched');
    });
  });

  group('ElementalTemplates CRUD', () {
    late int charId;

    setUp(() async {
      charId = await db.insertCharacter(
        CharactersCompanion.insert(characterName: 'TemplateOwner'),
      );
    });

    test('insert and retrieve template', () async {
      final id = await db.insertTemplate(
        ElementalTemplatesCompanion.insert(
          characterId: charId,
          templateName: 'Fire Servant',
          element: Value(0), // fire
          summoningType: Value(0), // servant
        ),
      );
      expect(id, greaterThan(0));

      final templates = await db.getTemplatesForCharacter(charId);
      expect(templates.length, 1);
      expect(templates.first.templateName, 'Fire Servant');
      expect(templates.first.element, 0);
      expect(templates.first.characterId, charId);
    });

    test('get template by id', () async {
      final id = await db.insertTemplate(
        ElementalTemplatesCompanion.insert(
          characterId: charId,
          templateName: 'Ice Djinn',
          element: Value(3), // ice
          summoningType: Value(1), // djinn
        ),
      );

      final t = await db.getTemplateById(id);
      expect(t.templateName, 'Ice Djinn');
      expect(t.element, 3);
      expect(t.summoningType, 1);
    });

    test('update template', () async {
      final id = await db.insertTemplate(
        ElementalTemplatesCompanion.insert(
          characterId: charId,
          templateName: 'Old Template',
        ),
      );

      final t = await db.getTemplateById(id);
      await db.updateTemplate(ElementalTemplate(
        id: t.id,
        characterId: t.characterId,
        templateName: 'Updated Template',
        element: 2, // life
        summoningType: 2, // master
        astralSense: true,
        longArm: false,
        lifeSense: false,
        regenerationLevel: 1,
        additionalActionsLevel: 0,
        resistanceMagic: true,
        resistanceTraitDamage: false,
        immunityMagic: false,
        immunityTraitDamage: false,
        resistancesDemonicJson: '{}',
        resistancesElementalJson: '{}',
        immunitiesDemonicJson: '{}',
        immunitiesElementalJson: '{}',
        // New general properties
        causeFear: true,
        artifactAnimationLevel: 0,
        aura: false,
        blinkingInvisibility: false,
        elementalShackle: false,
        elementalGripLevel: 2,
        elementalInferno: false,
        elementalGrowth: false,
        drowning: false,
        areaAttack: false,
        flight: false,
        frost: false,
        ember: false,
        criticalImmunity: false,
        boilingBlood: false,
        fog: false,
        smoke: false,
        stasis: false,
        stoneEatingLevel: 0,
        stoneSkinLevel: 0,
        mergeWithElement: false,
        sinking: false,
        wildGrowth: true,
        burst: false,
        shatteringArmor: false,
        // Value modifications
        modLeP: 3,
        modINI: 0,
        modRS: 0,
        modGS: 0,
        modMR: 0,
        modAT: 0,
        modPA: 0,
        modTP: 0,
        modAttribute: 0,
        modNewTalent: 0,
        modTaWZfW: 0,
      ));

      final updated = await db.getTemplateById(id);
      expect(updated.templateName, 'Updated Template');
      expect(updated.element, 2);
      expect(updated.summoningType, 2);
      expect(updated.astralSense, true);
      expect(updated.resistanceMagic, true);
      expect(updated.regenerationLevel, 1);
      // Check new properties
      expect(updated.causeFear, true);
      expect(updated.elementalGripLevel, 2);
      expect(updated.wildGrowth, true);
      expect(updated.modLeP, 3);
    });

    test('delete template', () async {
      final id = await db.insertTemplate(
        ElementalTemplatesCompanion.insert(
          characterId: charId,
          templateName: 'ToDelete',
        ),
      );

      final deleted = await db.deleteTemplate(id);
      expect(deleted, 1);

      final templates = await db.getTemplatesForCharacter(charId);
      expect(templates, isEmpty);
    });

    test('templates are scoped to character', () async {
      final charId2 = await db.insertCharacter(
        CharactersCompanion.insert(characterName: 'Other'),
      );

      await db.insertTemplate(
        ElementalTemplatesCompanion.insert(
          characterId: charId,
          templateName: 'Char1 Template',
        ),
      );
      await db.insertTemplate(
        ElementalTemplatesCompanion.insert(
          characterId: charId2,
          templateName: 'Char2 Template',
        ),
      );

      final t1 = await db.getTemplatesForCharacter(charId);
      final t2 = await db.getTemplatesForCharacter(charId2);

      expect(t1.length, 1);
      expect(t1.first.templateName, 'Char1 Template');
      expect(t2.length, 1);
      expect(t2.first.templateName, 'Char2 Template');
    });

    test('template defaults are correct', () async {
      await db.insertTemplate(
        ElementalTemplatesCompanion.insert(
          characterId: charId,
          templateName: 'Defaults',
        ),
      );

      final templates = await db.getTemplatesForCharacter(charId);
      final t = templates.first;
      expect(t.element, 0);
      expect(t.summoningType, 0);
      expect(t.astralSense, false);
      expect(t.longArm, false);
      expect(t.lifeSense, false);
      expect(t.regenerationLevel, 0);
      expect(t.additionalActionsLevel, 0);
      expect(t.resistanceMagic, false);
      expect(t.resistanceTraitDamage, false);
      expect(t.immunityMagic, false);
      expect(t.immunityTraitDamage, false);
      expect(t.resistancesDemonicJson, '{}');
      expect(t.resistancesElementalJson, '{}');
      expect(t.immunitiesDemonicJson, '{}');
      expect(t.immunitiesElementalJson, '{}');
      // New general properties defaults
      expect(t.causeFear, false);
      expect(t.artifactAnimationLevel, 0);
      expect(t.aura, false);
      expect(t.blinkingInvisibility, false);
      expect(t.elementalShackle, false);
      expect(t.elementalGripLevel, 0);
      expect(t.elementalInferno, false);
      expect(t.elementalGrowth, false);
      expect(t.drowning, false);
      expect(t.areaAttack, false);
      expect(t.flight, false);
      expect(t.frost, false);
      expect(t.ember, false);
      expect(t.criticalImmunity, false);
      expect(t.boilingBlood, false);
      expect(t.fog, false);
      expect(t.smoke, false);
      expect(t.stasis, false);
      expect(t.stoneEatingLevel, 0);
      expect(t.stoneSkinLevel, 0);
      expect(t.mergeWithElement, false);
      expect(t.sinking, false);
      expect(t.wildGrowth, false);
      expect(t.burst, false);
      expect(t.shatteringArmor, false);
      // Value modifications defaults
      expect(t.modLeP, 0);
      expect(t.modINI, 0);
      expect(t.modRS, 0);
      expect(t.modGS, 0);
      expect(t.modMR, 0);
      expect(t.modAT, 0);
      expect(t.modPA, 0);
      expect(t.modTP, 0);
      expect(t.modAttribute, 0);
      expect(t.modNewTalent, 0);
      expect(t.modTaWZfW, 0);
    });

    test('watchTemplatesForCharacter emits updates', () async {
      final stream = db.watchTemplatesForCharacter(charId);

      expect(await stream.first, isEmpty);

      await db.insertTemplate(
        ElementalTemplatesCompanion.insert(
          characterId: charId,
          templateName: 'Watched',
        ),
      );

      final templates = await stream.first;
      expect(templates.length, 1);
      expect(templates.first.templateName, 'Watched');
    });

    test('template stores JSON fields correctly', () async {
      const demonicJson = '{"Blakharaz":true,"Agrimoth":false}';
      const elementalJson = '{"0":true,"3":false}';

      await db.insertTemplate(
        ElementalTemplatesCompanion.insert(
          characterId: charId,
          templateName: 'JsonTest',
          resistancesDemonicJson: Value(demonicJson),
          resistancesElementalJson: Value(elementalJson),
        ),
      );

      final t = (await db.getTemplatesForCharacter(charId)).first;
      expect(t.resistancesDemonicJson, demonicJson);
      expect(t.resistancesElementalJson, elementalJson);
    });

    test('template stores new properties correctly', () async {
      await db.insertTemplate(
        ElementalTemplatesCompanion.insert(
          characterId: charId,
          templateName: 'PropertiesTest',
          causeFear: Value(true),
          elementalGripLevel: Value(3),
          flight: Value(true),
          stoneSkinLevel: Value(2),
          modLeP: Value(5),
          modAT: Value(2),
          modTaWZfW: Value(4),
        ),
      );

      final t = (await db.getTemplatesForCharacter(charId)).first;
      expect(t.causeFear, true);
      expect(t.elementalGripLevel, 3);
      expect(t.flight, true);
      expect(t.stoneSkinLevel, 2);
      expect(t.modLeP, 5);
      expect(t.modAT, 2);
      expect(t.modTaWZfW, 4);
      // Others should be default
      expect(t.aura, false);
      expect(t.modINI, 0);
    });
  });
}
