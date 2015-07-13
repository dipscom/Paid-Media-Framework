package com.pedrotavares.paidmedia.platforms.base  {
	// FLASH IMPORTS
	import flash.display.MovieClip;
	
	public class BaseDbug extends MovieClip {
		
		protected var dbug :Boolean = false;
		
		public function BaseDbug() {
			// constructor code
		}
		
		protected function doTrace(dbug):void {
			this.dbug = dbug;
		}

	}
	
}
