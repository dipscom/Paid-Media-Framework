package com.pedrotavares.paidmedia.platforms.base
{
	// CUSTOM IMPORTS
	import com.pedrotavares.paidmedia.platforms.base.BaseUnit;
	import com.pedrotavares.paidmedia.events.PaidMediaEvent;
	// FLASH IMPORTS
	import flash.display.*;
	import flash.events.*;

	public class BaseRich extends BaseUnit {

		protected var dbug :Boolean = false;

		public function BaseRich():void {
			//trace( "[BASERICH] All good, wait for setupAd()");
			// Do nothing, wait for the setupAd() to be called
		}

		protected function doTrace(dbug) {
			this.dbug = dbug;
		}


		/********************
		*
		*	 Setup Methods
		*
		**********************/
		override protected function setupAd( brdr_clr:uint=0x000000, brdr:Boolean=true, w:Number=0, h:Number=0 ):void {
			// Bring in the functionality of the overriden function
			// TO DO //
			super.setupAd(brdr_clr, brdr, w, h);
			if(dbug) trace( "[BASERICH] Dispatch UNIT_INITIALISED");
			// Dispatch the start of the ad
			dispatchEvent( new PaidMediaEvent( PaidMediaEvent.UNIT_INITIALISED ) );
		}


		/********************
		*
		*	 Helper Methods
		*
		**********************/
		protected function reOrderButtons(arr:Array):void {
			// Loop thru the given array
			for( var i:int = 0; i < arr.length; i++ ) {
				// And rearrange the order
				this.setChildIndex(arr[i], this.numChildren-1);
				if(dbug) trace("[BASERICH] Re-ordering buttons", arr[i].name);
			}
		}
	}
}
