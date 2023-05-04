from django.contrib import admin
from project_app import models

# Register your models here.

from . import *

admin.site.register(models.Attractions)
admin.site.register(models.Payments)
admin.site.register(models.Shows)
admin.site.register(models.Storcategories)
admin.site.register(models.Ticket)
admin.site.register(models.Visitors) 
admin.site.register(models.AttTick)
admin.site.register(models.Card)
admin.site.register(models.Menuitems)
admin.site.register(models.Orders)
admin.site.register(models.Parking)
admin.site.register(models.Stores) 