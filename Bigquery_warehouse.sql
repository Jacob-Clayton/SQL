SELECT 
  Warehouse.warehouse_id,
  CONCAT(warehouse.state,' ', warehouse.warehouse_alias) AS warehouse_name,
  COUNT(Orders.order_id) AS number_of_orders,
  (SELECT
    COUNT(*)
    FROM warehouse_orders.orders Orders)
  AS total_orders,
  CASE
    WHEN COUNT(Orders.order_id)/(SELECT COUNT(*) FROM warehouse_orders.orders Orders) <= 0.20
    THEN "Fulfilled 0-20% of Orders"
    WHEN COUNT(Orders.order_id)/(SELECT COUNT(*) FROM warehouse_orders.orders Orders) > 0.20
    AND COUNT(Orders.order_id)/(SELECT COUNT(*) FROM warehouse_orders.orders Orders) <= 0.60
    THEN "Fulfilled 21-60% of Orders"
  ELSE "Fulfilled more than 60% of Orders"
  END AS fulfillment_summary
FROM warehouse_orders.warehouse Warehouse
LEFT JOIN warehouse_orders.orders Orders 
  ON Orders.warehouse_id = Warehouse.warehouse_id
  GROUP BY 
    Warehouse.warehouse_id,
    warehouse_name
  HAVING
    COUNT(Orders.order_id) >0