public class BuyProductController {
	private Id productID;
    
    public Product__c product {get; set;} 
    public Contacts__c contact { 
        get { if (contact == null) 
                    contact = new Contacts__c ();
              return contact;
            }
        set;
    }    
    public Discount__c discountFromPage { 
        get { if (discountFromPage == null) 
                    discountFromPage = new Discount__c ();
              return discountFromPage;
            }
        set;
    }    
    private Contacts__c contactFromBase {get; set;}
    private Discount__c autoDiscount {get; set;}
    public Boolean isAutoDiscount {get; set;}
    public String costResult {get; set;}
    
    public BuyProductController() {
        productID = ApexPages.currentPage().getParameters().get('Id');
        product = [SELECT Id,
                  		  Name,
                   		  Amount__c,
                   		  Title__c,
                          Description__c,
                   		  Image__c,
                   		  Cost__c
                   FROM Product__c
                   WHERE Id = :productID
                   LIMIT 1];
        
        checkDiscount();        
    }
    
    public PageReference buyProduct() {
		
        if (!checkInputData()) {
            return null;
        }
        
        String newPageUrl;
        if (product.Amount__c < 1) {            
            newPageUrl = '/apex/Shop' + '?errorMessage=' + 'Amount ' + product.Name + '  < 1';
        } else {
            product.Amount__c -= 1;
            createNewSoldProduct(); 
            if (isAutoDiscount) {
               newPageUrl = '/apex/BuyOk' + '?ProductId=' + product.Id + '&DiscountId=' + autoDiscount.Id; 
            } else {
               discountFromPage = DiscountSupport.getMaxDiscountFromList(DiscountSupport.getDiscountByCode(discountFromPage.Discount_Code__c), 
                                                                         product.Cost__c);
               newPageUrl = '/apex/BuyOk' + '?ProductId=' + product.Id + '&DiscountId=' + discountFromPage.Id; 
            }          
        } 
        return goToNextPage(newPageUrl);
    }
    
    public void contactCheck() {        

        contactFromBase = new Contacts__c();
        try {
        contactFromBase = [SELECT Id,
                                  E_Mail__c,
                           		  Name,
                                  Address__c,
                                  Phone__c
                           FROM Contacts__c
                           WHERE E_Mail__c = :contact.E_Mail__c AND
                           		 E_Mail__c != NULL
                           LIMIT 1];
        } catch(Exception e) {        	
            contact.Name = '';
            contact.Address__c = '';
            contact.Phone__c = '';
            return;
        }    
        contact.Name = contactFromBase.Name;  
        contact.Address__c = contactFromBase.Address__c; 
        contact.Phone__c = contactFromBase.Phone__c;
    }
     
    private void checkDiscount() {
        Id userId = System.UserInfo.getUserId();
        Account account = new Account();
        User user = new User(); 

        account = [SELECT Id
                   FROM Account
                   WHERE Id IN (SELECT AccountId FROM User WHERE Id = :userId)
                   LIMIT 1];        
        
        List <Discount__c> discounts = new List <Discount__c>();
        discounts = DiscountSupport.getDiscountByAccId(account.Id);        
        Decimal costBeforeDisc;
        if (discounts.size() > 0) {
            isAutoDiscount = true;
            autoDiscount = DiscountSupport.getMaxDiscountFromList(discounts, product.Cost__c);
            costBeforeDisc = DiscountSupport.calculateCostAfterDiscount(autoDiscount, product.Cost__c);            
        	costResult = 'Your primary cost: ' + String.valueOf(costBeforeDisc) + '. Cost for all: ' + String.valueOf(product.Cost__c);
        } else {
            isAutoDiscount = false;
            costResult = 'Cost: ' + String.valueOf(product.Cost__c);
        }        
    }
   
    private PageReference goToNextPage(String url) {
        PageReference ref = new PageReference(url);
        ref.setRedirect(true);  
        return ref;
    }
    
    private void createNewSoldProduct() {
        Product__c newProduct = new Product__c();
        newProduct = product.clone(false, true, false, false);
        newProduct.Amount__c = 1;
        
        RecordType productRecordType = [SELECT id,
                                        	   Name 
                                        FROM RecordType 
                                        WHERE SobjectType='Product__c' AND 
                                              Name='Sold' 
                                        LIMIT 1];   
        
        newProduct.RecordTypeId = productRecordType.Id;
        insert newProduct;
    }
    
    private Boolean checkInputData() {
         Boolean result;
         try {
             if (contact.E_Mail__c != contactFromBase.E_Mail__c && contact.E_Mail__c != null) {
                 if (contact.Name == null) {
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Enter name!')); 
                     result = false;
                 } else {
                     insert contact;
                 }
             } else if (contact.Name != contactFromBase.Name) {
                 contactFromBase.Name = contact.Name;
                 update contactFromBase;
             }
             result = true;
         } catch(Exception e) { 
         	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error input data!'));   
            result = false;     
         }
         return result; 
    }
    
}