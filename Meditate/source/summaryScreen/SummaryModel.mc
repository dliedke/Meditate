using Toybox.Time;
using Toybox.System;
using HrvAlgorithms.HrvTracking;
using Toybox.ActivityMonitor;
using Toybox.Time.Gregorian;

class SummaryModel {
	function initialize(activitySummary, rrActivity, hrvTracking) {
		me.elapsedTime = activitySummary.hrSummary.elapsedTimeSeconds; 
		me.maxHr = me.formatValue(activitySummary.hrSummary.maxHr);
		me.avgHr = me.formatValue(activitySummary.hrSummary.averageHr);
		me.minHr = me.formatValue(activitySummary.hrSummary.minHr);
		me.hrHistory = activitySummary.hrSummary.hrHistory;

		var rrSummary = rrActivity.getSummary();
		if (rrSummary!=null) {
			me.maxRr = me.formatValue(rrSummary.max);
			me.avgRr = me.formatValue(rrSummary.avg);
			me.minRr = me.formatValue(rrSummary.min);
			me.rrHistory = rrSummary.data;
		}

		initializeStressHistory(me.elapsedTime);
		me.stress = me.formatValue(me.stress);

		if (activitySummary.hrvSummary != null) {
			me.hrvRmssd = me.formatValue(activitySummary.hrvSummary.rmssd);
			me.hrvRmssdHistory = activitySummary.hrvSummary.rmssdHistory;
			me.hrvFirst5Min = me.formatValue(activitySummary.hrvSummary.first5MinSdrr);
			me.hrvLast5Min = me.formatValue(activitySummary.hrvSummary.last5MinSdrr);
			me.hrvPnn50 = me.formatValue(activitySummary.hrvSummary.pnn50);
			me.hrvPnn20 = me.formatValue(activitySummary.hrvSummary.pnn20);
		}
		
		me.hrvTracking = hrvTracking;
	}

	function initializeStressHistory(elapsedTimeSeconds) {

		me.stressEnd = null;
		me.stressStart = null;
		me.stressHistory = [];
		var momentStartMediatation = null;

		//DEBUG
		//elapsedTimeSeconds = 60 * 30;

		// Get stress history iterator object
		var stressIterator = getStressHistoryIterator();
		if (stressIterator!=null) {
		
			// Loop through all data
			var sample = stressIterator.next();

			// Get the stress data for the end of the session
			if (sample != null) {
				
				// Calculate the moment of the start of meditation session
				momentStartMediatation = Time.now().subtract(new Time.Duration(elapsedTimeSeconds));

				if (momentStartMediatation.greaterThan(sample.when))
				{
					//System.println("No stress history data found for the meditation timeframe, exiting.");
					return;
				}
				me.stressEnd = sample.data;
				me.stressHistory.add(sample.data);

				//System.println("stressEnd.data:" + sample.data);
			}

			// Go until the end of the iterator
			while (sample != null) {

				sample = stressIterator.next();

				// Get the stress score for the start of the session
				if (sample!=null) {

					// If the stress sample is within the meditation timeframe use it for the stress start metric
					if (sample.when.greaterThan(momentStartMediatation)) {
						me.stressStart = sample.data;
						me.stressHistory.add(sample.data);
						//var sampleDate = Gregorian.info(sample.when, Time.FORMAT_MEDIUM);
						//System.println("sample.date:" + sampleDate.hour + ":" + sampleDate.min + ":" + sampleDate.sec);
						//System.println("sample.data:" + sample.data);
					}
				}
			}
			me.stressHistory = stressHistory.reverse();
			me.stress = Math.mean(me.stressHistory);
		}
	}

	function getStressHistoryIterator() {

		// Check device for SensorHistory compatibility
		if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getStressHistory)) {

			// Retrieve the stress history (sending period sometimes fail in some watches)
			var stressHistory = Toybox.SensorHistory.getStressHistory(null);
			return stressHistory;
		}

		return null;
 	 }

	private function formatValue(value) {
		if (value == null || value == 0) {
			return me.InvalidValueString;
		}
		else {
			return Math.round(value).format("%3.0f");
		}
	}

	private const InvalidValueString = "   --";
	
	var elapsedTime;
	
	var maxHr;
	var avgHr;
	var minHr;	
	
	var maxRr;
	var avgRr;
	var minRr;	
    var rrHistory;

	var stress;
	var stressStart;
	var stressEnd;
	var stressHistory;

	var hrvRmssd;
	var hrvRmssdHistory;
	var hrvFirst5Min;
	var hrvLast5Min;
	var hrvPnn50;
	var hrvPnn20;
	
	var hrvTracking;
	var hrHistory;
}