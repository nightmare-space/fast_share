package com.nightmare.speedshare;

import android.annotation.SuppressLint;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.ParcelFileDescriptor;
import android.os.PowerManager;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.NonNull;

import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.channels.FileChannel;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformPlugin;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    MethodChannel channel;
    PowerManager.WakeLock wakeLock = null;
    static String TAG = "Nightmare";

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d(TAG, "申请wakelock");
        acquireWakeLock();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(0x00000000);
            window.getDecorView().setSystemUiVisibility(PlatformPlugin.DEFAULT_SYSTEM_UI);
        }
        Intent intent = getIntent();
        // 看不懂了
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
        final ClipboardManager manager = (ClipboardManager) getSystemService(CLIPBOARD_SERVICE);

        manager.addPrimaryClipChangedListener(new ClipboardManager.OnPrimaryClipChangedListener() {

            @Override

            public void onPrimaryClipChanged() {
                runOnUiThread(() -> {
                    channel.invokeMethod("clip_changed",null);
                });
//                if (manager.hasPrimaryClip() && manager.getPrimaryClip().getItemCount() > 0) {
//
//                    CharSequence addedText = manager.getPrimaryClip().getItemAt(0).getText();
//
//                    if (addedText != null) {
//
//                        Log.d(TAG, "copied text: " + addedData);
//
//                    }
//
//                }});
            }
        });

    }

    @Override
    protected void onDestroy() {
        releaseWakeLock();
        Log.d(TAG, "释放wakelock");
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


    /*
     *
     * */
    private static void copyFileUsingFileChannels(FileInputStream fileInputStream, File dest) throws
            IOException {
        FileChannel inputChannel = null;
        FileChannel outputChannel = null;
        try {
            inputChannel = fileInputStream.getChannel();
            outputChannel = new FileOutputStream(dest).getChannel();
            outputChannel.transferFrom(inputChannel, 0, inputChannel.size());
        } finally {
            inputChannel.close();
            outputChannel.close();
        }
    }

    private static void copyFileUsingFileStreams(FileInputStream fileInputStream, File dest)
            throws IOException {
        InputStream input = null;
        OutputStream output = null;
        try {
            input = fileInputStream;
            output = new FileOutputStream(dest);
            byte[] buf = new byte[1024];
            int bytesRead;
            while ((bytesRead = input.read(buf)) > 0) {
                output.write(buf, 0, bytesRead);
            }
        } finally {
            input.close();
            output.close();
        }
    }

    public void shareFiles(Intent intent) {
        if (intent.getAction() == Intent.ACTION_SEND) {
            Uri data_uri;
            data_uri = intent.getParcelableExtra(Intent.EXTRA_STREAM);
            if (data_uri == null) {
                Log.d(TAG, "sendFile: no data in intent");
                return;
            }
            Log.d(TAG, data_uri.toString());
            try {
                // 从分享的uri中构造文件描述符
                ParcelFileDescriptor inputPFD = getContentResolver().openFileDescriptor(data_uri, "r");
                FileDescriptor fd = inputPFD.getFileDescriptor();
                // 获得文件路径，这个路径不能直接拿来读，只是为了计算出文件名
                String filePath = data_uri.getPath();
                String fileName = filePath.substring(filePath.lastIndexOf('/') + 1, filePath.length());
                Log.i(TAG, fileName);
                // 需要生成的文件
                String targetPath = getCacheDir().getPath() + "/" + fileName;
                File file = new File(targetPath);
                FileInputStream fileInputStream = new FileInputStream(fd);
                // 进行复制
                copyFileUsingFileChannels(fileInputStream, file);
//                copyFileUsingFileStreams(fileInputStream, file);
                Log.e(TAG, this.getCacheDir().getPath());
                runOnUiThread(() -> {
                    channel.invokeMethod("send_file", targetPath);
                });
//                byte[] b = new byte[10];
//                Log.e("MainActivity", "File success read" + fileInputStream.read(b));
            } catch (FileNotFoundException e) {
                e.printStackTrace();
                Log.e("MainActivity", "File not found.");
                return;
            } catch (IOException e) {
                e.printStackTrace();
            }
            Log.d(TAG, data_uri.toString());
        } else if (intent.getAction() == Intent.ACTION_SEND_MULTIPLE) {
            List<Uri> uris = intent.getParcelableArrayListExtra(Intent.EXTRA_STREAM);
            for (int i = 0; i < uris.size(); i++) {
                Log.d(TAG, i + ":" + uris.get(i).toString());
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
            Log.d(TAG, fileUrl.getScheme());
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
