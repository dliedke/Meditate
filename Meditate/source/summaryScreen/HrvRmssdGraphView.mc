using Toybox.Math;
using Toybox.System;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Activity as Activity;
using Toybox.SensorHistory as SensorHistory;
using Toybox.ActivityMonitor as ActivityMonitor;

class HrvRmssdGraphView extends GraphView  {
		function initialize(summaryModel) {
			GraphView.initialize(summaryModel.hrvRmssdHistory, summaryModel.elapsedTime, Rez.Strings.SummaryHRVRMSSD, 10, 250);
		}
}
