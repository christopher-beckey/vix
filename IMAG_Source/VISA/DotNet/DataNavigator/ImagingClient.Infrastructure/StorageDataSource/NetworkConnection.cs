/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
 * Description: 
 *
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *
 */


using System;
using System.IO;
using System.Net;
using System.Runtime.InteropServices;
using System.Threading;
using log4net;

public class NetworkConnection : IDisposable
{
    private string _networkName;
    private const int MaxAttempts = 5;
    private const int SleepDurationMillis = 500;
    private static ILog Logger = LogManager.GetLogger(typeof(NetworkConnection));

    public static NetworkConnection GetNetworkConnection(string networkName, NetworkCredential credentials)
    {
        NetworkConnection conn = null;
        int attemptCount = 1;

        while (true)
        {
            try
            {
                Logger.Debug("Attempting to connect to " + networkName);
                conn = new NetworkConnection(networkName, credentials);
                return conn;
            }
            catch (Exception)
            {
                if (attemptCount <= MaxAttempts)
                {
                    // Increment the attempt count and sleep for a short period
                    attemptCount++;
                    Thread.Sleep(SleepDurationMillis);
                }
                else
                {
                    // We're unable to connect, but it may be because we're already connected,
                    // so don't throw an error.
                    Logger.Error("Unable to connect to " + networkName);
                    return conn;
                }
            }
        }
    }

    private NetworkConnection(string networkName, NetworkCredential credentials)
    {
        _networkName = networkName;

        if (_networkName.EndsWith("\\"))
        {
            _networkName = _networkName.Substring(0, _networkName.Length - 1);
        }

        var netResource = new NetResource()
        {
            Scope = ResourceScope.GlobalNetwork,
            ResourceType = ResourceType.Disk,
            DisplayType = ResourceDisplaytype.Share,
            RemoteName = _networkName
        };

        var result = WNetAddConnection2(
            netResource,
            credentials.Password,
            credentials.UserName,
            0);

        if (result != 0)
        {
            throw new IOException("Error connecting to remote share",
                result);
        }
    }

    ~NetworkConnection()
    {
        Dispose(false);
    }

    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    protected virtual void Dispose(bool disposing)
    {
        WNetCancelConnection2(_networkName, 0, true);
    }

    [DllImport("mpr.dll")]
    private static extern int WNetAddConnection2(NetResource netResource,
        string password, string username, int flags);

    [DllImport("mpr.dll")]
    private static extern int WNetCancelConnection2(string name, int flags,
        bool force);
}

[StructLayout(LayoutKind.Sequential)]
public class NetResource
{
    public ResourceScope Scope;
    public ResourceType ResourceType;
    public ResourceDisplaytype DisplayType;
    public int Usage;
    public string LocalName;
    public string RemoteName;
    public string Comment;
    public string Provider;
}

public enum ResourceScope : int
{
    Connected = 1,
    GlobalNetwork,
    Remembered,
    Recent,
    Context
};

public enum ResourceType : int
{
    Any = 0,
    Disk = 1,
    Print = 2,
    Reserved = 8,
}

public enum ResourceDisplaytype : int
{
    Generic = 0x0,
    Domain = 0x01,
    Server = 0x02,
    Share = 0x03,
    File = 0x04,
    Group = 0x05,
    Network = 0x06,
    Root = 0x07,
    Shareadmin = 0x08,
    Directory = 0x09,
    Tree = 0x0a,
    Ndscontainer = 0x0b
}