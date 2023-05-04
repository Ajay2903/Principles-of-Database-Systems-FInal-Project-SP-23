from django.shortcuts import render

# Create your views here.

from rest_framework import viewsets

from .serializers import *

class AttractionsAPI(viewsets.ModelViewSet):
    serializer_class = AttractionsSerializer
    queryset = Attractions.objects.all()[:5]

class  PaymentsAPI(viewsets.ModelViewSet):
    serializer_class = PaymentsSerializer
    queryset =  Payments.objects.all()[:5]

class ShowsAPI(viewsets.ModelViewSet):
    serializer_class = ShowsSerializer
    queryset = Shows.objects.all()[:5]

class StorcategoriesAPI(viewsets.ModelViewSet):
    serializer_class = StorcategoriesSerializer
    queryset = Storcategories.objects.all()[:5]

class TicketAPI(viewsets.ModelViewSet):
    serializer_class = TicketSerializer
    queryset = Ticket.objects.all()[:5]

class VisitorsAPI(viewsets.ModelViewSet):
    serializer_class = VisitorsSerializer
    queryset = Visitors.objects.all()[:5]

class AttTickAPI(viewsets.ModelViewSet):
    serializer_class = AttTickSerializer
    queryset = AttTick.objects.all()[:5]

class CardAPI(viewsets.ModelViewSet):
    serializer_class = CardSerializer
    queryset = Card.objects.all()[:5]

class MenuitemsAPI(viewsets.ModelViewSet):
    serializer_class = MenuitemsSerializer
    queryset = Menuitems.objects.all()[:5]

class OrdersAPI(viewsets.ModelViewSet):
    serializer_class = OrdersSerializer
    queryset = Orders.objects.all()[:5]

class ParkingAPI(viewsets.ModelViewSet):
    serializer_class = ParkingSerializer
    queryset = Parking.objects.all()[:5]

class StoresAPI(viewsets.ModelViewSet):
    serializer_class = StoresSerializer
    queryset = Stores.objects.all()[:5]
