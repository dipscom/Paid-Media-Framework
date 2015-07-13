package com.pedrotavares.paidmedia.platforms.base {
	// CUSTOM IMPORTS
	import com.pedrotavares.paidmedia.platforms.base.BaseDbug;
	import com.pedrotavares.paidmedia.events.PaidMediaEvent;
	// FLASH IMPORTS
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class BaseUnit extends BaseDbug {

		// Variable to hold the instance of the clicktag
		public var 		clicktag_mc					:MovieClip;

		public function BaseStd() {
			// Wait for setupAd()
		}


		/********************
		*
		*	 Setup Methods
		*
		**********************/
		protected function setupAd( brdr_clr:uint=0x000000, brdr:Boolean=true, w:Number=0, h:Number=0 ):void {
			/* TO DO - REMOVE THIS if STATEMENT FROM HERE AND ONLY OVERWRITE ON
				UNITS THAT NEED A DIFFERENT SIZED BORDER */
			// Check to see if there is w and h are being overriden
			if( w === 0 || h === 0 ) {
				// If w and h are zero,
				// Use the stage's width and height
				w = stage.stageWidth;
				h = stage.stageHeight;
			}

			/* TO DO - REMOVE THIS if STATEMENT FROM HERE AND ONLY OVERWRITE ON
				UNITS THAT NEED A CHECK FOR BORDER */
			// Check to see if border is required
			if( brdr ) {
				// Draw a one pixel border automatically
				var border = new Shape();
				border.graphics.lineStyle(1, brdr_clr, 1, true, "normal", "none", "miter");
				border.graphics.drawRect(0, 0, w-1, h-1);
				addChild(border);
				// NOTE: dbug var comes from BaseDbug.as 
				if(dbug) trace("[BASE_UNIT], Drawing border:", w, h);
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
		}

		protected function setAsButton(btn:MovieClip):void {
			btn.addEventListener(MouseEvent.CLICK, onClick);
			btn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			btn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			btn.buttonMode = true;
			btn.mouseChildren = false;
		}


		/********************
		*
		*	Mouse Methods
		*
		**********************/
		protected function onClick(e:MouseEvent):void {
			if(dbug) trace("[BASE_UNIT] Click ", e.currentTarget.name);
			var click_url:String = root.loaderInfo.parameters.clickTag;
			if(click_url) {
				navigateToURL(new URLRequest(click_url), '_blank');
			} else {
				trace("No url present");
			}
		}

		private function onMouseOver(e:MouseEvent):void {
			if(dbug) trace( "[BASE_UNIT] Mouse Over ", e.currentTarget.name);
			dispatchEvent( new PaidMediaEvent( PaidMediaEvent.MOUSE_OVER ) );
		}

		private function onMouseOut(e:MouseEvent):void {
			if(dbug) trace( "[BASE_UNIT] Mouse Out ", e.currentTarget.name);
			dispatchEvent( new PaidMediaEvent( PaidMediaEvent.MOUSE_OUT ) );
		}
	}
}
