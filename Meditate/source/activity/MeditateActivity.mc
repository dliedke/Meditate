using Toybox.WatchUi as Ui;
using Toybox.Timer;
using Toybox.FitContributor;
using Toybox.Timer;
using Toybox.Math;
using Toybox.Sensor;
using HrvAlgorithms.HrvTracking;

class MediteActivity extends HrvAlgorithms.HrvAndStressActivity {
	private var mMeditateModel;
	private var mVibeAlertsExecutor;	
	private var mMeditateDelegate;
		
	function initialize(meditateModel, heartbeatIntervalsSensor, meditateDelegate) {
		var fitSessionSpec;
		var sessionTime = meditateModel.getSessionTime();

		// Retrieve activity name property from Garmin Express/Connect IQ 
		var activityNameProperty = readKeyString(Application.getApp(), "activityName");

		if (meditateModel.getActivityType() == ActivityType.Yoga) {
			fitSessionSpec = HrvAlgorithms.FitSessionSpec.createYoga(createSessionName(sessionTime, activityNameProperty)); // Due to bug in Connect IQ API for breath activity to get respiration rate, we will use Yoga as default meditate activity
		} else if (meditateModel.getActivityType() == ActivityType.Breathing) {
			fitSessionSpec = HrvAlgorithms.FitSessionSpec.createBreathing(createSessionName(sessionTime, activityNameProperty));
		} else {
			fitSessionSpec = HrvAlgorithms.FitSessionSpec.createMeditation(createSessionName(sessionTime, activityNameProperty));
		}

		me.mMeditateModel = meditateModel;	
		me.mMeditateDelegate = meditateDelegate;
		HrvAlgorithms.HrvAndStressActivity.initialize(fitSessionSpec, meditateModel.getHrvTracking(), heartbeatIntervalsSensor);			
	}

	function readKeyString(myApp, key) {

		var value = myApp.getProperty(key);

		if(value == null || !(value instanceof String) || value.length() == 0) {
			
			// If it is empty or invalid, use default name
			value = Ui.loadResource(Rez.Strings.mediateActivityName);

		} else {

			value = value.toString();
		}
		return value;
	}

	protected function createSessionName(sessionTime, activityName) {

		// Calculate session minutes and hours
		var sessionTimeMinutes = Math.round(sessionTime / 60);
		var sessionTimeHours = Math.round(sessionTimeMinutes / 60);
		var sessionTimeString;

		// Create the Connect activity name showing the number of hours/minutes for the meditate session
		if (sessionTimeHours == 0) {
			sessionTimeString = Lang.format("$1$min", [sessionTimeMinutes]);
		} else {
			sessionTimeMinutes = sessionTimeMinutes % 60;
			if (sessionTimeMinutes == 0){
				sessionTimeString = Lang.format("$1$h 🙏", [sessionTimeHours]);
			} else {
				sessionTimeString = Lang.format("$1$h $2$min 🙏", [sessionTimeHours, sessionTimeMinutes]);
			}
		}

		// Replace "[time]" string with the activity time
		var finalActivityName = stringReplace(activityName,"[time]", sessionTimeString);

		// If the generated name is too big, use only default name
		if (finalActivityName.length() > 21) {
			finalActivityName = Ui.loadResource(Rez.Strings.meditateYogaActivityName);
		}

		return finalActivityName;
	}

	function stringReplace(str, oldString, newString)
	{
		var result = str;

		while (true) {
			var index = result.find(oldString);
			if (index != null) {
				var index2 = index+oldString.length();
				result = result.substring(0, index) + newString + result.substring(index2, result.length());
			} else {
				return result;
			}
		}

		return null;
	}
								
	protected function onBeforeStart(fitSession) {
		mMeditateModel.isTimerRunning = true;
		HrvAlgorithms.HrvAndStressActivity.onBeforeStart(fitSession);
		me.mVibeAlertsExecutor = new VibeAlertsExecutor(me.mMeditateModel);	
	}	
				
	protected function onRefreshHrvActivityStats(activityInfo, minHr, hrvValue) {	
		if (activityInfo.elapsedTime != null) {
			me.mMeditateModel.elapsedTime = activityInfo.timerTime / 1000;
		}
		me.mMeditateModel.currentHr = activityInfo.currentHeartRate;
		me.mMeditateModel.minHr = minHr;
		me.mVibeAlertsExecutor.firePendingAlerts();	 
		me.mMeditateModel.hrvValue = hrvValue;
    	
		// Check if we need to stop activity automatically when time ended
		var autoStopEnabled = GlobalSettings.loadAutoStop();
		if (autoStopEnabled && (me.mMeditateModel.elapsedTime >= me.mMeditateModel.getSessionTime())) {	
			mMeditateDelegate.stopActivity();
			return;
		}

	    Ui.requestUpdate();	    
	}	   	
	
	protected function onBeforeStop() {	
		HrvAlgorithms.HrvAndStressActivity.onBeforeStop();
		me.mVibeAlertsExecutor = null;
	}
		
	function calculateSummaryFields() {	
		var activitySummary = HrvAlgorithms.HrvAndStressActivity.calculateSummaryFields();	
		var summaryModel = new SummaryModel(activitySummary, me.mMeditateModel.getRespirationActivity(), me.mMeditateModel.getHrvTracking());
		return summaryModel;
	}
}