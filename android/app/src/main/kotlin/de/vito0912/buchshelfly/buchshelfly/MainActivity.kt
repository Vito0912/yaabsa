package de.vito0912.yaabsa

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
	companion object {
		private const val WIDGET_CHANNEL = "de.vito0912.yaabsa/widget"
		private const val WIDGET_COMMAND_DELAY_MS = 700L
	}

	private val widgetCommandHandler = Handler(Looper.getMainLooper())

	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		handleWidgetLaunchIntent(intent)
	}

	override fun onNewIntent(intent: Intent) {
		super.onNewIntent(intent)
		setIntent(intent)
		handleWidgetLaunchIntent(intent)
	}

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGET_CHANNEL)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"publishShelfSnapshot" -> handlePublishShelfSnapshot(call, result)
					"publishWidgetConfig" -> handlePublishWidgetConfig(call, result)
					"publishWidgetTheme" -> handlePublishWidgetTheme(call, result)
					"consumePopulateAllRequest" -> handleConsumePopulateAllRequest(result)
					"triggerWidgetUpdate" -> handleTriggerWidgetUpdate(call, result)
					else -> result.notImplemented()
				}
			}
	}

	private fun handleWidgetLaunchIntent(intent: Intent?) {
		if (intent == null) {
			return
		}

		val mediaIdToPlay = intent.getStringExtra(WidgetMediaBridge.EXTRA_WIDGET_MEDIA_ID_TO_PLAY)
		val quickPlay = intent.getBooleanExtra(WidgetMediaBridge.EXTRA_WIDGET_QUICK_PLAY, false)

		if (mediaIdToPlay.isNullOrBlank() && !quickPlay) {
			return
		}

		intent.removeExtra(WidgetMediaBridge.EXTRA_WIDGET_MEDIA_ID_TO_PLAY)
		intent.removeExtra(WidgetMediaBridge.EXTRA_WIDGET_QUICK_PLAY)

		if (!mediaIdToPlay.isNullOrBlank()) {
			postWidgetCommand {
				WidgetMediaBridge.playFromMediaId(
					context = applicationContext,
					mediaId = mediaIdToPlay,
					allowLaunchFallback = false
				)
			}
		}

		if (quickPlay) {
			postWidgetCommand {
				WidgetMediaBridge.performTransportAction(
					context = applicationContext,
					action = WidgetMediaBridge.ACTION_QUICK_PLAY,
					allowLaunchFallback = false
				)
			}
		}
	}

	private fun postWidgetCommand(command: () -> Unit) {
		widgetCommandHandler.postDelayed({ command() }, WIDGET_COMMAND_DELAY_MS)
	}

	private fun handlePublishShelfSnapshot(call: MethodCall, result: MethodChannel.Result) {
		val userId = call.argument<String>("userId")?.trim()?.ifEmpty { null }
		val userName = call.argument<String>("userName")?.trim()?.ifEmpty { null }
		val libraryId = call.argument<String>("libraryId")?.trim().orEmpty()
		val libraryName = call.argument<String>("libraryName")?.trim()?.ifEmpty { null }
		val shelfId = call.argument<String>("shelfId")?.trim().orEmpty()
		val shelfLabel = call.argument<String>("shelfLabel")?.trim()?.ifEmpty { null }
		val itemsJson = call.argument<String>("itemsJson")

		if (libraryId.isEmpty() || shelfId.isEmpty() || itemsJson.isNullOrBlank()) {
			result.error(
				"invalid_args",
				"publishShelfSnapshot expects non-empty libraryId, shelfId and itemsJson.",
				null
			)
			return
		}

		WidgetStorage.saveShelfSnapshot(
			context = applicationContext,
			userId = userId,
			userName = userName,
			libraryId = libraryId,
			libraryName = libraryName,
			shelfId = shelfId,
			itemsJson = itemsJson,
			shelfLabel = shelfLabel
		)
		WidgetUpdateDispatcher.updateShelfWidgets(applicationContext)
		WidgetUpdateDispatcher.updateQuickPlayWidgets(applicationContext)
		result.success(true)
	}

	private fun handlePublishWidgetConfig(call: MethodCall, result: MethodChannel.Result) {
		val appWidgetId = parseAppWidgetId(call.argument<Any>("appWidgetId"))
		if (appWidgetId == null || appWidgetId < 0) {
			result.error("invalid_widget_id", "publishWidgetConfig requires a valid appWidgetId.", null)
			return
		}

		val configAsMap = call.argument<Map<*, *>>("config")
		val configAsJson = call.argument<String>("config")

		val saved = when {
			configAsMap != null -> WidgetStorage.saveWidgetConfig(applicationContext, appWidgetId, configAsMap)
			!configAsJson.isNullOrBlank() -> WidgetStorage.saveWidgetConfig(applicationContext, appWidgetId, configAsJson)
			else -> false
		}

		if (saved) {
			WidgetUpdateDispatcher.updateSingleWidget(applicationContext, appWidgetId)
			result.success(true)
		} else {
			result.error(
				"invalid_config",
				"publishWidgetConfig requires config with non-empty libraryId and shelfId.",
				null
			)
		}
	}

	private fun handlePublishWidgetTheme(call: MethodCall, result: MethodChannel.Result) {
		val isDarkMode = call.argument<Boolean>("isDarkMode")
		if (isDarkMode == null) {
			result.error("invalid_theme", "publishWidgetTheme requires a boolean isDarkMode argument.", null)
			return
		}

		WidgetStorage.setDarkModeEnabled(applicationContext, isDarkMode)
		WidgetUpdateDispatcher.updateAll(applicationContext)
		result.success(true)
	}

	private fun handleConsumePopulateAllRequest(result: MethodChannel.Result) {
		result.success(WidgetStorage.consumePopulateAllRequest(applicationContext))
	}

	private fun handleTriggerWidgetUpdate(call: MethodCall, result: MethodChannel.Result) {
		val appWidgetId = parseAppWidgetId(call.argument<Any>("appWidgetId"))
		if (appWidgetId != null && appWidgetId >= 0) {
			WidgetUpdateDispatcher.updateSingleWidget(applicationContext, appWidgetId)
		} else {
			WidgetUpdateDispatcher.updateAll(applicationContext)
		}

		result.success(true)
	}

	private fun parseAppWidgetId(raw: Any?): Int? {
		return when (raw) {
			is Int -> raw
			is Long -> raw.toInt()
			is Double -> raw.toInt()
			is String -> raw.toIntOrNull()
			else -> null
		}
	}
}
