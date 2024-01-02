using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System;

class MeditateApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        // Disable and remove listeners for heatbeat sensor
        if (heartbeatIntervalsSensor!=null) {
            heartbeatIntervalsSensor.disableHrSensor();
            heartbeatIntervalsSensor.stop();
        }
    }

    var heartbeatIntervalsSensor;

    // Return the initial view of your application here
    function getInitialView() {      
    	var sessionStorage = new SessionStorage();	          	
    	heartbeatIntervalsSensor = new HrvAlgorithms.HeartbeatIntervalsSensor();	
    	var sessionPickerDelegate = new SessionPickerDelegate(sessionStorage, heartbeatIntervalsSensor);
    	
        return [ sessionPickerDelegate.createScreenPickerView(), sessionPickerDelegate ];
    }
}
