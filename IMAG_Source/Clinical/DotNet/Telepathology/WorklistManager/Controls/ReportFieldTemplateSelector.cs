using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Controls;
using System.Windows;
using VistA.Imaging.Telepathology.Worklist.ViewModel;
using VistA.Imaging.Telepathology.Common.Model;

namespace VistA.Imaging.Telepathology.Worklist.Controls
{
    class ReportFieldTemplateSelector : DataTemplateSelector
    {
        public DataTemplate WordProcessingTemplate { get; set; }
        public DataTemplate MultiTextTemplate { get; set; }
        public DataTemplate BooleanTemplate { get; set; }

        public override DataTemplate SelectTemplate(object item, DependencyObject container)
        {
            ReportField repField = item as ReportField;
            if (repField != null)
            {
                // normal report fields
                //if (!repField.IsSR)
                //{
                    // switch templates for different entry type
                    switch (repField.InputType)
                    {
                        case FieldInputType.WordProcessing:
                            return WordProcessingTemplate;
                        case FieldInputType.MultiText:
                            return MultiTextTemplate;
                        case FieldInputType.Boolean:
                            return BooleanTemplate;
                        default:
                            return WordProcessingTemplate;
                    }
                //}
                //else
                //{
                //    return null;
                //}

            }
            else
            {
                return null;
            }
        }
    }
}
