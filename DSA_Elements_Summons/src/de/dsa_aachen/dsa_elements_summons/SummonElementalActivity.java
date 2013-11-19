package de.dsa_aachen.dsa_elements_summons;

import de.dsa_aachen.dsa_elements_summons.DSA_Summons_Elements_Database.dbField;
import android.os.Bundle;
import android.app.Activity;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;

public class SummonElementalActivity extends Activity {
	int dbId;

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
		DSA_Summons_Elements_Database DB = new DSA_Summons_Elements_Database(this);
		SQLiteDatabase Database = DB.getReadableDatabase();
		final Cursor cursor = Database.query(false, "Characters", null, null, null, null, null, "id ASC", null);
		cursor.moveToFirst();
		/*
		LinearLayout.LayoutParams editParams = new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT,LayoutParams.WRAP_CONTENT);
		LinearLayout layoutSummonElementalActivity = (LinearLayout) findViewById(R.id.LinearLayout1);

		Button elementalServant = new Button(this);
		elementalServant.setLayoutParams(editParams);
		elementalServant.setTag(getResources().getIdentifier("buttonSummonElementalServant","id",this.getBaseContext().getPackageName()));
		elementalServant.setText(R.string.str_ElementalServant);
		layoutSummonElementalActivity.addView(elementalServant);
		elementalServant.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	//TODO create function
            }
        });
		Button djinn = new Button(this);
		djinn.setLayoutParams(editParams);
		djinn.setTag(getResources().getIdentifier("buttonSummonDjinn","id",this.getBaseContext().getPackageName()));
		djinn.setText(R.string.str_Djinn);
		layoutSummonElementalActivity.addView(djinn);
		djinn.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	//TODO create function
            }
        });

		Button masterOfElement = new Button(this);
		masterOfElement.setLayoutParams(editParams);
		masterOfElement.setTag(getResources().getIdentifier("buttonSummonMasterOfElement","id",this.getBaseContext().getPackageName()));
		masterOfElement.setText(R.string.str_MasterOfElement);
		layoutSummonElementalActivity.addView(masterOfElement);
		masterOfElement.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	//TODO create function
            }
        });
        */
	}

	private void showElementSelection(){
		
	}
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.summon_elemental_activity, menu);
		return true;
	}

}
