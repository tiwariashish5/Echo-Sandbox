/******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test Class for GlAp_FieldProps
*******************************************************************************/

@isTest
Public Class GlAp_FieldProps_Test{

//variable declation section
    private static final string UNSUPPORTED= 'Unsupported';
    private static final string TEXTAREA ='TextArea';    
    private static List<string> selectList ;   
    static{
            //Get Fields from the Supression Object
            selectList = new List<string>();
            selectList .add('FirstName');
            selectList .add('LastName');      
    }
    private static Map<string,string> MapSelectEntries ;   
    static{
            //Get Fields from the Supression Object
            MapSelectEntries = new  Map<string,string>();
            MapSelectEntries.put('FirstName','FirstName');
            MapSelectEntries.put('LastName','LastName');      
    }

/******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test data setup method
*******************************************************************************/
    @TestSetup
    Static void createTestData(){
        User objUser = GlUt_TestFactoryData.createUser('System Administrator','TestUser',null);
        Database.insert(objUser);  
    }

          /******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static void setFieldType(DisplayType fieldTypes, String type){
        User objUser =[select id,name from user where isActive=true limit 1];
        system.runas(objUser){
            GlAp_FieldProps fieldstype = new GlAp_FieldProps();
            DisplayType fieldType = fieldTypes;
            fieldstype.isRequired = true;
            fieldstype.isFLSVisible = true;
            fieldstype.isEncrypted = false;
            fieldstype.isEditable = true;
            fieldstype.fieldName = 'Test';
            fieldstype.fieldLabel = 'Test__c';
            fieldstype.parentObject = objUser.Id;
            fieldstype.fieldType = type;
            fieldsType.pickListValues = selectList ;
            fieldsType.pickListEntries = MapSelectEntries ;            
            fieldstype.setFieldType(fieldType);
        }
    }

              /******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static testmethod void setFieldTypeString(){
        DisplayType fieldType = Schema.DisplayType.STRING;
        String types = 'text';
        setFieldType(fieldType,types);

    }  

     /******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static testmethod void setFieldTypeEmail(){
        DisplayType fieldType = Schema.DisplayType.EMAIL;
        String types = 'email';
        setFieldType(fieldType,types);

    }    
  
    /******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static testmethod void setFieldTypePhone(){
        DisplayType fieldType = Schema.DisplayType.PHONE;
        String types = 'Phone';
        setFieldType(fieldType,types);

    } 

    /******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static testmethod void setFieldTypeURL(){
        DisplayType fieldType = Schema.DisplayType.URL;
        String types = 'url';
        setFieldType(fieldType,types);

    }    
 
    /******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static testmethod void setFieldTypeCurrency(){
        DisplayType fieldType = Schema.DisplayType.CURRENCY;
        String types = 'currency';
        setFieldType(fieldType,types);

    }    
  
    /******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static testmethod void setFieldTypeInteger(){
        DisplayType fieldType = Schema.DisplayType.INTEGER;
        String types = 'number';
        setFieldType(fieldType,types);

    }    

    /******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static testmethod void setFieldTypeBoolean(){
        DisplayType fieldType = Schema.DisplayType.BOOLEAN;
        String types = 'checkbox';
        setFieldType(fieldType,types);

    }    
    /******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static testmethod void setFieldTypeDate(){
        DisplayType fieldType = Schema.DisplayType.DATE;
        String types = 'date';
        setFieldType(fieldType,types);

    }
    /******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static testmethod void setFieldTypeDateTime(){
        DisplayType fieldType = Schema.DisplayType.DATETIME;
        String types = 'datetime-local';
        setFieldType(fieldType,types);

    }
    /******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static testmethod void setFieldTypemultiselect(){
        DisplayType fieldType = Schema.DisplayType.MULTIPICKLIST;
        String types = 'MultiPicklist';
        setFieldType(fieldType,types);

    }
    /******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static testmethod void setFieldTypepicklist(){
        DisplayType fieldType = Schema.DisplayType.PICKLIST;
        String types = 'select';
        setFieldType(fieldType,types);

    }

    /******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static testmethod void setFieldTypecombobox(){
        DisplayType fieldType = Schema.DisplayType.COMBOBOX;
        String types = 'combobox';
        setFieldType(fieldType,types);

    }
    /******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static testmethod void setFieldTypepercent(){
        DisplayType fieldType = Schema.DisplayType.PERCENT;
        String types = 'percent';
        setFieldType(fieldType,types);

    }

        /******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static testmethod void setFieldTypereference(){
        DisplayType fieldType = Schema.DisplayType.REFERENCE;
        String types = 'reference';
        setFieldType(fieldType,types);

    }

        /******************************************************************************
@author:      Accenture: Suman Kumar
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static testmethod void setFieldTypetextarea(){
        DisplayType fieldType = Schema.DisplayType.TEXTAREA;
        String types = 'TextArea';
        setFieldType(fieldType,types);

    }
     /******************************************************************************
@author:      Accenture: Manish Singh
@date:        26th September 2017
@description: Test method for checking the field Type
*******************************************************************************/
    static testmethod void setFieldTypeUnsspported(){
        DisplayType fieldType = Schema.DisplayType.ADDRESS;
        String types = 'ADDRESS';
        setFieldType(fieldType,types);
    }


}