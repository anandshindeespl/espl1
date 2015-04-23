/*
 *  Dynamic Sobject Insertion with mapping to parent external id field.
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   24 Mar 2015
 ===========================================================================================================================================
 */
public class AssociateChildParent
{
   // Dynamic Sobject Insertion with maping to parent external id field.
    public void insertchild()
    {
        String ff;
        String externalId = 'Test1234';
        SObject parentObject;
        Schema.SObjectType targetType =Schema.getGlobalDescribe().get('Contact_Topic__c');
        
        //loop to get the look up field from object
        for(Schema.sObjectField field1 : targetType.getDescribe().fields.getMap().values())
        {
            DescribeFieldResult fieldDescribe1 = field1.getDescribe();
            system.debug('fieldDescribe'+field1);
            String fldType = string.valueOf(fieldDescribe1.getType());   
            if (fldType == 'REFERENCE')// Lookup field!
            { 
            	if(fieldDescribe1.isCustom()) {
            		system.debug('andy'+field1);
            		ff=fieldDescribe1.getLabel(); 
            		system.debug('aaaaa'+ff);
            }
            system.debug('string.valueOf(dfield.Name)' + fldType);
            system.debug('yyyyyfield1'+field1);
            }
        }
                Schema.DescribeFieldResult fieldToUpdateDescribe=Contact_Topic__c.Account_Topic_Id__c.getDescribe();// You mention in your question you already have this, I assume it's Opportunity.Opportunity_Code__r based on the example
                if(!fieldToUpdateDescribe.isNamePointing())
                {
                    // This field only refers to one sObject type and parenttype contains parent Sobject name 
                    Schema.sObjectType parentType = fieldToUpdateDescribe.getReferenceTo()[0]; // We know this only has one value since isNamePointing is true
                    system.debug('parenttype'+parentType);
                    // Find the External ID field
                    for(Schema.sObjectField field : parentType.getDescribe().fields.getMap().values())//to get the fields in variable field
                    {
                        DescribeFieldResult fieldDescribe = field.getDescribe();
                        system.debug('fieldDescribe'+fieldDescribe);
                        if(fieldDescribe.isExternalId())
                        {
                            system.debug('nnnn'+field);
                        parentObject = parentType.newSObject();
                        parentObject.put(fieldDescribe.getName(), externalId);
                        break; // I'm assuming there is only one External Id field
                }
            }
	            }
                // for Update the child object..
                //next line will create dynamic child object from string
                SObject childObject = Schema.getGlobalDescribe().get('Contact_Topic__c').newSObject();
                //will put the parent external id in lookfield of child. ie childParent association
                childObject.putSObject(fieldToUpdateDescribe.getRelationshipName(), parentObject); 
                //childObject.putSObject('Account_Topic_Id__r', externalId);
                childObject.put('LastName__c','espl');
                //childObject.put('Account_Topic_Id__c','Test1234');
                upsert childObject;
}
}