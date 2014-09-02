﻿package com.pedrotavares.paidmedia.platforms.base{	// CUSTOM CLASSE IMPORTS	import com.pedrotavares.paidmedia.events.PaidMediaEvent;	// FLASH IMPORTS	import flash.display.*;	//import flash.display.Stage;	import flash.events.*;	//import flash.events.MouseEvent;	public class BaseRich extends MovieClip	{		// Variable to hold an instance of the stage		//private var stageRef					:Stage; // IS THIS NEEDED?		// Variable to hold the instance of the clicktag		protected var clicktag_mc				:MovieClip;		// Variables to create the border or not		private var border						:Shape;		private var brdr						:Boolean;		private var brdr_clr					:uint;		// Variable to hold the mcs on stage		private var mcs							:Array;		public function BaseRich():void		{			trace( "[BASERICH] All good, wait for setupAd();");			// Do nothing, wait for the setupAd() to be called		}				/********************		* 		*	Mouse Methods 		*		**********************/		private function baseClick( e:MouseEvent ):void		{ 			//trace("[BASERICH] Click");			dispatchEvent( new PaidMediaEvent( PaidMediaEvent.CLICK_CLICKTAG ) );		}				private function baseMouseOver(e:MouseEvent):void		{			//trace( "[BASERICH] Mouse Over");			dispatchEvent( new PaidMediaEvent( PaidMediaEvent.MOUSE_OVER ) );		}				private function baseMouseOut(e:MouseEvent):void		{			//trace( "[BASERICH] Mouse Out");			dispatchEvent( new PaidMediaEvent( PaidMediaEvent.MOUSE_OUT ) );		}						/********************		* 		*	 Setup Methods		*		**********************/		private function onStage( e:Event ):void		{			trace( "[BASERICH] On Stage");			// Stop listening if this was added to stage			removeEventListener( Event.ADDED_TO_STAGE, onStage );			// Check to see if border is required			if( brdr )			{				// Draw a one pixel border automatically				border = new Shape();				border.graphics.lineStyle(1, brdr_clr, 1, true, "normal", "none", "miter");				border.graphics.drawRect(0, 0, stage.stageWidth-1, stage.stageHeight-1);				addChild(border);			}			// Initiate a new clicktag			clicktag_mc = new MovieClip();			// Clicktag details			clicktag_mc.name = "clicktag_mc";			clicktag_mc.graphics.beginFill(0xFF0000);			clicktag_mc.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);			clicktag_mc.graphics.endFill();			clicktag_mc.buttonMode = true;			clicktag_mc.alpha = 0;			// Listen to the mouse events			clicktag_mc.addEventListener(MouseEvent.CLICK, baseClick);			clicktag_mc.addEventListener(MouseEvent.MOUSE_OVER, baseMouseOver);			clicktag_mc.addEventListener(MouseEvent.MOUSE_OUT, baseMouseOut);			// Add the clicktag_mc to the stage			addChild(clicktag_mc);						// Dispatch the start of the ad			dispatchEvent( new PaidMediaEvent( PaidMediaEvent.UNIT_INITIALISED ) );		}				protected function setupAd( brdr:Boolean=true, brdr_clr:uint=0x000000 ):void		{			trace("[BASERICH] setupAd");			// Define the received values as global variables			this.brdr = brdr;			this.brdr_clr = brdr_clr;			// Listen for when the movieclip is added to stage			addEventListener( Event.ADDED_TO_STAGE, onStage );		}	}}