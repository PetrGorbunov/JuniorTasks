public class productExtension {
    
    private Id productID;
    public Product__c product {get; set;} 
    
    public productExtension() {
        productID = ApexPages.currentPage().getParameters().get('Id');
        product = [SELECT Id,
                  		  Name,
                   		  Amount__c,
                   		  Title__c,
                          Description__c,
                   		  Image__c
                   FROM Product__c
                   WHERE Id = :productID
                   LIMIT 1];
    }
    
}