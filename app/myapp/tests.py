from django.test import TestCase, Client
from django.urls import reverse


class HealthCheckViewTest(TestCase):
    def setUp(self):
        self.client = Client()

    def test_health_check_returns_200(self):
        response = self.client.get('/health/')
        self.assertEqual(response.status_code, 200)

    def test_health_check_returns_json(self):
        response = self.client.get('/health/')
        data = response.json()
        self.assertEqual(data['status'], 'healthy')

    def test_home_returns_200(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)

    def test_home_returns_json(self):
        response = self.client.get('/')
        data = response.json()
        self.assertIn('message', data)
