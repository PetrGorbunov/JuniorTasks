public class DiscountSupport {
	
    public static List<Discount__c> getDiscountByCode(String code) {
        List <Discount__c> resultDiscounts = new List <Discount__c>();        
        if ((code == null) || (code == '')) {
            return resultDiscounts;
        } 
        
        try {
            resultDiscounts = [SELECT    Id,
                                         Name,
                                         Discount_Code__c,
                                         Percentes_of__c,
                                         Static_discount__c  
                               FROM Discount__c
                               WHERE Discount_Code__c = :code]; 
        } catch(Exception e) {  
         	System.debug('Not discount');
        }
        return resultDiscounts;
    } 
    
    public static List<Discount__c> getDiscountByAccId(Id accId) {
        List <Discount__c> resultDiscounts = new List <Discount__c>(); 
        try {
            resultDiscounts = [SELECT  Id,
                                       Name,
                                       Discount_Code__c,
                                       Percentes_of__c,
                                       Static_discount__c,
                                       Account__c
                               FROM Discount__c
                               WHERE Account__c = :accId];    

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
    
}