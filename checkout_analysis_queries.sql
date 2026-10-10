-- PayPal branded checkout case study
-- IMPORTANT: All analysis uses synthetic demonstration data, not PayPal internal data.
-- SQL is written for SQLite and should require minimal changes for other SQL engines.

-- 1. Basic data quality checks
SELECT COUNT(*) AS total_sessions,
       COUNT(DISTINCT session_id) AS unique_sessions,
       SUM(CASE WHEN purchase_completed = 1 THEN 1 ELSE 0 END) AS completed_purchases
FROM synthetic_checkout_sessions;

-- 2. Funnel totals and stage conversion rates.
-- Each rate uses the immediately preceding stage as its denominator.
SELECT
    SUM(product_view) AS product_views,
    SUM(cart_created) AS carts,
    ROUND(100.0 * SUM(cart_created) / NULLIF(SUM(product_view), 0), 2) AS product_to_cart_pct,
    SUM(checkout_started) AS checkout_starts,
    ROUND(100.0 * SUM(checkout_started) / NULLIF(SUM(cart_created), 0), 2) AS cart_to_checkout_pct,
    SUM(payment_method_selected) AS payment_method_selections,
    ROUND(100.0 * SUM(payment_method_selected) / NULLIF(SUM(checkout_started), 0), 2) AS checkout_to_selection_pct,
    SUM(payment_attempted) AS payment_attempts,
    ROUND(100.0 * SUM(payment_attempted) / NULLIF(SUM(payment_method_selected), 0), 2) AS selection_to_attempt_pct,
    SUM(payment_authorized) AS authorized_payments,
    ROUND(100.0 * SUM(payment_authorized) / NULLIF(SUM(payment_attempted), 0), 2) AS attempt_to_authorization_pct,
    SUM(purchase_completed) AS purchases,
    ROUND(100.0 * SUM(purchase_completed) / NULLIF(SUM(checkout_started), 0), 2) AS checkout_start_to_purchase_pct
FROM synthetic_checkout_sessions;

-- 3. Compare checkout outcomes by device.
SELECT device_type,
       COUNT(*) AS sessions,
       SUM(checkout_started) AS checkout_starts,
       SUM(purchase_completed) AS purchases,
       ROUND(100.0 * SUM(purchase_completed) / NULLIF(SUM(checkout_started), 0), 2) AS checkout_completion_pct
FROM synthetic_checkout_sessions
GROUP BY device_type
ORDER BY checkout_completion_pct DESC;

-- 4. Compare standard vs redesigned checkout.
SELECT checkout_version,
       COUNT(*) AS sessions,
       SUM(checkout_started) AS checkout_starts,
       SUM(purchase_completed) AS purchases,
       ROUND(100.0 * SUM(purchase_completed) / NULLIF(SUM(checkout_started), 0), 2) AS checkout_completion_pct,
       ROUND(100.0 * SUM(payment_authorized) / NULLIF(SUM(payment_attempted), 0), 2) AS authorization_rate_pct
FROM synthetic_checkout_sessions
GROUP BY checkout_version;

-- 5. Compare authentication readiness cohorts.
SELECT auth_ready,
       COUNT(*) AS sessions,
       SUM(checkout_started) AS checkout_starts,
       SUM(purchase_completed) AS purchases,
       ROUND(100.0 * SUM(purchase_completed) / NULLIF(SUM(checkout_started), 0), 2) AS checkout_completion_pct
FROM synthetic_checkout_sessions
GROUP BY auth_ready;

-- 6. Payment failure mix among sessions with a checkout start.
SELECT failure_category,
       COUNT(*) AS sessions,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM synthetic_checkout_sessions
                                  WHERE checkout_started = 1), 2) AS pct_of_checkout_starts
FROM synthetic_checkout_sessions
WHERE checkout_started = 1
GROUP BY failure_category
ORDER BY sessions DESC;

-- 7. Segment view: device and checkout version.
SELECT device_type, checkout_version,
       SUM(checkout_started) AS checkout_starts,
       SUM(purchase_completed) AS purchases,
       ROUND(100.0 * SUM(purchase_completed) / NULLIF(SUM(checkout_started), 0), 2) AS completion_pct
FROM synthetic_checkout_sessions
GROUP BY device_type, checkout_version
ORDER BY device_type, checkout_version;

-- 8. BNPL eligible/exposed comparison.
-- Observational comparisons are not causal; exposure was simulated and may be selected.
SELECT bnpl_eligible, bnpl_exposed,
       SUM(checkout_started) AS checkout_starts,
       SUM(purchase_completed) AS purchases,
       ROUND(100.0 * SUM(purchase_completed) / NULLIF(SUM(checkout_started), 0), 2) AS completion_pct
FROM synthetic_checkout_sessions
GROUP BY bnpl_eligible, bnpl_exposed;

-- 9. Daily trend.
SELECT session_date,
       SUM(checkout_started) AS checkout_starts,
       SUM(purchase_completed) AS purchases,
       ROUND(100.0 * SUM(purchase_completed) / NULLIF(SUM(checkout_started), 0), 2) AS completion_pct
FROM synthetic_checkout_sessions
GROUP BY session_date
ORDER BY session_date;

-- 10. Revenue proxy: completed orders only.
-- This is simulated gross order value, NOT PayPal revenue or payment volume.
SELECT checkout_version,
       COUNT(*) AS completed_orders,
       ROUND(SUM(order_value_usd), 2) AS completed_order_value_usd,
       ROUND(AVG(order_value_usd), 2) AS average_order_value_usd
FROM synthetic_checkout_sessions
WHERE purchase_completed = 1
GROUP BY checkout_version;
