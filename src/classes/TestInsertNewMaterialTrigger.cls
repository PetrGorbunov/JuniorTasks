@isTest
private class TestInsertNewMaterialTrigger {
	
	@isTest static void test_TestInsertNewMaterialTrigger_withoutDate() {
        //Creating test data
		Raw_material__c material = new Raw_material__c(Name = 'material',
                                                       Name__c = 'material');        
		
        //starting trigger
        insert material;
        Store__c store = [SELECT Id,
                          		 Start_period__c
                          FROM Store__c
                         ];
        
        //test condition
		System.assert(store.Start_period__c == System.today());
	}
    
}