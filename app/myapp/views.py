from django.http import JsonResponse
from django.views import View


class HealthCheckView(View):
    def get(self, request):
        return JsonResponse({'status': 'healthy', 'message': 'Django app is running'})


class HomeView(View):
    def get(self, request):
        return JsonResponse({
            'message': 'Welcome to the Django app deployed on AWS ECS!',
            'version': '1.0.0'
        })
