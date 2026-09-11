package com.example.ktdialer

import android.app.role.RoleManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.telecom.TelecomManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL_NAME = "com.example.ktdialer/call"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
        
        // Ensure CallHandler is set up
        CallHandler.setChannel(channel)

        channel.setMethodCallHandler { methodCall: MethodCall, result: MethodChannel.Result ->
            when (methodCall.method) {
                "requestDefaultDialer" -> {
                    requestDefaultDialer()
                    result.success(true)
                }
                "isDefaultDialer" -> {
                    result.success(isDefaultDialer())
                }
                "answerCall" -> {
                    val activeCall = CallService.activeCall
                    if (activeCall != null) {
                        try {
                            activeCall.answer(0) // VideoProfile.STATE_AUDIO_ONLY
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("CALL_ERROR", e.message, null)
                        }
                    } else {
                        result.error("NO_ACTIVE_CALL", "No active call found", null)
                    }
                }
                "hangupCall" -> {
                    val activeCall = CallService.activeCall
                    if (activeCall != null) {
                        activeCall.disconnect()
                        result.success(true)
                    } else {
                        result.error("NO_ACTIVE_CALL", "No active call found", null)
                    }
                }
                "placeCall" -> {
                    val number = methodCall.argument<String>("number")
                    if (number != null) {
                        placeCall(number)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGUMENT", "Number is null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun isDefaultDialer(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val roleManager = getSystemService(RoleManager::class.java)
            roleManager?.isRoleHeld(RoleManager.ROLE_DIALER) == true
        } else {
            val telecomManager = getSystemService(Context.TELECOM_SERVICE) as TelecomManager
            packageName == telecomManager.defaultDialerPackage
        }
    }

    private fun requestDefaultDialer() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val roleManager = getSystemService(RoleManager::class.java)
            val intent = roleManager?.createRequestRoleIntent(RoleManager.ROLE_DIALER)
            if (intent != null) {
                startActivityForResult(intent, 123)
            }
        } else {
            val intent = Intent(TelecomManager.ACTION_CHANGE_DEFAULT_DIALER)
            intent.putExtra(TelecomManager.EXTRA_CHANGE_DEFAULT_DIALER_PACKAGE_NAME, packageName)
            startActivityForResult(intent, 123)
        }
    }

    private fun placeCall(number: String) {
        val telecomManager = getSystemService(Context.TELECOM_SERVICE) as TelecomManager
        val uri = Uri.fromParts("tel", number, null)
        val extras = Bundle()
        try {
            telecomManager.placeCall(uri, extras)
        } catch (e: SecurityException) {
            e.printStackTrace()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
