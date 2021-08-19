package com.nightmare.speedshare;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    MethodChannel channel;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

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
