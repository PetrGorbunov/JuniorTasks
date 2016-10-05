public with sharing class ImportMaterialController {
	public Document inputDocument { 
		get {
			if (inputDocument == null) {
				inputDocument = new Document();
			}
			return inputDocument;
		}
		set {
			changeFile();
		}
	}	
	private Id storeId;
	public Boolean isFile { get; set; }

	public ImportMaterialController() {
		storeId = ApexPages.currentPage().getParameters().get('storeId');
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'storeId = ' + storeId));
		changeFile();
	}

	public void importData() {
		if (!inputDocument.checkValue()) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please, select file!'));
			return;
		}

		String fileAsText;
		try {
			fileAsText = inputDocument.value.toString();			
		} catch(Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Incorrect file!'));
		}
		
		List<String> fileAsList = fileAsText.split('\n');
		List<Raw_material__c> materials = new List<Raw_material__c>();
		for (String currentLine : fileAsList) {
			try {
				List<String> parameters = currentLine.split(',');
				Raw_material__c currentMaterial = new Raw_material__c(
					Name__c = parameters.get(0), 
					Name = parameters.get(0),
					Quality__c = parameters.get(1),
					Amount__c = Integer.valueOf(parameters.get(2).trim()),
					Made_in__c = parameters.get(3).trim(),
					Enter_date__c = date.valueOf(parameters.get(4)),
					Store__c = storeId
				);
				materials.add(currentMaterial);
			} catch (Exception e) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error in string:' + currentLine));
			}
		}
		insert materials;
		changeFile();
	}

	public void changeFile() {
		 isFile = (inputDocument.value == null) ? false : true;
	}

	public class Document {
		public blob value { get; set; }
		public String name { get; set; }
		public Boolean checkValue() {
			return (value == null) ? false : true;
		}
	}
}