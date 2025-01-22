package com.nightmare.speedshare;

import android.annotation.SuppressLint;
import android.content.ClipboardManager;
import android.content.ClipData;
import android.content.Context;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.ParcelFileDescriptor;
import android.os.PowerManager;
import android.util.Log;
import android.view.DragEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import androidx.annotation.NonNull;
import androidx.core.view.WindowCompat;
import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.FileChannel;
import java.util.List;
import java.util.Objects;
import io.flutter.embedding.android.FlutterSurfaceView;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformPlugin;

public class MainActivity extends qiuxiang.android_window.AndroidWindowActivity {
    MethodChannel channel;
    PowerManager.WakeLock wakeLock = null;
    static String TAG = "Nightmare";

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d(TAG, "申请wakelock");
        FlutterEngine engine = new FlutterEngine(this);
// Aligns the Flutter view vertically with the window.
        WindowCompat.setDecorFitsSystemWindows(getWindow(), false);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Disable the Android splash screen fade out animation to avoid
            // a flicker before the similar frame is drawn in Flutter.
//            getSplashScreen().setOnExitAnimationListener(SplashScreenView::remove);
        }

//        FlutterLoader flutterLoader = FlutterInjector.instance().flutterLoader();
////        DartExecutor.DartEntrypoint.createDefault()
//        engine.getDartExecutor().executeDartEntrypoint(
//                new DartExecutor.DartEntrypoint(flutterLoader.findAppBundlePath(), "constIsland")
//        );
//        FlutterEngineCache
//                .getInstance()
//                .put("my_engine_id", engine);
        acquireWakeLock();
        // 下面代码会防止应用打开的时候，状态栏会先是灰色，再是透明的情况
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(0x00000000);
            window.getDecorView().setSystemUiVisibility(PlatformPlugin.DEFAULT_SYSTEM_UI);
        }
        Intent intent = getIntent();
        // 下面代码是处理app冷启动的时候处理文件分享
        // 延时200ms是为了等Flutter注册好method channel回调
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
                // 判断剪切板内容不为空
                if (manager.hasPrimaryClip() && manager.getPrimaryClip().getItemCount() > 0) {
                    CharSequence addedText = manager.getPrimaryClip().getItemAt(0).getText();
                    if (addedText != null) {
                        runOnUiThread(() -> {
                            channel.invokeMethod("clip_changed", addedText);
                        });
                        Log.d(TAG, "copied text: " + addedText);
                    }
                }
            }
        });

        WindowManager.LayoutParams params = new WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE |
                        WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
                PixelFormat.TRANSLUCENT);
        params.width=200;
        params.height=200;
        WindowManager windowManager = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
//        View floatingView = new LinearLayout(this);
//        floatingView.setOnDragListener(new View.OnDragListener() {
//            @Override
//            public boolean onDrag(View v, DragEvent event) {
//                switch (event.getAction()) {
//                    case DragEvent.ACTION_DROP:
//                        Log.d(TAG, "onDrag: " + event.getClipData().getItemCount());
//                        // 处理拖拽事件
//                        ClipData clipData = event.getClipData();
//                        if (clipData != null && clipData.getItemCount() > 0) {
//                            Uri uri = clipData.getItemAt(0).getUri();
//                            // 处理文件
//                        }
//                        return true;
//                    default:
//                        return false;
//                }
//            }
//        });
//        floatingView.setBackgroundColor(0x55ff0000);
//        // 添加悬浮窗
//        windowManager.addView(floatingView, params);

    }


    @Override
    public void onFlutterSurfaceViewCreated(@NonNull FlutterSurfaceView flutterSurfaceView) {
        super.onFlutterSurfaceViewCreated(flutterSurfaceView);
        flutterSurfaceView.setOnDragListener(new View.OnDragListener() {
            @Override
            public boolean onDrag(View v, DragEvent event) {
                switch (event.getAction()) {
                    case DragEvent.ACTION_DROP:
                        Log.d(TAG, "onDrag: " + event.getClipData().getItemCount());
                        // 处理拖拽事件
                        ClipData clipData = event.getClipData();
                        if (clipData != null && clipData.getItemCount() > 0) {
                            Uri uri = clipData.getItemAt(0).getUri();
                            // 处理文件
                        }
                        return true;
                    default:
                        return false;
                }
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
        super.configureFlutterEngine(flutterEngine);
//        flutterEngine.en
        channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "send_channel");
        channel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                if (Objects.equals(call.method, "island")) {
                    Intent intent = new Intent(MainActivity.this, ConstIsland.class);
                    startActivity(intent);
                }
            }
        });
    }
}
