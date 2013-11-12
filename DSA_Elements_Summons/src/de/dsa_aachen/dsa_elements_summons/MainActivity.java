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
	}
	void createCharView(){
		Intent intent = new Intent();
		intent.setClass(MainActivity.this,CreateCharActivity.class); 
		startActivity(intent);
	}
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main_activity, menu);
		return true;
	}

}

