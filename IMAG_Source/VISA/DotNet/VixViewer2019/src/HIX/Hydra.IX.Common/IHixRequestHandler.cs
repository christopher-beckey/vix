using Nancy;
using System.Collections.Generic;

namespace Hydra.IX.Common
{
    public interface IHixRequestHandler
    {
        //Response GetImagePart(NancyModule module, string imageUid);

        //Response GetImageGroupRecord(NancyModule module, string groupUid);
        //Response CreateImageGroupRecord(NancyModule module);
        //Response GetImageGroupStatus(NancyModule module, string groupUid);
        //Response GetImageGroupData(NancyModule module, string groupUid);

        //Response GetImage(NancyModule module, string imageUid);
        //Response StoreImage(NancyModule module, string imageUid);
        //Response CreateImageRecord(NancyModule module);

        Response ProcessRequest(HixRequest requestType, NancyModule module, dynamic parameters);

        IEnumerable<EventLogItem> GetEventLogItems(int? pageSize, int? pageIndex);
    }
}