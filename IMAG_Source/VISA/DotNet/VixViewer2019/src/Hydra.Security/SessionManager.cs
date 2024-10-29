using Hydra.Common;
using Hydra.Log;
using Nancy.Security; //VAI-707: For IUserIdentity
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Caching;

namespace Hydra.Security
{
    public class SessionManager
    {
        public class SessionData
        {
            public string BseToken { get; set; }
            public SecurityToken SecurityToken { get; set; }
            public string ClientHostAddress { get; set; }
            public IUserIdentity UserIdentity { get; set; }
        }

        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        private static readonly Lazy<SessionManager> _Instance = new Lazy<SessionManager>(() => new SessionManager());

        private object _SyncLock = new object();

        //This needs the load balancers to use sticky sessions in order for CVIX sessions to work. The key is a sessionId (Guid).
        private Dictionary<string, SessionData> _SessionDataCollection = new Dictionary<string, SessionData>();

        private int _RequestCounter = 0;

        private const int _ExpirationCheckThreshold = 5;

        public static SessionManager Instance
        {
            get
            {
                return SessionManager._Instance.Value;
            }
        }

        public bool IsSessionValid(string securityToken, string clientHostAddress)
        {
            string clientHostAddressNoSuffix = Util.GetHostAddressNoSuffix(clientHostAddress);
            SecurityToken token;
            if (!SecurityToken.TryParse(securityToken, out token))
                return false;

            if (token.IsExpired)
            {
                _Logger.Error("Token expired");
                return false;
            }

            lock (_SyncLock)
            {
                _Logger.Debug("Client host address", "HostAddress", clientHostAddressNoSuffix);

                SessionData sessionData;
                if (_SessionDataCollection.TryGetValue(token.Key, out sessionData))
                {
                    //VAI-851 TODO: Uncomment out this block once we have a central session cache / sticky sessions
                    //VAI-847: For now, comment out this block becaue it is not working for users behind a load balancer without a central session cache / sticky sessions
                    ////When the user already exists in the session cache, make sure he is coming from the same IP address
                    //if (string.Compare(Util.GetHostAddressNoSuffix(sessionData.ClientHostAddress), clientHostAddressNoSuffix, true) != 0)
                    //{
                    //    //Cannot use the same security token from different machines
                    //    //treat ::1 the same as 127.0.0.1
                    //    if (((sessionData.ClientHostAddress == "::1") || (sessionData.ClientHostAddress == "127.0.0.1")) &&
                    //        ((clientHostAddress == "::1") || (clientHostAddress == "127.0.0.1")))
                    //    {
                    //        //no-op
                    //    }
                    //    else
                    //    {
                    //        _Logger.Error("Unauthorized access.", "HostAddress", clientHostAddressNoSuffix, "ClientHostAddress", sessionData.ClientHostAddress);
                    //        return false; // different client
                    //    }
                    //}
                }
                else
                {
                    _SessionDataCollection[token.Key] = new SessionData
                    {
                        ClientHostAddress = clientHostAddressNoSuffix,
                        SecurityToken = token
                    };

                    _RequestCounter++;
                    if (_RequestCounter == _ExpirationCheckThreshold)
                    {
                        // purge expired tokens. 
                        var expiredTokens = _SessionDataCollection.Where(x => x.Value.SecurityToken.IsExpired).ToList();
                        expiredTokens.ForEach(x => _SessionDataCollection.Remove(x.Key));
                        _RequestCounter = 0;

                        _Logger.Info("Expired session data purged.", "ExpiredTokensCount", expiredTokens.Count, "SessionDataCollectionCount", _SessionDataCollection.Count);
                    }
                }
            }
            return true;
        }

        /// <summary>
        /// Get the UserIdentity associated with a VIX Viewer Security Token
        /// </summary>
        /// <param name="vixViewerSecurityToken">The VIX Viewer Security Token</param>
        /// <returns>If a match was found, the user identity. If no match, null.</returns>
        public IUserIdentity GetUserIdentity(string vixViewerSecurityToken)
        {
            if (string.IsNullOrWhiteSpace(vixViewerSecurityToken))
                return null;
            SessionData sessionData = null;
            //VAI-848
            lock (_SyncLock)
            {
                foreach (KeyValuePair<string, SessionData> kvp in _SessionDataCollection)
                {
                    if (kvp.Value.SecurityToken.ToString() == vixViewerSecurityToken)
                    {
                        if (sessionData == null)
                            sessionData = new SessionData(); //VAI-847: instantiate the object
                        sessionData = kvp.Value;
                        break;
                    }
                }
            }
            if (sessionData != null)
                return sessionData.UserIdentity;
            return null;
        }

