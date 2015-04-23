<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Clearview_Workflow_Flag</fullName>
        <description>Set Clearview Workflow Flag</description>
        <field>Clearview_Workflow__c</field>
        <literalValue>1</literalValue>
        <name>Set Clearview Workflow Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>First Workflow Fired</fullName>
        <actions>
            <name>Set_Clearview_Workflow_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Set to true after running for the first time</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
