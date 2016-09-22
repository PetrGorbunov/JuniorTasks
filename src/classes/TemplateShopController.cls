public class TemplateShopController {

    public Boolean isGuest { 
        get {
        	return System.UserInfo.getUserType() == 'Guest';        
    	} 
    }
    
}