using Toybox.System;

class SummaryRollupModel {
	function initialize() {
		me.mSummaryModels = [];
	}

	private var mSummaryModels;

	public function addSummary(summaryModel) {
		me.mSummaryModels.add(summaryModel);
	}

	public function getSummary(index) {
		return me.mSummaryModels[index];
	}

	public function getSummaries() {
		return me.mSummaryModels;
	}
}
