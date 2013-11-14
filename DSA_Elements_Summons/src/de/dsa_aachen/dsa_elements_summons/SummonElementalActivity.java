package de.dsa_aachen.dsa_elements_summons;

import android.os.Bundle;
import android.app.Activity;
import android.view.Menu;

public class SummonElementalActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.summon_elemental_activity);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.summon_elemental, menu);
		return true;
	}

}
