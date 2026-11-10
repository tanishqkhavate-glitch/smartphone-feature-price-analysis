/*
Project: Smartphone Feature–Price Analysis
Database: SMART PHONE DATABASE
Source table: smartphone_cleaned
Analysis view: smartphone_analysis

The view excludes the seven records flagged for manual verification.
Run this script after importing smartphone_cleaned and creating the view.

Notes:
- The meaning and scale of the source rating field are unverified.
- AVG(rating) ignores NULL values in PostgreSQL.
- The RAM, storage, and 5G comparisons filter to records with a rating,
  matching the counts used in the original analysis outputs.
- Other sections count records with the relevant feature available.
*/

-- ============================================================
-- 0. Create analysis view
-- ============================================================

CREATE OR REPLACE VIEW smartphone_analysis AS
SELECT *
FROM smartphone_cleaned
WHERE needs_review = FALSE;


-- ============================================================
-- 1. Dataset size and target-segment count
-- ============================================================

SELECT
    COUNT(*) AS total_phones,
    COUNT(*) FILTER (WHERE price < 20000) AS phones_under_20k
FROM smartphone_analysis;


-- ============================================================
-- 2. Price-band distribution
-- ============================================================

SELECT
    price_band,
    COUNT(*) AS phone_count,
    ROUND(
        COUNT(*)::numeric * 100
        / SUM(COUNT(*)) OVER (),
        1
    ) AS dataset_share_pct,
    ROUND(AVG(price)::numeric, 0) AS avg_price,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY price)::numeric,
        0
    ) AS median_price,
    MIN(price) AS min_price,
    MAX(price) AS max_price
FROM smartphone_analysis
GROUP BY price_band
ORDER BY
    CASE price_band
        WHEN 'Below 10K' THEN 1
        WHEN '10K-15K' THEN 2
        WHEN '15K-20K' THEN 3
        WHEN '20K-30K' THEN 4
        WHEN '30K-50K' THEN 5
        WHEN '50K-1L' THEN 6
        WHEN 'Above 1L' THEN 7
    END;


-- ============================================================
-- 3. RAM vs price and rating score
-- Counts represent phones with a non-NULL rating.
-- Groups with fewer than 3 rated phones are excluded.
-- ============================================================

SELECT
    price_band,
    ram_capacity,
    COUNT(*) AS rated_phone_count,
    ROUND(AVG(price)::numeric, 0) AS avg_price,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY price)::numeric,
        0
    ) AS median_price,
    ROUND(AVG(rating)::numeric, 1) AS avg_rating_score
FROM smartphone_analysis
WHERE rating IS NOT NULL
GROUP BY price_band, ram_capacity
HAVING COUNT(*) >= 3
ORDER BY
    CASE price_band
        WHEN 'Below 10K' THEN 1
        WHEN '10K-15K' THEN 2
        WHEN '15K-20K' THEN 3
        WHEN '20K-30K' THEN 4
        WHEN '30K-50K' THEN 5
        WHEN '50K-1L' THEN 6
        WHEN 'Above 1L' THEN 7
    END,
    ram_capacity;


-- ============================================================
-- 4. Internal storage vs price and rating score
-- Counts represent phones with a non-NULL rating.
-- Groups with fewer than 3 rated phones are excluded.
-- ============================================================

SELECT
    price_band,
    internal_memory AS storage_gb,
    COUNT(*) AS rated_phone_count,
    ROUND(AVG(price)::numeric, 0) AS avg_price,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY price)::numeric,
        0
    ) AS median_price,
    ROUND(AVG(rating)::numeric, 1) AS avg_rating_score
FROM smartphone_analysis
WHERE rating IS NOT NULL
GROUP BY price_band, internal_memory
HAVING COUNT(*) >= 3
ORDER BY
    CASE price_band
        WHEN 'Below 10K' THEN 1
        WHEN '10K-15K' THEN 2
        WHEN '15K-20K' THEN 3
        WHEN '20K-30K' THEN 4
        WHEN '30K-50K' THEN 5
        WHEN '50K-1L' THEN 6
        WHEN 'Above 1L' THEN 7
    END,
    internal_memory;


-- ============================================================
-- 5. 5G vs non-5G comparison by price band
-- Counts represent phones with a non-NULL rating and known 5G flag.
-- ============================================================

