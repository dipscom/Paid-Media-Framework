package  {
	// CUSTOM IMPORTS
	import com.pedrotavares.paidmedia.platforms.base.BaseUnit;
	// FLASH IMPORTS
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Main extends BaseUnit {
		
		
		public function Main() {
			// Wait until unit is displayed
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(e:Event):void {
			// Now that the unit is on the stage,
			// we have access to it and can start
			// the classes/animation
			setupAd();// Inherited from BaseUnit
		}
	}
	
}
