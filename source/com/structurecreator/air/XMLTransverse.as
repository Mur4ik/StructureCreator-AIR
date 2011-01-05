﻿package com.structurecreator.air
{
	/**
	 * ...
	 * @author Ed Moore
	 */
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class XMLTransverse extends MovieClip 
	{
		private static var _xmlUrl:String = '';
		private static var _directory:String = '';
		private var _xmlLoader:URLLoader;
		private var _totalFiles:int;
		private var _filesCreated:int;
		
		public function XMLTransverse(schema_xml:String, directory:String) 
		{
			_xmlUrl = schema_xml;
			_directory = directory;
			
			CaptainsLog.getInstance().addToLog("Start Creation");
			
			loadXML();
		}
		
		private function loadXML():void
		{
			//StructureCreator.instance.addInfoText("load the xml " + _xmlUrl);
			CaptainsLog.getInstance().addToLog("load the xml " + _xmlUrl);
			_xmlLoader = new URLLoader();
			_xmlLoader.addEventListener(Event.COMPLETE, hComplete);
			_xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, secError);
			_xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, hError);
			_xmlLoader.load(new URLRequest(_xmlUrl));
		}
		
		private function secError(e:SecurityErrorEvent):void 
		{
			//StructureCreator.instance.addInfoText("security error: " + e);
			CaptainsLog.getInstance().addToLog("security error: " + e);
		}
		
		private function hComplete(e:Event):void 
		{
			CaptainsLog.getInstance().addToLog('load xml complete');
			_xmlLoader.removeEventListener(Event.COMPLETE, hComplete);
			_xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, hError);
			
			var xml:XML = new XML(e.currentTarget.data);
			
			CaptainsLog.getInstance().addToLog(xml.folder.length());
			_totalFiles = xml.descendants('file').length();
			_filesCreated = 0;
			
			createStructure(xml);
		}
		
		private function createStructure(xml:XML, path:String = '/'):void
		{
			var currPath:String = path;
			
			CaptainsLog.getInstance().addToLog(currPath);
			
			//FILES
			var file:File;
			var url:String;
			
			for (var j:int = 0; j < xml.file.length(); j++) 
			{
				CaptainsLog.getInstance().addToLog("create file: " + xml.file[j].@name);
				url = xml.file[j].@url;
				
				new FileCreate(_directory + currPath, CustomVars.getInstance().addVariables(xml.file[j].@name), url, xml.file[j].text());
				_filesCreated += 1;
			}
			//FOLDERS
			var dir:File;
			for (var i:int = 0; i < xml.folder.length(); ++i)
			{
				CaptainsLog.getInstance().addToLog("create folder : " + xml.folder[i].@name);
				dir = new File();
				dir.url = _directory + currPath;
				dir = dir.resolvePath(CustomVars.getInstance().addVariables(xml.folder[i].@name));
				dir.createDirectory();
				
				if (xml.folder[i].folder.length() > 0 || xml.folder[i].file.length() > 0)
				{
					createStructure(xml.folder[i] as XML, currPath + CustomVars.getInstance().addVariables(xml.folder[i].@name) + '/');
				}
			}
			_filesCreated >= _totalFiles ? writeLogFile() : '';
		}
		
		private function writeLogFile():void
		{
			CaptainsLog.getInstance().writeToFile();
		}
		
		private function hError(e:IOErrorEvent):void 
		{
			CaptainsLog.getInstance().addToLog("load xml error: " + e + "\n");
			trace("Error: " + e);
		}
		
	}
	
}