package de.dsa_aachen.dsa_elements_summons;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class DSA_Summons_Elements_Database extends SQLiteOpenHelper{

    private static final int DATABASE_VERSION = 2;
    private static final String CHARACTERS_TABLE_NAME = "Characters";
    private static final String CHARACTERS_TABLE_CREATE =
                "create table " + CHARACTERS_TABLE_NAME + " (" +
	                "id" + " integer primary key autoincrement, " +
	                "characterName" + " text not null, " +
	                "statCourage" + " integer, " +
	                "statWisdom" + " integer, " +
	                "statCharisma" + " integer, " +
	                "statIntuition" + " integer, " +
	                "talentCallElementalServant" + " integer, " +
	                "talentCallDjinn" + " integer, " +
	                "talentCallMasterOfElement" + " integer, " +
	                "talentedFire" + " bool, " +
	                "talentedWater" + " bool, " +
	                "talentedLife" + " bool, " +
	                "talentedIce" + " bool, " +
	                "talentedStone" + " bool, " +
	                "talentedAir" + " bool, " +
	                "talentedDemonic" + " integer, " +
	                "knowledgeFire" + " bool, " +
	                "knowledgeWater" + " bool, " +
	                "knowledgeLife" + " bool, " +
	                "knowledgeIce" + " bool, " +
	                "knowledgeStone" + " bool, " +
	                "knowledgeAir" + " bool, " +
	                "knowledgeDemonic" + " integer, " +
	                "affinityToElementals" + " bool, " +
	                "demonicCovenant" + " bool, " +
	                "cloakedAura" + " bool, " +
	                "weakPresence" + " integer, " +
	                "strengthOfStigma" + " integer);";
	private static final String DATABASE_NAME = "DSA_Summons_Database";

    DSA_Summons_Elements_Database(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(CHARACTERS_TABLE_CREATE);
    }

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		// TODO Auto-generated method stub
		
	}
}