trigger InsertNewProductTrigger on Product__c (before insert) {
    
		
	Map<Id, Integer> storesMap = new Map<Id, Integer>();
	List<Store__c> storesList = new List<Store__c>([SELECT Id,
											               Name,
											               Start_period__c,
											               End_period__c
										        	FROM Store__c
										        	WHERE Start_period__c != null AND
										        	      End_period__c != null]);
	
	for (Store__c store : storesList) {
		storesMap.put(store.Id, 0);
	}

	List<Product__c> productsListFromDB = new List<Product__c>([SELECT Store__c
														        FROM Product__c
														        WHERE Store__c != null]);

	
	for (Store__c store : storesList) {
		for (Product__c product : productsListFromDB) {
			if (store.Id == product.Store__c) {
				storesMap.put(store.Id, storesMap.get(store.Id) + 1);				
			}
		}			
	}

	List<Store__c> storesForInsert = new List <Store__c>();
	Integer StoreMaxRecords = 100;
	for (Product__c product : Trigger.new) { 
		product.Enter_date__c = System.today();
		for (Store__c store : storesList) {			
			if (product.Enter_date__c >= store.Start_period__c && 
			    product.Enter_date__c <= store.End_period__c &&
			    storesMap.get(store.Id) < StoreMaxRecords) {
					product.Store__c = store.Id;
					storesMap.put(store.Id, storesMap.get(store.Id) + 1);
			}
		}

		if (product.Store__c == null) {
			Store__c newStore = new Store__c();
    		newStore.Name = String.valueOf(System.currentTimeMillis());
            newStore.Start_period__c = product.Enter_date__c;
            newStore.End_period__c = product.Enter_date__c + 1;
            
            
            newStore.Id = TestUtility.getFakeId(Store__c.SObjectType);//newStore.Name;
            storesForInsert.add(newStore);            
            storesList.add(newStore);
            storesMap.put(newStore.Id, 1);
            product.Store__c = newStore.Id;
		}		 
	}
	Map<Id,Id> replaceFakeId = new Map<Id, Id>();//initial Map<fakeId,trueId>
	for(Store__c store : storesForInsert) {
		replaceFakeId.put(store.Id, null);
		store.Id = null;
	}
	
	insert storesForInsert;

	Integer iter = 0;
	for (Id fakeId : replaceFakeId.keySet()) {
		replaceFakeId.put(fakeId, storesForInsert.get(iter).Id);
		iter++;        
    }
    
    for (Product__c product : Trigger.new) {    	
    	if (replaceFakeId.get(product.Store__c) != null) {
    		product.Store__c = replaceFakeId.get(product.Store__c);
    	}
    }   
}