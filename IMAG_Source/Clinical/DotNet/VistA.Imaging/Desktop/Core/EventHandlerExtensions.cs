// -----------------------------------------------------------------------
// <copyright file="EventHandlerExtensions.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging
{
    using System;

    /// <summary>
    /// Extension methods for the System.EventHandler class
    /// </summary>
    public static class EventHandlerExtensions
    {
        /// <summary>
        /// Safely raises the specified event handler.
        /// </summary>
        /// <typeparam name="TEventArgs">The type of the event args.</typeparam>
        /// <param name="handler">The event handler.</param>
        /// <param name="sender">The sender of the event.</param>
        /// <param name="e">The <see cref="TEventArgs"/> instance containing the event data.</param>
        public static void SafelyRaise<TEventArgs>(this EventHandler<TEventArgs> handler, object sender, TEventArgs e)
            where TEventArgs : EventArgs
        {
            if (handler != null)
            {
                handler(sender, e);
            }
        }
    }
}
