using Hydra.Log;
using Hydra.Web.Contracts;

namespace Hydra.Web.Modules
{
    public class StudyModule : BaseModule
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public StudyModule(IHydraParentContext ctx) : base("studies", HydraConfiguration.ApiRoutePrefix)
        {
            //AddGet("/", _ => GetStudies(ctx));
        }

        //Response GetStudies(IHydraParentContext ctx)
        //{
        //    var request = this.Bind<StudyRequest>();
        //    if (request == null)
        //        return BadRequest();

        //    Study study = ctx.GetStudyDetails(request.StudyId, request.StudyInstanceUid, request.GroupUid);
        //    if (study == null)
        //        return NotFound();

        //    return Ok<Study>(study);
        //}
    }
}
