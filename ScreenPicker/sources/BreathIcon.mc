using Toybox.Graphics as Gfx;

module ScreenPicker {
	class BreathIcon extends Icon {
		function initialize(icon) {
			icon[:font] = StatusIconFonts.fontMeditateIcons;
			icon[:symbol] = StatusIconFonts.Rez.Strings.meditateFontBreath;
			if (icon[:color] == null) {
				icon[:color] = me.BreathIconLightBlueColor;
			}
			Icon.initialize(icon);
		}

		const BreathIconLightBlueColor = 0x6060ff;
		function setActive() {
			me.setColor(BreathIconLightBlueColor);
		}
		function setInactive() {
			me.setColor(Gfx.COLOR_LT_GRAY);
		}
	}
}
