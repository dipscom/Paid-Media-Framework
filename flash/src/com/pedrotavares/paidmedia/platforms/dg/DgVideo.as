﻿package com.pedrotavares.paidmedia.platforms.dg{	// CUSTOM CLASS IMPORTS	import com.pedrotavares.paidmedia.platforms.dg.DgRich;	import com.pedrotavares.paidmedia.events.PaidMediaEvent;	// DG IMPORTS	import eyeblaster.media.VideoLoader;	import eyeblaster.events.*;	// FLASH IMPORTS	import flash.display.MovieClip;	import flash.events.MouseEvent;	import flash.events.Event;	public class DgVideo extends DgRich	{		protected var isVidPlaying:Boolean;		private var isMuted:Boolean = true;		// create an instance of VideoLoader named _videoScreenInst		private var _videoScreenInst;		public var videoHolder:MovieClip;		public var vidCntrl:MovieClip;		public var vidSound:MovieClip;		public var vidRply:MovieClip;		public function DgVideo()		{			//addEventListener( PaidMediaEvent.UNIT_INITIALISED, startDgVideo );						// create an instance of VideoLoader named _videoScreenInst			_videoScreenInst = new VideoLoader();			// set some properties of the instance			_videoScreenInst.initComponentProperties = setComponentProperties;			// Listen for the end of the video and cue points			_videoScreenInst.addEventListener(EBVideoEvent.MOVIE_END, onVideoEnd);			_videoScreenInst.addEventListener(EBMetadataEvent.CUE_POINT, onCue);			_videoScreenInst.addEventListener(Event.ADDED_TO_STAGE, videoOnStage);		}				/*override public function startDgRich():void		{			trace("video class");			//super.startDgRich();						//startDgVideo();		}*/				public function startDgVideo(e:PaidMediaEvent=null):void		{			EBBase.UserActionCounter("startDgVideo");						super.startDgRich();						// create an instance of VideoLoader named _videoScreenInst			/*_videoScreenInst = new VideoLoader();			// set some properties of the instance			_videoScreenInst.initComponentProperties = setComponentProperties;			// Listen for the end of the video and cue points			_videoScreenInst.addEventListener(EBVideoEvent.MOVIE_END, onVideoEnd);			_videoScreenInst.addEventListener(EBMetadataEvent.CUE_POINT, onCue);			_videoScreenInst.addEventListener(Event.ADDED_TO_STAGE, videoOnStage);*/						//dispatchEvent( new PaidMediaEvent( PaidMediaEvent.VIDEO_INITIALISED ) );			// add _videoScreenInst to the stage			//videoHolder.addChild(_videoScreenInst);			//addChild(_videoScreenInst);		}		private function setComponentProperties():void		{			_videoScreenInst.name = "_videoScreenInst";			_videoScreenInst.muteOnVideoStart = false;			_videoScreenInst.pauseOnLastFrame = false;			// Video starts muted			isMuted = true;		}				private function videoOnStage(e:Event):void		{			EBBase.UserActionCounter("Video is on stage");		}				protected function setupVideo( vidEntry:int, videoHolder:MovieClip, vidCntrl:MovieClip, vidSound:MovieClip, vidRply:MovieClip, vidWidth:int=100, vidHeight:int=100, vidX:int=0, vidY:int=0 ):void		{			EBBase.UserActionCounter("setupVideo");			// Video to play			_videoScreenInst.loadExt("../_videos/test_444x250.flv");			//_videoScreenInst.load(vidEntry);			_videoScreenInst.width = vidWidth;			_videoScreenInst.height = vidHeight;			_videoScreenInst.x = vidX;			_videoScreenInst.y = vidY;						// Assign the video controller movieClip instances to the relevant variable			this.vidCntrl = vidCntrl;			vidCntrl.gotoAndStop(1);			this.vidSound = vidSound;			vidSound.gotoAndStop(1);			this.vidRply = vidRply;			vidRply.gotoAndStop(1);						// Listen to the buttons on stage			addEventListener( PaidMediaEvent.CLICK_CLICKTAG, onClickTag );			vidCntrl.addEventListener( MouseEvent.CLICK, toggleVideo );			vidSound.addEventListener( MouseEvent.CLICK, toggleSound );			vidRply.addEventListener( MouseEvent.CLICK, replayVideo );			vidCntrl.buttonMode = vidSound.buttonMode = vidRply.buttonMode = true;						// add _videoScreenInst to the stage			videoHolder.addChild(_videoScreenInst);			//addChild(_videoScreenInst);			// Put the clicktag on top of the video			// The clicktag instance comes from the "DoubleclickRich.as" class			addChild(clicktag_mc);			// Put the video controls on top of the clicktag			addChild(vidCntrl);			addChild(vidSound);			addChild(vidRply);		}				private function onClickTag(e:PaidMediaEvent):void		{			//trace( "[VIDEO] Main clicktag");			// Check to see if the video is playing			if(isVidPlaying)			{				trace( "[VIDEO] Video is playing");				// Stop and remove video				removeVideo();			} else {				trace( "[VIDEO] Video is NOT playing");			}		}				private function replayVideo(e:MouseEvent):void		{			dispatchEvent(new PaidMediaEvent(PaidMediaEvent.MOUSE_CLICK));			trace("Replay Clicked");			//Restart the video			// And unmute it			unmuteVideo();		}		private function onCue(info):void		{			//videoPlayer_bg.visible = true;		}		private function onVideoEnd(e:EBVideoEvent=null):void		{			//trace("onVideoEnd");			dispatchEvent(new PaidMediaEvent(PaidMediaEvent.ON_VIDEO_END));		}						private function toggleVideo(e:MouseEvent):void		{			trace("Video toggle");			// Checks to see if the video is playing			if( !isVidPlaying )			{				trace("Play it");				// Yes it is, unpause it				playVideo();				// And unmute it				unmuteVideo();						} else {				trace("Pause it");				// No it isn't, pause it				pauseVideo();			}		}				protected function playVideo():void		{			//trace("[VIDEO] Playing the video");			EBBase.UserActionCounter("Play Video");			// The video is now playing			isVidPlaying = true;			// Toggles which movie clip to show			vidCntrl.gotoAndStop(1);			// Start playing the video			_videoScreenInst.play();		}		protected function pauseVideo():void		{			isVidPlaying = false;			// Toggles which movie clip to show			vidCntrl.gotoAndStop(2);			// Pause the video			_videoScreenInst.pause();		}				private function toggleSound(e:MouseEvent):void		{			// Checks to see if it should mute or unmute			if( isMuted )			{				trace("Unmute it");				// Yes it is, unmute it				unmuteVideo();						} else {				trace("Mute it");				// No it isn't, mute it				muteVideo();			}		}				private function muteVideo():void		{			isMuted = true;			// Mute the video			_videoScreenInst.setMute(1);			// Toggles which movie clip to show			vidSound.gotoAndStop(1);		}		private function unmuteVideo():void		{			isMuted = false;			// Unmute the video			_videoScreenInst.setMute(0);			// Toggles which movie clip to show			vidSound.gotoAndStop(2);		}			private function removeVideo():void		{			// Video is no longer playing			isVidPlaying = false;			// Hide controls			vidCntrl.visible = false;			vidSound.visible = false;			// Show replay button			vidRply.visible = true;			// Make sure the video is stopped			_videoScreenInst.stop();			// Remove it from the stage			// add _videoScreenInst to the stage			//videoHolder.removeChild(_videoScreenInst);		}	}}