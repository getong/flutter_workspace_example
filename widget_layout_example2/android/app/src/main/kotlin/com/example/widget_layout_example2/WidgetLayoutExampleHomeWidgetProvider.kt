package com.example.widget_layout_example2

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class WidgetLayoutExampleHomeWidgetProvider : HomeWidgetProvider() {
  override fun onUpdate(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetIds: IntArray,
    widgetData: SharedPreferences,
  ) {
    appWidgetIds.forEach { widgetId ->
      val title = widgetData.getString("title", null) ?: "Widget Layout Example"
      val message = widgetData.getString("message", null) ?: "Update me from Flutter."
      val imagePath = widgetData.getString("flutterIcon", null)

      val views = RemoteViews(context.packageName, R.layout.widget_layout_example_home_widget).apply {
        val launchIntent = HomeWidgetLaunchIntent.getActivity(
          context,
          MainActivity::class.java,
          Uri.parse("widget-layout-example://home-widget?source=container"),
        )
        setOnClickPendingIntent(R.id.widget_container, launchIntent)

        setTextViewText(R.id.widget_title, title)
        setTextViewText(R.id.widget_message, message)

        val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
          context,
          Uri.parse("widget-layout-example://messageClicked"),
        )
        setOnClickPendingIntent(R.id.widget_message, backgroundIntent)

        if (imagePath != null) {
          setImageViewBitmap(R.id.widget_image, BitmapFactory.decodeFile(imagePath))
          setViewVisibility(R.id.widget_image, View.VISIBLE)
        } else {
          setViewVisibility(R.id.widget_image, View.GONE)
        }
      }

      appWidgetManager.updateAppWidget(widgetId, views)
    }
  }
}
