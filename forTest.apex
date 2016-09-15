/*List <Store__c> stores = [SELECT id FROM Store__c];
System.debug(stores.size());
delete stores;*/
List <Store__c> stores = [SELECT id, Name FROM Store__c];
/*delete stores;*/
/*Store__c st1 = new Store__c();
st1.Name = 'ex1';
st1.End_period__c = Date.today() + 10;
st1.Start_period__c = Date.today();
stores.add(st1);
insert st1;*/
Store__c st_cur = stores.get(0);
System.debug('st_cur.name' + st_cur.Name);


System.debug('stores.size()=' + stores.size());
List <Product__c> products = [SELECT id FROM Product__c];
System.debug('products.size()=' + products.size());
/*delete products;*/
Product__c p1 = new Product__c();
p1.Name = 'qqqqqq';
p1.Name__c = 'wwwww';
p1.Enter_date__c = Date.today() + 1;
p1.Store__c = st_cur.id;

products.add(p1);
/*insert p1;*/

System.debug('products.size()=' + products.size());

Contacts__c contact = new Contacts__c();
contact = [SELECT id FROM Contacts__c WHERE Name = 'Contact1' LIMIT 1];
/*contact.Name = 'Contact1';
insert contact;*/


raw_material__c material = new raw_material__c();
material.Name = 'Material1';
material.Enter_date__c = Date.today();
material.Store__c = st_cur.id;
material.Contacts__c = contact.id;
material.Name__c = 'MatName__C_EXAMPLE';
insert material;

/*String days;*/
/*ReportPeriodTime__c days = [SELECT Days__c FROM ReportPeriodTime__c WHERE Name = 'MainPeriod' ];
System.debug(ReportPeriodTime__c.Days__c);*/
ReportPeriodTime__c reportPeriod = ReportPeriodTime__c.getInstance('MainPeriod');
System.debug(reportPeriod.Days__c);