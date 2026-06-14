package com.example.arpy

import android.content.Context
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val CHANNEL = "arpy/native_events"
	private var methodChannel: MethodChannel? = null


	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

		// MethodChannel left available for platform-to-Flutter messages.
		// ARCore-specific broadcast receiver removed since native ARCore integration was removed.
	}

	override fun onDestroy() {
		super.onDestroy()
		// no receiver to unregister
	}
}
