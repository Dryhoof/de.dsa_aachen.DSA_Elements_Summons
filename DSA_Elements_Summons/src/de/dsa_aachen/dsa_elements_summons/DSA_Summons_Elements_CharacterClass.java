package de.dsa_aachen.dsa_elements_summons;

public class DSA_Summons_Elements_CharacterClass {
	private static enum Classes{
		Mage(0,R.string.str_Mage,R.string.str_EquipmentMage1,R.string.str_EquipmentMage2),
		Druid(1,R.string.str_Druid,R.string.str_EquipmentDruid1,R.string.str_EquipmentDruid2),
		Geode(2,R.string.str_Geode,R.string.str_EquipmentDruid1,R.string.str_EquipmentDruid2),
		Cristalomant(3,R.string.str_Cristalomant,R.string.str_EquipmentCristalomant1,R.string.str_EquipmentCristalomant2),
		Shaman(4,R.string.str_Shaman,R.string.str_EquipmentShaman1,R.string.str_EquipmentShaman2);
		private int dbId;
		private int classNameId;
		private int firstEquipmentId;
		private int secondEquipmentId;
		private Classes(int dbId, int classNameId, int firstEquipmentId, int secondEquipmentId){
			setDbId(dbId);
			setClassNameId(classNameId);
			setFirstEquipmentId(firstEquipmentId);
			setSecondEquipmentId(secondEquipmentId);
		}

		public int getDbId() {
			return dbId;
		}
		public void setDbId(int dbId) {
			this.dbId = dbId;
		}
		public int getClassNameId() {
			return classNameId;
		}
		public void setClassNameId(int classNameId) {
			this.classNameId = classNameId;
		}
		public int getFirstEquipmentId() {
			return firstEquipmentId;
		}
		public void setFirstEquipmentId(int firstEquipmentId) {
			this.firstEquipmentId = firstEquipmentId;
		}
		public int getSecondEquipmentId() {
			return secondEquipmentId;
		}
		public void setSecondEquipmentId(int secondEquipmentId) {
			this.secondEquipmentId = secondEquipmentId;
		}
		
	}
}
