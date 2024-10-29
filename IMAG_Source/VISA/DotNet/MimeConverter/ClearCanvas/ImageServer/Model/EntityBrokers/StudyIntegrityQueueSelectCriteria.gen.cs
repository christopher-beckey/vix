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

namespace ClearCanvas.ImageServer.Model.EntityBrokers
{
    using System;
    using System.Xml;
    using ClearCanvas.Enterprise.Core;
    using ClearCanvas.ImageServer.Enterprise;

    public partial class StudyIntegrityQueueSelectCriteria : EntitySelectCriteria
    {
        public StudyIntegrityQueueSelectCriteria()
        : base("StudyIntegrityQueue")
        {}
        public StudyIntegrityQueueSelectCriteria(StudyIntegrityQueueSelectCriteria other)
        : base(other)
        {}
        public override object Clone()
        {
            return new StudyIntegrityQueueSelectCriteria(this);
        }
        [EntityFieldDatabaseMappingAttribute(TableName="StudyIntegrityQueue", ColumnName="ServerPartitionGUID")]
        public ISearchCondition<ServerEntityKey> ServerPartitionKey
        {
            get
            {
              if (!SubCriteria.ContainsKey("ServerPartitionKey"))
              {
                 SubCriteria["ServerPartitionKey"] = new SearchCondition<ServerEntityKey>("ServerPartitionKey");
              }
              return (ISearchCondition<ServerEntityKey>)SubCriteria["ServerPartitionKey"];
            } 
        }
        [EntityFieldDatabaseMappingAttribute(TableName="StudyIntegrityQueue", ColumnName="StudyStorageGUID")]
        public ISearchCondition<ServerEntityKey> StudyStorageKey
        {
            get
            {
              if (!SubCriteria.ContainsKey("StudyStorageKey"))
              {
                 SubCriteria["StudyStorageKey"] = new SearchCondition<ServerEntityKey>("StudyStorageKey");
              }
              return (ISearchCondition<ServerEntityKey>)SubCriteria["StudyStorageKey"];
            } 
        }
        [EntityFieldDatabaseMappingAttribute(TableName="StudyIntegrityQueue", ColumnName="InsertTime")]
        public ISearchCondition<DateTime> InsertTime
        {
            get
            {
              if (!SubCriteria.ContainsKey("InsertTime"))
              {
                 SubCriteria["InsertTime"] = new SearchCondition<DateTime>("InsertTime");
              }
              return (ISearchCondition<DateTime>)SubCriteria["InsertTime"];
            } 
        }
        [EntityFieldDatabaseMappingAttribute(TableName="StudyIntegrityQueue", ColumnName="StudyData")]
        public ISearchCondition<XmlDocument> StudyData
        {
            get
            {
              if (!SubCriteria.ContainsKey("StudyData"))
              {
                 SubCriteria["StudyData"] = new SearchCondition<XmlDocument>("StudyData");
              }
              return (ISearchCondition<XmlDocument>)SubCriteria["StudyData"];
            } 
        }
        [EntityFieldDatabaseMappingAttribute(TableName="StudyIntegrityQueue", ColumnName="StudyIntegrityReasonEnum")]
        public ISearchCondition<StudyIntegrityReasonEnum> StudyIntegrityReasonEnum
        {
            get
            {
              if (!SubCriteria.ContainsKey("StudyIntegrityReasonEnum"))
              {
                 SubCriteria["StudyIntegrityReasonEnum"] = new SearchCondition<StudyIntegrityReasonEnum>("StudyIntegrityReasonEnum");
              }
              return (ISearchCondition<StudyIntegrityReasonEnum>)SubCriteria["StudyIntegrityReasonEnum"];
            } 
        }
        [EntityFieldDatabaseMappingAttribute(TableName="StudyIntegrityQueue", ColumnName="GroupID")]
        public ISearchCondition<String> GroupID
        {
            get
            {
              if (!SubCriteria.ContainsKey("GroupID"))
              {
                 SubCriteria["GroupID"] = new SearchCondition<String>("GroupID");
              }
              return (ISearchCondition<String>)SubCriteria["GroupID"];
            } 
        }
        [EntityFieldDatabaseMappingAttribute(TableName="StudyIntegrityQueue", ColumnName="Details")]
        public ISearchCondition<XmlDocument> Details
        {
            get
            {
              if (!SubCriteria.ContainsKey("Details"))
              {
                 SubCriteria["Details"] = new SearchCondition<XmlDocument>("Details");
              }
              return (ISearchCondition<XmlDocument>)SubCriteria["Details"];
            } 
        }
        [EntityFieldDatabaseMappingAttribute(TableName="StudyIntegrityQueue", ColumnName="Description")]
        public ISearchCondition<String> Description
        {
            get
            {
              if (!SubCriteria.ContainsKey("Description"))
              {
                 SubCriteria["Description"] = new SearchCondition<String>("Description");
              }
              return (ISearchCondition<String>)SubCriteria["Description"];
            } 
        }
    }
}
