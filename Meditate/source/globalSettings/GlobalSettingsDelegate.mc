using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using HrvAlgorithms.HrvTracking;

class GlobalSettingsDelegate extends ScreenPicker.ScreenPickerDelegate {
	protected var mColors;
	private var mOnColorSelected;
	private var mSessionPickerDelegate;
	
	function initialize(sessionPickerDelegate) {
		ScreenPickerDelegate.initialize(0, 1);	
		me.mGlobalSettingsTitle = Ui.loadResource(Rez.Strings.menuGlobalSettings_title);
		me.mGlobalSettingsDetailsModel = new ScreenPicker.DetailsModel();
		me.mSessionPickerDelegate = sessionPickerDelegate;
		updateGlobalSettingsDetails();
	}
	
	private var mGlobalSettingsTitle;
	private var mGlobalSettingsDetailsModel;
	
	function createScreenPickerView() {
		return new ScreenPicker.ScreenPickerDetailsView(me.mGlobalSettingsDetailsModel, false);
	}
	
	function onMenu() {        
    	return me.showGlobalSettingsMenu();
    }
    
	function onHold(param) {
		return me.showGlobalSettingsMenu();
	}

	function showGlobalSettingsMenu()
	{
		Ui.pushView(new Rez.Menus.globalSettingsMenu(), new GlobalSettingsMenuDelegate(method(:onGlobalSettingsChanged)), Ui.SLIDE_LEFT);  
	}

    function onBack() {    
    	Ui.switchToView(me.mSessionPickerDelegate.createScreenPickerView(), me.mSessionPickerDelegate, Ui.SLIDE_RIGHT);
    	return true;
    }
    
    function onGlobalSettingsChanged() {
    	me.updateGlobalSettingsDetails();
    	Ui.requestUpdate();
    }
    
