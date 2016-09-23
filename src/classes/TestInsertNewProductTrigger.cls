@isTest
private class TestInsertNewProductTrigger {
	
	@isTest static void test_InsertNewProductTrigger_withoutDate() {
        //Creating test data
        /*Store__c store = new Store__c(Name = 'Store',
                                      Start_period__c = System.today() - 20,
                                      End_period__c = System.today() -10 );*/
        /*insert store;*/
	    Product__c product = new Product__c(Name='nullDate');        
		
        //starting trigger
        insert product;
        Store__c store = [SELECT Id,
                          		Start_period__c
                          FROM Store__c];
        
        //test condition
	    System.assert(store.Id != null);        
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

    @isTest static void test_InsertNewProductTrigger_ManyRecords() {
        //Creating test data
        Store__c store = new Store__c(Name = 'Store',
                                      Start_period__c = System.today() - 1,
                                      End_period__c = System.today() + 1 );
        insert store;

        List <Product__c> products = new List<Product__c>();
        for( Integer i = 1; i <= 800; i++) {
            Product__c product = new Product__c(Name = 'productName' + i,
                                                Enter_date__c = System.today() + i);
            products.add(product);
        }
        insert products;
        //starting trigger
        //insert products;
        List <Product__c> productsFromBase = new List<Product__c>();
        productsFromBase = [SELECT Id
                            FROM Product__c];

        //test condition
        System.assert(products.size() == productsFromBase.size());
  }
	
		
}