        /// <summary>
        /// Get the VIX Java Token associated with a VIX Viewer Security Token
        /// </summary>
        /// <param name="vixViewerSecurityToken">The VIX Viewer Security Token</param>
        /// <returns>If a match was found, the VIX Java token. If no match, null.</returns>
        public string GetVixJavaToken(string vixViewerSecurityToken)
        {
            if (string.IsNullOrWhiteSpace(vixViewerSecurityToken))
                return null;

            SessionData sessionData = null;
            //VAI-848
            lock (_SyncLock)
            {
                foreach (KeyValuePair<string, SessionData> kvp in _SessionDataCollection)
                {
                    if (kvp.Value.SecurityToken.ToString() == vixViewerSecurityToken)
                    {
                        sessionData = kvp.Value;
                        break;
                    }
                }
            }
            if (sessionData != null)
                return sessionData.SecurityToken.Data;
            return null;
        }

        /// <summary>
        /// Get the BSE Token associated with a VIX Viewer Security Token
        /// </summary>
        /// <param name="vixViewerSecurityToken">The VIX Viewer Security Token</param>
        /// <returns>If a match was found, the BSE token. If no match, null.</returns>
        public string GetBseToken(string vixViewerSecurityToken)
        {
            if (string.IsNullOrWhiteSpace(vixViewerSecurityToken))
                return null;

            SessionData sessionData = null;
            //VAI-848
            lock (_SyncLock)
            {
                foreach (KeyValuePair<string, SessionData> kvp in _SessionDataCollection)
                {
                    if (kvp.Value.SecurityToken.ToString() == vixViewerSecurityToken)
                    {
                        sessionData = kvp.Value;
                        break;
                    }
                }
            }
            if (sessionData != null)
                return sessionData.BseToken;
            return null;
        }

        /// <summary>
        /// Add a User to the Session "cache"
        /// </summary>
        /// <param name="vixViewerSecurityToken">The VIX Viewer Security Token</param>
        /// <param name="userId">The VistA UserId</param>
        /// <param name="clientIpAddress">The client's IP address (which is not the atual one if since X-Forwarded-For header not being used)</param>
        public void AddUserSession(string vixViewerSecurityToken, string userId, UserIdentity currentUser, string clientIpAddress)
        {
            //The standard .NET way to create Claims is to use List<Claim> and add multiple Claim objects, like the following:
            //    currentUser.Claims = new List<Claim>();
            //    claims.Add(new Claim(ClaimTypes.Role, "User"));
            //NancyFX, however uses Claims as List<string>, and we can't override it.
            //If we want to add more than just the security token in the future, we can use the pipe (|) symbol like key|value and use kvp below
            //KeyValuePair<string, SessionData> kvp = new KeyValuePair<string, SessionData>();
            currentUser.Claims = new List<string>() { vixViewerSecurityToken };
            if (string.IsNullOrWhiteSpace(currentUser.UserName)) currentUser.UserName = userId;
            CacheItemPolicy policy = new CacheItemPolicy { SlidingExpiration = TimeSpan.FromHours(8) }; //P254 was too short: AbsoluteExpiration = DateTimeOffset.Now.AddMinutes(2) };
            _ = SecurityToken.TryParse(vixViewerSecurityToken, out SecurityToken token);
            string errMsg = "";
            //VAI-848: Do not call the .jar to decrypt. Temporarily set the BSE Token to a dummy value since it is unused right now.
            string bseToken = "XUSBSE935-572651_2";
            //string bseToken = "";
            //try
            //{
            //    string vixJavaToken = SecurityUtil.DecryptFromVixJava(token.Data, out errMsg);
            //    //IMAGPROVIDERONETWOSIX,ONETWOSIX||126||843924956||El Paso, TX||756||VISTA IMAGING VIX^XUSBSE416-62998_8^756^9400||||
            //    string[] parts = vixJavaToken.Split(new string[] { "||" }, StringSplitOptions.None);
            //    if (parts.Count() >= 6)
            //    {
            //        bseToken = parts[5];
            //        if (bseToken.Contains("^"))
            //        {
            //            string[] bseParts = bseToken.Split('^');
            //            if (bseParts.Count() >= 2)
            //                bseToken = bseParts[1]; //XUSBSE416-62998_8
            //        }
            //    }
            //}
            //catch (Exception ex)
            //{
            //    errMsg = ex.ToString();
            //}
            if (!string.IsNullOrWhiteSpace(errMsg))
                _Logger.Info("Java decryption failed for AddUserSession.", "Error", errMsg); //session lookup will fail later
            //VAI-848
            lock (_SyncLock)
            {
                _SessionDataCollection[token.Key] = new SessionData
                {
                    ClientHostAddress = clientIpAddress,
                    UserIdentity = currentUser,
                    SecurityToken = token,
                    BseToken = bseToken
                };
            }
        }

        /// <summary>
        /// Replace the VIX Viewer Security Token string in the Session cache
        /// </summary>
        /// <param name="currentToken">The current string</param>
        /// <param name="newToken">The string to replace the current string</param>
        public void ReplaceSecurityToken(string currentToken, SecurityToken newToken)
        {
            SessionData sessionData;
            //VAI-848
            lock (_SyncLock)
            {
                foreach (KeyValuePair<string, SessionData> kvp in _SessionDataCollection)
                {
                    if (kvp.Value.SecurityToken.ToString() == currentToken)
                    {
                        sessionData = kvp.Value;
                        sessionData.SecurityToken = newToken;
                        break;
                    }
                }
            }
        }
    }
}
