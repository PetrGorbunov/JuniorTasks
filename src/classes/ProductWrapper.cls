global class ProductWrapper implements Comparable {
	public Product__c product { get; set; }
    public String fieldName { get; set; }
    public String direction { get; set; }
        
    public ProductWrapper(Product__c product, String fieldName, String direction) {
        this.product = product;
        this.fieldName = fieldName;
        this.direction = direction;        
    }

    global Integer compareTo(Object compareTo) {
    	ProductWrapper productWrapper = (ProductWrapper)compareTo;
        Integer returnValue = 0;
        Integer sortType = (productWrapper.direction == 'desc') ? 1 : -1;

        if (productWrapper.fieldName == 'Name') {
            returnValue = productWrapper.product.Name.compareTo(product.Name);
        } else if (productWrapper.fieldName == 'Cost__c') {  
            returnValue = Integer.valueOf(productWrapper.product.Cost__c - product.Cost__c);
        }

        return returnValue * sortType;
    }	

}