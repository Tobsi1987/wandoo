package app.wandoo.wandoo

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/** Homescreen-Widget mit dem Wesen. Die Texte schreibt die App (home_widget). */
class CreatureWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.creature_widget).apply {
                setTextViewText(R.id.widget_face, widgetData.getString("face", "🥚"))
                setTextViewText(R.id.widget_stage, widgetData.getString("stage", "Ei"))
                setTextViewText(
                    R.id.widget_detail,
                    widgetData.getString("detail", "Geh los und entdecke neue Wege"),
                )
                setTextViewText(R.id.widget_mood, widgetData.getString("mood", ""))
                setOnClickPendingIntent(
                    R.id.widget_root,
                    HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
                )
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
