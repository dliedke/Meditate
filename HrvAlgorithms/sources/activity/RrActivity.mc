using Toybox.Timer;
using Toybox.Sensor;
using Toybox.FitContributor;
using Toybox.ActivityMonitor;
using Toybox.ActivityRecording;

module HrvAlgorithms {
	class RrActivity {
		
		function initialize() {

			// Check if device supports respiration rate
			if (isRespirationRateSupported()) {
				//DEBUG
				//PopulateFakeRRHistory();
				me.respirationRateSupported = true;
				me.rrSummary = new RrSummary();
				me.rrSummary.maxRr = 0;
				me.rrSummary.minRr = 9999999;
				me.totalRespirationSamples = 0;
				me.totalRespirationRateSum = 0;
			} else {
				me.respirationRateSupported = false;
			}
		}

		private var respirationRateSupported;
		private var totalRespirationSamples;
		private var totalRespirationRateSum;
		private var rrSummary;
	    private var mRRHistory = [];
		private var firstBadMesure = true;

		// Method to be used without class instance
		function isRespirationRateSupported(){
			if (ActivityMonitor.getInfo() has :respirationRate) {
				return true;
			} else {
				return false;
			}
		}

		// Check if device supports respiration rate
		function isSupported() {
			return respirationRateSupported;
		}

		function getRespirationRate() {

			// If device supports respiration rate
			if (me.respirationRateSupported) {
				
				// Usually device returns 15 or 14 incorrectly as first mesure and should be ignored
				if (firstBadMesure)
				{
					firstBadMesure = false;
					return -1;
				}

				// Retrieves respiration rate
				var respirationRate = ActivityMonitor.getInfo().respirationRate;

				// Update summary metrics
				if (respirationRate!=null && respirationRate!=0 && respirationRate!=1) {
					updateSummary(respirationRate);
				}

				// Update respiration rate history for chart
				if (respirationRate!=null) {
					mRRHistory.add(respirationRate);
				}

				return respirationRate;

			} else {
				return -1;
			}
		}

		function updateSummary(respirationRate) {

			// Refresh respiration rate metrics including:
			// Min respiration rate
			// Average respiration rate
			// Max respiration rate
			
			totalRespirationSamples++;
			totalRespirationRateSum+=respirationRate;

			rrSummary.averageRr = Math.round(totalRespirationRateSum / totalRespirationSamples);

			if (respirationRate < rrSummary.minRr) {
				rrSummary.minRr = respirationRate;
			}
			if (respirationRate > rrSummary.maxRr) {
				rrSummary.maxRr = respirationRate;
			}
		}

		function getSummary() {

			rrSummary.rrHistory = me.mRRHistory;
			return rrSummary;
		}

		
		//DEBUG - start - test the respiration rate chart instantaneously for X minutes
		//                also change min/max HR fixed in class RespirationRateGraphView and
		//                call this method in initialize() of this class
		/*var numMinutes = 1;
		var mRRHistory1Min = [10,10,10,10,10,10,10,10,10,10,12,12,12,12,12,12,12,12,12,12,14,14,14,14,14,14,14,14,14,14,11,11,11,11,11,11,11,11,11,11,8,8,8,8,8,8,8,8,8,8,7,7,7,7,7,7,7,7,7,7];
		private function PopulateFakeRRHistory() {

			for (var f=1;f<=numMinutes;f++) {

				for (var i=0;i<mRRHistory1Min.size();i++)
				{
					mRRHistory.add(mRRHistory1Min[i]);
				}
			}
		}*/
		//DEBUG - end
	}	
}