package com.nightmare.speedshare;

import android.annotation.SuppressLint;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.PowerManager;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.NonNull;

import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformPlugin;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    MethodChannel channel;
    PowerManager.WakeLock wakeLock = null;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d("NightmareTAG", "申请wakelock");
        acquireWakeLock();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(0x00000000);
            window.getDecorView().setSystemUiVisibility(PlatformPlugin.DEFAULT_SYSTEM_UI);
        }
        Intent intent = getIntent();
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Thread.sleep(200);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                shareFiles(intent);
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
                    wakeLock.acquire(10 * 60 * 1000L /*10 minutes*/);
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
        shareFiles(intent);
    }

    public void shareFiles(Intent intent) {
        if (intent.getAction() == Intent.ACTION_SEND) {
            Uri data_uri;
            data_uri = intent.getParcelableExtra(Intent.EXTRA_STREAM);
            if (data_uri == null) {
                Log.d("NightmareTAG", "sendFile: no data in intent");
                return;
            }
            runOnUiThread(() -> {
                channel.invokeMethod("send_file", getRealPath(data_uri));
            });
            Log.d("NightmareTAG", data_uri.toString());
        } else if (intent.getAction() == Intent.ACTION_SEND_MULTIPLE) {
            List<Uri> uris = intent.getParcelableArrayListExtra(Intent.EXTRA_STREAM);
            for (int i = 0; i < uris.size(); i++) {
                Log.d("NightmareTAG", i + ":" + uris.get(i).toString());
                int finalI = i;
                runOnUiThread(() -> {
                    channel.invokeMethod("send_file", getRealPath(uris.get(finalI)));
                });
            }
        }
    }

    private String getRealPath(Uri fileUrl) {
        String fileName = null;
        if (fileUrl != null) {
            Log.d("NightmareTAG", fileUrl.getScheme());
            if (fileUrl.getScheme().compareTo("content") == 0) // content://开头的uri
            {
//                Uri uri = Uri.parse(fileUrl.getPath());
                fileName = fileUrl.getPath();
//                Cursor cursor = this.getContentResolver().query(fileUrl, null, null, null, null);
//                if (cursor != null && cursor.moveToFirst()) {
//                    try {
//                        int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
//                        fileName = cursor.getString(column_index); // 取出文件路径
//                    } catch (IllegalArgumentException e) {
//                        e.printStackTrace();
//                    } finally {
//                        cursor.close();
//                    }
//                }
            } else if (fileUrl.getScheme().compareTo("file") == 0) // file:///开头的uri
            {
                fileName = fileUrl.getPath();
            }
        }
        return fileName;
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "send_channel");
    }
}
