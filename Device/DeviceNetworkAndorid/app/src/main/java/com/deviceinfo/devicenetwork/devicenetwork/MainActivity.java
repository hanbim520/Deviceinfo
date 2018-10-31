package com.deviceinfo.devicenetwork.devicenetwork;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.TextView;

import com.deviceinfo.devicenetwork.network.IntenetUtil;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Init();
    }

    private  void  Init()
    {
      TextView textView = getWindow().findViewById(R.id.textView);
      textView.setText(IntenetUtil.getNetworkState(this.getBaseContext()) + " ," +IntenetUtil.GetRssi());

    }
}
