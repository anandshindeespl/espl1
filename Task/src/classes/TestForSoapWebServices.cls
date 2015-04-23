/**
 * This class contains unit tests for validating the behavior of Apex classes

 */
@isTest
private class TestForSoapWebServices {

    static testMethod void myUnitTest() 
    {
    	//test for Create lead
    	String responce=SoapWebServices.createLead('Shinde', 'ESPL', 'Open-Not Contacted');
    	system.assertNotEquals(null, responce);
    	
    	//test for update Lead
    	String updateResponce=SoapWebServices.updateLead('Shinde','','Anand@espl.com','98989898');
    	system.assertNotEquals(null, updateResponce);
       
       //test for Delete Lead
        String deletedResponce=SoapWebServices.deleteLead( 'Shinde','','Anand@espl.com','98989898');
        system.assertNotEquals(null, deletedResponce);
    }
}