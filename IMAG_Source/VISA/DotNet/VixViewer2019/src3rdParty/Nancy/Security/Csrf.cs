﻿namespace Nancy.Security
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using System.Text;

    using Nancy.Bootstrapper;
    using Nancy.Cookies;
    using Nancy.Cryptography;
    using Nancy.Helpers;

    /// <summary>
    /// Csrf protection methods
    /// </summary>
    public static class Csrf
    {
        private const string CsrfHookName = "CsrfPostHook";
        private const char ValueDelimiter = '#';
        private const char PairDelimiter = '|';

        /// <summary>
        /// Enables Csrf token generation.
        /// </summary>
        /// <remarks>This is disabled by default.</remarks>
        /// <param name="pipelines">The application pipelines.</param>
        /// <param name="cryptographyConfiguration">The cryptography configuration. This is <see langword="null" /> by default.</param>
        public static void Enable(IPipelines pipelines, CryptographyConfiguration cryptographyConfiguration = null)
        {
            cryptographyConfiguration = cryptographyConfiguration ?? CsrfApplicationStartup.CryptographyConfiguration;

            var postHook = new PipelineItem<Action<NancyContext>>(
                CsrfHookName,
                context =>
                {
                    if (context.Response == null || context.Response.Cookies == null || context.Request.Method.Equals("OPTIONS", StringComparison.OrdinalIgnoreCase))
                    {
                        return;
                    }

                    if (context.Items.ContainsKey(CsrfToken.DEFAULT_CSRF_KEY))
                    {
                        context.Response.Cookies.Add(new NancyCookie(
                            CsrfToken.DEFAULT_CSRF_KEY,
                            (string)context.Items[CsrfToken.DEFAULT_CSRF_KEY],
                            true));

                        return;
                    }

                    if (context.Request.Cookies.ContainsKey(CsrfToken.DEFAULT_CSRF_KEY))
                    {
                        var cookieValue = context.Request.Cookies[CsrfToken.DEFAULT_CSRF_KEY];
                        var cookieToken = ParseToCsrfToken(cookieValue);

                        if (CsrfApplicationStartup.TokenValidator.CookieTokenStillValid(cookieToken))
                        {
                            context.Items[CsrfToken.DEFAULT_CSRF_KEY] = cookieValue;
                            return;
                        }
                    }

                    var tokenString = GenerateTokenString(cryptographyConfiguration);

                    context.Items[CsrfToken.DEFAULT_CSRF_KEY] = tokenString;
                    context.Response.Cookies.Add(new NancyCookie(CsrfToken.DEFAULT_CSRF_KEY, tokenString, true));
                });

            pipelines.AfterRequest.AddItemToEndOfPipeline(postHook);
        }

        /// <summary>
        /// Disable csrf token generation
        /// </summary>
        /// <param name="pipelines">Application pipelines</param>
        public static void Disable(IPipelines pipelines)
        {
            pipelines.AfterRequest.RemoveByName(CsrfHookName);
        }

        /// <summary>
        /// Creates a new csrf token for this response with an optional salt.
        /// Only necessary if a particular route requires a new token for each request.
        /// </summary>
        /// <param name="module">Nancy module</param>
        /// <param name="cryptographyConfiguration">The cryptography configuration. This is <c>null</c> by default.</param>
        public static void CreateNewCsrfToken(this INancyModule module, CryptographyConfiguration cryptographyConfiguration = null)
        {
            var tokenString = GenerateTokenString(cryptographyConfiguration);
            module.Context.Items[CsrfToken.DEFAULT_CSRF_KEY] = tokenString;
        }

        /// <summary>
        /// Creates a new csrf token with an optional salt.
        /// Does not store the token in context.
        /// </summary>
        /// <returns>The generated token</returns>
        internal static string GenerateTokenString(CryptographyConfiguration cryptographyConfiguration = null)
        {
            cryptographyConfiguration = cryptographyConfiguration ?? CsrfApplicationStartup.CryptographyConfiguration;
            var token = new CsrfToken
            {
                CreatedDate = DateTimeOffset.Now
            };

            token.CreateRandomBytes();
            token.CreateHmac(cryptographyConfiguration.HmacProvider);

            var builder = new StringBuilder();

            builder.AppendFormat("RandomBytes{0}{1}", ValueDelimiter, Convert.ToBase64String(token.RandomBytes));
            builder.Append(PairDelimiter);
            builder.AppendFormat("Hmac{0}{1}", ValueDelimiter, Convert.ToBase64String(token.Hmac));
            builder.Append(PairDelimiter);
            builder.AppendFormat("CreatedDate{0}{1}", ValueDelimiter, token.CreatedDate.ToString("o", CultureInfo.InvariantCulture));

            return builder.ToString();
        }

        /// <summary>
        /// Validate that the incoming request has valid CSRF tokens.
        /// Throws <see cref="CsrfValidationException"/> if validation fails.
        /// </summary>
        /// <param name="module">Module object</param>
        /// <param name="validityPeriod">Optional validity period before it times out</param>
        /// <exception cref="CsrfValidationException">If validation fails</exception>
        public static void ValidateCsrfToken(this INancyModule module, TimeSpan? validityPeriod = null)
        {
            var request = module.Request;

            if (request == null)
            {
                return;
            }

            var cookieToken = GetCookieToken(request);
            var providedToken = GetProvidedToken(request);

            var result = CsrfApplicationStartup.TokenValidator.Validate(cookieToken, providedToken, validityPeriod);

            if (result != CsrfTokenValidationResult.Ok)
            {
                throw new CsrfValidationException(result);
            }
        }

        private static CsrfToken GetProvidedToken(Request request)
        {
            CsrfToken providedToken = null;

            var providedTokenString = request.Form[CsrfToken.DEFAULT_CSRF_KEY].Value ?? request.Headers[CsrfToken.DEFAULT_CSRF_KEY].FirstOrDefault();
            if (providedTokenString != null)
            {
                providedToken = ParseToCsrfToken(providedTokenString);
            }

            return providedToken;
        }

        private static CsrfToken GetCookieToken(Request request)
        {
            CsrfToken cookieToken = null;

            string cookieTokenString;
            if (request.Cookies.TryGetValue(CsrfToken.DEFAULT_CSRF_KEY, out cookieTokenString))
            {
                cookieToken = ParseToCsrfToken(cookieTokenString);
            }

            return cookieToken;
        }

        private static void AddTokenValue(Dictionary<string, string> dictionary, string key, string value)
        {
            if (!string.IsNullOrEmpty(key))
            {
                dictionary.Add(key, value);
            }
        }

        private static CsrfToken ParseToCsrfToken(string cookieTokenString)
        {
            var parsed = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

            var currentKey = string.Empty;
            var buffer = new StringBuilder();

            for (var index = 0; index < cookieTokenString.Length; index++)
            {
                var currentCharacter = cookieTokenString[index];

                switch (currentCharacter)
                {
                    case ValueDelimiter:
                        currentKey = buffer.ToString();
                        buffer.Clear();
                        break;
                    case PairDelimiter:
                        AddTokenValue(parsed, currentKey, buffer.ToString());
                        buffer.Clear();
                        break;
                    default:
                        buffer.Append(currentCharacter);
                        break;
                }
            }

            AddTokenValue(parsed, currentKey, buffer.ToString());

            if (parsed.Keys.Count() != 3)
            {
                return null;
            }

            try
            {
                return new CsrfToken
                {
                    CreatedDate = DateTimeOffset.ParseExact(parsed["CreatedDate"], "o", CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal),
                    Hmac = Convert.FromBase64String(parsed["Hmac"]),
                    RandomBytes = Convert.FromBase64String(parsed["RandomBytes"])
                };
            }
            catch
            {
                return null;
            }
        }
    }
}