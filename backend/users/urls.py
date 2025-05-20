from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from .views import CleanerRegisterView, CustomerRegisterView, AdminRegisterView, LoginView, LogoutView, PasswordResetView, PasswordResetConfirmView, verify_email
urlpatterns = [
    path('register/customer/', CustomerRegisterView.as_view()),
    path('register/cleaner/', CleanerRegisterView.as_view()),
    path('register/admin/', AdminRegisterView.as_view()),
    path('login/', LoginView.as_view()),
    path('logout/', LogoutView.as_view()),
    path('password/reset/', PasswordResetView.as_view()),
    path('password/reset/confirm/', PasswordResetConfirmView.as_view()),
    path('verify-email/<uidb64>/<token>/', verify_email, name='verify-email'),
]
