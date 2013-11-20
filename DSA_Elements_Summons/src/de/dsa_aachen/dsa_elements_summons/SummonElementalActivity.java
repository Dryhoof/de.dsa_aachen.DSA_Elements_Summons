package de.dsa_aachen.dsa_elements_summons;

import de.dsa_aachen.dsa_elements_summons.DSA_Summons_Elements_Database.dbField;
import android.os.Bundle;
import android.app.Activity;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.LinearLayout;
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
		final Cursor cursor = Database.query(false, "Characters", null, null, 
				null, null, null, "id ASC", null);
		cursor.moveToFirst();
		Spinner spinner = (Spinner) findViewById(R.id.spinnerTypeOfElement);
		spinner.setOnItemSelectedListener(this);
		/*
		LinearLayout.LayoutParams editParams = 
			new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT,
				LayoutParams.WRAP_CONTENT);
		LinearLayout layoutSummonElementalActivity = 
			(LinearLayout) findViewById(R.id.LinearLayout1);

		Button elementalServant = new Button(this);
		elementalServant.setLayoutParams(editParams);
		elementalServant.setTag(getResources().getIdentifier(
			"buttonSummonElementalServant","id",
			this.getBaseContext().getPackageName()));
		elementalServant.setText(R.string.str_ElementalServant);
		layoutSummonElementalActivity.addView(elementalServant);
		elementalServant.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	//TODO create function
            }
        });
		Button djinn = new Button(this);
		djinn.setLayoutParams(editParams);
		djinn.setTag(getResources().getIdentifier("buttonSummonDjinn",
			"id",this.getBaseContext().getPackageName()));
		djinn.setText(R.string.str_Djinn);
		layoutSummonElementalActivity.addView(djinn);
		djinn.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	//TODO create function
            }
        });

		Button masterOfElement = new Button(this);
		masterOfElement.setLayoutParams(editParams);
		masterOfElement.setTag(getResources().getIdentifier(
			"buttonSummonMasterOfElement","id",
			this.getBaseContext().getPackageName()));
		masterOfElement.setText(R.string.str_MasterOfElement);
		layoutSummonElementalActivity.addView(masterOfElement);
		masterOfElement.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	//TODO create function
            }
        });
        */
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
			View namebar = linearLayoutElementSpinners.findViewById(R.id.spinnerChooseQualityOfMaterial);
			((LinearLayout)namebar.getParent()).removeView(namebar);
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
		        spinnerElement.values()[position].getStringArrayId(), android.R.layout.simple_spinner_item);
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
