package de.dsa_aachen.dsa_elements_summons;

import android.app.Activity;
import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.view.Menu;
import android.widget.CheckBox;
import android.widget.TextView;

public class EditCharActivity extends Activity {
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
	    private int intValue;
        private dbField(String stringV, int value) {
        	intValue = value;
        	stringValue = stringV;
        }
	}

	int dbId;
	DSA_Summons_Elements_Database DB = new DSA_Summons_Elements_Database(this);
    public static final String PREFS_NAME = "DSA_Summons_Prefs";
	protected void onCreate(Bundle savedInstanceState) {
		if (savedInstanceState == null) {
		    Bundle extras = getIntent().getExtras();
		    if(extras == null) {
		        dbId= 0;
		    } else {
		    	dbId= extras.getInt("STRING_I_NEED");
		    }
		} else {
			dbId= (Integer) savedInstanceState.getSerializable("STRING_I_NEED");
		}
		super.onCreate(savedInstanceState);
		setContentView(R.layout.edit_char_activity);
		
		SQLiteDatabase Database = DB.getReadableDatabase();
		Cursor query = Database.query(false, "Characters", null, null, null, null, null, "id ASC", null);
		if(query.getCount() < dbId){
			//query.moveToFirst();
			query.moveToPosition(dbId-1);

			setEditTextString(query, dbField.characterName.intValue, R.id.editCharEditCharacterName);
			setEditTextInt(query, dbField.statCourage.intValue, R.id.editCharEditStatCourage);
			setEditTextInt(query, dbField.statWisdom.intValue, R.id.editCharEditStatWisdom);
			setEditTextInt(query, dbField.statCharisma.intValue, R.id.editCharEditStatCharisma);
			setEditTextInt(query, dbField.statIntuition.intValue, R.id.editCharEditStatIntuition);
			setEditTextInt(query, dbField.talentCallElementalServant.intValue, R.id.editCharEditTalentCallElementalServant);
			setEditTextInt(query, dbField.talentCallDjinn.intValue, R.id.editCharEditTalentCallDjinn);
			setEditTextInt(query, dbField.talentCallMasterOfElement.intValue, R.id.editCharEditTalentCallMasterOfElement);
			setCheckBox(query, dbField.talentedFire.intValue, R.id.editCharCheckBoxTalentedFire);
			setCheckBox(query, dbField.talentedWater.intValue, R.id.editCharCheckBoxTalentedWater);
			setCheckBox(query, dbField.talentedLife.intValue, R.id.editCharCheckBoxTalentedLife);
			setCheckBox(query, dbField.talentedIce.intValue, R.id.editCharCheckBoxTalentedIce);
			setCheckBox(query, dbField.talentedStone.intValue, R.id.editCharCheckBoxTalentedStone);
			setCheckBox(query, dbField.talentedAir.intValue, R.id.editCharCheckBoxTalentedAir);
			setEditTextInt(query, dbField.talentedDemonic.intValue, R.id.editCharEditTalentedDemonic);
			setCheckBox(query, dbField.knowledgeFire.intValue, R.id.editCharCheckBoxKnowledgeFire);
			setCheckBox(query, dbField.knowledgeWater.intValue, R.id.editCharCheckBoxKnowledgeWater);
			setCheckBox(query, dbField.knowledgeLife.intValue, R.id.editCharCheckBoxKnowledgeLife);
			setCheckBox(query, dbField.knowledgeIce.intValue, R.id.editCharCheckBoxKnowledgeIce);
			setCheckBox(query, dbField.knowledgeStone.intValue, R.id.editCharCheckBoxKnowledgeStone);
			setCheckBox(query, dbField.knowledgeAir.intValue, R.id.editCharCheckBoxKnowledgeAir);
			setEditTextInt(query, dbField.knowledgeDemonic.intValue, R.id.editCharEditKnowledgeDemonic);
			setCheckBox(query, dbField.affinityToElementals.intValue, R.id.editCharCheckBoxAffinityToElementals);
			setCheckBox(query, dbField.demonicCovenant.intValue, R.id.editCharCheckBoxDemonicCovenant);
			setCheckBox(query, dbField.cloakedAura.intValue, R.id.editCharCheckBoxCloakedAura);
			setEditTextInt(query, dbField.weakPresence.intValue, R.id.editCharEditWeakPresence);
			setEditTextInt(query, dbField.strengthOfStigma.intValue, R.id.editCharEditStrengthOfStigma);
			
			/*String characterName = query.getString(dbField.characterName.intValue);
		    final TextView editCharEditCharacterName = (TextView) findViewById(R.id.editCharEditCharacterName);
		    editCharEditCharacterName.setText(characterName);
		    
			int statCourage = query.getInt(dbField.statCourage.intValue);
		    final TextView editCharEditStatCourage = (TextView) findViewById(R.id.editCharEditStatCourage);
		    editCharEditStatCourage.setText(String.valueOf(statCourage));

		    boolean talentedFire = query.getInt(dbField.talentedFire.intValue)>0;
		    final CheckBox editCharCheckBoxTalentedFire = (CheckBox) findViewById(R.id.editCharCheckBoxTalentedFire);
		    editCharCheckBoxTalentedFire.setChecked(talentedFire);*/
		}
		Database.close();
	}
	
	protected void onStop(){
		super.onStop();

		// We need an Editor object to make preference changes.
		// All objects are from android.context.Context
        SQLiteDatabase DatabaseRead = DB.getReadableDatabase();
		Cursor query = DatabaseRead.query(false, "Characters", null, null, null, null, null, "id ASC", null);
		int queryCount = query.getCount();
		DatabaseRead.close();
		
        SQLiteDatabase Database = DB.getWritableDatabase();
        ContentValues values = new ContentValues();
        
		values.put(dbField.id.stringValue,dbId);
		values.put(dbField.characterName.stringValue,getFormElementString(R.id.editCharEditCharacterName));
		values.put(dbField.statCourage.stringValue,getFormElementInt(R.id.editCharEditStatCourage));
		values.put(dbField.statWisdom.stringValue,getFormElementInt(R.id.editCharEditStatWisdom));
		values.put(dbField.statCharisma.stringValue,getFormElementInt(R.id.editCharEditStatCharisma));
		values.put(dbField.statIntuition.stringValue,getFormElementInt(R.id.editCharEditStatIntuition));
		values.put(dbField.talentCallElementalServant.stringValue,getFormElementInt(R.id.editCharEditTalentCallElementalServant));
		values.put(dbField.talentCallDjinn.stringValue,getFormElementInt(R.id.editCharEditTalentCallDjinn));
		values.put(dbField.talentCallMasterOfElement.stringValue,getFormElementInt(R.id.editCharEditTalentCallMasterOfElement));
		values.put(dbField.talentedFire.stringValue,getFormElementBoolean(R.id.editCharCheckBoxTalentedFire));
		values.put(dbField.talentedWater.stringValue,getFormElementBoolean(R.id.editCharCheckBoxTalentedWater));
		values.put(dbField.talentedLife.stringValue,getFormElementBoolean(R.id.editCharCheckBoxTalentedLife));
		values.put(dbField.talentedIce.stringValue,getFormElementBoolean(R.id.editCharCheckBoxTalentedIce));
		values.put(dbField.talentedStone.stringValue,getFormElementBoolean(R.id.editCharCheckBoxTalentedStone));
		values.put(dbField.talentedAir.stringValue,getFormElementBoolean(R.id.editCharCheckBoxTalentedAir));
		values.put(dbField.talentedDemonic.stringValue,getFormElementInt(R.id.editCharEditTalentedDemonic));
		values.put(dbField.knowledgeFire.stringValue,getFormElementBoolean(R.id.editCharCheckBoxKnowledgeFire));
		values.put(dbField.knowledgeWater.stringValue,getFormElementBoolean(R.id.editCharCheckBoxKnowledgeWater));
		values.put(dbField.knowledgeLife.stringValue,getFormElementBoolean(R.id.editCharCheckBoxKnowledgeLife));
		values.put(dbField.knowledgeIce.stringValue,getFormElementBoolean(R.id.editCharCheckBoxKnowledgeIce));
		values.put(dbField.knowledgeStone.stringValue,getFormElementBoolean(R.id.editCharCheckBoxKnowledgeStone));
		values.put(dbField.knowledgeAir.stringValue,getFormElementBoolean(R.id.editCharCheckBoxKnowledgeAir));
		values.put(dbField.knowledgeDemonic.stringValue,getFormElementInt(R.id.editCharEditKnowledgeDemonic));
		values.put(dbField.affinityToElementals.stringValue,getFormElementBoolean(R.id.editCharCheckBoxAffinityToElementals));
		values.put(dbField.demonicCovenant.stringValue,getFormElementBoolean(R.id.editCharCheckBoxDemonicCovenant));
		values.put(dbField.cloakedAura.stringValue,getFormElementBoolean(R.id.editCharCheckBoxCloakedAura));
		values.put(dbField.weakPresence.stringValue,getFormElementInt(R.id.editCharEditWeakPresence));
		values.put(dbField.strengthOfStigma.stringValue,getFormElementInt(R.id.editCharEditStrengthOfStigma));
		
		if(queryCount == 1){
			Database.update("Characters", values, "id = '1'", null);
		}else{
        	Database.insert("Characters", "id", values);
		}
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
	}
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.edit_char_activity, menu);
		return true;
	}
}
