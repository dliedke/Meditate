using Toybox.Time;
using Toybox.System;
using HrvAlgorithms.HrvTracking;
using Toybox.ActivityMonitor;
using Toybox.Time.Gregorian;

class SummaryModel {
	function initialize(activitySummary, rrActivity, stressActivity, hrvTracking) {
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

		var stressSummary = stressActivity.getSummary();
		if (stressSummary!=null) {
			me.maxSt = me.formatValue(stressSummary.max);
			me.avgSt = me.formatValue(stressSummary.avg);
			me.minSt = me.formatValue(stressSummary.min);
			me.firstSt = me.formatValue(stressSummary.first);
			me.lastSt = me.formatValue(stressSummary.last);
			me.stHistory = stressSummary.data;
		}

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

	var firstSt;
	var lastSt;
	var maxSt;
	var avgSt;
	var minSt;
	var stHistory;

	var hrvRmssd;
	var hrvRmssdHistory;
	var hrvFirst5Min;
	var hrvLast5Min;
	var hrvPnn50;
	var hrvPnn20;
	
	var hrvTracking;
	var hrHistory;
}