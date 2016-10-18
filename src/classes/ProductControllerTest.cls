@isTest
private class ProductControllerTest {
	
	@isTest static void getProduct() {
		//create test data
		String title = 'Test Title';
		Product__c product = new Product__c();
        product.Name = 'name';
        product.Title__c = title;
        insert product;
        
        PageReference pRef = Page.Product;
        pRef.getParameters().put('Id', product.Id);
        Test.setCurrentPage(pRef);

        //get data for test
        ProductController productForTest = new ProductController();

        //test condition
        System.assertEquals(productForTest.product.Title__c, title);
	}
	
}