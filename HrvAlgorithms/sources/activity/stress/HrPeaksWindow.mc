using Toybox.Math;

module HrvAlgorithms {
	class HrPeaksWindow {
		function initialize(samplesCount) {
			me.mSamples = new [samplesCount];
			me.mStoreIndex = 0;
			me.mStoredSamplesCount = 0;
			
			me.mAverageHrPeak = 0.0;
			me.mHrPeaksCount = 0;
		}
		
		private var mSamples;
		private var mStoredSamplesCount;
		private var mStoreIndex;
		
		private var mAverageHrPeak;
		private var mHrPeaksCount;
		
		function addOneSecBeatToBeatIntervals(beatToBeatIntervals) {
			me.mSamples[me.mStoreIndex] = beatToBeatIntervals;
			me.mStoreIndex = (me.mStoreIndex + 1) % me.mSamples.size();
			me.mStoredSamplesCount++;
		}
		
		function calculateCurrentPeak() {
			var hrPeak = me.calculateHrPeak();
			if (hrPeak != null) {
				me.addHrPeak(hrPeak);
			}
			return hrPeak;
		}
		
		function calculateAverageStress(minHr) {
			if (me.mHrPeaksCount == 0 || minHr == null || minHr == 0) {
				return 0.0;
			}
			var averageHrPeaksDiff = me.mAverageHrPeak / me.mHrPeaksCount.toFloat() - minHr;
			if (averageHrPeaksDiff < 0.0) {
				return 0.0;
			}
			
			var averageStress = (averageHrPeaksDiff * 100.0) / minHr.toFloat();
			if (averageStress > 100.0) {
				return 100.0;
			}
			return averageStress;
		}
		
		private function addHrPeak(hrPeak) {
			me.mAverageHrPeak += hrPeak;
			me.mHrPeaksCount++;
		}
		
		private function calculateHrPeak() {
			if (me.mStoredSamplesCount < me.mSamples.size()) {
				return null;
			}
			var maxHr = -1;
			for (var i = 0; i < me.mSamples.size(); i++) {
				if (me.mSamples[i].size() > 0) {
					for (var s = 0; s < me.mSamples[i].size(); s++) { 
						var beatToBeatSample = me.mSamples[i][s];
						var bpmSample =  Math.round(60000 / beatToBeatSample.toFloat()).toNumber();
						
						if (maxHr == -1 || bpmSample > maxHr) {
							maxHr = bpmSample;
						}
					}
				}
			}
			
			if (maxHr == -1) {
				return null;
			}
			return maxHr;
		}

		function calculateCurrentStress(minHr) {
			// Check if we have valid data and minimum heart rate
			if (minHr == null || minHr == 0) {
				return 0.0;
			}
			
			// Get the current HR peak
			var hrPeak = me.calculateHrPeak();
			if (hrPeak == null) {
				return 0.0;
			}
			
			// Calculate stress based on the difference between current peak HR and minimum HR
			var hrPeakDiff = hrPeak - minHr;
			if (hrPeakDiff < 0.0) {
				return 0.0;
			}
			
			// Stress is the percentage increase above minimum heart rate
			var currentStress = (hrPeakDiff * 100.0) / minHr.toFloat();
			
			// Cap the stress value at 100%
			if (currentStress > 100.0) {
				return 100.0;
			}
			
			return currentStress;
		}
	}

}