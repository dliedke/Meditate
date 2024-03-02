using Toybox.Math;
using Toybox.System;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Activity as Activity;
using Toybox.SensorHistory as SensorHistory;
using Toybox.ActivityMonitor as ActivityMonitor;

class RespirationRateGraphView extends ScreenPicker.ScreenPickerView  {

    hidden var position_x, position_y;
    hidden var graph_width, graph_height;
	var centerX;
	var centerY;
	var summaryModel;
	var resultsTheme;

    function initialize(summaryModel) {
    	ScreenPickerView.initialize(Gfx.COLOR_BLACK);
		me.summaryModel = summaryModel;
		resultsTheme = GlobalSettings.loadResultsTheme();
    }
	
    // Update the view
    function onUpdate(dc) {    

		// Light results theme
		var backgroundColor = Gfx.COLOR_WHITE;
		var foregroundColor = Gfx.COLOR_BLACK;

		// Dark results theme
		if (resultsTheme == ResultsTheme.Dark) {
			backgroundColor = Gfx.COLOR_BLACK;
			foregroundColor = Gfx.COLOR_WHITE;
		}

		// Clear the screen
		dc.setColor(Gfx.COLOR_TRANSPARENT, backgroundColor);
        dc.clear();
    	ScreenPickerView.onUpdate(dc);

		// Calculate center of the screen
		centerX = dc.getWidth()/2;
		centerY = dc.getHeight()/2;

		// Calculate position of the chart
		position_x = centerX - (centerX / 1.5) - App.getApp().getProperty("heartRateChartXPos");
		position_y = centerY + (centerY / 2) - App.getApp().getProperty("heartRateChartYPos");
	
		graph_height = dc.getHeight() / 3;
		graph_width =  App.getApp().getProperty("heartRateChartWidth");

		if (me.summaryModel.minRr instanceof String) {
			me.summaryModel.minRr = "--";
		}

		if (me.summaryModel.maxRr instanceof String) {
			me.summaryModel.maxRr = "--";
		}

		if (me.summaryModel.avgRr instanceof String) {
			me.summaryModel.avgRr = "--";
		}
		
		dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);

		// Draw title text
		dc.drawText(centerX, 
					25, 
					App.getApp().getProperty("largeFont"), 
					Ui.loadResource(Rez.Strings.SummaryRespiration), 
					Graphics.TEXT_JUSTIFY_CENTER);

		// Draw MIN RR text
		dc.drawText(centerX - centerX / 2 + 10, 
					centerY - centerY / 2 + 10, 
					Gfx.FONT_SYSTEM_TINY, 
					Ui.loadResource(Rez.Strings.SummaryRespirationMin) + me.summaryModel.minRr.toString(), 
					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

		// Draw AVG RR text
		dc.drawText(centerX, 
					centerY + centerY / 2 + 3, 
					Gfx.FONT_SYSTEM_TINY, 
					Ui.loadResource(Rez.Strings.SummaryRespirationAvg) + me.summaryModel.avgRr.toString(), 
					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

		// Draw MAX RR text
		dc.drawText(centerX + centerX / 2 - 10, 
					centerY - centerY / 2 + 10, 
					Gfx.FONT_SYSTEM_TINY, 
					Ui.loadResource(Rez.Strings.SummaryRespirationMax) + me.summaryModel.maxRr.toString(), 
					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

		// Retrieve saved RR history for this activity
		var respirationRateHistory = me.summaryModel.rrHistory;
		
		// Validate if we have respirate rate history
		if (respirationRateHistory == null || respirationRateHistory.size() <=0) {
			return;
		}
		
		//DEBUG
		//me.summaryModel.minRr = 7;
		//me.summaryModel.maxRr = 14;

		// Get min and max RR and check if they are valid
		var HistoryMin = me.summaryModel.minRr;
		var HistoryMax = me.summaryModel.maxRr;

		if (HistoryMin instanceof String) {
			return;
		}

		if (HistoryMax instanceof String) {
			return;
		}

		// Reduce a bit the min respiration rate so it will show in the chart
		HistoryMin-=1;

		// Calculate different between min and max RR
		var minMaxDiff = (HistoryMax - HistoryMin).toFloat();

		// Calculate number of horizontal lines that will be required for chart
		var numberHorizontalLines = 4;

		// If we only have 3 numbers to draw, draw 3 lines 
		if (minMaxDiff <=3 ) {
			numberHorizontalLines = 3;
		}

		// If we only have 2 numbers to draw, draw 2 lines 
		if (minMaxDiff <=2 ) {
			numberHorizontalLines = 2;
		}

		// If we only have 1 number to draw, draw 1 lines 
		if (minMaxDiff <=1 ) {
			numberHorizontalLines = 1;
		}


		// Chart as light blue
		dc.setPenWidth(1);
		dc.setColor(0x27a0c4, Graphics.COLOR_TRANSPARENT);
		
		// Try adapting the chart for the graph width
		var skipSize = 1;
		var skipSizeFloatPart = 0;

		// If chart would be larger than expected graph width
		if (respirationRateHistory.size() > graph_width) {

			// Calculate with maximum precision the skip
			skipSizeFloatPart = respirationRateHistory.size().toFloat() / graph_width.toFloat();
			skipSizeFloatPart = skipSizeFloatPart - Math.floor(skipSizeFloatPart);
			skipSizeFloatPart = skipSizeFloatPart * 10000000;

			// Calculate the basic skip for the for loop
			skipSize = Math.floor(respirationRateHistory.size().toFloat() / graph_width.toFloat()).toNumber();
		} 
		
		// Draw RR chart
		var xStep = 1;
		for (var i = 0; i < respirationRateHistory.size(); i+=skipSize){
			
			var respirationRate = respirationRateHistory[i];
			
			if (respirationRate!=null && respirationRate > 1) {

				var lineHeight = (respirationRate-HistoryMin) * (graph_height.toFloat() / minMaxDiff.toFloat());
				
				dc.drawLine(position_x + xStep, 
							position_y - lineHeight.toNumber(), 
							position_x + xStep, 
							position_y);
			}

			// Skip to fit the chart in the screen
			if (skipSizeFloatPart > 0) {
				if ((xStep * 1000000) % (skipSizeFloatPart).toNumber() > 1000000) {
					i++;			
				}
			}

			xStep++;
		}

		// Draw lines and labels 
		dc.setPenWidth(1);
		dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);

		var lineSpacing = graph_height / numberHorizontalLines;

		for(var i = 0; i <= numberHorizontalLines; i++){

			// Draw horizontal lines over chart
			dc.drawLine(position_x + 3, 
						position_y - (lineSpacing * i), 
						position_x + graph_width, 
						position_y - (lineSpacing * i));

			if (i!=0) {

				// Draw labels for the lines except last one
				dc.drawText(position_x + App.getApp().getProperty("heartRateChartXPosLabel"), 
							position_y - (lineSpacing * i), 
							Gfx.FONT_SYSTEM_XTINY, 
							Math.ceil(HistoryMin + (minMaxDiff / numberHorizontalLines) * i).toNumber().toString(), 
							Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
			}
		}
		
    }
}