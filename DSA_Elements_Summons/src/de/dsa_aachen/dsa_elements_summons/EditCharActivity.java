package de.dsa_aachen.dsa_elements_summons;

import de.dsa_aachen.dsa_elements_summons.DSA_Summons_Elements_Database.dbField;
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
		
        final Button saveChar = (Button) findViewById(R.id.saveChar);
        saveChar.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	saveChar();
            	mainView();
            }
        });
        final Button deleteChar = (Button) findViewById(R.id.deleteChar);
        deleteChar.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	deleteChar();
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
        
		values.put(dbField.id.getStringValue(),dbId);
		values.put(dbField.characterName.getStringValue(),getFormElementString(R.id.editCharEditCharacterName));
		values.put(dbField.statCourage.getStringValue(),getFormElementInt(R.id.editCharEditStatCourage));
		values.put(dbField.statWisdom.getStringValue(),getFormElementInt(R.id.editCharEditStatWisdom));
		values.put(dbField.statCharisma.getStringValue(),getFormElementInt(R.id.editCharEditStatCharisma));
		values.put(dbField.statIntuition.getStringValue(),getFormElementInt(R.id.editCharEditStatIntuition));
		values.put(dbField.talentCallElementalServant.getStringValue(),getFormElementInt(R.id.editCharEditTalentCallElementalServant));
		values.put(dbField.talentCallDjinn.getStringValue(),getFormElementInt(R.id.editCharEditTalentCallDjinn));
		values.put(dbField.talentCallMasterOfElement.getStringValue(),getFormElementInt(R.id.editCharEditTalentCallMasterOfElement));
		values.put(dbField.talentedFire.getStringValue(),getFormElementBoolean(R.id.editCharCheckBoxTalentedFire));
		values.put(dbField.talentedWater.getStringValue(),getFormElementBoolean(R.id.editCharCheckBoxTalentedWater));
		values.put(dbField.talentedLife.getStringValue(),getFormElementBoolean(R.id.editCharCheckBoxTalentedLife));
		values.put(dbField.talentedIce.getStringValue(),getFormElementBoolean(R.id.editCharCheckBoxTalentedIce));
		values.put(dbField.talentedStone.getStringValue(),getFormElementBoolean(R.id.editCharCheckBoxTalentedStone));
		values.put(dbField.talentedAir.getStringValue(),getFormElementBoolean(R.id.editCharCheckBoxTalentedAir));
		values.put(dbField.talentedDemonic.getStringValue(),getFormElementInt(R.id.editCharEditTalentedDemonic));
		values.put(dbField.knowledgeFire.getStringValue(),getFormElementBoolean(R.id.editCharCheckBoxKnowledgeFire));
		values.put(dbField.knowledgeWater.getStringValue(),getFormElementBoolean(R.id.editCharCheckBoxKnowledgeWater));
		values.put(dbField.knowledgeLife.getStringValue(),getFormElementBoolean(R.id.editCharCheckBoxKnowledgeLife));
		values.put(dbField.knowledgeIce.getStringValue(),getFormElementBoolean(R.id.editCharCheckBoxKnowledgeIce));
		values.put(dbField.knowledgeStone.getStringValue(),getFormElementBoolean(R.id.editCharCheckBoxKnowledgeStone));
		values.put(dbField.knowledgeAir.getStringValue(),getFormElementBoolean(R.id.editCharCheckBoxKnowledgeAir));
		values.put(dbField.knowledgeDemonic.getStringValue(),getFormElementInt(R.id.editCharEditKnowledgeDemonic));
		values.put(dbField.affinityToElementals.getStringValue(),getFormElementBoolean(R.id.editCharCheckBoxAffinityToElementals));
		values.put(dbField.demonicCovenant.getStringValue(),getFormElementBoolean(R.id.editCharCheckBoxDemonicCovenant));
		values.put(dbField.cloakedAura.getStringValue(),getFormElementBoolean(R.id.editCharCheckBoxCloakedAura));
		values.put(dbField.weakPresence.getStringValue(),getFormElementInt(R.id.editCharEditWeakPresence));
		values.put(dbField.strengthOfStigma.getStringValue(),getFormElementInt(R.id.editCharEditStrengthOfStigma));
		Database.update("Characters", values, "id = '"+dbId+"'", null);
		Database.close();
	}
	private void deleteChar(){
		SQLiteDatabase Database = DB.getWritableDatabase();
		Database.delete("Characters", ""+dbField.id.getStringValue()+" = '"+dbId+"'", null);
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
