/*
* //if origin is Email or Web or Chat then Account Id will get filled in Case object
*/
trigger CaseHandler on Case (before insert)
    {
        //if origin is Email or Web or Chat then Account Id will get filled in Case object
        HandlerCase handler=new HandlerCase();
        handler.checkCaseRecord(trigger.new);
    }