SELECT
    price_band,
    has_5g,
    COUNT(*) AS rated_phone_count,
    ROUND(AVG(price)::numeric, 0) AS avg_price,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY price)::numeric,
        0
    ) AS median_price,
    ROUND(AVG(rating)::numeric, 1) AS avg_rating_score
FROM smartphone_analysis
WHERE rating IS NOT NULL
  AND has_5g IS NOT NULL
GROUP BY price_band, has_5g
ORDER BY
    CASE price_band
        WHEN 'Below 10K' THEN 1
        WHEN '10K-15K' THEN 2
        WHEN '15K-20K' THEN 3
        WHEN '20K-30K' THEN 4
        WHEN '30K-50K' THEN 5
        WHEN '50K-1L' THEN 6
        WHEN 'Above 1L' THEN 7
    END,
    has_5g;


-- ============================================================
-- 6. Battery capacity groups across all price bands
-- Counts include phones with a known battery capacity.
-- ============================================================

SELECT
    price_band,
    CASE
        WHEN battery_capacity < 4000 THEN 'Below 4000'
        WHEN battery_capacity < 5000 THEN '4000-4999'
        ELSE '5000+'
    END AS battery_category,
    COUNT(*) AS phone_count,
    ROUND(AVG(price)::numeric, 0) AS avg_price,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY price)::numeric,
        0
    ) AS median_price,
    ROUND(AVG(rating)::numeric, 1) AS avg_rating_score
FROM smartphone_analysis
WHERE battery_capacity IS NOT NULL
GROUP BY price_band, battery_category
ORDER BY
    CASE price_band
        WHEN 'Below 10K' THEN 1
        WHEN '10K-15K' THEN 2
        WHEN '15K-20K' THEN 3
        WHEN '20K-30K' THEN 4
        WHEN '30K-50K' THEN 5
        WHEN '50K-1L' THEN 6
        WHEN 'Above 1L' THEN 7
    END,
    MIN(battery_capacity);


-- ============================================================
-- 7. Processor brand comparison in the target segment
-- ============================================================

SELECT
    processor_brand,
    COUNT(*) AS phone_count,
    ROUND(AVG(price)::numeric, 0) AS avg_price,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY price)::numeric,
        0
    ) AS median_price,
    ROUND(AVG(rating)::numeric, 1) AS avg_rating_score
FROM smartphone_analysis
WHERE price >= 15000
  AND price < 20000
GROUP BY processor_brand
ORDER BY phone_count DESC;


-- ============================================================
-- 8. Processor speed groups in the target segment
-- Counts include phones with a known processor speed.
-- ============================================================

SELECT
    CASE
        WHEN processor_speed < 2.0 THEN 'Below 2.0 GHz'
        WHEN processor_speed < 2.5 THEN '2.0-2.49 GHz'
        ELSE '2.5+ GHz'
    END AS speed_category,
    COUNT(*) AS phone_count,
    ROUND(AVG(price)::numeric, 0) AS avg_price,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY price)::numeric,
        0
    ) AS median_price,
    ROUND(AVG(rating)::numeric, 1) AS avg_rating_score
FROM smartphone_analysis
WHERE price >= 15000
  AND price < 20000
  AND processor_speed IS NOT NULL
GROUP BY speed_category
ORDER BY MIN(processor_speed);


-- ============================================================
-- 9. Rear camera megapixel groups in the target segment
-- Counts include phones with a known primary rear-camera value.
-- ============================================================

SELECT
    CASE
        WHEN primary_camera_rear < 50 THEN 'Below 50 MP'
        WHEN primary_camera_rear < 100 THEN '50-99 MP'
        ELSE '100+ MP'
    END AS camera_category,
    COUNT(*) AS phone_count,
    ROUND(AVG(price)::numeric, 0) AS avg_price,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY price)::numeric,
        0
    ) AS median_price,
    ROUND(AVG(rating)::numeric, 1) AS avg_rating_score
FROM smartphone_analysis
WHERE price >= 15000
  AND price < 20000
  AND primary_camera_rear IS NOT NULL
GROUP BY camera_category
ORDER BY MIN(primary_camera_rear);
