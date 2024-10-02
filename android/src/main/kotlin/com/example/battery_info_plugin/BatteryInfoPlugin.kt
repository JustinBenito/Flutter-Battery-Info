package com.example.battery_info_plugin

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class BatteryInfoPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "battery_info_plugin")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getBatteryInfo" -> {
        val batteryInfo = getBatteryInfo()
        Log.d("BatteryInfoPlugin", "Battery Info: $batteryInfo")
        result.success(batteryInfo)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun getBatteryInfo(): Map<String, Any> {
    val batteryStatus: Intent? = IntentFilter(Intent.ACTION_BATTERY_CHANGED).let { ifilter ->
      context.registerReceiver(null, ifilter)
    }

    val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager

    val status: Int = batteryStatus?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
    val isCharging: Boolean = status == BatteryManager.BATTERY_STATUS_CHARGING
            || status == BatteryManager.BATTERY_STATUS_FULL

    val batteryPct: Float = batteryStatus?.let { intent ->
      val level: Int = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
      val scale: Int = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
      level * 100 / scale.toFloat()
    } ?: -1f

    // Get battery current
    val batteryCurrent = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW)

    return mapOf(
      "batteryLevel" to batteryPct.toInt(),
      "isCharging" to isCharging,
      "chargingStatus" to when (status) {
        BatteryManager.BATTERY_STATUS_CHARGING -> "Charging"
        BatteryManager.BATTERY_STATUS_DISCHARGING -> "Discharging"
        BatteryManager.BATTERY_STATUS_FULL -> "Full"
        BatteryManager.BATTERY_STATUS_NOT_CHARGING -> "Not Charging"
        BatteryManager.BATTERY_STATUS_UNKNOWN -> "Unknown"
        else -> "Unknown"
      },
      "batteryHealth" to when (batteryStatus?.getIntExtra(BatteryManager.EXTRA_HEALTH, -1)) {
        BatteryManager.BATTERY_HEALTH_GOOD -> "Good"
        BatteryManager.BATTERY_HEALTH_OVERHEAT -> "Overheat"
        BatteryManager.BATTERY_HEALTH_DEAD -> "Dead"
        BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> "Over Voltage"
        BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE -> "Unspecified Failure"
        BatteryManager.BATTERY_HEALTH_COLD -> "Cold"
        else -> "Unknown"
      },
      "pluggedStatus" to when (batteryStatus?.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1)) {
        BatteryManager.BATTERY_PLUGGED_AC -> "AC"
        BatteryManager.BATTERY_PLUGGED_USB -> "USB"
        BatteryManager.BATTERY_PLUGGED_WIRELESS -> "Wireless"
        else -> "Not Plugged"
      },
      "batteryCapacity" to batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY),
      "batteryVoltage" to (batteryStatus?.getIntExtra(BatteryManager.EXTRA_VOLTAGE, -1) ?: -1),
      "batteryTemperature" to (batteryStatus?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1)?.div(10) ?: -1),
      "batteryTechnology" to (batteryStatus?.getStringExtra(BatteryManager.EXTRA_TECHNOLOGY) ?: "Unknown"),
      "batteryCurrent" to batteryCurrent  // Added battery current
    )
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}