module HrvAlgorithms {
	class WindowAvg {
		function initialize(windowSize, first) {
			me.windowSize = windowSize;
			me.count = 0;
			me.data = new [me.windowSize];
			me.first = first;
		}
		
		var windowSize;
		var count;
		var data;
		var first;
		
		function addData(data) {
			if (me.count >= me.windowSize && me.first) {
				return;
			}
			
			if (data != null) {
				me.data[me.count % me.windowSize] = data.toNumber();
				me.count++;
			}
		}
		
		function calculate() {
			if (me.count < 2) {
				return null;
			}			
			var sum = 0;
			for (var i = 0; i < me.count; i++) {
				sum += me.data[i];
			}
			return sum / me.count.toFloat();
		}
	}
}