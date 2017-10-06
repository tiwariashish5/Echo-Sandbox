/***************************************************************************************************
@author        Accenture : Manish Singh
@date          04-Sep-2017
@description:  This is helper class used by Reading object trigger  
@group         TriggerHelper
*******************************************************************************************************/
public with sharing class GlUt_ReadingHandler extends GlUt_TriggerHandlerBase{
    // Variable declaration
    
    // End variable declaration
    
    /**********************************************************************************************
    @author        Accenture: Manish Singh
    @date          04-Sep-2017
    @param         GlUt_TriggerHandlerObj inputParam
    @return        void
    @description   This method is used to invoke method from trigger
    **********************************************************************************************/
    public override void  MainEntry(GlUt_TriggerHandlerObj inputParam){
        try{
        //Logger.Push('MainEntry', 'BlAp_ReadingHandler');
            if( inputParam.isInsert && inputParam.isBefore ){
                    
            }
            if( inputParam.isInsert && inputParam.isAfter ){
                // call for average daily uses calculations 
                calAvgDailyUses(inputParam.newlist);
                
            }
            if( inputParam.isUpdate && inputParam.isBefore ){
                
            }
            if( inputParam.isUpdate && inputParam.isAfter ){
                    
            }  
            if( inputParam.isDelete && inputParam.isBefore ){
                
            }
            if( inputParam.isDelete && inputParam.isAfter ){
            
            }  
        }
        catch (Exception ex){
            system.debug('Line Number:=' + ex.getLineNumber());
                //Logger.debugException(ex);
        }

        finally{   
            //Reset the active function to null in case this class was first in stack
            //this indicates that the trigger has finished firing so it no longer needs to control flow
            GlUt_CentralDispatcher.activeFunction = null;
            //Logger.pop();
        }
    
            //update inputParam.newlist;
    }
    /**********************************************************************************************
    @author        Accenture: Manish Singh
    @date          05-Sep-2017
    @param         Trigger.new
    @return        void
    @description   This method is used to calculate daily uses for device
    **********************************************************************************************/
    private void calAvgDailyUses(list<Reading__c> newlist){
        set<Id> setDeviceId = new set<Id>();
        list<AverageDailyUse__c> listAverageUses = new list<AverageDailyUse__c>() ;
        map<Id,list<Reading__c>> mapDeviceReading = new map<Id,list<Reading__c>>() ;
        map<Id,list<SupplyPointDevice__c>> mapDeviceSupplyptDevice = new map<Id,list<SupplyPointDevice__c>>();
        for(Reading__c read : newlist){
            setDeviceId.add(read.DeviceReference__c);
        }
        
        for(Device__c device: [Select Id, (select Id, ActualDeviceReading__c, DeviceReference__c,ReadingDate__c  from 
            Readings__r order by createdDate desc limit :GlUt_Constants.LIMITBILLINGCAL ),(select Id from 
            SupplyPointDevices__r where Active__c = true limit 1) from Device__c where Id=:setDeviceId ]){
            if(device.Readings__r != null)
                mapDeviceReading.put(device.Id,device.Readings__r);
            if(!device.SupplyPointDevices__r.isEmpty() && device.SupplyPointDevices__r != null )
                mapDeviceSupplyptDevice.put(device.Id,device.SupplyPointDevices__r);        
        }
        if(mapDeviceReading != null && !mapDeviceReading.isEmpty()){
            double readingDifference ;
            integer daysDifference = GlUt_Constants.INDEX1;
            for(Id deviceId: mapDeviceReading.keySet() ){
                readingDifference = mapDeviceReading.get(deviceId)[GlUt_Constants.INDEX0].ActualDeviceReading__c - 
                    mapDeviceReading.get(deviceId)[GlUt_Constants.INDEX1].ActualDeviceReading__c;
               datetime startDateTime = mapDeviceReading.get(deviceId)[GlUt_Constants.INDEX1].ReadingDate__c;
               datetime endDateTime = mapDeviceReading.get(deviceId)[GlUt_Constants.INDEX0].ReadingDate__c;
                date startDate = Date.newinstance(startDateTime.year(), startDateTime.month(),startDateTime.day());
                date endDate =  Date.newinstance(endDateTime.year(), endDateTime.month(),endDateTime.day());
                daysDifference = startDate.daysBetween(endDate);
                daysDifference  = daysDifference == GlUt_Constants.INDEX0 ? GlUt_Constants.INDEX1 : daysDifference ;                                       
                system.debug('@@@readingDifferenc = '+ readingDifference + ' @@@daysDifference ='+daysDifference);
                double averageReading = readingDifference/daysDifference;
                if(mapDeviceSupplyptDevice.containsKey(deviceId)){                    
                    if( mapDeviceSupplyptDevice.get(deviceId)[GlUt_Constants.INDEX0].Id != null)
                        listAverageUses.add(new AverageDailyUse__c(AverageDailyUsage__c = averageReading,Date__c= System.Today(),
                            SupplyPointDevice__c =mapDeviceSupplyptDevice.get(deviceId)[GlUt_Constants.INDEX0].Id));
                }            
            }
        }
        if(!listAverageUses.isEmpty() && listAverageUses!= null){
            database.insert(listAverageUses);
        }
    }
}