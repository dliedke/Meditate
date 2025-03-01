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
	}
			
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
	
	function createScreenPickerView() {
		var detailsModel;

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
				detailsModel = me.createDetailsPageStress();
			}
			else if (page.equals(me.pageHrvRmssd)) {
				detailsModel = me.createDetailsPageHrvRmssd();
			}
			else if (page.equals(me.pageHrvPnnx)) {
				detailsModel = me.createDetailsPageHrvPnnx();
			}
			else if (page.equals(me.pageHrvSdrr)) {
				detailsModel = me.createDetailsPageHrvSdrr();
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
		return new ScreenPicker.ScreenPickerViewDetails(detailsModel, me.mPagesCount > 1);
	}	
			
	private function createDetailsPageStress() {
		var detailsModel = new ScreenPicker.DetailsModel();
		detailsModel.title = Ui.loadResource(Rez.Strings.SummaryStress);

		var line = null;
		var lowStressIcon = new ScreenPicker.StressIcon({});
    	lowStressIcon.setLowStress();
		line = detailsModel.getLine(0);
        line.icon = lowStressIcon;  
        line.value.text = Lang.format("$1$ %", [me.mSummaryModel.avgSt]);
		var offset = 0;
 		if (me.mSummaryModel.firstSt!=null && me.mSummaryModel.lastSt!=null) {
			line = detailsModel.getLine(1);
			line.value.text = Lang.format("$1$ $2$", [Ui.loadResource(Rez.Strings.SummaryStressStart), me.mSummaryModel.firstSt]);
			line = detailsModel.getLine(2);
			line.value.text = Lang.format("$1$ $2$", [Ui.loadResource(Rez.Strings.SummaryStressEnd), me.mSummaryModel.lastSt]);
			offset = 2;
		}
		
		if (me.mSummaryModel.minSt!=null && me.mSummaryModel.maxSt!=null) {
			line = detailsModel.getLine(1 + offset);
			line.value.text = Lang.format("$1$ $2$", [Ui.loadResource(Rez.Strings.SummaryMin), me.mSummaryModel.minSt]);           
			line = detailsModel.getLine(2 + offset);
			line.value.text = Lang.format("$1$ $2$", [Ui.loadResource(Rez.Strings.SummaryMax), me.mSummaryModel.maxSt]);
		}
        return detailsModel;
	}
	
	private function createDetailsPageHrvRmssd() {
		var detailsModel = new ScreenPicker.DetailsModel();
		detailsModel.title = Ui.loadResource(Rez.Strings.SummaryHRVRMSSD);
		var line = detailsModel.getLine(0);
        line.icon = new ScreenPicker.HrvIcon({});
        line.value.text = Lang.format("$1$ ms", [me.mSummaryModel.hrvRmssd]);        
        return detailsModel;
	}	
	
	private function createDetailsPageHrvPnnx() {
		var detailsModel = new ScreenPicker.DetailsModel();
		detailsModel.title = Ui.loadResource(Rez.Strings.SummaryHRVpNNx);

		var line = detailsModel.getLine(0);
        var hrvIcon = new ScreenPicker.HrvIcon({});    
        line.icon = hrvIcon;      
        line.value.text = "pNN20";
        
		line = detailsModel.getLine(1);
        line.value.text = Lang.format("$1$ %", [me.mSummaryModel.hrvPnn20]);

		line = detailsModel.getLine(2);
    	line.icon = hrvIcon;
        line.value.text = "pNN50";

		line = detailsModel.getLine(3);
        line.value.text = Lang.format("$1$ %", [me.mSummaryModel.hrvPnn50]);          
        
		return detailsModel;
	}	
	
	private function createDetailsPageHrvSdrr() {
		var detailsModel = new ScreenPicker.DetailsModel();
		detailsModel.title = Ui.loadResource(Rez.Strings.SummaryHRVSDRR);
        
		var line = detailsModel.getLine(0);
        var hrvIcon = new ScreenPicker.HrvIcon({});            
        line.icon = hrvIcon;           
        line.value.text = Ui.loadResource(Rez.Strings.SummaryHRVRMSSDFirst5min);

		line = detailsModel.getLine(1);
        line.value.text = Lang.format("$1$ ms", [me.mSummaryModel.hrvFirst5Min]);
        
		line = detailsModel.getLine(2);
    	line.icon = hrvIcon;
        line.value.text = Ui.loadResource(Rez.Strings.SummaryHRVRMSSDLast5min);
		line = detailsModel.getLine(3);
        line.value.text = Lang.format("$1$ ms", [me.mSummaryModel.hrvLast5Min]);          
        return detailsModel;
	}	
}
