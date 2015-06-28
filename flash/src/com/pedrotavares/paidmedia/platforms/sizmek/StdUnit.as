package com.pedrotavares.paidmedia.platforms.sizmek {
	
	// CUSTOM IMPORTS
	import com.pedrotavares.paidmedia.platforms.base.BaseUnit;
	import com.pedrotavares.paidmedia.events.PaidMediaEvent;
	// SIZMEK IMPORTS
	
	public class StdUnit extends BaseUnit {

		public function StdUnit() {
			// Initialise Sizmek's classes
			EBStd.Init(this);
			addEventListener( PaidMediaEvent.UNIT_INITIALISED, unitReady );
		}
		
		private function unitReady( e:PaidMediaEvent ):void
		{
			trace("[RICHUNIT] Caught UNIT_INITIALISED");
			// Listen for the clicktag
			addEventListener( PaidMediaEvent.CLICK_CLICKTAG, onClick );	
		}
		
		protected function onClick( e:PaidMediaEvent ):void
		{
			EBStd.Clickthrough(); 
		}

	}
	
}
