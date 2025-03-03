using Toybox.Graphics as Gfx;

module ScreenPicker {
	class HrvIcon extends Icon {
		function initialize(icon) {
			icon[:font] = StatusIconFonts.fontAwesomeFreeSolid;			
			icon[:symbol] = StatusIconFonts.Rez.Strings.IconHeartBeat;
			if (icon[:color] == null) {
				icon[:color] = HeartBeatRedColor;
			}
				
			Icon.initialize(icon);
		}
		
		const HeartBeatGreenColor = Gfx.COLOR_GREEN;
		const HeartBeatRedColor = Gfx.COLOR_RED;
		
		function setStatusOn() {
			me.setColor(HeartBeatGreenColor);
		}
		
		function setStatusOnDetailed() {
			me.setColor(HeartBeatGreenColor);
		}
		
		function setStatusOff() {
			me.setColor(Gfx.COLOR_LT_GRAY);
		}
		
		function setStatusWarning() {
			me.setColor(Gfx.COLOR_YELLOW);
		}
	} 
}