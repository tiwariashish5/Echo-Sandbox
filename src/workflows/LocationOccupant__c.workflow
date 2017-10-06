<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ActiveLocationOccupant</fullName>
        <field>ActiveBackground__c</field>
        <literalValue>1</literalValue>
        <name>Active Location Occupant</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Active Location Occupant</fullName>
        <actions>
            <name>ActiveLocationOccupant</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(AND( StartDate__c &lt;=TODAY(),TODAY()&lt;= EndDate__c ),
AND(StartDate__c &lt;=TODAY(),ISBLANK(EndDate__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
