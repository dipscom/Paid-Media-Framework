﻿package com.pedrotavares.paidmedia.platforms.sizmek{	// Custom Imports	import com.pedrotavares.paidmedia.platforms.base.BaseRich;	import com.pedrotavares.paidmedia.events.PaidMediaEvent;	// Sizmek Imports	import eyeblaster.events.EBNotificationEvent;	// Flash imports	import flash.events.Event;	public class RichUnit extends BaseRich	{		public function RichUnit():void		{			EBBase.UserActionCounter("[RICH] All good");						// Initialise the enabler			EBBase.Init(this);			// Listen for when the enabler is ready			EBBase.addEventListener( Event.INIT, hasInit );// This does not seem to happen			// Listen for the click			addEventListener(PaidMediaEvent.CLICK_CLICKTAG, onClick);// Shouldn't this wait until the unit has completed initializing?			addEventListener( PaidMediaEvent.UNIT_INITIALISED, unitStarted );		}				private function unitStarted( e:PaidMediaEvent ):void		{			//trace("[RICH] unit has started");			EB.UserActionCounter("[RICH] unit has started");		}				private function hasInit( e:EBNotificationEvent ):void		{			//trace("[RICH] EB has initiated");			EB.UserActionCounter("[RICH] EB has initiated");		}				protected function onClick(e:PaidMediaEvent):void		{			EBBase.Clickthrough(); 		}	}}