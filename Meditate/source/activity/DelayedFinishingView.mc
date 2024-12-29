using Toybox.WatchUi as Ui;
using Toybox.Timer;
using Toybox.Application as App;

class DelayedFinishingView extends Ui.View {
	private var mOnShow;
	private var mShouldAutoExit;

	function initialize(onShow, shouldAutoExit) {
		View.initialize();
		me.mOnShow = onShow;
		me.mShouldAutoExit = shouldAutoExit;
	}
	
	function onViewDrawn() {

		// Exit app if required
		if (me.mShouldAutoExit) {
			System.exit();
			return;
		}

		me.mOnShow.invoke();
	}
	
	function onLayout(dc) {    
        setLayout(Rez.Layouts.delayedFinishing(dc));
    }     
	
	function onShow() {	
		var viewDrawnTimer = new Timer.Timer();
		viewDrawnTimer.start(method(:onViewDrawn), 1000, false);		
	}
		
	function onUpdate(dc) {     
		View.onUpdate(dc);
	}
	
	function onHide() {
	}
}