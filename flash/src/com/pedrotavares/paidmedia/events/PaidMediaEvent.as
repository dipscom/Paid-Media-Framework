﻿package com.pedrotavares.paidmedia.events{	import flash.events.Event;		public class PaidMediaEvent extends Event	{		public static const MOUSE_CLICK				:String = "PaidMediaEvent_MouseClick";		public static const CLICK_CLICKTAG			:String = "PaidMediaEvent_ClickClickTag";		public static const ON_VIDEO_END			:String = "PaidMediaEvent_OnVideoEnd";				public static const UNIT_INITIALISED		:String = "PaidMediaEvent_UnitInitialised";		public static const VIDEO_INITIALISED		:String	= "PaidMediaEvent_VideoInitialised";		public static const VIDEO_REPLAY			:String = "PaidMediaEvent_VideoReplay";		public function PaidMediaEvent( eventType :String, bubbles :Boolean = true, cancelable :Boolean = false)		{			super( eventType, bubbles, cancelable );		}	}}