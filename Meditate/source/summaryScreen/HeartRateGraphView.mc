using Toybox.Math;
using Toybox.System;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Activity as Activity;
using Toybox.SensorHistory as SensorHistory;
using Toybox.ActivityMonitor as ActivityMonitor;

class HeartRateGraphView extends GraphView  {
		function initialize(summaryModel) {
			GraphView.initialize(summaryModel.hrHistory, summaryModel.elapsedTime, Rez.Strings.SummaryHR, 20, 150);
		}
}
