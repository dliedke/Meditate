using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;

module ScreenPicker {
	class ScreenPickerViewBase extends Ui.View {
		var multiPage;
		var mUpArrow, mDownArrow;
		var centerXPos;
		var colorTheme;
		var backgroundColor, foregroundColor;
		private static const colorThemeKey = "globalSettings_resultsTheme";
		function initialize(multiPage) {
			View.initialize();
			if(multiPage != null && multiPage ) {
				me.multiPage = true;
				me.mUpArrow = new Icon({        
	        	:font => StatusIconFonts.fontAwesomeFreeSolid,
	        	:symbol => StatusIconFonts.Rez.Strings.faSortUp,
	        	:color=>foregroundColor,
	        	:justify => Gfx.TEXT_JUSTIFY_CENTER
				});
				me.mDownArrow = new Icon({        
					:font => StatusIconFonts.fontAwesomeFreeSolid,
					:symbol => StatusIconFonts.Rez.Strings.faSortDown,
					:color=>foregroundColor,
					:justify => Gfx.TEXT_JUSTIFY_CENTER
				});
			} else {
				me.multiPage = false;
			}
			colorTheme = App.Storage.getValue(colorThemeKey);
			// Light results theme
			backgroundColor = Gfx.COLOR_WHITE;
			foregroundColor = Gfx.COLOR_BLACK;

			// Dark results theme
			if (colorTheme == ResultsTheme.Dark) {
				backgroundColor = Gfx.COLOR_BLACK;
				foregroundColor = Gfx.COLOR_WHITE;
			}
		}

		protected function setArrowsColor(color) {
			if (me.multiPage) {
				me.mUpArrow.setColor(color);
				me.mDownArrow.setColor(color);
			}
		}
		
		function drawTitle(dc, title) {
			dc.drawText(dc.getWidth()/2,
						dc.getHeight() * 0.1,
						App.getApp().getProperty("largeFont"), 
						title,
						Graphics.TEXT_JUSTIFY_CENTER);
		}

		function drawArrows(dc) {
			centerXPos = dc.getWidth() / 2;
			me.mUpArrow.setXPos(centerXPos);
			me.mUpArrow.setYPos(0);
			me.mUpArrow.draw(dc);
			me.mDownArrow.setXPos(centerXPos);
			me.mDownArrow.setYPos(dc.getHeight() - dc.getFontHeight(StatusIconFonts.fontAwesomeFreeSolid));
			me.mDownArrow.draw(dc);	
		}

		function onUpdate(dc) {
			View.onUpdate(dc);
			dc.setColor(Gfx.COLOR_TRANSPARENT, backgroundColor);  
			dc.clear();
			dc.setColor(foregroundColor, Graphics.COLOR_TRANSPARENT);
			if(me.multiPage) {
				me.drawArrows(dc);
			}
	    } 
	}
}