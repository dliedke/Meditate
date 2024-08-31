using Toybox.Attention;

class Vibe {
	static function vibrate(pattern) {

		// Check if notifications are enabled, if not return
		var notificationsEnabled = GlobalSettings.loadNotification();
		if (notificationsEnabled == Notification.Off) {
			return;
		}

		var vibeProfile;
		switch (pattern) {
			case VibePattern.LongContinuous:
				vibeProfile = getLongContinuous();
				break;
			case VibePattern.LongPulsating:
				vibeProfile = getLongPulsating();
				break;
			case VibePattern.LongAscending:
				vibeProfile = getLongAscending();
				break;
			case VibePattern.MediumContinuous:
				vibeProfile = getMediumContinuous();
				break;
			case VibePattern.MediumPulsating:
				vibeProfile = getMediumPulsating();
				break;
			case VibePattern.MediumAscending:
				vibeProfile = getMediumAscending();
				break;
			case VibePattern.ShortContinuous:
				vibeProfile = getShortContinuous();
				break;
			case VibePattern.ShortPulsating:
				vibeProfile = getShortPulsating();
				break;
			case VibePattern.ShortAscending:
				vibeProfile = getShortAscending();
				break;
			case VibePattern.ShorterAscending:
				vibeProfile = getShorterAscending();
				break;
			case VibePattern.ShorterContinuous:
				vibeProfile = getShorterContinuous();
				break;
			case VibePattern.Blip:
				vibeProfile = getBlip();
				break;
			case VibePattern.ShortSound:
				
				// Play single fast note sound
				if (Attention has :ToneProfile) {
					var toneProfile =
					[
						new Attention.ToneProfile(650, 100)
					];
					Attention.playTone({:toneProfile=>toneProfile});
				}

				break;

			case VibePattern.LongSound:

				// Play three notes sound
				if (Attention has :ToneProfile) {
					var toneProfile =
					[
						new Attention.ToneProfile(523, 400),
						new Attention.ToneProfile(698, 400),
						new Attention.ToneProfile(932, 400),
					];
					Attention.playTone({:toneProfile=>toneProfile});
				}
				break;
				
			default:
				vibeProfile = getLongPulsating();
				break;
		}

		if (vibeProfile!=null) {
			Attention.vibrate(vibeProfile);
		}
	}
	
	static function getLongPulsating() {
		return [
			new Attention.VibeProfile(100, 1000),
	        new Attention.VibeProfile(0, 1000),
	        new Attention.VibeProfile(100, 1000),
	        new Attention.VibeProfile(0, 1000), 
	        new Attention.VibeProfile(100, 1000),
	        new Attention.VibeProfile(0, 1000),
	        new Attention.VibeProfile(100, 1000)
		];
	}
	
	static function getLongAscending() {
		return [
	        new Attention.VibeProfile(20, 1000),
	        new Attention.VibeProfile(30, 1000),
	        new Attention.VibeProfile(60, 1000), 
	        new Attention.VibeProfile(80, 1000),
	        new Attention.VibeProfile(90, 1000),
	        new Attention.VibeProfile(100, 1000)
		];
	}
	
	static function getLongContinuous() {
		return [
			new Attention.VibeProfile(100, 4000)
		];
	}
	
	static function getMediumPulsating() {
		return [
			new Attention.VibeProfile(100, 1000),
	        new Attention.VibeProfile(0, 1000),
	        new Attention.VibeProfile(100, 1000)
		];
	}
	
	static function getMediumAscending() {
		return [
	        new Attention.VibeProfile(33, 1000),
	        new Attention.VibeProfile(66, 1000),
	        new Attention.VibeProfile(100, 1000)
		];
	}
	
	static function getMediumContinuous() {
		return [
			new Attention.VibeProfile(100, 2000)
		];
	}
	
	static function getShortPulsating() {
		return [
			new Attention.VibeProfile(100, 333),
	        new Attention.VibeProfile(0, 333),
	        new Attention.VibeProfile(100, 333)
		];
	}
	
	static function getShortAscending() {
		return [
	        new Attention.VibeProfile(33, 333),
	        new Attention.VibeProfile(66, 333),
	        new Attention.VibeProfile(100, 333)
		];
	}
	
	static function getShortContinuous() {
		return [
			new Attention.VibeProfile(100, 500)
		];
	}
	
	static function getShorterAscending() {
		return [
	        new Attention.VibeProfile(33, 111),
	        new Attention.VibeProfile(66, 111),
	        new Attention.VibeProfile(100, 111)
		];
	}
	
	static function getShorterContinuous() {
		return [
	        new Attention.VibeProfile(100, 100)
		];
	}
	
	static function getBlip() {
		return [
	        new Attention.VibeProfile(100, 50)
		];
	}
}