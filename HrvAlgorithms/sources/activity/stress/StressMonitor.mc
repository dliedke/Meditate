using Toybox.FitContributor;
using Toybox.Math;
using Toybox.Activity;
using Toybox.Application as App;

module HrvAlgorithms {
    class StressMonitor {
        function initialize(activitySession, hrvTracking) {    
            me.mHrvTracking = hrvTracking;
            me.mMinHr = null;
            me.mStressHistory = [];
            
            if (me.mHrvTracking == HrvTracking.OnDetailed) {        
                me.mHrPeaksWindow10DataField = StressMonitor.createHrPeaksWindow10DataField(activitySession);            
            } 
            
            if (me.mHrvTracking != HrvTracking.Off) {        
                me.mHrPeaksAverageDataField = StressMonitor.createHrPeaksAverageDataField(activitySession);            
                me.mHrPeaksWindow10 = new HrPeaksWindow(10);    
            }                        
        }
                                
        private var mHrvTracking;
        private var mMinHr;
        private var mStressHistory;
        
        private var mHrPeaksWindow10;
        
        private var mHrPeaksWindow10DataField;
        private var mHrPeaksAverageDataField;
        
       
        private static const HrPeaksWindow10DataFieldId = 15;
        private static const HrPeaksAverageDataFieldId = 17;
        private static const CurrentStressDataFieldId = 16;
        
        private var mInitialStressCalculated = false;
        private var mDataCollectionStartTime = null;
        private var mInitialAverageStress = 10.0;  // Default to minimum stress
        private static const INITIAL_DATA_COLLECTION_SECONDS = 120;  // 2 minutes

        private static function createHrPeaksAverageDataField(activitySession) {
            return activitySession.createField(
                "stress_hrpa",
                HrPeaksAverageDataFieldId,
                FitContributor.DATA_TYPE_FLOAT,
                {:mesgType=>FitContributor.MESG_TYPE_SESSION, :units=>"%"}
            );
        }
    
        private static function createHrPeaksWindow10DataField(activitySession) {
            return activitySession.createField(
                "stress_hrp",
                HrPeaksWindow10DataFieldId,
                FitContributor.DATA_TYPE_FLOAT,
                {:mesgType=>FitContributor.MESG_TYPE_RECORD, :units=>"bpm"}
            );
        }
        
        private static function createCurrentStressDataField(activitySession) {
            return activitySession.createField(
                "stress_current",
                CurrentStressDataFieldId,
                FitContributor.DATA_TYPE_FLOAT,
                {:mesgType=>FitContributor.MESG_TYPE_RECORD, :units=>"%"}
            );
        }
        
        // Update minimum heart rate based on current activity info
        function updateMinHeartRate(currentHeartRate) {
            if (currentHeartRate != null && (me.mMinHr == null || me.mMinHr > currentHeartRate)) {
                me.mMinHr = currentHeartRate;
            }
        }
        
        function addOneSecBeatToBeatIntervals(beatToBeatIntervals) {
            if (me.mHrvTracking != HrvTracking.Off) {
                // Track when we start collecting data if not already started
                if (me.mDataCollectionStartTime == null) {
                    me.mDataCollectionStartTime = System.getTimer();
                }
                
                me.mHrPeaksWindow10.addOneSecBeatToBeatIntervals(beatToBeatIntervals);
                me.calculateHrPeaksWindow10();
                
                // Check if we've reached the 2-minute mark for initial average calculation
                if (!me.mInitialStressCalculated) {
                    var currentTime = System.getTimer();
                    var elapsedSeconds = (currentTime - me.mDataCollectionStartTime) / 1000;
                    
                    if (elapsedSeconds >= INITIAL_DATA_COLLECTION_SECONDS && me.mMinHr != null && me.mMinHr > 0) {
                        // Calculate initial average stress after 2 minutes
                        me.mInitialAverageStress = me.mHrPeaksWindow10.calculateAverageStress(me.mMinHr);
                        if (me.mInitialAverageStress < 10.0) {
                            me.mInitialAverageStress = 10.0;  // Ensure minimum value
                        }
                        me.mInitialStressCalculated = true;
                        
                        // Initialize stress history with initial average
                        if (me.mStressHistory.size() == 0) {
                            // Fill history with initial values for past seconds
                            for (var i = 0; i < elapsedSeconds; i++) {
                                me.mStressHistory.add(me.mInitialAverageStress);
                            }
                        }
                    }
                }
                
                // Calculate and store per-second stress if in detailed mode
                if (me.mHrvTracking == HrvTracking.OnDetailed && me.mMinHr != null && me.mMinHr > 0) {
                    me.calculateAndStoreCurrentStress();
                }
            }
        }
        
       private function calculateAndStoreCurrentStress() {
            var currentStress = me.mHrPeaksWindow10.calculateCurrentStress(me.mMinHr);
            
            // Use initial average for the first 2 minutes if not calculated yet
            if (!me.mInitialStressCalculated) {
                currentStress = 10.0;  // Use minimum value until we calculate initial average
            }
            
            // Store the stress value in history
            me.mStressHistory.add(currentStress);
        }
        
        private function calculateHrPeaksWindow10() {
            if (me.mHrvTracking == HrvTracking.Off) {
                return;
            }
        
            var result = me.mHrPeaksWindow10.calculateCurrentPeak();
            if (result != null) {
                if (me.mHrPeaksWindow10DataField != null) {
                    me.mHrPeaksWindow10DataField.setData(result);
                }
            }
        }
                
        public function calculateStress() {
            if (me.mHrvTracking == HrvTracking.Off || me.mMinHr == null || me.mMinHr == 0) {
                return null;
            }
            var averageStress = me.mHrPeaksWindow10.calculateAverageStress(me.mMinHr);
            me.mHrPeaksAverageDataField.setData(averageStress);
            return averageStress;
        }
        
        // Method to calculate stress summary
       function calculateStressSummary() {
            var stressSummary = new HrvAlgorithms.StressSummary();
            
            // Initialize the stress history array
            stressSummary.stressHistory = [];
            
            // Copy the stored stress history values
            if (me.mStressHistory != null && me.mStressHistory.size() > 0) {
                stressSummary.stressHistory = me.mStressHistory.slice(0, null); // Create a copy
                
                // Set the start and end stress values
                if (stressSummary.stressHistory.size() > 0) {
                    stressSummary.startStress = stressSummary.stressHistory[0];
                    stressSummary.endStress = stressSummary.stressHistory[stressSummary.stressHistory.size() - 1];
                }
            } else {
                // If we don't have stress history data, use initial average or minimum
                var defaultStress = me.mInitialStressCalculated ? me.mInitialAverageStress : 10.0;
                stressSummary.startStress = defaultStress;
                stressSummary.endStress = defaultStress;
            }
            
            return stressSummary;
        }
    }
}