using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Test : MonoBehaviour
{
    public Text textDeviceNetwork;
    public Text textDeviceBattery;
    // Use this for initialization
    void Start()
    {
        DeviceInfoManager.Instance.Initialized();

    }

    // Update is called once per frame
    void Update()
    {
        textDeviceNetwork.text = DeviceInfoManager.Instance.GetNetworkType() + "," + DeviceInfoManager.Instance.GetNetworkRssi();
        textDeviceBattery.text = DeviceInfoManager.Instance.GetBattery().ToString();

    }
}
