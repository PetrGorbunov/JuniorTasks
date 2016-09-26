trigger InsertNewMaterialTrigger on raw_material__c (before insert) {

    List<sObject> materialList = Trigger.new;
    StoreSupport.associateWithStore(Raw_material__c.class, materialList);

}