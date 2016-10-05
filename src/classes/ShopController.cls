public class ShopController {
    //public List<Product__c> products {get; set;}
    static Integer iter = 1;
    public string productUrl;
    private String errorMessage;
    private String searchName { get; set; }

    public Integer pageNumber { get; set; }


    public String sortSymbol { get; set; } 
    public String sortField { get; set; }
    public String sortDirection {
        get  { if (sortDirection == null) {  
                    sortDirection = 'desc'; 
               } 
               return sortDirection;  
             }
        set;
    }  
    public void startSort() {
        List<ProductWrapper> productsWrapper = new List<ProductWrapper>();
        for(Product__c currentProduct : products) {
            productsWrapper.add(new ProductWrapper(currentProduct, sortField, sortDirection)); 
        }

        if (sortDirection.equals('asc')) {
            sortDirection = 'desc';
            sortSymbol = '↓';
        } else {
            sortDirection = 'asc';
            sortSymbol = '↑';
        } 

        productsWrapper.sort(); 
        products.clear();
        //for(ProductWrapper currentProductWrapper : productsWrapper) {
        //    products.add(currentProductWrapper.product);            
        //}
        //setCon = new ApexPages.StandardSetController(products);     
        //setCon.setPageNumber(1);
        //pageNumber = setCon.getPageNumber(); 
    }
    /*-->*/
    public List<Product__c> products2 { get; set; }
    public List<Product__c> products { 
        //get{
        //    List<Product__c> recordList = (List<Product__c>)setCon.getRecords();
        //    for( Product__c prod: recordList ) {
        //        if (prod.Description__c.length() > 100) {
        //            productUrl = '/apex/product?Id=' + prod.Id;
        //            prod.Description__c = prod.Description__c.substring(1, 100) + '...<a href="' + productUrl + '">more details</a>';
        //        }
        //    }
        //    return recordList;
        //} 
        get {
            products = new List<Product__c>();
            for (Product__c product : (List<Product__c>)setCon.getRecords()) {
                products.add(product);
            }
            return products;
            //return (List<Product__c>)setCon.getRecords();
        }
        set; 
    }

    public String size { 
        get; 
        set;
        //set {
        //    size = productsInPage.get(0);
        //} 
    } 
    public List<SelectOption> productsInPage {
        get;
        //set;
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
        products2 = [SELECT Id, Name, Title__c, 
                           Description__c, 
                           Cost__c, Image__c
                    FROM Product__c
                    WHERE RecordTypeId NOT IN (SELECT Id FROM RecordType WHERE SobjectType='Product__c' AND Name='Sold')
                    ORDER BY Name, Title__c
                    LIMIT 100];
    }

    public Integer productTableSize { get; set; }
    public Integer noOfRecords { get; set; }
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                //if (size == null) {
                //    size = '5';
                //}
                productTableSize = Integer.valueOf(size);
                //productTableSize = 5;
                //String searchName = Apexpages.currentPage().getParameters().get('searchName');                
                searchName = '%' + (searchName == null ? '' : String.escapeSingleQuotes(searchName)) + '%';

                //String SearchBookKeywordCreteria = '%'+(SearchBookKeyword == null ? '' : SearchBookKeyword)+'%';
                //List<Book__c> BookList = [SELECT Id, Name, ISBN__c, Date_Of_Publication__c, (SELECT Id, Author__c, Author__r.Name FROM Book_Author__r) FROM Book__c WHERE Name LIKE :SearchBookKeywordCreteria LIMIT 10000];
                
                List<Product__c> productList = [SELECT Id, Name, Title__c, 
                                                       Description__c, 
                                                       Cost__c, Image__c
                                                FROM Product__c
                                                WHERE RecordTypeId NOT IN (SELECT Id FROM RecordType WHERE SobjectType='Product__c' AND Name='Sold') AND
                                                      Name LIKE :searchName
                                                ORDER BY Name, Title__c
                                                LIMIT 10000];

                //for( Product__c prod: productList ) {
                //    if (prod.Description__c.length() > 100) {
                //        productUrl = '/apex/product?Id=' + prod.Id;
                //        prod.Description__c = prod.Description__c.substring(1, 100) + '...<a href="' + productUrl + '">more details</a>';
                //    }
                //}

                setCon = new ApexPages.StandardSetController(productList);
                setCon.setPageSize(productTableSize);
                noOfRecords = setCon.getResultSize();
                //pageNumber = String.valueOf(setCon.pageNumber);
            }
            return setCon;
        }
        set;
    }
    /*--<*/
    
    //public ShopController() {
    //    getProducts('');
        
    //    errorMessage = ApexPages.currentPage().getParameters().get('errorMessage');
    //    if (errorMessage != null) {
    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage)); 
    //    }
    //}
    
    public void searchProduct() {
        searchName = Apexpages.currentPage().getParameters().get('searchName'); 
        searchName = (searchName == '\'') ? '' : searchName;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'start searchProduct()' + iter + ';searchName=' + searchName)); 
        setCon = null;
        setCon.setPageNumber(1);
        pageNumber = setCon.getPageNumber();
        //getProducts(searchName);        
    }

    public void getPage() {
        setCon = null;
        setCon.setPageNumber(pageNumber);
        pageNumber = setCon.getPageNumber();
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
                    ORDER BY Name, Title__c
                    LIMIT 200];
        for( Product__c prod: products ) {
            if (prod.Description__c.length() > 100) {
                productUrl = '/apex/product?Id=' + prod.Id;
                prod.Description__c = prod.Description__c.substring(1, 100) + '...<a href="' + productUrl + '">more details</a>';
            }
        }
    }

    public void firstPage() {
        setCon.first();
        pageNumber = setCon.getPageNumber();
    }

    public void previousPage() {
        setCon.previous();
        pageNumber = setCon.getPageNumber();
    }

    public void nextPage() {
        //if (destination == 'next') {
        //    setCon.next();
        //}
        setCon.next();        
        pageNumber = setCon.getPageNumber();
    }

    public void lastPage() {
        setCon.last();
        pageNumber = setCon.getPageNumber();
    }
    
}