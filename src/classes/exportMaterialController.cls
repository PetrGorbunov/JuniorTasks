public with sharing class exportMaterialController {
	public List<Raw_material__c> materials { 
		get {
			if (materials == null) {
				materials = new List<Raw_material__c>();
			}
				return materials;
		}
		set;
	}
	
	public exportMaterialController() {
		Id storeId = ApexPages.currentPage().getParameters().get('storeId');
		materials = [SELECT Name, Name__c, Quality__c, Amount__c, Made_in__c, Enter_date__c
					 FROM Raw_material__c					 
					 WHERE Store__c = :storeId
					 LIMIT 1000];
	}
}