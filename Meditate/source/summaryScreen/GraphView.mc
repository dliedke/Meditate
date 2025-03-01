using Toybox.Math;
using Toybox.System;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Activity as Activity;
using Toybox.SensorHistory as SensorHistory;
using Toybox.ActivityMonitor as ActivityMonitor;

class GraphView extends ScreenPicker.ScreenPickerView  {

	var positionX, positionY;
	var chartToLabelOffset;
	var graphWidth, graphHeight;
	var centerX, centerY;
	var data;
	var min, max, avg;
	var elapsedTime;
	var title;
	var resultsTheme;
	var minCut, maxCut;

	function initialize(data, elapsedTime, title, minCut, maxCut) {
		me.minCut = minCut;
		me.maxCut = maxCut;
		me.data = data;
		me.avg = null;
		me.min = null;
		me.max = null;
		var val = null;
		var total = 0;
		var count = 0;
		if(me.data != null) {
			for (var i = 0; i < me.data.size(); i++){
				val = me.data[i];
				if (val != null) {
					if (me.min == null || val < me.min) {
						me.min = val;
					}
					if (me.max == null || val > me.max) {
						me.max = val;
					}
					total+=val;
					count++;
				}
			}
		}
		if (count > 0) {
			me.avg = total / count;
		}

		me.elapsedTime = elapsedTime;
		me.title = title;
		ScreenPickerView.initialize(Gfx.COLOR_BLACK);
		resultsTheme = GlobalSettings.loadResultsTheme();
	}

	static function formatNumber(number) {
		if (number == null) {
			return " --";
		} else {
			return Math.round(number).format("%3.0f");
		}
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
		me.positionX = centerX - (centerX / 1.5) - App.getApp().getProperty("ChartXPos");
		me.positionY = centerY + (centerY / 2) - App.getApp().getProperty("ChartYPos");
	
		me.graphHeight = dc.getHeight() / 3;
		me.graphWidth = App.getApp().getProperty("ChartWidth");
		me.chartToLabelOffset = Math.ceil(me.graphWidth * 0.01);
	
		dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);

		// Draw title text
		dc.drawText(centerX, 
					App.getApp().getProperty("ChartTitleY"), 
					App.getApp().getProperty("largeFont"), 
					Ui.loadResource(me.title), 
					Graphics.TEXT_JUSTIFY_CENTER);
		
