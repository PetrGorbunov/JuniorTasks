public class StoreSupport {

	public static Store__c getStore(Date currentDate) {

	   List<Store__c> stores = [SELECT Id,
                                       Name
                                FROM Store__c 
                                WHERE Start_period__c <= :currentDate AND
                               		  End_period__c >= :currentDate];
        if (stores.size() == 0) {
            currentDate = System.today();
            ReportPeriodTime__c reportPeriod = ReportPeriodTime__c.getInstance('MainPeriod');			
            Store__c newStore = new Store__c();
            //Integer days = (Integer.valueOf(reportPeriod.Days__c) == null) ? 1 : Integer.valueOf(reportPeriod.Days__c);
            Integer days = 1;
            newStore.Name = String.valueOf(System.currentTimeMillis());
            newStore.End_period__c = currentDate + days;
            newStore.Start_period__c = currentDate;
            insert newStore;            
            return newStore;
        }      
        return stores.get(0); 
	}
    
    /*public static void writeAll(List<Object> currentList) {
        System.debug('from write all:' + currentList.size());
        map<Id,Store__c> storeMap = new map<Id,Store__c>([Select Id, Start_period__c, End_period__c From Store__c ]);
    }*/
    
}