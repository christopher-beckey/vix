// -----------------------------------------------------------------------
// <copyright file="DelegateCommandProp.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace ImagingClient.Infrastructure.Prism.Commands
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Linq;
    using System.Linq.Expressions;
    using System.Text;
    using Microsoft.Practices.Prism.Commands;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class DelegateCommandProp : DelegateCommand
    {
        #region Private Fields

        /// <summary>
        /// List of properties that trigger the RaiseCanExecuteChanged method
        /// </summary>
        private HashSet<MemberExpression> propertySubscriptions;

        /// <summary>
        /// The expression to evaluate when CanExecute is called
        /// </summary>
        private Expression<Func<bool>> canExecuteExpression;

        #endregion

        #region Constructor(s)

        /// <summary>
        /// Initializes a new instance of the <see cref="DelegateCommandProp"/> class.
        /// </summary>
        /// <param name="executeMethod">The execute method.</param>
        public DelegateCommandProp(Action executeMethod) :
            base(executeMethod)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="DelegateCommandProp"/> class.
        /// </summary>
        /// <param name="executeMethod">The <see cref="T:System.Action"/> to invoke when <see cref="M:System.Windows.Input.ICommand.Execute(System.Object)"/> is called.</param>
        /// <param name="canExecuteExpression">The <see cref="T:System.Func`1"/> to invoke when <see cref="M:System.Windows.Input.ICommand.CanExecute(System.Object)"/> is called</param>
        public DelegateCommandProp(
            Action executeMethod,
            Expression<Func<bool>> canExecuteExpression) :
            base(executeMethod, canExecuteExpression.Compile())
        {
            this.propertySubscriptions = new HashSet<MemberExpression>();
            this.canExecuteExpression = canExecuteExpression;
            this.EvaluateCanExecuteExpression(this.canExecuteExpression);
        }

        #endregion

        /// <summary>
        /// Receives notifications when a property on the target changes.
        /// </summary>
        /// <param name="sender">The sender of the event notification.</param>
        /// <param name="e">The <see cref="System.ComponentModel.PropertyChangedEventArgs"/> instance containing the event data.</param>
        protected virtual void TargetPropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            if (this.propertySubscriptions.Any(p => p.Member.DeclaringType.Equals(sender.GetType()) && p.Member.Name.Equals(e.PropertyName)))
            {
                this.RaiseCanExecuteChanged();

                // In a deep expression tree, a change at an upper node may require re-evaluation in order to
                // subscribe to the apropriate child nodes and to clean up old subscriptions
                this.EvaluateCanExecuteExpression(this.canExecuteExpression);
            }
        }

        /// <summary>
        /// Evaluates the CanExecute expression tree looking for properties to which to subscribe to change notifications.
        /// </summary>
        /// <param name="canExecuteExpression">The can execute expression.</param>
        private void EvaluateCanExecuteExpression(Expression<Func<bool>> canExecuteExpression)
        {
            PropertyExpressionVisitor visitor = new PropertyExpressionVisitor(canExecuteExpression);
            INotifyPropertyChanged parent;
            this.ClearSubscriptions();
            foreach (MemberExpression propExp in visitor.PropertyExpressions)
            {
                parent = this.GetParent(propExp);
                if (parent != null)
                {
                    parent.PropertyChanged += this.TargetPropertyChanged;
                    this.propertySubscriptions.Add(propExp);
                }
            }
        }

        /// <summary>
        /// Gets the parent of the member expression.
        /// </summary>
        /// <param name="exp">The member exp.</param>
        /// <returns>The parent of the member expression</returns>
        private INotifyPropertyChanged GetParent(MemberExpression exp)
        {
            if (exp.Expression is ConstantExpression)
            {
                return (exp.Expression as ConstantExpression).Value as INotifyPropertyChanged;
            }
            else
            {
                return exp.Expression as INotifyPropertyChanged;
            }
        }

        /// <summary>
        /// Clears the subscriptions.
        /// </summary>
        private void ClearSubscriptions()
        {
            INotifyPropertyChanged parent;
            foreach (MemberExpression subscription in this.propertySubscriptions)
            {
                parent = (subscription.Expression as ConstantExpression).Value as INotifyPropertyChanged;
                parent.PropertyChanged -= this.TargetPropertyChanged;
            }

            this.propertySubscriptions.Clear();
        }
    }
}
