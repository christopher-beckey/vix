using System;
namespace Hydra.Log
{
    public interface ILogEventInfo
    {
        LogEventInfo AddFields(params object[] args);
        LogEventInfo AddTag(string tag);
        LogEventInfo AddTags(string[] tags);
        void Log();
    }
}
