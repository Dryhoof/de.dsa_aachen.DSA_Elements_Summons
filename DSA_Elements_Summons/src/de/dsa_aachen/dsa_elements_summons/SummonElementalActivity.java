package de.dsa_aachen.dsa_elements_summons;

import java.util.Random;

import de.dsa_aachen.dsa_elements_summons.DSA_Summons_Elements_Database.dbField;
import de.dsa_aachen.dsa_elements_summons.DSA_Summons_Elements_CharacterClasses.Classes;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.TextView;
import android.widget.LinearLayout.LayoutParams;
import android.widget.Spinner;

public class SummonElementalActivity extends Activity 
	implements OnItemSelectedListener, OnCheckedChangeListener{
	private int dbId;
	private boolean firstStart = true;
	private boolean lastResistanceAgainstTraitDamage = false;
	private boolean lastImmunityAgainstTraitDamage = false;
	DSA_Summons_Elements_Database DB = new DSA_Summons_Elements_Database(this);
	public static enum SpinnerElement {
		fire(0,
				R.array.str_ElementalPurityFireArray,
				dbField.talentedFire,
				dbField.knowledgeFire,
				1,
				//dbField.talentedWater,
				//dbField.knowledgeWater,
				R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksFire,
				R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksFire,
				R.array.str_personalityFireArray),
        water(1,
        		R.array.str_ElementalPurityWaterArray,
        		dbField.talentedWater,
        		dbField.knowledgeWater,
				0,
        		//dbField.talentedFire,
        		//dbField.knowledgeFire,
        		R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksWater,
        		R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksWater,
				R.array.str_personalityWaterArray),
        life(2,
        		R.array.str_ElementalPurityLifeArray,
        		dbField.talentedLife,
        		dbField.knowledgeLife,
				3,
        		//dbField.talentedIce,
        		//dbField.knowledgeIce,
        		R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksLife,
        		R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksLife,
				R.array.str_personalityLifeArray),
        ice(3,
        		R.array.str_ElementalPurityIceArray,
        		dbField.talentedIce,
        		dbField.knowledgeIce,
				2,
        		//dbField.talentedLife,
        		//dbField.knowledgeLife,
        		R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksIce,
        		R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksIce,
				R.array.str_personalityIceArray),
        stone(4,
        		R.array.str_ElementalPurityStoneArray,
        		dbField.talentedStone,
        		dbField.knowledgeStone,
				5,
        		//dbField.talentedAir,
        		//dbField.knowledgeAir,
        		R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksStone,
        		R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksStone,
				R.array.str_personalityStoneArray),
        air(5,
        		R.array.str_ElementalPurityAirArray,
        		dbField.talentedAir,
        		dbField.knowledgeAir,
				4,
        		//dbField.talentedStone,
        		//dbField.knowledgeStone,
        		R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksAir,
        		R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksAir,
				R.array.str_personalityAirArray);
		
	    private int intValue;
	    private int stringArrayId;
	    private dbField talentedElementDbField;
	    private dbField knowledgeElementDbField;
	    private int counterElement;
	    //private dbField talentedCounterElementDbField;
	    //private dbField knowledgeCounterElementDbField;
	    private int resistanceCheckboxId;
	    private int immunityCheckboxId;
	    private int personalityArrayId;
        private SpinnerElement(
        		int value,
        		int array,
        		dbField telentedElement,
        		dbField knowledgeElement,
        		int counterElement,
        		//dbField talentedCounterElementDbField,
        		//dbField knowledgeCounterElementDbField,
        		int resistanceCheckboxId,
        		int immunityCheckboxId,
        		int personalityArrayId) 
        {
        	setIntValue(value);
        	setStringArrayId(array);
        	setTalentedElementDbField(telentedElement);
        	setKnowledgeElementDbField(knowledgeElement);
        	setCounterElement(counterElement);
        	//setTalentedCounterElementDbField(talentedCounterElementDbField);
        	//setKnowledgeCounterElementDbField(knowledgeCounterElementDbField);
        	setResistanceCheckboxId(resistanceCheckboxId);
        	setImmunityCheckboxId(immunityCheckboxId);
        	setPersonalityArrayId(personalityArrayId);
        }
		public int getIntValue() {
			return intValue;
		}
		public void setIntValue(int intValue) {
			this.intValue = intValue;
		}
		public int getStringArrayId() {
			return stringArrayId;
		}
		public void setStringArrayId(int stringArrayId) {
			this.stringArrayId = stringArrayId;
		}
		public dbField getTalentedElementDbField() {
			return talentedElementDbField;
		}
		public void setTalentedElementDbField(dbField talentedElementDbField) {
			this.talentedElementDbField = talentedElementDbField;
		}
		public dbField getKnowledgeElementDbField() {
			return knowledgeElementDbField;
		}
		public void setKnowledgeElementDbField(dbField knowledgeElementDbField) {
			this.knowledgeElementDbField = knowledgeElementDbField;
		}

		public int getCounterElement() {
			return counterElement;
		}
		public void setCounterElement(int counterElement) {
			this.counterElement = counterElement;
		}
		/*public dbField getTalentedCounterElementDbField() {
			return talentedCounterElementDbField;
		}
		public void setTalentedCounterElementDbField(dbField talentedCounterElementDbField) {
			this.talentedCounterElementDbField = talentedCounterElementDbField;
		}
		public dbField getKnowledgeCounterElementDbField() {
			return knowledgeCounterElementDbField;
		}
		public void setKnowledgeCounterElementDbField(dbField knowledgeCounterElementDbField) {
			this.knowledgeCounterElementDbField = knowledgeCounterElementDbField;
		}*/
		public int getResistanceCheckboxId()
		{
			return resistanceCheckboxId;
		}
		public void setResistanceCheckboxId(int resistanceCheckboxId)
		{
			this.resistanceCheckboxId = resistanceCheckboxId;
		}
		public int getImmunityCheckboxId()
		{
			return immunityCheckboxId;
		}
		public void setImmunityCheckboxId(int immunityCheckboxId)
		{
			this.immunityCheckboxId = immunityCheckboxId;
		}
		public int getPersonalityArrayId()
		{
			return personalityArrayId;
		}
		public void setPersonalityArrayId(int personalityArrayId)
		{
			this.personalityArrayId = personalityArrayId;
		}
	}
	public static SpinnerElement[] getSpinnerElementValue()
	{
		return SpinnerElement.values();
	}
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		if (savedInstanceState == null)
		{
		    Bundle extras = getIntent().getExtras();
		    if(extras == null)
		    {
		        dbId= 0;
		    }
		    else
		    {
		    	dbId= extras.getInt("dbId");
		    }
		}
		else 
		{
			dbId= (Integer) savedInstanceState.getSerializable("dbId");
		}
		System.out.println("SummonElementalActivity.dbId = "+ dbId);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.summon_elemental_activity);
        final Button calculateSummoning = (Button) findViewById(R.id.calculateSummoning);
        calculateSummoning.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v)
            {
            	savePreferences();
            	summonResultView();
            }
        });
		SQLiteDatabase Database = DB.getReadableDatabase();

		Cursor query = Database.query(false, "Characters", null, "id = '" + dbId + "'", null, null, null, "id ASC", null);
		query.moveToFirst();
		Spinner spinner = (Spinner) findViewById(R.id.spinnerTypeOfElement);
		spinner.setOnItemSelectedListener(this);
		
		CheckBox immunityAgainstMagic = (CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstMagicAttacks);
		immunityAgainstMagic.setOnCheckedChangeListener(this);
		setEditTextString(query, dbField.characterName.getIntValue(), R.id.summonElementalCharacterName);
		Spinner powernode = (Spinner)findViewById(R.id.spinnerPowernode);
		if(query.getInt(dbField.powerlinemagicI.getIntValue()) == 0)
		{
			powernode.setEnabled(false);
			powernode.setClickable(false);
		}
		powernode.setSelection(0);
		//Classes character = Classes.getById(dbField.characterClass.getIntValue());
		Classes character = Classes.getById(query.getInt(dbField.characterClass.getIntValue()));
		System.out.println("dbField.characterClass.getIntValue(): "+dbField.characterClass.getIntValue());
		CheckBox checkboxEquipment1 = (CheckBox)findViewById(R.id.summonElementalCheckBoxEquipment1);
		checkboxEquipment1.setText(getString(character.getFirstEquipmentId()));
		CheckBox checkboxEquipment2 = (CheckBox)findViewById(R.id.summonElementalCheckBoxEquipment2);
		checkboxEquipment2.setText(getString(character.getSecondEquipmentId()));
		
		Database.close();
		
		System.out.println(getFormElementSpinnerPosition(R.id.spinnerChooseQualityOfMaterial));
		Spinner spinnerQualityOfTrueName = (Spinner) findViewById(R.id.spinnerQualityOfTrueName);
		spinnerQualityOfTrueName.setSelection(0);
		Spinner spinnerCircumstancesOfThePlace = (Spinner) findViewById(R.id.spinnerCircumstancesOfThePlace);
		spinnerCircumstancesOfThePlace.setSelection(6);
		Spinner spinnerCircumstancesOfTimeArray = (Spinner) findViewById(R.id.spinnerCircumstancesOfTimeArray);
		spinnerCircumstancesOfTimeArray.setSelection(3);
		Spinner spinnerQualityOfGift = (Spinner) findViewById(R.id.spinnerQualityOfGift);
		spinnerQualityOfGift.setSelection(7);
		Spinner spinnerQualityOfDeed = (Spinner) findViewById(R.id.spinnerQualityOfDeed);
		spinnerQualityOfDeed.setSelection(7);
	}
	private void savePreferences(){
		SQLiteDatabase Database = DB.getReadableDatabase();
		Cursor query = Database.query(false, "Characters", null, "id = '" + dbId + "'", null, null, null, "id ASC", null);
		query.moveToFirst();
		SharedPreferences settings = this.getSharedPreferences("de.dsa_aachen.dsa_elements_summons", MODE_PRIVATE);
		SharedPreferences.Editor editor = settings.edit();
		
		//int spinnerTypeOfElement = settings.getInt("spinnerTypeOfElement", 0);
		int spinnerTypeOfElement = getFormElementSpinnerPosition(R.id.spinnerTypeOfElement);
		SpinnerElement[] spinnerElements = SummonElementalActivity.getSpinnerElementValue();
		//spinnerElements[spinnerTypeOfElement].getStringArrayId();
		editor.putInt("spinnerTypeOfElement", spinnerTypeOfElement);
		editor.putInt("statCourage", query.getInt(dbField.statCourage.getIntValue()));
		editor.putInt("statWisdom", query.getInt(dbField.statWisdom.getIntValue()));
		editor.putInt("statCharisma", query.getInt(dbField.statCharisma.getIntValue()));
		editor.putInt("statIntuition", query.getInt(dbField.statIntuition.getIntValue()));
		editor.putInt("talentCallElementalServant", query.getInt(dbField.talentCallElementalServant.getIntValue()));
		editor.putInt("talentCallDjinn", query.getInt(dbField.talentCallDjinn.getIntValue()));
		editor.putInt("talentCallMasterOfElement", query.getInt(dbField.talentCallMasterOfElement.getIntValue()));

		editor.putBoolean("talentedElement", query.getInt(spinnerElements[spinnerTypeOfElement].getTalentedElementDbField().getIntValue())>0);
		editor.putBoolean("talentedCounterElement", query.getInt(spinnerElements[spinnerElements[spinnerTypeOfElement].getCounterElement()].getTalentedElementDbField().getIntValue())>0);
		editor.putInt("talentedDemonic", query.getInt(dbField.talentedDemonic.getIntValue()));
		editor.putBoolean("knowledgeElement", query.getInt(spinnerElements[spinnerTypeOfElement].getKnowledgeElementDbField().getIntValue())>0);
		editor.putBoolean("knowledgeCounterElement", query.getInt(spinnerElements[spinnerElements[spinnerTypeOfElement].getCounterElement()].getKnowledgeElementDbField().getIntValue())>0);
		editor.putInt("knowledgeDemonic", query.getInt(dbField.knowledgeDemonic.getIntValue()));

		editor.putBoolean("affinityToElementals", query.getInt(dbField.affinityToElementals.getIntValue())>0);

		editor.putBoolean("demonicCovenant", query.getInt(dbField.demonicCovenant.getIntValue())>0);
		editor.putBoolean("cloakedAura", query.getInt(dbField.cloakedAura.getIntValue())>0);
		editor.putInt("weakPresence", query.getInt(dbField.weakPresence.getIntValue()));

		editor.putInt("strengthOfStigma", query.getInt(dbField.strengthOfStigma.getIntValue()));

		int characterEquipmentModifier = 0;
		if(getFormElementBoolean(R.id.summonElementalCheckBoxEquipment1)){
			characterEquipmentModifier = characterEquipmentModifier +1;
		}
		if(getFormElementBoolean(R.id.summonElementalCheckBoxEquipment2)){
			characterEquipmentModifier = characterEquipmentModifier +2;
		}
		editor.putInt("characterEquipmentModifier",characterEquipmentModifier);
		editor.putBoolean("radioElementalServant", ((RadioButton)findViewById(R.id.radioElementalServant)).isChecked());
		editor.putBoolean("radioDjinn", ((RadioButton)findViewById(R.id.radioDjinn)).isChecked());
		editor.putBoolean("radioMasterOfElement", ((RadioButton)findViewById(R.id.radioMasterOfElement)).isChecked());

		editor.putString("qualityOfMaterial", getResources().getStringArray(spinnerElements[spinnerTypeOfElement].getStringArrayId())[getFormElementSpinnerPosition(R.id.spinnerChooseQualityOfMaterial)]);

		editor.putString("qualityOfTrueName", getResources().getStringArray(R.array.str_QualityOfTrueNameArray)[getFormElementSpinnerPosition(R.id.spinnerQualityOfTrueName)]);
		editor.putString("circumstancesOfThePlace", getResources().getStringArray(R.array.str_CircumstancesOfThePlaceArray)[getFormElementSpinnerPosition(R.id.spinnerCircumstancesOfThePlace)]);
		editor.putString("powernode", getResources().getStringArray(R.array.str_PowernodeArray)[getFormElementSpinnerPosition(R.id.spinnerPowernode)]);
		editor.putString("circumstancesOfTime", getResources().getStringArray(R.array.str_CircumstancesOfTimeArray)[getFormElementSpinnerPosition(R.id.spinnerCircumstancesOfTimeArray)]);
		editor.putString("qualityOfGift", getResources().getStringArray(R.array.str_QualityOfGiftArray)[getFormElementSpinnerPosition(R.id.spinnerQualityOfGift)]);
		editor.putString("qualityOfDeed", getResources().getStringArray(R.array.str_QualityOfDeedArray)[getFormElementSpinnerPosition(R.id.spinnerQualityOfDeed)]);
		
		//Add all special abilities & resistance & immunity checkboxes!
		editor.putBoolean("astralSense", ((CheckBox)findViewById(R.id.summonElementalCheckBoxAstralSense)).isChecked());
		editor.putBoolean("longArm", ((CheckBox)findViewById(R.id.summonElementalCheckBoxLongArm)).isChecked());
		editor.putBoolean("lifeSense", ((CheckBox)findViewById(R.id.summonElementalCheckBoxLifeSense)).isChecked());
		editor.putBoolean("resistanceAgainstMagicAttacks", ((CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstMagicAttacks)).isChecked());
		editor.putBoolean("immunityAgainstMagicAttacks", ((CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstMagicAttacks)).isChecked());
		
		//radiogroups
		editor.putBoolean("regenerationOne", ((RadioButton)findViewById(R.id.radioRegenerationOne)).isChecked());
		editor.putBoolean("regenerationTwo", ((RadioButton)findViewById(R.id.radioRegenerationTwo)).isChecked());
		editor.putBoolean("additionalActionsOne", ((RadioButton)findViewById(R.id.radioAdditionalActionsOne)).isChecked());
		editor.putBoolean("additionalActionsTwo", ((RadioButton)findViewById(R.id.radioAdditionalActionsTwo)).isChecked());
		
		editor.putBoolean("resistanceAgainstTraitDamage", ((CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstTraitDamage)).isChecked());
		editor.putBoolean("resistanceAgainstDemonicBlakharaz", ((CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstDemonicBlakharaz)).isChecked());
		editor.putBoolean("resistanceAgainstDemonicBelhalhar", ((CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstDemonicBelhalhar)).isChecked());
		editor.putBoolean("resistanceAgainstDemonicLolgramoth", ((CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstDemonicLolgramoth)).isChecked());
		editor.putBoolean("resistanceAgainstDemonicAmazeroth", ((CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstDemonicAmazeroth)).isChecked());
		editor.putBoolean("resistanceAgainstDemonicAsfaloth", ((CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstDemonicAsfaloth)).isChecked());
		editor.putBoolean("resistanceAgainstDemonicBelzhorash", ((CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstDemonicBelzhorash)).isChecked());
		editor.putBoolean("resistanceAgainstDemonicAgrimoth", ((CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstDemonicAgrimoth)).isChecked());
		editor.putBoolean("resistanceAgainstDemonicThargunitoth", ((CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstDemonicThargunitoth)).isChecked());
		editor.putBoolean(String.valueOf(R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksFire), ((CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksFire)).isChecked());
		editor.putBoolean(String.valueOf(R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksWater), ((CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksWater)).isChecked());
		editor.putBoolean(String.valueOf(R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksLife), ((CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksLife)).isChecked());
		editor.putBoolean(String.valueOf(R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksIce), ((CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksIce)).isChecked());
		editor.putBoolean(String.valueOf(R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksStone), ((CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksStone)).isChecked());
		editor.putBoolean(String.valueOf(R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksAir), ((CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstElementalAttacksAir)).isChecked());
		
		editor.putBoolean("immunityAgainstTraitDamage", ((CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstTraitDamage)).isChecked());
		editor.putBoolean("immunityAgainstDemonicBlakharaz", ((CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstDemonicBlakharaz)).isChecked());
		editor.putBoolean("immunityAgainstDemonicBelhalhar", ((CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstDemonicBelhalhar)).isChecked());
		editor.putBoolean("immunityAgainstDemonicLolgramoth", ((CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstDemonicLolgramoth)).isChecked());
		editor.putBoolean("immunityAgainstDemonicAmazeroth", ((CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstDemonicAmazeroth)).isChecked());
		editor.putBoolean("immunityAgainstDemonicAsfaloth", ((CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstDemonicAsfaloth)).isChecked());
		editor.putBoolean("immunityAgainstDemonicBelzhorash", ((CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstDemonicBelzhorash)).isChecked());
		editor.putBoolean("immunityAgainstDemonicAgrimoth", ((CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstDemonicAgrimoth)).isChecked());
		editor.putBoolean("immunityAgainstDemonicThargunitoth", ((CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstDemonicThargunitoth)).isChecked());
		editor.putBoolean(String.valueOf(R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksFire), ((CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksFire)).isChecked());
		editor.putBoolean(String.valueOf(R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksWater), ((CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksWater)).isChecked());
		editor.putBoolean(String.valueOf(R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksLife), ((CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksLife)).isChecked());
		editor.putBoolean(String.valueOf(R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksIce), ((CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksIce)).isChecked());
		editor.putBoolean(String.valueOf(R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksStone), ((CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksStone)).isChecked());
		editor.putBoolean(String.valueOf(R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksAir), ((CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstElementalAttacksAir)).isChecked());
		

		editor.putBoolean("bloodmagicUsed", ((CheckBox)findViewById(R.id.summonElementalCheckBoxBloodmagicUsed)).isChecked());
		editor.putBoolean("summonedLesserDemon", ((CheckBox)findViewById(R.id.summonElementalCheckBoxSummonedLesserDemon)).isChecked());
		editor.putBoolean("summonedHornedDemon", ((CheckBox)findViewById(R.id.summonElementalCheckBoxSummonedHornedDemon)).isChecked());
		editor.putInt("additionalSummon",getFormElementInt(R.id.summonElementalEditAdditionalSummon));
		editor.putInt("additionalControl",getFormElementInt(R.id.summonElementalEditAdditionalControl));
		String[] personalityStringArray = getResources().getStringArray(spinnerElements[spinnerTypeOfElement].getPersonalityArrayId());
		Random rand = new Random();
		int randomIntInPersonalityArray = rand.nextInt(personalityStringArray.length);
		editor.putString("personality", personalityStringArray[randomIntInPersonalityArray]);
		
		editor.commit();
		Database.close();
	}
	private boolean getFormElementBoolean(int Rid){
		final CheckBox checkBox = (CheckBox) findViewById(Rid);
		return checkBox.isChecked();
	}
	private int getFormElementInt(int Rid){
		String RidTextViewString = getFormElementString(Rid);
		if(RidTextViewString == ""){
        	return(0);
        }else{
            return(Integer.parseInt(RidTextViewString));
        }
	}
	private String getFormElementString(int Rid){
		final TextView RidTextView = (TextView) findViewById(Rid);
		CharSequence sequence = RidTextView.getText();
		if(sequence.length() == 0){
			return("");
		}
        String RidTextViewString = sequence.toString();
        return(RidTextViewString);
	}
	private int getFormElementSpinnerPosition(int Rid){
		final Spinner spinner = (Spinner)findViewById(Rid);
		int position = spinner.getSelectedItemPosition();
		//System.out.println("spinner position = "+ position);
		return position;
	}
	private void summonResultView(){
		this.onStop();
		Intent intent = new Intent();
		intent.setClass(SummonElementalActivity.this,SummoningResultActivity.class);
		intent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP | Intent.FLAG_ACTIVITY_CLEAR_TOP);
		startActivity(intent);
	}
	
	private void setCheckBox(Cursor cursor, int columnId, int Rid){
	    boolean bool = cursor.getInt(columnId)>0;
	    final CheckBox checkBox = (CheckBox) findViewById(Rid);
	    checkBox.setChecked(bool);
	}
	private void setEditTextInt(Cursor cursor, int columnId, int Rid){
		int Int = cursor.getInt(columnId);
	    final TextView textView = (TextView) findViewById(Rid);
	    textView.setText(String.valueOf(Int));
	}
	private void setEditSpinnerPositionInt(Cursor cursor, int columnId,int Rid){
		int Int = cursor.getInt(columnId);
		final Spinner spinner = (Spinner)findViewById(Rid);
		spinner.setSelection(Int);
	}
	private void setEditTextString(Cursor cursor, int columnId, int Rid){
		String string = cursor.getString(columnId);
	    final TextView textView = (TextView) findViewById(Rid);
	    textView.setText(string);
	}
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is 
		//present.
		getMenuInflater().inflate(R.menu.summon_elemental_activity, menu);
		return true;
	}

	@Override
	public void onItemSelected(AdapterView<?> arg0, View view, int position,
			long rId) {

		View spinnerTypeOfElement = 
				findViewById(R.id.spinnerTypeOfElement);
		if(arg0 == spinnerTypeOfElement){
			
			View linearLayoutElementSpinners = 
					findViewById(R.id.LinearLayoutElementSpinners);
			int oldSpinnerPosition = 0;
			try{
				View oldSpinner = linearLayoutElementSpinners.findViewById(R.id.spinnerChooseQualityOfMaterial);
				oldSpinnerPosition = getFormElementSpinnerPosition(R.id.spinnerChooseQualityOfMaterial);
				((LinearLayout)oldSpinner.getParent()).removeView(oldSpinner);
			}catch(NullPointerException e){
				System.out.println("Catched the god damn nullpointer!");
			}
			
			LinearLayout layoutSummonElementalActivity = 
					(LinearLayout) linearLayoutElementSpinners;
			//layoutSummonElementalActivity.removeView(spinnerBla);
			Spinner spinner = new Spinner(this);
			LinearLayout.LayoutParams editParams = 
					new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT,
						LayoutParams.WRAP_CONTENT);
			spinner.setLayoutParams(editParams);
			//spinner.setTag(R.id.spinnerChooseQualityOfMaterial);
			spinner.setId(R.id.spinnerChooseQualityOfMaterial);
			layoutSummonElementalActivity.addView(spinner);
			// Create an ArrayAdapter using the string array and a default spinner layout
			ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this,
			        SpinnerElement.values()[(int)rId].getStringArrayId(), 
			        android.R.layout.simple_spinner_item);
			// Specify the layout to use when the list of choices appears
			adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
			// Apply the adapter to the spinner
			spinner.setAdapter(adapter);
			if(firstStart == true){
				spinner.setSelection(3);
				firstStart = false;
			}else{
				spinner.setSelection(oldSpinnerPosition);
			}
			System.out.println("view.getId() == R.id.spinnerTypeOfElement");
			
			for (SpinnerElement spinnerElement : SpinnerElement.values()) {
				CheckBox resistanceCheckbox = (CheckBox)findViewById(spinnerElement.getResistanceCheckboxId());
				resistanceCheckbox.setChecked(false);
				resistanceCheckbox.setEnabled(true);
				CheckBox immunityCheckbox = (CheckBox)findViewById(spinnerElement.getImmunityCheckboxId());
				immunityCheckbox.setChecked(false);
				immunityCheckbox.setEnabled(true);
			}
			
			CheckBox resistanceCheckbox = (CheckBox)findViewById(SpinnerElement.values()[(int)rId].getResistanceCheckboxId());
			resistanceCheckbox.setEnabled(false);
			CheckBox immunityCheckbox = (CheckBox)findViewById(SpinnerElement.values()[(int)rId].getImmunityCheckboxId());
			immunityCheckbox.setChecked(true);
			immunityCheckbox.setEnabled(false);

			int counterElement = SpinnerElement.values()[(int)rId].getCounterElement();
			System.out.println("counterElement= "+counterElement);
			CheckBox counterResistanceCheckbox = (CheckBox)findViewById(SpinnerElement.values()[counterElement].getResistanceCheckboxId());
			counterResistanceCheckbox.setEnabled(false);
			CheckBox counterImmunityCheckbox = (CheckBox)findViewById(SpinnerElement.values()[counterElement].getImmunityCheckboxId());
			counterImmunityCheckbox.setEnabled(false);
			
		}
	}
	@Override
	public void onCheckedChanged(CompoundButton buttonView,boolean isChecked) {
		CheckBox resistanceTraitDamage = (CheckBox)findViewById(R.id.summonElementalCheckBoxResistanceAgainstTraitDamage);
		CheckBox immunityTraitDamage = (CheckBox)findViewById(R.id.summonElementalCheckBoxImmunityAgainstTraitDamage);
		if(isChecked == true){
			lastResistanceAgainstTraitDamage = resistanceTraitDamage.isChecked();
			resistanceTraitDamage.setChecked(false);
			resistanceTraitDamage.setEnabled(false);
			lastImmunityAgainstTraitDamage = immunityTraitDamage.isChecked();
			immunityTraitDamage.setChecked(false);
			immunityTraitDamage.setEnabled(false);
		}else{
			resistanceTraitDamage.setChecked(lastResistanceAgainstTraitDamage);
			resistanceTraitDamage.setEnabled(true);
			immunityTraitDamage.setChecked(lastImmunityAgainstTraitDamage);
			immunityTraitDamage.setEnabled(true);
		}
		
	} 
	@Override
	public void onNothingSelected(AdapterView<?> arg0){}

}
