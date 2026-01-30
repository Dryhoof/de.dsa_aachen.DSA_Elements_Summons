package de.dsa_aachen.dsa_elements_summons;

//import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.app.Activity;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.os.Bundle;
//import android.widget.Button;
//import android.widget.CheckBox;
//import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.ScrollView;
import android.widget.TextView;
import de.dsa_aachen.dsa_elements_summons.SummonElementalActivity;
import de.dsa_aachen.dsa_elements_summons.SummonElementalActivity.SpinnerElement;

public class SummoningResultActivity extends Activity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.summoning_result_activity);
		SharedPreferences settings = this.getSharedPreferences("de.dsa_aachen.dsa_elements_summons", MODE_PRIVATE);
		String responseText = "";

		int elementId = settings.getInt("spinnerTypeOfElement",0);
		SpinnerElement[] spinnerElements = SummonElementalActivity.getSpinnerElementValue();
		int summonDifficulty = 0;
		int controlTestDifficulty = 0;
		Resources resources = getResources();
		if(settings.getBoolean("radioElementalServant", false) == true){
			System.out.println("Summon radioElementalServant +4");
			responseText += resources.getString(R.string.str_Summoning) +" "+ resources.getString(R.string.str_ElementalServant)+"\n";
			summonDifficulty += 4;
			System.out.println("Control radioElementalServant +2");
			controlTestDifficulty += 2;
		}
		
		if(settings.getBoolean("radioDjinn", false) == true){
			responseText += resources.getString(R.string.str_Summoning) +" "+ resources.getString(R.string.str_Djinn);
			System.out.println("Summon radioDjinn +8");
			summonDifficulty += 8;
			System.out.println("Control radioDjinn +2");
			controlTestDifficulty += 4;
		}
		
		if(settings.getBoolean("radioMasterOfElement", false) == true){
			responseText += resources.getString(R.string.str_Summoning) +" "+ resources.getString(R.string.str_MasterOfElement);
			System.out.println("Summon radioMasterOfElement +12");
			summonDifficulty += 12;
			System.out.println("Control radioMasterOfElement +8");
			controlTestDifficulty += 8;
		}
		

		responseText += resources.getString(R.string.str_ElementDD) +" "+ resources.getStringArray(R.array.str_ElementsArray)[elementId]+"\n";
		responseText += resources.getString(R.string.str_Personality) + " " + settings.getString("personality","") + "\n\n";
		responseText += resources.getString(R.string.str_weakAgainst) +" "+ resources.getString(R.string.str_ElementDD) + " " + resources.getStringArray(R.array.str_ElementsArray)[spinnerElements[elementId].getCounterElement()]+"\n";
		

		if(settings.getBoolean("astralSense", false) == true){
			System.out.println("Summon astralSense +5");
			responseText += resources.getString(R.string.str_AstralSense) + "\n";
			summonDifficulty += 5;
		}

		if(settings.getBoolean("longArm", false) == true){
			System.out.println("Summon longArm +3");
			responseText += resources.getString(R.string.str_LongArm) + "\n";
			summonDifficulty += 3;
		}

		if(settings.getBoolean("lifeSense", false) == true){
			System.out.println("Summon lifeSense +6");
			responseText += resources.getString(R.string.str_LifeSense) + "\n";
			summonDifficulty += 6;
			controlTestDifficulty += 9;
		}
		String resistanceString = "";
		String immunityString = "";
		if(settings.getBoolean("immunityAgainstMagicAttacks", false) == true){
			System.out.println("Summon immunityAgainstMagicAttacks +13");
			immunityString += resources.getString(R.string.str_ImmunityAgainstMagicAttacks) + "\n";
			summonDifficulty += 13;
		}else if(settings.getBoolean("resistanceAgainstMagicAttacks", false) == true){
			System.out.println("Summon resistanceAgainstMagicAttacks +6");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstMagicAttacks) + "\n";
			summonDifficulty += 6;
		}

		if(settings.getBoolean("regenerationTwo", false) == true){
			System.out.println("Summon regenerationTwo +7");
			responseText += resources.getString(R.string.str_Regeneration) + " " + resources.getString(R.string.str_RomanTwo) + "\n";
			summonDifficulty += 7;
		}else if(settings.getBoolean("regenerationOne", false) == true){
			System.out.println("Summon regenerationOne +4");
			responseText += resources.getString(R.string.str_Regeneration) + " " + resources.getString(R.string.str_RomanOne) + "\n";
			summonDifficulty += 4;
		}

		if(settings.getBoolean("additionalActionsTwo", false) == true){
			System.out.println("Summon additionalActionsTwo +7");
			responseText += resources.getString(R.string.str_AdditionalActions) + " " + resources.getString(R.string.str_RomanTwo) + "\n";
			summonDifficulty += 7;
		}else if(settings.getBoolean("additionalActionsOne", false) == true){
			System.out.println("Summon additionalActionsOne +3");
			responseText += resources.getString(R.string.str_AdditionalActions) + " " + resources.getString(R.string.str_RomanOne) + "\n";
			summonDifficulty += 3;
		}
		
		if(settings.getBoolean("immunityAgainstTraitDamage", false) == true){
			System.out.println("Summon immunityAgainstTraitDamage +10");
			immunityString += resources.getString(R.string.str_ImmunityAgainstTrait) + " " + resources.getString(R.string.str_Damage) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstTraitDamage", false) == true){
			System.out.println("Summon resistanceAgainstTraitDamage +5");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstTrait) + " " + resources.getString(R.string.str_Damage) + "\n";
			summonDifficulty += 5;
		}
		
		if(settings.getBoolean("immunityAgainstDemonicBlakharaz", false) == true){
			System.out.println("Summon immunityAgainstDemonicBlakharaz +10");
			immunityString += resources.getString(R.string.str_ImmunityAgainstDemonic) + " " + resources.getString(R.string.str_Blakharaz) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstDemonicBlakharaz", false) == true){
			System.out.println("Summon resistanceAgainstDemonicBlakharaz +5");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstDemonic) + " " + resources.getString(R.string.str_Blakharaz) + "\n";
			summonDifficulty += 5;
		}
		
		if(settings.getBoolean("immunityAgainstDemonicBelhalhar", false) == true){
			System.out.println("Summon immunityAgainstDemonicBelhalhar +10");
			immunityString += resources.getString(R.string.str_ImmunityAgainstDemonic) + " " + resources.getString(R.string.str_Belhalhar) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstDemonicBelhalhar", false) == true){
			System.out.println("Summon resistanceAgainstDemonicBelhalhar +5");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstDemonic) + " " + resources.getString(R.string.str_Belhalhar) + "\n";
			summonDifficulty += 5;
		}
		
		if(settings.getBoolean("immunityAgainstDemonicLolgramoth", false) == true){
			System.out.println("Summon immunityAgainstDemonicLolgramoth +10");
			immunityString += resources.getString(R.string.str_ImmunityAgainstDemonic) + " " + resources.getString(R.string.str_Lolgramoth) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstDemonicLolgramoth", false) == true){
			System.out.println("Summon resistanceAgainstDemonicLolgramoth +5");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstDemonic) + " " + resources.getString(R.string.str_Lolgramoth) + "\n";
			summonDifficulty += 5;
		}
		
		if(settings.getBoolean("immunityAgainstDemonicAmazeroth", false) == true){
			System.out.println("Summon immunityAgainstDemonicAmazeroth +10");
			immunityString += resources.getString(R.string.str_ImmunityAgainstDemonic) + " " + resources.getString(R.string.str_Amazeroth) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstDemonicAmazeroth", false) == true){
			System.out.println("Summon resistanceAgainstDemonicAmazeroth +5");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstDemonic) + " " + resources.getString(R.string.str_Amazeroth) + "\n";
			summonDifficulty += 5;
		}

		if(settings.getBoolean("immunityAgainstDemonicAsfaloth", false) == true){
			System.out.println("Summon immunityAgainstDemonicAsfaloth +10");
			immunityString += resources.getString(R.string.str_ImmunityAgainstDemonic) + " " + resources.getString(R.string.str_Asfaloth) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstDemonicAsfaloth", false) == true){
			System.out.println("Summon resistanceAgainstDemonicAsfaloth +5");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstDemonic) + " " + resources.getString(R.string.str_Asfaloth) + "\n";
			summonDifficulty += 5;
		}

		if(settings.getBoolean("immunityAgainstDemonicBelzhorash", false) == true){
			System.out.println("Summon immunityAgainstDemonicBelzhorash +10");
			immunityString += resources.getString(R.string.str_ImmunityAgainstDemonic) + " " + resources.getString(R.string.str_Belzhorash) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstDemonicBelzhorash", false) == true){
			System.out.println("Summon resistanceAgainstDemonicBelzhorash +5");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstDemonic) + " " + resources.getString(R.string.str_Belzhorash) + "\n";
			summonDifficulty += 5;
		}

		if(settings.getBoolean("immunityAgainstDemonicAgrimoth", false) == true){
			System.out.println("Summon immunityAgainstDemonicAgrimoth +10");
			immunityString += resources.getString(R.string.str_ImmunityAgainstDemonic) + " " + resources.getString(R.string.str_Agrimoth) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstDemonicAgrimoth", false) == true){
			System.out.println("Summon resistanceAgainstDemonicAgrimoth +5");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstDemonic) + " " + resources.getString(R.string.str_Agrimoth) + "\n";
			summonDifficulty += 5;
		}

		if(settings.getBoolean("immunityAgainstDemonicThargunitoth", false) == true){
			System.out.println("Summon immunityAgainstDemonicThargunitoth +10");
			immunityString += resources.getString(R.string.str_ImmunityAgainstDemonic) + " " + resources.getString(R.string.str_Thargunitoth) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstDemonicThargunitoth", false) == true){
			System.out.println("Summon resistanceAgainstDemonicThargunitoth +5");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstDemonic) + " " + resources.getString(R.string.str_Thargunitoth) + "\n";
			summonDifficulty += 5;
		}

		for (SpinnerElement spinnerElement : SpinnerElement.values()) {
			if(spinnerElement.getIntValue() != elementId){
				if(settings.getBoolean(String.valueOf(spinnerElement.getImmunityCheckboxId()), false) == true){
					System.out.println("Summon " + resources.getString(R.string.str_ImmunityAgainstElementalAttacks) + " " + resources.getStringArray(R.array.str_ElementsArray)[spinnerElement.getIntValue()] + " +7");
					immunityString += resources.getString(R.string.str_ImmunityAgainstElementalAttacks) + " " + resources.getStringArray(R.array.str_ElementsArray)[spinnerElement.getIntValue()] + "\n";
					summonDifficulty += 7;
				}else if(settings.getBoolean(String.valueOf(spinnerElement.getResistanceCheckboxId()), false) == true){
					System.out.println("Summon " + resources.getString(R.string.str_ResistanceAgainstElementalAttacks) + " " + resources.getStringArray(R.array.str_ElementsArray)[spinnerElement.getIntValue()] + " +3");
					resistanceString += resources.getString(R.string.str_ResistanceAgainstElementalAttacks) + " " + resources.getStringArray(R.array.str_ElementsArray)[spinnerElement.getIntValue()] + "\n";
					summonDifficulty += 3;
				}
			}else{
				immunityString += resources.getString(R.string.str_ImmunityAgainstElementalAttacks) + " " + resources.getStringArray(R.array.str_ElementsArray)[spinnerElement.getIntValue()] + "\n";
				System.out.println("Summon " + resources.getString(R.string.str_ImmunityAgainstElementalAttacks) + " " + resources.getStringArray(R.array.str_ElementsArray)[spinnerElement.getIntValue()] + " +0");
			}
		}
		
		int[] qualityOfTrueNameIntArray = getIntArrayFromStringArray(settings.getString("qualityOfTrueName", "(0/0)"));
		System.out.println("Summon qualityOfTrueNameIntArray[0] " + qualityOfTrueNameIntArray[0]);
		summonDifficulty += qualityOfTrueNameIntArray[0];
		System.out.println("Control qualityOfTrueNameIntArray[1] " + qualityOfTrueNameIntArray[1]);
		controlTestDifficulty += qualityOfTrueNameIntArray[1];

		int characterEquipmentModifier = settings.getInt("characterEquipmentModifier", 0);
		if(characterEquipmentModifier == 1 || characterEquipmentModifier == 2){
			System.out.println("Summon characterEquipmentModifier -1");
			summonDifficulty += -1;
			System.out.println("Control characterEquipmentModifier -1");
			controlTestDifficulty += -1;
		}else if(characterEquipmentModifier == 3){
			System.out.println("Summon characterEquipmentModifier -2");
			summonDifficulty += -2;
			System.out.println("Control characterEquipmentModifier -2");
			controlTestDifficulty += -2;
		}
		
		if(settings.getBoolean("talentedElement", false) == true){
			System.out.println("Summon talentedElement -2");
			summonDifficulty += -2;
			System.out.println("Control talentedElement -2");
			controlTestDifficulty += -2;
		}
		
		if(settings.getBoolean("knowledgeElement", false) == true){
			System.out.println("Summon knowledgeElement -2");
			summonDifficulty += -2;
			System.out.println("Control knowledgeElement -2");
			controlTestDifficulty += -2;
		}
		
		if(settings.getBoolean("talentedCounterElement", false) == true){
			System.out.println("Summon talentedCounterElement +4");
			summonDifficulty += 4;
			System.out.println("Control talentedCounterElement +2");
			controlTestDifficulty += 2;
		}
		
		if(settings.getBoolean("knowledgeCounterElement", false) == true){
			System.out.println("Summon knowledgeCounterElement +4");
			summonDifficulty += 4;
			System.out.println("Control knowledgeCounterElement +2");
			controlTestDifficulty += 2;
		}
		
		int talentedDemonic = settings.getInt("talentedDemonic", 0);
		System.out.println("Summon talentedDemonic:" + (talentedDemonic * 2));
		summonDifficulty += (talentedDemonic * 2);
		System.out.println("Control talentedDemonic:" + (talentedDemonic * 4));
		controlTestDifficulty += (talentedDemonic * 4);
		
		int knowledgeDemonic = settings.getInt("knowledgeDemonic", 0);
		System.out.println("Summon knowledgeDemonic: " + (knowledgeDemonic * 2));
		summonDifficulty += (knowledgeDemonic * 2);
		System.out.println("Control knowledgeDemonic: " + (knowledgeDemonic * 4));
		controlTestDifficulty += (knowledgeDemonic * 4);

		if(settings.getBoolean("demonicCovenant", false) == true){
			System.out.println("Summon demonicCovenant +6");
			summonDifficulty += 6;
			System.out.println("Control demonicCovenant +9");
			controlTestDifficulty += 9;
		}

		if(settings.getBoolean("affinityToElementals", false) == true){
			System.out.println("Control affinityToElementals -3");
			controlTestDifficulty += -3;
		}
		if(settings.getBoolean("cloakedAura", false) == true){
			System.out.println("Control cloakedAura +1");
			controlTestDifficulty += 1;
		}
		
		System.out.println("Control weakPresence " + settings.getInt("weakPresence", 0));
		controlTestDifficulty += settings.getInt("weakPresence", 0);

		System.out.println("Control strengthOfStigma " + settings.getInt("strengthOfStigma", 0));
		controlTestDifficulty += settings.getInt("strengthOfStigma", 0);

		int[] circumstancesOfThePlaceIntArray = getIntArrayFromStringArray(settings.getString("circumstancesOfThePlace", "(0/0)"));
		System.out.println("Summon circumstancesOfThePlaceIntArray[0] " + circumstancesOfThePlaceIntArray[0]);
		summonDifficulty += circumstancesOfThePlaceIntArray[0];
		System.out.println("Control circumstancesOfThePlaceIntArray[1] " + circumstancesOfThePlaceIntArray[1]);
		controlTestDifficulty += circumstancesOfThePlaceIntArray[1];
		
		System.out.println("Summon powernode " + settings.getString("powernode", "(0)"));
		summonDifficulty += getIntFromStringArray(settings.getString("powernode", "(0)"));
		
		int[] circumstancesOfTimeIntArray = getIntArrayFromStringArray(settings.getString("circumstancesOfTime", "(0/0)"));
		System.out.println("Summon circumstancesOfTimeIntArray[0] " + circumstancesOfTimeIntArray[0]);
		summonDifficulty += circumstancesOfTimeIntArray[0];
		System.out.println("Control circumstancesOfTimeIntArray[1] " + circumstancesOfTimeIntArray[1]);
		controlTestDifficulty += circumstancesOfTimeIntArray[1];

		System.out.println("Summon qualityOfMaterial " + settings.getString("qualityOfMaterial", "(0)"));
		summonDifficulty += getIntFromStringArray(settings.getString("qualityOfMaterial", "(0)"));

		int[] qualityOfGiftIntArray = getIntArrayFromStringArray(settings.getString("qualityOfGift", "(0/0)"));
		System.out.println("Summon qualityOfGiftIntArray[0] " + qualityOfGiftIntArray[0]);
		summonDifficulty += qualityOfGiftIntArray[0];
		System.out.println("Control qualityOfGiftIntArray[1] " + qualityOfGiftIntArray[1]);
		controlTestDifficulty += qualityOfGiftIntArray[1];
		
		int[] qualityOfDeedIntArray = getIntArrayFromStringArray(settings.getString("qualityOfDeed", "(0/0)"));
		System.out.println("Summon qualityOfDeedIntArray[0] " + qualityOfDeedIntArray[0]);
		summonDifficulty += qualityOfDeedIntArray[0];
		System.out.println("Control qualityOfDeedIntArray[1] " + qualityOfDeedIntArray[1]);
		controlTestDifficulty += qualityOfDeedIntArray[1];
		
		if(settings.getBoolean("bloodmagicUsed", false) == true){
			System.out.println("Control bloodmagicUsed +12");
			controlTestDifficulty += 12;
		}
		if(settings.getBoolean("summonedLesserDemon", false) == true){
			System.out.println("Summon summonedLesserDemon +4");
			controlTestDifficulty += 4;
		}
		if(settings.getBoolean("summonedHornedDemon", false) == true){
			System.out.println("Summon summonedHornedDemon +4");
			controlTestDifficulty += 4;
		}
		if(settings.getInt("additionalSummon",0) > 0){
			System.out.println("Summon additionalSummon +" + settings.getInt("additionalSummon",0));
			summonDifficulty += settings.getInt("additionalSummon",0);
		}else if(settings.getInt("additionalSummon",0) < 0){
			System.out.println("Summon additionalSummon " + settings.getInt("additionalSummon",0));
			summonDifficulty += settings.getInt("additionalSummon",0);
		}
		
		if(settings.getInt("additionalControl",0) > 0){
			System.out.println("Summon additionalControl +" + settings.getInt("additionalControl",0));
			controlTestDifficulty += settings.getInt("additionalControl",0);
		}else if(settings.getInt("additionalControl",0) < 0){
			System.out.println("Summon additionalControl " + settings.getInt("additionalControl",0));
			controlTestDifficulty += settings.getInt("additionalControl",0);
		}
		/*int statCourage = settings.getInt("statCourage", 0);
		int statWisdom = settings.getInt("statWisdom", 0);
		int statCharisma = settings.getInt("statCharisma", 0);
		int statIntuition = settings.getInt("statIntuition", 0);
		int talentCallElementalServant = settings.getInt("talentCallElementalServant", 0);
		int talentCallDjinn = settings.getInt("talentCallDjinn", 0);
		int talentCallMasterOfElement = settings.getInt("talentCallMasterOfElement", 0);*/
		
		String summonDifficultyString = resources.getString(R.string.str_SummoningModifier)+ " " + summonDifficulty + "\n";
		String controlTestDifficultyString = resources.getString(R.string.str_ControlTestModifier)+ " " + controlTestDifficulty + "\n";
		ScrollView.LayoutParams editParams = new ScrollView.LayoutParams(LayoutParams.MATCH_PARENT,LayoutParams.WRAP_CONTENT);
		TextView textView = new TextView(this);
		textView.setText(responseText + resistanceString + immunityString + "\n" + summonDifficultyString + controlTestDifficultyString);
		textView.setLayoutParams(editParams);
		ScrollView myLayout = (ScrollView) findViewById(R.id.ScrollLayout1);
		myLayout.addView(textView);
	}
	public int getIntFromStringArray(String string){
		String found = null;
		Pattern my_pattern = Pattern.compile("\\([-+]?\\d+\\)");
		Matcher m = my_pattern.matcher(string);
		if(m.find()){
			found = m.group(0);
		}
		if(found  != null){
			found = found.substring(1, found.length()-1);
			try{
				if(found.substring(0, 1).equals("+")){
					found = found.substring(1, found.length());
					return Integer.parseInt(found);
				}else{
					return Integer.parseInt(found);
				}
			}catch(StringIndexOutOfBoundsException e){}
		}
		return 0;
	}
	public int[] getIntArrayFromStringArray(String string){
		String found = null;
		int[] returnArray = {0,0};
		Pattern my_pattern = Pattern.compile("\\([-+]?\\d+/[-+]?\\d+\\)");
		Matcher m = my_pattern.matcher(string);
		if(m.find()){
			found = m.group(0);
		}
		if(found  != null){
			found = found.substring(1, found.length()-1);
			String[] parts = found.split("/");
			int counter = 0;
			for(String element : parts){
				int tempInt = 0;
				try{
					if(element.substring(0, 1).equals("+")){
						element = element.substring(1, element.length());
						tempInt = Integer.parseInt(element);
					}else{
						tempInt = Integer.parseInt(element);
					}
				}catch(StringIndexOutOfBoundsException e){}
				if(counter <= (returnArray.length-1)){
					returnArray[counter] = tempInt;
				}
				counter++;
			}
			return returnArray;
		}
		return returnArray;
	}
}
