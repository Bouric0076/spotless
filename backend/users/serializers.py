from rest_framework import serializers as Serializer
from .models import User
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from django.utils.encoding import force_bytes
from django.contrib.auth.tokens import default_token_generator
from django.core.mail import send_mail
from django.conf import settings

# ---------------------------
# Registration Serializers
# ---------------------------

class CustomerRegisterSerializer(Serializer.ModelSerializer):
    class Meta:
        model = User
        fields = ('email', 'phone_number', 'username', 'password')
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        validated_data['is_customer'] = True
        user = User.objects.create_user(**validated_data)
        self.send_verification_email(user)
        return user

    def send_verification_email(self, user):
        uid = urlsafe_base64_encode(force_bytes(user.pk))
        token = default_token_generator.make_token(user)
        link = f"http://localhost:8000/auth/verify-email/{uid}/{token}/"

        subject = 'Verify your email'
        message = f'Hi {user.username},\n\nClick the link below to verify your email:\n{link}'
        send_mail(
            subject,
            message,
            settings.DEFAULT_FROM_EMAIL,
            [user.email],
            fail_silently=False
        )

class CleanerRegisterSerializer(Serializer.ModelSerializer):
    class Meta:
        model = User
        fields = ('email', 'phone_number', 'username', 'password', 'national_id')
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        validated_data['is_cleaner'] = True
        user = User.objects.create_user(**validated_data)
        self.send_verification_email(user)
        return user

    def send_verification_email(self, user):
        uid = urlsafe_base64_encode(force_bytes(user.pk))
        token = default_token_generator.make_token(user)
        link = f"http://localhost:8000/auth/verify-email/{uid}/{token}/"

        subject = 'Verify your email'
        message = f'Hi {user.username},\n\nClick the link below to verify your email:\n{link}'
        send_mail(
            subject,
            message,
            settings.DEFAULT_FROM_EMAIL,
            [user.email],
            fail_silently=False
        )

class AdminRegisterSerializer(Serializer.ModelSerializer):
    class Meta:
        model = User
        fields = ('email', 'phone_number', 'username', 'password')
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        validated_data['is_admin'] = True
        user = User.objects.create_user(**validated_data)
        self.send_verification_email(user)
        return user

    def send_verification_email(self, user):
        uid = urlsafe_base64_encode(force_bytes(user.pk))
        token = default_token_generator.make_token(user)
        link = f"http://localhost:8000/auth/verify-email/{uid}/{token}/"

        subject = 'Verify your email'
        message = f'Hi {user.username},\n\nClick the link below to verify your email:\n{link}'
        send_mail(
            subject,
            message,
            settings.DEFAULT_FROM_EMAIL,
            [user.email],
            fail_silently=False
        )

# ---------------------------
# Auth Serializers
# ---------------------------

class LoginSerializer(Serializer.Serializer):
    email = Serializer.EmailField()
    password = Serializer.CharField(write_only=True)

    def validate(self, attrs):
        email = attrs.get('email')
        password = attrs.get('password')

        if not email or not password:
            raise Serializer.ValidationError("Email and password are required.")

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            raise Serializer.ValidationError("Invalid email or password.")

        if not user.check_password(password):
            raise Serializer.ValidationError("Invalid email or password.")

        if not user.is_verified:
            raise Serializer.ValidationError("Email not verified. Please check your inbox.")

        attrs['user'] = user
        return attrs

class LogoutSerializer(Serializer.Serializer):
    def validate(self, attrs):
        return attrs

# ---------------------------
# Password Reset
# ---------------------------

class PasswordResetSerializer(Serializer.Serializer):
    email = Serializer.EmailField()

    def validate_email(self, value):
        if not User.objects.filter(email=value).exists():
            raise Serializer.ValidationError("Email not found.")
        return value

class PasswordResetConfirmSerializer(Serializer.Serializer):
    new_password = Serializer.CharField(write_only=True)
    token = Serializer.CharField()
    uid = Serializer.CharField()

    def validate(self, attrs):
        uid = attrs.get('uid')
        token = attrs.get('token')
        new_password = attrs.get('new_password')

        if not uid or not token or not new_password:
            raise Serializer.ValidationError("UID, token, and new password are required.")

        try:
            uid = urlsafe_base64_decode(uid).decode()
            user = User.objects.get(pk=uid)
        except (TypeError, ValueError, OverflowError, User.DoesNotExist):
            raise Serializer.ValidationError("Invalid UID.")

        if not default_token_generator.check_token(user, token):
            raise Serializer.ValidationError("Invalid or expired token.")

        user.set_password(new_password)
        user.save()

        return attrs

# ---------------------------
# Email Verification Placeholder (Handled via View)
# ---------------------------

class VerifyEmailSerializer(Serializer.Serializer):
    # Optional placeholder for POST method
    email = Serializer.EmailField()
