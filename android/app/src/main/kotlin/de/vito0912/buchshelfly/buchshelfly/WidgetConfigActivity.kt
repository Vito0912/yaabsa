package de.vito0912.yaabsa

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.ListView
import android.widget.TextView

class WidgetConfigActivity : Activity() {
    private var appWidgetId: Int = AppWidgetManager.INVALID_APPWIDGET_ID

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.widget_config_activity)

        appWidgetId = intent?.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID)
            ?: AppWidgetManager.INVALID_APPWIDGET_ID

        setResult(
            RESULT_CANCELED,
            Intent().putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        )

        if (appWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
            return
        }

        val listView = findViewById<ListView>(R.id.widget_config_list)
        val emptyView = findViewById<TextView>(R.id.widget_config_empty)
        val populateAllButton = findViewById<Button>(R.id.widget_config_populate_all)
        val cancelButton = findViewById<Button>(R.id.widget_config_cancel)

        populateAllButton.setOnClickListener {
            WidgetStorage.requestPopulateAll(this)
            WidgetUpdateDispatcher.updateAll(this)

            val launchIntent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            }
            if (launchIntent != null) {
                startActivity(launchIntent)
            }

            finish()
        }

        cancelButton.setOnClickListener {
            finish()
        }

        val references = WidgetStorage.listShelfReferences(this)
        if (references.isEmpty()) {
            listView.visibility = View.GONE
            emptyView.visibility = View.VISIBLE
            emptyView.text = "No shelf snapshots found yet. Open Shelf in app to publish snapshot data."
            return
        }

        val labels = references.map { ref ->
            val shelfLabel = ref.shelfLabel?.trim().takeUnless { it.isNullOrEmpty() } ?: ref.shelfId
            val libraryLabel = ref.libraryName?.trim().takeUnless { it.isNullOrEmpty() } ?: ref.libraryId
            val userLabel = ref.userName?.trim().takeUnless { it.isNullOrEmpty() } ?: ref.userId ?: "unknown user"
            "$shelfLabel - $libraryLabel - $userLabel"
        }

        listView.adapter = ArrayAdapter(this, android.R.layout.simple_list_item_1, labels)
        listView.setOnItemClickListener { _, _, position, _ ->
            val selected = references[position]
            val saved = WidgetStorage.saveWidgetConfig(
                context = this,
                appWidgetId = appWidgetId,
                config = WidgetStorage.ShelfConfig(
                    userId = selected.userId,
                    libraryId = selected.libraryId,
                    shelfId = selected.shelfId
                )
            )

            if (saved) {
                WidgetUpdateDispatcher.updateSingleWidget(this, appWidgetId)
                setResult(
                    RESULT_OK,
                    Intent().putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                )
            }

            finish()
        }
    }
}
