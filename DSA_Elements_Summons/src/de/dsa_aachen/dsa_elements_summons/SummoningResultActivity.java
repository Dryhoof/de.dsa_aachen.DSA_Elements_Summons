package de.dsa_aachen.dsa_elements_summons;

import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.app.Activity;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.os.Bundle;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.LinearLayout;
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
		//printSharedPreferences(settings);
		int summonDifficulty = 0;
		int controlTestDifficulty = 0;
		Resources resources = getResources();
		if(settings.getBoolean("radioElementalServant", false) == true){
			System.out.println("radioElementalServant");
			responseText += resources.getString(R.string.str_ElementalServant)+"\n";
			summonDifficulty += 4;
			controlTestDifficulty += 2;
		}
		
		if(settings.getBoolean("radioDjinn", false) == true){
			System.out.println("radioDjinn");
			responseText += resources.getString(R.string.str_Djinn);
			summonDifficulty += 8;
			controlTestDifficulty += 4;
		}
		
		if(settings.getBoolean("radioMasterOfElement", false) == true){
			System.out.println("radioMasterOfElement");
			responseText += "Summoning:" + resources.getString(R.string.str_MasterOfElement);
			summonDifficulty += 12;
			controlTestDifficulty += 8;
		}
		

		responseText += "Element: "+resources.getStringArray(R.array.str_ElementsArray)[elementId]+"\n";
		responseText += resources.getString(R.string.str_weakAgainst) +" element: "+resources.getStringArray(R.array.str_ElementsArray)[spinnerElements[elementId].getCounterElement()]+"\n";
		

		if(settings.getBoolean("astralSense", false) == true){
			System.out.println("astralSense");
			responseText += resources.getString(R.string.str_AstralSense) + "\n";
			summonDifficulty += 5;
		}

		if(settings.getBoolean("longArm", false) == true){
			System.out.println("longArm");
			responseText += resources.getString(R.string.str_LongArm) + "\n";
			summonDifficulty += 3;
		}

		if(settings.getBoolean("lifeSense", false) == true){
			System.out.println("lifeSense");
			responseText += resources.getString(R.string.str_LifeSense) + "\n";
			summonDifficulty += 6;
			controlTestDifficulty += 9;
		}
		String resistanceString = "";
		String immunityString = "";
		if(settings.getBoolean("immunityAgainstMagicAttacks", false) == true){
			System.out.println("immunityAgainstMagicAttacks");
			immunityString += resources.getString(R.string.str_ImmunityAgainstMagicAttacks) + "\n";
			summonDifficulty += 13;
		}else if(settings.getBoolean("resistanceAgainstMagicAttacks", false) == true){
			System.out.println("resistanceAgainstMagicAttacks");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstMagicAttacks) + "\n";
			summonDifficulty += 6;
		}

		if(settings.getBoolean("regenerationTwo", false) == true){
			System.out.println("regenerationTwo");
			responseText += resources.getString(R.string.str_Regeneration) + " " + resources.getString(R.string.str_RomanTwo) + "\n";
			summonDifficulty += 7;
		}else if(settings.getBoolean("regenerationOne", false) == true){
			System.out.println("regenerationOne");
			responseText += resources.getString(R.string.str_Regeneration) + " " + resources.getString(R.string.str_RomanOne) + "\n";
			summonDifficulty += 4;
		}

		if(settings.getBoolean("additionalActionsTwo", false) == true){
			System.out.println("additionalActionsTwo");
			responseText += resources.getString(R.string.str_AdditionalActions) + " " + resources.getString(R.string.str_RomanTwo) + "\n";
			summonDifficulty += 7;
		}else if(settings.getBoolean("additionalActionsOne", false) == true){
			System.out.println("additionalActionsOne");
			responseText += resources.getString(R.string.str_AdditionalActions) + " " + resources.getString(R.string.str_RomanOne) + "\n";
			summonDifficulty += 3;
		}
		
		if(settings.getBoolean("immunityAgainstTraitDamage", false) == true){
			System.out.println("immunityAgainstTraitDamage");
			immunityString += resources.getString(R.string.str_ImmunityAgainstTrait) + " " + resources.getString(R.string.str_Damage) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstTraitDamage", false) == true){
			System.out.println("resistanceAgainstTraitDamage");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstTrait) + " " + resources.getString(R.string.str_Damage) + "\n";
			summonDifficulty += 5;
		}
		
		if(settings.getBoolean("immunityAgainstDemonicBlakharaz", false) == true){
			System.out.println("immunityAgainstDemonicBlakharaz");
			immunityString += resources.getString(R.string.str_ImmunityAgainstDemonic) + " " + resources.getString(R.string.str_Blakharaz) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstDemonicBlakharaz", false) == true){
			System.out.println("resistanceAgainstDemonicBlakharaz");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstDemonic) + " " + resources.getString(R.string.str_Blakharaz) + "\n";
			summonDifficulty += 5;
		}
		
		if(settings.getBoolean("immunityAgainstDemonicBelhalhar", false) == true){
			System.out.println("immunityAgainstDemonicBelhalhar");
			immunityString += resources.getString(R.string.str_ImmunityAgainstDemonic) + " " + resources.getString(R.string.str_Belhalhar) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstDemonicBelhalhar", false) == true){
			System.out.println("resistanceAgainstDemonicBelhalhar");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstDemonic) + " " + resources.getString(R.string.str_Belhalhar) + "\n";
			summonDifficulty += 5;
		}
		
		if(settings.getBoolean("immunityAgainstDemonicLolgramoth", false) == true){
			System.out.println("immunityAgainstDemonicLolgramoth");
			immunityString += resources.getString(R.string.str_ImmunityAgainstDemonic) + " " + resources.getString(R.string.str_Lolgramoth) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstDemonicLolgramoth", false) == true){
			System.out.println("resistanceAgainstDemonicLolgramoth");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstDemonic) + " " + resources.getString(R.string.str_Lolgramoth) + "\n";
			summonDifficulty += 5;
		}
		
		if(settings.getBoolean("immunityAgainstDemonicAmazeroth", false) == true){
			System.out.println("immunityAgainstDemonicAmazeroth");
			immunityString += resources.getString(R.string.str_ImmunityAgainstDemonic) + " " + resources.getString(R.string.str_Amazeroth) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstDemonicAmazeroth", false) == true){
			System.out.println("resistanceAgainstDemonicAmazeroth");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstDemonic) + " " + resources.getString(R.string.str_Amazeroth) + "\n";
			summonDifficulty += 5;
		}

		if(settings.getBoolean("immunityAgainstDemonicAsfaloth", false) == true){
			System.out.println("immunityAgainstDemonicAsfaloth");
			immunityString += resources.getString(R.string.str_ImmunityAgainstDemonic) + " " + resources.getString(R.string.str_Asfaloth) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstDemonicAsfaloth", false) == true){
			System.out.println("resistanceAgainstDemonicAsfaloth");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstDemonic) + " " + resources.getString(R.string.str_Asfaloth) + "\n";
			summonDifficulty += 5;
		}

		if(settings.getBoolean("immunityAgainstDemonicBelzhorash", false) == true){
			System.out.println("immunityAgainstDemonicBelzhorash");
			immunityString += resources.getString(R.string.str_ImmunityAgainstDemonic) + " " + resources.getString(R.string.str_Belzhorash) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstDemonicBelzhorash", false) == true){
			System.out.println("resistanceAgainstDemonicBelzhorash");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstDemonic) + " " + resources.getString(R.string.str_Belzhorash) + "\n";
			summonDifficulty += 5;
		}

		if(settings.getBoolean("immunityAgainstDemonicAgrimoth", false) == true){
			System.out.println("immunityAgainstDemonicAgrimoth");
			immunityString += resources.getString(R.string.str_ImmunityAgainstDemonic) + " " + resources.getString(R.string.str_Agrimoth) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstDemonicAgrimoth", false) == true){
			System.out.println("resistanceAgainstDemonicAgrimoth");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstDemonic) + " " + resources.getString(R.string.str_Agrimoth) + "\n";
			summonDifficulty += 5;
		}

		if(settings.getBoolean("immunityAgainstDemonicThargunitoth", false) == true){
			System.out.println("immunityAgainstDemonicThargunitoth");
			immunityString += resources.getString(R.string.str_ImmunityAgainstDemonic) + " " + resources.getString(R.string.str_Thargunitoth) + "\n";
			summonDifficulty += 10;
		}else if(settings.getBoolean("resistanceAgainstDemonicThargunitoth", false) == true){
			System.out.println("resistanceAgainstDemonicThargunitoth");
			resistanceString += resources.getString(R.string.str_ResistanceAgainstDemonic) + " " + resources.getString(R.string.str_Thargunitoth) + "\n";
			summonDifficulty += 5;
		}

		for (SpinnerElement spinnerElement : SpinnerElement.values()) {
			if(spinnerElement.getIntValue() != elementId){
				if(settings.getBoolean(String.valueOf(spinnerElement.getImmunityCheckboxId()), false) == true){
					System.out.println(resources.getString(R.string.str_ImmunityAgainstElementalAttacks) + " " + resources.getStringArray(R.array.str_ElementsArray)[spinnerElement.getIntValue()] + " +7");
					immunityString += resources.getString(R.string.str_ImmunityAgainstElementalAttacks) + " " + resources.getStringArray(R.array.str_ElementsArray)[spinnerElement.getIntValue()] + "\n";
					summonDifficulty += 7;
				}else if(settings.getBoolean(String.valueOf(spinnerElement.getResistanceCheckboxId()), false) == true){
					System.out.println(resources.getString(R.string.str_ResistanceAgainstElementalAttacks) + " " + resources.getStringArray(R.array.str_ElementsArray)[spinnerElement.getIntValue()] + " +3");
					resistanceString += resources.getString(R.string.str_ResistanceAgainstElementalAttacks) + " " + resources.getStringArray(R.array.str_ElementsArray)[spinnerElement.getIntValue()] + "\n";
					summonDifficulty += 3;
				}
			}else{
				immunityString += resources.getString(R.string.str_ImmunityAgainstElementalAttacks) + " " + resources.getStringArray(R.array.str_ElementsArray)[spinnerElement.getIntValue()] + "\n";
				System.out.println(resources.getString(R.string.str_ImmunityAgainstElementalAttacks) + " " + resources.getStringArray(R.array.str_ElementsArray)[spinnerElement.getIntValue()] + " +0");
			}
		}
		
		int[] qualityOfTrueNameIntArray = getIntArrayFromStringArray(settings.getString("qualityOfTrueName", "(0/0)"));
		summonDifficulty += qualityOfTrueNameIntArray[0];
		System.out.println("qualityOfTrueNameIntArray[0]" + qualityOfTrueNameIntArray[0]);
		summonDifficulty += qualityOfTrueNameIntArray[1];
		System.out.println("qualityOfTrueNameIntArray[1]" + qualityOfTrueNameIntArray[1]);

		int characterEquipmentModifier = settings.getInt("characterEquipmentModifier", 0);
		if(characterEquipmentModifier == 1 || characterEquipmentModifier == 2){
			System.out.println("characterEquipmentModifier" + characterEquipmentModifier);
			summonDifficulty += -1;
			controlTestDifficulty += -1;
		}else if(characterEquipmentModifier == 3){
			System.out.println("characterEquipmentModifier" + characterEquipmentModifier);
			summonDifficulty += -2;
			controlTestDifficulty += -2;
		}
		
		if(settings.getBoolean("talentedElement", false) == true){
			System.out.println("talentedElement");
			summonDifficulty += -2;
			controlTestDifficulty += -2;
		}
		
		if(settings.getBoolean("knowledgeElement", false) == true){
			System.out.println("knowledgeElement");
			summonDifficulty += -2;
			controlTestDifficulty += -2;
		}
		
		if(settings.getBoolean("talentedCounterElement", false) == true){
			System.out.println("talentedCounterElement");
			summonDifficulty += 4;
			controlTestDifficulty += 2;
		}
		
		if(settings.getBoolean("knowledgeCounterElement", false) == true){
			System.out.println("knowledgeCounterElement");
			summonDifficulty += 4;
			controlTestDifficulty += 2;
		}
		
		int talentedDemonic = settings.getInt("talentedDemonic", 0);
		System.out.println("talentedDemonic");
		summonDifficulty += (talentedDemonic * 2);
		controlTestDifficulty += (talentedDemonic * 4);
		
		int knowledgeDemonic = settings.getInt("knowledgeDemonic", 0);
		System.out.println("knowledgeDemonic");
		summonDifficulty += (knowledgeDemonic * 2);
		controlTestDifficulty += (knowledgeDemonic * 4);

		if(settings.getBoolean("demonicCovenant", false) == true){
			System.out.println("demonicCovenant");
			summonDifficulty += 6;
			controlTestDifficulty += 9;
		}

		if(settings.getBoolean("affinityToElementals", false) == true){
			System.out.println("affinityToElementals");
			controlTestDifficulty += -3;
		}
		if(settings.getBoolean("cloakedAura", false) == true){
			System.out.println("cloakedAura");
			controlTestDifficulty += 1;
		}
		controlTestDifficulty += settings.getInt("weakPresence", 0);
		System.out.println("weakPresence" + settings.getInt("weakPresence", 0));

		controlTestDifficulty += settings.getInt("strengthOfStigma", 0);
		System.out.println("strengthOfStigma" + settings.getInt("strengthOfStigma", 0));

		int[] circumstancesOfThePlaceIntArray = getIntArrayFromStringArray(settings.getString("circumstancesOfThePlace", "(0/0)"));
		System.out.println("circumstancesOfThePlaceIntArray[0]" + circumstancesOfThePlaceIntArray[0]);
		summonDifficulty += circumstancesOfThePlaceIntArray[0];
		System.out.println("circumstancesOfThePlaceIntArray[1]" + circumstancesOfThePlaceIntArray[1]);
		controlTestDifficulty += circumstancesOfThePlaceIntArray[1];
		
		int[] circumstancesOfTimeIntArray = getIntArrayFromStringArray(settings.getString("circumstancesOfTime", "(0/0)"));
		System.out.println("circumstancesOfTimeIntArray[0]" + circumstancesOfTimeIntArray[0]);
		summonDifficulty += circumstancesOfTimeIntArray[0];
		System.out.println("circumstancesOfTimeIntArray[1]" + circumstancesOfTimeIntArray[1]);
		controlTestDifficulty += circumstancesOfTimeIntArray[1];
		
		summonDifficulty += getIntFromStringArray(settings.getString("qualityOfMaterial", "(0)"));
		System.out.println("qualityOfMaterial" + settings.getString("qualityOfMaterial", "(0)"));

		int[] qualityOfGiftIntArray = getIntArrayFromStringArray(settings.getString("qualityOfGift", "(0/0)"));
		System.out.println("qualityOfGiftIntArray[0]" + qualityOfGiftIntArray[0]);
		summonDifficulty += qualityOfGiftIntArray[0];
		System.out.println("qualityOfGiftIntArray[1]" + qualityOfGiftIntArray[1]);
		controlTestDifficulty += qualityOfGiftIntArray[1];
		
		int[] qualityOfDeedIntArray = getIntArrayFromStringArray(settings.getString("qualityOfDeed", "(0/0)"));
		System.out.println("qualityOfDeedIntArray[0]" + qualityOfDeedIntArray[0]);
		summonDifficulty += qualityOfDeedIntArray[0];
		System.out.println("qualityOfDeedIntArray[1]" + qualityOfDeedIntArray[1]);
		controlTestDifficulty += qualityOfDeedIntArray[1];
		
		if(settings.getBoolean("bloodmagicUsed", false) == true){
			System.out.println("bloodmagicUsed");
			controlTestDifficulty += 12;
		}
		if(settings.getBoolean("summonedLesserDemon", false) == true){
			System.out.println("summonedLesserDemon");
			controlTestDifficulty += 4;
		}
		if(settings.getBoolean("summonedHornedDemon", false) == true){
			System.out.println("summonedHornedDemon");
			controlTestDifficulty += 4;
		}

		int statCourage = settings.getInt("statCourage", 0);
		int statWisdom = settings.getInt("statWisdom", 0);
		int statCharisma = settings.getInt("statCharisma", 0);
		int statIntuition = settings.getInt("statIntuition", 0);
		int talentCallElementalServant = settings.getInt("talentCallElementalServant", 0);
		int talentCallDjinn = settings.getInt("talentCallDjinn", 0);
		int talentCallMasterOfElement = settings.getInt("talentCallMasterOfElement", 0);
		String summonDifficultyString = resources.getString(R.string.str_SummoningDifficulty)+ " " + summonDifficulty + "\n";
		String controlTestDifficultyString = resources.getString(R.string.str_ControlTestDifficulty)+ " " + controlTestDifficulty + "\n";
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
					if(element.substring(1, 2).equals("+")){
						element = element.substring(2, element.length());
						tempInt = Integer.parseInt(element);
					}else{
						element = element.substring(1, element.length());
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
	
	private void printSharedPreferences(SharedPreferences prefs){
		Map<String,?> keys = prefs.getAll();

		for(Map.Entry<String,?> entry : keys.entrySet()){
			System.out.printf("map values",entry.getKey() + ": " + 
		                                   entry.getValue().toString());            
		 }
	}
}
