trigger Muliple_EventsOnContact on Contact (after delete, after insert, after undelete, 
after update, before delete, before insert, before update)

 {
    
    System.debug('---------------new triger' +trigger.New);
    System.debug('---------------old trigger'+trigger.Old);
    System.debug('---------------newmap'     +trigger.NewMap);
    System.debug('---------------old map'    +trigger.OldMap);

}