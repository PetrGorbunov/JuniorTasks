trigger InsertNewProductTrigger on Product__c (before insert) {		
	
    List<sObject> productList = Trigger.new;
    StoreSupport.associateWithStore(Product__c.class, productList);
    
}