		// Draw MIN text
		dc.drawText(centerX - centerX / 2 + 10, 
					centerY - centerY / 2 + 10, 
					Gfx.FONT_SYSTEM_TINY, 
					Ui.loadResource(Rez.Strings.SummaryMin) + me.formatNumber(me.min), 
					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

		// Draw AVG text
		dc.drawText(centerX, 
					centerY + centerY / 2 + 3, 
					Gfx.FONT_SYSTEM_TINY, 
					Ui.loadResource(Rez.Strings.SummaryAvg) + me.formatNumber(me.avg), 
					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

		// Draw MAX text
		dc.drawText(centerX + centerX / 2 - 10, 
					centerY - centerY / 2 + 10, 
					Gfx.FONT_SYSTEM_TINY, 
					Ui.loadResource(Rez.Strings.SummaryMax) + me.formatNumber(me.max), 
					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

		// Draw Time text
		dc.drawText(centerX, 
					centerY + centerY / 1.5 + 13, 
					Gfx.FONT_SYSTEM_TINY, 
					TimeFormatter.format(me.elapsedTime), 
					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

		// Draw data if available
		var minMaxDiff = null;
		var yMin = null;
		var yMax = null;
		if (me.data != null && me.data.size() > 1 && me.min != null && me.max != null) {
			// Calculate different between min and max
			minMaxDiff = me.max - me.min;

			// allow for some space between data and chart min/max
			var minCutSet = me.minCut != null;
			var maxCutSet = me.maxCut != null;
			var yOffset = Math.ceil(minMaxDiff * 0.1);			
			yMin = Math.floor(me.min - yOffset);
			yMax = Math.ceil(me.max + yOffset);

			// if y-cuts set, make sure graph stays within set range
			if (minCutSet && yMin < me.minCut) {
				yMin = me.minCut;
			}
			if (maxCutSet && yMin > me.maxCut){
				yMin = me.maxCut;
			}

			if (maxCutSet && yMax > me.maxCut) {
				yMax = me.maxCut;
			}
			if (minCutSet && yMax < me.minCut) {
				yMax = me.minCut;
			}

			// update min max diff and make sure > 0
			minMaxDiff = yMax - yMin;
			if (minMaxDiff < 1) {
				var tmpOffset = Math.ceil(yMax * 0.1);
				if(maxCutSet && yMax + tmpOffset < me.maxCut){
					yMax+=tmpOffset;
				} 
				if(minCutSet && yMin - tmpOffset > me.minCut){
					yMin-=tmpOffset;
				} 
				if (yMax - yMin < 1){
					yMin-=tmpOffset;
					yMax+=tmpOffset;
				}
				minMaxDiff = yMax - yMin;
			}

			// Chart as light blue
			dc.setPenWidth(1);
			dc.setColor(0x27a0c4, Graphics.COLOR_TRANSPARENT);
			
			// Try adapting the chart for the graph width
			var dataWidthRatio = 0.0;
			var expandFact = 1;
			var bucketSize = 1;

			dataWidthRatio = me.data.size() / me.graphWidth.toFloat();
			
			if (dataWidthRatio > 1) {
				// Calculate bucket size
				bucketSize = Math.round(dataWidthRatio).toNumber();
			} else {
				bucketSize = 1;
				// Calculate the expanding
				expandFact = 2;
				while (expandFact * me.data.size() < me.graphWidth) {
					expandFact++;
				}
				expandFact--;
			}
			
			// Draw chart
			var lineHeight = null;
			var val = null;
			var heightFact = me.graphHeight.toFloat() / minMaxDiff;
			var xPos = me.positionX + 1 + chartToLabelOffset; // leave some space to labels
			var bucketVal = 0;
			var bucketCount = 0;
			for (var i = 0; i < me.data.size(); i++){
				val = me.data[i];
				if (val!=null) {
					bucketVal+=val;
					bucketCount++;
				}
				// skip first, draw last, else every full bucket
				if(i > 0 && (i==me.data.size() -1 || i % bucketSize == 0)) {
					// draw bucket
					if (bucketCount > 0) {
						// calc average of bucket
						val = bucketVal / bucketCount;
						
						// cut data if exceeds limits
						if (minCutSet && me.minCut > val) {
							val = me.minCut;
						}
						if (maxCutSet && me.maxCut < val) {
							val = me.maxCut;
						}

						// draw line
						lineHeight = Math.round((val-yMin) * heightFact).toNumber();
						for (var j = 0; j < expandFact; j++){
							dc.drawLine(xPos, 
										me.positionY - lineHeight, 
										xPos, 
										me.positionY);
							xPos++;
						}
						// reset bucket
						bucketVal = 0;
						bucketCount = 0;
					} else {
						// jump over null values
						xPos+=expandFact;
					}
				}
			}
		}
		// Draw lines and labels 
		dc.setPenWidth(1);
		dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
		if (minMaxDiff == null) {
			minMaxDiff = 100;
			yMin = 0;
		}
		var numLines = minMaxDiff;
		// max 4 lines
		if (numLines > 4) {
			numLines = 4;
		}
		var lineSpacing = Math.floor(me.graphHeight / numLines.toFloat());

		for(var i = 0; i <= numLines; i++){
			// Draw lines over chart
			dc.drawLine(me.positionX + me.chartToLabelOffset, 
						me.positionY - (lineSpacing * i), 
						me.positionX + me.graphWidth, 
						me.positionY - (lineSpacing * i));

			// Draw labels for the lines except last one
			dc.drawText(me.positionX, 
						me.positionY - (lineSpacing * i), 
						Gfx.FONT_SYSTEM_XTINY, 
						Math.round(yMin + (minMaxDiff / numLines) * i).toNumber().toString(), 
						Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);
		}
    }
}