﻿package com.pedrotavares.paidmedia.platforms.yahoo{	// CUSTOM CLASSE IMPORTS	import com.pedrotavares.paidmedia.platforms.yahoo.YahooRich;	import com.pedrotavares.paidmedia.events.PaidMediaEvent;	// FLASH IMPORTS	import flash.display.MovieClip;	import flash.events.*;	import flash.external.ExternalInterface;	import flash.media.*;	import flash.net.*;	import flash.utils.*;	import flash.system.fscommand;	public class YahooVideo extends YahooRich	{		// Video Vars		private var netConnection		:NetConnection;		private var netStream			:NetStream;		private var soundtransform		:SoundTransform;				protected var vidEntry			:String;		protected var vidPlayerInstance	:Video;				protected var isVidPlaying		:Boolean;		protected var isMuted			:Boolean;		protected var isFirstPlay		:Boolean;		protected var hasVidStarted		:Boolean;		protected var videoHolder		:MovieClip;		protected var vidCntrl			:MovieClip;		protected var vidSound			:MovieClip;		protected var vidRply			:MovieClip;		// Yahoo vars		private var timer:Number;		private var duration:Number;		private var trackProgress:Boolean;		private var seekbarEnabled:Boolean;		private var percentage:Number;		private var finished25:Boolean;		private var finished50:Boolean;		private var finished75:Boolean;		private var finished100:Boolean;		private var trackingSource:String;		private var initiated:String = "click";		private var videoID:String;		public function YahooVideo()		{			// constructor code			trace("[VIDEO] All good");		}		protected function setupVideo(vidEntry:String, videoHolder:MovieClip, vidCntrl:MovieClip, vidSound:MovieClip, vidRply:MovieClip=null, vidWidth:int=100, vidHeight:int=100, vidX:int=0, vidY:int=0 ):void		{			//---------------- Video, Audio and UI Init ----------------//			netConnection = new NetConnection();			netConnection.connect(null);			netStream = new NetStream(netConnection);			netStream.client = {};			netStream.client.onMetaData = onmetaData;			netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);			soundtransform = new SoundTransform();						// Video Player setup			vidPlayerInstance = new Video();			vidPlayerInstance.width = vidWidth;			vidPlayerInstance.height = vidHeight;			vidPlayerInstance.x = vidX;			vidPlayerInstance.y = vidY;			vidPlayerInstance.attachNetStream(netStream);						videoHolder.addChild(vidPlayerInstance);						//---------------- Flags Init ----------------//			isVidPlaying = false;			isMuted = false;			isFirstPlay = true;			hasVidStarted = false;			this.vidEntry = vidEntry; //video URL from AdUploader			trackProgress = true;	//Change to false to disable video interactions tracking (mute, unmute, pause, unpause)			seekbarEnabled = true; //True to enable video progress seek from the seekbar (backward seeking ONLY)			trackingSource = "fpad"; //source possible values = "fpad","exp","billboard"			videoID = "1"	//Update this if you have more than 1 video in the same module (1 for first video, 2 for second video and so on)						if(seekbarEnabled)			{				var seekPercentage:Number;//				seekbar.seekbarcurrent.buttonMode = true;//				seekbar.seekbarcurrent.addEventListener(MouseEvent.CLICK, seekbarbaseCLICK);			}			// Assign the video holder to the instance in the stage;			this.videoHolder = videoHolder;			// Assign the video controller movieClip instances to the relevant variable			this.vidCntrl = vidCntrl;			vidCntrl.gotoAndStop(1);			this.vidSound = vidSound;			vidSound.gotoAndStop(1);			this.vidRply = vidRply;			vidRply.gotoAndStop(1);			// Put the clicktag on top of the video			// The clicktag instance comes from the "YahooRich.as" class			setChildIndex(clicktag_mc, numChildren-1);			// Put the video controls on top of the clicktag			setChildIndex(vidCntrl, numChildren-1);			setChildIndex(vidSound, numChildren-1);			setChildIndex(vidRply, numChildren-1);			// Listen to the buttons on stage			vidCntrl.addEventListener( MouseEvent.CLICK, toggleVideo );			vidSound.addEventListener( MouseEvent.CLICK, toggleSound );			vidRply.addEventListener( MouseEvent.CLICK, replayVideo );			vidCntrl.buttonMode = vidSound.buttonMode = vidRply.buttonMode = true;						// Videos always start muted			muteVideo();		}		protected function playVideo():void		{			trace("[VIDEO] Play video");			// The video is now playing			isVidPlaying = true;			// Toggles which movie clip to show			vidCntrl.gotoAndStop(1);			// Make sure the video is visible;			videoHolder.visible = true;			// Play the video			if(!hasVidStarted)			{				finished25 = false; finished50 = false; finished75 = false; finished100 = false;				hasVidStarted = true;				netStream.play(vidEntry);				if(!isMuted)				{					isFirstPlay = false;									}			}			else			{				netStream.resume();			}		}		protected function pauseVideo():void		{			isVidPlaying = false;			// Toggles which movie clip to show			vidCntrl.gotoAndStop(2);			// Pause the video;			netStream.pause();		}		protected function replayVideo(e:MouseEvent):void		{			trace("[VIDEO] Replay Clicked");			dispatchEvent(new PaidMediaEvent(PaidMediaEvent.VIDEO_REPLAY));						track(trackingSource+"_click_video"+videoID+"_replay");						finished25 = false; finished50 = false; finished75 = false; finished100 = false;			timer = setInterval(checkProgress, 100);			// Unmute the video			unmuteVideo();					}		private function toggleVideo(e:MouseEvent):void		{			trace("Video toggle");			// Checks to see if the video is playing			if (! isVidPlaying)			{				//trace("Play it");				// Yes it is, unpause it				playVideo();				track(trackingSource+"_click_video"+videoID+"_pauseplay");			}			else			{				//trace("Pause it");				// No it isn't, pause it				pauseVideo();				track(trackingSource+"_click_video"+videoID+"_pause");			}		}		private function toggleSound(e:MouseEvent):void		{			// Checks to see if it should mute or unmute			if (isMuted)			{				trace("[VIDEO] Unmute it");				// Yes it is, unmute it				unmuteVideo();				track(trackingSource+"_click_sound_on");			}			else			{				trace("[VIDEO] Mute it");				// No it isn't, mute it				muteVideo();				track(trackingSource+"_click_sound_off");			}		}		protected function muteVideo():void		{			trace("[VIDEO] muteVideo");			isMuted = true;			// Mute the video			soundtransform.volume = 0;			netStream.soundTransform = soundtransform;			// Toggles which movie clip to show;			vidSound.gotoAndStop(1);		}		protected function unmuteVideo():void		{			isMuted = false;			// Unmute the video			soundtransform.volume = 1;			netStream.soundTransform = soundtransform;			// Toggles which movie clip to show;			vidSound.gotoAndStop(2);						if(isFirstPlay)			{				trace("[VIDEO] First unmute");				isFirstPlay = false;				rewind();				track(trackingSource+"_click_sound_initiated");				setTimeout(function()				{					track(trackingSource+"_video"+videoID+"_rewind_firstplay");				},200);			}		}		private function onCue(e:Event):void		{			trace("[VIDEO] cue");		}		private function onVideoEnd():void		{			trace("[VIDEO] Video is now over");			removeVideo();			dispatchEvent(new PaidMediaEvent(PaidMediaEvent.ON_VIDEO_END));						clearInterval(timer);		}		protected function removeVideo():void		{			// Video is no longer playing			isVidPlaying = false;			// It has played once			isFirstPlay = false;			// Hide video			videoHolder.visible = false;			// Hide controls			vidCntrl.visible = false;			vidSound.visible = false;			// Show replay button			vidRply.visible = true;			//Rewind the video			rewind();			// And pause it			netStream.pause();		}				//-------------------------------------------------		// Yahoo! Rich Media 300x250 Streaming Video Banner		// Version: 7.1 [Flash 9+/AS3]		// Copyright: Yahoo! [http://adspecs.yahoo.co.uk/]		//-------------------------------------------------		//---------------- Tracking Handler --------------//		private function track(val:String):void{			if(isFrontpage){				ExternalInterface.call("FPAD.track", val); 				trace("FPAD.track('"+val+"')");			}else{				ExternalInterface.call("adx_track_event", val); 				trace("adx_track_event('"+val+"')");			}		}		//---------------- Event Handlers ----------------//		private function netStatusHandler(event:NetStatusEvent):void 		{			if(event.info.code == "NetStream.Play.Start") {				track(trackingSource+"_"+initiated+"_video"+videoID+"_start");			}			else if(event.info.code == "NetStream.Play.Stop") {				trace("[VIDEO] end");				onVideoEnd();				if(finished25 && finished50 && finished75 && !finished100)				{					finished100 = true;					track(trackingSource+"_view_video"+videoID+"_complete");				}			}		}		private function onmetaData(item:Object):void 		{			trace("[VIDEO] OnmetaData");			duration = item.duration;			timer = setInterval(checkProgress, 100);		}				private function rewind()		{			track(trackingSource+"_click_video"+videoID+"_rewind");			finished25 = false; finished50 = false; finished75 = false; finished100 = false;			netStream.seek(0);		}		private function checkProgress()		{			percentage = netStream.time / duration;			//seekbar.seekbarcurrent.width = percentage * (controls.seekbar.width - 2);			if(trackProgress)			{				if(percentage >= 0.75 && percentage != 1 && !finished75)				{					finished75 = true;					track(trackingSource+"_view_video"+videoID+"_75percent");				}				else if(percentage >= 0.50 && !finished50)				{					finished50 = true;					track(trackingSource+"_view_video"+videoID+"_50percent");				}				else if(percentage >= 0.25 && !finished25)				{					finished25 = true;					track(trackingSource+"_view_video"+videoID+"_25percent");				}			}		}	}}