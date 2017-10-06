<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateEndDateforLeapYearOnAR</fullName>
        <field>EndDate__c</field>
        <formula>(StartDate__c +366)-1</formula>
        <name>Update End Date For Leap Year On AR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update End Date for Leap Year on Agreed Rate</fullName>
        <actions>
            <name>UpdateEndDateforLeapYearOnAR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AgreedRate__c.LeapYear__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
