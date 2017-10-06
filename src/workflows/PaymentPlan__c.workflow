<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AutoPopulateEndDate</fullName>
        <description>Field Update to auto-populate End Date: End Date = Start Date +12 months</description>
        <field>EndDate__c</field>
        <formula>DATE (YEAR(  StartDate__c  ) + FLOOR((MONTH(StartDate__c) + 12 - 1)/12), CASE(MOD(MONTH(StartDate__c) + 12, 12 ), 0, 12, MOD(MONTH(StartDate__c)+ 12, 12 )), MIN(DAY(StartDate__c), CASE(MOD(MONTH(StartDate__c) + 12,12), 9, 30, 4, 30, 6, 30, 11, 30, 2, IF(MOD(YEAR(StartDate__c) + FLOOR((MONTH(StartDate__c) + 12)/12), 400) = 0 || (MOD(YEAR(StartDate__c) + FLOOR((MONTH(StartDate__c) + 12)/12), 4) = 0 &amp;&amp; MOD(YEAR(StartDate__c) + FLOOR((MONTH(StartDate__c) + 12)/12), 100) &lt;&gt; 0 ), 29,28), 31)) )</formula>
        <name>Auto Populate EndDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Auto Populate EndDate On Payment Plan</fullName>
        <actions>
            <name>AutoPopulateEndDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PaymentPlan__c.StartDate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
