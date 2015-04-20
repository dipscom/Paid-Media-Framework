package com.pedrotavares.paidmedia.platforms.doubleclick
{
	/*
		First and foremost:
		Create your flash ".fla" file;
		Go to >Commands>DoubleClick Studio v2>Insert v2 HTML Enabler;
		Click "OK";
		Delete the "Studio Enabler V2" layer as it's duplicate code that is already in this class;
		Then, create a main class for it;
		And extend it with this class
	*/
	
	// CUSTOM IMPORTS
	import com.pedrotavares.paidmedia.events.PaidMediaEvent;
	import com.pedrotavares.paidmedia.platforms.doubleclick.PoliteLoader;
	// DOUBLECLICK IMPORTS
	import com.google.ads.studio.utils.StudioClassAccessor;
	// FLASH IMPORTS
	import flash.display.MovieClip;


	/********************
		TO DO:
		
	**********************/
		
	public class PoliteLoaderExp extends PoliteLoader
	{
		// Prepare a variable to be used as the expanding panel
		public var expanding			:Object;

		public function PoliteLoaderExp():void
		{		
			trace("[POLITE EXP LOADER] All good");
			
			// Listen for the expanding or collapsing events
			addEventListener(PaidMediaEvent.UNIT_EXPAND, userExpandPanel);
			addEventListener(PaidMediaEvent.UNIT_COLLAPSE, userCollapse);
		}
		
		override protected function politeLoad(childSwf_name:String, holderMc:MovieClip):void
		{
			// Call in the extended function methods
			super.politeLoad(childSwf_name, holderMc);
			// Get the expanding instance
			expanding = StudioClassAccessor.getClass(StudioClassAccessor.CLASS_EXPANDING)["getInstance"]();
		}
		
		private function userExpandPanel(e:PaidMediaEvent):void
		{
			trace("[POLITE EXP LOADER] Expanding");
			expanding.expand();
		}
		
		private function userCollapse(e:PaidMediaEvent):void
		{
			trace("[POLITE EXP LOADER] Collapsing");
			expanding.collapse();
		}
	}
}
