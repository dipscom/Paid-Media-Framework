﻿package com.pedrotavares.paidmedia.platforms.dg{	// CUSTOM CLASSE IMPORTS	import com.pedrotavares.paidmedia.utils.dateChecker.DateChecker;	import com.pedrotavares.paidmedia.events.PaidMediaEvent;	// FLASH IMPORTS	import flash.display.MovieClip;	import flash.display.Stage;	import flash.events.Event;	import flash.events.MouseEvent;	public class DgRich extends MovieClip	{		// Get the instance of the buttons		public var clicktag_mc:MovieClip;		public function DgRich():void		{			// Do nothing		}				public function startDgRich():void		{			// Listen for the when the swf is added to stage			//EBBase.UserActionCounter("DgRich startDgRich");			// Initiate a new clicktag			clicktag_mc = new MovieClip();			// Add the clicktag_mc to the stage			addChild(clicktag_mc);						clicktag_mc.name = "clicktag_mc";			clicktag_mc.graphics.beginFill(0xFF0000);			clicktag_mc.graphics.drawRect(0, 0, 10, 10);			clicktag_mc.graphics.endFill();			clicktag_mc.width = stage.stageWidth;			clicktag_mc.height = stage.stageHeight;			clicktag_mc.addEventListener(MouseEvent.CLICK, onClick);			clicktag_mc.buttonMode = true;			clicktag_mc.alpha = 0;		}				protected function onClick(e:MouseEvent):void		{			EBBase.Clickthrough(); 			dispatchEvent( new PaidMediaEvent( PaidMediaEvent.CLICK_CLICKTAG ) );		}	}}