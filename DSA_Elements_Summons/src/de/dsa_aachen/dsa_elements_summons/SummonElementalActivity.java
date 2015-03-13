package de.dsa_aachen.dsa_elements_summons;

import de.dsa_aachen.dsa_elements_summons.DSA_Summons_Elements_Database.dbField;
import de.dsa_aachen.dsa_elements_summons.DSA_Summons_Elements_CharacterClasses.Classes;
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
	private int dbId, talentedDemonic, weakPresence, statCourage, statWisdom, statCharisma,
		statIntuition, talentCallElementalServant, talentCallDjinn, talentCallMasterOfElement,
		knowledgeDemonic, strengthOfStigma;
	private boolean talentedFire,  talentedWater, talentedLife, talentedIce, talentedStone, 
		talentedAir, knowledgeFire, knowledgeWater, knowledgeLife, knowledgeIce, knowledgeStone, 
		knowledgeAir, affinityToElementals, cloakedAura, demonicCovenant;
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
		
		Classes character = Classes.getById(dbField.characterClass.getIntValue());
		CheckBox checkboxEquipment1 = (CheckBox)findViewById(R.id.summonElementalCheckBoxEquipment1);
		checkboxEquipment1.setText(getString(character.getFirstEquipmentId()));
		CheckBox checkboxEquipment2 = (CheckBox)findViewById(R.id.summonElementalCheckBoxEquipment2);
		checkboxEquipment2.setText(getString(character.getSecondEquipmentId()));
		
		//setEditSpinnerPositionInt(query, dbField.characterClass.getIntValue(), R.id.editCharChooseCharacterClass);
		
		int characterEquipmentModifier = query.getInt(dbField.characterEquipmentModifier.getIntValue());
		System.out.println("characterEquipmentModifier = "+characterEquipmentModifier);
		if(characterEquipmentModifier == 1 || characterEquipmentModifier == 3 ) {
			checkboxEquipment1.setChecked(true);
		    //setCheckBox(query,1, R.id.editCharCheckBoxEquipment1);
		}

		if(characterEquipmentModifier > 1) {
			checkboxEquipment2.setChecked(true);
			//setCheckBox(query,1, R.id.editCharCheckBoxEquipment2);
		}
		statCourage = dbField.statCourage.getIntValue();
		statWisdom = dbField.statWisdom.getIntValue();
		statCharisma = dbField.statCharisma.getIntValue();
		statIntuition = dbField.statIntuition.getIntValue();
		talentCallElementalServant = dbField.talentCallElementalServant.getIntValue();
		talentCallDjinn = dbField.talentCallDjinn.getIntValue();
		talentCallMasterOfElement = dbField.talentCallMasterOfElement.getIntValue();
		/*setEditTextInt(query, dbField.statCourage.getIntValue(), R.id.summonElementalEditStatCourage);
		setEditTextInt(query, dbField.statWisdom.getIntValue(), R.id.summonElementalEditStatWisdom);
		setEditTextInt(query, dbField.statCharisma.getIntValue(), R.id.summonElementalEditStatCharisma);
		setEditTextInt(query, dbField.statIntuition.getIntValue(), R.id.summonElementalEditStatIntuition);
		setEditTextInt(query, dbField.talentCallElementalServant.getIntValue(), R.id.summonElementalEditTalentCallElementalServant);
		setEditTextInt(query, dbField.talentCallDjinn.getIntValue(), R.id.summonElementalEditTalentCallDjinn);
		setEditTextInt(query, dbField.talentCallMasterOfElement.getIntValue(), R.id.summonElementalEditTalentCallMasterOfElement);*/
		
		talentedFire = dbField.talentedFire.getIntValue() == 1 ? true : false;
		talentedWater = dbField.talentedWater.getIntValue() == 1 ? true : false; 
		talentedLife = dbField.talentedLife.getIntValue() == 1 ? true : false; 
		talentedIce = dbField.talentedIce.getIntValue() == 1 ? true : false; 
		talentedStone = dbField.talentedStone.getIntValue() == 1 ? true : false; 
		talentedAir = dbField.talentedAir.getIntValue() == 1 ? true : false; 
		talentedDemonic = dbField.talentedDemonic.getIntValue();
		
		knowledgeFire = dbField.knowledgeFire.getIntValue()== 1 ? true : false;
		knowledgeWater = dbField.knowledgeWater.getIntValue()== 1 ? true : false;
		knowledgeLife = dbField.knowledgeLife.getIntValue()== 1 ? true : false;
		knowledgeIce = dbField.knowledgeIce.getIntValue()== 1 ? true : false;
		knowledgeStone = dbField.knowledgeStone.getIntValue()== 1 ? true : false;
		knowledgeAir = dbField.knowledgeAir.getIntValue()== 1 ? true : false;
		/*setCheckBox(query, dbField.knowledgeFire.getIntValue(), R.id.summonElementalCheckBoxKnowledgeFire);
		setCheckBox(query, dbField.knowledgeWater.getIntValue(), R.id.summonElementalCheckBoxKnowledgeWater);
		setCheckBox(query, dbField.knowledgeLife.getIntValue(), R.id.summonElementalCheckBoxKnowledgeLife);
		setCheckBox(query, dbField.knowledgeIce.getIntValue(), R.id.summonElementalCheckBoxKnowledgeIce);
		setCheckBox(query, dbField.knowledgeStone.getIntValue(), R.id.summonElementalCheckBoxKnowledgeStone);
		setCheckBox(query, dbField.knowledgeAir.getIntValue(), R.id.summonElementalCheckBoxKnowledgeAir);*/
		
		knowledgeDemonic = dbField.knowledgeDemonic.getIntValue();
		//setEditTextInt(query, dbField.knowledgeDemonic.getIntValue(), R.id.summonElementalEditKnowledgeDemonic);
		
		affinityToElementals = dbField.affinityToElementals.getIntValue() == 1 ? true: false;
		
		demonicCovenant = dbField.demonicCovenant.getIntValue()== 1 ? true : false;
		//setCheckBox(query, dbField.demonicCovenant.getIntValue(), R.id.summonElementalCheckBoxDemonicCovenant);
		cloakedAura = dbField.cloakedAura.getIntValue() == 1 ? true : false;
		weakPresence = dbField.weakPresence.getIntValue();
		
		strengthOfStigma = dbField.strengthOfStigma.getIntValue();
		//setEditTextInt(query, dbField.strengthOfStigma.getIntValue(), R.id.summonElementalEditStrengthOfStigma);

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

		View spinnerTypeOfElement = 
				findViewById(R.id.spinnerTypeOfElement);
		if(arg0 == spinnerTypeOfElement){
			
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
			        spinnerElement.values()[(int)rId].getStringArrayId(), 
			        android.R.layout.simple_spinner_item);
			// Specify the layout to use when the list of choices appears
			adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
			// Apply the adapter to the spinner
			spinner.setAdapter(adapter);
			System.out.println("view.getId() == R.id.spinnerTypeOfElement");
		}
	}
	@Override
	public void onNothingSelected(AdapterView<?> arg0) {
		// TODO Auto-generated method stub
		
	}

}
