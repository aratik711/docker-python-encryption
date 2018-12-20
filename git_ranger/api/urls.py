from django.conf.urls import url, include
from rest_framework.urlpatterns import format_suffix_patterns
from rest_framework.authtoken.views import obtain_auth_token
from .views import FileView


urlpatterns = {

    url(r'^auth/', include('rest_framework.urls',
                               namespace='rest_framework')),
    url(r'^encrypt/$', FileView.as_view(), name='file-upload'),
    url(r'^decrypt/$', FileView.as_view(), name='file-upload'),

}

urlpatterns = format_suffix_patterns(urlpatterns)