    private function updateGlobalSettingsDetails() {
		var details = me.mGlobalSettingsDetailsModel;
		details.title = me.mGlobalSettingsTitle;
		var iconColor = null;

		// Auto stop settings
        var autoStopSetting = "";
		
        var autoStop = GlobalSettings.loadAutoStop();
    	var line = details.getLine(0);
        if (autoStop == AutoStop.On) {

			// In order to avoid the (default) text in string "menuAutoStopOptions_on"
	        autoStopSetting = Ui.loadResource(Rez.Strings.menuHrvTrackingOptions_on); 
			iconColor = Gfx.COLOR_GREEN;
        } else {
	        autoStopSetting = Ui.loadResource(Rez.Strings.menuAutoStopOptions_off);
			iconColor = Gfx.COLOR_RED;
        }
		line.icon = new ScreenPicker.Icon({        
			:font => StatusIconFonts.fontAwesomeFreeSolid,
			:symbol => StatusIconFonts.Rez.Strings.faRepeatSession,
			:color => iconColor
		});	

		var autoStopTitle = Ui.loadResource(Rez.Strings.menuAutoStopOptions_title);
        line.value.text = autoStopTitle + ": " + autoStopSetting;
		

		// HRV settings (not enough screen space for everything)
		/*
	    details.detailLines[1].icon = new ScreenPicker.HrvIcon({});
	    var hrvTrackingSetting;
	    var hrvTracking = GlobalSettings.loadHrvTracking();
		if (hrvTracking == HrvTracking.On) {			
			hrvTrackingSetting = Ui.loadResource(Rez.Strings.menuNewHrvTrackingOptions_on);
		}          
		else if (hrvTracking == HrvTracking.OnDetailed) {
			hrvTrackingSetting = Ui.loadResource(Rez.Strings.menuNewHrvTrackingOptions_onDetailedSimple);
		}
		else {
			hrvTrackingSetting = Ui.loadResource(Rez.Strings.menuNewHrvTrackingOptions_off);
		}
		details.detailLines[1].value.text = "HRV: " +  hrvTrackingSetting; 	
		*/
		
		// Confirm save activity settings
		var confirmSaveSetting = "";		
        var saveActivityConfirmation = GlobalSettings.loadConfirmSaveActivity();
		line = details.getLine(1);
        if (saveActivityConfirmation == ConfirmSaveActivity.AutoYes) {
			iconColor = Gfx.COLOR_GREEN;
	        confirmSaveSetting = Ui.loadResource(Rez.Strings.menuConfirmSaveActivityOptions_autoYes);
        } else if (saveActivityConfirmation == ConfirmSaveActivity.AutoYesExit) {
			iconColor = Gfx.COLOR_GREEN;
	        confirmSaveSetting = Ui.loadResource(Rez.Strings.menuConfirmSaveActivityOptions_autoYesExit);
		} else if (saveActivityConfirmation == ConfirmSaveActivity.AutoNo) {
			iconColor = Gfx.COLOR_RED;
			confirmSaveSetting = Ui.loadResource(Rez.Strings.menuConfirmSaveActivityOptions_autoNo);
		} else {
			// Ask
			iconColor = Gfx.COLOR_GREEN;
			confirmSaveSetting = Ui.loadResource(Rez.Strings.menuConfirmSaveActivityOptions_askSimple);
		}
		line.icon = new ScreenPicker.Icon({        
	        	:font => StatusIconFonts.fontAwesomeFreeSolid,
	        	:symbol => StatusIconFonts.Rez.Strings.faSaveSession,
	        	:color => iconColor
	        });	

        line.value.text = Ui.loadResource(Rez.Strings.menuGlobalSettings_save) + confirmSaveSetting;
        
		// Multi-session settings (not enough screen space for everything)
		/*
        var multiSessionSetting = "";
        var multiSession = GlobalSettings.loadMultiSession();
    	details.detailLines[3].icon = new ScreenPicker.Icon({        
	        	:font => StatusIconFonts.fontAwesomeFreeSolid,
	        	:symbol => StatusIconFonts.Rez.Strings.faRepeatSession
	        });	
        if (multiSession == MultiSession.Yes) {
	        multiSessionSetting = Ui.loadResource(Rez.Strings.menuGlobalSettings_multiSession);
        }
        if (multiSession == MultiSession.No) {
	        multiSessionSetting = Ui.loadResource(Rez.Strings.menuGlobalSettings_singleSession);
        }
        details.detailLines[3].value.text = multiSessionSetting;
		*/

		// Preparation time settings
		line = details.getLine(2);
        line.icon = new ScreenPicker.Icon({        
	        	:font => StatusIconFonts.fontAwesomeFreeRegular,
        	    :symbol => StatusIconFonts.Rez.Strings.faClock
	        });	

		// Calculate minutes and seconds from the loaded prepare time
		var prepareTimeSeconds = GlobalSettings.loadPrepareTime();
		var minutes = prepareTimeSeconds / 60;
		var seconds = prepareTimeSeconds % 60;

		// Set the text with the remaining time in the format M:SS
		line.value.text = Ui.loadResource(Rez.Strings.menuPrepareTimeOptions_title) + ": " + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;


		// Finalize time settings
		line = details.getLine(3);
        line.icon = new ScreenPicker.Icon({        
	        	:font => StatusIconFonts.fontAwesomeFreeRegular,
        	    :symbol => StatusIconFonts.Rez.Strings.faClock
	        });	

		// Calculate minutes and seconds from the loaded prepare time
		var finalizeTimeSeconds = GlobalSettings.loadFinalizeTime();
		minutes = finalizeTimeSeconds / 60;
		seconds = finalizeTimeSeconds % 60;

		// Set the text with the remaining time in the format M:SS
		line.value.text = Ui.loadResource(Rez.Strings.menuFinalizeTimeOptions_title) + ": " + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;


		// New Activity type settings
		line = details.getLine(4);
        line.icon = new ScreenPicker.Icon({        
	        	:font => StatusIconFonts.fontMeditateIcons,
	        	:symbol => StatusIconFonts.Rez.Strings.meditateFontYoga,
				:color => Gfx.COLOR_GREEN
	        });	
        var newActivityType = GlobalSettings.loadActivityType();
        if (newActivityType == ActivityType.Meditating) {
        	line.value.text = Ui.loadResource(Rez.Strings.menuNewActivityTypeOptions_meditating);
        } else if (newActivityType == ActivityType.Yoga) {
        	line.value.text = Ui.loadResource(Rez.Strings.menuNewActivityTypeOptions_yoga);
        } else {
			// ActivityType.Breathing
        	line.value.text = Ui.loadResource(Rez.Strings.menuNewActivityTypeOptions_breathing);
        }

		// Show Respiration rate settings if supported (not enough screen space for everything)
		/*
		if (HrvAlgorithms.RrActivity.isRespirationRateSupported()) {
			
			var respirationRateSetting = "";
			var respirationRate = GlobalSettings.loadRespirationRate();
			details.detailLines[5].icon = new ScreenPicker.BreathIcon({});
			if (respirationRate == RespirationRate.On) {
				respirationRateSetting = Ui.loadResource(Rez.Strings.menuNewHrvTrackingOptions_on);
			}
			if (respirationRate == RespirationRate.Off) {
				respirationRateSetting = Ui.loadResource(Rez.Strings.menuNewHrvTrackingOptions_off);
			}
			details.detailLines[5].value.text = Ui.loadResource(Rez.Strings.menuGlobalSettings_respiration) + respirationRateSetting;
		}
		*/
	}
}