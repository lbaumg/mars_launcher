package com.cloudcatcher.mars_launcher

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.cloud-catchers.launcher/settings"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger!!, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openLauncherSettings") {
                openLauncherSettings()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun openLauncherSettings() {
        val intent = Intent(android.provider.Settings.ACTION_HOME_SETTINGS)
        startActivity(intent)
    }
}
