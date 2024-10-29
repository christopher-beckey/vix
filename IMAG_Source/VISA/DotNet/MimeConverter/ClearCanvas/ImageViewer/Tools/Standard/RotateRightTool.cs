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

using ClearCanvas.Common;
using ClearCanvas.Desktop;
using ClearCanvas.Desktop.Actions;
using ClearCanvas.ImageViewer.BaseTools;
using ClearCanvas.ImageViewer.Graphics;
using ClearCanvas.ImageViewer.Tools.Standard.Configuration;

namespace ClearCanvas.ImageViewer.Tools.Standard
{
	[MenuAction("activate", "imageviewer-contextmenu/MenuRotateRight", "Activate", InitiallyAvailable = false)]
	[MenuAction("activate", "global-menus/MenuTools/MenuStandard/MenuRotateRight", "Activate")]
	[ButtonAction("activate", "global-toolbars/ToolbarStandard/ToolbarRotateRight", "Activate", KeyStroke = XKeys.R)]
	[EnabledStateObserver("activate", "Enabled", "EnabledChanged")]
	[Tooltip("activate", "TooltipRotateRight")]
	[IconSet("activate", "Icons.RotateRightToolSmall.png", "Icons.RotateRightToolMedium.png", "Icons.RotateRightToolLarge.png")]
	[GroupHint("activate", "Tools.Image.Manipulation.Orientation.Rotate.Right")]
	[ExtensionOf(typeof (ImageViewerToolExtensionPoint))]
	public class RotateRightTool : ImageViewerTool
	{
		private readonly SpatialTransformImageOperation _operation;
		private ToolModalityBehaviorHelper _toolBehavior;

		public RotateRightTool()
		{
			_operation = new SpatialTransformImageOperation(Apply);
		}

		public override void Initialize()
		{
			base.Initialize();

			_toolBehavior = new ToolModalityBehaviorHelper(ImageViewer);
		}

		public void Activate()
		{
			if (!_operation.AppliesTo(this.SelectedPresentationImage))
				return;

			ImageOperationApplicator applicator = new ImageOperationApplicator(SelectedPresentationImage, _operation);
			UndoableCommand historyCommand = _toolBehavior.Behavior.SelectedImageRotateTool ? applicator.ApplyToReferenceImage() : applicator.ApplyToAllImages();
			if (historyCommand != null)
			{
				historyCommand.Name = SR.CommandRotateRight;
				Context.Viewer.CommandHistory.AddCommand(historyCommand);
			}
		}

		public void Apply(IPresentationImage image)
		{
			ISpatialTransform transform = (ISpatialTransform) _operation.GetOriginator(image);
			transform.Rotate(90);
		}
	}
}