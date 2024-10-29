/*
Project: ImporterSolution
Date Created: 05/17/2022
Site Name:  Field Office (Remote)
Developer:  Gary Pham (oitlonphamg)
Description: P346 - This is UI code for a dialog progress for display of time duration of how long a task has taken to process/complete.

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

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using DicomImporter.ViewModels;

namespace DicomImporter.Views
{
   /// <summary>
   /// Interaction logic for DialogProgress.xaml
   /// </summary>
   public partial class DialogProgress : Window
   {
      public DialogProgress()
      {
         InitializeComponent();
      }

      public DialogProgress(DialogProgressModel viewModel)
      {
         InitializeComponent();
         DataContext = viewModel;
         Loaded += OnLoad;
      }

      private void OnLoad(object sender, RoutedEventArgs e)
      {
         ((DialogProgressModel)DataContext).InitializeVisibility();
      }
   }
   public class ConverterBoolToColumnWidth : IValueConverter
   {
      object IValueConverter.Convert(object value, Type targetType, object parameter, CultureInfo culture)
      {
         bool bVisibility = (bool)value;

         if (bVisibility)
            return new GridLength(1, GridUnitType.Star);

         return new GridLength(0, GridUnitType.Pixel);
      }

      object IValueConverter.ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
      {
         return null;
      }
   }
}
