from django.urls import include, path
from django.conf import settings
from django.conf.urls.static import static
from .views import CleanerRegisterView, CustomerRegisterView, AdminRegisterView, FlutterRedirectPasswordResetConfirmView, LoginView, LogoutView, PasswordResetView, PasswordResetConfirmView, password_reset_redirect_view, verify_email
from dj_rest_auth.registration.views import SocialLoginView
from allauth.socialaccount.providers.google.views import GoogleOAuth2Adapter

class GoogleLogin(SocialLoginView):
    adapter_class = GoogleOAuth2Adapter

urlpatterns = [
    path('register/customer/', CustomerRegisterView.as_view()),
    path('register/cleaner/', CleanerRegisterView.as_view()),
    path('register/admin/', AdminRegisterView.as_view()),
    path('login/', LoginView.as_view()),
    path('logout/', LogoutView.as_view()),
    path('password/reset/', PasswordResetView.as_view()),
    path('password/reset/complete/', PasswordResetConfirmView.as_view(), name='password_reset_complete'),
    path('password/reset/redirect/<uidb64>/<token>/', password_reset_redirect_view, name='flutter-password-reset'),
    path('verify-email/<uidb64>/<token>/', verify_email, name='verify-email'),
]
