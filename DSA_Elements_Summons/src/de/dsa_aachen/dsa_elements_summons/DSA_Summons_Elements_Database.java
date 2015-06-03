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
        "characterClass" + " integer, " +
        //"characterEquipmentModifier" + " integer, " +
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
        characterClass("characterClass",2),
        /*characterEquipmentModifier("characterEquipmentModifier",3),
        statCourage("statCourage",4),
        statWisdom("statWisdom",5),
        statCharisma("statCharisma",6),
        statIntuition("statIntuition",7),
        talentCallElementalServant("talentCallElementalServant",8),
        talentCallDjinn("talentCallDjinn",9),
        talentCallMasterOfElement("talentCallMasterOfElement",10),
        talentedFire("talentedFire",11),
        talentedWater("talentedWater",12),
        talentedLife("talentedLife",13),
        talentedIce("talentedIce",14),
        talentedStone("talentedStone",15),
        talentedAir("talentedAir",16),
        talentedDemonic("talentedDemonic",17),
        knowledgeFire("knowledgeFire",18),
        knowledgeWater("knowledgeWater",19),
        knowledgeLife("knowledgeLife",20),
        knowledgeIce("knowledgeIce",21),
        knowledgeStone("knowledgeStone",22),
        knowledgeAir("knowledgeAir",23),
        knowledgeDemonic("knowledgeDemonic",24),
        affinityToElementals("affinityToElementals",25),
        demonicCovenant("demonicCovenant",26),
        cloakedAura("cloakedAura",27),
        weakPresence("weakPresence",28),
        strengthOfStigma("strengthOfStigma",29);*/
        statCourage("statCourage",3),
        statWisdom("statWisdom",4),
        statCharisma("statCharisma",5),
        statIntuition("statIntuition",6),
        talentCallElementalServant("talentCallElementalServant",7),
        talentCallDjinn("talentCallDjinn",8),
        talentCallMasterOfElement("talentCallMasterOfElement",9),
        talentedFire("talentedFire",10),
        talentedWater("talentedWater",11),
        talentedLife("talentedLife",12),
        talentedIce("talentedIce",13),
        talentedStone("talentedStone",14),
        talentedAir("talentedAir",15),
        talentedDemonic("talentedDemonic",16),
        knowledgeFire("knowledgeFire",17),
        knowledgeWater("knowledgeWater",18),
        knowledgeLife("knowledgeLife",19),
        knowledgeIce("knowledgeIce",20),
        knowledgeStone("knowledgeStone",21),
        knowledgeAir("knowledgeAir",22),
        knowledgeDemonic("knowledgeDemonic",23),
        affinityToElementals("affinityToElementals",24),
        demonicCovenant("demonicCovenant",25),
        cloakedAura("cloakedAura",26),
        weakPresence("weakPresence",27),
        strengthOfStigma("strengthOfStigma",28);
		
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