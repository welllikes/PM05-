WITH mat_cost AS (
    SELECT 
        p.production_id AS ID_production,
        SUM(pm.quantity * pr.value) AS cost
    FROM prod_materials pm
    JOIN price pr ON pr.nomenclature_id = pm.nomenclature_id
    JOIN production p ON p.production_id = pm.production_id
    GROUP BY p.production_id
)

SELECT 
    c.name                AS покупатель,
    co.order_id           AS заказ,
    SUM(pp.quantity)      AS всего_изготовлено,
    SUM(mc.cost)          AS стоимость_материалов_в_заказе
FROM contractor c
JOIN customer_order co ON c.contractor_id = co.contractor_id
JOIN order_item oi ON oi.order_id = co.order_id
JOIN specification s ON s.product_id = oi.product_id
JOIN production p ON p.specification_id = s.specification_id
JOIN prodprod pp ON pp.production_id = p.production_id
JOIN mat_cost mc ON mc.ID_production = p.production_id
WHERE c.buyer = TRUE
GROUP BY c.name, co.order_id
ORDER BY c.name, co.order_id;