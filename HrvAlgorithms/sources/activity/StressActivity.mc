using Toybox;

module HrvAlgorithms {
	class StressActivity extends SensorActivity {
		
		function initialize() {
			SensorActivity.initialize(new SensorSummary(), false);
		}

		// Method to be used without class instance
		static function isSensorSupported(){
			if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getStressHistory)) {
				return true;
			} else {
				return false;
			}
		}

		function getCurrentValueRaw() {
			var iter = Toybox.SensorHistory.getStressHistory({:period=>1,:order=>Toybox.SensorHistory.ORDER_NEWEST_FIRST});
			var sample = iter.next();
			if (sample != null && sample.data != null && sample.data >=0 && sample.data <= 100) {
				return sample.data;
			} else {
				return null;
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
