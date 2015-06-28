package com.pedrotavares.paidmedia.platforms.doubleclick
{
	// CUSTOM CLASSE IMPORTS
	import com.pedrotavares.paidmedia.platforms.doubleclick.RichUnit;
	import com.pedrotavares.paidmedia.events.PaidMediaEvent;
	// DOUBLECLICK IMPORTS
	import com.google.ads.studio.innovation.youtube.player.proxy.YTPlayer;
	import com.google.ads.studio.innovation.youtube.player.YTPlayerEvent;
	// FLASH IMPORTS
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Security;
	
	// Security settings
	Security.allowDomain("www.gstatic.com");
	Security.allowDomain("www.youtube.com");
	Security.allowDomain("s.ytimg.com");


	public class YT_player extends RichUnit
	{
		// Video Vars
		protected var vidPlayerInstance		:YTPlayer;
		
		protected var isVidPlaying			:Boolean;
		protected var isMuted				:Boolean;
		protected var videoHolder			:MovieClip;
		protected var vidCntrl				:MovieClip;
		protected var vidSound				:MovieClip;
		protected var vidRply				:MovieClip;
		
		private var isFullScreen			:Boolean 		= false;


		public function YT_player()
		{
			// constructor code
			trace("[YTPLAYER] All good");
		}

		protected function setupVideo(	vidEntry	:String, 
										videoHolder	:MovieClip, 
										vidWidth	:int 			= 100, 
										vidHeight	:int 			= 100,
										vidX		:int 			= 0, 
										vidY		:int 			= 0, 
										vidCntrl	:MovieClip 		= null, 
										vidSound	:MovieClip 		= null, 
										vidRply		:MovieClip 		= null, 
										playType	:String 		= "preview",
										cntrlType	:String 		= "autohide"
										):void
		{
			trace("[YTPLAYER] Video setup"); 
			// Define the local variable to global space
			this.videoHolder = videoHolder;
			this.vidCntrl = vidCntrl;
			this.vidSound = vidSound;
			this.vidRply = vidRply;
			
			// Video Player setup
			vidPlayerInstance = new YTPlayer();
			vidPlayerInstance.proxy.videoId = vidEntry;
			vidPlayerInstance.proxy.autoPlayType = playType;
			vidPlayerInstance.proxy.controlsType = cntrlType;
			vidPlayerInstance.proxy.hdOnFullscreen = true;
			vidPlayerInstance.proxy.previewDuration = 10;
			vidPlayerInstance.proxy.width = vidWidth;
			vidPlayerInstance.proxy.height = vidHeight;
			vidPlayerInstance.proxy.x = vidX;
			vidPlayerInstance.proxy.y = vidY;
			
			// Wait unitl it is initialized
			if (vidPlayerInstance.remoteComponentReady) 
			{
			 	ytPlayerReady();
			} else 
			{
			 	vidPlayerInstance.proxy.addEventListener("ready", ytPlayerReady);
			}
			
			// Does vidCntrl exist?
			if (vidCntrl) {
				// Check if the video is autoplaying
				if( playType === "none" ) {
					trace("[YTPLAYER] >>>>>>>>>>>>>>>> Video is not autoplaying");
					isVidPlaying = false;
					vidCntrl.gotoAndStop(2);
				} else {
					trace("[YTPLAYER] >>>>>>>>>>>>>>>> Video is autoplaying");
					isVidPlaying = true;
					vidCntrl.gotoAndStop(1);
				}
				
				// Add the event listener if it does
				vidCntrl.addEventListener(MouseEvent.CLICK, toggleVideo);
				vidCntrl.buttonMode = true;
				vidCntrl.mouseChildren = false;
			}

			// Does vidSound exist?
			if (vidSound) {
				// Check if video is starting muted
				if( playType === "standard" ) {
					trace(">>>>>>>>>>>>>>>> Video is not muted");
					isMuted = false;
					vidSound.gotoAndStop(2);
				} else {
					trace(">>>>>>>>>>>>>>>> Video is muted");
					isMuted = true;
					vidSound.gotoAndStop(1);
				}
				
				// Add the event listener if it does
				vidSound.addEventListener(MouseEvent.CLICK, toggleSound);
				vidSound.buttonMode = true;
				vidSound.mouseChildren = false;
			}

			// Does vidRply exist?
			if (vidRply) {
				// Make sure the video controls is on the correct frame
				vidRply.gotoAndStop(1);
				// Add the event listener if it does
				vidRply.addEventListener(MouseEvent.CLICK, replayVideo);
				vidRply.addEventListener(MouseEvent.MOUSE_OVER, videoMouseOver);
				vidRply.addEventListener(MouseEvent.MOUSE_OVER, videoMouseOut);
				vidRply.buttonMode = true;
				vidRply.mouseChildren = false;
			}
		}
		
		private function playerEventHandler(event:YTPlayerEvent):void 
		{
			 trace("[YTPLAYER] handled event", event.type);
			 switch (event.type) {
				 case YTPlayerEvent.VIDEO_PLAY:
					enabler.counter("YTP Video Play", true);
					break;
				 case YTPlayerEvent.VIDEO_PAUSE:
				    enabler.counter("YTP Video Pause", true);
					trace("[YTPLAYER] >>>>>>>>>>Video Pause");
				    break;
				 case YTPlayerEvent.VIDEO_MUTE:
				    enabler.counter("YTP Video Mute", true);
				    break;
				 case YTPlayerEvent.VIDEO_UNMUTE:
				    enabler.counter("YTP Video Unmute", true);
				    break;
				 case YTPlayerEvent.VIDEO_REPLAY:
				    enabler.counter("YTP Video Replay", true);
				    break;
				 case YTPlayerEvent.VIDEO_COMPLETE:
				    enabler.counter("YTP Video Complete", true);
					onVideoEnd();
				    break;
				 case YTPlayerEvent.VIDEO_EXIT:
				    pauseVideo();
				    //dispatchEvent( new PaidMediaEvent( PaidMediaEvent.CLICK_CLICKTAG ) );
					trace("[YTPLAYER] >>>>>>>>>>Video Exit");
					break;
			 }
		}
		
		private function ytPlayerReady( e:Event=null):void
		{
			trace("[YTPLAYER] Player ready");
			// Set up the listener for the video events
			for each (var playerEvent:String in YTPlayerEvent.allEvents) 
			{
			 vidPlayerInstance.addEventListener(playerEvent, playerEventHandler);
			}

			// Add it to the stage
			videoHolder.addChild( vidPlayerInstance );
			
			// Dispatch the VIDEO_INITIALISED event
			dispatchEvent(new PaidMediaEvent(PaidMediaEvent.VIDEO_INITIALISED));
		}
		
		override protected function onClick(e: PaidMediaEvent): void {
			trace("[VIDEO] Main clicktag");
			// Bring in the functionality from the overriden method
			super.onClick(e);
		}

		protected function playVideo():void
		{
			trace("[YTPLAYER] Play video");
			// The video is now playing
			isVidPlaying = true;
			if (vidCntrl) {
				// Toggles which movie clip to show
				vidCntrl.gotoAndStop(1);
			}
			// Make sure the video is visible;
			vidPlayerInstance.visible = true;
			// Play the video
			vidPlayerInstance.proxy.play();
		}

		protected function pauseVideo():void
		{
			isVidPlaying = false;
			if (vidCntrl) {
				// Toggles which movie clip to show
				vidCntrl.gotoAndStop(2);
			}
			// Pause the video;
			vidPlayerInstance.proxy.pause();
		}

		protected function replayVideo( e:MouseEvent ):void
		{
			trace("[YTPLAYER] Replay Clicked");
			/*// Hide replay button
			vidRply.visible = false;*/
			// Dispatch the event
			dispatchEvent( new PaidMediaEvent( PaidMediaEvent.VIDEO_REPLAY ) );
			// The video is now playing
			isVidPlaying = true;
			if (vidCntrl) {
				// Toggles which movie clip to show
				vidCntrl.gotoAndStop(1);
			}
			// Make sure the video is visible;
			vidPlayerInstance.visible = true;
			//Restart the video
			vidPlayerInstance.proxy.replay();
		}

		private function toggleVideo( e:MouseEvent ):void
		{
			trace("[YTPLAYER] Video toggle");
			// Checks to see if the video is playing
			if ( ! isVidPlaying )
			{
				trace("[YTPLAYER] Play it");
				// Yes it is, unpause it
				playVideo();
			}
			else
			{
				trace("[YTPLAYER] Pause it");
				// No it isn't, pause it
				pauseVideo();
			}
		}
		
		protected function videoMouseOver(e: MouseEvent): void {
			dispatchEvent(new PaidMediaEvent(PaidMediaEvent.MOUSE_OVER));
		}

		protected function videoMouseOut(e: MouseEvent): void {
			dispatchEvent(new PaidMediaEvent(PaidMediaEvent.MOUSE_OUT));
		}

		private function toggleSound( e:MouseEvent ):void
		{
			// Checks to see if it should mute or unmute
			if (isMuted)
			{
				//trace("Unmute it");
				// Yes it is, unmute it
				unmuteVideo();
			}
			else
			{
				//trace("Mute it");
				// No it isn't, mute it
				muteVideo();
			}
		}

		protected function muteVideo():void
		{
			isMuted = true;
			// Mute the video
			vidPlayerInstance.proxy.mute();
			if(vidSound) {
				// Toggles which movie clip to show;
				vidSound.gotoAndStop(1);
			}
		}

		protected function unmuteVideo():void
		{
			isMuted = false;
			// Unmute the video
			vidPlayerInstance.proxy.unMute();
			if(vidSound) {
				// Toggles which movie clip to show;
				vidSound.gotoAndStop(2);
			}
		}

		private function onCue( e:YTPlayerEvent ):void
		{
			//trace("[VIDEO] cue");
		}

		private function onVideoEnd( e:YTPlayerEvent = null ):void
		{
			//trace("[VIDEO] Video is now over");
			// See if user is on full screen
			if( isFullScreen === true )
			{
				// If so, exit it
				vidPlayerInstance.proxy.exitFullScreen();
			}
			dispatchEvent(new PaidMediaEvent( PaidMediaEvent.ON_VIDEO_END ) );
			removeVideo();
		}

		protected function removeVideo():void
		{
			//trace("[VIDEO] Remove video");
			// Video is no longer playing
			isVidPlaying = false;
			// Hide video
			vidPlayerInstance.visible = false;
			/*// Hide controls
			vidCntrl.visible = false;
			vidSound.visible = false;
			// Show replay button
			vidRply.visible = true;*/
			// Make sure the video is stopped
/*			vidPlayerInstance.proxy.pause();
*/		}
		
		private function fullScreen( e:YTPlayerEvent ):void
		{
			isFullScreen = true;
		}
		
		private function fullScreenExit( e:YTPlayerEvent ):void
		{
			isFullScreen = false;
		}
	}
}
