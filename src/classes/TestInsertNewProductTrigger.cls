@isTest
private class TestInsertNewProductTrigger {
	
	@isTest static void test_InsertNewProductTrigger_withoutDate() {
        //Creating test data
		Product__c product = new Product__c(Name='nullDate');        
		
        //starting trigger
        insert product;
        Store__c store = [SELECT Id,
                          		 Start_period__c
                          FROM Store__c
                         ];
        
        //test condition
		System.assert(store.Start_period__c == System.today());        
	}
    
    @isTest static void test_InsertNewProductTrigger_withDate() {
        //Creating test data
        String productName = 'withDate';
        Store__c store = new Store__c(Name = 'StorewithDate',
                                      Start_period__c = System.today() - 1,
                                      End_period__c = System.today() + 1 );
        insert store;        
		Product__c product = new Product__c(Name = productName,
                                           	Enter_date__c = System.today());     
        
        //starting trigger
		insert product;
        Product__c productFromBase = [SELECT Store__c
                                      FROM Product__c
                                      WHERE Name = :productName];
        
        //test condition
		System.assert(store.Id == productFromBase.Store__c);
	}
	
		
}