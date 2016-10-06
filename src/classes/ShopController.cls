public class ShopController {

    public List<Product__c> products { get; set; }
    public Integer pageNumber { get; set; }
    public String sortSymbol { get; set; } 
    public String sortField { get; set; }
    public String size { get; set; } 
    public List<SelectOption> productsInPage { get; set; }
    public Integer productTableSize { get; set; }
    public Integer noOfRecords { get; set; }
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                productTableSize = Integer.valueOf(size);
                String searchName = '%' + String.escapeSingleQuotes(searchProductName) + '%';
                List<Product__c> productList = [SELECT Id, Name, Title__c, Description__c, Cost__c, Image__c
                                                FROM Product__c
                                                WHERE RecordTypeId NOT IN (SELECT Id FROM RecordType WHERE SobjectType='Product__c' AND Name='Sold') AND
                                                      Name LIKE :searchName
                                                ORDER BY Name, Title__c
                                                LIMIT 10000];
                setCon = new ApexPages.StandardSetController(productList);
                setCon.setPageSize(productTableSize);
                noOfRecords = setCon.getResultSize();
            }
            return setCon;
        }
        set;
    }
    private String sortDirection {
        get  { if (sortDirection == null) {  
                    sortDirection = 'desc'; 
               } 
               return sortDirection;  
             }
        set;
    }  
    public String searchProductName { 
        get {
            if (searchProductName == null) {
                searchProductName = '';
            }
            return searchProductName;
        }
        set; 
    }

    public ShopController() {
        productsInPage = new List<SelectOption>();
        productsInPage.add(new SelectOption('5','5'));
        productsInPage.add(new SelectOption('10','10'));
        productsInPage.add(new SelectOption('25','25'));
        productsInPage.add(new SelectOption('50','50'));
        size = productsInPage.get(0).getValue();
        pageNumber = 1;
        products = new List<Product__c>(); 
        updateProductsList();  
    }

    private void updateProductsList() {
        products.clear();
        for (Product__c product : (List<Product__c>)setCon.getRecords()) {
            products.add(product);
        }
        sortSymbol = '';
    }

    public void searchNewProduct() {
        setCon = null;
        setCon.setPageNumber(1);
        pageNumber = setCon.getPageNumber();
        updateProductsList();
    }

    public void startSort() {
        List<ProductWrapper> productsWrapper = new List<ProductWrapper>();
        for(Product__c currentProduct : products) {
            productsWrapper.add(new ProductWrapper(currentProduct, sortField, sortDirection)); 
        }
        if (sortDirection.equals('asc')) {
            sortDirection = 'desc';
            sortSymbol = '↑';
        } else {
            sortDirection = 'asc';
            sortSymbol = '↓';
        } 
        productsWrapper.sort(); 
        products.clear();
        for(ProductWrapper currentProductWrapper : productsWrapper) {
            products.add(currentProductWrapper.product);            
        }

    }

    public void getPage() {
        setCon = null;
        setCon.setPageNumber(pageNumber);
        pageNumber = setCon.getPageNumber();
        updateProductsList();
    }

    public void firstPage() {
        setCon.first();
        pageNumber = setCon.getPageNumber();
        updateProductsList();    
    }

    public void previousPage() {
        setCon.previous();
        pageNumber = setCon.getPageNumber();
        updateProductsList();     
    }

    public void nextPage() {
        setCon.next();
        pageNumber = setCon.getPageNumber();
        updateProductsList();
    }

    public void lastPage() {
        setCon.last();
        pageNumber = setCon.getPageNumber();
        updateProductsList();   
    }    
   
}