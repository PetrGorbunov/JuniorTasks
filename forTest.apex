/*List <Store__c> stores = [SELECT id, Name FROM Store__c];

Store__c st_cur = stores.get(0);
System.debug('st_cur.name' + st_cur.Name);


System.debug('stores.size()=' + stores.size());
List <Product__c> products = [SELECT id FROM Product__c];
System.debug('products.size()=' + products.size());

Product__c p1 = new Product__c();
p1.Name = 'qqqqqq';
p1.Name__c = 'wwwww';
p1.Enter_date__c = Date.today() - 2;

products.add(p1);
insert p1;

System.debug('products.size()=' + products.size());

Contacts__c contact = new Contacts__c();
contact = [SELECT id FROM Contacts__c WHERE Name = 'Contact1' LIMIT 1];

raw_material__c material = new raw_material__c();
material.Name = 'Material1';
material.Enter_date__c = Date.today() - 1;

material.Contacts__c = contact.id;
material.Name__c = 'MatName__C_EXAMPLE';
insert material;*/

/*--------------------------------------------------------------*/

List<Product__c> products = new List<Product__c>();
products.add(new Product__c(Name='nullDate22'));
for (Integer i = 1; i <= 10; i++) {
    
    Product__c prod = new Product__c();
    prod.Name = 'ProdExample22';
    prod.Enter_date__c = Date.newInstance(2001, 1, i);
    products.add(prod);
    
}
products.add(new Product__c(Name='nullDate23'));
insert products;

List<Product__c> checkProducts = new List<Product__c>();
checkProducts = [SELECT id, Name, Enter_date__c
                 FROM Product__c
                 WHERE Name = 'ProdExample22' OR
                 	   Name = 'nullDate22' OR
                       Name = 'nullDate23'
                ];


for (Product__c p : checkProducts) {
    System.debug(p.Name + ' ' + p.Enter_date__c);
}



List<raw_material__c> matireals = new List<raw_material__c>();
matireals.add(new raw_material__c(Name='nullDate33', Name__c='111'));
for (Integer i = 1; i <= 10; i++) {
    
    raw_material__c mat = new raw_material__c();
    mat.Name = 'MatExample33';
    mat.Enter_date__c = Date.newInstance(2001, 2, i);
    mat.Name__c = 'MatName__C_EXAMPLE';
    matireals.add(mat);
    
}
matireals.add(new raw_material__c(Name='nullDate44', Name__c='111'));
insert matireals;

List<raw_material__c> checkMat = new List<raw_material__c>();
checkMat = [SELECT id, Name, Enter_date__c
                 FROM raw_material__c
                 WHERE Name = 'MatExample33' OR
                 	   Name = 'nullDate33' OR
                       Name = 'nullDate44'
                ];


for (raw_material__c m : checkMat) {
    System.debug(m.Name + ' ' + m.Enter_date__c);
}

/*--------------------------------------------------------------*/

/*----------------------formula check-------------------------*/
/*Store__c store = new Store__c();
store.Name = 'MyName8899';
store.End_period__c = Date.today() + 4;
store.Start_period__c = Date.today();
insert store;
store = [SELECT id, Date_between__c
         FROM Store__c
         WHERE Name = 'MyName8899'         
         LIMIT 1
        ];
System.debug('store.Date_between__c' + store.Date_between__c);*/
/*--------------------------------------------------------------*/