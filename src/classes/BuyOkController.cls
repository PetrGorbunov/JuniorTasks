public class BuyOkController {

    private Id productId;
    private Id discountId;
    public Product__c product {get; set;} 
    public Discount__c discount {
        get { if (discount == null) 
                    discount = new Discount__c ();
              return discount;
            }
        set;}
    
    
    public BuyOkController() {        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Hello')); 
        productId = ApexPages.currentPage().getParameters().get('ProductId');
        product = [SELECT Name,
                   		  Cost__c
                   FROM Product__c
                   WHERE Id = :productId
                   LIMIT 1];
        
        try {
            discountId = ApexPages.currentPage().getParameters().get('DiscountId');
            discount = [SELECT Name,
                               Discount_Code__c,
                               Percentes_of__c,
                               Static_discount__c
                        FROM Discount__c
                        WHERE Id = :discountId
                        LIMIT 1];
            
            //activeDiscount();
            product.Cost__c = DiscountSupport.calculateCostAfterDiscount(discount, product.Cost__c);
        } catch(Exception e) {
            discount.Percentes_of__c = 0;
			      discount.Static_discount__c = 0;         
        }


        //sendEmail();
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Start sendEmail')); 
        Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[] {'customuser16092016@gmail.com'};
        String[] ccAddresses = new String[] {'support@gorbunov-shop-comm-developer-edition.ap2.force.com'};

        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);

        mail.setReplyTo('customuser17092016@gmail.com');
        mail.setSenderDisplayName('gorbunov-shop-comm-developer-edition.ap2.force.com support');
        mail.setSubject('You bought new product : ' );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody('Your Product: ' +' has been created.'); 
        mail.setHtmlBody('Your case:<b> ' +' </b>has been created.<p>');

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        
    }
    
    //private void activeDiscount() {        
    //    discount.Percentes_of__c = (discount.Percentes_of__c == null) ? 0 : discount.Percentes_of__c;
    //    discount.Static_discount__c = (discount.Static_discount__c == null) ? 0 : discount.Static_discount__c;
    //    product.Cost__c = product.Cost__c - (product.Cost__c * discount.Percentes_of__c / 100);
    //    product.Cost__c = product.Cost__c - discount.Static_discount__c; 
    //}

    private void sendEmail() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Start sendEmail')); 
        Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[] {'customuser16092016@gmail.com'};
        String[] ccAddresses = new String[] {'support@gorbunov-shop-comm-developer-edition.ap2.force.com'};

        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);

        mail.setReplyTo('customuser17092016@gmail.com');
        mail.setSenderDisplayName('gorbunov-shop-comm-developer-edition.ap2.force.com support');
        mail.setSubject('You bought new product : ' );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody('Your Product: ' +' has been created.'); 
        mail.setHtmlBody('Your case:<b> ' +' </b>has been created.<p>');

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }
}