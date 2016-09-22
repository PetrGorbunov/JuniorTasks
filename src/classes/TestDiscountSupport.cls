@isTest
private class TestDiscountSupport {
	
	@isTest static void testGetDiscountByCodeNull() {
		//get discounts list
		List <Discount__c> discounts = new List <Discount__c>();
		discounts = DiscountSupport.getDiscountByCode(null);

		//test condition
		System.assert(discounts.size() == 0);
	}

	@isTest static void testGetDiscountByTrueCode() {
		//Creating test data
		String promoCode = 'disc1';
		Integer discountNumber = 10;
		for(Integer i = 1; i <= discountNumber; i++) {
			Discount__c discount = new Discount__c();
			discount.Name = 'disc' + i;
			discount.Discount_Code__c = promoCode;
			discount.Percentes_of__c = i;
			discount.Static_discount__c = i;
			insert discount;
		}
		Discount__c discount = new Discount__c();
		discount.Name = 'disc';
		discount.Discount_Code__c = 'falsePromoCode';
		discount.Percentes_of__c = 1;
		discount.Static_discount__c = 1;
		insert discount;

		//get discounts list
		List <Discount__c> discounts =  new List <Discount__c>();
		discounts = DiscountSupport.getDiscountByCode(promoCode);

		//test condition
		for (Discount__c d : discounts) {
			System.assert(d.Discount_Code__c == promoCode);
		}
		System.assert(discounts.size() == discountNumber);
	}

	@isTest static void testGetDiscountByFalseCode() {
		String truePromoCode = 'true';
		String falsePromoCode = 'false';

		//Creating test data
		Discount__c discount = new Discount__c();
		discount.Name = 'disc';
		discount.Discount_Code__c = truePromoCode;
		discount.Percentes_of__c = 1;
		discount.Static_discount__c = 1;
		insert discount;

		//get discounts list		
		List <Discount__c> discounts =  new List <Discount__c>();
		discounts = DiscountSupport.getDiscountByCode(falsePromoCode);

		//test condition
		System.assert(discounts.size() == 0);
	}
	
}