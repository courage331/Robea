extends Control

var payment

signal purchase_success(item_name)
signal purchase_fail
signal purchase_cancel
signal purchase_owned(item_name)
signal has_purchased(item_name)
signal consume_success(item_name)
signal consume_fail
signal consume_not_required
signal sku_details_complete
signal sku_details_error

func _ready():
	if Engine.has_singleton("GodotPayments"):
		payment = Engine.get_singleton("GodotPayments")
	else:
		print("GodotPayment singleton is only available on Android devices.")

	if payment:
		# set callback with this script instance
		payment.setPurchaseCallbackId(get_instance_id())

	set_auto_consume(false)
	connect("purchase_success", self, "on_purchase_success")
	connect("purchase_fail", self, "on_purchase_fail")
	connect("purchase_cancel", self, "on_purchase_cancel")
	connect("purchase_owned", self, "on_purchase_owned")
	connect("has_purchased", self, "on_has_purchased")
	connect("consume_success", self, "on_consume_success")
	connect("consume_fail", self, "on_consume_fail")
	connect("sku_details_complete", self, "on_sku_details_complete")
	sku_details_query(["remove_advertisement"])
	request_purchased()	#구매했는지 확인 


func _on_Button_pressed():
	Global.goto_scene("res://SceneFolder/MainScene.tscn")

func _on_Button2_pressed():
	Global.goto_scene("res://SceneFolder/MainScene.tscn")

func _on_Button3_pressed():
	get_node("Explain_sprite").visible = true

func _on_Button4_pressed():
	$Label.text = str(payment)
	purchase("remove_advertisement")

func on_sku_details_complete():
	$Label.text = "price: " + str(sku_details["remove_advertisement"].price)

func on_has_purchased(item_name): #이미 소유했으면 구매 못하게
	if item_name == null:
		$Label.text = "You don't have " + str(item_name)
	else:
		$Button4.visible = false
		$Label.text = "You already got " + str(item_name)

func on_purchase_success():
	$Label.text = "purchase success"

func on_purchase_fail():
	$Label.text = "purchase fail"

func on_purchase_owed(item_name):
	$Label.text = "purchase owed: " + str(item_name)

func on_purchase_cancel():
	$Label.text = "purchase cancel"

# set consume purchased item automatically after purchase, defulat value is true
func set_auto_consume(auto):
	if payment:
		payment.setAutoConsume(auto)

# request user owned item, callback : has_purchased
func request_purchased():
	if payment:
		payment.requestPurchased()

func has_purchased(_receipt, _signature, sku):
	if sku == "":
		print("has_purchased : nothing")
		emit_signal("has_purchased", null)
	else:
		print("has_purchased : ", sku)
		emit_signal("has_purchased", sku)

# purchase item
# callback : purchase_success, purchase_fail, purchase_cancel, purchase_owned
func purchase(item_name):
	if payment:
		# transaction_id could be any string that used for validation internally in java
		payment.purchase(item_name, "transaction_id")

func purchase_success(_receipt, _signature, sku):
	print("purchase_success : ", sku)
	emit_signal("purchase_success", sku)

func purchase_fail():
	print("purchase_fail")
	emit_signal("purchase_fail")

func purchase_cancel():
	print("purchase_cancel")
	emit_signal("purchase_cancel")

func purchase_owned(sku):
	print("purchase_owned : ", sku)
	emit_signal("purchase_owned", sku)

# consume purchased item
# callback : consume_success, consume_fail
func consume(item_name):
	if payment:
		payment.consume(item_name)

# consume all purchased items
func consume_all():
	if payment:
		payment.consumeUnconsumedPurchases()

func consume_success(_receipt, _signature, sku):
	print("consume_success : ", sku)
	emit_signal("consume_success", sku)

# if consume fail, need to call request_purchased() to get purchase token from google
# then try to consume again
func consume_fail():
	emit_signal("consume_fail")

# no purchased item to consume
func consume_not_required():
	emit_signal("consume_not_required")


# detail info of IAP items
# sku_details = {
#     product_id (String) : {
#         type (String),
#         product_id (String),
#         title (String),
#         description (String),
#         price (String),  # this can be used to display price for each country with their own currency
#         price_currency_code (String),
#         price_amount (float)
#     },
#     ...
# }
var sku_details = {}

# query for details of IAP items
# callback : sku_details_complete
func sku_details_query(list):
	if payment:
		var sku_list = PoolStringArray(list)
		payment.querySkuDetails(sku_list)

func sku_details_complete(result):
	print("sku_details_complete : ", result)
	for key in result.keys():
		sku_details[key] = result[key]
	emit_signal("sku_details_complete")

func sku_details_error(error_message):
	print("error_sku_details = ", error_message)
	emit_signal("sku_details_error")
