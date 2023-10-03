using Toybox.Lang;
using Toybox.Timer;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;

class MeditatePrepareView extends Ui.View {
	private var mOnShow;
	private var mMainDurationRenderer;
	private var mSeconds; 
    private var mTotalSeconds;

	function initialize(onShow) {
		View.initialize();
		me.mOnShow = onShow;
		mSeconds = 0;
		mTotalSeconds = GlobalSettings.loadPrepareTime();
	}
	
	function onViewDrawn() {

		if (mSeconds >= mTotalSeconds+1) {
			return;
		}

		mSeconds += 1;
    	Ui.requestUpdate();

		// Start the meditation session after XX seconds
		if (mSeconds == mTotalSeconds+1) {

			// Vibrate short to notify session starts
			Vibe.vibrate(VibePattern.Blip);
			
			// Starts the meditation session
			me.mOnShow.invoke();

			return;
		}

		// Try to keep backlight on during preparation time
		try {

			if ((Attention has :backlight) ) {
					if (mSeconds == 1 || (mSeconds % 8 == 0)) {
						Attention.backlight(true);
					}
			}

		} catch(ex) { 

			// Just in case we get a BacklightOnTooLongException for OLED display devices (ex: Venu2)
			if ((Attention has :backlight) ) {
					Attention.backlight(false);
				}
		}
	}
	
	function onLayout(dc) {   

		// Clear the screen
        renderBackground(dc);   

		var durationArcRadius = dc.getWidth() / 2;
        var mainDurationArcWidth = dc.getWidth() / 4;

		// For rectangle screens we need to set this manually 
		var mainDurationArcWidthConfig = App.getApp().getProperty("meditateActivityDurationArcWidth");
		if (mainDurationArcWidthConfig != null) {
			mainDurationArcWidth = mainDurationArcWidthConfig;
		}

		// Configure the arc render for progress
        me.mMainDurationRenderer = new ElapsedDurationRenderer(Gfx.COLOR_BLUE, durationArcRadius, mainDurationArcWidth);
    }     
	
	private function renderBackground(dc) {				        

		// Clear the screen
        dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK);        
        dc.clear();        
    }

	function onShow() {	
		var viewDrawnTimer = new Timer.Timer();
		viewDrawnTimer.start(method(:onViewDrawn), 1000, true);		
	}
		
	function onUpdate(dc) {     
		View.onUpdate(dc);

		// Draw arc with the progress
		me.mMainDurationRenderer.drawOverallElapsedTime(dc, mSeconds, mTotalSeconds);

		// Calculate center of the screen
		var centerX = dc.getWidth()/2;
		var centerY = dc.getHeight()/2;

		// Calculate minutes and seconds from the remaining seconds
		var remainingSeconds = mTotalSeconds - mSeconds;
		var minutes = remainingSeconds / 60;
		var seconds = remainingSeconds % 60;

		// Render main text with the remaining time in the format M:SS
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.drawText(centerX, 
					centerY-centerY/3, 
					Gfx.FONT_SYSTEM_TINY, 
					Ui.loadResource(Rez.Strings.meditateActivityPrepare) + " " + minutes + ":" + (seconds < 10 ? "0" : "") + seconds,
					Graphics.TEXT_JUSTIFY_CENTER);

	}
	
	function onHide() {
	}
}