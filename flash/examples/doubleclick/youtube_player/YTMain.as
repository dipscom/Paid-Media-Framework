﻿package {	// Custom Imports	import com.pedrotavares.paidmedia.platforms.doubleclick.*;	import com.pedrotavares.paidmedia.events.PaidMediaEvent;	// Flash Imports	import flash.events.Event;	public class YTMain extends YT_player	{		public function YTMain()		{			//trace("[RICH] All good");			addEventListener( PaidMediaEvent.UNIT_INITIALISED, startThisAd ); 		}				private function startThisAd( e:PaidMediaEvent ):void		{			trace("Ready");		}	}}