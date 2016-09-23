trigger InsertNewProductTrigger on Product__c (before insert) {
    
    /*StoreSupport.writeAll(Trigger.new);*/
    
    for (Product__c prod : Trigger.new) {
        Store__c store = StoreSupport.getStore(prod.Enter_date__c);        
        prod.Store__c = store.Id;        
    }
   
}