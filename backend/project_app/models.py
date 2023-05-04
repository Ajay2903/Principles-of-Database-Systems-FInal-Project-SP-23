# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Attractions(models.Model):
    attraction_id = models.IntegerField(primary_key=True)
    attraction_name = models.CharField(max_length=50)
    description = models.CharField(max_length=100)
    attraction_type = models.CharField(max_length=50)
    status = models.CharField(max_length=20)
    capacity = models.IntegerField()
    minimunheight = models.DecimalField(max_digits=5, decimal_places=2)
    duration = models.TimeField()
    location_section = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'ATTRACTIONS'


class Payments(models.Model):
    payment_id = models.IntegerField(primary_key=True)
    payment_method = models.CharField(max_length=15)
    payment_date = models.DateField()
    payment_amount = models.DecimalField(max_digits=5, decimal_places=2)

    class Meta:
        managed = False
        db_table = 'PAYMENTS'


class Shows(models.Model):
    show_id = models.IntegerField(primary_key=True)
    show_name = models.CharField(max_length=50)
    description = models.CharField(max_length=100)
    show_type = models.CharField(max_length=10)
    start_time = models.TimeField()
    end_time = models.TimeField()
    wheelchair_accessible = models.CharField(max_length=1)
    price = models.DecimalField(max_digits=5, decimal_places=2)
    visits_visit_id = models.IntegerField()
    orders_order = models.ForeignKey('Orders', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'SHOWS'


class Storcategories(models.Model):
    cat_id = models.IntegerField(primary_key=True)
    category = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'STORCATEGORIES'


class Ticket(models.Model):
    ticket_id = models.IntegerField(primary_key=True)
    ticket_method = models.CharField(max_length=10)
    ticket_purchase_date = models.DateField()
    ticket_visit_date = models.DateField()
    discount = models.DecimalField(max_digits=5, decimal_places=2)
    ticket_price = models.DecimalField(max_digits=5, decimal_places=2)
    ticket_type = models.CharField(max_length=10)
    orders_order_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'TICKET'


class Visitors(models.Model):
    visitor_id = models.IntegerField(primary_key=True)
    visitor_fname = models.CharField(max_length=20)
    visitor_email_address = models.CharField(max_length=20)
    visitor_phone_number = models.BigIntegerField()
    visitor_dob = models.DateField()
    visitor_type = models.CharField(max_length=10)
    visitor_lname = models.CharField(max_length=10)
    address_street = models.CharField(max_length=50, blank=True, null=True)
    zipcode = models.IntegerField()
    address_city = models.CharField(max_length=20, blank=True, null=True)
    address_state = models.CharField(max_length=2, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'VISITORS'


class Vistors(models.Model):
    visitor_id = models.IntegerField(primary_key=True)
    visitor_fname = models.CharField(max_length=20)
    visitor_email_address = models.CharField(max_length=20)
    visitor_phone_number = models.BigIntegerField()
    visitor_dob = models.DateField()
    visitor_type = models.CharField(max_length=10)
    visitor_lname = models.CharField(max_length=10)
    address_street = models.CharField(max_length=50, blank=True, null=True)
    zipcode = models.IntegerField()
    address_city = models.CharField(max_length=20, blank=True, null=True)
    address_state = models.CharField(max_length=2, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'VISTORS'


class AttTick(models.Model):
    ticket_visit_date = models.DateField()
    ticket_ticket = models.ForeignKey(Ticket, models.DO_NOTHING)
    attractions_attraction = models.ForeignKey(Attractions, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'att_tick'


class Card(models.Model):
    payment = models.OneToOneField(Payments, models.DO_NOTHING, primary_key=True)
    fname_on_card = models.CharField(max_length=20)
    card_type = models.CharField(max_length=10)
    card_number = models.BigIntegerField()
    exparation_date = models.DateField()
    cvvnumber = models.IntegerField()
    lname_on_card = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'card'


class Menuitems(models.Model):
    menuitem_id = models.IntegerField(primary_key=True)
    description = models.CharField(max_length=50)
    unitprice = models.DecimalField(max_digits=5, decimal_places=2)
    stores_store = models.ForeignKey('Stores', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'menuitems'


class Orders(models.Model):
    order_id = models.IntegerField(primary_key=True)
    order_date = models.DateField()
    quantity = models.IntegerField()
    visitors_visitor = models.ForeignKey(Visitors, models.DO_NOTHING)
    stores_store = models.ForeignKey('Stores', models.DO_NOTHING)
    payments_payment = models.ForeignKey(Payments, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'orders'


class Parking(models.Model):
    parking_id = models.IntegerField(primary_key=True)
    parking_lot = models.CharField(max_length=1)
    spot_number = models.IntegerField()
    time_in = models.TimeField()
    time_out = models.TimeField()
    fee = models.DecimalField(max_digits=5, decimal_places=2)
    orders_order = models.ForeignKey(Orders, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'parking'


class Stores(models.Model):
    store_id = models.IntegerField(primary_key=True)
    store_name = models.CharField(max_length=30)
    storcategories_cat = models.ForeignKey(Storcategories, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'stores'
