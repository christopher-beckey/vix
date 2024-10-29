//-----------------------------------------------------------------------
// <copyright file="AuthenticationResult.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace ImagingClient.Infrastructure.UserDataSource
{
    using System;
    using System.Linq;
    using ImagingClient.Infrastructure.User.Model;

    /// <summary>
    /// TODO: Provide summary section in the documentation header.
    /// </summary>
    public class AuthenticationResult
    {
        public bool IsSuccessful { get; set; }
        public string Message { get; set; }
        public UserCredentials Credentials { get; set; }
    }
}
