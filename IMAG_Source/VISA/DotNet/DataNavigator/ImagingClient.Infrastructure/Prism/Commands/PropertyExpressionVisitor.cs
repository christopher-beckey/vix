// -----------------------------------------------------------------------
// <copyright file="PropertyExpressionVisitor.cs" company="Department of Veterans Affairs">
// Package: MAG - VistA Imaging
//   WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//   Date Created: 11/30/2011
//   Site Name:  Washington OI Field Office, Silver Spring, MD
//   Developer: vhaiswgraver
//   Description: 
//         ;; +--------------------------------------------------------------------+
//         ;; Property of the US Government.
//         ;; No permission to copy or redistribute this software is given.
//         ;; Use of unreleased versions of this software requires the user
//         ;;  to execute a written test agreement with the VistA Imaging
//         ;;  Development Office of the Department of Veterans Affairs,
//         ;;  telephone (301) 734-0100.
//         ;;
//         ;; The Food and Drug Administration classifies this software as
//         ;; a Class II medical device.  As such, it may not be changed
//         ;; in any way.  Modifications to this software may result in an
//         ;; adulterated medical device under 21CFR820, the use of which
//         ;; is considered to be a violation of US Federal Statutes.
//         ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------

namespace ImagingClient.Infrastructure.Prism.Commands
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.Contracts;
    using System.Linq;
    using System.Linq.Expressions;
    using System.Text;

    /// <summary>
    /// Looks for all property member expressions in an expression tree
    /// </summary>
    public class PropertyExpressionVisitor : ExpressionVisitor
    {
        /// <summary>
        /// List of property expressions found in the expression tree
        /// </summary>
        private List<MemberExpression> propertyExpressions;

        /// <summary>
        /// Initializes a new instance of the <see cref="PropertyExpressionVisitor"/> class.
        /// </summary>
        public PropertyExpressionVisitor(Expression expression)
        {
            Contract.Requires(expression != null);
            this.propertyExpressions = new List<MemberExpression>();
            Visit(expression);
        }

        /// <summary>
        /// Gets the property expressions in the expression tree.
        /// </summary>
        public IEnumerable<MemberExpression> PropertyExpressions
        {
            get { return propertyExpressions.ToArray(); }
        }

        /// <summary>
        /// Visits the children of the <see cref="T:System.Linq.Expressions.MemberExpression"/>.
        /// </summary>
        /// <param name="node">The expression to visit.</param>
        /// <returns>
        /// The modified expression, if it or any subexpression was modified; otherwise, returns the original expression.
        /// </returns>
        protected override Expression VisitMember(MemberExpression node)
        {
            if (node.Member.MemberType == System.Reflection.MemberTypes.Property)
            {
                this.propertyExpressions.Add(node);
            }

            return base.VisitMember(node);
        }
    }
}