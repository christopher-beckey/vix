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
    using System.Xml;
    using ClearCanvas.Enterprise.Core;
    using ClearCanvas.ImageServer.Enterprise;
    using ClearCanvas.ImageServer.Enterprise.Command;
    using ClearCanvas.ImageServer.Model.EntityBrokers;

    [Serializable]
    public partial class ArchiveQueue: ServerEntity
    {
        #region Constructors
        public ArchiveQueue():base("ArchiveQueue")
        {}
        public ArchiveQueue(
             ServerEntityKey _partitionArchiveKey_
            ,DateTime _scheduledTime_
            ,ServerEntityKey _studyStorageKey_
            ,ArchiveQueueStatusEnum _archiveQueueStatusEnum_
            ,String _processorId_
            ,String _failureDescription_
            ):base("ArchiveQueue")
        {
            PartitionArchiveKey = _partitionArchiveKey_;
            ScheduledTime = _scheduledTime_;
            StudyStorageKey = _studyStorageKey_;
            ArchiveQueueStatusEnum = _archiveQueueStatusEnum_;
            ProcessorId = _processorId_;
            FailureDescription = _failureDescription_;
        }
        #endregion

        #region Public Properties
        [EntityFieldDatabaseMappingAttribute(TableName="ArchiveQueue", ColumnName="PartitionArchiveGUID")]
        public ServerEntityKey PartitionArchiveKey
        { get; set; }
        [EntityFieldDatabaseMappingAttribute(TableName="ArchiveQueue", ColumnName="ScheduledTime")]
        public DateTime ScheduledTime
        { get; set; }
        [EntityFieldDatabaseMappingAttribute(TableName="ArchiveQueue", ColumnName="StudyStorageGUID")]
        public ServerEntityKey StudyStorageKey
        { get; set; }
        [EntityFieldDatabaseMappingAttribute(TableName="ArchiveQueue", ColumnName="ArchiveQueueStatusEnum")]
        public ArchiveQueueStatusEnum ArchiveQueueStatusEnum
        { get; set; }
        [EntityFieldDatabaseMappingAttribute(TableName="ArchiveQueue", ColumnName="ProcessorId")]
        public String ProcessorId
        { get; set; }
        [EntityFieldDatabaseMappingAttribute(TableName="ArchiveQueue", ColumnName="FailureDescription")]
        public String FailureDescription
        { get; set; }
        #endregion

        #region Static Methods
        static public ArchiveQueue Load(ServerEntityKey key)
        {
            using (var context = new ServerExecutionContext())
            {
                return Load(context.ReadContext, key);
            }
        }
        static public ArchiveQueue Load(IPersistenceContext read, ServerEntityKey key)
        {
            var broker = read.GetBroker<IArchiveQueueEntityBroker>();
            ArchiveQueue theObject = broker.Load(key);
            return theObject;
        }
        static public ArchiveQueue Insert(ArchiveQueue entity)
        {
            using (var update = PersistentStoreRegistry.GetDefaultStore().OpenUpdateContext(UpdateContextSyncMode.Flush))
            {
                ArchiveQueue newEntity = Insert(update, entity);
                update.Commit();
                return newEntity;
            }
        }
        static public ArchiveQueue Insert(IUpdateContext update, ArchiveQueue entity)
        {
            var broker = update.GetBroker<IArchiveQueueEntityBroker>();
            var updateColumns = new ArchiveQueueUpdateColumns();
            updateColumns.PartitionArchiveKey = entity.PartitionArchiveKey;
            updateColumns.ScheduledTime = entity.ScheduledTime;
            updateColumns.StudyStorageKey = entity.StudyStorageKey;
            updateColumns.ArchiveQueueStatusEnum = entity.ArchiveQueueStatusEnum;
            updateColumns.ProcessorId = entity.ProcessorId;
            updateColumns.FailureDescription = entity.FailureDescription;
            ArchiveQueue newEntity = broker.Insert(updateColumns);
            return newEntity;
        }
        #endregion
    }
}
