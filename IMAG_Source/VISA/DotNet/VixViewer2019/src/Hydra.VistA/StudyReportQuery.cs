﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class StudyReportQuery : VistAQuery
    {
        public bool IsValid
        {
            get
            {
                return (!string.IsNullOrEmpty(ContextId));
            }
        }

    }
}