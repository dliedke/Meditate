module HrvAlgorithms {
	class HrvSdrrLastNSec extends WindowAvg{
		function initialize(maxIntervalsCount) {
			WindowAvg.initialize(maxIntervalsCount, false);
		}		
		function calculate() {
			var avg = WindowAvg.calculate();
			if (avg == null) {
				return null;
			}
			var sumSquaredDeviations = 0.0;
			for (var i = 0; i < me.count; i++) {
				sumSquaredDeviations += Math.pow(me.data[i] - avg, 2);	
			}
			return Math.sqrt(sumSquaredDeviations / me.count.toFloat());
		}
	}
}