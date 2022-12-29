using Toybox.WatchUi as Ui;
using Toybox.Lang;

class MeditatePrepareDelegate extends Ui.BehaviorDelegate {
	
	var mSessionPickerDelegate;

    function initialize(sessionPickerDelegate) {
		mSessionPickerDelegate = sessionPickerDelegate;
        Ui.BehaviorDelegate.initialize();
    }

	function onBack() {    
    	return true;
    }

	function onKey(keyEvent) {
	  	return true;
    }
}