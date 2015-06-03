package de.dsa_aachen.dsa_elements_summons;

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
		int statCourage = settings.getInt("statCourage", 0);
		System.out.println("statCourage = "+statCourage);
		int statWisdom = settings.getInt("statWisdom", 0);
		System.out.println("statWisdom = "+statWisdom);
		int statCharisma = settings.getInt("statCharisma", 0);
		System.out.println("statCharisma = "+statCharisma);
		int statIntuition = settings.getInt("statIntuition", 0);
		System.out.println("statIntuition = "+statIntuition);
		int talentCallElementalServant = settings.getInt("talentCallElementalServant", 0);
		System.out.println("talentCallElementalServant = "+talentCallElementalServant);
		int talentCallDjinn = settings.getInt("talentCallDjinn", 0);
		System.out.println("talentCallDjinn = "+talentCallDjinn);
		int talentCallMasterOfElement = settings.getInt("talentCallMasterOfElement", 0);
		System.out.println("talentCallMasterOfElement = "+talentCallMasterOfElement);
		boolean talentedElement = settings.getBoolean("talentedElement", false);
		System.out.println("talentedElement = "+talentedElement);
		int talentedDemonic = settings.getInt("talentedDemonic", 0);
		System.out.println("talentedDemonic = "+talentedDemonic);
		boolean knowledgeElement = settings.getBoolean("knowledgeElement", false);
		System.out.println("knowledgeElement = "+knowledgeElement);
		int knowledgeDemonic = settings.getInt("knowledgeDemonic", 0);
		System.out.println("knowledgeDemonic = "+knowledgeDemonic);
		boolean affinityToElementals = settings.getBoolean("affinityToElementals", false);
		System.out.println("affinityToElementals = "+affinityToElementals);
		boolean demonicCovenant = settings.getBoolean("demonicCovenant", false);
		System.out.println("demonicCovenant = "+demonicCovenant);
		boolean cloakedAura = settings.getBoolean("cloakedAura", false);
		System.out.println("cloakedAura = "+cloakedAura);
		int weakPresence = settings.getInt("weakPresence", 0);
		System.out.println("weakPresence = "+weakPresence);
		int strengthOfStigma = settings.getInt("strengthOfStigma", 0);
		System.out.println("strengthOfStigma = "+strengthOfStigma);
		int characterEquipmentModifier = settings.getInt("characterEquipmentModifier", 0);
		System.out.println("characterEquipmentModifier = "+characterEquipmentModifier);
		boolean radioElementalServant = settings.getBoolean("radioElementalServant", false);
		System.out.println("radioElementalServant = "+radioElementalServant);
		boolean radioDjinn = settings.getBoolean("radioDjinn", false);
		System.out.println("radioDjinn = "+radioDjinn);
		boolean radioMasterOfElement = settings.getBoolean("radioMasterOfElement", false);
		System.out.println("radioMasterOfElement = "+radioMasterOfElement);
		String qualityOfMaterial = settings.getString("qualityOfMaterial", "(0)");
		System.out.println("qualityOfMaterial = "+qualityOfMaterial);
		String qualityOfTrueName = settings.getString("qualityOfTrueName", "(0/0)");
		System.out.println("qualityOfTrueName = "+qualityOfTrueName);
		String circumstancesOfThePlace = settings.getString("circumstancesOfThePlace", "(0/0)");
		System.out.println("circumstancesOfThePlace = "+circumstancesOfThePlace);
		String circumstancesOfTime = settings.getString("circumstancesOfTime", "(0/0)");
		System.out.println("circumstancesOfTime = "+circumstancesOfTime);
		//System.out.println(settings.toString());
	}
	public int getIntFromStringArray(){
		return 0;
	}
	public int[] getIntArrayFromStringArray(){
		return new int[] {0,0};
	}
}
