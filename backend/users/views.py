from django.shortcuts import redirect, render

# Create your views here.
from rest_framework import generics
from .models import User
from .serializers import CustomerRegisterSerializer, CleanerRegisterSerializer, AdminRegisterSerializer, LoginSerializer, LogoutSerializer, PasswordResetSerializer, PasswordResetConfirmSerializer, VerifyEmailSerializer
from django.utils.http import urlsafe_base64_decode, urlsafe_base64_encode
from django.utils.encoding import force_bytes
from django.contrib.auth.tokens import default_token_generator
from django.http import JsonResponse
from rest_framework.response import Response
from rest_framework import status
from django.conf import settings
from django.core.mail import send_mail
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny


def verify_email(request, uidb64, token):
    try:
        uid = urlsafe_base64_decode(uidb64).decode()
        user = User.objects.get(pk=uid)
    except (TypeError, ValueError, OverflowError, User.DoesNotExist):
        return JsonResponse({'error': 'Invalid UID.'}, status=400)

    if user.is_verified:
        return JsonResponse({'message': 'Email already verified.'})

    if default_token_generator.check_token(user, token):
        user.is_verified = True
        user.save()
        return JsonResponse({'message': 'Email verified successfully!'})
    else:
        return JsonResponse({'error': 'Invalid or expired token.'}, status=400)

class CustomerRegisterView(generics.CreateAPIView):
    serializer_class = CustomerRegisterSerializer
    permission_classes = [AllowAny]

class CleanerRegisterView(generics.CreateAPIView):
    serializer_class = CleanerRegisterSerializer
    permission_classes = [AllowAny]

class AdminRegisterView(generics.CreateAPIView):
    serializer_class = AdminRegisterSerializer
    permission_classes = [AllowAny]

class LoginView(generics.GenericAPIView):
    serializer_class = LoginSerializer
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        return Response({
            "message": "Login successful",
            "user": {
                "email": user.email,
                "username": user.username,
                "is_customer": user.is_customer,
                "is_cleaner": user.is_cleaner,
                "is_admin": user.is_admin,
            }
        }, status=status.HTTP_200_OK)


class LogoutView(generics.GenericAPIView):
    serializer_class = LogoutSerializer

class PasswordResetView(generics.GenericAPIView):
    serializer_class = PasswordResetSerializer
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        email = serializer.validated_data['email']
        user = User.objects.get(email=email)

        uid = urlsafe_base64_encode(force_bytes(user.pk))
        token = default_token_generator.make_token(user)

        # 👉 NEW: point to our custom redirect view
        reset_link = f"http://localhost:8000/auth/password/reset/redirect/{uid}/{token}/"

        subject = "Reset Your Password"
        message = f"Hi {user.username},\n\nClick the link below to reset your password:\n{reset_link}"

        send_mail(
            subject,
            message,
            settings.DEFAULT_FROM_EMAIL,
            [user.email],
            fail_silently=False,
        )

        return Response({"message": "Password reset link sent to your email."}, status=status.HTTP_200_OK)

    
class FlutterRedirectPasswordResetConfirmView(APIView):
    def get(self, request, uidb64, token):
        permission_classes = [AllowAny]
        # Redirect to Flutter app
        flutter_link = f"myapp://reset-password?uid={uidb64}&token={token}"
        return redirect(flutter_link)

def password_reset_redirect_view(request, uidb64, token):
    return render(request, 'password_reset_redirect.html', {
        'uid': uidb64,
        'token': token
    })


class PasswordResetConfirmView(generics.GenericAPIView):
    permission_classes = [AllowAny]
    serializer_class = PasswordResetConfirmSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        return Response({"message": "Password has been reset successfully."}, status=status.HTTP_200_OK)


class VerifyEmailView(generics.GenericAPIView):
    serializer_class = VerifyEmailSerializer

