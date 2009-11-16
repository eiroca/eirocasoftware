/**
 * (C) 2006-2009 eIrOcA (eNrIcO Croce & sImOnA Burzio)
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 3 of the License, or (at your option) any later
 * version.
 */
using System;
using Microsoft.Office.Core;
using PowerPoint;

namespace WikiHelper {

  public class Presentation {
    
  	bool bAssistantOn;

  	static PowerPoint.Application powerpoint;
  	static PowerPoint.Presentations presentationSet;
  	
  	
  	PowerPoint.Presentation presentation;
  	PowerPoint.Slides slides;
  	
  	public const string SEP = "\r";

    public Presentation(string strTemplate) {
  	  Create(strTemplate);
    }

  	~Presentation() {
  	  Close();
  	}
  	public PowerPoint.Slide Add(string title) { 
  	  return Add(PowerPoint.PpSlideLayout.ppLayoutTitleOnly, title);
  	}
    
  	public PowerPoint.Slide Add(PowerPoint.PpSlideLayout layout, string title) {
    	PowerPoint.Slide slide;
    	PowerPoint.TextRange textRange;
    	slide = slides.Add(slides.Count+1, layout);
    	textRange = slide.Shapes[1].TextFrame.TextRange;
    	textRange.Text = title;
    	return slide;
  	}
    
    public void Save(string path) {
    	presentation.SaveAs(path, PpSaveAsFileType.ppSaveAsPresentation, Microsoft.Office.Core.MsoTriState.msoFalse);
    }

  	public void OpenPowerPoint() {
    	powerpoint = new PowerPoint.Application();
    	powerpoint.Visible = MsoTriState.msoTrue;
    	//Prevent Office Assistant from displaying alert messages:
    	bAssistantOn = powerpoint.Assistant.On;
    	powerpoint.Assistant.On = false;
    	presentationSet = powerpoint.Presentations;
  	}

  	public void ClosePowerPoint() {
  	  if (powerpoint !=null) {
      	// Reenable Office Assisant, if it was on:
      	if (bAssistantOn) {
      		powerpoint.Assistant.On = true;
      		powerpoint.Assistant.Visible = false;
      	}
      	powerpoint.Quit();
      	presentationSet = null;
      	powerpoint = null;
  	  }
  	}

    public void Create(string strTemplate) {
  	  if (powerpoint==null) {
  	    OpenPowerPoint();
  	  }
    	//Create a new presentation based on a template.
    	presentation = presentationSet.Open(strTemplate, MsoTriState.msoFalse, MsoTriState.msoTrue, MsoTriState.msoTrue);
    	slides = presentation.Slides;
  	}
  	
    public void Close() {
  	  if (presentation !=null) {
      	presentation.Close();
      	slides = null;
      	presentation = null;
  	  }
  	}
    
  }
  
}
