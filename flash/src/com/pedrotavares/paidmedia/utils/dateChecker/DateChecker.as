package com.pedrotavares.paidmedia.utils.dateChecker{	public class DateChecker	{		// possible date states		public static const BEFORE_DATE:String = "DateBefore";		public static const POST_DATE:String = "DatePost";		public static const RELEASE_PERIOD:String = "DateReleasePeriod";		public static const RELEASE_DATE:String = "DateRelease";		// current date state		private static var currentDateState:String;		// calculate and return the currentDate state		// accepts two arguments:		// $targetDate - Date of release		// $releaseDatePeriod- An optional date before date of release after which different behavious is required		public static function getCurrentDateState($targetDate:Date,$releaseDatePeriod:Date=null):String		{			calculateCurrentDateState($targetDate,$releaseDatePeriod);			return currentDateState;		}
		
		public static function hasReleased(releaseDate:Date):Boolean {
			var today:Date = new Date;
			var releaseDate:Date = releaseDate;
			
			// Is the today date before the release date
			if(today < releaseDate){
				// Today is before the release date
				return false;
			} else {
				// Today is either on or has past the release date
				return true;
			}
			
		}		// logic to calculate the current date state		private static function calculateCurrentDateState($targetDate:Date,$releaseDatePeriod:Date):void		{			var date:Date = new Date ;			var targetDate:Date = $targetDate;			var releasePeriodDate:Date = $releaseDatePeriod;			// check if $releaseDatePeriod is defined, then check for release period dates			if ($releaseDatePeriod)			{				// is current date before the release period date				if (date.getTime() < releasePeriodDate.getTime())				{					currentDateState = BEFORE_DATE;					return;				}				// is current date after the start of the release period but before the release date?				if (date.getTime() < targetDate.getTime())				{					currentDateState = RELEASE_PERIOD;					return;				}			} else {				// are we ignoring the release period and is date before the release date				if (date.getTime() < targetDate.getTime())				{					currentDateState = BEFORE_DATE;					return;				}			}			// are we on the release day?			if (date.getTime() < targetDate.getTime() + 86400000)			{				currentDateState = RELEASE_DATE;				return;			}			// all checks fail so we are past the release date			currentDateState = POST_DATE;			return;		}	}}