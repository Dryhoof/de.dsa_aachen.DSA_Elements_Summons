package de.dsa_aachen.dsa_elements_summons;

import android.app.Activity;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.Menu;
import android.widget.CheckBox;
import android.widget.TextView;

public class CreateCharActivity extends Activity {
    public static final String PREFS_NAME = "DSA_Summons_Prefs";
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.create_char_activity);
		
		SharedPreferences settings = getSharedPreferences(PREFS_NAME,MODE_PRIVATE);
		
	    boolean charTalentedFire = settings.getBoolean("charTalentedFire", false);
	    final CheckBox createCharCheckBoxTalentedFire = (CheckBox) findViewById(R.id.createCharCheckBoxTalentedFire);
	    createCharCheckBoxTalentedFire.setChecked(charTalentedFire);

	    String charCharacterName = settings.getString("CharCharacterName", null);
	    final TextView createCharEditCharacterName = (TextView) findViewById(R.id.createCharEditCharacterName);
	    createCharEditCharacterName.setText(charCharacterName);
	    
	    int CharStatCourage = settings.getInt("CharStatCourage", 0);
	    final TextView createCharEditStatCourage = (TextView) findViewById(R.id.createCharEditStatCourage);
	    createCharEditStatCourage.setText(String.valueOf(CharStatCourage));
	}
	
    protected void onStop(){
        super.onStop();

       // We need an Editor object to make preference changes.
       // All objects are from android.context.Context
       SharedPreferences settings = getSharedPreferences(PREFS_NAME,MODE_PRIVATE);
       SharedPreferences.Editor editor = settings.edit();
       
       final CheckBox createCharCheckBoxTelendetFire = (CheckBox) findViewById(R.id.createCharCheckBoxTalentedFire);
       editor.putBoolean("charTalentedFire", createCharCheckBoxTelendetFire.isChecked());
       
       final TextView createCharEditCharacterName = (TextView) findViewById(R.id.createCharEditCharacterName);
       String createCharEditCharacterNameString = createCharEditCharacterName.getText().toString();
       editor.putString("CharCharacterName", createCharEditCharacterNameString);
       
       final TextView createCharEditStatCourage = (TextView) findViewById(R.id.createCharEditStatCourage);
       int createCharEditStatCourageInt =  Integer.parseInt(createCharEditStatCourage.getText().toString());
       editor.putInt("CharStatCourage", createCharEditStatCourageInt);
       
       
       // Commit the edits!
       editor.commit();
     }
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.create_char_activity, menu);
		return true;
	}
}
