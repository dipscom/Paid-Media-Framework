﻿package {	//import com.pedrotavares.paidmedia.utils.loopingGallery.GallerySetup;	import com.pedrotavares.paidmedia.utils.loopingGallery.CoverFlow	import flash.display.MovieClip;	public class galleryMain extends MovieClip	{		//public var imgGallery:GallerySetup;		public var imgGallery:CoverFlow;		public function galleryMain()		{			// constructor code			/*imgGallery = new GallerySetup(gallery_mc);			addChild(imgGallery);*/			imgGallery = new CoverFlow();			addChild(imgGallery);		}	}}