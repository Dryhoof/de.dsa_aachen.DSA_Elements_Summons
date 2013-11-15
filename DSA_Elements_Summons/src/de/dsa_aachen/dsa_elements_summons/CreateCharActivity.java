package de.dsa_aachen.dsa_elements_summons;

import android.app.Activity;
import android.content.ContentValues;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.view.Menu;
import android.widget.CheckBox;
import android.widget.TextView;

public class CreateCharActivity extends Activity {
	public enum dbField {
		id("id",0),
        characterName("characterName",1),
        statCourage("statCourage",2),
        statWisdom("statWisdom",3),
        statCharisma("statCharisma",4),
        statIntuition("statIntuition",5),
        talentCallElementalServant("talentCallElementalServant",6),
        talentCallDjinn("talentCallDjinn",7),
        talentCallMasterOfElement("talentCallMasterOfElement",8),
        talentedFire("talentedFire",9),
        talentedWater("talentedWater",10),
        talentedLife("talentedLife",11),
        talentedIce("talentedIce",12),
        talentedStone("talentedStone",13),
        talentedAir("talentedAir",14),
        talentedDemonic("talentedDemonic",15),
        knowledgeFire("knowledgeFire",16),
        knowledgeWater("knowledgeWater",17),
        knowledgeLife("knowledgeLife",18),
        knowledgeIce("knowledgeIce",19),
        knowledgeStone("knowledgeStone",20),
        knowledgeAir("knowledgeAir",21),
        knowledgeDemonic("knowledgeDemonic",22),
        affinityToElementals("affinityToElementals",23),
        demonicCovenant("demonicCovenant",24),
        cloakedAura("cloakedAura",25),
        weakPresence("weakPresence",26),
        strengthOfStigma("strengthOfStigma",27);
		
