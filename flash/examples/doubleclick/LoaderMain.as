﻿package {	import paidMedia.flashAS3.doubleclick.DoubleclickLoader;	public class LoaderMain extends DoubleclickLoader	{		public function LoaderMain()		{			//trace("[MAIN] All good");			// The bellow string should be the name of the child swf to load and the date to use			init("doubleclick_rich.swf", new Date(2014,2,18));		}	}}