unit iMagDicomHeaderLoader;
(*
        ;; +---------------------------------------------------------------------------------------------------+
        ;;  MAG - IMAGING
        ;;  Property of the US Government.
        ;;  WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
        ;;  No permission to copy or redistribute this software is given.
        ;;  Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;;
        ;;  Date created: May 2013
        ;;  Site Name:  Washington OI Field Office, Silver Spring, MD
        ;;  Developer:  Julian Werfel
        ;;  Description: Interface to genericize loading of DICOM header
        ;;    information from a DICOM image.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

interface

uses
  uMagClasses;

type
  TMagDicomHeaderLoader = class//Interface(IInterface)
    Function LoadDicomHeader(Filename : String) : TDicomData; Virtual; Abstract;

  End;

implementation

end.
