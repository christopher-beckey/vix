{*------------------------------------------------------------------------------
  Hashmap class (does not actually use a hash function to store data, but data
    can be accessed by using a hash key).

  @author Julian Werfel
-------------------------------------------------------------------------------}

Unit cMagHashmap;
{
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date created: February 2006
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  Julian Werfel
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
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Classes
  ;

Type
  TMagHashmapItem = Class
  Public
    Key: String;
    Value: String;
  End;

Type
  TMagHashmap = Class(Tobject)
  Public
    Procedure put(Key, Value: String);
    Function Get(Key: String): String;
    Constructor Create();
    Function DisplayMap(): String;
    Procedure Clear();

  Private
      /// contains all objects stored in the map
    map: Tlist;
    Function getHashmapItem(Key: String): TMagHashmapItem;

  Protected
  End;

Implementation

{*------------------------------------------------------------------------------
  Default constructor, creates the map list object

  @author Julian Werfel
-------------------------------------------------------------------------------}

Constructor TMagHashmap.Create();
Begin
  Inherited;
  map := Tlist.Create();
End;

{*------------------------------------------------------------------------------
  Adds an item to the map, if the key already exists, the value is updated

  @author Julian Werfel
  @param Key the key for the new value
  @param Value the value to be added
-------------------------------------------------------------------------------}

Procedure TMagHashmap.put(Key, Value: String);
Var
  curItem: TMagHashmapItem;
Begin
  curItem := getHashmapItem(Key);
  If curItem = Nil Then
  Begin
    curItem := TMagHashmapItem.Create();
    curItem.Key := Key;
    curItem.Value := Value;
    map.Add(curItem);
  End
  Else
  Begin
    curItem.Value := Value;
  End;

End;

{*------------------------------------------------------------------------------
  Finds the hashmap key item for the given key

  @author Julian Werfel
  @param Key the key to search for
  @return The hashmap key item for the given key
-------------------------------------------------------------------------------}

Function TMagHashmap.getHashmapItem(Key: String): TMagHashmapItem;
Var
  i: Integer;
  curItem: TMagHashmapItem;
Begin
  Result := Nil;
  For i := 0 To map.Count - 1 Do
  Begin
    curItem := map.Items[i];
    If curItem.Key = Key Then
    Begin
      Result := curItem;
    End;
  End;
End;

{*------------------------------------------------------------------------------
  Finds the the value for the given key

  @author Julian Werfel
  @param Key the key to search for
  @return The value for the given key
-------------------------------------------------------------------------------}

Function TMagHashmap.Get(Key: String): String;
Var
  i: Integer;
  curItem: TMagHashmapItem;
Begin
  Result := '';
  For i := 0 To map.Count - 1 Do
  Begin
    curItem := map.Items[i];
    If curItem.Key = Key Then
    Begin
      Result := curItem.Value;
      Exit;
    End;
  End;
End;

{*------------------------------------------------------------------------------
  Displays a string representation of the map

  @author Julian Werfel
  @return The map in string form
-------------------------------------------------------------------------------}

Function TMagHashmap.DisplayMap(): String;
Var
  i: Integer;
  curItem: TMagHashmapItem;
Begin
  Result := '';
  For i := 0 To map.Count - 1 Do
  Begin
    curItem := map.Items[i];
    Result := Result + '[' + curItem.Key + ']=' + curItem.Value + #13;
  End;
End;

{*------------------------------------------------------------------------------
  Clears the hashmap (removes all items)

  @author Julian Werfel
-------------------------------------------------------------------------------}

Procedure TMagHashmap.Clear();
Begin
  map.Clear();
End;

End.
