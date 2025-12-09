CREATE VIEW IF NOT EXISTS user_analytics AS
SELECT 
    u.user_id,    
    -- Número de carrinhos do usuário
    COUNT(DISTINCT c.cart_id) AS total_carts,    
    -- Número de produtos distintos em todos os carrinhos (por usuário)
    COUNT(DISTINCT ci.product_id) AS total_products,    
    --  Média de produtos por carrinho, arredondado
    ROUND(
        CAST(COUNT(ci.product_id) AS REAL) / NULLIF(COUNT(DISTINCT c.cart_id), 0), 2
    ) AS avg_products_per_cart,    
    -- Número de categorias diferentes de produtos comprados
    COUNT(DISTINCT p.category) AS distinct_categories,    
    -- Preço do produto mais caro do usuário (retorna 0 se não houver compras)
    COALESCE(MAX(p.price), 0) AS most_expensive_product,    
    -- Soma dos preços dos produtos (assumindo uma unidade por produto)
    COALESCE(SUM(p.price), 0) AS total_value
FROM
    users u
    LEFT OUTER JOIN carts c ON u.user_id = c.user_id
    LEFT OUTER JOIN cart_items ci ON c.cart_id = ci.cart_id
    LEFT OUTER JOIN products p ON ci.product_id = p.product_id
GROUP BY 
    u.user_id;