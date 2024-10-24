using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using HrvAlgorithms.HrvTracking;

class AboutDelegate extends ScreenPicker.ScreenPickerDelegate {

	private var mSessionPickerDelegate;
	
	function initialize(sessionPickerDelegate) {
		ScreenPickerDelegate.initialize(0, 1);	
		
		me.mGlobalSettingsIconsXPos = App.getApp().getProperty("globalSettingsIconsXPos");
		me.mGlobalSettingsValueXPos = App.getApp().getProperty("globalSettingsValueXPos");
		me.mGlobalSettingsLinesYOffset = App.getApp().getProperty("globalSettingsLinesYOffset");
		me.mGlobalSettingsTitle = Ui.loadResource(Rez.Strings.menuSessionSettings_about);
		me.mGlobalSettingsDetailsModel = new ScreenPicker.DetailsModel();
		me.mSessionPickerDelegate = sessionPickerDelegate;
		updateAboutDetails();
	}
	
	private var mGlobalSettingsTitle;
	private var mGlobalSettingsIconsXPos;
	private var mGlobalSettingsValueXPos;
	private var mGlobalSettingsDetailsModel;
	private var mGlobalSettingsLinesYOffset;
	
	function createScreenPickerView() {
		return new ScreenPicker.ScreenPickerDetailsSinglePageView(me.mGlobalSettingsDetailsModel);
	}
    
    private function updateAboutDetails() {
		var details = me.mGlobalSettingsDetailsModel;
		details.title = me.mGlobalSettingsTitle;
		details.titleFont = Gfx.FONT_SMALL;
        details.titleColor = Gfx.COLOR_WHITE;
        details.color = Gfx.COLOR_WHITE;
        details.backgroundColor = Gfx.COLOR_BLACK;
        		
		// Meditate text with green icon
        details.detailLines[2].icon = new ScreenPicker.Icon({        
	        	:font => StatusIconFonts.fontMeditateIcons,
	        	:symbol => StatusIconFonts.Rez.Strings.meditateFontYoga,
				:color => Gfx.COLOR_GREEN
	        });	

		// Application version and developers
		details.detailLines[2].value.text = Ui.loadResource(Rez.Strings.about_AppVersion);
		details.detailLines[3].value.text = Ui.loadResource(Rez.Strings.about_vtrifonov);
		details.detailLines[4].value.text = Ui.loadResource(Rez.Strings.about_dliedke);
		details.detailLines[5].value.text = Ui.loadResource(Rez.Strings.about_falsetru);
		
        details.setAllLinesYOffset(me.mGlobalSettingsLinesYOffset);
        details.setAllIconsXPos(me.mGlobalSettingsIconsXPos);
        details.setAllValuesXPos(me.mGlobalSettingsValueXPos);  
	}

	function onBack() {    
    	Ui.switchToView(me.mSessionPickerDelegate.createScreenPickerView(), me.mSessionPickerDelegate, Ui.SLIDE_RIGHT);
    	return true;
    }
}