package com.example.ktdialer

import io.flutter.plugin.common.MethodChannel

object CallHandler {
    private var channel: MethodChannel? = null

    fun setChannel(methodChannel: MethodChannel) {
        channel = methodChannel
    }

    fun onCallAdded(call: android.telecom.Call) {
        val data = mapOf<String, Any?>(
            "number" to call.details.handle.schemeSpecificPart,
            "state" to call.state
        )
        channel?.invokeMethod("onCallAdded", data)
    }

    fun onStateChanged(call: android.telecom.Call, state: Int) {
        val data = mapOf<String, Any?>(
            "number" to call.details.handle.schemeSpecificPart,
            "state" to state
        )
        channel?.invokeMethod("onStateChanged", data)
    }

    fun onCallRemoved(call: android.telecom.Call) {
        channel?.invokeMethod("onCallRemoved", null)
    }
}
