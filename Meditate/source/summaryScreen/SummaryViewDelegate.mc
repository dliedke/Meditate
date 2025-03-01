using Toybox.Time.Gregorian as Calendar;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Lang;
using HrvAlgorithms.HrvTracking;

class SummaryViewDelegate extends ScreenPicker.ScreenPickerDelegate {
	private var mSummaryModel;
	private var mDiscardDanglingActivity;
	private var pages;
	private static const pageHeartRateGraph = "HeartRateGraph";
	private static const pageRespirationRateGraph = "RespirationRateGraph";
	private static const pageStressGraph = "StressGraph";
	private static const pageStress = "Stress";
	private static const pageHrvRmssd = "HrvRmssd";
	private static const pageHrvPnnx = "HrvPnnx";
	private static const pageHrvSdrr = "HrvSdrr";
	private static const pageHrvRmssdGraph = "HrvRmssdGraph";

	function initialize(summaryModel, isRespirationRateOn, discardDanglingActivity) {		
		me.setPageIndexes(summaryModel.hrvTracking, isRespirationRateOn);
		me.mPagesCount = me.pages.size();
		
        ScreenPickerDelegate.initialize(0, me.mPagesCount);
        me.mSummaryModel = summaryModel;
        me.mDiscardDanglingActivity = discardDanglingActivity;
        me.mSummaryLinesYOffset = App.getApp().getProperty("summaryLinesYOffset");
	}
		
	private var mSummaryLinesYOffset;
			
	private function getPagesCount(hrvTracking, isRespirationRateOn) {		
		return me.mPagesCount;
	}
	
	private function setPageIndexes(hrvTracking, isRespirationRateOn) {
		me.pages = new [0];
		me.pages.add(me.pageHeartRateGraph);
		if (isRespirationRateOn) {
			me.pages.add(me.pageRespirationRateGraph);
		}
		if (hrvTracking == HrvTracking.On or hrvTracking == HrvTracking.OnDetailed){
			me.pages.add(me.pageStressGraph);
			me.pages.add(me.pageStress);
			me.pages.add(me.pageHrvRmssd);
			if (hrvTracking == HrvTracking.OnDetailed) {	
				me.pages.add(me.pageHrvPnnx);
				me.pages.add(me.pageHrvSdrr);
				me.pages.add(me.pageHrvRmssdGraph);
			}
		}
	}
	// Light results theme
	var backgroundColor = Gfx.COLOR_WHITE;
	var foregroundColor = Gfx.COLOR_BLACK;

	function onBack() {
		if (me.mDiscardDanglingActivity != null) {
			me.mDiscardDanglingActivity.invoke();
		}
		
		return false;
	}
	
	function createScreenPickerView() {
		var details;
	
		// Dark results theme
		if (GlobalSettings.loadResultsTheme() == ResultsTheme.Dark) {
			backgroundColor = Gfx.COLOR_BLACK;
			foregroundColor = Gfx.COLOR_WHITE;
		}
		if (me.mSelectedPageIndex < me.mPagesCount) {
			var page = me.pages[me.mSelectedPageIndex];
			if (page.equals(me.pageHeartRateGraph)) {
				return new HeartRateGraphView(me.mSummaryModel);
			}
			else if (page.equals(me.pageRespirationRateGraph)) {
				return new RespirationRateGraphView(me.mSummaryModel);
			}
			else if (page.equals(me.pageStressGraph)) {
				return new StressGraphView(me.mSummaryModel);
			}
			else if (page.equals(me.pageStress)) {
				details = me.createDetailsPageStress();
			}
			else if (page.equals(me.pageHrvRmssd)) {
				details = me.createDetailsPageHrvRmssd();
			}
			else if (page.equals(me.pageHrvPnnx)) {
				details = me.createDetailsPageHrvPnnx();
			}
			else if (page.equals(me.pageHrvSdrr)) {
				details = me.createDetailsPageHrvSdrr();
			}
			else if (page.equals(me.pageHrvRmssdGraph)) {
				return new HrvRmssdGraphView(me.mSummaryModel);
			}
			else {
				return new HeartRateGraphView(me.mSummaryModel);
			}	
		} 
		else {
			return new HeartRateGraphView(me.mSummaryModel);
		}
		if (me.mPagesCount > 1) {
			return new ScreenPicker.ScreenPickerDetailsView(details);
		}
		else {
			return new ScreenPicker.ScreenPickerDetailsSinglePageView(details);
		}
	}	
			
