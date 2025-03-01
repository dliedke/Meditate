using Toybox;
using Toybox.Time;
using Toybox.SensorHistory;

module HrvAlgorithms {
	class StressActivity extends SensorActivity {
		
		function initialize() {
			SensorActivity.initialize(new SensorSummary(), false);
		}

		static function isSensorSupported(){
			if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getStressHistory)) {
				return true;
			} else {
				return false;
			}
		}

		function getCurrentValueRaw() {
			var iter = Toybox.SensorHistory.getStressHistory({:period=>null, :order=>Toybox.SensorHistory.ORDER_NEWEST_FIRST});
			var sample = iter.next();
			var val = null;
			while (sample != null) {
				val = sample.data;
				if (val != null && val >=0 && val <= 100) {
					return val;
				} else {
					return null;
				}
			}
		}

		function getCurrentValueClean() {
			var val = me.getCurrentValueRaw();
			if(val > 0) {
				return val;
			} else {
				return null;
			}
		}
	}
}
