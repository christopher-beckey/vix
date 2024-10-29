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

    public partial class SeriesSelectCriteria : EntitySelectCriteria
    {
        public SeriesSelectCriteria()
        : base("Series")
        {}
        public SeriesSelectCriteria(SeriesSelectCriteria other)
        : base(other)
        {}
        public override object Clone()
        {
            return new SeriesSelectCriteria(this);
        }
        [EntityFieldDatabaseMappingAttribute(TableName="Series", ColumnName="ServerPartitionGUID")]
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
        [EntityFieldDatabaseMappingAttribute(TableName="Series", ColumnName="StudyGUID")]
        public ISearchCondition<ServerEntityKey> StudyKey
        {
            get
            {
              if (!SubCriteria.ContainsKey("StudyKey"))
              {
                 SubCriteria["StudyKey"] = new SearchCondition<ServerEntityKey>("StudyKey");
              }
              return (ISearchCondition<ServerEntityKey>)SubCriteria["StudyKey"];
            } 
        }
        [EntityFieldDatabaseMappingAttribute(TableName="Series", ColumnName="SeriesInstanceUid")]
        public ISearchCondition<String> SeriesInstanceUid
        {
            get
            {
              if (!SubCriteria.ContainsKey("SeriesInstanceUid"))
              {
                 SubCriteria["SeriesInstanceUid"] = new SearchCondition<String>("SeriesInstanceUid");
              }
              return (ISearchCondition<String>)SubCriteria["SeriesInstanceUid"];
            } 
        }
        [EntityFieldDatabaseMappingAttribute(TableName="Series", ColumnName="Modality")]
        public ISearchCondition<String> Modality
        {
            get
            {
              if (!SubCriteria.ContainsKey("Modality"))
              {
                 SubCriteria["Modality"] = new SearchCondition<String>("Modality");
              }
              return (ISearchCondition<String>)SubCriteria["Modality"];
            } 
        }
        [EntityFieldDatabaseMappingAttribute(TableName="Series", ColumnName="NumberOfSeriesRelatedInstances")]
        public ISearchCondition<Int32> NumberOfSeriesRelatedInstances
        {
            get
            {
              if (!SubCriteria.ContainsKey("NumberOfSeriesRelatedInstances"))
              {
                 SubCriteria["NumberOfSeriesRelatedInstances"] = new SearchCondition<Int32>("NumberOfSeriesRelatedInstances");
              }
              return (ISearchCondition<Int32>)SubCriteria["NumberOfSeriesRelatedInstances"];
            } 
        }
        [EntityFieldDatabaseMappingAttribute(TableName="Series", ColumnName="PerformedProcedureStepStartDate")]
        public ISearchCondition<String> PerformedProcedureStepStartDate
        {
            get
            {
              if (!SubCriteria.ContainsKey("PerformedProcedureStepStartDate"))
              {
                 SubCriteria["PerformedProcedureStepStartDate"] = new SearchCondition<String>("PerformedProcedureStepStartDate");
              }
              return (ISearchCondition<String>)SubCriteria["PerformedProcedureStepStartDate"];
            } 
        }
        [EntityFieldDatabaseMappingAttribute(TableName="Series", ColumnName="PerformedProcedureStepStartTime")]
        public ISearchCondition<String> PerformedProcedureStepStartTime
        {
            get
            {
              if (!SubCriteria.ContainsKey("PerformedProcedureStepStartTime"))
              {
                 SubCriteria["PerformedProcedureStepStartTime"] = new SearchCondition<String>("PerformedProcedureStepStartTime");
              }
              return (ISearchCondition<String>)SubCriteria["PerformedProcedureStepStartTime"];
            } 
        }
        [EntityFieldDatabaseMappingAttribute(TableName="Series", ColumnName="SourceApplicationEntityTitle")]
        public ISearchCondition<String> SourceApplicationEntityTitle
        {
            get
            {
              if (!SubCriteria.ContainsKey("SourceApplicationEntityTitle"))
              {
                 SubCriteria["SourceApplicationEntityTitle"] = new SearchCondition<String>("SourceApplicationEntityTitle");
              }
              return (ISearchCondition<String>)SubCriteria["SourceApplicationEntityTitle"];
            } 
        }
        [EntityFieldDatabaseMappingAttribute(TableName="Series", ColumnName="SeriesNumber")]
        public ISearchCondition<String> SeriesNumber
        {
            get
            {
              if (!SubCriteria.ContainsKey("SeriesNumber"))
              {
                 SubCriteria["SeriesNumber"] = new SearchCondition<String>("SeriesNumber");
              }
              return (ISearchCondition<String>)SubCriteria["SeriesNumber"];
            } 
        }
        [EntityFieldDatabaseMappingAttribute(TableName="Series", ColumnName="SeriesDescription")]
        public ISearchCondition<String> SeriesDescription
        {
            get
            {
              if (!SubCriteria.ContainsKey("SeriesDescription"))
              {
                 SubCriteria["SeriesDescription"] = new SearchCondition<String>("SeriesDescription");
              }
              return (ISearchCondition<String>)SubCriteria["SeriesDescription"];
            } 
        }
    }
}
