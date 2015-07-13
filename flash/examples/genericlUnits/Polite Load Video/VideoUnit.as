package {
	// CUSTOM CLASSE IMPORTS
	import com.pedrotavares.paidmedia.events.PaidMediaEvent;
	/*///////////////////////////////////////////////// 
		Uncomment the necessary AdServer distributor 
	*//////////////////////////////////////////////////
	import com.pedrotavares.paidmedia.platforms.doubleclick.*;// DOUBLECLICK
	//import com.pedrotavares.paidmedia.platforms.sizmek.*;// SIZMEK		import flash.events.Event;	public class VideoUnit extends RichVideo {		public function VideoUnit() {			if(dbug) trace("[MAIN CLASS] All good");
			// Listen for when the unit is ready to play
			addEventListener( PaidMediaEvent.UNIT_INITIALISED, unitReady );		}				private function unitReady( e:PaidMediaEvent ):void {			if(dbug) trace("[MAIN CLASS] On stage, setup and play the video");			// Initialize the video			setupVideo("_SampleVideo.flv", video_holder,  300, 128, 0, 0, play_toggle, sound_toggle, replay_mc);			// Wait until the video has completely initialized,
			// before attempting to play it
			addEventListener( PaidMediaEvent.VIDEO_INITIALISED, function(){
				// Automatically play the video
				playVideo();
			});
					}	}}