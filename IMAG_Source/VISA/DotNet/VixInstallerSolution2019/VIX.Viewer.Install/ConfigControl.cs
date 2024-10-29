using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;

namespace Vix.Viewer.Install
{
    public partial class ConfigControl : UserControl
    {
        public ConfigControl()
        {
            InitializeComponent();

            ServiceUtil.EventHandleError += ServiceUtil_EventHandleError;
        }

        void ServiceUtil_EventHandleError(string message)
        {
            MessageBox.Show(message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }

        private void ConfigControl_Load(object sender, EventArgs e)
        {
            ConfigManager.Instance.PropertyChanged += Instance_PropertyChanged;
            ConfigManager.Instance.EditConfigurationCommand.CanExecuteChanged += EditConfigurationCommand_CanExecuteChanged;

            this.ViewerPropertyGrid.SelectedObject = ConfigManager.Instance.ViewerProperties;
            this.ViewerPropertyGrid.ExpandAllGridItems();

        }

        void Instance_PropertyChanged(object sender, object e)
        {
            this.InvokeIfRequired((c) =>
                {
                    if (e is ViewerProperties)
                        this.ViewerPropertyGrid.Refresh();
                });
        }

        void EditConfigurationCommand_CanExecuteChanged(object sender, EventArgs e)
        {
            this.ViewerPropertyGrid.Enabled = ConfigManager.Instance.EditConfigurationCommand.CanExecute(null);
        }

        public bool AllowTabbableFields 
        {
            get
            {
                return this.ViewerPropertyGrid.AllowTabbableFields;
            }

            set
            {
                this.ViewerPropertyGrid.AllowTabbableFields = value;
            }
        }

        private void ViewerPropertyGrid_PropertyValueChanged(object s, PropertyValueChangedEventArgs e)
        {
            ConfigManager.Instance.IsDirty = true;
        }
    }
}
