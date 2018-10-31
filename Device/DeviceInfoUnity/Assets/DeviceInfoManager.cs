using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public sealed class DeviceInfoManager
{
    private DeviceInfoManager()
    {
    }

    public static DeviceInfoManager Instance { get { return Nested.instance; } }

    private class Nested
    {
        // Explicit static constructor to tell C# compiler
        // not to mark type as beforefieldinit
        static Nested()
        {
        }

        internal static readonly DeviceInfoManager instance = new DeviceInfoManager();
    }
    public float GetBattery()
    {
        return SystemInfo.batteryLevel;
    }
#if UNITY_IOS && !UNITY_EDITOR
    [DllImport("__Internal")]
    private static extern void Init();
    [DllImport("__Internal")]
    private static extern string GetIOSNetworkType();
    [DllImport("__Internal")]
    private static extern int GetIOSNetworkStrength();

    public void Initialized()
    {
        Init();
    }
    public string GetNetworkType()
    {
    return GetIOSNetworkType();
    }
    public int GetNetworkRssi()
    {
        return GetIOSNetworkStrength();
    }

#elif UNITY_ANDROID && !UNITY_EDITOR

    private AndroidJavaClass unityjc = null;
    private AndroidJavaObject context = null;
    private AndroidJavaClass jcNetwork = null;
    public void Initialized()
    {

        unityjc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
        context = unityjc.GetStatic<AndroidJavaObject>("currentActivity");
        jcNetwork = new AndroidJavaClass("com.deviceinfo.devicenetwork.network.IntenetUtil");

    }
    /*
  public static final int NETWORN_NONE = 0;
  public static final int NETWORN_WIFI = 1;
  public static final int NETWORN_2G = 2;
  public static final int NETWORN_3G = 3;
  public static final int NETWORN_4G = 4;
  public static final int NETWORN_MOBILE = 5;
     */

    public string GetNetworkType()
    {
        switch (GetAndroidNetworkType())
        {
            case 0:
                return "Unreachable";
            case 1:
                return "wifi";
            case 2:
                return "2G";
            case 3:
                return "3G";
            case 4:
                return "4G";
            case 5:
                return "5G";
        }
        return "Unreachable";
    }
    private int GetAndroidNetworkType()
    {
        if (jcNetwork == null)
        {
            Initialized();
        }
        if (jcNetwork == null)
        {
            Debug.LogError("网络SDK初始化失败，请检查jar");
            return 0;
        }
        int networkType = jcNetwork.CallStatic<int>("getNetworkState", context);
        return networkType;
    }

    public int GetNetworkRssi()
    {
        if (jcNetwork == null)
        {
            Initialized();
        }
        if (jcNetwork == null)
        {
            Debug.LogError("网络SDK初始化失败，请检查jar");
            return 0;
        }
        int networkStrength = jcNetwork.CallStatic<int>("GetRssi");
        return networkStrength;
    }
#else
    public int GetNetworkRssi()
    {
        return 0;
    }
    public void Initialized()
    {

    }
    public string GetNetworkType()
    {
        return "lan";
    }
#endif

}
