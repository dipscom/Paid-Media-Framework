﻿package {
	// CUSTOM CLASSE IMPORTS
	import com.pedrotavares.paidmedia.events.PaidMediaEvent;
	/*///////////////////////////////////////////////// 
		Uncomment the necessary AdServer distributor 
	*//////////////////////////////////////////////////
	import com.pedrotavares.paidmedia.platforms.doubleclick.*;// DOUBLECLICK
	//import com.pedrotavares.paidmedia.platforms.sizmek.*;// SIZMEK
			// Listen for when the unit is ready to play
			addEventListener( PaidMediaEvent.UNIT_INITIALISED, unitReady );
			// before attempting to play it
			addEventListener( PaidMediaEvent.VIDEO_INITIALISED, function(){
				// Automatically play the video
				playVideo();
			});
			