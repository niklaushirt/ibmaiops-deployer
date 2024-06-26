from django.urls import path

from . import views

urlpatterns = [
    path('health', views.health, name='health'),
    path('loginui', views.loginui, name='loginui'),
    path('login', views.login, name='login'),
    path('doc', views.doc, name='doc'),
    path('config', views.config, name='config'),
    path('apps', views.apps, name='apps'),
    path('apps_system', views.apps_system, name='apps_system'),
    path('apps_demo', views.apps_demo, name='apps_demo'),
    path('apps_additional', views.apps_additional, name='apps_additional'),
    path('about', views.about, name='about'),
    path('watsonx', views.watsonx, name='watsonx'),
    path('', views.index, name='index'),
    path('injectLogsREST', views.injectLogsREST, name='injectLogsREST'),
    path('injectEventsREST', views.injectEventsREST, name='injectEventsREST'),
    path('injectMetricsREST', views.injectMetricsREST, name='injectMetricsREST'),
    path('injectAllREST', views.injectAllREST, name='injectAllREST'),
    path('injectAllRobotNetREST', views.injectAllRobotNetREST, name='injectAllRobotNetREST'),
    path('injectAllFanACMEREST', views.injectAllFanACMEREST, name='injectAllFanACMEREST'),
    path('injectAllNetSOCKREST', views.injectAllNetSOCKREST, name='injectAllNetSOCKREST'),
    path('injectAllTUBEREST', views.injectAllTUBEREST, name='injectAllTUBEREST'),
    path('injectAllTELCOREST', views.injectAllTELCOREST, name='injectAllTELCOREST'),
    path('injectBusy', views.injectBusy, name='injectBusy'),
    path('clearAllREST', views.clearAllREST, name='clearAllREST'),
    path('clearEventsREST', views.clearEventsREST, name='clearEventsREST'),
    path('clearStoriesREST', views.clearStoriesREST, name='clearStoriesREST'),
    path('instanaCreateIncident', views.instanaCreateIncident, name='instanaCreateIncident'),
    path('instanaMitigateIncident', views.instanaMitigateIncident, name='instanaMitigateIncident'),
    path('injectRESTHeadless', views.injectRESTHeadless, name='injectRESTHeadless'),
    path('injectCUSTOM', views.injectCUSTOM, name='injectCUSTOM'),
    path('httpCommand', views.httpCommand, name='httpCommand'),
    path('reloadTopology', views.reloadTopology, name='reloadTopology'),
]
