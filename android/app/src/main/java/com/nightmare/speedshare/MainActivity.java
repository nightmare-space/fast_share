package com.nightmare.speedshare;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.PowerManager;
import android.util.Log;

import androidx.annotation.NonNull;

import com.nightmare.applib.AppChannel;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    MethodChannel channel;
    PowerManager.WakeLock wakeLock = null;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d("NightmareTAG", "申请wakelock");
        acquireWakeLock();
        new Thread(() -> {
            try {
                AppChannel.startServer(getApplicationContext());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }).start();
    }

    @Override
    protected void onDestroy() {
        releaseWakeLock();
        Log.d("NightmareTAG", "释放wakelock");
        super.onDestroy();
    }

    //获取电源锁，保持该服务在屏幕熄灭时仍然获取CPU时，保持运行
    @SuppressLint("InvalidWakeLockTag")
    private void acquireWakeLock() {
        if (null == wakeLock) {
            PowerManager pm = null;
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                pm = (PowerManager) this.getSystemService(Context.POWER_SERVICE);
                wakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK | PowerManager.ON_AFTER_RELEASE, "PostLocationService");
                if (null != wakeLock) {
                    wakeLock.acquire();
                }
            }

        }
    }

    //释放设备电源锁
    private void releaseWakeLock() {
        if (null != wakeLock) {
            wakeLock.release();
            wakeLock = null;
        }
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        Uri data_uri;
        if (intent == null) {
            Log.d("NightmareTAG", "sendFile: no data to send");
            return;
        }
        data_uri = intent.getParcelableExtra(intent.EXTRA_STREAM);
        if (data_uri == null) {
            Log.d("NightmareTAG", "sendFile: no data in intent");
            return;
        }
        channel.invokeMethod("send_file", data_uri.toString());
        Log.d("NightmareTAG", data_uri.toString());
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "send_channel");
    }
}
