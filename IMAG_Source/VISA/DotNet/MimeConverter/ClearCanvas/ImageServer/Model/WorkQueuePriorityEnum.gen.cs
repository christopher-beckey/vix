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
public partial class WorkQueuePriorityEnum : ServerEnum
{
      #region Private Static Members
      private static readonly WorkQueuePriorityEnum _Low = GetEnum("Low");
      private static readonly WorkQueuePriorityEnum _Medium = GetEnum("Medium");
      private static readonly WorkQueuePriorityEnum _High = GetEnum("High");
      private static readonly WorkQueuePriorityEnum _Stat = GetEnum("Stat");
      #endregion

      #region Public Static Properties
      /// <summary>
      /// Low priority
      /// </summary>
      public static WorkQueuePriorityEnum Low
      {
          get { return _Low; }
      }
      /// <summary>
      /// Medium priority
      /// </summary>
      public static WorkQueuePriorityEnum Medium
      {
          get { return _Medium; }
      }
      /// <summary>
      /// High priority
      /// </summary>
      public static WorkQueuePriorityEnum High
      {
          get { return _High; }
      }
      /// <summary>
      /// Stat priority
      /// </summary>
      public static WorkQueuePriorityEnum Stat
      {
          get { return _Stat; }
      }

      #endregion

      #region Constructors
      public WorkQueuePriorityEnum():base("WorkQueuePriorityEnum")
      {}
      #endregion
      #region Public Members
      public override void SetEnum(short val)
      {
          ServerEnumHelper<WorkQueuePriorityEnum, IWorkQueuePriorityEnumBroker>.SetEnum(this, val);
      }
      static public List<WorkQueuePriorityEnum> GetAll()
      {
          return ServerEnumHelper<WorkQueuePriorityEnum, IWorkQueuePriorityEnumBroker>.GetAll();
      }
      static public WorkQueuePriorityEnum GetEnum(string lookup)
      {
          return ServerEnumHelper<WorkQueuePriorityEnum, IWorkQueuePriorityEnumBroker>.GetEnum(lookup);
      }
      #endregion
}
}
