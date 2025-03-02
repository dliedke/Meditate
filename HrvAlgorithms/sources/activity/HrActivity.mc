using Toybox.Timer;
using Toybox.FitContributor;
using Toybox.ActivityRecording;
using Toybox.Sensor;

module HrvAlgorithms {
	class HrActivity {
		function initialize(fitSessionSpec) {
			//DEBUG
			//PopulateFakeHRHistory();
			me.mFitSession = ActivityRecording.createSession(fitSessionSpec);
			me.createMinHrDataField();	
			me.onBeforeStart(me.mFitSession);
			me.mFitSession.start(); 
			me.mRefreshActivityTimer = new Timer.Timer();		
			me.mRefreshActivityTimer.start(method(:refreshActivityStats), RefreshActivityInterval, true);
		}
			
		private var mFitSession;		
		private const RefreshActivityInterval = 1000;	
		private var mRefreshActivityTimer;
			
		protected function onBeforeStart(fitSession) {
		}
		
		function stop() {	
			if (me.mFitSession.isRecording() == false) {
				return;
		    }

		    me.onBeforeStop();
			me.mFitSession.stop();		
			me.mRefreshActivityTimer.stop();
			me.mRefreshActivityTimer = null;
		}
		
		protected function onBeforeStop() {
		}

		// Pause/Resume session, returns true is session is now running
		function pauseResume() {
			// Check if session is running	
			if (me.mFitSession.isRecording()) {

				// Stop the timer and refresh the screen 
				// to show the pause text
				me.mFitSession.stop();		
				me.mRefreshActivityTimer.stop();
				me.mRefreshActivityTimer = null;
				refreshActivityStats();
				return false;

		    } else {

				// Restart the timer for the session
				me.mFitSession.start();		
				me.mRefreshActivityTimer = new Timer.Timer();		
				me.mRefreshActivityTimer.start(method(:refreshActivityStats), RefreshActivityInterval, true);
				return true;
			}
		}

		function isTimerRunning() {	
			return me.mFitSession.isRecording();
		}

		private function createMinHrDataField() {
			me.mMinHrField = me.mFitSession.createField(
	            "min_hr",
	            me.MinHrFieldId,
	            FitContributor.DATA_TYPE_UINT16,
	            {:mesgType=>FitContributor.MESG_TYPE_SESSION, :units=>"bpm"}
	        );
			
	        me.mMinHrField.setData(0);
		}
		
		private const MinHrFieldId = 0;
		private var mMinHrField;
		private var mMinHr;
		private var mHRHistory = [];

		//DEBUG - start - test the heart rate chart instantaneously for X minutes
		//                also change min/max HR fixed in class HeartRateGraphView and
		//                call this method in initialize() of this class
		/*
		var numMinutes = 30;
		var mHRHistory1Min = [55,55,55,55,56,56,56,56,56,58,58,58,62,62,62,65,65,65,65,70,70,70,70,72,72,72,72,73,73,73,73,74,74,76,76,76,76,78,78,78,78,80,80,78,78,77,77,74,74,72,72,67,67,67,67,68,68,68,68,68];
		private function PopulateFakeHRHistory() {

			for (var f=1;f<=numMinutes;f++) {

				for (var i=0;i<mHRHistory1Min.size();i++)
				{
					mHRHistory.add(mHRHistory1Min[i]);
				}
			}
		}*/
		//DEBUG - end

		function refreshActivityStats() {
			
			var activityInfo = Activity.getActivityInfo();
			if (activityInfo == null) {
				return;
			}

			if (me.mFitSession.isRecording()) {

				if (activityInfo.currentHeartRate != null && (me.mMinHr == null || me.mMinHr > activityInfo.currentHeartRate)) {
					me.mMinHr = activityInfo.currentHeartRate;
				}

				mHRHistory.add(activityInfo.currentHeartRate);
			}

	    	me.onRefreshHrActivityStats(activityInfo, me.mMinHr);
		}
		
		protected function onRefreshHrActivityStats(activityInfo, minHr) {
		}
		
		function calculateSummaryFields() {		
			var activityInfo = Activity.getActivityInfo();		
			if (me.mMinHr != null) {
				me.mMinHrField.setData(me.mMinHr);
			}
			
			var summary = new HrSummary();
			summary.maxHr = activityInfo.maxHeartRate;
			summary.averageHr = activityInfo.averageHeartRate;
			summary.minHr = me.mMinHr;
			summary.elapsedTimeSeconds = activityInfo.timerTime / 1000;
			summary.hrHistory = me.mHRHistory;
			
			return summary;
		}
								
		function finish() {		
			me.mFitSession.save();
			me.mFitSession = null;
		}
			
		function discard() {		
			me.mFitSession.discard();
			me.mFitSession = null;
		}
		
		function discardDanglingActivity() {
			var isDangling = me.mFitSession != null && !me.mFitSession.isRecording();
			if (isDangling) {
				me.discard();
			}
		}
	}	
}