package com.pedrotavares.paidmedia.platforms.base
{
	// CUSTOM CLASSE IMPORTS
	import com.pedrotavares.paidmedia.events.PaidMediaEvent;
	// FLASH IMPORTS
	import flash.display.*;
	import flash.events.*;

	public class BaseRich extends MovieClip
	{
		/********************
			TO DO:
			
		**********************/
		
		// Variable to hold the instance of the clicktag
		protected var 		clicktag_mc					:MovieClip;
		// Variables to create the border or not
		private var 		border						:Shape;
		private var 		brdr						:Boolean;
		private var 		brdr_clr					:uint;
		// Variable to hold the mcs on stage
		private var 		mcs							:Array;

		public function BaseRich():void
		{
			trace( "[BASERICH] All good, wait for setupAd()");
			// Do nothing, wait for the setupAd() to be called
		}
		
		/********************
		* 
		*	Mouse Methods 
		*
		**********************/
		private function baseClick( e:MouseEvent ):void
		{ 
			trace("[BASERICH] Click");
			// Check to see if the target was the main clicktag
			if( e.target.name == "clicktag_mc" )
			{
				dispatchEvent( new PaidMediaEvent( PaidMediaEvent.CLICK_CLICKTAG ) );
			} else {
				dispatchEvent( new PaidMediaEvent( PaidMediaEvent.MOUSE_CLICK ) );
			}
		}
		
		private function baseMouseOver(e:MouseEvent):void
		{
			//trace( "[BASERICH] Mouse Over");
			dispatchEvent( new PaidMediaEvent( PaidMediaEvent.MOUSE_OVER ) );
		}
		
		private function baseMouseOut(e:MouseEvent):void
		{
			//trace( "[BASERICH] Mouse Out");
			dispatchEvent( new PaidMediaEvent( PaidMediaEvent.MOUSE_OUT ) );
		}
		
		
		/********************
		* 
		*	 Setup Methods
		*
		**********************/
		private function startSetup():void
		{
			// Check to see if border is required
			if( brdr )
			{
				// Draw a one pixel border automatically
				border = new Shape();
				border.graphics.lineStyle(1, brdr_clr, 1, true, "normal", "none", "miter");
				border.graphics.drawRect(0, 0, this.width-1, this.height-1);
				addChild(border);
				/********************
					TO DO:
					Find a way to have this border only detecting the rich unit's size
					currently it takes in the parent's stage size which, causes the
					border to be too wide/high when working with expanding creatives
				**********************/
			}
			// Initiate the main clicktag
			clicktag_mc = new MovieClip();
			// Clicktag details
			clicktag_mc.name = "clicktag_mc";
			clicktag_mc.graphics.beginFill(0xFF0000);
			clicktag_mc.graphics.drawRect(0, 0, this.width, this.height);
			clicktag_mc.graphics.endFill();
			clicktag_mc.alpha = 0.5;
			// Add mouse behaviour to the clicktag
			addButtonBehaviour(clicktag_mc);
			// Add the clicktag_mc to the stage
			addChild(clicktag_mc);
			
			trace( "[BASERICH] Dispatch UNIT_INITIALISED");
			// Dispatch the start of the ad
			dispatchEvent( new PaidMediaEvent( PaidMediaEvent.UNIT_INITIALISED ) );
		}
		
		private function onStage( e:Event ):void
		{
			trace( "[BASERICH] On Stage");
			// Stop listening if this was added to stage
			removeEventListener( Event.ADDED_TO_STAGE, onStage );
			// Start the setup of the ad
			startSetup();
		}
		
		protected function setupAd( brdr_clr:uint=0x000000, brdr:Boolean=true ):void
		{
			trace("[BASERICH] setupAd");
			// Define the received values as global variables
			this.brdr = brdr;
			this.brdr_clr = brdr_clr;
			// Check if stage exists
			if( stage )
			{
				trace("[BASERICH] setupAd, already on stage");
				// If the ad is already on stage
				// start the setup of the ad
				startSetup();
			} else {
				trace("[BASERICH] setupAd, wait for ADDED_TO_STAGE");
				// Listen for when the movieclip is added to stage
				addEventListener( Event.ADDED_TO_STAGE, onStage );
			}
		}
		
		
		/********************
		* 
		*	 Helper Methods
		*
		**********************/
		protected function addButtonBehaviour(btn:MovieClip):void {
			btn.addEventListener(MouseEvent.CLICK, baseClick);
			btn.addEventListener(MouseEvent.MOUSE_OVER, baseMouseOver);
			btn.addEventListener(MouseEvent.MOUSE_OUT, baseMouseOut);
			btn.buttonMode = true;
		}
		
		protected function reOrderButtons(arr:Array):void {
			// Loop thru the given array
			for( var i:int = 0; i < arr.length; i++ ) {
				// And rearrange the order
				this.setChildIndex(arr[i], this.numChildren-1);
				trace("[BASERICH] Re-ordering buttons", arr[i].name);
			}
		}
	}
}
