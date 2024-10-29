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
public partial class ServerPartitionTypeEnum : ServerEnum
{
      #region Private Static Members
      private static readonly ServerPartitionTypeEnum _Standard = GetEnum("Standard");
      private static readonly ServerPartitionTypeEnum _VFS = GetEnum("VFS");
      #endregion

      #region Public Static Properties
      /// <summary>
      /// A standard ImageServer Partition
      /// </summary>
      public static ServerPartitionTypeEnum Standard
      {
          get { return _Standard; }
      }
      /// <summary>
      /// An ImageServer Virtual File System Partition
      /// </summary>
      public static ServerPartitionTypeEnum VFS
      {
          get { return _VFS; }
      }

      #endregion

      #region Constructors
      public ServerPartitionTypeEnum():base("ServerPartitionTypeEnum")
      {}
      #endregion
      #region Public Members
      public override void SetEnum(short val)
      {
          ServerEnumHelper<ServerPartitionTypeEnum, IServerPartitionTypeEnumBroker>.SetEnum(this, val);
      }
      static public List<ServerPartitionTypeEnum> GetAll()
      {
          return ServerEnumHelper<ServerPartitionTypeEnum, IServerPartitionTypeEnumBroker>.GetAll();
      }
      static public ServerPartitionTypeEnum GetEnum(string lookup)
      {
          return ServerEnumHelper<ServerPartitionTypeEnum, IServerPartitionTypeEnumBroker>.GetEnum(lookup);
      }
      #endregion
}
}
