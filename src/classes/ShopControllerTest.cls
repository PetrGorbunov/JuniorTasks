@isTest
private class ShopControllerTest { 
    private static RecordType productMadeId = [SELECT Id FROM RecordType WHERE SobjectType='Product__c' AND Name='Made'];
    private static RecordType productSoldId = [SELECT Id FROM RecordType WHERE SobjectType='Product__c' AND Name='Sold'];
    private static Decimal costDefault = 0;

    @isTest static void getProducts() {       
        //create test data    
        List<Product__c> products = new List<Product__c>();
        
        //create negative data        
        products.add(getProduct('NameNegative', productSoldId.Id, costDefault));
        
        //create positive data
        String productFirstInList = 'Name0';        
        products.add(getProduct(productFirstInList, productMadeId.Id, costDefault));
        for (Integer i = 1; i <= Integer.valueOf(ShopController.PRODUCTS_DEFAULT_SIZE); i++) {            
            products.add(getProduct('Name' + i, productMadeId.Id, costDefault));
        }
        insert products;

        //get data for test
        ShopController shop = new ShopController();
        
        //test conditions
        System.assertEquals(shop.products.size(), Integer.valueOf(ShopController.PRODUCTS_DEFAULT_SIZE));
        System.assertEquals(shop.products.get(0).Name, productFirstInList);
    }    

    @isTest static void checkSearching() {
        //create test data
        List<Product__c> products = new List<Product__c>();
        String namePositive = 'Name';
        Integer productsCount = 3;
        for(Integer i = 1; i <= productsCount; i++) {
            products.add(getProduct(namePositive + i, productMadeId.Id, costDefault));
        }
        products.add(getProduct('n', productMadeId.Id, costDefault));
        insert products;

        //get data for test
        ShopController shop = new ShopController();
        shop.searchProductName = namePositive;
        shop.searchNewProduct();

        //test conditions
        System.assertEquals(shop.products.size(), productsCount);
        for(Product__c product : shop.products) {
            System.assertEquals(product.Name.contains(namePositive), true);
        }
    }

    @isTest static void checkSorting() {
        //create test data
        List<Product__c> products = new List<Product__c>();
        String namePositive = 'Name';
        Integer productsCount = 5;
        for(Integer i = 1; i <= productsCount; i++) {
            products.add(getProduct(namePositive + i, productMadeId.Id, productsCount - i));
        }
        insert products;

        //get data for test
        ShopController shop = new ShopController();
        shop.sortDirection = 'asc';
        shop.sortField = 'Cost__c';
        shop.startSort();

        //test conditions
        System.assertEquals(shop.sortDirection, 'desc');
        System.assertEquals(shop.sortSymbol, '↑');
        Integer currentCost = 0;
        for(Product__c product : shop.products) {
            System.assertEquals(product.Cost__c, currentCost);
            currentCost += 1; 
        }
    }

    @isTest static void getPage() {
        //create test data
        String productName = 'Name';
        createDataForPagination(productName);

        //get data for test
        Integer pageNumber = 3;
        ShopController shop = new ShopController();
        shop.pageNumber = pageNumber;
        shop.getPage();

        //test conditions
        Integer productCurrent = 11;
        for(Product__c product : shop.products) {
            System.assertEquals(product.Name, productName + productCurrent);
            productCurrent += 1;
        }       
        System.assertEquals(shop.pageNumber, pageNumber);        
    }

    @isTest static void getFirstPage() {
        //create test data
        String productName = 'Name';
        createDataForPagination(productName);

        //get data for test
        ShopController shop = new ShopController();
        shop.firstPage();

        //test conditions
        Integer productCurrent = 1;
        for(Product__c product : shop.products) {
            System.assertEquals(product.Name, productName + '0' + productCurrent);
            productCurrent += 1;
        }   
        System.assertEquals(shop.pageNumber, 1);
    }

    @isTest static void getLastPage() {
        //create test data
        String productName = 'Name';
        createDataForPagination(productName);

        //get data for test
        ShopController shop = new ShopController();
        shop.lastPage();

        //test conditions
        Integer productCurrent = 21;
        for(Product__c product : shop.products) {
            System.assertEquals(product.Name, productName + productCurrent);
            productCurrent += 1;
        }   
        System.assertEquals(shop.pageNumber, 5);
    }

    @isTest static void getNextAndPreviousPage() {
        //create test data
        String productName = 'Name';
        createDataForPagination(productName);

        //get data for test nextPage()
        ShopController shop = new ShopController();
        shop.nextPage();
        shop.nextPage();
        shop.nextPage();

        //test conditions
        Integer productCurrent = 16;
        for(Product__c product : shop.products) {
            System.assertEquals(product.Name, productName + productCurrent);
            productCurrent += 1;
        }   
        System.assertEquals(shop.pageNumber, 4);

        //get data for test previousPage()
        shop.previousPage();

        //test conditions
        productCurrent = 11;
        for(Product__c product : shop.products) {
            System.assertEquals(product.Name, productName + productCurrent);
            productCurrent += 1;
        }  
        System.assertEquals(shop.pageNumber, 3);
    }

    private static void createDataForPagination(String productName) {
        List<Product__c> products = new List<Product__c>();
        Integer pagesCount = 5;
        Integer productsCountOnPage = Integer.valueOf(ShopController.PRODUCTS_DEFAULT_SIZE); 
        for (Integer i = 1; i <= productsCountOnPage * pagesCount; i++) {
            String currentName = (i < 10) ? '0' + String.valueOf(i) : String.valueOf(i);
            products.add(getProduct(productName + currentName, productMadeId.Id, costDefault));
        }
        insert products;
    }

    private static Product__c getProduct(String name, Id recordTypeId, Decimal cost) {
        Product__c product = new Product__c();
        product.Name = name;
        product.RecordTypeId = recordTypeId;
        product.Cost__c = cost;
        return product;
    } 

}