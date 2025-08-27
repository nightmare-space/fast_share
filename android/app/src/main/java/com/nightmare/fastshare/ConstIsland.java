package com.nightmare.fastshare;


import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Objects;

import io.flutter.FlutterInjector;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterActivityLaunchConfigs;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class ConstIsland extends FlutterActivity {
    //    @NonNull
//    @Override
//    public String getDartEntrypointFunctionName() {
//        return "constIsland";
//    }
    @Nullable
    @Override
    public FlutterEngine provideFlutterEngine(@NonNull Context context) {
        FlutterEngine engine = new FlutterEngine(this);
        FlutterLoader flutterLoader = FlutterInjector.instance().flutterLoader();
//        DartExecutor.DartEntrypoint.createDefault()
        engine.getDartExecutor().executeDartEntrypoint(
                new DartExecutor.DartEntrypoint(flutterLoader.findAppBundlePath(), "constIsland")
        );
        return engine;
//        return FlutterEngineCache
//                .getInstance()
//                .get("my_engine_id");
    }

    @Override
    protected FlutterActivityLaunchConfigs.BackgroundMode getBackgroundMode() {
        return FlutterActivityLaunchConfigs.BackgroundMode.transparent;
    }

    @Override
    public boolean shouldDestroyEngineWithHost() {
        return false;
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}
