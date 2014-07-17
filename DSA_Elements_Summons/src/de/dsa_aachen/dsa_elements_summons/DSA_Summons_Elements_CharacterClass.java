package de.dsa_aachen.dsa_elements_summons;

public class DSA_Summons_Elements_CharacterClass {
	public static enum Classes{
		Mage(0,R.array.str_ClassesArray,R.string.str_EquipmentMage1,R.string.str_EquipmentMage2),
		Druid(1,R.array.str_ClassesArray,R.string.str_EquipmentDruid1,R.string.str_EquipmentDruid2),
		Geode(2,R.array.str_ClassesArray,R.string.str_EquipmentDruid1,R.string.str_EquipmentDruid2),
		Cristalomant(3,R.array.str_ClassesArray,R.string.str_EquipmentCristalomant1,R.string.str_EquipmentCristalomant2),
		Shaman(4,R.array.str_ClassesArray,R.string.str_EquipmentShaman1,R.string.str_EquipmentShaman2);
		private int dbId;
		private int classNameArrayId;
		private int firstEquipmentId;
		private int secondEquipmentId;
		private Classes(int dbId, int classNameArrayId, int firstEquipmentId, int secondEquipmentId){
			setDbId(dbId);
			setFirstEquipmentId(firstEquipmentId);
			setSecondEquipmentId(secondEquipmentId);
		}
		public static Classes getById(int id) {
		    for(Classes c : values()) {
		        if(c.dbId == id) return c;
		    }
		    return null;
		 }
		public int getDbId() {
			return dbId;
		}
		public void setDbId(int dbId) {
			this.dbId = dbId;
		}
		public int getClassNameArrayId() {
			return classNameArrayId;
		}
		public void setClassNameArrayId(int classNameArrayId) {
			this.classNameArrayId = classNameArrayId;
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
