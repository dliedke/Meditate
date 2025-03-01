using Toybox;
using Toybox.FitContributor;
using Toybox.ActivityMonitor;
using Toybox.System;
using Toybox.SensorHistory;
using Toybox.Time;

module HrvAlgorithms {
	class StressMonitor {
		function initialize(activitySession, hrvTracking) {	
			me.mHrvTracking = hrvTracking;
			me.mStressDataField = null;
			if (me.mHrvTracking != HrvTracking.Off && StressMonitor.isSensorSupported()) {		
				me.mStressDataField = StressMonitor.createStressDataField(activitySession);
			}		
		}
								
		private var mHrvTracking;		
		private var mStressDataField;		
		private static const StressDataFieldId = 17;
		private var lastValue = null;

		static function isSensorSupported(){
			if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getStressHistory)) {
				return true;
			} else {
				return false;
			}
		}
		
		private static function createStressDataField(activitySession) {
			return activitySession.createField(
	            "stress_hrpa",
	            StressDataFieldId,
	            FitContributor.DATA_TYPE_FLOAT,
	            {:mesgType=>FitContributor.MESG_TYPE_SESSION, :units=>"%"}
	        );
		}

		public function calculateStress() {
			if (me.mStressDataField != null) {
				var iter = Toybox.SensorHistory.getStressHistory({:period=>null, :order=>Toybox.SensorHistory.ORDER_NEWEST_FIRST});
				var sample = iter.next();
				var val = null;
				while (sample != null) {
					val = sample.data;
					if (val != null && val >=0 && val <= 100) {
						if (me.lastValue == 0 || me.lastValue != val){
							me.mStressDataField.setData(val);
							me.lastValue = val;
						}
						return val;
					} else {
						return null;
					}
				}
			} else {
				return null;
			}

		}
	}
}