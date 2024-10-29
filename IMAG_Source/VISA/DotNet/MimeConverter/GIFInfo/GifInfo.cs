using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
namespace GifInformation
{
    public class GifInfo
    {
    #region Fields
        private FileInfo fileInfo;
        private IList<Image> frames;
        private Size size;
        private bool animated;
        private bool loop;
        private TimeSpan animationDuration;
    #endregion
        
    #region Properties
    public FileInfo FileInfo
    {
         get
         {
             return this.fileInfo;
         }
    }

    public IList<Image> Frames
    {
        get
        {
            return this.frames;
        }
    }

    public Size Size
    {
        get
        {
            return this.size;
        }
    }

    public bool Animated
    {
        get
        {
            return this.animated;
        }
    }

    public bool Loop
    {
        get
        {
            return this.loop;
        }
    }

    public TimeSpan AnimationDuration
    {
        get
        {
            return this.animationDuration;
        }
    }

    #endregion


    #region Constructors  

    public GifInfo(String filePath)
    {
        if (File.Exists(filePath))
        {
            using (var image = Image.FromFile(filePath))
            {
                this.size = new Size(image.Width, image.Height);

                if (image.RawFormat.Equals(ImageFormat.Gif))
                {
                    this.frames = new List<Image>();
                    this.fileInfo = new FileInfo(filePath);

                    if (ImageAnimator.CanAnimate(image))
                    {
                        //Get frames  
                        var dimension = new FrameDimension(image.FrameDimensionsList[0]);
                        int frameCount = image.GetFrameCount(dimension);

                        int index = 0;
                        int duration = 0;
                        for (int i = 0; i < frameCount; i++)
                        {
                            image.SelectActiveFrame(dimension, i);
                            var frame = image.Clone() as Image;
                            frames.Add(frame);

                            var delay = BitConverter.ToInt32(image.GetPropertyItem(20736).Value, index) * 10;
                            duration += (delay < 100 ? 100 : delay);

                            index += 4;
                        }

                        this.animationDuration = TimeSpan.FromMilliseconds(duration);
                        this.animated = true;
                        this.loop = BitConverter.ToInt16(image.GetPropertyItem(20737).Value, 0) != 1;
                    }
                    else
                    {
                        this.frames.Add(image.Clone() as Image);
                    }

                }
                else
                {
                    throw new FormatException("Not valid GIF image format");
                }
            }

        }
    }  
            #endregion  
        }  
    }  
  
      