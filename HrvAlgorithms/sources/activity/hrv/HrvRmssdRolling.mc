module HrvAlgorithms {
	class HrvRmssdRolling extends Rolling {
		function initialize(rollingIntervalSeconds) {
			Rolling.initialize(rollingIntervalSeconds);
		}
		function aggregate(value) {
			me.aggregatedValue += Math.pow(value - me.previousValue, 2);
		}
		
		function calculate() {
			if (me.secondsCount < me.rollingIntervalSeconds || me.count < 1) {
				return null;
			}
			var result = Math.sqrt(me.aggregatedValue / me.count.toFloat());
			me.reset();
			me.data.add(result);
			return result;
		}
	}
}