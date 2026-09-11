package com.example.ktdialer

import android.content.Intent
import android.telecom.Call
import android.telecom.InCallService

class CallService : InCallService() {

    companion object {
        var activeCall: Call? = null
    }

    override fun onCallAdded(call: Call) {
        super.onCallAdded(call)
        activeCall = call
        
        val intent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            putExtra("show_call_ui", true)
        }
        startActivity(intent)

        CallHandler.onCallAdded(call)
        
        call.registerCallback(object : Call.Callback() {
            override fun onStateChanged(call: Call, state: Int) {
                CallHandler.onStateChanged(call, state)
            }
        })
    }

    override fun onCallRemoved(call: Call) {
        super.onCallRemoved(call)
        activeCall = null
        CallHandler.onCallRemoved(call)
    }
}
