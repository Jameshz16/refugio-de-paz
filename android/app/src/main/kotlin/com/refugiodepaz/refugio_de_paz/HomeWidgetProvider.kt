package com.refugiodepaz.refugio_de_paz

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class HomeWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                // Configurar click superior para Abrir Diario ("Normal")
                val pendingIntentOpen = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("refugiodepaz://home")
                )
                setOnClickPendingIntent(R.id.btn_open, pendingIntentOpen)

                // Reacción Feliz
                val pendingIntentFeliz = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("refugiodepaz://emotion?name=Feliz")
                )
                setOnClickPendingIntent(R.id.btn_feliz, pendingIntentFeliz)
                
                // Reacción Triste
                val pendingIntentTriste = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("refugiodepaz://emotion?name=Triste")
                )
                setOnClickPendingIntent(R.id.btn_triste, pendingIntentTriste)

                // Optional: We can read data from Flutter here to update the text if we want
                // val t = widgetData.getString("title", "¿Cómo te sientes hoy?")
                // setTextViewText(R.id.widget_title, t)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
