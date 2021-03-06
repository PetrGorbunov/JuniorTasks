public class ShopController {
    public List<Product__c> products {get; set;}
    public string productUrl;
    private String errorMessage;
    
    public ShopController() {
        getProducts('');
        
        errorMessage = ApexPages.currentPage().getParameters().get('errorMessage');
        if (errorMessage != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage)); 
        }
    }
    
    public void searchProduct() {
        String searchName = Apexpages.currentPage().getParameters().get('searchName'); 
        getProducts(searchName);        
    }
    
    private void getProducts(String searchName) {
        searchName = '%' + String.escapeSingleQuotes(searchName) + '%';
        products = [SELECT Id,
                    	   Name,
                           Title__c,
                           Description__c,
                           Cost__c,
                    	   Image__c
                    FROM Product__c
                    WHERE RecordTypeId NOT IN (SELECT Id FROM RecordType WHERE SobjectType='Product__c' AND Name='Sold') AND
                          Name LIKE :searchName
                    LIMIT 200];
        for( Product__c prod: products ) {
            if (prod.Description__c.length() > 100) {
                productUrl = '/apex/product?Id=' + prod.Id;
                prod.Description__c = prod.Description__c.substring(1, 100) + '...<a href="' + productUrl + '">more details</a>';
            }
        }
    }
}