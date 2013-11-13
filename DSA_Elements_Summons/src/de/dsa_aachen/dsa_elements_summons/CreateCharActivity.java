package de.dsa_aachen.dsa_elements_summons;

import android.app.Activity;
import android.content.ContentValues;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteQuery;
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
	    private int intValue;
        private dbField(String stringV, int value) {
        	intValue = value;
        	stringValue = stringV;
        }
	}
	DSA_Summons_Elements_Database DB = new DSA_Summons_Elements_Database(this);
    public static final String PREFS_NAME = "DSA_Summons_Prefs";
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.create_char_activity);
		
		//SharedPreferences settings = getSharedPreferences(PREFS_NAME,MODE_PRIVATE);
		
		SQLiteDatabase Database = DB.getReadableDatabase();
		Cursor query = Database.query(false, "Characters", null, null, null, null, null, "id ASC", null);
		if(query.getCount() != 0){
			query.moveToFirst();
			//int test = query.getColumnCount();
			//boolean charTalentedFire = settings.getBoolean("charTalentedFire", false);
	
			/*boolean talentedFire = query.getInt(dbField.talentedFire.intValue)>0;
		    final CheckBox createCharCheckBoxTalentedFire = (CheckBox) findViewById(R.id.createCharCheckBoxTalentedFire);
		    createCharCheckBoxTalentedFire.setChecked(talentedFire);
	
		    //String charCharacterName = settings.getString("CharCharacterName", null);
			String characterName = query.getString(dbField.characterName.intValue);
		    final TextView createCharEditCharacterName = (TextView) findViewById(R.id.createCharEditCharacterName);
		    createCharEditCharacterName.setText(characterName);*/
		    
		    //int CharStatCourage = settings.getInt("CharStatCourage", 0);
			/*System.out.println("query.getCount()" + " " +query.getCount());
			System.out.println("query.getColumnCount()" + " " +query.getColumnCount());
			System.out.println("dbField.statCourage.intValue" +" " + dbField.statCourage.intValue);
			System.out.println("query.getPosition()" +" " + query.getPosition());*/
			
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
        //values.put(dbField.id.stringValue,);
        

		values.put(dbField.id.stringValue,1);
		
        final TextView createCharEditCharacterName = (TextView) findViewById(R.id.createCharEditCharacterName);
        String createCharEditCharacterNameString = createCharEditCharacterName.getText().toString();
        if(createCharEditCharacterNameString != null){
        	values.put(dbField.characterName.stringValue,createCharEditCharacterNameString);
        }else{
        		values.put(dbField.characterName.stringValue,"");
        }
        
        final TextView createCharEditStatCourage = (TextView) findViewById(R.id.createCharEditStatCourage);
        String createCharEditStatCourageString = createCharEditStatCourage.getText().toString();
        int createCharEditStatCourageInt;
        if(createCharEditStatCourageString == ""){
        	createCharEditStatCourageInt = 0;
        }else{
            createCharEditStatCourageInt =  Integer.parseInt(createCharEditStatCourageString);
        }
        values.put(dbField.statCourage.stringValue,createCharEditStatCourageInt);

        final TextView createCharEditStatWisdom = (TextView) findViewById(R.id.createCharEditStatWisdom);
        String createCharEditStatWisdomString = createCharEditStatWisdom.getText().toString();
        int createCharEditStatWisdomInt;
        if(createCharEditStatWisdomString == ""){
        	createCharEditStatWisdomInt = 0;
        }else{
            createCharEditStatWisdomInt =  Integer.parseInt(createCharEditStatWisdomString);
        }
        values.put(dbField.statWisdom.stringValue,createCharEditStatWisdomInt);
        
        final TextView createCharEditStatCharisma = (TextView) findViewById(R.id.createCharEditStatCharisma);
        String createCharEditStatCharismaString = createCharEditStatCharisma.getText().toString();
        int createCharEditStatCharismaInt;
        if(createCharEditStatCharismaString == ""){
        	createCharEditStatCharismaInt = 0;
        }else{
            createCharEditStatCharismaInt =  Integer.parseInt(createCharEditStatCharismaString);
        }
        values.put(dbField.statCharisma.stringValue,createCharEditStatCharismaInt);
        
        final TextView createCharEditStatIntuition = (TextView) findViewById(R.id.createCharEditStatIntuition);
        String createCharEditStatIntuitionString = createCharEditStatIntuition.getText().toString();
        int createCharEditStatIntuitionInt;
        if(createCharEditStatIntuitionString == ""){
        	createCharEditStatIntuitionInt = 0;
        }else{
            createCharEditStatIntuitionInt =  Integer.parseInt(createCharEditStatIntuitionString);
        }
        values.put(dbField.statIntuition.stringValue,createCharEditStatIntuitionInt);
        
        //TODO
        final TextView createCharEditStatIntuition = (TextView) findViewById(R.id.createCharEditStatIntuition);
        String createCharEditStatIntuitionString = createCharEditStatIntuition.getText().toString();
        int createCharEditStatIntuitionInt;
        if(createCharEditStatIntuitionString == ""){
        	createCharEditStatIntuitionInt = 0;
        }else{
            createCharEditStatIntuitionInt =  Integer.parseInt(createCharEditStatIntuitionString);
        }
        values.put(dbField.talentCallElementalServant.stringValue,0);

        //TODO
        final TextView createCharEditStatIntuition = (TextView) findViewById(R.id.createCharEditStatIntuition);
        String createCharEditStatIntuitionString = createCharEditStatIntuition.getText().toString();
        int createCharEditStatIntuitionInt;
        if(createCharEditStatIntuitionString == ""){
        	createCharEditStatIntuitionInt = 0;
        }else{
            createCharEditStatIntuitionInt =  Integer.parseInt(createCharEditStatIntuitionString);
        }
        values.put(dbField.talentCallDjinn.stringValue,0);

        //TODO
        final TextView createCharEditStatIntuition = (TextView) findViewById(R.id.createCharEditStatIntuition);
        String createCharEditStatIntuitionString = createCharEditStatIntuition.getText().toString();
        int createCharEditStatIntuitionInt;
        if(createCharEditStatIntuitionString == ""){
        	createCharEditStatIntuitionInt = 0;
        }else{
            createCharEditStatIntuitionInt =  Integer.parseInt(createCharEditStatIntuitionString);
        }
        values.put(dbField.talentCallMasterOfElement.stringValue,0);
        
        
        final CheckBox createCharCheckBoxTelendetFire = (CheckBox) findViewById(R.id.createCharCheckBoxTalentedFire);
        values.put(dbField.talentedFire.stringValue,createCharCheckBoxTelendetFire.isChecked());
        
        values.put(dbField.talentedWater.stringValue,0);
        values.put(dbField.talentedLife.stringValue,0);
        values.put(dbField.talentedIce.stringValue,0);
        values.put(dbField.talentedStone.stringValue,0);
        values.put(dbField.talentedAir.stringValue,0);

        //TODO
        final TextView createCharEditStatIntuition = (TextView) findViewById(R.id.createCharEditStatIntuition);
        String createCharEditStatIntuitionString = createCharEditStatIntuition.getText().toString();
        int createCharEditStatIntuitionInt;
        if(createCharEditStatIntuitionString == ""){
        	createCharEditStatIntuitionInt = 0;
        }else{
            createCharEditStatIntuitionInt =  Integer.parseInt(createCharEditStatIntuitionString);
        }
        values.put(dbField.talentedDemonic.stringValue,0);
        
		values.put(dbField.knowledgeFire.stringValue,0);
		values.put(dbField.knowledgeWater.stringValue,0);
		values.put(dbField.knowledgeLife.stringValue,0);
		values.put(dbField.knowledgeIce.stringValue,0);
		values.put(dbField.knowledgeStone.stringValue,0);
		values.put(dbField.knowledgeAir.stringValue,0);

        //TODO
        final TextView createCharEditStatIntuition = (TextView) findViewById(R.id.createCharEditStatIntuition);
        String createCharEditStatIntuitionString = createCharEditStatIntuition.getText().toString();
        int createCharEditStatIntuitionInt;
        if(createCharEditStatIntuitionString == ""){
        	createCharEditStatIntuitionInt = 0;
        }else{
            createCharEditStatIntuitionInt =  Integer.parseInt(createCharEditStatIntuitionString);
        }
		values.put(dbField.knowledgeDemonic.stringValue,0);
		
		values.put(dbField.affinityToElementals.stringValue,0);
		values.put(dbField.demonicCovenant.stringValue,0);
		values.put(dbField.cloakedAura.stringValue,0);

        //TODO
        final TextView createCharEditStatIntuition = (TextView) findViewById(R.id.createCharEditStatIntuition);
        String createCharEditStatIntuitionString = createCharEditStatIntuition.getText().toString();
        int createCharEditStatIntuitionInt;
        if(createCharEditStatIntuitionString == ""){
        	createCharEditStatIntuitionInt = 0;
        }else{
            createCharEditStatIntuitionInt =  Integer.parseInt(createCharEditStatIntuitionString);
        }
		values.put(dbField.weakPresence.stringValue,0);

        //TODO
        final TextView createCharEditStatIntuition = (TextView) findViewById(R.id.createCharEditStatIntuition);
        String createCharEditStatIntuitionString = createCharEditStatIntuition.getText().toString();
        int createCharEditStatIntuitionInt;
        if(createCharEditStatIntuitionString == ""){
        	createCharEditStatIntuitionInt = 0;
        }else{
            createCharEditStatIntuitionInt =  Integer.parseInt(createCharEditStatIntuitionString);
        }
		values.put(dbField.strengthOfStigma.stringValue,0);
		
		if(queryCount == 1){
			Database.update("Characters", values, "id = '1'", null);
		}else{
        	Database.insert("Characters", "id", values);
		}
		Database.close();
		//SharedPreferences settings = getSharedPreferences(PREFS_NAME,MODE_PRIVATE);
		//SharedPreferences.Editor editor = settings.edit();
		
		
		//editor.putString("CharCharacterName", createCharEditCharacterNameString);
		
		//final TextView createCharEditStatCourage = (TextView) findViewById(R.id.createCharEditStatCourage);
		//int createCharEditStatCourageInt =  Integer.parseInt(createCharEditStatCourage.getText().toString());
		//editor.putInt("CharStatCourage", createCharEditStatCourageInt);
		
		
		// Commit the edits!
		//editor.commit();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.create_char_activity, menu);
		return true;
	}
}
