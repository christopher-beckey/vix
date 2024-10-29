/*
	Copyright c 2003 by RiskCare Ltd.  All rights reserved.

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions
	are met:
	1. Redistributions of source code must retain the above copyright
	notice, this list of conditions and the following disclaimer.
	2. Redistributions in binary form must reproduce the above copyright
	notice, this list of conditions and the following disclaimer in the
	documentation and/or other materials provided with the distribution.

	THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
	ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
	FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
	OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
	HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
	LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
	OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
	SUCH DAMAGE.
*/


using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

//C# code generated by Asmex
//http://www.jbrowse.com/products/asmex

namespace SvgNet.SvgGdi
{

	/// <summary>
	/// An interface that contains exactly the same methods as the GDI+ Graphics object.  If your drawing routines draw to an <c>IGraphics</c> interface, then you can supply either
	/// a <c>GdiGraphics</c> object to render to the screen, or an <see cref="SvgGraphics"> object to render to an SVG file.
	/// <para>
	/// It's a pity that <c>Graphics</c> is a sealed class.  Otherwise there'd be no need to have this interface or the <see cref="GdiGraphics"/> class; we could simply
	/// derive a class from <c>Graphics</c> to do SVG output.
	/// </para>
	/// </summary>
	public interface IGraphics
	{
		void Flush ();
		void Flush (FlushIntention intention);
		void ResetTransform ();
		void MultiplyTransform (Matrix matrix);
		void MultiplyTransform (Matrix matrix, MatrixOrder order);
		void TranslateTransform (Single dx, Single dy);
		void TranslateTransform (Single dx, Single dy, MatrixOrder order);
		void ScaleTransform (Single sx, Single sy);
		void ScaleTransform (Single sx, Single sy, MatrixOrder order);
		void RotateTransform (Single angle);
		void RotateTransform (Single angle, MatrixOrder order);
		void TransformPoints (CoordinateSpace destSpace, CoordinateSpace srcSpace, PointF[] pts);
		void TransformPoints (CoordinateSpace destSpace, CoordinateSpace srcSpace, Point[] pts);
		System.Drawing.Color GetNearestColor (Color color);
		void DrawLine (Pen pen, Single x1, Single y1, Single x2, Single y2);
		void DrawLine (Pen pen, PointF pt1, PointF pt2);
		void DrawLines (Pen pen, PointF[] points);
		void DrawLine (Pen pen, Int32 x1, Int32 y1, Int32 x2, Int32 y2);
		void DrawLine (Pen pen, Point pt1, Point pt2);
		void DrawLines (Pen pen, Point[] points);
		void DrawArc (Pen pen, Single x, Single y, Single width, Single height, Single startAngle, Single sweepAngle);
		void DrawArc (Pen pen, RectangleF rect, Single startAngle, Single sweepAngle);
		void DrawArc (Pen pen, Int32 x, Int32 y, Int32 width, Int32 height, Int32 startAngle, Int32 sweepAngle);
		void DrawArc (Pen pen, Rectangle rect, Single startAngle, Single sweepAngle);
		void DrawBezier (Pen pen, Single x1, Single y1, Single x2, Single y2, Single x3, Single y3, Single x4, Single y4);
		void DrawBezier (Pen pen, PointF pt1, PointF pt2, PointF pt3, PointF pt4);
		void DrawBeziers (Pen pen, PointF[] points);
		void DrawBezier (Pen pen, Point pt1, Point pt2, Point pt3, Point pt4);
		void DrawBeziers (Pen pen, Point[] points);
		void DrawRectangle (Pen pen, Rectangle rect);
		void DrawRectangle (Pen pen, Single x, Single y, Single width, Single height);
		void DrawRectangles (Pen pen, RectangleF[] rects);
		void DrawRectangle (Pen pen, Int32 x, Int32 y, Int32 width, Int32 height);
		void DrawRectangles (Pen pen, Rectangle[] rects);
		void DrawEllipse (Pen pen, RectangleF rect);
		void DrawEllipse (Pen pen, Single x, Single y, Single width, Single height);
		void DrawEllipse (Pen pen, Rectangle rect);
		void DrawEllipse (Pen pen, Int32 x, Int32 y, Int32 width, Int32 height);
		void DrawPie (Pen pen, RectangleF rect, Single startAngle, Single sweepAngle);
		void DrawPie (Pen pen, Single x, Single y, Single width, Single height, Single startAngle, Single sweepAngle);
		void DrawPie (Pen pen, Rectangle rect, Single startAngle, Single sweepAngle);
		void DrawPie (Pen pen, Int32 x, Int32 y, Int32 width, Int32 height, Int32 startAngle, Int32 sweepAngle);
		void DrawPolygon (Pen pen, PointF[] points);
		void DrawPolygon (Pen pen, Point[] points);
		void DrawPath (Pen pen, GraphicsPath path);
		void DrawCurve (Pen pen, PointF[] points);
		void DrawCurve (Pen pen, PointF[] points, Single tension);
		void DrawCurve (Pen pen, PointF[] points, Int32 offset, Int32 numberOfSegments);
		void DrawCurve (Pen pen, PointF[] points, Int32 offset, Int32 numberOfSegments, Single tension);
		void DrawCurve (Pen pen, Point[] points);
		void DrawCurve (Pen pen, Point[] points, Single tension);
		void DrawCurve (Pen pen, Point[] points, Int32 offset, Int32 numberOfSegments, Single tension);
		void DrawClosedCurve (Pen pen, PointF[] points);
		void DrawClosedCurve (Pen pen, PointF[] points, Single tension, FillMode fillmode);
		void DrawClosedCurve (Pen pen, Point[] points);
		void DrawClosedCurve (Pen pen, Point[] points, Single tension, FillMode fillmode);
		void Clear (Color color);
		void FillRectangle (Brush brush, RectangleF rect);
		void FillRectangle (Brush brush, Single x, Single y, Single width, Single height);
		void FillRectangles (Brush brush, RectangleF[] rects);
		void FillRectangle (Brush brush, Rectangle rect);
		void FillRectangle (Brush brush, Int32 x, Int32 y, Int32 width, Int32 height);
		void FillRectangles (Brush brush, Rectangle[] rects);
		void FillPolygon (Brush brush, PointF[] points);
		void FillPolygon (Brush brush, PointF[] points, FillMode fillMode);
		void FillPolygon (Brush brush, Point[] points);
		void FillPolygon (Brush brush, Point[] points, FillMode fillMode);
		void FillEllipse (Brush brush, RectangleF rect);
		void FillEllipse (Brush brush, Single x, Single y, Single width, Single height);
		void FillEllipse (Brush brush, Rectangle rect);
		void FillEllipse (Brush brush, Int32 x, Int32 y, Int32 width, Int32 height);
		void FillPie (Brush brush, Rectangle rect, Single startAngle, Single sweepAngle);
		void FillPie (Brush brush, Single x, Single y, Single width, Single height, Single startAngle, Single sweepAngle);
		void FillPie (Brush brush, Int32 x, Int32 y, Int32 width, Int32 height, Int32 startAngle, Int32 sweepAngle);
		void FillPath (Brush brush, GraphicsPath path);
		void FillClosedCurve (Brush brush, PointF[] points);
		void FillClosedCurve (Brush brush, PointF[] points, FillMode fillmode);
		void FillClosedCurve (Brush brush, PointF[] points, FillMode fillmode, Single tension);
		void FillClosedCurve (Brush brush, Point[] points);
		void FillClosedCurve (Brush brush, Point[] points, FillMode fillmode);
		void FillClosedCurve (Brush brush, Point[] points, FillMode fillmode, Single tension);
		void FillRegion (Brush brush, Region region);
		void DrawString (String s, Font font, Brush brush, Single x, Single y);
		void DrawString (String s, Font font, Brush brush, PointF point);
		void DrawString (String s, Font font, Brush brush, Single x, Single y, StringFormat format);
		void DrawString (String s, Font font, Brush brush, PointF point, StringFormat format);
		void DrawString (String s, Font font, Brush brush, RectangleF layoutRectangle);
		void DrawString (String s, Font font, Brush brush, RectangleF layoutRectangle, StringFormat format);
		System.Drawing.SizeF MeasureString (String text, Font font, SizeF layoutArea, StringFormat stringFormat, out int charactersFitted, out int linesFilled);
		System.Drawing.SizeF MeasureString (String text, Font font, PointF origin, StringFormat stringFormat);
		System.Drawing.SizeF MeasureString (String text, Font font, SizeF layoutArea);
		System.Drawing.SizeF MeasureString (String text, Font font, SizeF layoutArea, StringFormat stringFormat);
		System.Drawing.SizeF MeasureString (String text, Font font);
		System.Drawing.SizeF MeasureString (String text, Font font, Int32 width);
		System.Drawing.SizeF MeasureString (String text, Font font, Int32 width, StringFormat format);
		System.Drawing.Region[] MeasureCharacterRanges (String text, Font font, RectangleF layoutRect, StringFormat stringFormat);
		void DrawIcon (Icon icon, Int32 x, Int32 y);
		void DrawIcon (Icon icon, Rectangle targetRect);
		void DrawIconUnstretched (Icon icon, Rectangle targetRect);
		void DrawImage (Image image, PointF point);
		void DrawImage (Image image, Single x, Single y);
		void DrawImage (Image image, RectangleF rect);
		void DrawImage (Image image, Single x, Single y, Single width, Single height);
		void DrawImage (Image image, Point point);
		void DrawImage (Image image, Int32 x, Int32 y);
		void DrawImage (Image image, Rectangle rect);
		void DrawImage (Image image, Int32 x, Int32 y, Int32 width, Int32 height);
		void DrawImageUnscaled (Image image, Point point);
		void DrawImageUnscaled (Image image, Int32 x, Int32 y);
		void DrawImageUnscaled (Image image, Rectangle rect);
		void DrawImageUnscaled (Image image, Int32 x, Int32 y, Int32 width, Int32 height);
		void DrawImage (Image image, PointF[] destPoints);
		void DrawImage (Image image, Point[] destPoints);
		void DrawImage (Image image, Single x, Single y, RectangleF srcRect, GraphicsUnit srcUnit);
		void DrawImage (Image image, Int32 x, Int32 y, Rectangle srcRect, GraphicsUnit srcUnit);
		void DrawImage (Image image, RectangleF destRect, RectangleF srcRect, GraphicsUnit srcUnit);
		void DrawImage (Image image, Rectangle destRect, Rectangle srcRect, GraphicsUnit srcUnit);
		void DrawImage (Image image, PointF[] destPoints, RectangleF srcRect, GraphicsUnit srcUnit);
		void DrawImage (Image image, PointF[] destPoints, RectangleF srcRect, GraphicsUnit srcUnit, ImageAttributes imageAttr);
		void DrawImage (Image image, PointF[] destPoints, RectangleF srcRect, GraphicsUnit srcUnit, ImageAttributes imageAttr, Graphics.DrawImageAbort callback);
		//void DrawImage (Image image, PointF[] destPoints, RectangleF srcRect, GraphicsUnit srcUnit, ImageAttributes imageAttr, DrawImageAbort callback, Int32 callbackData);
		void DrawImage (Image image, Point[] destPoints, Rectangle srcRect, GraphicsUnit srcUnit);
		void DrawImage (Image image, Point[] destPoints, Rectangle srcRect, GraphicsUnit srcUnit, ImageAttributes imageAttr);
		//void DrawImage (Image image, Point[] destPoints, Rectangle srcRect, GraphicsUnit srcUnit, ImageAttributes imageAttr, DrawImageAbort callback);
		//void DrawImage (Image image, Point[] destPoints, Rectangle srcRect, GraphicsUnit srcUnit, ImageAttributes imageAttr, DrawImageAbort callback, Int32 callbackData);
		void DrawImage (Image image, Rectangle destRect, Single srcX, Single srcY, Single srcWidth, Single srcHeight, GraphicsUnit srcUnit);
		void DrawImage (Image image, Rectangle destRect, Single srcX, Single srcY, Single srcWidth, Single srcHeight, GraphicsUnit srcUnit, ImageAttributes imageAttrs);
		//void DrawImage (Image image, Rectangle destRect, Single srcX, Single srcY, Single srcWidth, Single srcHeight, GraphicsUnit srcUnit, ImageAttributes imageAttrs, DrawImageAbort callback);
		//void DrawImage (Image image, Rectangle destRect, Single srcX, Single srcY, Single srcWidth, Single srcHeight, GraphicsUnit srcUnit, ImageAttributes imageAttrs, DrawImageAbort callback, IntPtr callbackData);
		void DrawImage (Image image, Rectangle destRect, Int32 srcX, Int32 srcY, Int32 srcWidth, Int32 srcHeight, GraphicsUnit srcUnit);
		void DrawImage (Image image, Rectangle destRect, Int32 srcX, Int32 srcY, Int32 srcWidth, Int32 srcHeight, GraphicsUnit srcUnit, ImageAttributes imageAttr);
		//void DrawImage (Image image, Rectangle destRect, Int32 srcX, Int32 srcY, Int32 srcWidth, Int32 srcHeight, GraphicsUnit srcUnit, ImageAttributes imageAttr, DrawImageAbort callback);
		//void DrawImage (Image image, Rectangle destRect, Int32 srcX, Int32 srcY, Int32 srcWidth, Int32 srcHeight, GraphicsUnit srcUnit, ImageAttributes imageAttrs, DrawImageAbort callback, IntPtr callbackData);
		/*
				void EnumerateMetafile (Metafile metafile, PointF destPoint, EnumerateMetafileProc callback);
				void EnumerateMetafile (Metafile metafile, PointF destPoint, EnumerateMetafileProc callback, IntPtr callbackData);
				void EnumerateMetafile (Metafile metafile, PointF destPoint, EnumerateMetafileProc callback, IntPtr callbackData, ImageAttributes imageAttr);
				void EnumerateMetafile (Metafile metafile, Point destPoint, EnumerateMetafileProc callback);
				void EnumerateMetafile (Metafile metafile, Point destPoint, EnumerateMetafileProc callback, IntPtr callbackData);
				void EnumerateMetafile (Metafile metafile, Point destPoint, EnumerateMetafileProc callback, IntPtr callbackData, ImageAttributes imageAttr);
				void EnumerateMetafile (Metafile metafile, RectangleF destRect, EnumerateMetafileProc callback);
				void EnumerateMetafile (Metafile metafile, RectangleF destRect, EnumerateMetafileProc callback, IntPtr callbackData);
				void EnumerateMetafile (Metafile metafile, RectangleF destRect, EnumerateMetafileProc callback, IntPtr callbackData, ImageAttributes imageAttr);
				void EnumerateMetafile (Metafile metafile, Rectangle destRect, EnumerateMetafileProc callback);
				void EnumerateMetafile (Metafile metafile, Rectangle destRect, EnumerateMetafileProc callback, IntPtr callbackData);
				void EnumerateMetafile (Metafile metafile, Rectangle destRect, EnumerateMetafileProc callback, IntPtr callbackData, ImageAttributes imageAttr);
				void EnumerateMetafile (Metafile metafile, PointF[] destPoints, EnumerateMetafileProc callback);
				void EnumerateMetafile (Metafile metafile, PointF[] destPoints, EnumerateMetafileProc callback, IntPtr callbackData);
				void EnumerateMetafile (Metafile metafile, PointF[] destPoints, EnumerateMetafileProc callback, IntPtr callbackData, ImageAttributes imageAttr);
				void EnumerateMetafile (Metafile metafile, Point[] destPoints, EnumerateMetafileProc callback);
				void EnumerateMetafile (Metafile metafile, Point[] destPoints, EnumerateMetafileProc callback, IntPtr callbackData);
				void EnumerateMetafile (Metafile metafile, Point[] destPoints, EnumerateMetafileProc callback, IntPtr callbackData, ImageAttributes imageAttr);
				void EnumerateMetafile (Metafile metafile, PointF destPoint, RectangleF srcRect, GraphicsUnit srcUnit, EnumerateMetafileProc callback);
				void EnumerateMetafile (Metafile metafile, PointF destPoint, RectangleF srcRect, GraphicsUnit srcUnit, EnumerateMetafileProc callback, IntPtr callbackData);
				void EnumerateMetafile (Metafile metafile, PointF destPoint, RectangleF srcRect, GraphicsUnit unit, EnumerateMetafileProc callback, IntPtr callbackData, ImageAttributes imageAttr);
				void EnumerateMetafile (Metafile metafile, Point destPoint, Rectangle srcRect, GraphicsUnit srcUnit, EnumerateMetafileProc callback);
				void EnumerateMetafile (Metafile metafile, Point destPoint, Rectangle srcRect, GraphicsUnit srcUnit, EnumerateMetafileProc callback, IntPtr callbackData);
				void EnumerateMetafile (Metafile metafile, Point destPoint, Rectangle srcRect, GraphicsUnit unit, EnumerateMetafileProc callback, IntPtr callbackData, ImageAttributes imageAttr);
				void EnumerateMetafile (Metafile metafile, RectangleF destRect, RectangleF srcRect, GraphicsUnit srcUnit, EnumerateMetafileProc callback);
				void EnumerateMetafile (Metafile metafile, RectangleF destRect, RectangleF srcRect, GraphicsUnit srcUnit, EnumerateMetafileProc callback, IntPtr callbackData);
				void EnumerateMetafile (Metafile metafile, RectangleF destRect, RectangleF srcRect, GraphicsUnit unit, EnumerateMetafileProc callback, IntPtr callbackData, ImageAttributes imageAttr);
				void EnumerateMetafile (Metafile metafile, Rectangle destRect, Rectangle srcRect, GraphicsUnit srcUnit, EnumerateMetafileProc callback);
				void EnumerateMetafile (Metafile metafile, Rectangle destRect, Rectangle srcRect, GraphicsUnit srcUnit, EnumerateMetafileProc callback, IntPtr callbackData);
				void EnumerateMetafile (Metafile metafile, Rectangle destRect, Rectangle srcRect, GraphicsUnit unit, EnumerateMetafileProc callback, IntPtr callbackData, ImageAttributes imageAttr);
				void EnumerateMetafile (Metafile metafile, PointF[] destPoints, RectangleF srcRect, GraphicsUnit srcUnit, EnumerateMetafileProc callback);
				void EnumerateMetafile (Metafile metafile, PointF[] destPoints, RectangleF srcRect, GraphicsUnit srcUnit, EnumerateMetafileProc callback, IntPtr callbackData);
				void EnumerateMetafile (Metafile metafile, PointF[] destPoints, RectangleF srcRect, GraphicsUnit unit, EnumerateMetafileProc callback, IntPtr callbackData, ImageAttributes imageAttr);
				void EnumerateMetafile (Metafile metafile, Point[] destPoints, Rectangle srcRect, GraphicsUnit srcUnit, EnumerateMetafileProc callback);
				void EnumerateMetafile (Metafile metafile, Point[] destPoints, Rectangle srcRect, GraphicsUnit srcUnit, EnumerateMetafileProc callback, IntPtr callbackData);
				void EnumerateMetafile (Metafile metafile, Point[] destPoints, Rectangle srcRect, GraphicsUnit unit, EnumerateMetafileProc callback, IntPtr callbackData, ImageAttributes imageAttr);
		*/
		void SetClip (Graphics g);
		void SetClip (Graphics g, CombineMode combineMode);
		void SetClip (Rectangle rect);
		void SetClip (Rectangle rect, CombineMode combineMode);
		void SetClip (RectangleF rect);
		void SetClip (RectangleF rect, CombineMode combineMode);
		void SetClip (GraphicsPath path);
		void SetClip (GraphicsPath path, CombineMode combineMode);
		void SetClip (Region region, CombineMode combineMode);
		void IntersectClip (Rectangle rect);
		void IntersectClip (RectangleF rect);
		void IntersectClip (Region region);
		void ExcludeClip (Rectangle rect);
		void ExcludeClip (Region region);
		void ResetClip ();
		void TranslateClip (Single dx, Single dy);
		void TranslateClip (Int32 dx, Int32 dy);
		System.Boolean IsVisible (Int32 x, Int32 y);
		System.Boolean IsVisible (Point point);
		System.Boolean IsVisible (Single x, Single y);
		System.Boolean IsVisible (PointF point);
		System.Boolean IsVisible (Int32 x, Int32 y, Int32 width, Int32 height);
		System.Boolean IsVisible (Rectangle rect);
		System.Boolean IsVisible (Single x, Single y, Single width, Single height);
		System.Boolean IsVisible (RectangleF rect);
		System.Drawing.Drawing2D.GraphicsState Save ();
		void Restore (GraphicsState gstate);
		System.Drawing.Drawing2D.GraphicsContainer BeginContainer (RectangleF dstrect, RectangleF srcrect, GraphicsUnit unit);
		System.Drawing.Drawing2D.GraphicsContainer BeginContainer ();
		void EndContainer (GraphicsContainer container);
		System.Drawing.Drawing2D.GraphicsContainer BeginContainer (Rectangle dstrect, Rectangle srcrect, GraphicsUnit unit);
		void AddMetafileComment (Byte[] data);
		System.Drawing.Drawing2D.CompositingMode CompositingMode {get; set; }
		System.Drawing.Point RenderingOrigin {get; set; }
		System.Drawing.Drawing2D.CompositingQuality CompositingQuality {get; set; }
		System.Drawing.Text.TextRenderingHint TextRenderingHint {get; set; }
		System.Int32 TextContrast {get; set; }
		System.Drawing.Drawing2D.SmoothingMode SmoothingMode {get; set; }
		System.Drawing.Drawing2D.PixelOffsetMode PixelOffsetMode {get; set; }
		System.Drawing.Drawing2D.InterpolationMode InterpolationMode {get; set; }
		System.Drawing.Drawing2D.Matrix Transform {get; set; }
		System.Drawing.GraphicsUnit PageUnit {get; set; }
		System.Single PageScale {get; set; }
		System.Single DpiX {get; }
		System.Single DpiY {get; }
		System.Drawing.Region Clip {get; set; }
		System.Drawing.RectangleF ClipBounds {get; }
		System.Boolean IsClipEmpty {get; }
		System.Drawing.RectangleF VisibleClipBounds {get; }
		System.Boolean IsVisibleClipEmpty {get; }

	}
}