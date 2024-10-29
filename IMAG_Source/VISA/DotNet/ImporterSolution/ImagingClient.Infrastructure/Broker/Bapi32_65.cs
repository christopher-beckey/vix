using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace ImagingClient.Infrastructure.Broker
{
    public class Bapi32_65
    {
        [DllImport("Bapi32_65_5.dll")]
        public static extern IntPtr MySsoToken();

        [DllImport("Bapi32_65_5.dll", CharSet = CharSet.None)]
        //[return: MarshalAs(UnmanagedType.LPWStr)]
        public static extern void RpcbCall(IntPtr pRPC, [MarshalAs(UnmanagedType.LPWStr)]StringBuilder s);

        [DllImport("Bapi32_65_5.dll")]
        public static extern bool RpcbCheckCmdLine(IntPtr pRPC);

        [DllImport("Bapi32_65_5.dll")]
        public static extern IntPtr RpcbCreate();

        [DllImport("Bapi32_65_5.dll")]
        public static extern bool RpcbCreateContext(IntPtr pRPC, [MarshalAs(UnmanagedType.LPWStr)]string s);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbDecode([MarshalAs(UnmanagedType.LPWStr)]string s, [MarshalAs(UnmanagedType.LPWStr)]string t);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbEncode([MarshalAs(UnmanagedType.LPWStr)]string s, [MarshalAs(UnmanagedType.LPWStr)]string t);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbFree(IntPtr pRPC);

        [DllImport("Bapi32_65_5.dll", CharSet = CharSet.None)]
        public static extern void RpcbGetServerInfo([MarshalAs(UnmanagedType.LPWStr)]StringBuilder s, [MarshalAs(UnmanagedType.LPWStr)]StringBuilder t, ref int u);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbGetUserInfo(IntPtr pRPC);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbLoginPropGet(IntPtr pRPC, [MarshalAs(UnmanagedType.LPWStr)]string s, [MarshalAs(UnmanagedType.LPWStr)]string t);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbLoginPropSet(IntPtr pRPC, [MarshalAs(UnmanagedType.LPWStr)]string s, [MarshalAs(UnmanagedType.LPWStr)]string t);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbMultItemGet(IntPtr pRPC, int s, [MarshalAs(UnmanagedType.LPWStr)]string t, [MarshalAs(UnmanagedType.LPWStr)]string u);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbMultOrder(IntPtr pRPC, int s, [MarshalAs(UnmanagedType.LPWStr)]string t, int u, [MarshalAs(UnmanagedType.LPWStr)]string v);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbMultPosition(IntPtr pRPC, int s, [MarshalAs(UnmanagedType.LPWStr)]string t, int u);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbMultPropGet(IntPtr pRPC, int s, [MarshalAs(UnmanagedType.LPWStr)]string t, [MarshalAs(UnmanagedType.LPWStr)]string u);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbMultSet(IntPtr pRPC, int s, [MarshalAs(UnmanagedType.LPWStr)]string t, [MarshalAs(UnmanagedType.LPWStr)]string u);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbMultSortedSet(IntPtr pRPC, int s, bool t);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbMultSubscript(IntPtr pRPC, int s, int t, [MarshalAs(UnmanagedType.LPWStr)]string u);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbParamGet(IntPtr pRPC, int s, int t, [MarshalAs(UnmanagedType.LPWStr)]string u);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbParamSet(IntPtr pRPC, int s, int t, [MarshalAs(UnmanagedType.LPWStr)]string u);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbPiece([MarshalAs(UnmanagedType.LPWStr)]string s, [MarshalAs(UnmanagedType.LPWStr)]string t, int u, [MarshalAs(UnmanagedType.LPWStr)]string v);

        [DllImport("Bapi32_65_5.dll", CharSet = CharSet.None)]
        public static extern void RpcbPropGet(IntPtr pRPC, [MarshalAs(UnmanagedType.LPWStr)]string s, [MarshalAs(UnmanagedType.LPWStr)]StringBuilder t);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbPropSet(IntPtr pRPC, [MarshalAs(UnmanagedType.LPWStr)]string s, [MarshalAs(UnmanagedType.LPWStr)]string t);

        [DllImport("Bapi32_65_5.dll")]
        public static extern bool RpcbSilentLogIn(IntPtr pRPC);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbStartProgSLogin([MarshalAs(UnmanagedType.LPWStr)]string s, IntPtr pRPC);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbTranslate([MarshalAs(UnmanagedType.LPWStr)]string s, [MarshalAs(UnmanagedType.LPWStr)]string t, [MarshalAs(UnmanagedType.LPWStr)]string u, [MarshalAs(UnmanagedType.LPWStr)]string v);

        [DllImport("Bapi32_65_5.dll", CharSet = CharSet.None)]
        public static extern void RpcbUserPropGet(IntPtr pRPC, [MarshalAs(UnmanagedType.LPWStr)]string s, [MarshalAs(UnmanagedType.LPWStr)]StringBuilder t);

        [DllImport("Bapi32_65_5.dll")]
        public static extern void RpcbUserPropSet(IntPtr pRPC, [MarshalAs(UnmanagedType.LPWStr)]string s, [MarshalAs(UnmanagedType.LPWStr)]string t);
    }
}