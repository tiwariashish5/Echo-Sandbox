<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateMeasuredOnSupplyPointFU</fullName>
        <field>Measured__c</field>
        <literalValue>Yes</literalValue>
        <name>Update Measured On Supply Point FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Measured On Supply Point</fullName>
        <actions>
            <name>UpdateMeasuredOnSupplyPointFU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SupplyPoint__c.TotalActiveSupplyPointDevice__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Update the Measured Picklist on Supply point based on the Supply point Device count</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
