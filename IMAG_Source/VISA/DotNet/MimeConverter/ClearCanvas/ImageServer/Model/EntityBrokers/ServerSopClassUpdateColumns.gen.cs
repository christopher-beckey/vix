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
    using ClearCanvas.Dicom;
    using ClearCanvas.ImageServer.Enterprise;

   public partial class ServerSopClassUpdateColumns : EntityUpdateColumns
   {
       public ServerSopClassUpdateColumns()
       : base("ServerSopClass")
       {}
       [DicomField(DicomTags.SopClassUid, DefaultValue = DicomFieldDefault.Null)]
        [EntityFieldDatabaseMappingAttribute(TableName="ServerSopClass", ColumnName="SopClassUid")]
        public String SopClassUid
        {
            set { SubParameters["SopClassUid"] = new EntityUpdateColumn<String>("SopClassUid", value); }
        }
        [EntityFieldDatabaseMappingAttribute(TableName="ServerSopClass", ColumnName="Description")]
        public String Description
        {
            set { SubParameters["Description"] = new EntityUpdateColumn<String>("Description", value); }
        }
        [EntityFieldDatabaseMappingAttribute(TableName="ServerSopClass", ColumnName="NonImage")]
        public Boolean NonImage
        {
            set { SubParameters["NonImage"] = new EntityUpdateColumn<Boolean>("NonImage", value); }
        }
        [EntityFieldDatabaseMappingAttribute(TableName="ServerSopClass", ColumnName="ImplicitOnly")]
        public Boolean ImplicitOnly
        {
            set { SubParameters["ImplicitOnly"] = new EntityUpdateColumn<Boolean>("ImplicitOnly", value); }
        }
    }
}
