﻿package com.pedrotavares.paidmedia.platforms.doubleclick { 
	// CUSTOM CLASSE IMPORTS
	import com.pedrotavares.paidmedia.platforms.doubleclick.*;
	import com.pedrotavares.paidmedia.events.PaidMediaEvent; 
	// DOUBLECLICK IMPORTS
	import com.google.ads.studio.events.StudioVideoEvent;
	import com.google.ads.studio.events.StudioEvent;
	import com.google.ads.studio.video.*; 
	// FLASH IMPORTS
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class RichVideo extends RichUnit { 
		// Video Vars
		protected var vidPlayerInstance	: VideoPlayerAdvanced; 
		//private var playlist			:Playlist;
		protected var _videoController	: EnhancedVideoController;
		protected var isVidPlaying		: Boolean; // Look into changing this into a call to the videoPlayerInstance
		protected var isMuted			: Boolean; // Look into changing this into a call to the videoPlayerInstance
		protected var vids				: Array; // Maybe an obejct? Look into it - Its attributes to replace the bellow
		protected var vidEntry			: String;
		protected var vidName			: String;
		protected var videoHolder		: MovieClip;
		protected var vidCntrl			: MovieClip;
		protected var vidSound			: MovieClip;
		protected var vidRply			: MovieClip;
		protected var vidWidth			: int;
		protected var vidHeight			: int;
		protected var vidX				: int;
		protected var vidY				: int;
		
		public function RichVideo() { 
			// NOTE: dbug var comes from the extended BaseDbug.as
			if(dbug) trace("[VIDEO] All good");
		}
		
		protected function setupVideo(vidEntry: String, videoHolder: MovieClip, vidWidth: int = 100, vidHeight: int = 100, vidX: int = 0, vidY: int = 0, vidCntrl: MovieClip = null, vidSound: MovieClip = null, vidRply: MovieClip = null): void {
			if(dbug) trace("[VIDEO] SetupVideo"); 
			// Define video stats for future use:
			this.vidEntry = vidEntry;
			this.videoHolder = videoHolder;
			this.vidCntrl = vidCntrl;
			this.vidSound = vidSound;
			this.vidRply = vidRply;
			
			// Video Player setup
			vidPlayerInstance = new VideoPlayerAdvanced(); 
			// Define the Video Player's initial size and position
			videoProperties(vidWidth, vidHeight, vidX, vidY)
			// Add it to the video holder on the display stack
			videoHolder.addChild(vidPlayerInstance);

			// Create a new video controller
			_videoController = new EnhancedVideoController();
			// Set the reporting identifier
			var identifier = vidEntry.toString();
			_videoController.setReportingIdentifier(identifier);
			// Wait until the Video Player has initialized
			vidPlayerInstance.addEventListener(StudioEvent.INIT, videoInit);
			// Does vidCntrl exist?
			if (vidCntrl) {
				// Make sure the video controls is on the correct frame
				vidCntrl.gotoAndStop(1);
				// Add the event listener if it does
				vidCntrl.addEventListener(MouseEvent.CLICK, toggleVideo);
				vidRply.addEventListener(MouseEvent.MOUSE_OVER, videoMouseOver);
				vidRply.addEventListener(MouseEvent.MOUSE_OVER, videoMouseOut);
				vidCntrl.buttonMode = true;
				vidCntrl.mouseChildren = false;
				// Move the button on top of the clicktag
				reOrderButtons([vidCntrl]);
			}

			// Does vidSound exist?
			if (vidSound) {
				// Make sure the video controls is on the correct frame
				vidSound.gotoAndStop(1);
				// Add the event listener if it does
				vidSound.addEventListener(MouseEvent.CLICK, toggleSound);
				vidRply.addEventListener(MouseEvent.MOUSE_OVER, videoMouseOver);
				vidRply.addEventListener(MouseEvent.MOUSE_OVER, videoMouseOut);
				vidSound.buttonMode = true;
				vidSound.mouseChildren = false;
				// Move the button on top of the clicktag
				reOrderButtons([vidSound]);
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
				// Hide it to begin with
				vidRply.visible = false;
				// Move the button on top of the clicktag
				reOrderButtons([vidRply]);
			}
		}

		private function videoInit(e: StudioEvent): void {
			if(dbug) trace("[VIDEO] video has initialised");
			// Event listeners
			// Consider adding a buffering listener

			// Cue points;
			vidPlayerInstance.addEventListener(StudioVideoEvent.NET_STREAM_CUE_POINT, onCue); // Check to see if this is still working
			// Create a video entry
			var videoEntry = new VideoEntry(vidEntry); 
			// Assign the video entry to the video controller
			_videoController.addVideoEntry(videoEntry); 
			// Set the video object
			_videoController.setVideoObject(vidPlayerInstance.getVideoObject()); // What is this for? 
			// The video should be muted by default
			muteVideo();
			// Make sure the video will not show once complete
			_videoController.setVideoCompleteDisplay(EnhancedVideoController.VIDEO_COMPLETE_HIDE_VIDEO);// This might not be needed as it's the default setting
			// Set the callback for when the video is complete
			_videoController.setVideoCompleteCallback(onVideoEnd);
			// Dispatch the VIDEO_INITIALISED event
			dispatchEvent(new PaidMediaEvent(PaidMediaEvent.VIDEO_INITIALISED));
		}

		protected function videoProperties(vidWidth: int = 100, vidHeight: int = 100, vidX: int = 0, vidY: int = 0): void {
			// Resize the video accordingly
			vidPlayerInstance.width = vidWidth;
			vidPlayerInstance.height = vidHeight;
			vidPlayerInstance.x = vidX;
			vidPlayerInstance.y = vidY;
		}

		private function getState(): Object {
			// Get the current state of the video
			var currState = _videoController.getPlayerState();
			if(dbug) trace("[VIDEO] CURRENT STATE IS " + currState)
			return currState;
		}

		override protected function onClick(e:MouseEvent): void {
			if(dbug) trace("[VIDEO] Main clicktag");
			// Bring in the functionality from the overriden method
			super.onClick(e);
			// Check the video current state
			var state = getState();
			if( !(state is StoppedState) ) {
				if(dbug) trace("[VIDEO] Stop it");
				// Video is playing, stop it
				stopVideo();
			}
		}
		
		protected function toggleVideo(e: MouseEvent): void {
			// Check the video current state
			var state = getState();
			if( state is PlayingState ) {
				if(dbug) trace("[VIDEO] Pause it");
				// Video is playing, pause it
				pauseVideo();
			} else {
				if(dbug) trace("[VIDEO] Play it");
				// Video is paused, play it
				playVideo();
			}
		}

		protected function videoMouseOver(e: MouseEvent): void {
			dispatchEvent(new PaidMediaEvent(PaidMediaEvent.MOUSE_OVER));//Send params describing who's over
		}

		protected function videoMouseOut(e: MouseEvent): void {
			dispatchEvent(new PaidMediaEvent(PaidMediaEvent.MOUSE_OUT));//Send params describing who's out
		}

		protected function playVideo(): void { 
			// The video is now playing
			isVidPlaying = true;
			// Play the video
			_videoController.play();
			// Make sure the player is visible
			vidPlayerInstance.visible = true;
			if (vidCntrl) {
				// Toggles which movie clip to show
				vidCntrl.gotoAndStop(1);
			}
		}

		protected function pauseVideo(): void {
			// The video is now paused
			isVidPlaying = false;
			// Pause the video;
			_videoController.pause();
			if (vidCntrl) {
				// Toggles which movie clip to show
				vidCntrl.gotoAndStop(2);
			}
		}

		protected function replayVideo(e: MouseEvent): void {		
			if(dbug) trace("[VIDEO] Replay Clicked");
			// Tell the rest of the ad that the replay has been clicked
			dispatchEvent(new PaidMediaEvent(PaidMediaEvent.VIDEO_REPLAY)); 
			// Trigger the user counter in DC
			_videoController.replay();
			// Make sure the player is visible
			vidPlayerInstance.visible = true;
			// The video is now playing
			isVidPlaying = true;
			if(vidRply){
				// Hide the replay button
				vidRply.visible = false;
			}
			// Unmute the video if muted
			if (_videoController.getVolume() == 0) {
				unmuteVideo();
			}
			// Move the play toggle to the playing state
			if (vidCntrl) {
				// Toggles which movie clip to show
				vidCntrl.gotoAndStop(1);
			}
		}

		protected function toggleSound(e: MouseEvent): void {
			// Checks to see if it should mute or unmute
			if (isMuted) {
				if(dbug) trace("[VIDEO] Unmute it");
				// Yes it is, unmute it
				unmuteVideo();
			} else {
				if(dbug) trace("[VIDEO] Mute it");
				// No it isn't, mute it
				muteVideo();
			}
		}
		
		protected function muteVideo(): void {
			isMuted = true;
			// Mute the video
			_videoController.mute();
			if(vidSound) {
				// Toggles which movie clip to show;
				vidSound.gotoAndStop(1);
			}
		}
		
		protected function unmuteVideo(): void {
			isMuted = false;
			// Unmute the video
			_videoController.unmute();
			if(vidSound) {
				// Toggles which movie clip to show;
				vidSound.gotoAndStop(2);
			}
		}
		
		private function onCue(e: StudioVideoEvent): void {
			if(dbug) trace("[VIDEO] Cue");
			// Dispatch the event to be heard
			dispatchEvent(new PaidMediaEvent(PaidMediaEvent.ON_VIDEO_CUE));
		}
		
		private function onVideoEnd(e: StudioVideoEvent = null): void {
			if(dbug) trace("[VIDEO] Video is now over");
			// Video is no longer playing
			isVidPlaying = false;
			if(vidRply){
				// Show the replay button
				vidRply.visible = true;
			}
			// Move the play toggle to the pause/stopped state
			if (vidCntrl) {
				// Toggles which movie clip to show
				vidCntrl.gotoAndStop(2);
			}
			// Dispatch the event to be heard
			dispatchEvent(new PaidMediaEvent(PaidMediaEvent.ON_VIDEO_END));
		}

		protected function stopVideo(): void {
			// Hide video
			vidPlayerInstance.visible = false;
			// Make sure the video stops no matter what
			_videoController.stop();
			// Dispatch the event the video is over
			onVideoEnd();
		}
	}
}
