package de.dsa_aachen.dsa_elements_summons;

import de.dsa_aachen.dsa_elements_summons.DSA_Summons_Elements_Database.dbField;
import android.app.Activity;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.LinearLayout.LayoutParams;
import android.widget.Spinner;

public class SummonElementalActivity extends Activity 
	implements OnItemSelectedListener{
	int dbId;
	DSA_Summons_Elements_Database DB = new DSA_Summons_Elements_Database(this);
	public static enum spinnerElement {
		fire(0,R.array.str_ElementalPurityFireArray),
        water(1,R.array.str_ElementalPurityWaterArray),
        life(2,R.array.str_ElementalPurityLifeArray),
        ice(3,R.array.str_ElementalPurityIceArray),
        stone(4,R.array.str_ElementalPurityStoneArray),
        air(5,R.array.str_ElementalPurityAirArray);
		
	    private int intValue;
	    private int stringArrayId;
        private spinnerElement(int value,int array) {
        	setIntValue(value);
        	setStringArrayId(array);
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
	}
	@Override
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
		System.out.println("SummonElementalActivity.dbId = "+ dbId);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.summon_elemental_activity);
		SQLiteDatabase Database = DB.getReadableDatabase();

		Cursor query = Database.query(false, "Characters", null, "id = '" + dbId + "'", null, null, null, "id ASC", null);
		query.moveToFirst();
		Spinner spinner = (Spinner) findViewById(R.id.spinnerTypeOfElement);
		spinner.setOnItemSelectedListener(this);
		
		setEditTextString(query, dbField.characterName.getIntValue(), R.id.summonElementalCharacterName);
		
		//setEditSpinnerPositionInt(query, dbField.characterClass.getIntValue(), R.id.editCharChooseCharacterClass);
		
		int charakterEquipmentModifier = query.getInt(dbField.characterEquipmentModifier.getIntValue());
		System.out.println("charakterEquipmentModifier = "+charakterEquipmentModifier);
		if(charakterEquipmentModifier == 1 || charakterEquipmentModifier == 3 ) {
			final CheckBox checkBox = (CheckBox) findViewById(R.id.summonElementalCheckBoxEquipment1);
		    checkBox.setChecked(true);
		    //setCheckBox(query,1, R.id.editCharCheckBoxEquipment1);
		}

		if(charakterEquipmentModifier > 1) {
			final CheckBox checkBox = (CheckBox) findViewById(R.id.summonElementalCheckBoxEquipment2);
		    checkBox.setChecked(true);
			//setCheckBox(query,1, R.id.editCharCheckBoxEquipment2);
		}
		setEditTextInt(query, dbField.statCourage.getIntValue(), R.id.summonElementalEditStatCourage);
		setEditTextInt(query, dbField.statWisdom.getIntValue(), R.id.summonElementalEditStatWisdom);
		setEditTextInt(query, dbField.statCharisma.getIntValue(), R.id.summonElementalEditStatCharisma);
		setEditTextInt(query, dbField.statIntuition.getIntValue(), R.id.summonElementalEditStatIntuition);
		setEditTextInt(query, dbField.talentCallElementalServant.getIntValue(), R.id.summonElementalEditTalentCallElementalServant);
		setEditTextInt(query, dbField.talentCallDjinn.getIntValue(), R.id.summonElementalEditTalentCallDjinn);
		setEditTextInt(query, dbField.talentCallMasterOfElement.getIntValue(), R.id.summonElementalEditTalentCallMasterOfElement);
		//setCheckBox(query, dbField.talentedFire.getIntValue(), R.id.editCharCheckBoxTalentedFire);
		//setCheckBox(query, dbField.talentedWater.getIntValue(), R.id.editCharCheckBoxTalentedWater);
		//setCheckBox(query, dbField.talentedLife.getIntValue(), R.id.editCharCheckBoxTalentedLife);
		//setCheckBox(query, dbField.talentedIce.getIntValue(), R.id.editCharCheckBoxTalentedIce);
		//setCheckBox(query, dbField.talentedStone.getIntValue(), R.id.editCharCheckBoxTalentedStone);
		//setCheckBox(query, dbField.talentedAir.getIntValue(), R.id.editCharCheckBoxTalentedAir);
		//setEditTextInt(query, dbField.talentedDemonic.getIntValue(), R.id.editCharEditTalentedDemonic);
		setCheckBox(query, dbField.knowledgeFire.getIntValue(), R.id.summonElementalCheckBoxKnowledgeFire);
		setCheckBox(query, dbField.knowledgeWater.getIntValue(), R.id.summonElementalCheckBoxKnowledgeWater);
		setCheckBox(query, dbField.knowledgeLife.getIntValue(), R.id.summonElementalCheckBoxKnowledgeLife);
		setCheckBox(query, dbField.knowledgeIce.getIntValue(), R.id.summonElementalCheckBoxKnowledgeIce);
		setCheckBox(query, dbField.knowledgeStone.getIntValue(), R.id.summonElementalCheckBoxKnowledgeStone);
		setCheckBox(query, dbField.knowledgeAir.getIntValue(), R.id.summonElementalCheckBoxKnowledgeAir);
		setEditTextInt(query, dbField.knowledgeDemonic.getIntValue(), R.id.summonElementalEditKnowledgeDemonic);
		//setCheckBox(query, dbField.affinityToElementals.getIntValue(), R.id.editCharCheckBoxAffinityToElementals);
		setCheckBox(query, dbField.demonicCovenant.getIntValue(), R.id.summonElementalCheckBoxDemonicCovenant);
		//setCheckBox(query, dbField.cloakedAura.getIntValue(), R.id.editCharCheckBoxCloakedAura);
		//setEditTextInt(query, dbField.weakPresence.getIntValue(), R.id.editCharEditWeakPresence);
		setEditTextInt(query, dbField.strengthOfStigma.getIntValue(), R.id.summonElementalEditStrengthOfStigma);

		Database.close();
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

		View linearLayoutElementSpinners = 
				findViewById(R.id.LinearLayoutElementSpinners);
		try{
			View oldSpinner = linearLayoutElementSpinners.findViewById(R.id.spinnerChooseQualityOfMaterial);
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
		        spinnerElement.values()[position].getStringArrayId(), 
		        android.R.layout.simple_spinner_item);
		// Specify the layout to use when the list of choices appears
		adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		// Apply the adapter to the spinner
		spinner.setAdapter(adapter);
		System.out.println("view.getId() == R.id.spinnerTypeOfElement");
		
	}
	@Override
	public void onNothingSelected(AdapterView<?> arg0) {
		// TODO Auto-generated method stub
		
	}

}
