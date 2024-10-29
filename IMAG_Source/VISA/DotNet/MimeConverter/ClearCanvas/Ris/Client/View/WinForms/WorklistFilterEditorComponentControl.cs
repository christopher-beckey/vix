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
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;

using ClearCanvas.Desktop.View.WinForms;

namespace ClearCanvas.Ris.Client.View.WinForms
{
    /// <summary>
    /// Provides a Windows Forms user-interface for <see cref="WorklistFilterEditorComponent"/>
    /// </summary>
    public partial class WorklistFilterEditorComponentControl : ApplicationComponentUserControl
    {
        private WorklistFilterEditorComponent _component;

        /// <summary>
        /// Constructor
        /// </summary>
        public WorklistFilterEditorComponentControl(WorklistFilterEditorComponent component)
            :base(component)
        {
            InitializeComponent();

            _component = component;

            _facilities.NullItem = _component.NullFilterItem;
            _facilities.Format += delegate(object sender, ListControlConvertEventArgs args) { args.Value = _component.FormatFacility(args.ListItem); };
            _facilities.DataBindings.Add("Items", _component, "FacilityChoices", true, DataSourceUpdateMode.Never);
            _facilities.DataBindings.Add("CheckedItems", _component, "SelectedFacilities", true,
                                         DataSourceUpdateMode.OnPropertyChanged);

            _priority.NullItem = _component.NullFilterItem;
            _priority.DataBindings.Add("Items", _component, "PriorityChoices", true, DataSourceUpdateMode.Never);
            _priority.DataBindings.Add("CheckedItems", _component, "SelectedPriorities", true,
                                         DataSourceUpdateMode.OnPropertyChanged);

            _patientClass.NullItem = _component.NullFilterItem;
            _patientClass.DataBindings.Add("Items", _component, "PatientClassChoices", true, DataSourceUpdateMode.Never);
            _patientClass.DataBindings.Add("CheckedItems", _component, "SelectedPatientClasses", true,
                                         DataSourceUpdateMode.OnPropertyChanged);
        	_patientClass.DataBindings.Add("Visible", _component, "PatientClassVisible");

            _portable.NullItem = _component.NullFilterItem;
            _portable.DataBindings.Add("Items", _component, "PortableChoices", true, DataSourceUpdateMode.Never);
            _portable.DataBindings.Add("CheckedItems", _component, "SelectedPortabilities", true,
                                         DataSourceUpdateMode.OnPropertyChanged);

        	_orderingPractitioner.LookupHandler = _component.OrderingPractitionerLookupHandler;
			_orderingPractitioner.DataBindings.Add("Value", _component, "SelectedOrderingPractitioner", true, DataSourceUpdateMode.OnPropertyChanged);
		}
    }
}
