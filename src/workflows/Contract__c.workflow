<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Billing_Address_field_update</fullName>
        <field>BillingAddress__c</field>
        <formula>CustomerName__r.BillingStreet  + &apos; &apos; +  CustomerName__r.BillingCity + &apos; &apos; +  CustomerName__r.BillingState + &apos; &apos; +  CustomerName__r.BillingCountry + &apos; &apos; +  CustomerName__r.BillingPostalCode</formula>
        <name>Billing Address field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Billing_Address_Field_on_Contract</fullName>
        <description>To update the billing address field on Contract.</description>
        <field>BillingAddress__c</field>
        <formula>CustomerName__r.BillingStreet  + &apos; &apos; +  CustomerName__r.BillingCity  + &apos; &apos; +  CustomerName__r.BillingState  + &apos; &apos; +  CustomerName__r.BillingCountry  + &apos; &apos; +  CustomerName__r.BillingPostalCode</formula>
        <name>Update Billing Address Field on Contract</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Billing Address auto population</fullName>
        <actions>
            <name>Billing_Address_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contract__c.BillingAddress__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
