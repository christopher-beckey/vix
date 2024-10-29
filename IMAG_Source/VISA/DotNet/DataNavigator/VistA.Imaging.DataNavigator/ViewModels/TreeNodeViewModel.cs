// -----------------------------------------------------------------------
// <copyright file="TreeNodeViewModel.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.DataNavigator.ViewModels
{
    using System.Collections.ObjectModel;
    using ImagingClient.Infrastructure.Prism.Mvvm;
    using System.Collections.Generic;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class TreeNodeViewModel : ViewModel
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="TreeNodeViewModel"/> class.
        /// </summary>
        public TreeNodeViewModel()
        {
            this.Children = new ObservableCollection<TreeNodeViewModel>();
        }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is selected.
        /// </summary>
        public virtual bool IsSelected { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is expanded.
        /// </summary>
        public virtual bool IsExpanded { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether children are loaded.
        /// </summary>
        public virtual bool AreChildrenLoaded { get; set; }

        /// <summary>
        /// Gets or sets the depth of this node in the tree
        /// </summary>
        public virtual int Depth
        {
            get
            {
                return Parent == null ? 0 : Parent.Depth + 1;
            }
        }

        /// <summary>
        /// Gets or sets the parent.
        /// </summary>
        public virtual TreeNodeViewModel Parent { get; set; }

        public virtual IEnumerable<TreeNodeViewModel> Lineage
        {
            get
            {
                if (this.Parent != null)
                {
                    foreach (TreeNodeViewModel ancestor in this.Parent.Lineage)
                    {
                        yield return ancestor;
                    }
                }

                yield return this;
            }
        }

        /// <summary>
        /// Gets the children.
        /// </summary>
        public virtual ObservableCollection<TreeNodeViewModel> Children { get; private set; }

        /// <summary>
        /// Recursively sets the expansion of this tree node and all of its descendents.
        /// </summary>
        /// <param name="isExpanded">if set to <c>true</c> the current node will be expanded.</param>
        public virtual void SetIsExpandedOnDescendents(bool isExpanded)
        {
            foreach (TreeNodeViewModel child in this.Children)
            {
                child.IsExpanded = isExpanded;
                child.SetIsExpandedOnDescendents(isExpanded);
            }
        }
    }
}
