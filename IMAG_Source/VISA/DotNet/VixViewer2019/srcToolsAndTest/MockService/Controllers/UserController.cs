using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Text;

namespace MockService.Controllers
{
    public class UserController : ApiController
    {
        /// <summary>
        /// VixClient.GetSecurityToken()
        /// </summary>
        /// <returns>The VIX Security Token</returns>
        [Route("ViewerStudyWebApp/restservices/study/user/token")]
        public HttpResponseMessage GetSecurityToken()
        {
            string xml = "<restStringType><value>0Vofu8t6_R9c6v5wKWGwuN1VEHD1BNdLfnq_W8NDCilOPaKsutVsmnSsbKcqLsHlW_KW53og4fXYMCOKaqokdj0ka-TD78oBVbnXPI4BTf4=</value></restStringType>";
            return new HttpResponseMessage()
            {
                Content = new StringContent(xml, Encoding.UTF8, "application/xml")
            };
        }

        /// <summary>
        /// VixClient.GetUserDetails()
        /// </summary>
        /// <returns></returns>
        //      ViewerImagingWebApp/token/restservices/viewerImaging/getUserInformation/?securityToken=BLAH
        //      ViewerImagingWebApp/token/restservices/viewerImaging/getUserInformation/?securityToken=BLAH&siteId=994&userId=520824910
        [Route("ViewerImagingWebApp/token/restservices/viewerImaging/getUserInformation")]
        public HttpResponseMessage GetUserDetails()
        {
            string xml = "<userInfo>" +
                "<securityKeys>" +
                  "<securityKey>CAPTURE KEYS OFF</securityKey>" +
                  "<securityKey>MAG CAPTURE</securityKey><securityKey>MAG DELETE</securityKey><securityKey>MAG DOD FIX</securityKey>" +
                  "<securityKey>MAG EDIT</securityKey><securityKey>MAG NOTE EFILE</securityKey><securityKey>MAG RAD SETTINGS</securityKey>" +
                  "<securityKey>MAG SYSTEM</securityKey><securityKey>MAG VIEW DOD IMAGES</securityKey><securityKey>MAG VIX ADMIN</securityKey>" +
                  "<securityKey>MAGCAP ADMIN</securityKey><securityKey>MAGCAP CP</securityKey><securityKey>MAGCAP LAB</securityKey>" +
                  "<securityKey>MAGCAP MED C</securityKey><securityKey>MAGCAP MED G</securityKey><securityKey>MAGCAP MED GEN</securityKey>" +
                  "<securityKey>MAGCAP MED H</securityKey><securityKey>MAGCAP MED HI</securityKey><securityKey>MAGCAP MED I</securityKey>" +
                  "<securityKey>MAGCAP MED N</securityKey><securityKey>MAGCAP MED P</securityKey><securityKey>MAGCAP MED PF</securityKey>" +
                  "<securityKey>MAGCAP MED R</securityKey><securityKey>MAGCAP MED Z</securityKey><securityKey>MAGCAP PHOTOID</securityKey>" +
                  "<securityKey>MAGDFIX ALL</securityKey><securityKey>MAGDISP ADMIN</securityKey><securityKey>MAGDISP CLIN</securityKey>" +
                  "<securityKey>MAGJ SYSTEM MANAGER</securityKey><securityKey>MAGJ SYSTEM USER</securityKey><securityKey>MAGCAP MED</securityKey>" +
                  "<securityKey>MAG ROI</securityKey><securityKey>MAG QA REVIEW</securityKey>" +
                "</securityKeys><userInitials>VVT</userInitials><userName>TEST,VIXVIEWER</userName></userInfo>";
            return new HttpResponseMessage()
            {
                Content = new StringContent(xml, Encoding.UTF8, "application/xml")
            };
        }
    }
}
