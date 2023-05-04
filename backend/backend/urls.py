from django.contrib import admin
from django.urls import path, include
from rest_framework import routers
from project_app import views

router = routers.DefaultRouter()

router.register('Attractions', views.AttractionsAPI)
router.register('Payments', views.PaymentsAPI)
router.register('Shows', views.ShowsAPI)
router.register('Storcategories', views.StorcategoriesAPI)
router.register('Ticket', views.TicketAPI)
router.register('Visitors', views.VisitorsAPI)
router.register('AttTick', views.AttTickAPI)
router.register('Card', views.CardAPI)
router.register('Menuitems', views.MenuitemsAPI)
router.register('Order', views.OrdersAPI)
router.register('Parking', views.ParkingAPI)
router.register('Stores', views.StoresAPI)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include(router.urls))
]



