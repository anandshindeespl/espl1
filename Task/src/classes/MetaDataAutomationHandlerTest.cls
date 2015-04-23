/*
    MetaDataAutomationHandler : Test Class used to:
    1) Test the Parssing of static resource
    2) Test for creation the Custom Settingd records
    3) Test for creation of Sobject Records
*/
@isTest
private class MetaDataAutomationHandlerTest {

    //method to test for Whether new custom setting records created or Not When strchoice= 'Yes'
    static testMethod void myUnitTest() {
    
        PageReference Pageref=Page.MetaDataAutomation;
        System.test.setCurrentPageReference(Pageref);
        
        Test.startTest();
        
        MetaDataAutomationHandler metaDataObj=new MetaDataAutomationHandler();
        metaDataObj.strStaticResourceName='HIRCRM';
        metaDataObj.strChoice='Yes';
        metaDataObj.runMetaDataSetUp();
        
        list <EventCustomSetting__c> eventList= [select Name from EventCustomSetting__c ];
        system.assertNotEquals(0,eventList.size());
        
        //test for SelectOptionList
        list<SelectOption> optionList= metaDataObj.getFirstRunOption();
        system.assertNotEquals(0,optionList.size());
        
        Test.stopTest();
    }
    
    //Test, if there are existing custom setting records and strchoice= 'No'.
    static testMethod void myUnitTest2() {
        
        Test.startTest();
        
        //Inserting Mock custom setting records
        EventCustomSetting__c obj=new EventCustomSetting__c();
        obj.Name='ESPL';
        insert obj;
        
        MetaDataAutomationHandler metaDataObj=new MetaDataAutomationHandler();
        metaDataObj.strStaticResourceName='HIRCRM';
        metaDataObj.strChoice='No';
        metaDataObj.runMetaDataSetUp();
        
        list <EventCustomSetting__c> eventList= [select Name from EventCustomSetting__c ];
        system.assertNotEquals(0,eventList.size());
        
        Test.stopTest();
    }
    
    //Check for null static resources
    static testMethod void myUnitTestforNullStatResource() {
        
        Test.startTest();
        
        MetaDataAutomationHandler metaDataObj=new MetaDataAutomationHandler();
        metaDataObj.strStaticResourceName = null;
        metaDataObj.strChoice='Yes';
        metaDataObj.runMetaDataSetUp();
        
        list <EventCustomSetting__c> eventList= [select Name from EventCustomSetting__c ];
        system.assertEquals(0,eventList.size());
        
        Test.stopTest();
    }
}