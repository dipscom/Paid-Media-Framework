﻿package com.pedrotavares.paidmedia.platforms.doubleclick{	// CUSTOM IMPORTS	import com.pedrotavares.paidmedia.platforms.base.BaseRich;	import com.pedrotavares.paidmedia.events.PaidMediaEvent;	// DOUBLECLICK IMPORTS	import com.google.ads.studio.ProxyEnabler;		public class RichUnit extends BaseRich	{		// Get an instance of the enabler		public var enabler:ProxyEnabler = ProxyEnabler.getInstance();					public function RichUnit() 		{			trace("[RICHUNIT] All good");			addEventListener( PaidMediaEvent.UNIT_INITIALISED, unitReady );		}				private function unitReady( e:PaidMediaEvent ):void		{		trace("[RICHUNIT] Caught UNIT_INITIALISED");			// Listen for the clicktag			addEventListener(PaidMediaEvent.CLICK_CLICKTAG, onClick);		}				protected function onClick( e:PaidMediaEvent ):void		{			enabler.exit("Main Click");		}	}}