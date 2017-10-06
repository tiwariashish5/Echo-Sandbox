<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ActiveSupplyPointDeviceFU</fullName>
        <field>ActiveBackground__c</field>
        <literalValue>1</literalValue>
        <name>Active Supply Point Device FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Active Supply Point Device</fullName>
        <actions>
            <name>ActiveSupplyPointDeviceFU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(InstallationDate__c &lt;= TODAY(),RemovalDate__c &gt;= TODAY()) || AND( TODAY() &gt;= InstallationDate__c,ISBLANK(RemovalDate__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
