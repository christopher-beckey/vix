// <copyright file="UnityContainerFactory.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>

using System;
using Microsoft.Pex.Framework;
using Microsoft.Practices.Unity;

namespace Microsoft.Practices.Unity
{
    /// <summary>A factory for Microsoft.Practices.Unity.UnityContainer instances</summary>
    public static partial class UnityContainerFactory
    {
        /// <summary>A factory for Microsoft.Practices.Unity.UnityContainer instances</summary>
        [PexFactoryMethod(typeof(UnityContainer))]
        public static UnityContainer Create(object o_o)
        {
            UnityContainer unityContainer = new UnityContainer();
            unityContainer.BuildUp(o_o);
            return unityContainer;

            // TODO: Edit factory method of UnityContainer
            // This method should be able to configure the object in all possible ways.
            // Add as many parameters as needed,
            // and assign their values to each field by using the API.
        }
    }
}
