﻿/*
Project: ImporterSolution
Date Created: 05/17/2022
Site Name:  Field Office (Remote)
Developer:  Gary Pham (oitlonphamg)
Description: P346 - This interface encapsulates a dialog progress for display of time duration of how long a task has taken to process/complete.

: ----------
: Property of the US Government.
: No permission to copy or redistribute this software is given.
: Use of unreleased versions of this software requires the user
: to execute a written test agreement with the VistA Imaging
: Development Office of the Department of Veterans Affairs,
: telephone (301) 734-0100.
: 
: The Food and Drug Administration classifies this software as
: a Class II medical device.  As such, it may not be changed
: in any way.  Modifications to this software may result in an
: adulterated medical device under 21CFR820, the use of which
: is considered to be a violation of US Federal Statutes.
: ----------
 */

using ImagingClient.Infrastructure.DialogService;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ImagingClient.Infrastructure.DialogService
{
   public interface IDialogServiceImporter : IDialogService
   {
      void CloseDialog();
      void ShowDialog();
   }
}
