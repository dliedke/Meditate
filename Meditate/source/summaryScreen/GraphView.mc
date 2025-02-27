using Toybox.Math;
using Toybox.System;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Activity as Activity;
using Toybox.SensorHistory as SensorHistory;
using Toybox.ActivityMonitor as ActivityMonitor;

class GraphView extends ScreenPicker.ScreenPickerView  {

	hidden var position_x, position_y;
	hidden var graph_width, graph_height;
	var centerX;
	var centerY;
	var data;
	var min;
	var max;
	var avg;
	var elapsedTime;
	var title;
	var resultsTheme;

    function initialize(data, min, max, avg, elapsedTime, title) {
		me.data = data;
		me.min = min;
		me.max = max;
		me.avg = avg;
		me.elapsedTime = elapsedTime;
		me.title = title;
		ScreenPickerView.initialize(Gfx.COLOR_BLACK);
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
		position_x = centerX - (centerX / 1.5) - App.getApp().getProperty("ChartXPos");
		position_y = centerY + (centerY / 2) - App.getApp().getProperty("ChartYPos");
	
		graph_height = dc.getHeight() / 3;
		graph_width =  App.getApp().getProperty("ChartWidth");

		if (me.min instanceof String) {
			me.min = "--";
		}

		if (me.max instanceof String) {
			me.max = "--";
		}

		if (me.avg instanceof String) {
			me.avg = "--";
		}
		
		dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);

		// Draw title text
		dc.drawText(centerX, 
					App.getApp().getProperty("ChartTitleY"), 
					App.getApp().getProperty("largeFont"), 
					Ui.loadResource(me.title), 
					Graphics.TEXT_JUSTIFY_CENTER);

		// Draw MIN HR text
		dc.drawText(centerX - centerX / 2 + 10, 
					centerY - centerY / 2 + 10, 
					Gfx.FONT_SYSTEM_TINY, 
					Ui.loadResource(Rez.Strings.SummaryMin) + me.min.toString(), 
					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

		// Draw AVG HR text
		dc.drawText(centerX, 
					centerY + centerY / 2 + 3, 
					Gfx.FONT_SYSTEM_TINY, 
					Ui.loadResource(Rez.Strings.SummaryAvg) + me.avg.toString(), 
					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

		// Draw MAX HR text
		dc.drawText(centerX + centerX / 2 - 10, 
					centerY - centerY / 2 + 10, 
					Gfx.FONT_SYSTEM_TINY, 
					Ui.loadResource(Rez.Strings.SummaryMax) + me.max.toString(), 
					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

		// Draw Time text
		dc.drawText(centerX, 
					centerY + centerY / 1.5 + 13, 
					Gfx.FONT_SYSTEM_TINY, 
					TimeFormatter.format(me.elapsedTime), 
					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
		
		// Validate if we have data history
		if (me.data == null || me.data.size() <=0) {
			return;
		}
		
		//DEBUG
		//me.min = 55;
		//me.max = 80;

		if(me.min instanceof String) {
			return;
		}

		if(me.max instanceof String) {
			return;
		}

		// Reduce a bit the min heart rate so it will show in the chart
		var yMin = Math.floor(me.min * 0.99);
		var yMax = Math.ceil(me.max * 1.01);

		// Calculate different between min and max HR
		var minMaxDiff = (yMax - yMin).toFloat();
		
		// Chart as light blue
		dc.setPenWidth(1);
		dc.setColor(0x27a0c4, Graphics.COLOR_TRANSPARENT);
		
		// Try adapting the chart for the graph width
		var skipSize = 1;
		var skipSizeFloatPart = 0;

		// If chart would be larger than expected graph width
		if (me.data.size() > graph_width) {

			// Calculate with maximum precision the skip
			skipSizeFloatPart = me.data.size().toFloat() / graph_width.toFloat();
			skipSizeFloatPart = skipSizeFloatPart - Math.floor(skipSizeFloatPart);
			skipSizeFloatPart = skipSizeFloatPart * 10000000;

			// Calculate the basic skip for the for loop
			skipSize = Math.floor(me.data.size().toFloat() / graph_width.toFloat()).toNumber();
		} 
		
		// Draw chart
		var xStep = 1;
		for (var i = 0; i < me.data.size(); i+=skipSize){
			
			var val = me.data[i];
			
			if (val!=null && val > 1) {

				var lineHeight = (val-yMin) * (graph_height.toFloat() / minMaxDiff.toFloat());

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
		var numLines = minMaxDiff;
		// max 4 lines
		if (numLines > 4) {
			numLines = 4;
		}
		var lineSpacing = graph_height / numLines;

		for(var i = 0; i <= numLines; i++){
			// Draw lines over chart
			dc.drawLine(position_x + 3, 
						position_y - (lineSpacing * i), 
						position_x + graph_width, 
						position_y - (lineSpacing * i));

			if (i!=0) {
				// Draw labels for the lines except last one
				dc.drawText(position_x + App.getApp().getProperty("ChartXPosLabel"), 
							position_y - (lineSpacing * i), 
							Gfx.FONT_SYSTEM_XTINY, 
							Math.round(yMin + (minMaxDiff / numLines) * i).toNumber().toString(), 
							Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
			}
		}
		
    }
}