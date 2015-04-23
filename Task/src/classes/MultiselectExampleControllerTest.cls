/**
 * This class contains unit tests for validating the behavior of Apex classes
 
 */
@isTest
private class MultiselectExampleControllerTest {
    static testMethod void testMultiselectExampleController() {
    	// Create some test data
    	List<Contact> l = new List<Contact>();
    	for (Integer i = 0; i < 10; i++) {
    		Contact c = new Contact(firstName = 'User'+i, lastName = 'Name'+i);
            l.add(c);
    	}
    	insert l;
    	
    	MultiselectExampleController c = new MultiselectExampleController();
    	
    	List<Contact> contacts = [SELECT Name, Id FROM Contact];
    	
    	System.assertEquals(c.selectedContacts.size(), 0);
        System.assertEquals(c.allContacts.size(), contacts.size());
        
        c.save();
        
        System.assertEquals(c.message, 'Selected Contacts: ');

        c.selectedContacts.add(new SelectOption('123456789123456', 'Dummy User'));
        c.selectedContacts.add(new SelectOption('234567891234567', 'Example User'));
        
        c.save();
        
        System.assertEquals(c.message, 
                'Selected Contacts: Dummy User (123456789123456), Example User (234567891234567)');
    }
}