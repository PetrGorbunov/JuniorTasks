global class SchedulerBatchUpdateDiscountStatus implements Schedulable {

	global void execute(SchedulableContext ctx) {
		String queryToBase = 'select Id, Start_period__c, End_period__c, Status_discount__c  from Discount__c';
      	BatchUpdateDiscountStatus batchUpdate = new BatchUpdateDiscountStatus(queryToBase);
        database.executeBatch(batchUpdate);
   }   

}