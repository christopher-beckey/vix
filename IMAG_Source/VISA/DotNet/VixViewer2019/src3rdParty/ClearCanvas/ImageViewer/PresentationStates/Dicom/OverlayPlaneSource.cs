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

namespace ClearCanvas.ImageViewer.PresentationStates.Dicom
{
	/// <summary>
	/// Enumeration to indicate the source of an <see cref="OverlayPlaneGraphic"/>.
	/// </summary>
	public enum OverlayPlaneSource
	{
		/// <summary>
		/// Indicates that the associated <see cref="OverlayPlaneGraphic"/> was defined in the image SOP or the image SOP referenced by the presentation state SOP.
		/// </summary>
		Image,

		/// <summary>
		/// Indicates that the associated <see cref="OverlayPlaneGraphic"/> was defined in the presentation state SOP.
		/// </summary>
		PresentationState,

		/// <summary>
		/// Indicates that the associated <see cref="OverlayPlaneGraphic"/> was user-created.
		/// </summary>
		User
	}
}