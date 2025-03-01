module HrvAlgorithms {
    class HrvAndStressActivity extends HrActivity {
        function initialize(fitSession, hrvTracking, heartbeatIntervalsSensor) {
            me.mHrvTracking = hrvTracking;
            me.mHeartbeatIntervalsSensor = heartbeatIntervalsSensor;
            HrActivity.initialize(fitSession);
        }
        
        private var mHrvTracking;
        private var mHeartbeatIntervalsSensor;
        
        private var mHrvMonitor;
        private var mStressMonitor;
        
        private function isHrvOn() {
            return me.mHrvTracking != HrvTracking.Off;
        }

        private function isHrvDetailOn() {
            return me.mHrvTracking == HrvTracking.OnDetailed;
        }
        
        protected function onBeforeStart(fitSession) {
            if (me.isHrvOn()) {                 
                me.mHeartbeatIntervalsSensor.setOneSecBeatToBeatIntervalsSensorListener(method(:onOneSecBeatToBeatIntervals));
                me.mStressMonitor = new StressMonitor(fitSession, me.mHrvTracking);
                if (me.isHrvDetailOn()) {
                    me.mHrvMonitor = new HrvMonitorDetailed(fitSession, true);                    
                }
                else {
                    me.mHrvMonitor = new HrvMonitorDefault(fitSession);
                }
            }
        }
        
        function onOneSecBeatToBeatIntervals(heartBeatIntervals) {
            if (me.isHrvOn()) {    
                me.mHrvMonitor.addOneSecBeatToBeatIntervals(heartBeatIntervals);
                me.mStressMonitor.addOneSecBeatToBeatIntervals(heartBeatIntervals);
            }  
        }
        
        protected function onBeforeStop() {
            if (me.isHrvOn()) {
                me.mHeartbeatIntervalsSensor.setOneSecBeatToBeatIntervalsSensorListener(null);
            }
        }
        
        private var mHrvValue;
        
        // Updated to pass minimum heart rate to the stress monitor
        protected function onRefreshHrActivityStats(activityInfo, minHr) {    
            // Update the stress monitor's minimum heart rate
            if (me.isHrvOn() && me.mStressMonitor != null && minHr != null) {
                me.mStressMonitor.updateMinHeartRate(minHr);
            }
            
            if (me.isHrvOn()) {
                if (me.isHrvDetailOn()) {
                    me.mHrvValue = me.mHrvMonitor.getRmssdRolling();    
                }
                else {
                    me.mHrvValue = me.mHrvMonitor.calculateHrvSuccessive();    
                }
            }            
            me.onRefreshHrvActivityStats(activityInfo, minHr, me.mHrvValue);
        }
        
        protected function onRefreshHrvActivityStats(activityInfo, minHr, hrvValue) {
        }
        
        function calculateSummaryFields() {    
            var hrSummary = HrActivity.calculateSummaryFields();    
            var activitySummary = new ActivitySummary();
            activitySummary.hrSummary = hrSummary;
            if (me.isHrvOn()) {
                activitySummary.hrvSummary = me.mHrvMonitor.calculateHrvSummary();

                // Updated to not pass the minimum HR - use the one stored in the stress monitor
                activitySummary.stressSummary = me.mStressMonitor.calculateStressSummary();
            }
            return activitySummary;
        }
    }    
}