trigger InsertNewProductTrigger on Product__c (before insert) {
    
	//###############################3
	//Map<Id, Date> dataMap = new Map<Id, Date>();
	//for (Product__c product : Trigger.new) {
	//	dataMap.put(product.Id, product.Enter_date__c);
	//}
	//StoreSupport.crazyMethod(dataMap);



    //################################2
    List<Product__c> products = Trigger.new;
    List<Product__c> productNoStoreId = new List<Product__c>();
    List<Store__c> stores = new List<Store__c>();
    try {
	   stores = [SELECT Id,
						Name,
						Start_period__c,
						End_period__c
				  FROM Store__c];
    } catch(Exception e) {
    	System.debug('stores is empty');
    }

    List<Store__c> storesForInsert = new List <Store__c>();
    /**/
    Store__c storeNull = new Store__c();
	storeNull.Name = String.valueOf(System.currentTimeMillis());
    storeNull.Start_period__c = null;
    storeNull.End_period__c = null;
    insert storeNull;  
    /**/
    //
    for (Product__c product : Trigger.new) {  
		if (product.Enter_date__c == null) {
			product.Store__c = storeNull.Id;
			continue;
		}
    	for (Store__c store : stores) {

    		if ((product.Enter_date__c >= store.Start_period__c) && 
			    (product.Enter_date__c <= store.End_period__c) &&
				 store.Id != null) {   
	    			product.Store__c = store.Id;
	    			break;
    		}    		
    	}

    	if (product.Store__c == null) {
    		Store__c newStore = new Store__c();
    		newStore.Name = String.valueOf(System.currentTimeMillis());
            newStore.Start_period__c = product.Enter_date__c;
            newStore.End_period__c = (product.Enter_date__c == null) ? null : product.Enter_date__c + 1;
            storesForInsert.add(newStore);
            stores.add(newStore);            
    	}
    }

    if (storesForInsert.size() > 0) {
    	insert storesForInsert;
    	for (Product__c product : Trigger.new) {
    		if (product.Store__c == null) {    			
    			for (Store__c store : storesForInsert) {
    				if ((product.Enter_date__c >= store.Start_period__c) && 
    					(product.Enter_date__c <= store.End_period__c)) {
    					product.Store__c = store.Id;
    					break;
    				}
    			}
    		}
    	}
    }

    
    //########################################################1
    //for (Product__c prod : Trigger.new) {
    //    Store__c store = StoreSupport.getStore(prod.Enter_date__c);        
    //    prod.Store__c = store.Id;        
    //}
   
}