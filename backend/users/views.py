from django.shortcuts import render

# Create your views here.
from rest_framework import generics
from .models import User
from .serializers import CustomerRegisterSerializer, CleanerRegisterSerializer, AdminRegisterSerializer, LoginSerializer, LogoutSerializer, PasswordResetSerializer, PasswordResetConfirmSerializer, VerifyEmailSerializer
from django.utils.http import urlsafe_base64_decode
from django.contrib.auth.tokens import default_token_generator
from django.http import JsonResponse
from rest_framework.response import Response
from rest_framework import status


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

class CleanerRegisterView(generics.CreateAPIView):
    serializer_class = CleanerRegisterSerializer

class AdminRegisterView(generics.CreateAPIView):
    serializer_class = AdminRegisterSerializer

class LoginView(generics.GenericAPIView):
    serializer_class = LoginSerializer

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

class PasswordResetConfirmView(generics.GenericAPIView):
    serializer_class = PasswordResetConfirmSerializer

class VerifyEmailView(generics.GenericAPIView):
    serializer_class = VerifyEmailSerializer

