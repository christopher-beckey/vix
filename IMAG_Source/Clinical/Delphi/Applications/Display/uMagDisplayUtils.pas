Unit uMagDisplayUtils;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:  Version 2.0
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==     unit uMagDisplayUtils;
   Description: Image utilities
          Some functions and methods are used by many Forms (windows) and components of
          the application.  Utility units are designed to be a repository of such
          utility functions used throughout the application.

          This utility methods for
          -  Display application.
          - Getting things out of main form
                                     ==]
   Note:
   }
(*
   ;; +---------------------------------------------------------------------------------------------------+
   ;; Property of the US Government.
   ;; No permission to copy or redistribute this software is given.
   ;; Use of unreleased versions of this software requires the user
   ;;  to execute a written test agreement with the VistA Imaging
   ;;  Development Office of the Department of Veterans Affairs,
   ;;  telephone (301) 734-0100.
   ;;
   ;; The Food and Drug Administration classifies this software as
   ;; a medical device.  As such, it may not be changed
   ;; in any way.  Modifications to this software may result in an
   ;; adulterated medical device under 21CFR820, the use of which
   ;; is considered to be a violation of US Federal Statutes.
   ;; +---------------------------------------------------------------------------------------------------+
*)
Interface
Uses
  Forms,

    //Imaging
  UMagClasses,
  UMagDefinitions,
  ImagInterfaces,
  Umagutils8,
  FmagActiveForms
  ;

Procedure outSwitchToForm; //59
Implementation

Procedure outSwitchToForm;
Begin
// moved to umagutils8A

//   frmActiveforms.execute;
End;
End.
