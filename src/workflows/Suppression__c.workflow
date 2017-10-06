<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Update Active Status On Suppression</fullName>
        <active>false</active>
        <description>Update the Active flag on Suppression based on the Suppression Start Date and the Suppression End Date</description>
        <formula>AND( SuppressionStartDate__c &lt;=TODAY(),TODAY()&lt;= SuppressionEndDate__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
