﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ITSolution.Framework.Common.BaseClasses
{
    public static class Consts
    {
        public const string AssemblyServers = "ITSolution.ServiceFramework.BaseClasses.RegisterServices";
        public const string FrameworkServerClass = "ITSolution.Framework.Server.ITSFrameworkServerController.soap"; // /ITSFrameworkServer
        public const string FrameworkSchedulerClass = "ITSolution.Framework.Server.Scheduler.SchedulerController.soap"; // /ISchedulerControl
        public const string InternalFrameworkSession = "ITSINTERNALSESSION";
        public const string TraceServer = "ITSolution.Framework.BaseClasses.TraceMonitor.soap"; // /ITrace
        public const string ReportServerClass = "ITSolution.Framework.Server.ReportServer.ReportController.soap";


    }
}
