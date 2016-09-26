@isTest
private class TestInsertNewProductTrigger {
	
    @isTest static void test_InsertNewProductTrigger_ManyRecords() {  
        //test data
        List <Product__c> products = new List<Product__c>();
        Integer productNum = 3000;               
        for( Integer i = 1; i < productNum; i++) {
            Product__c product = new Product__c(Name = 'productName' + i);
            products.add(product);
        }
        
        //starting trigger
        insert products;
        List <Product__c> productsFromBase = new List<Product__c>();
        productsFromBase = [SELECT Id
                            FROM Product__c];

        List<Store__c> stores = [SELECT Id
                                 FROM Store__c];

        //test conditions
        Integer productMaxInStore = 100; 
        System.debug('stores.size()=' + stores.size());
        System.debug('productsFromBase.size()=' + productsFromBase.size());
        System.assert(stores.size() == productNum/productMaxInStore);
        System.assert(products.size() == productsFromBase.size());
  }	
		
}