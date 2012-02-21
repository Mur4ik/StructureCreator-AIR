package com.structurecreator.view.saveprofile
{
	import com.structurecreator.events.ProfileEvent;
	
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class SaveProfileWindowMediator extends Mediator
	{
		[Inject]
		public var view:SaveProfileWindow;
		
		public function SaveProfileWindowMediator()
		{
			
		}
		
		override public function onRegister():void
		{
			trace("Save Profile Window registered");
			view.saveBtn.addEventListener(MouseEvent.CLICK, onSaveClick);
		}
		
		/**
		 * On Save Click dispatch the name of the profile
		 */
		protected function onSaveClick(event:MouseEvent):void
		{
			if (view.profile_name.text != '')
			{
				trace("dispatch profile name");
				eventDispatcher.dispatchEvent(new ProfileEvent(ProfileEvent.SAVE_PROFILE, view.profile_name.text));
			}
		}
	}
}