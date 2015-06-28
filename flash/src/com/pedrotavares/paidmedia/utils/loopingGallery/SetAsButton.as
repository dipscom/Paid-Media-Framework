package com.pedrotavares.paidmedia.utils {
	import flash.display.MovieClip;
	
	public class SetAsButton extends MovieClip{

		public function SetAsButton() {
			// constructor code
		}
		
		public function addButtonBehaviour(btn:MovieClip):MovieClip {
			btn.addEventListener(MouseEvent.CLICK, baseClick);
			btn.addEventListener(MouseEvent.MOUSE_OVER, baseMouseOver);
			btn.addEventListener(MouseEvent.MOUSE_OUT, baseMouseOut);
			btn.buttonMode = true;
			return btn;
		}

	}
	
}
