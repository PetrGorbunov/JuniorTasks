trigger InsertNewMaterialTrigger on raw_material__c (before insert) {

    for (raw_material__c material: Trigger.new) {
        Store__c store = StoreSupport.getStore(material.Enter_date__c);
        material.Store__c = store.id; 
    }

}