using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.wiki
{
    public class VixAdministrator
    {
        public string Name { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }

        public VixAdministrator(string name, string phoneNumber, string email)
        {
            this.Name = name;
            this.PhoneNumber = phoneNumber;
            this.Email = email;
        }

        public override string ToString()
        {
            return Name + " [" + PhoneNumber + "], [" + Email + "]";
        }
    }
}
