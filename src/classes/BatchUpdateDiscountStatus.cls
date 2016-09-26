global class BatchUpdateDiscountStatus implements Database.Batchable<sObject> {

	global final String Query;
    global BatchUpdateDiscountStatus(String q) {
        Query = q;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Sobject> scope) {
        List <Discount__c> discounts = new List<Discount__c>();
        DateTime currentDateTime = Datetime.now();

        for(Sobject currentObject : scope) {
            Discount__c discount = (Discount__c)currentObject;
            if (discount.Start_period__c == null || 
            	discount.End_period__c == null || 
            	discount.End_period__c < discount.Start_period__c) {
        		continue;
            }

            if (discount.Start_period__c > currentDateTime) {
            	discount.Status_discount__c = 'Not started';            	
            } else if (discount.End_period__c < currentDateTime) {
            	discount.Status_discount__c = 'Ended'; 
            } else {
            	discount.Status_discount__c = 'Active';
            }
            discounts.add(discount);
        }
        update discounts;
    }

    global void finish(Database.BatchableContext BC) {
        //Send email after batch completes
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'piotrgorbunov@mail.ru'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Batch Job is done');
        mail.setPlainTextBody('The batch Apex job processed. All discounts use valid status.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}