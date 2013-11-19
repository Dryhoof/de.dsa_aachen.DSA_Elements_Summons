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
	public static enum dbField {
		id("id",0),
        characterName("characterName",1),
        statCourage("statCourage",2),
        statWisdom("statWisdom",3),
        statCharisma("statCharisma",4),
        statIntuition("statIntuition",5),
        talentCallElementalServant("talentCallElementalServant",6),
        talentCallDjinn("talentCallDjinn",7),
        talentCallMasterOfElement("talentCallMasterOfElement",8),
        talentedFire("talentedFire",9),
        talentedWater("talentedWater",10),
        talentedLife("talentedLife",11),
        talentedIce("talentedIce",12),
        talentedStone("talentedStone",13),
        talentedAir("talentedAir",14),
        talentedDemonic("talentedDemonic",15),
        knowledgeFire("knowledgeFire",16),
        knowledgeWater("knowledgeWater",17),
        knowledgeLife("knowledgeLife",18),
        knowledgeIce("knowledgeIce",19),
        knowledgeStone("knowledgeStone",20),
        knowledgeAir("knowledgeAir",21),
        knowledgeDemonic("knowledgeDemonic",22),
        affinityToElementals("affinityToElementals",23),
        demonicCovenant("demonicCovenant",24),
        cloakedAura("cloakedAura",25),
        weakPresence("weakPresence",26),
        strengthOfStigma("strengthOfStigma",27);
		
		private String stringValue;
	    private int intValue;
        private dbField(String stringV, int value) {
        	setIntValue(value);
        	setStringValue(stringV);
        }
		public int getIntValue() {
			return intValue;
		}
		public void setIntValue(int intValue) {
			this.intValue = intValue;
		}
		public String getStringValue() {
			return stringValue;
		}
		public void setStringValue(String stringValue) {
			this.stringValue = stringValue;
		}
	}
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