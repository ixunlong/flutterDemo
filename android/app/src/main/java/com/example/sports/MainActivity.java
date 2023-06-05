package com.example.sportshuachao;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;

import com.alibaba.sdk.android.push.popup.PopupNotifyClick;
import com.alibaba.sdk.android.push.popup.PopupNotifyClickListener;
import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.UMConfigure;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import com.alibaba.sdk.android.push.AndroidPopupActivity;

import java.util.Map;


public class MainActivity extends FlutterActivity {

    MethodChannel flutterMethodChannel;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        (new PopupNotifyClick(new PopupNotifyClickListener() {
            public void onSysNoticeOpened(String title, String summary, Map<String, String> extMap) {
//                Log.d("xxx", "Receive notification, title: " + title + ", content: " + content + ", extraMap: " + extraMap);
            }
        })).onCreate(this, this.getIntent());
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            getWindow().setStatusBarColor(0);
        }
//red646875317dddcc5bad4e4025  qxb6334192c05844627b5581ca4
        UMConfigure.preInit(this,"646875317dddcc5bad4e4025", getChannel(this));
//        getFlutterEngine().getDartExecutor().getBinaryMessenger()

//        flutterMethodChannel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "customFlutterChannel");
//        flutterMethodChannel.invokeMethod("getAppChannel", new MethodChannel.Result(){
//            @Override
//            public void success(@Nullable Object result) {
//                System.out.println("===========" + result);
//                System.out.print("===========" + result);
//                UMConfigure.preInit(getContext(),"6334192c05844627b5581ca4",result.toString());
//            }
//
//            @Override
//            public void error(@NonNull String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
//
//            }
//
//            @Override
//            public void notImplemented() {
//
//            }
//
//        });

//        UMConfigure.preInit(this,"6334192c05844627b5581ca4", "umeng");
        // android.util.Log.i("UMLog", "onCreate@MainActivity");
    }
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine);
//
//    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
       flutterMethodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "qxb_method_channel");
        flutterMethodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {

            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                String method = call.method;
                if (method.equals("getAndroidChannel")) {
                    String channel = getChannel(getApplicationContext());
                    result.success(channel);
                } else {
                    result.notImplemented();
                }
            }
        });
//        flutterMethodChannel.invokeMethod("getAppChannel", new MethodChannel.Result(){
//            @Override
//            public void success(@Nullable Object result) {
//                System.out.println("===========" + result);
//                System.out.print("===========" + result);
//                UMConfigure.preInit(getContext(),"6334192c05844627b5581ca4",result.toString());
//            }
//
//            @Override
//            public void error(@NonNull String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
//
//            }
//
//            @Override
//            public void notImplemented() {
//
//            }
//
//        });
    }
    private String getChannel(Context context) {
        Bundle metaData = null;
        String apiKey = null;
        if (context == null) {
            return null;
        }
        try {
            ApplicationInfo ai = context.getPackageManager()
                    .getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA);
            if (null != ai) {
                metaData = ai.metaData;
            }
            if (null != metaData) {
                apiKey = metaData.getString("channel");
            }
        } catch (PackageManager.NameNotFoundException e) {
        }
        return apiKey;

    }

}
