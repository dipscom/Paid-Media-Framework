﻿package com.pedrotavares.paidmedia.platforms.doubleclick{	/*		First and foremost:		Create your flash ".fla" file;		Go to >Commands>DoubleClick Studio v2>Insert v2 HTML Enabler;		Click "OK";		Delete the "Studio Enabler V2" layer as it's duplicate code that is already in this class;		Then, create a "Loader_main" class for it;		And extend the Doubleclick_loader class	*/		// CUSTOM IMPORTS	import com.pedrotavares.paidmedia.events.PaidMediaEvent;	// DOUBLECLICK IMPORTS	import com.google.ads.studio.HtmlEnabler;	import com.google.ads.studio.display.StudioLoader;	import com.google.ads.studio.events.StudioEvent;	// FLASH IMPORTS	import flash.display.MovieClip;	import flash.events.Event;	import flash.net.URLRequest;	public class PoliteLoader extends MovieClip	{		// Variable to hold reference to child swf.		protected var childSwf:MovieClip;		// Variable to hold the child swf instance name.		protected var childSwf_name:String;		// Variable to hold the child mc itself		protected var holderMc:MovieClip;		// StudioLoader extends directly from Adobe's Loader class, but also locates		// file names in the Studio UI.		protected var loader:StudioLoader; 		// Initialize the Enabler		public var enabler:HtmlEnabler = HtmlEnabler.getInstance();		public function PoliteLoader():void		{					trace("[DOUBLECLICK LOADER] All good");			// Start doubleclick enabler			enabler.init(this);					}				protected function politeLoad(childSwf_name:String, holderMc:MovieClip):void		{			// Start doubleclick enabler			enabler.init(this);						// Assign the childSwf to the instance variable			this.childSwf_name = childSwf_name;						// Assign the holder to the instance variable			this.holderMc = holderMc;						// Register for the PAGE_LOADED event to ensure polite loading of child swf			enabler.addEventListener(StudioEvent.PAGE_LOADED, pageLoadHandler); 						trace("[DOUBLECLICK LOADER] childSwf_name is: ", childSwf_name);		}				// Fired when the page has loaded.		private function pageLoadHandler(e:StudioEvent):void 		{			// Page has loaded, ok to politely load assets now			loader = new StudioLoader();			// Register handler to get notified when child swf is loaded			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete); 			// Start to load the child swf			loader.load(new URLRequest(childSwf_name));			// Add the loader to the stage			holderMc.addChild(loader);					}				private function loadComplete(e:Event):void		{			trace("[DOUBLECLICK LOADER] Load complete");			// Store reference to the loaded swf			childSwf = MovieClip(e.target.content);			// Dispatch an event once load is complete			dispatchEvent( new PaidMediaEvent( PaidMediaEvent.LOAD_COMPLETE ) );		}	}}