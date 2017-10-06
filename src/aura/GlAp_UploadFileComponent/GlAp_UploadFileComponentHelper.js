({
/*
	maxStringSize = 6000000;    // Maximum String size is 6,000,000 characters
	maxFileSize = 4350000;      // After Base64 Encoding, this is the max file size
	chunkSize = 950000;         // Maximum Javascript Remoting message size is 1,000,000 characters
	attachment;
	attachmentName;
	fileSize;
	positionIndex;
	doneUploading;
*/
//    MAX_FILE_SIZE: 4350000,		/* 6 000 000 * 3/4 to account for base64 */
    MAX_FILE_SIZE: 3000000,		/* half max heap size */
    CHUNK_SIZE: 950000,			/* Maximum String size */

    save: function(component, event) {
    
        this.requestInitiated(component);
		
    	var file = event.getSource().get("v.files")[0];

        if (file.size > this.MAX_FILE_SIZE) {
            alert('File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' +
    		  'Selected file size: ' + file.size);
    	    return;
        }
        
        console.log('doc: ' + file.name);
        
        var helper = this;
        var reader = new FileReader();
        reader.onload = $A.getCallback(function() {
            var fileContents = reader.result;
//			var base64Mark = 'base64,';
//			var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;

//			fileContents = fileContents.substring(dataStart);
       
//			console.log('uploading...');
            console.log('uploading... '  + fileContents);
    	    helper.upload(component, file, fileContents);
        });
        reader.readAsDataURL(file);
        
        event.getSource().set("v.files", "");
    },
        
    upload: function(component, file, fileContents) {
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
        
        console.log('uploading chunk...');
        this.requestInitiated(component);
		
       	// start with the initial chunk
        this.uploadChunk(component, file, fileContents, fromPos, toPos, '');   
    },
     
    uploadChunk: function(component, file, fileContents, fromPos, toPos, attachId) {
//        var chunk = fileContents.substring(fromPos, toPos);

        console.log('saving... '  + fileContents);
        var action = component.get("c.saveTheChunk"); 
        action.setParams({
            fileContent: fileContents,		//encodeURIComponent(chunk), 
            parentId: "a000Y00000GDD7UQAX",
            fileName: file.name,
            path: file.name
         });
       
        action.setCallback(this, function(response) {
        	if (response.getState() === "SUCCESS") {
	            
/*
	            console.log("fileContents.length: " + fileContents.length);
	            fromPos = toPos;
	            toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
	            console.log("from position: " + fromPos + " to position: " + toPos);
	            
	            if (fromPos < toPos) {
	            	this.uploadChunk(component, file, fileContents, fromPos, toPos, attachId);  
	
	            } else {
	            
	            	// save the document
			        var action = component.get("c.saveDocument"); 
			        action.setParams({
			            parentId: "a000Y00000GDD7UQAX",
			            fileName: file.name,
			            path: file.name
			        });
	            	
			        action.setCallback(this, function(response) {
			        	if (response.getState() === "SUCCESS") {
				            attachId = response.getReturnValue();

				        // error exit
				        } else {

			            this.handleError(component, response);
				        }
			        });
			        $A.enqueueAction(action);
					console.log("saveDocument() call queued");
	            
	            }
*/
	            this.requestComplete(component);
	            
	        // error exit
	        } else {
	        	
	            this.requestComplete(component);
	            this.handleError(component, response);
	        }
        });
        $A.enqueueAction(action);
		console.log("saveTheChunk() call queued");
    },


    // called when a request is initiated to render the spinner etc
    requestInitiated: function(component) {
        console.log('show spinner...');
		component.find("spinner").show();
    },

    // called when a request is completed to hide the spinner etc
	requestComplete: function(component) {
        console.log('hide spinner...');
        component.find("spinner").hide();
    },

    // displays any errors
    handleError: function(component, response) {
    	console.log("Exception caught successfully");
        console.log("Error Message", response.getError()[0]);
        console.log("Error Message", response.getError()[0].message);
        component.set("v.error", response.getError()[0].message);
    }



})