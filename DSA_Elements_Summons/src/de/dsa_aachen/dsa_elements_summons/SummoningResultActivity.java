package de.dsa_aachen.dsa_elements_summons;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.app.Activity;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.os.Bundle;
import de.dsa_aachen.dsa_elements_summons.SummonElementalActivity;
import de.dsa_aachen.dsa_elements_summons.SummonElementalActivity.SpinnerElement;

public class SummoningResultActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.summoning_result_activity);
		SharedPreferences settings = this.getSharedPreferences("de.dsa_aachen.dsa_elements_summons", MODE_PRIVATE);
		int summonDifficulty = 0;
		int controlTestDifficulty = 0;
		if(settings.getBoolean("radioElementalServant", false) == true){
			summonDifficulty += 4;
			controlTestDifficulty += 2;
		}
		
		if(settings.getBoolean("radioDjinn", false) == true){
			summonDifficulty += 8;
			controlTestDifficulty += 4;
		}
		
		if(settings.getBoolean("radioMasterOfElement", false) == true){
			summonDifficulty += 12;
			controlTestDifficulty += 8;
		}
		
		int[] qualityOfTrueNameIntArray = getIntArrayFromStringArray(settings.getString("qualityOfTrueName", "(0/0)"));
		summonDifficulty += qualityOfTrueNameIntArray[0];
		summonDifficulty += qualityOfTrueNameIntArray[1];

		int characterEquipmentModifier = settings.getInt("characterEquipmentModifier", 0);
		if(characterEquipmentModifier == 1 || characterEquipmentModifier == 2){
			summonDifficulty += -1;
			controlTestDifficulty += -1;
		}else if(characterEquipmentModifier == 3){
			summonDifficulty += -2;
			controlTestDifficulty += -2;
		}
		
		if(settings.getBoolean("talentedElement", false) == true){
			summonDifficulty += -2;
			controlTestDifficulty += -2;
		}
		
		if(settings.getBoolean("knowledgeElement", false) == true){
			summonDifficulty += -2;
			controlTestDifficulty += -2;
		}
		

		
		if(settings.getBoolean("talentedCounterElement", false) == true){
			summonDifficulty += 4;
			controlTestDifficulty += 2;
		}
		
		if(settings.getBoolean("knowledgeCounterElement", false) == true){
			summonDifficulty += 4;
			controlTestDifficulty += 2;
		}
		
		int talentedDemonic = settings.getInt("talentedDemonic", 0);
		summonDifficulty += (talentedDemonic * 2);
		controlTestDifficulty += (talentedDemonic * 4);
		
		int knowledgeDemonic = settings.getInt("knowledgeDemonic", 0);
		summonDifficulty += (knowledgeDemonic * 2);
		controlTestDifficulty += (knowledgeDemonic * 4);

		if(settings.getBoolean("demonicCovenant", false) == true){
			summonDifficulty += 6;
			controlTestDifficulty += 9;
		}

		if(settings.getBoolean("affinityToElementals", false) == true){
			controlTestDifficulty += -3;
		}
		if(settings.getBoolean("cloakedAura", false) == true){
			controlTestDifficulty += 1;
		}
		controlTestDifficulty += settings.getInt("weakPresence", 0);

		controlTestDifficulty += settings.getInt("strengthOfStigma", 0);

		int[] circumstancesOfThePlaceIntArray = getIntArrayFromStringArray(settings.getString("circumstancesOfThePlace", "(0/0)"));
		summonDifficulty += circumstancesOfThePlaceIntArray[0];
		controlTestDifficulty += circumstancesOfThePlaceIntArray[1];
		
		int[] circumstancesOfTimeIntArray = getIntArrayFromStringArray(settings.getString("circumstancesOfTime", "(0/0)"));
		summonDifficulty += circumstancesOfTimeIntArray[0];
		controlTestDifficulty += circumstancesOfTimeIntArray[1];
		
		summonDifficulty += getIntFromStringArray(settings.getString("qualityOfMaterial", "(0)"));

		int[] qualityOfGiftIntArray = getIntArrayFromStringArray(settings.getString("qualityOfGift", "(0/0)"));
		summonDifficulty += qualityOfGiftIntArray[0];
		controlTestDifficulty += qualityOfGiftIntArray[1];
		
		int[] qualityOfDeedIntArray = getIntArrayFromStringArray(settings.getString("qualityOfDeed", "(0/0)"));
		summonDifficulty += qualityOfDeedIntArray[0];
		controlTestDifficulty += qualityOfDeedIntArray[1];
		
		int statCourage = settings.getInt("statCourage", 0);
		int statWisdom = settings.getInt("statWisdom", 0);
		int statCharisma = settings.getInt("statCharisma", 0);
		int statIntuition = settings.getInt("statIntuition", 0);
		int talentCallElementalServant = settings.getInt("talentCallElementalServant", 0);
		int talentCallDjinn = settings.getInt("talentCallDjinn", 0);
		int talentCallMasterOfElement = settings.getInt("talentCallMasterOfElement", 0);
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
			return Integer.parseInt(found);
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
				int tempInt = Integer.parseInt(element);
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
