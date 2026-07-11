package de.vito0912.yaabsa

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.documentfile.provider.DocumentFile
import com.ryanheise.audioservice.AudioServiceFragmentActivity
import com.ryanheise.audioservice.AudioServicePlugin
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceFragmentActivity() {
	companion object {
		private const val WIDGET_CHANNEL = "de.vito0912.yaabsa/widget"
		private const val SAF_CHANNEL = "de.vito0912.yaabsa/saf"
		private const val AAOS_CHANNEL = "de.vito0912.yaabsa/aaos"
		private const val AAOS_SETTINGS_ACTION = "android.intent.action.APPLICATION_PREFERENCES"
		private const val AAOS_MEDIA_TEMPLATE_ACTION = "android.car.intent.action.MEDIA_TEMPLATE"
		private const val AAOS_MEDIA_TEMPLATE_V2_ACTION = "androidx.car.app.mediaextensions.action.MEDIA_TEMPLATE_V2"
		private const val AAOS_MEDIA_COMPONENT_EXTRA = "android.car.intent.extra.MEDIA_COMPONENT"
		private const val WIDGET_COMMAND_DELAY_MS = 100L
	}

	private val widgetCommandHandler = Handler(Looper.getMainLooper())

	private fun isWidgetSupportEnabled(): Boolean {
		return WidgetRuntimeSupport.isWidgetSupportEnabled(applicationContext)
	}


	private var aaosChannel: MethodChannel? = null
	private var pendingAaosOpenSettings = false
	private var pendingAaosOpenSignIn = false

	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		handleWidgetLaunchIntent(intent)
		handleAaosIntent(intent)
		handleSignInIntent(intent)
		if (maybeLaunchMediaCenterFromMainIntent(intent)) {
			return
		}
	}

	override fun onNewIntent(intent: Intent) {
		super.onNewIntent(intent)
		setIntent(intent)
		handleWidgetLaunchIntent(intent)
		handleAaosIntent(intent)
		handleSignInIntent(intent)
		if (maybeLaunchMediaCenterFromMainIntent(intent)) {
			return
		}
	}

	private fun handleSignInIntent(intent: Intent) {
		if (!isSignInAliasLaunch(intent)) {
			return
		}

		pendingAaosOpenSignIn = true
		notifyAaosOpenSignInIfPending()
	}

	private fun maybeLaunchMediaCenterFromMainIntent(intent: Intent): Boolean {
		if (!packageManager.hasSystemFeature(PackageManager.FEATURE_AUTOMOTIVE)) {
			return false
		}

		if (isSignInAliasLaunch(intent)) {
			return false
		}

		if (intent.action == AAOS_SETTINGS_ACTION || intent.getBooleanExtra("openSettings", false)) {
			return false
		}

		if (intent.action != Intent.ACTION_MAIN) {
			return false
		}

		if (!intent.hasCategory(Intent.CATEGORY_LAUNCHER)) {
			return false
		}

		return launchMediaCenterInternal(finishActivity = true)
	}

	private fun isSignInAliasLaunch(intent: Intent): Boolean {
		val className = intent.component?.className ?: return false
		return className == "de.vito0912.yaabsa.SignInActivity" || className == "$packageName.SignInActivity"
	}

	private fun handleAaosIntent(intent: Intent) {
		val shouldOpenSettings = intent.action == AAOS_SETTINGS_ACTION || intent.getBooleanExtra("openSettings", false)
		if (!shouldOpenSettings) {
			return
		}

		intent.removeExtra("openSettings")
		pendingAaosOpenSettings = true
		notifyAaosOpenSettingsIfPending()
	}

	private fun notifyAaosOpenSettingsIfPending() {
		if (!pendingAaosOpenSettings) {
			return
		}

		val channel = aaosChannel ?: return
		pendingAaosOpenSettings = false

		Handler(Looper.getMainLooper()).postDelayed({
			channel.invokeMethod("openSettings", null)
		}, 300)
	}

	private fun notifyAaosOpenSignInIfPending() {
		if (!pendingAaosOpenSignIn) {
			return
		}

		val channel = aaosChannel ?: return
		pendingAaosOpenSignIn = false

		Handler(Looper.getMainLooper()).postDelayed({
			channel.invokeMethod("openSignIn", null)
		}, 120)
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

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SAF_CHANNEL)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"prepareDownloadFile" -> handlePrepareDownloadFile(call, result)
					else -> result.notImplemented()
				}
			}

		aaosChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AAOS_CHANNEL)
		aaosChannel?.setMethodCallHandler { call, result ->
			when (call.method) {
				"launchMediaCenter" -> handleLaunchMediaCenter(call, result)
				else -> result.notImplemented()
			}
		}

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "de.vito0912.yaabsa/autoresume")
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"updateAutoResumeSettings" -> {
						val bluetooth = call.argument<Boolean>("bluetooth") ?: false
						val prefs = applicationContext.getSharedPreferences("yaabsa_settings", Context.MODE_PRIVATE)
						prefs.edit()
							.putBoolean("auto_resume_bluetooth", bluetooth)
							.apply()

						if (bluetooth && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
							if (checkSelfPermission(Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED) {
								requestPermissions(arrayOf(Manifest.permission.BLUETOOTH_CONNECT), 101)
							}
						}

						result.success(null)
					}
					else -> result.notImplemented()
				}
			}

		notifyAaosOpenSettingsIfPending()
		notifyAaosOpenSignInIfPending()
	}

	private fun handleLaunchMediaCenter(call: MethodCall, result: MethodChannel.Result) {
		try {
			val finishActivity = call.argument<Boolean>("finishActivity") ?: false
			result.success(launchMediaCenterInternal(finishActivity = finishActivity))
		} catch (e: Exception) {
			result.error("LAUNCH_FAILED", "Failed to launch Media Center: ${e.message}", null)
		}
	}

	private fun launchMediaCenterInternal(finishActivity: Boolean): Boolean {
		val componentName = android.content.ComponentName(packageName, "com.ryanheise.audioservice.AudioService")
		val mediaHostIntent = buildMediaHostIntent(componentName)

		return try {
			startActivity(mediaHostIntent)
			if (finishActivity && !isFinishing) {
				finish()
			}
			true
		} catch (_: Exception) {
			false
		}
	}

	private fun buildMediaHostIntent(componentName: android.content.ComponentName): Intent {
		val supportsMediaTemplateV2 = packageManager.queryIntentActivities(
			Intent(AAOS_MEDIA_TEMPLATE_V2_ACTION),
			PackageManager.MATCH_DEFAULT_ONLY or PackageManager.MATCH_SYSTEM_ONLY,
		).isNotEmpty()

		val action = if (supportsMediaTemplateV2) AAOS_MEDIA_TEMPLATE_V2_ACTION else AAOS_MEDIA_TEMPLATE_ACTION
		return Intent(action)
			.putExtra(AAOS_MEDIA_COMPONENT_EXTRA, componentName.flattenToString())
			.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
	}

	private fun handlePrepareDownloadFile(call: MethodCall, result: MethodChannel.Result) {
		val rootTreeUriRaw = call.argument<String>("rootTreeUri")?.trim().orEmpty()
		val relativeDirectory = call.argument<String>("relativeDirectory")?.trim().orEmpty()
		val filename = call.argument<String>("filename")?.trim().orEmpty()
		val mimeType = call.argument<String>("mimeType")?.trim().orEmpty().ifEmpty { "application/octet-stream" }

		if (rootTreeUriRaw.isEmpty() || filename.isEmpty()) {
			result.error(
				"invalid_args",
				"prepareDownloadFile expects non-empty rootTreeUri and filename.",
				null
			)
			return
		}

		val rootTreeUri = try {
			Uri.parse(rootTreeUriRaw)
		} catch (e: Exception) {
			result.error("invalid_uri", "Invalid rootTreeUri: ${e.message}", null)
			return
		}

		if (rootTreeUri.scheme != "content") {
			result.error("invalid_uri", "rootTreeUri must be a content:// URI.", null)
			return
		}

		val rootDirectory = DocumentFile.fromTreeUri(applicationContext, rootTreeUri)
		if (rootDirectory == null || !rootDirectory.exists() || !rootDirectory.isDirectory) {
			result.error("invalid_root", "Selected SAF root directory is not accessible.", null)
			return
		}

		val targetDirectory = resolveOrCreateSafDirectory(rootDirectory, relativeDirectory)
		if (targetDirectory == null || !targetDirectory.exists() || !targetDirectory.isDirectory) {
			result.error("directory_failed", "Could not resolve target SAF directory.", null)
			return
		}

		val existingEntry = targetDirectory.findFile(filename)
		if (existingEntry != null && existingEntry.exists()) {
			if (!existingEntry.isFile) {
				result.error("invalid_target", "Target exists but is not a file.", null)
				return
			}
			result.success(existingEntry.uri.toString())
			return
		}

		val createdFile = targetDirectory.createFile(mimeType, filename)
		if (createdFile == null || !createdFile.exists()) {
			result.error("create_failed", "Could not create target file in SAF directory.", null)
			return
		}

		result.success(createdFile.uri.toString())
	}

	private fun resolveOrCreateSafDirectory(rootDirectory: DocumentFile, relativeDirectory: String): DocumentFile? {
		if (relativeDirectory.isBlank()) {
			return rootDirectory
		}

		val segments = relativeDirectory
			.split('/', '\\')
			.map { it.trim() }
			.filter { it.isNotEmpty() }

		var current: DocumentFile = rootDirectory
		for (segment in segments) {
			var next = current.findFile(segment)
			if (next == null || !next.exists()) {
				next = current.createDirectory(segment)
			} else if (!next.isDirectory) {
				return null
			}
			if (next == null) {
				return null
			}
			current = next
		}

		return current
	}

	private fun handleWidgetLaunchIntent(intent: Intent?) {
		if (!isWidgetSupportEnabled()) {
			return
		}

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
		if (!isWidgetSupportEnabled()) {
			result.success(false)
			return
		}

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
		if (!isWidgetSupportEnabled()) {
			result.success(false)
			return
		}

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
		if (!isWidgetSupportEnabled()) {
			result.success(false)
			return
		}

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
		if (!isWidgetSupportEnabled()) {
			result.success(false)
			return
		}

		result.success(WidgetStorage.consumePopulateAllRequest(applicationContext))
	}

	private fun handleTriggerWidgetUpdate(call: MethodCall, result: MethodChannel.Result) {
		if (!isWidgetSupportEnabled()) {
			result.success(false)
			return
		}

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

	override fun onDestroy() {
		val isServiceRunning = try {
			val serviceClass = Class.forName("com.ryanheise.audioservice.AudioService")
			val instanceField = serviceClass.getDeclaredField("instance")
			instanceField.isAccessible = true
			instanceField.get(null) != null
		} catch (e: Exception) {
			false
		}

		if (!isServiceRunning) {
			AudioServicePlugin.disposeFlutterEngine()
		}

		super.onDestroy()
	}
}

