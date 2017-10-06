<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateEndDateforLeapYear</fullName>
        <field>EndDate__c</field>
        <formula>StartDate__c +366-1</formula>
        <name>Update End Date for Leap Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update End Date for Leap Year</fullName>
        <actions>
            <name>UpdateEndDateforLeapYear</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Rate__c.LeapYear__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Populates the End Date for Leap Year. i.e. when the Leap Year checkbox is checked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
