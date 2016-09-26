@isTest
private class TestInsertNewMaterialTrigger {
	
	@isTest static void test_TestInsertNewMaterialTrigger_ManyRecords() {
        //test data
        List <Raw_material__c> materials = new List<Raw_material__c>();
        Integer materialNum = 4000;               
        for( Integer i = 1; i < materialNum; i++) {
            Raw_material__c material = new Raw_material__c(Name = 'productName' + i,
                                                          Name__c = 'Name__c');
            materials.add(material);
        }
        
        //starting trigger
        insert materials;
        List <Raw_material__c> materialsFromBase = new List<Raw_material__c>();
        materialsFromBase = [SELECT Id
                             FROM Raw_material__c];

        List<Store__c> stores = [SELECT Id
                                 FROM Store__c];

        
        //test conditions
        Integer materialMaxInStore = 100; 
        System.debug('stores.size()=' + stores.size());
        System.debug('productsFromBase.size()=' + materialsFromBase.size());
        System.assert(stores.size() == materialNum/materialMaxInStore);
        System.assert(materials.size() == materialsFromBase.size());
  }
    
}