		private String stringValue;
	    //private int intValue;
        private dbField(String stringV, int value) {
        	//intValue = value;
        	stringValue = stringV;
        }
	}
	DSA_Summons_Elements_Database DB = new DSA_Summons_Elements_Database(this);
    public static final String PREFS_NAME = "DSA_Summons_Prefs";
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.create_char_activity);
		/*
		SQLiteDatabase Database = DB.getReadableDatabase();
		Cursor query = Database.query(false, "Characters", null, null, null, null, null, "id ASC", null);
		if(query.getCount() != 0){
			query.moveToFirst();

			setEditTextString(query, dbField.characterName.intValue, R.id.createCharEditCharacterName);
			setEditTextInt(query, dbField.statCourage.intValue, R.id.createCharEditStatCourage);
			setEditTextInt(query, dbField.statWisdom.intValue, R.id.createCharEditStatWisdom);
			setEditTextInt(query, dbField.statCharisma.intValue, R.id.createCharEditStatCharisma);
			setEditTextInt(query, dbField.statIntuition.intValue, R.id.createCharEditStatIntuition);
			setEditTextInt(query, dbField.talentCallElementalServant.intValue, R.id.createCharEditTalentCallElementalServant);
			setEditTextInt(query, dbField.talentCallDjinn.intValue, R.id.createCharEditTalentCallDjinn);
			setEditTextInt(query, dbField.talentCallMasterOfElement.intValue, R.id.createCharEditTalentCallMasterOfElement);
			setCheckBox(query, dbField.talentedFire.intValue, R.id.createCharCheckBoxTalentedFire);
			setCheckBox(query, dbField.talentedWater.intValue, R.id.createCharCheckBoxTalentedWater);
			setCheckBox(query, dbField.talentedLife.intValue, R.id.createCharCheckBoxTalentedLife);
			setCheckBox(query, dbField.talentedIce.intValue, R.id.createCharCheckBoxTalentedIce);
			setCheckBox(query, dbField.talentedStone.intValue, R.id.createCharCheckBoxTalentedStone);
			setCheckBox(query, dbField.talentedAir.intValue, R.id.createCharCheckBoxTalentedAir);
			setEditTextInt(query, dbField.talentedDemonic.intValue, R.id.createCharEditTalentedDemonic);
			setCheckBox(query, dbField.knowledgeFire.intValue, R.id.createCharCheckBoxKnowledgeFire);
			setCheckBox(query, dbField.knowledgeWater.intValue, R.id.createCharCheckBoxKnowledgeWater);
			setCheckBox(query, dbField.knowledgeLife.intValue, R.id.createCharCheckBoxKnowledgeLife);
			setCheckBox(query, dbField.knowledgeIce.intValue, R.id.createCharCheckBoxKnowledgeIce);
			setCheckBox(query, dbField.knowledgeStone.intValue, R.id.createCharCheckBoxKnowledgeStone);
			setCheckBox(query, dbField.knowledgeAir.intValue, R.id.createCharCheckBoxKnowledgeAir);
			setEditTextInt(query, dbField.knowledgeDemonic.intValue, R.id.createCharEditKnowledgeDemonic);
			setCheckBox(query, dbField.affinityToElementals.intValue, R.id.createCharCheckBoxAffinityToElementals);
			setCheckBox(query, dbField.demonicCovenant.intValue, R.id.createCharCheckBoxDemonicCovenant);
			setCheckBox(query, dbField.cloakedAura.intValue, R.id.createCharCheckBoxCloakedAura);
			setEditTextInt(query, dbField.weakPresence.intValue, R.id.createCharEditWeakPresence);
			setEditTextInt(query, dbField.strengthOfStigma.intValue, R.id.createCharEditStrengthOfStigma);
			
			String characterName = query.getString(dbField.characterName.intValue);
		    final TextView createCharEditCharacterName = (TextView) findViewById(R.id.createCharEditCharacterName);
		    createCharEditCharacterName.setText(characterName);
		    
			int statCourage = query.getInt(dbField.statCourage.intValue);
		    final TextView createCharEditStatCourage = (TextView) findViewById(R.id.createCharEditStatCourage);
		    createCharEditStatCourage.setText(String.valueOf(statCourage));

		    boolean talentedFire = query.getInt(dbField.talentedFire.intValue)>0;
		    final CheckBox createCharCheckBoxTalentedFire = (CheckBox) findViewById(R.id.createCharCheckBoxTalentedFire);
		    createCharCheckBoxTalentedFire.setChecked(talentedFire);
		}
		Database.close();
		*/
	}
	
	protected void onStop(){
		super.onStop();

		// We need an Editor object to make preference changes.
		// All objects are from android.context.Context
        //SQLiteDatabase DatabaseRead = DB.getReadableDatabase();
		//Cursor query = DatabaseRead.query(false, "Characters", null, null, null, null, null, "id ASC", null);
		//int queryCount = query.getCount();
		//DatabaseRead.close();
		
        SQLiteDatabase Database = DB.getWritableDatabase();
        ContentValues values = new ContentValues();
        
		//values.put(dbField.id.stringValue,1);
		values.put(dbField.characterName.stringValue,getFormElementString(R.id.createCharEditCharacterName));
		values.put(dbField.statCourage.stringValue,getFormElementInt(R.id.createCharEditStatCourage));
		values.put(dbField.statWisdom.stringValue,getFormElementInt(R.id.createCharEditStatWisdom));
		values.put(dbField.statCharisma.stringValue,getFormElementInt(R.id.createCharEditStatCharisma));
		values.put(dbField.statIntuition.stringValue,getFormElementInt(R.id.createCharEditStatIntuition));
		values.put(dbField.talentCallElementalServant.stringValue,getFormElementInt(R.id.createCharEditTalentCallElementalServant));
		values.put(dbField.talentCallDjinn.stringValue,getFormElementInt(R.id.createCharEditTalentCallDjinn));
		values.put(dbField.talentCallMasterOfElement.stringValue,getFormElementInt(R.id.createCharEditTalentCallMasterOfElement));
		values.put(dbField.talentedFire.stringValue,getFormElementBoolean(R.id.createCharCheckBoxTalentedFire));
		values.put(dbField.talentedWater.stringValue,getFormElementBoolean(R.id.createCharCheckBoxTalentedWater));
		values.put(dbField.talentedLife.stringValue,getFormElementBoolean(R.id.createCharCheckBoxTalentedLife));
		values.put(dbField.talentedIce.stringValue,getFormElementBoolean(R.id.createCharCheckBoxTalentedIce));
		values.put(dbField.talentedStone.stringValue,getFormElementBoolean(R.id.createCharCheckBoxTalentedStone));
		values.put(dbField.talentedAir.stringValue,getFormElementBoolean(R.id.createCharCheckBoxTalentedAir));
		values.put(dbField.talentedDemonic.stringValue,getFormElementInt(R.id.createCharEditTalentedDemonic));
		values.put(dbField.knowledgeFire.stringValue,getFormElementBoolean(R.id.createCharCheckBoxKnowledgeFire));
		values.put(dbField.knowledgeWater.stringValue,getFormElementBoolean(R.id.createCharCheckBoxKnowledgeWater));
		values.put(dbField.knowledgeLife.stringValue,getFormElementBoolean(R.id.createCharCheckBoxKnowledgeLife));
		values.put(dbField.knowledgeIce.stringValue,getFormElementBoolean(R.id.createCharCheckBoxKnowledgeIce));
		values.put(dbField.knowledgeStone.stringValue,getFormElementBoolean(R.id.createCharCheckBoxKnowledgeStone));
		values.put(dbField.knowledgeAir.stringValue,getFormElementBoolean(R.id.createCharCheckBoxKnowledgeAir));
		values.put(dbField.knowledgeDemonic.stringValue,getFormElementInt(R.id.createCharEditKnowledgeDemonic));
		values.put(dbField.affinityToElementals.stringValue,getFormElementBoolean(R.id.createCharCheckBoxAffinityToElementals));
		values.put(dbField.demonicCovenant.stringValue,getFormElementBoolean(R.id.createCharCheckBoxDemonicCovenant));
		values.put(dbField.cloakedAura.stringValue,getFormElementBoolean(R.id.createCharCheckBoxCloakedAura));
		values.put(dbField.weakPresence.stringValue,getFormElementInt(R.id.createCharEditWeakPresence));
		values.put(dbField.strengthOfStigma.stringValue,getFormElementInt(R.id.createCharEditStrengthOfStigma));

        Database.insert("Characters", "id", values);
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
	}/*
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
	private void setEditTextString(Cursor cursor, int columnId, int Rid){
		String string = cursor.getString(columnId);
	    final TextView textView = (TextView) findViewById(Rid);
	    textView.setText(string);
	}*/
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.create_char_activity, menu);
		return true;
	}
}
