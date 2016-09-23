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
			insert discount;
		}
		Discount__c discount = new Discount__c();
		discount.Name = 'disc';
		discount.Discount_Code__c = 'falsePromoCode';
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
		insert discount;

		//get discounts list		
		List <Discount__c> discounts =  new List <Discount__c>();
		discounts = DiscountSupport.getDiscountByCode(falsePromoCode);

		//test condition
		System.assert(discounts.size() == 0);
	}
	
	@isTest static void testGetDiscountByAccId() {
		//Creating test data		
		Account account = new Account(Name = 'Acc');
		insert account;

		Discount__c discWithAcc = new Discount__c();
		discWithAcc.Name = 'discWithAcc';
		discWithAcc.Account__c = account.Id;
		insert discWithAcc;

		Discount__c discWithoutAcc = new Discount__c();
		discWithoutAcc.Name = 'discWithoutAcc';
		discWithoutAcc.Account__c = null;
		insert discWithoutAcc;

		//get discounts list
		List <Discount__c> discounts =  new List <Discount__c>();
		discounts = DiscountSupport.getDiscountByAccId(account.Id);

		//test condition
		System.assert(discounts.get(0).Id == discWithAcc.Id);
	}

	@isTest static void testGetMaxDiscountFromList() {
		//Creating test data
		List <Discount__c> discounts =  new List <Discount__c>();
		Decimal cost = 100;

		//--Max discount object
		String maxDiscountName = 'maxDiscountName';
		Discount__c discOne = new Discount__c();
		discOne.Name = maxDiscountName;
		discOne.Percentes_of__c = 80;
		discOne.Static_discount__c = 1;
		discounts.add(discOne);

		Discount__c discTwo = new Discount__c();
		discTwo.Name = 'discTwo';
		discTwo.Percentes_of__c = 10;
		discTwo.Static_discount__c = 1;
		discounts.add(discTwo);

		Discount__c discThree = new Discount__c();
		discThree.Name = 'discThree';
		discThree.Percentes_of__c = 0;
		discThree.Static_discount__c = cost + 1;
		discounts.add(discThree);

		//get max discount		
		Discount__c discountMax = new Discount__c();
		discountMax = DiscountSupport.getMaxDiscountFromList(discounts, cost);

		//test condition
		System.assert(discountMax.Name == maxDiscountName);

	}

	@isTest static void test_GetMaxDiscountFromList_WhereCostIsZero() {
		//Creating test data
		List <Discount__c> discounts =  new List <Discount__c>();
		Decimal cost = 0;
			
		Discount__c discOne = new Discount__c();
		discOne.Name = 'discOne';
		discOne.Percentes_of__c = 1;
		discOne.Static_discount__c = 1;
		discounts.add(discOne);

		//get max discount
		Discount__c discountMax = new Discount__c();
		discountMax = DiscountSupport.getMaxDiscountFromList(discounts, cost);

		//test condition
		System.assert(discountMax.Name == null);
	}
}