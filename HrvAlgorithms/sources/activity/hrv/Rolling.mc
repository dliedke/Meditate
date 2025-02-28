module HrvAlgorithms {
	class Rolling {
		function initialize(rollingIntervalSeconds) {	
			me.rollingIntervalSeconds = rollingIntervalSeconds;		
			me.reset();
		}
			
		var rollingIntervalSeconds;
		var secondsCount;	
		var previousValue;
		var count;
		var aggregatedValue;
		
		function reset() {
			me.secondsCount = 0;	
			me.count = 0;
			me.previousValue = null;
			me.aggregatedValue = 0.0;
		}
		
		function addOneSec(data) {
			for (var i = 0; i < data.size(); i++) {
				me.addValue(data[i]);
			}
			me.secondsCount++;
			return me.calculate();
		}
		
		function addValue(value) {
			if (me.previousValue != null) {
				me.count++;
				me.aggregate(value);
			}
			me.previousValue = value;
		}

		function aggregate(value) {
			me.aggregatedValue += value;
		}
	
		function calculate() {
			if (me.secondsCount < me.rollingIntervalSeconds || me.count < 1) {
				return null;
			}
			
			var result = me.aggregatedValue / me.count.toFloat();
			me.reset();
			return result;
		}
	}
}