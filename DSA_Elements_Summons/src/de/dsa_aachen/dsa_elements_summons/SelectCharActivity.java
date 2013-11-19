package de.dsa_aachen.dsa_elements_summons;

import de.dsa_aachen.dsa_elements_summons.DSA_Summons_Elements_Database.dbField;
import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;

public class SelectCharActivity extends Activity {
	private String nextActivity = "";
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		if (savedInstanceState == null) {
		    Bundle extras = getIntent().getExtras();
		    if(extras == null) {
		    	nextActivity = "EditCharActivity";
		    } else {
		    	nextActivity= extras.getString("nextActivity");
		    }
		} else {
			nextActivity= savedInstanceState.getSerializable("nextActivity").toString();
		}
		System.out.println("SelectCharActivity.nextActivity = "+ nextActivity);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.select_char_activity);
		DSA_Summons_Elements_Database DB = new DSA_Summons_Elements_Database(this);
		SQLiteDatabase Database = DB.getReadableDatabase();
		final Cursor cursor = Database.query(false, "Characters", null, null, null, null, null, "id ASC", null);
		cursor.moveToFirst();
		int i = 0;
		final int dbId[] = new int[cursor.getCount()];
		final Button button[] = new Button[cursor.getCount()];

		/*OnClickListener onclicklistener = new OnClickListener() {
			@Override
            public void onClick(View v) {
				for(int j=0;j<cursor.getCount();j++){
					if(v == button[j]){
		            	editCharView(dbId[j]);
		            	break;
			        }
				}
            }
        };*/
		do{
			button[i] = new Button(this);
			System.out.println("SelectCharActivity.echo");
			LinearLayout.LayoutParams editParams = new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT,LayoutParams.WRAP_CONTENT);
			button[i].setLayoutParams(editParams);
			System.out.println("SelectCharActivity.echo");
			int ressourceId = getResources().getIdentifier(
				    "dynamicCharButton"+cursor.getPosition(),
				    "id",
				    this.getBaseContext().getPackageName());
			button[i].setTag(ressourceId);
			button[i].setText(cursor.getString(dbField.characterName.getIntValue()));
			//button[i].setOnClickListener(onclicklistener);
			LinearLayout myLayout = (LinearLayout) findViewById(R.id.LinearLayout1);
			myLayout.addView(button[i]);
			System.out.println("SelectCharActivity.[i] = "+ i);
			System.out.println("SelectCharActivity.button[i] = "+ ressourceId);
			dbId[i] = cursor.getInt(dbField.id.getIntValue());
			System.out.println("SelectCharActivity.dbId[i] = "+ dbId[i]);
			button[i].setOnClickListener(new View.OnClickListener() {
				@Override
		        public void onClick(View v) {
					for(int j=0;j<cursor.getCount();j++){
						if(v == button[j]){
							System.out.println("nextActivity.equals(\"EditCharActivity\") =  "+ nextActivity.equals("EditCharActivity"));
							if(nextActivity.equals("EditCharActivity")){
				            	editCharView(dbId[j]);
							}
							System.out.println("nextActivity.equals(\"SummonElementalActivity\") =  "+ nextActivity.equals("SummonElementalActivity"));
							if(nextActivity.equals("SummonElementalActivity")){
								System.out.println();
								summonElementalView(dbId[j]);
							}
			            	break;
				        }
					}
		        }
		    });
			i++;
		}while(cursor.moveToNext());
		
	}

	void summonElementalView(int dbId){
		System.out.println("Starting SummonElementalActivity");
		Intent intent = new Intent();
		intent.setClass(SelectCharActivity.this,SummonElementalActivity.class); 
		intent.putExtra("dbId", dbId);
		startActivity(intent);
	}
	void editCharView(int dbId){
		System.out.println("Starting EditCharActivity");
		Intent intent = new Intent();
		intent.setClass(SelectCharActivity.this,EditCharActivity.class); 
		intent.putExtra("dbId", dbId);
		startActivity(intent);
	}
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.select_char_activity, menu);
		return true;
	}
	@Override
	public void onStop(){
		super.onStop();
		System.out.println("SelectCharActivity is beeing destroyed!");
	}
}
