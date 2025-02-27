using Toybox.Math;
using Toybox.System;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Activity as Activity;
using Toybox.SensorHistory as SensorHistory;
using Toybox.ActivityMonitor as ActivityMonitor;

class RespirationRateGraphView extends GraphView  {
		function initialize(summaryModel) {
			GraphView.initialize(summaryModel.rrHistory, summaryModel.minRr, summaryModel.maxRr, summaryModel.avgRr, summaryModel.elapsedTime, Rez.Strings.SummaryRespiration);
		}
}
