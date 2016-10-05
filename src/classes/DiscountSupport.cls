public class DiscountSupport {
	
    public static List<Discount__c> getDiscountByCode(String code) {
        List <Discount__c> resultDiscounts = new List <Discount__c>();        
        if ((code == null) || (code == '')) {
            return resultDiscounts;
        } 
        
        try {
            DateTime currentDateTime = Datetime.now();
            resultDiscounts = [SELECT    Id,
                                         Name,
                                         Discount_Code__c,
                                         Percentes_of__c,
                                         Static_discount__c,
                               			 Start_period__c,
                               			 End_period__c
                               FROM Discount__c
                               WHERE Discount_Code__c = :code AND
                              		 Start_period__c != null AND
                              		 End_period__c != null AND
                              		 Start_period__c <= :currentDateTime AND
                                     End_period__c >= :currentDateTime]; 
        } catch(Exception e) {  
         	System.debug('Not discount');
        }
        return resultDiscounts;
    } 
    
    public static List<Discount__c> getDiscountByAccId(Id accId) {
        List <Discount__c> resultDiscounts = new List <Discount__c>(); 
        try {
            DateTime currentDateTime = Datetime.now();
            resultDiscounts = [SELECT  Id,
                                       Name,
                                       Discount_Code__c,
                                       Percentes_of__c,
                                       Static_discount__c,
                                       Account__c,
                               		   Start_period__c,
                               		   End_period__c
                               FROM Discount__c
                               WHERE Account__c = :accId /*AND
                              		 Start_period__c != null AND
                              		 End_period__c != null AND
                              		 Start_period__c <= :currentDateTime AND
                                     End_period__c >= :currentDateTime*/];    

        } catch(Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You do not have autodiscount. Enter promocode'));                
        }
        return resultDiscounts;
    }
    
    public static Discount__c getMaxDiscountFromList(List<Discount__c> discounts, Decimal cost) {
        Discount__c resultDiscount = new Discount__c();
        if (discounts.size() < 1 || cost <= 0) {
            return resultDiscount;
        }

        Decimal minCost = cost;
        Decimal currentCost;
        for (Discount__c currentDiscount : discounts) {
            currentCost = calculateCostAfterDiscount(currentDiscount, cost);            
            if ((currentCost < minCost) && (currentCost > 0)) {
                minCost = currentCost;
                resultDiscount = currentDiscount;
            }
        }
        return resultDiscount;
    }
    
    public static Decimal calculateCostAfterDiscount(Discount__c dicount, Decimal cost) {
        dicount.Percentes_of__c = (dicount.Percentes_of__c == null) ? 0 : dicount.Percentes_of__c;
        dicount.Static_discount__c = (dicount.Static_discount__c == null) ? 0 : dicount.Static_discount__c;        
        return (cost - (cost * dicount.Percentes_of__c / 100)) - dicount.Static_discount__c; 
    }
    
    public static String getTimeDiscountEnd(Datetime endTime) {
        Long discountTimeMs = (endTime.getTime() - DateTime.now().getTime()); 
        String days = String.valueOf((discountTimeMs / (1000 * 60 * 60 * 24)).intValue()) + ' days';
        String hours = String.valueOf((discountTimeMs / (1000 * 60 * 60)).intValue()) + ' hours';
        
        return (discountTimeMs / (1000 * 60 * 60 * 24) > 1) ? days : hours;       
    }
    
}