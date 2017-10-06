({
	hide: function(cmp) {
        var spinner = cmp.find("spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    show: function(cmp) {
        var spinner = cmp.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
    }
})