using Toybox.WatchUi as Ui;
using Toybox.Lang;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Timer;

class MeditateView extends ScreenPicker.ScreenPickerDetailsView {
	private var mMeditateModel;
	private var mMainDurationRenderer;
	private var mIntervalAlertsRenderer;
	private var mElapsedTimeLine;
	private var mHrStatusLine;
	private var mHrvStatusLine;
	private var mRrStatusLine;
	private var mStressStatusLine;
	private var mHrvIcon;
	private var mHrvText;
	private var mStressIcon;
	private var mStressText;
	private var mBreathIcon;
	private var mBreathText;
	private var mMeditateIcon;
	private var mRespirationRateYPosOffset;

	function initialize(meditateModel) {
		ScreenPicker.ScreenPickerDetailsView.initialize(meditateModel, false);
		me.mMeditateModel = meditateModel;
		me.mMainDurationRenderer = null;
		me.mIntervalAlertsRenderer = null;
		me.mElapsedTimeLine = null;
		me.mHrStatusLine = null;
		me.mHrvStatusLine = null;
		me.mStressStatusLine = null;
		me.mRrStatusLine = null;
		me.mMeditateIcon = null;
	}

	private static const TextFont = App.getApp().getProperty("largeFont");

	// Load your resources here
	function onLayout(dc) {
		ScreenPicker.ScreenPickerDetailsView.onLayout(dc);

		var lineNum = 0;
		me.mHrStatusLine = me.mMeditateModel.getLine(lineNum);
		lineNum++;

		if (me.mMeditateModel.isHrvOn()) {
			me.mHrvStatusLine = me.mMeditateModel.getLine(lineNum);
			lineNum++;
		}
		me.mRrStatusLine = me.mMeditateModel.getLine(lineNum);
		lineNum++;

		me.mStressStatusLine = me.mMeditateModel.getLine(lineNum);
		var durationArcRadius = dc.getWidth() / 2;
		var mainDurationArcWidth = dc.getWidth() / 8;

		// For rectangle screens we need to set this manually
		var mainDurationArcWidthConfig = App.getApp().getProperty("meditateActivityDurationArcWidth");
		if (mainDurationArcWidthConfig != null) {
			mainDurationArcWidth = mainDurationArcWidthConfig;
		}

		me.mMainDurationRenderer = new ElapsedDurationRenderer(
			me.mMeditateModel.getColor(),
			durationArcRadius,
			mainDurationArcWidth
		);

		if (me.mMeditateModel.hasIntervalAlerts()) {
			var intervalAlertsArcRadius = dc.getWidth() / 2;
			var intervalAlertsArcWidth = dc.getWidth() / 16;
			me.mIntervalAlertsRenderer = new IntervalAlertsRenderer(
				me.mMeditateModel.getSessionTime(),
				me.mMeditateModel.getOneOffIntervalAlerts(),
				me.mMeditateModel.getRepeatIntervalAlerts(),
				intervalAlertsArcRadius,
				intervalAlertsArcWidth
			);
		}
	}

	var lastElapsedTime = -1;

	// Update the view
	function onUpdate(dc) {
		var elapsedTime = me.mMeditateModel.elapsedTime;
		// Only update every second
		if (elapsedTime != lastElapsedTime || !me.mMeditateModel.isTimerRunning) {
			var currentHr = null;
			var currentHrv = null;
			var currentRr = null;
			var currentStress = null;
			var currentElapsedTime = null;
			if (me.mMeditateModel.isTimerRunning) {
				if (me.mMeditateIcon != null) {
					mMeditateIcon.draw(dc);
				}

				var timeText = TimeFormatter.format(elapsedTime);
				currentElapsedTime = timeText.substring(0, timeText.length() - 3);

				currentHr = me.mMeditateModel.currentHr;

				if (me.mMeditateModel.isHrvOn() == true) {
					currentHrv = me.mMeditateModel.hrvValue;
				}

				if (me.mMeditateModel.isRespirationRateOn()) {
					currentRr = me.mMeditateModel.getRespirationRate();
				}
				currentStress = me.mMeditateModel.getStress();
			} else {
				// if activity is paused, render the [Paused] text
				currentElapsedTime = Ui.loadResource(Rez.Strings.meditateActivityPaused);
			}
			var iconColor = null;
			me.mMeditateModel.title = currentElapsedTime;
			me.mHrStatusLine.value.text = me.formatValue(currentHr);
			if (currentHr != null) {
				iconColor = Graphics.COLOR_RED;
			} else {
				iconColor = Graphics.COLOR_LT_GRAY;
			}
			me.mHrStatusLine.icon = new ScreenPicker.Icon({
				:font => StatusIconFonts.fontAwesomeFreeSolid,
				:symbol => StatusIconFonts.Rez.Strings.faHeart,
				:color => iconColor,
			});

			me.mHrvStatusLine.value.text = me.formatValue(currentHrv);
			if (me.mMeditateModel.isHrvOn() == true && currentHr != null) {
				iconColor = Graphics.COLOR_RED;
			} else {
				iconColor = Graphics.COLOR_LT_GRAY;
			}
			me.mHrvStatusLine.icon = new ScreenPicker.HrvIcon({
				:color => iconColor,
			});

			me.mRrStatusLine.value.text = me.formatValue(currentRr);
			if (currentRr != null) {
				iconColor = Graphics.COLOR_BLUE;
			} else {
				iconColor = Graphics.COLOR_LT_GRAY;
			}
			me.mRrStatusLine.icon = new ScreenPicker.BreathIcon({
				:color => iconColor,
			});

			me.mStressStatusLine.value.text = me.formatValue(currentStress);
			me.mStressStatusLine.icon = new ScreenPicker.StressIcon({});
			me.mStressStatusLine.icon.setStress(currentStress);

			ScreenPicker.ScreenPickerDetailsView.onUpdate(dc);
			var alarmTime = me.mMeditateModel.getSessionTime();

			// Fix issues with OLED screens for prepare time 45 seconds
			if (elapsedTime <= 1) {
				Attention.backlight(false);
			}

			// Enable backlight in the first 8 seconds then turn off to save battery
			if (elapsedTime > 0 && elapsedTime <= 8) {
				Attention.backlight(true);
			}

			if (elapsedTime == 9) {
				Attention.backlight(false);
			}

			me.mMainDurationRenderer.drawOverallElapsedTime(dc, elapsedTime, alarmTime);
			if (me.mIntervalAlertsRenderer != null) {
				me.mIntervalAlertsRenderer.drawRepeatIntervalAlerts(dc);
				me.mIntervalAlertsRenderer.drawOneOffIntervalAlerts(dc);
			}
		}
		lastElapsedTime = elapsedTime;
	}
}
