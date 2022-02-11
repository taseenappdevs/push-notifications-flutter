package com.pusher.pusher_beams

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import com.google.firebase.messaging.RemoteMessage
import com.pusher.pushnotifications.*
import com.pusher.pushnotifications.auth.AuthData
import com.pusher.pushnotifications.auth.AuthDataGetter
import com.pusher.pushnotifications.auth.BeamsTokenProvider
import io.flutter.Log

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** PusherBeamsPlugin */
class PusherBeamsPlugin : FlutterPlugin, Messages.PusherBeamsApi, ActivityAware {
    private lateinit var context: Context
    private var alreadyInterestsListener: Boolean = false
    private var currentActivity: Activity? = null

    private lateinit var callbackHandlerApi: Messages.CallbackHandlerApi

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Messages.PusherBeamsApi.setup(flutterPluginBinding.binaryMessenger, this)

        context = flutterPluginBinding.applicationContext
        callbackHandlerApi = Messages.CallbackHandlerApi(flutterPluginBinding.binaryMessenger)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Messages.PusherBeamsApi.setup(binding.binaryMessenger, null)
        callbackHandlerApi = Messages.CallbackHandlerApi(binding.binaryMessenger)
    }

    override fun start(instanceId: String) {
        PushNotifications.start(this.context, instanceId)
        Log.d(this.toString(), "PusherBeams started with $instanceId instanceId")
    }

    override fun addDeviceInterest(interest: String) {
        PushNotifications.addDeviceInterest(interest)
        Log.d(this.toString(), "Added device to interest: $interest")
    }

    override fun removeDeviceInterest(interest: String) {
        PushNotifications.removeDeviceInterest(interest)
        Log.d(this.toString(), "Removed device to interest: $interest")
    }

    override fun getDeviceInterests(): kotlin.collections.List<String> {
        return PushNotifications.getDeviceInterests().toList()
    }

    override fun setDeviceInterests(interests: kotlin.collections.List<String>) {
        PushNotifications.setDeviceInterests(interests.toSet())
        Log.d(this.toString(), "$interests added to device")
    }

    override fun clearDeviceInterests() {
        PushNotifications.clearDeviceInterests()
        Log.d(this.toString(), "Cleared device interests")
    }

    override fun onInterestChanges(callbackId: String) {
        if (!alreadyInterestsListener) {
            PushNotifications.setOnDeviceInterestsChangedListener(object : SubscriptionsChangedListener {
                override fun onSubscriptionsChanged(interests: Set<String>) {
                    callbackHandlerApi.handleCallback(callbackId, "onInterestChanges", listOf(interests.toList()), Messages.CallbackHandlerApi.Reply {
                        Log.d(this.toString(), "interests changed $interests")
                    })
                }
            })
        }
    }

    override fun setUserId(
            userId: String,
            provider: Messages.BeamsAuthProvider,
            callbackId: String
    ) {
        val tokenProvider = BeamsTokenProvider(
                provider.authUrl,
                object : AuthDataGetter {
                    override fun getAuthData(): AuthData {
                        return AuthData(
                                headers = provider.headers,
                                queryParams = provider.queryParams
                        )
                    }
                }
        )

        PushNotifications.setUserId(
                userId,
                tokenProvider,
                object : BeamsCallback<Void, PusherCallbackError> {
                    override fun onFailure(error: PusherCallbackError) {
                        callbackHandlerApi.handleCallback(callbackId, "setUserId", listOf(error.message), Messages.CallbackHandlerApi.Reply {
                            Log.d(this.toString(), "Failed to set Authentication to device")
                        })
                    }

                    override fun onSuccess(vararg values: Void) {
                        callbackHandlerApi.handleCallback(callbackId, "setUserId", listOf(null), Messages.CallbackHandlerApi.Reply {
                            Log.d(this.toString(), "Device authenticated with $userId")
                        })
                    }
                }
        )
    }

    override fun clearAllState() {
        PushNotifications.clearAllState()
    }

    override fun onMessageReceivedInTheForeground(callbackId: String) {
        currentActivity?.let { activity ->
            PushNotifications.setOnMessageReceivedListenerForVisibleActivity(activity, object : PushNotificationReceivedListener {
                override fun onMessageReceived(remoteMessage: RemoteMessage) {
                    activity.runOnUiThread {
                        val pusherMessage = remoteMessage.toPusherMessage()
                        callbackHandlerApi.handleCallback(callbackId, "onMessageReceivedInTheForeground", listOf(pusherMessage)) {
                            Log.d(this.toString(), "Message received: $pusherMessage")
                        }
                    }
                }
            })
        }
    }

    override fun stop() {
        PushNotifications.stop()
    }

    override fun onAttachedToActivity(pluginBinding: ActivityPluginBinding) {
        this.currentActivity = pluginBinding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(pluginBinding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
        this.currentActivity = null;
    }
}

fun RemoteMessage.toPusherMessage() = mapOf(
    "title" to notification?.title,
    "body" to notification?.body,
    "data" to data
)