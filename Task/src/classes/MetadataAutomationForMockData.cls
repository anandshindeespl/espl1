public class MetadataAutomationForMockData {
	public static String jsonContent='{"CustomSettings" :{ "GroupActive" : true,"Setting1" :{"Name" :"EventCustomSetting__c","FileName" : "CustomSettings/eventsetting.json", "isActive" : true, "ExternalID" :"Name" }, "Setting2" :{ "Name" :"EventCustomSetting__c", "FileName" : "CustomSettings/eventsetting.json", "isActive" : true, "ExternalID" :"Name" }}, "CustomObjects" :{ "GroupActive" : true, "CustomObject1" :{ "ObjectNName" :"ENS_Topic__c", "Order" :1, "FileName" : "CustomSettings/setting1.json","isActive" : true, "ExternalID" :"ExternalId__c" }}, "CustomObjects" :{"GroupActive" : true, "CustomObject1" :{ "ObjectName" :"Topic__c", "Order" :1, "FileName" : "CustomObjects/Topic.json", "isActive" : true, "ExternalID" :"ExternalId__c" }}}';
    //public static String path='/resource/'+ strStaticResourceName +'/' + strStaticResourceName + '/RunConfig.json';
    public static String customSettingJson='[ { "NAME":"Amazon CS", "EVENT_TYPE__C":"Amazon", "TYPE_HANDLER__C":"AmazonContentRetrieverBatch"}]';
}