	private function createDetailsPageStress() {
		var details = new ScreenPicker.DetailsModel();
		details.title = Ui.loadResource(Rez.Strings.SummaryStress);

		details.color = foregroundColor;
        details.backgroundColor = backgroundColor;
        details.titleColor = foregroundColor;

 		if (me.mSummaryModel.firstSt!=null && me.mSummaryModel.lastSt!=null) {

				var lowStressIcon = new ScreenPicker.StressIcon({});
    			lowStressIcon.setLowStress();	      
        		details.detailLines[3].icon = lowStressIcon;  
				details.detailLines[3].value.color = foregroundColor;
				details.detailLines[3].value.text = Lang.format(Ui.loadResource(Rez.Strings.SummaryStressStart), [me.mSummaryModel.firstSt.format("%d")]);

				lowStressIcon = new ScreenPicker.StressIcon({});
    			lowStressIcon.setLowStress();	      
        		details.detailLines[4].icon = lowStressIcon;  
				details.detailLines[4].value.color = foregroundColor;            
				details.detailLines[4].value.text = Lang.format(Ui.loadResource(Rez.Strings.SummaryStressEnd), [me.mSummaryModel.lastSt.format("%d")]);
		}

    	var lowStressIcon = new ScreenPicker.StressIcon({});
    	lowStressIcon.setLowStress();	      
        details.detailLines[2].icon = lowStressIcon;  
		details.detailLines[2].value.color = foregroundColor;   
        details.detailLines[2].value.text = Lang.format("$1$ %", [me.mSummaryModel.avgSt]);
                 
        var summaryStressIconsXPos = App.getApp().getProperty("summaryStressIconsXPos");
        var summaryStressValueXPos = App.getApp().getProperty("summaryStressValueXPos");
        details.setAllIconsXPos(summaryStressIconsXPos);
        details.setAllValuesXPos(summaryStressValueXPos);   
        details.setAllLinesYOffset(me.mSummaryLinesYOffset);
        
        return details;
	}
	
	private function createDetailsPageHrvRmssd() {
		var details = new ScreenPicker.DetailsModel();
		details.title = Ui.loadResource(Rez.Strings.SummaryHRVRMSSD);

		details.color = foregroundColor;
        details.backgroundColor = backgroundColor;
        details.titleColor = foregroundColor;

        details.detailLines[3].icon = new ScreenPicker.HrvIcon({});              
		details.detailLines[3].value.color = foregroundColor;
        details.detailLines[3].value.text = Lang.format("$1$ ms", [me.mSummaryModel.hrvRmssd]);
                 
        var hrvIconsXPos = App.getApp().getProperty("summaryHrvIconsXPos");
        var hrvValueXPos = App.getApp().getProperty("summaryHrvValueXPos");
        details.setAllIconsXPos(hrvIconsXPos);
        details.setAllValuesXPos(hrvValueXPos); 
        details.setAllLinesYOffset(me.mSummaryLinesYOffset);
        
        return details;
	}	
	
	private function createDetailsPageHrvPnnx() {
		var details = new ScreenPicker.DetailsModel();
		details.title = Ui.loadResource(Rez.Strings.SummaryHRVpNNx);

		details.color = foregroundColor;
        details.backgroundColor = backgroundColor;
        details.titleColor = foregroundColor;

        var hrvIcon = new ScreenPicker.HrvIcon({});            
        details.detailLines[2].icon = hrvIcon;      
        details.detailLines[2].value.color = foregroundColor;        
        details.detailLines[2].value.text = "pNN20";
        
		details.detailLines[3].value.color = foregroundColor;
        details.detailLines[3].value.text = Lang.format("$1$ %", [me.mSummaryModel.hrvPnn20]);
        
    	details.detailLines[4].icon = hrvIcon;
		details.detailLines[4].value.color = foregroundColor;
        details.detailLines[4].value.text = "pNN50";
		details.detailLines[5].value.color = foregroundColor;
        details.detailLines[5].value.text = Lang.format("$1$ %", [me.mSummaryModel.hrvPnn50]);  
         
        var hrvIconsXPos = App.getApp().getProperty("summaryHrvIconsXPos");
        var hrvValueXPos = App.getApp().getProperty("summaryHrvValueXPos");
        details.setAllIconsXPos(hrvIconsXPos);
        details.setAllValuesXPos(hrvValueXPos); 
        details.setAllLinesYOffset(me.mSummaryLinesYOffset);
        
        return details;
	}	
	
	private function createDetailsPageHrvSdrr() {
		var details = new ScreenPicker.DetailsModel();
		details.title = Ui.loadResource(Rez.Strings.SummaryHRVSDRR);

		details.color = foregroundColor;
        details.backgroundColor = backgroundColor;
        details.titleColor = foregroundColor;
                        
        var hrvIcon = new ScreenPicker.HrvIcon({});            
        details.detailLines[2].icon = hrvIcon;      
		details.detailLines[2].value.color = foregroundColor;        
        details.detailLines[2].value.text = Ui.loadResource(Rez.Strings.SummaryHRVRMSSDFirst5min);
        
		details.detailLines[3].value.color = foregroundColor;
        details.detailLines[3].value.text = Lang.format("$1$ ms", [me.mSummaryModel.hrvFirst5Min]);
        
    	details.detailLines[4].icon = hrvIcon;
		details.detailLines[4].value.color = foregroundColor;
        details.detailLines[4].value.text = Ui.loadResource(Rez.Strings.SummaryHRVRMSSDLast5min);
		details.detailLines[5].value.color = foregroundColor;
        details.detailLines[5].value.text = Lang.format("$1$ ms", [me.mSummaryModel.hrvLast5Min]);  
         
        var hrvIconsXPos = App.getApp().getProperty("summaryHrvIconsXPos");
        var hrvValueXPos = App.getApp().getProperty("summaryHrvValueXPos");
        details.setAllIconsXPos(hrvIconsXPos);
        details.setAllValuesXPos(hrvValueXPos); 
        details.setAllLinesYOffset(me.mSummaryLinesYOffset);
        
        return details;
	}	
}