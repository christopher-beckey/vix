using System.Linq;
using Nancy;
using Nancy.ModelBinding;
using Hydra.VistA;
using Hydra.VistA.Web;

namespace SCIP_Tool
{
    public class PseudoModule : VistAModule
    {
        public PseudoModule(string modulePath) : base(modulePath)
        {
            //StudyQuery request = this.BindRequest<StudyQuery>(true);
            //var bootstrapper = new DefaultNancyBootstrapper();
            //Browser browser = new Browser(bootstrapper, to => to.Accept("application/json"));

            //StudyQuery studyQuery = new StudyQuery();
            //string myPath = "new.xml";
            //XmlSerializer s = new XmlSerializer(typeof(mySettings));

            //StudyQuery studyQuery = new StudyQuery
            //{
            //    FirstName = "TestFirst",
            //    LastName = "TestLast"
            //};
            //string jsonUser = JsonConvert.SerializeObject(newUser);

            //var result = browser.Post("/DB/SQLite/users/create", with =>
            //{
            //    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
            //    with.Header("content-type", "application/json");
            //    with.Body(jsonUser);
            //});
        }

        //from Hydra.VistA.Web\ViewerModule.cs
        public TModel BindRequest<TModel>(bool bodyOnly = false)
        {
            //***********************************TODO-Is this module every used????????*******************************************
            TModel request = bodyOnly ? this.Bind<TModel>(new BindingConfig { BodyOnly = true }) : this.Bind<TModel>();
            if ((request != null) && (request is VistAQuery))
            {
                var vistaQuery = (request as VistAQuery);
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                vistaQuery.VixHeaders = new VixHeaders(this.Request.Headers.ToDictionary(k => k.Key.ToLower(), v => v.Value));
                //REAL: vistaQuery.HostRootUrl = this.ViewerRootUrl;    TODO: Read config file and use REAL one
                vistaQuery.HostRootUrl = "http://localhost:7343/vix/viewer"; //for SCIP_Tool

                if (string.IsNullOrEmpty(vistaQuery.AuthSiteNumber) &&
                    (vistaQuery.VixHeaders.Contains(VixHeaderName.SiteNumber)))
                    vistaQuery.AuthSiteNumber = vistaQuery.VixHeaders.GetValue(VixHeaderName.SiteNumber);

                if (string.IsNullOrEmpty(vistaQuery.VixJavaSecurityToken) && (this.Request.Query != null))
                {
                    dynamic vixJavaSecurityToken;
                    if ((this.Request.Query as Nancy.DynamicDictionary).TryGetValue("VixJavaSecurityToken", out vixJavaSecurityToken))
                    {
                        if (vixJavaSecurityToken.HasValue)
                            vistaQuery.VixJavaSecurityToken = (vixJavaSecurityToken.Value as string);
                    }
                }

                if (string.IsNullOrEmpty(vistaQuery.ApiToken) &&
                    (vistaQuery.VixHeaders.Contains(VixHeaderName.ApiToken)))
                    vistaQuery.ApiToken = vistaQuery.VixHeaders.GetValue(VixHeaderName.ApiToken);
            }

            return request;
        }
    }
}
