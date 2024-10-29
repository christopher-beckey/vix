using Nancy.Security;
using System.Collections.Generic;

namespace Hydra.Security
{
    public class UserIdentity : IUserIdentity
    {
        public string UserName { get; set; }
        public IEnumerable<string> Claims { get; set; }
        public Nancy.HttpStatusCode HttpStatusCode { get; set; }
        public string Message { get; set; }
    }
}
