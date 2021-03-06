package de.dsa_aachen.dsa_elements_summons;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.Menu;
import android.view.View;
import android.widget.Button;

public class MainActivity extends Activity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main_activity);
		
        final Button createChar = (Button) findViewById(R.id.createChar);
        createChar.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	createCharView();
            }
        });
        
        final Button editChar = (Button) findViewById(R.id.editChar);
        editChar.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	selectCharView("EditCharActivity");
            }
        });

        final Button summonElemental = (Button) findViewById(R.id.summonElemental);
        summonElemental.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	selectCharView("SummonElementalActivity");
            }
        });
	}
	void createCharView(){
		System.out.println("Starting EditCharActivity");
		Intent intent = new Intent();
		intent.setClass(MainActivity.this,EditCharActivity.class);
		//intent.putExtra("dbId", 0); 
		startActivity(intent);
	}
	/*void editCharView(){
		Intent intent = new Intent();
		intent.setClass(MainActivity.this,EditCharActivity.class); 
		intent.putExtra("dbId", 1);
		startActivity(intent);
	}*/
	void selectCharView(String nextActivity){
		Intent intent = new Intent();
		intent.setClass(MainActivity.this,SelectCharActivity.class); 
		intent.putExtra("nextActivity", nextActivity);
		startActivity(intent);
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main_activity, menu);
		return true;
	}
}

