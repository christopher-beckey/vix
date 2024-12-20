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
    public partial class ServiceLock: ServerEntity
    {
        #region Constructors
        public ServiceLock():base("ServiceLock")
        {}
        public ServiceLock(
             ServiceLockTypeEnum _serviceLockTypeEnum_
            ,Boolean _lock_
            ,DateTime _scheduledTime_
            ,Boolean _enabled_
            ,XmlDocument _state_
            ,ServerEntityKey _serverPartitionKey_
            ,ServerEntityKey _filesystemKey_
            ,String _processorId_
            ):base("ServiceLock")
        {
            ServiceLockTypeEnum = _serviceLockTypeEnum_;
            Lock = _lock_;
            ScheduledTime = _scheduledTime_;
            Enabled = _enabled_;
            State = _state_;
            ServerPartitionKey = _serverPartitionKey_;
            FilesystemKey = _filesystemKey_;
            ProcessorId = _processorId_;
        }
        #endregion

        #region Public Properties
        [EntityFieldDatabaseMappingAttribute(TableName="ServiceLock", ColumnName="ServiceLockTypeEnum")]
        public ServiceLockTypeEnum ServiceLockTypeEnum
        { get; set; }
        [EntityFieldDatabaseMappingAttribute(TableName="ServiceLock", ColumnName="Lock")]
        public Boolean Lock
        { get; set; }
        [EntityFieldDatabaseMappingAttribute(TableName="ServiceLock", ColumnName="ScheduledTime")]
        public DateTime ScheduledTime
        { get; set; }
        [EntityFieldDatabaseMappingAttribute(TableName="ServiceLock", ColumnName="Enabled")]
        public Boolean Enabled
        { get; set; }
        [EntityFieldDatabaseMappingAttribute(TableName="ServiceLock", ColumnName="State")]
        public XmlDocument State
        { get { return _State; } set { _State = value; } }
        [NonSerialized]
        private XmlDocument _State;
        [EntityFieldDatabaseMappingAttribute(TableName="ServiceLock", ColumnName="ServerPartitionGUID")]
        public ServerEntityKey ServerPartitionKey
        { get; set; }
        [EntityFieldDatabaseMappingAttribute(TableName="ServiceLock", ColumnName="FilesystemGUID")]
        public ServerEntityKey FilesystemKey
        { get; set; }
        [EntityFieldDatabaseMappingAttribute(TableName="ServiceLock", ColumnName="ProcessorId")]
        public String ProcessorId
        { get; set; }
        #endregion

        #region Static Methods
        static public ServiceLock Load(ServerEntityKey key)
        {
            using (var context = new ServerExecutionContext())
            {
                return Load(context.ReadContext, key);
            }
        }
        static public ServiceLock Load(IPersistenceContext read, ServerEntityKey key)
        {
            var broker = read.GetBroker<IServiceLockEntityBroker>();
            ServiceLock theObject = broker.Load(key);
            return theObject;
        }
        static public ServiceLock Insert(ServiceLock entity)
        {
            using (var update = PersistentStoreRegistry.GetDefaultStore().OpenUpdateContext(UpdateContextSyncMode.Flush))
            {
                ServiceLock newEntity = Insert(update, entity);
                update.Commit();
                return newEntity;
            }
        }
        static public ServiceLock Insert(IUpdateContext update, ServiceLock entity)
        {
            var broker = update.GetBroker<IServiceLockEntityBroker>();
            var updateColumns = new ServiceLockUpdateColumns();
            updateColumns.ServiceLockTypeEnum = entity.ServiceLockTypeEnum;
            updateColumns.Lock = entity.Lock;
            updateColumns.ScheduledTime = entity.ScheduledTime;
            updateColumns.Enabled = entity.Enabled;
            updateColumns.State = entity.State;
            updateColumns.ServerPartitionKey = entity.ServerPartitionKey;
            updateColumns.FilesystemKey = entity.FilesystemKey;
            updateColumns.ProcessorId = entity.ProcessorId;
            ServiceLock newEntity = broker.Insert(updateColumns);
            return newEntity;
        }
        #endregion
    }
}
