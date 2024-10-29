using Hydra.IX.Database.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Core
{
    internal class TagUtil
    {
        internal static Tag AddOrGetTag(IHixDbContext ctx, string tagName)
        {
            var tag = ctx.Tags.FirstOrDefault(x => (x.Name == tagName));
            if (tag == null)
            {
                tag = new Tag { Name = tagName };
                ctx.Tags.Add(tag);
                ctx.SaveChanges();
            }

            return tag;
        }

        internal static void AssociateTag(IHixDbContext ctx, ITaggable taggableObject, Tag tag)
        {
            var tagMap = ctx.TagMap.FirstOrDefault(x => ((x.RefUid == taggableObject.RefUid) && (x.TagId == tag.Id)));
            if (tagMap == null)
            {
                tagMap = new TagMap { RefUid = taggableObject.RefUid, TagId = tag.Id };
                ctx.TagMap.Add(tagMap);

                taggableObject.IsTagged = true;

                if (ctx.Entry(taggableObject).State == System.Data.Entity.EntityState.Unchanged)
                    ctx.Entry(taggableObject).State = System.Data.Entity.EntityState.Modified;
            }
        }

        internal static void DissociateTag(IHixDbContext ctx, ITaggable taggableObject, Tag tag)
        {
            var tagMap = ctx.TagMap.FirstOrDefault(x => ((x.RefUid == taggableObject.RefUid) && (x.TagId == tag.Id)));
            if (tagMap != null)
            {
                ctx.TagMap.Remove(tagMap);

                // check if other tags exist
                if (ctx.TagMap.Any(x => ((x.RefUid == taggableObject.RefUid) && (x.TagId != tag.Id))))
                {
                    taggableObject.IsTagged = false;

                    if (ctx.Entry(taggableObject).State == System.Data.Entity.EntityState.Unchanged)
                        ctx.Entry(taggableObject).State = System.Data.Entity.EntityState.Modified;
                }
            }
        }

        internal static List<string> GetTags(IHixDbContext ctx, ITaggable taggableObject)
        {
            if (taggableObject.IsTagged ?? false)
            {
                var items = ctx.TagMap.Where(x => x.RefUid == taggableObject.RefUid).ToList();
                if (items != null)
                {
                    var tags = new List<string>();

                    foreach (var item in items)
                    {
                        StringBuilder sb = new StringBuilder();
                        var tag = ctx.Tags.FirstOrDefault(x => x.Id == item.TagId);
                        if (tag != null)
                        {
                            tags.Add(tag.Name);
                        }
                    }

                    return tags;
                }
            }

            return null;
        }
    }
}
