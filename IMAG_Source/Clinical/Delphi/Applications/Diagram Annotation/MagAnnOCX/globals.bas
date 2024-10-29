Attribute VB_Name = "globals"
'
' File: globals.bas
'
' Created: 7/11/03
'
' Copyright (c) 1996-2003 AccuSoft Corporation.  All rights reserved.
'
' You are licensed to use, modify, and merge this Sample Code so long as you
' (a) have a valid software license with AccuSoft to use the ImageGear software
' development toolkit, and (b) use, modify or merge the Sample Code only in an
' Application that contains the ImageGear distributable files.  AccuSoft is under
' no obligation to provide any support or upgrades for this or future versions of
' the Sample Code.
'
Public artPage As IGArtPage
Public igCurPoint As IGPoint

Public igFileDialog As IGFileDlg

' currently active igPage object
Public CurIGPage As IGPage

'IG DDB object for storing the DDB
Public IGDDB As IGDisplayDDB

' display for the currently active igPage object
Public igPageDisp As IGPageDisplay

Public loadOptions As IGLoadOptions
Public saveOptions As IGSaveOptions

' this object represents the current ioLocation. it could be equal to ioMemoryLocation below!
Public ioLocation As IIGIOLocation
Public ioArtLocation As IIGIOLocation

' here is a global ioMemoryLocation object, because we need to save this!!
Public ioMemoryLocation As IGIOMemory

Public currentPageNumber As Integer
Public totalLocationPageCount As Integer

'For keeping track of the current gamma/contrast/brightness settings
Public curBrightness As Double
Public curGamma As Double
Public curContrast As Double

Public Const ART_INVALID_ID = -1
Global BurnOption As Integer
Public pointsArray As IGIntegerArray

