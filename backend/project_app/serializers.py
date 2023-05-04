from rest_framework import serializers
from .models import *


class AttractionsSerializer(serializers.ModelSerializer):
    class Meta:
        model=Attractions
        fields = "__all__"

class PaymentsSerializer(serializers.ModelSerializer):
    class Meta:
        model=Payments
        fields = "__all__"

class ShowsSerializer(serializers.ModelSerializer):
    class Meta:
        model=Shows
        fields = "__all__"

class StorcategoriesSerializer(serializers.ModelSerializer):
    class Meta:
        model=Storcategories
        fields = "__all__"

class TicketSerializer(serializers.ModelSerializer):
    class Meta:
        model=Ticket
        fields = "__all__"

class VisitorsSerializer(serializers.ModelSerializer):
    class Meta:
        model=Visitors
        fields = "__all__"
class AttTickSerializer(serializers.ModelSerializer):
    class Meta:
        model=AttTick
        fields = "__all__"

class CardSerializer(serializers.ModelSerializer):
    class Meta:
        model=Card
        fields = "__all__"

class MenuitemsSerializer(serializers.ModelSerializer):
    class Meta:
        model=Menuitems
        fields = "__all__"

class OrdersSerializer(serializers.ModelSerializer):
    class Meta:
        model=Orders
        fields = "__all__"

class ParkingSerializer(serializers.ModelSerializer):
    class Meta:
        model=Parking
        fields = "__all__"

class StoresSerializer(serializers.ModelSerializer):
    class Meta:
        model=Stores
        fields = "__all__"

