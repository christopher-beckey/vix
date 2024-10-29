#region License

// Copyright (c) 2013, ClearCanvas Inc.
// All rights reserved.
// http://www.clearcanvas.ca
//
// This file is part of the ClearCanvas RIS/PACS open source project.
//
// The ClearCanvas RIS/PACS open source project is free software: you can
// redistribute it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// The ClearCanvas RIS/PACS open source project is distributed in the hope that it
// will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
// Public License for more details.
//
// You should have received a copy of the GNU General Public License along with
// the ClearCanvas RIS/PACS open source project.  If not, see
// <http://www.gnu.org/licenses/>.

#endregion

// This file is auto-generated by the ClearCanvas.Model.SqlServer.CodeGenerator project.

namespace ClearCanvas.ImageServer.Model
{
    using System;
    using System.Collections.Generic;
    using ClearCanvas.ImageServer.Model.EntityBrokers;
    using ClearCanvas.ImageServer.Enterprise;
    using System.Reflection;

[Serializable]
public partial class AlertLevelEnum : ServerEnum
{
      #region Private Static Members
      private static readonly AlertLevelEnum _Informational = GetEnum("Informational");
      private static readonly AlertLevelEnum _Warning = GetEnum("Warning");
      private static readonly AlertLevelEnum _Error = GetEnum("Error");
      private static readonly AlertLevelEnum _Critical = GetEnum("Critical");
      #endregion

      #region Public Static Properties
      /// <summary>
      /// Informational alert
      /// </summary>
      public static AlertLevelEnum Informational
      {
          get { return _Informational; }
      }
      /// <summary>
      /// Warning alert
      /// </summary>
      public static AlertLevelEnum Warning
      {
          get { return _Warning; }
      }
      /// <summary>
      /// Error alert
      /// </summary>
      public static AlertLevelEnum Error
      {
          get { return _Error; }
      }
      /// <summary>
      /// Critical alert
      /// </summary>
      public static AlertLevelEnum Critical
      {
          get { return _Critical; }
      }

      #endregion

      #region Constructors
      public AlertLevelEnum():base("AlertLevelEnum")
      {}
      #endregion
      #region Public Members
      public override void SetEnum(short val)
      {
          ServerEnumHelper<AlertLevelEnum, IAlertLevelEnumBroker>.SetEnum(this, val);
      }
      static public List<AlertLevelEnum> GetAll()
      {
          return ServerEnumHelper<AlertLevelEnum, IAlertLevelEnumBroker>.GetAll();
      }
      static public AlertLevelEnum GetEnum(string lookup)
      {
          return ServerEnumHelper<AlertLevelEnum, IAlertLevelEnumBroker>.GetEnum(lookup);
      }
      #endregion
}
}
