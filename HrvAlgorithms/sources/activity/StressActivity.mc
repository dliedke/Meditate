using Toybox;
using Toybox.Time;
using Toybox.SensorHistory;
using Toybox.ActivityMonitor;

module HrvAlgorithms {
	class StressActivity extends SensorActivity {
		static var apiV5Plus;
		function initialize() {
			SensorActivity.initialize(new SensorSummary(), false);
		}

		static function isSensorSupported(){
			if ((Toybox has :ActivityMonitor) && (Toybox.ActivityMonitor has :Info) && (Toybox.ActivityMonitor.Info has :stressScore)) {
				me.apiV5Plus = true;
				return true;
			} else if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getStressHistory)) {
				me.apiV5Plus = false;
				return true;
			} else {
				return false;
			}
		}
		
		function getCurrentValueRaw() {
			var val = null;
			if (me.sensorSupported) {
				if (me.apiV5Plus) {
					val = Toybox.ActivityMonitor.Info.stressScore;
				} else {
					var iter = Toybox.SensorHistory.getStressHistory({:period=>null, :order=>Toybox.SensorHistory.ORDER_NEWEST_FIRST});
					var sample = iter.next();
					while (sample != null) {
						val = sample.data;
						if (val != null) {
							break;
						}
					}
				}
				// Debug System.println("api5v:" + me.apiV5Plus);
			}
			return val;
		}

		function getCurrentValueClean() {
			var val = me.getCurrentValueRaw();
			if(val != null && val >= 0 && val <= 100) {
				return val;
			} else {
				return null;
			}
		}
	}
}
