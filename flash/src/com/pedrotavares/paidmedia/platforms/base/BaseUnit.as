package com.pedrotavares.paidmedia.platforms.base {
	import com.pedrotavares.paidmedia.events.PaidMediaEvent;
	import flash.display.*;
	import flash.events.MouseEvent;
	
	public class BaseUnit extends Sprite {
		
		// Variable to hold the instance of the clicktag
		public var 		clicktag_mc					:Sprite;

		public function BaseStd() {
			// Wait for setupAd()
		}
		
		protected function setupAd( brdr_clr:uint=0x000000, brdr:Boolean=true, w:Number=0, h:Number=0 ):void {
			// Check to see if there is w and h are being overriden
			if( w === 0 || h === 0 ) {
				// If w and h are zero,
				// Use the stage's width and height
				w = stage.stageWidth;
				h = stage.stageHeight;
			} 
			
			// Check to see if border is required
			if( brdr )
			{
				// Draw a one pixel border automatically
				var border = new Shape();
				border.graphics.lineStyle(1, brdr_clr, 1, true, "normal", "none", "miter");
				border.graphics.drawRect(0, 0, w-1, h-1);
				addChild(border);
				trace("[BASE_UNIT], Drawing border:", w, h);
			}
			// Initiate the main clicktag
			clicktag_mc = new MovieClip();
			// Clicktag details
			clicktag_mc.name = "clicktag_mc";
			clicktag_mc.graphics.beginFill(0xFF0000);
			clicktag_mc.graphics.drawRect(0, 0, w, h);
			clicktag_mc.graphics.endFill();
			clicktag_mc.alpha = 0;
			// Add mouse behaviour to the clicktag
			setAsButton(clicktag_mc);
			// Add the clicktag_mc to the stage
			addChild(clicktag_mc);
			
			trace( "[BASE_UNIT] Dispatch UNIT_INITIALISED");
			// Dispatch the start of the ad
			dispatchEvent( new PaidMediaEvent( PaidMediaEvent.UNIT_INITIALISED ) );
		}
	
		private function setAsButton(btn:Sprite):void {
			btn.addEventListener(MouseEvent.CLICK, baseClick);
			btn.addEventListener(MouseEvent.MOUSE_OVER, baseMouseOver);
			btn.addEventListener(MouseEvent.MOUSE_OUT, baseMouseOut);
			btn.buttonMode = true;
			btn.mouseChildren = false;
		}
		
		/********************
		* 
		*	Mouse Methods 
		*
		**********************/
		private function baseClick( e:MouseEvent ):void
		{ 
			trace("[BASE_UNIT] Click");
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
			trace( "[BASE_UNIT] Mouse Over ", e.currentTarget.name);
			dispatchEvent( new PaidMediaEvent( PaidMediaEvent.MOUSE_OVER ) );
		}
		
		private function baseMouseOut(e:MouseEvent):void
		{
			trace( "[BASE_UNIT] Mouse Out ", e.currentTarget.name);
			dispatchEvent( new PaidMediaEvent( PaidMediaEvent.MOUSE_OUT ) );
		}
	}
}
