public class StoreSupport {
	
    public static void associateWithStore(Type objectType, List<sObject> inputList) {        
        String fieldStoreRef = 'Store__c';
        Map<Id, Store__c> storesMapFromDB = new Map<Id, Store__c>(); 
        storesMapFromDB = getStoresFromDB();
    	
        Map<Id, Integer> storesMap = new Map<Id, Integer>();
        for(Store__c store : storesMapFromDB.values()) {
            storesMap.put(store.Id, 0);
        }        
       
        List<sObject> objectsListFromDB = new List<sObject>();
        if (objectType == Product__c.class) {           
            objectsListFromDB = getProductsFromDB();            
        } else if (objectType == Raw_material__c.class) {            
            objectsListFromDB = getMaterialFromDB();
        }        
        
        for (sObject currentObject : objectsListFromDB) {
            Id storeId = (Id)currentObject.get(fieldStoreRef);
            if(storesMapFromDB.get(storeId) != null){
                storesMap.put(storeId, storesMap.get(storeId) + 1);
            }	   
        }
        
        //Main logic
        List<Store__c> storesForInsert = new List <Store__c>();
        Integer StoreMaxRecords = 100;
        String fieldEnterDate = 'Enter_date__c';//One name for Raw_material__c and Product__c
        for (sObject currentObject : inputList) {             
            currentObject.put(fieldEnterDate, System.today()); 
            for (Store__c store : storesMapFromDB.values()) {
                Date enterDate = Date.valueOf(currentObject.get(fieldEnterDate));
                if (enterDate >= store.Start_period__c && 
                    enterDate <= store.End_period__c &&
                    storesMap.get(store.Id) < StoreMaxRecords) {                        
                        currentObject.put(fieldStoreRef, store.Id);
                        storesMap.put(store.Id, storesMap.get(store.Id) + 1);
                }
            }
    		
            if ((Id)currentObject.get(fieldStoreRef) == null) {
                Store__c newStore = new Store__c();
                newStore = createStore(Date.valueOf(currentObject.get(fieldEnterDate)));                                
                storesForInsert.add(newStore);
                storesMapFromDB.put(newStore.Id, newStore);
                storesMap.put(newStore.Id, 1);                
                currentObject.put(fieldStoreRef, newStore.Id);
            }		 
        }        
        
        Map<Id,Id> replaceFakeId = new Map<Id, Id>();
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
        
        for (sObject currentObject : inputList) {  
            Id storeId = (Id)currentObject.get(fieldStoreRef);
            if (replaceFakeId.get(storeId) != null) {
                currentObject.put(fieldStoreRef, replaceFakeId.get(storeId));
            }
        }   
    }
    
    
    private static Map<Id, Store__c> getStoresFromDB() {
        Map<Id, Store__c> storesMapFromDB = new Map<Id, Store__c>([SELECT Id,
                                                                          Name,
                                                                          Start_period__c,
                                                                          End_period__c
                                                                   FROM Store__c
                                                                   WHERE Start_period__c != null OR
                                                                         End_period__c != null]);
        return storesMapFromDB;
    }
    
    private static List<sObject> getProductsFromDB() {
        List<sObject> productListFromDB = new List<Product__c>([SELECT Store__c
                                                                FROM Product__c
                                                                WHERE Store__c != null]);
        return productListFromDB;
    } 
    
    private static List<sObject> getMaterialFromDB () {
        List<sObject> materialListFromDB = new List<Raw_material__c> ([SELECT Store__c
                                                                       FROM Raw_material__c
                                                                       WHERE Store__c != null]); 
        return materialListFromDB;
    } 
    
    private static Store__c createStore(Date enterDate) {
        Store__c store = new Store__c();
        store.Name = String.valueOf(System.currentTimeMillis());
        store.Start_period__c =enterDate;
        store.End_period__c = enterDate + 1;
        store.Id = TestUtility.getFakeId(Store__c.SObjectType);  
        return store;
    }
    
}