
-- Query 1: Validate the dataset
SELECT
    COUNT(*) AS total_sessions,
    COUNT(DISTINCT session_id) AS unique_sessions,
    SUM(purchase_completed) AS completed_purchases
FROM synthetic_checkout_sessions;

-- Query 2: Preview 10 records
SELECT *
FROM synthetic_checkout_sessions
LIMIT 10;

-- Query 3: Check for missing session IDs
SELECT COUNT(*) AS missing_session_ids
FROM synthetic_checkout_sessions
WHERE session_id IS NULL OR session_id = '';
