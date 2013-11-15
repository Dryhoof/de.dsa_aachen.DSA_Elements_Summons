package de.dsa_aachen.dsa_elements_summons;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
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
        	setIntValue(value);
        	stringValue = stringV;
        }
		public int getIntValue() {
			return intValue;
		}
		public void setIntValue(int intValue) {
			this.intValue = intValue;
		}
	}

	int dbId;
	DSA_Summons_Elements_Database DB = new DSA_Summons_Elements_Database(this);
   // public static final String PREFS_NAME = "DSA_Summons_Prefs";
	protected void onCreate(Bundle savedInstanceState) {
		if (savedInstanceState == null) {
		    Bundle extras = getIntent().getExtras();
		    if(extras == null) {
		        dbId= 0;
		    } else {
		    	dbId= extras.getInt("dbId");
		    }
		} else {
			dbId= (Integer) savedInstanceState.getSerializable("dbId");
		}
		System.out.println("EditCharActivity.dbId = "+ dbId);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.edit_char_activity);
		
        final Button saveChar = (Button) findViewById(R.id.saveNewChar);
        saveChar.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	saveChar();
            	mainView();
            }
        });
		
		SQLiteDatabase Database = DB.getReadableDatabase();
		Cursor query = Database.query(false, "Characters", null, "id = '" + dbId + "'", null, null, null, "id ASC", null);
		if(query.getCount() > 0){
			//query.moveToFirst();
			query.moveToFirst();

			setEditTextString(query, dbField.characterName.getIntValue(), R.id.editCharEditCharacterName);
			setEditTextInt(query, dbField.statCourage.getIntValue(), R.id.editCharEditStatCourage);
			setEditTextInt(query, dbField.statWisdom.getIntValue(), R.id.editCharEditStatWisdom);
			setEditTextInt(query, dbField.statCharisma.getIntValue(), R.id.editCharEditStatCharisma);
			setEditTextInt(query, dbField.statIntuition.getIntValue(), R.id.editCharEditStatIntuition);
			setEditTextInt(query, dbField.talentCallElementalServant.getIntValue(), R.id.editCharEditTalentCallElementalServant);
			setEditTextInt(query, dbField.talentCallDjinn.getIntValue(), R.id.editCharEditTalentCallDjinn);
			setEditTextInt(query, dbField.talentCallMasterOfElement.getIntValue(), R.id.editCharEditTalentCallMasterOfElement);
			setCheckBox(query, dbField.talentedFire.getIntValue(), R.id.editCharCheckBoxTalentedFire);
			setCheckBox(query, dbField.talentedWater.getIntValue(), R.id.editCharCheckBoxTalentedWater);
			setCheckBox(query, dbField.talentedLife.getIntValue(), R.id.editCharCheckBoxTalentedLife);
			setCheckBox(query, dbField.talentedIce.getIntValue(), R.id.editCharCheckBoxTalentedIce);
			setCheckBox(query, dbField.talentedStone.getIntValue(), R.id.editCharCheckBoxTalentedStone);
			setCheckBox(query, dbField.talentedAir.getIntValue(), R.id.editCharCheckBoxTalentedAir);
			setEditTextInt(query, dbField.talentedDemonic.getIntValue(), R.id.editCharEditTalentedDemonic);
			setCheckBox(query, dbField.knowledgeFire.getIntValue(), R.id.editCharCheckBoxKnowledgeFire);
			setCheckBox(query, dbField.knowledgeWater.getIntValue(), R.id.editCharCheckBoxKnowledgeWater);
			setCheckBox(query, dbField.knowledgeLife.getIntValue(), R.id.editCharCheckBoxKnowledgeLife);
			setCheckBox(query, dbField.knowledgeIce.getIntValue(), R.id.editCharCheckBoxKnowledgeIce);
			setCheckBox(query, dbField.knowledgeStone.getIntValue(), R.id.editCharCheckBoxKnowledgeStone);
			setCheckBox(query, dbField.knowledgeAir.getIntValue(), R.id.editCharCheckBoxKnowledgeAir);
			setEditTextInt(query, dbField.knowledgeDemonic.getIntValue(), R.id.editCharEditKnowledgeDemonic);
			setCheckBox(query, dbField.affinityToElementals.getIntValue(), R.id.editCharCheckBoxAffinityToElementals);
			setCheckBox(query, dbField.demonicCovenant.getIntValue(), R.id.editCharCheckBoxDemonicCovenant);
			setCheckBox(query, dbField.cloakedAura.getIntValue(), R.id.editCharCheckBoxCloakedAura);
			setEditTextInt(query, dbField.weakPresence.getIntValue(), R.id.editCharEditWeakPresence);
			setEditTextInt(query, dbField.strengthOfStigma.getIntValue(), R.id.editCharEditStrengthOfStigma);
			
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
		System.out.println("EditCharActivity is beeing destroyed!");
		saveChar();
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
	private void saveChar(){
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
		Database.update("Characters", values, "id = '1'", null);
		Database.close();
	}
	private void mainView(){
		this.onStop();
		Intent intent = new Intent();
		intent.setClass(EditCharActivity.this,MainActivity.class);
		intent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP | Intent.FLAG_ACTIVITY_CLEAR_TOP);
		startActivity(intent);
	}
}
