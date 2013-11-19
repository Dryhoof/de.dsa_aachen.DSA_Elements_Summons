package de.dsa_aachen.dsa_elements_summons;

import de.dsa_aachen.dsa_elements_summons.DSA_Summons_Elements_Database.dbField;
import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.TextView;

public class CreateCharActivity extends Activity {
	boolean someThingToWrite = false;
	DSA_Summons_Elements_Database DB = new DSA_Summons_Elements_Database(this);
    public static final String PREFS_NAME = "DSA_Summons_Prefs";
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.create_char_activity);
        final Button saveChar = (Button) findViewById(R.id.saveNewChar);
        saveChar.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	saveChar();
            	mainView();
            }
        });

	}
	
	protected void onStop(){
		super.onStop();

	}
	private void saveChar(){

		// We need an Editor object to make preference changes.
		// All objects are from android.context.Context
        //SQLiteDatabase DatabaseRead = DB.getReadableDatabase();
		//Cursor query = DatabaseRead.query(false, "Characters", null, null, null, null, null, "id ASC", null);
		//int queryCount = query.getCount();
		//DatabaseRead.close();
		
        SQLiteDatabase Database = DB.getWritableDatabase();
        ContentValues values = new ContentValues();
        
		//values.put(dbField.id.stringValue,1);
		values.put(dbField.characterName.getStringValue(),getFormElementString(R.id.createCharEditCharacterName));
		values.put(dbField.statCourage.getStringValue(),getFormElementInt(R.id.createCharEditStatCourage));
		values.put(dbField.statWisdom.getStringValue(),getFormElementInt(R.id.createCharEditStatWisdom));
		values.put(dbField.statCharisma.getStringValue(),getFormElementInt(R.id.createCharEditStatCharisma));
		values.put(dbField.statIntuition.getStringValue(),getFormElementInt(R.id.createCharEditStatIntuition));
		values.put(dbField.talentCallElementalServant.getStringValue(),getFormElementInt(R.id.createCharEditTalentCallElementalServant));
		values.put(dbField.talentCallDjinn.getStringValue(),getFormElementInt(R.id.createCharEditTalentCallDjinn));
		values.put(dbField.talentCallMasterOfElement.getStringValue(),getFormElementInt(R.id.createCharEditTalentCallMasterOfElement));
		values.put(dbField.talentedFire.getStringValue(),getFormElementBoolean(R.id.createCharCheckBoxTalentedFire));
		values.put(dbField.talentedWater.getStringValue(),getFormElementBoolean(R.id.createCharCheckBoxTalentedWater));
		values.put(dbField.talentedLife.getStringValue(),getFormElementBoolean(R.id.createCharCheckBoxTalentedLife));
		values.put(dbField.talentedIce.getStringValue(),getFormElementBoolean(R.id.createCharCheckBoxTalentedIce));
		values.put(dbField.talentedStone.getStringValue(),getFormElementBoolean(R.id.createCharCheckBoxTalentedStone));
		values.put(dbField.talentedAir.getStringValue(),getFormElementBoolean(R.id.createCharCheckBoxTalentedAir));
		values.put(dbField.talentedDemonic.getStringValue(),getFormElementInt(R.id.createCharEditTalentedDemonic));
		values.put(dbField.knowledgeFire.getStringValue(),getFormElementBoolean(R.id.createCharCheckBoxKnowledgeFire));
		values.put(dbField.knowledgeWater.getStringValue(),getFormElementBoolean(R.id.createCharCheckBoxKnowledgeWater));
		values.put(dbField.knowledgeLife.getStringValue(),getFormElementBoolean(R.id.createCharCheckBoxKnowledgeLife));
		values.put(dbField.knowledgeIce.getStringValue(),getFormElementBoolean(R.id.createCharCheckBoxKnowledgeIce));
		values.put(dbField.knowledgeStone.getStringValue(),getFormElementBoolean(R.id.createCharCheckBoxKnowledgeStone));
		values.put(dbField.knowledgeAir.getStringValue(),getFormElementBoolean(R.id.createCharCheckBoxKnowledgeAir));
		values.put(dbField.knowledgeDemonic.getStringValue(),getFormElementInt(R.id.createCharEditKnowledgeDemonic));
		values.put(dbField.affinityToElementals.getStringValue(),getFormElementBoolean(R.id.createCharCheckBoxAffinityToElementals));
		values.put(dbField.demonicCovenant.getStringValue(),getFormElementBoolean(R.id.createCharCheckBoxDemonicCovenant));
		values.put(dbField.cloakedAura.getStringValue(),getFormElementBoolean(R.id.createCharCheckBoxCloakedAura));
		values.put(dbField.weakPresence.getStringValue(),getFormElementInt(R.id.createCharEditWeakPresence));
		values.put(dbField.strengthOfStigma.getStringValue(),getFormElementInt(R.id.createCharEditStrengthOfStigma));
		if(someThingToWrite == true){
	        Database.insert("Characters", "id", values);
		}
		Database.close();
	}

	private void mainView(){
		this.onStop();
		Intent intent = new Intent();
		intent.setClass(CreateCharActivity.this,MainActivity.class);
		intent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP | Intent.FLAG_ACTIVITY_CLEAR_TOP);
		startActivity(intent);
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
        	someThingToWrite = true;
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
    	someThingToWrite = true;
        return(RidTextViewString);
	}
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.create_char_activity, menu);
		return true;
	}
}
