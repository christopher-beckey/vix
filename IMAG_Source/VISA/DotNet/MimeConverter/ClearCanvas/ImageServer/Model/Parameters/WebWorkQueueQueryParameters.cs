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

using System;
using ClearCanvas.ImageServer.Enterprise;

namespace ClearCanvas.ImageServer.Model.Parameters
{
    public class WebWorkQueueQueryParameters : ProcedureParameters
    {
        public WebWorkQueueQueryParameters()
            : base("WebQueryWorkQueue")
        {
			//Declare output parameters here
			SubCriteria["ResultCount"] = new ProcedureParameter<int>("ResultCount");
        }

        public ServerEntityKey ServerPartitionKey
        {
            set { SubCriteria["ServerPartitionKey"] = new ProcedureParameter<ServerEntityKey>("ServerPartitionKey", value); }
        }

        public string PatientID
        {
            set { SubCriteria["PatientID"] = new ProcedureParameter<string>("PatientID", value); }
        }

        public string PatientsName
        {
			set { SubCriteria["PatientsName"] = new ProcedureParameter<string>("PatientsName", value); }
        }

        public string ProcessorID
        {
            set { SubCriteria["ProcessorID"] = new ProcedureParameter<string>("ProcessorID", value); }
        }

        public DateTime? ScheduledTime
        {
            set { SubCriteria["ScheduledTime"] = new ProcedureParameter<DateTime?>("ScheduledTime", value); }
        }

        public string Type
        {
            set { SubCriteria["Type"] = new ProcedureParameter<string>("Type", value); }
        }

        public string Status
        {
            set { SubCriteria["Status"] = new ProcedureParameter<string>("Status", value); }
        }

        public WorkQueuePriorityEnum Priority
        {
            set { SubCriteria["Priority"] = new ProcedureParameter<ServerEnum>("Priority", value); }
        }

        public bool CheckDataAccess
        {
            set { SubCriteria["CheckDataAccess"] = new ProcedureParameter<bool>("CheckDataAccess", value); }
        }

        public string UserAuthorityGroupGUIDs
        {
            set { SubCriteria["UserAuthorityGroupGUIDs"] = new ProcedureParameter<string>("UserAuthorityGroupGUIDs", value); }
        }

		public int StartIndex
        {
			set { SubCriteria["StartIndex"] = new ProcedureParameter<int>("StartIndex", value); }
	    }

		public int MaxRowCount
		{
			set { SubCriteria["MaxRowCount"] = new ProcedureParameter<int>("MaxRowCount", value); }
		}

		public int ResultCount
		{
			get { return (SubCriteria["ResultCount"] as ProcedureParameter<int>).Value; }
		}
		
    }
}
