// -----------------------------------------------------------------------
// <copyright file="AsyncCompletedEventArgs.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.ComponentModel
{
    using System.ComponentModel;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    /// <typeparam name="TResult">The type of the result.</typeparam>
    public class AsyncCompletedEventArgs<TResult> : AsyncCompletedEventArgs
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="AsyncCompletedEventArgs&lt;TResult&gt;"/> class.
        /// </summary>
        /// <param name="result">The result.</param>
        /// <param name="exception">The exception.</param>
        /// <param name="cancelled">if set to <c>true</c> [cancelled].</param>
        /// <param name="userState">The async user state.</param>
        public AsyncCompletedEventArgs(TResult result, System.Exception exception, bool cancelled, object userState) :
            base(exception, cancelled, userState)
        {
            this.Result = result;
        }

        /// <summary>
        /// Gets the result.
        /// </summary>
        public TResult Result { get; private set; }
    }
}
