using Toybox.Time;
using Toybox.System;
using HrvAlgorithms.HrvTracking;
using Toybox.ActivityMonitor;
using Toybox.Time.Gregorian;

class SummaryModel {
	function initialize(activitySummary, rrActivity, stressActivity, hrvTracking) {
		me.elapsedTime = activitySummary.hrSummary.elapsedTimeSeconds;
		me.maxHr = activitySummary.hrSummary.maxHr;
		me.avgHr = activitySummary.hrSummary.averageHr;
		me.minHr = activitySummary.hrSummary.minHr;
		me.hrHistory = activitySummary.hrSummary.hrHistory;

		var rrSummary = rrActivity.getSummary();
		if (rrSummary != null) {
			me.maxRr = rrSummary.max;
			me.avgRr = rrSummary.avg;
			me.minRr = rrSummary.min;
			me.rrHistory = rrSummary.data;
		}

		var stressSummary = stressActivity.getSummary();
		if (stressSummary != null) {
			me.maxSt = stressSummary.max;
			me.avgSt = stressSummary.avg;
			me.minSt = stressSummary.min;
			me.firstSt = stressSummary.first;
			me.lastSt = stressSummary.last;
			me.stHistory = stressSummary.data;
		}

		if (activitySummary.hrvSummary != null) {
			me.hrvRmssd = activitySummary.hrvSummary.rmssd;
			me.hrvRmssdHistory = activitySummary.hrvSummary.rmssdHistory;
			me.hrvFirst5Min = activitySummary.hrvSummary.first5MinSdrr;
			me.hrvLast5Min = activitySummary.hrvSummary.last5MinSdrr;
			me.hrvPnn50 = activitySummary.hrvSummary.pnn50;
			me.hrvPnn20 = activitySummary.hrvSummary.pnn20;
		}

		me.hrvTracking = hrvTracking;
	}

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
