package de.dsa_aachen.dsa_elements_summons;

import android.os.Bundle;
import android.app.Activity;
import android.text.InputType;
import android.view.Menu;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;

public class SelectCharActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.select_char_activity);
		final EditText editText = new EditText(this);
		LinearLayout.LayoutParams editParams = new LinearLayout.LayoutParams(360, LayoutParams.WRAP_CONTENT);
		editParams.setMargins(7, 0, 0, 0);
		editText.setLayoutParams(editParams);
		editText.setTag(R.id.dynamicCharButton1);
		editText.setSingleLine(true);
		editText.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
		LinearLayout myLayout = (LinearLayout) findViewById(R.id.LinearLayout1);
		myLayout.addView(editText);
	}

	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.select_char_activity, menu);
		return true;
	}

}
