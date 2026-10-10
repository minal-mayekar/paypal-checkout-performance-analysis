# PayPal Branded Checkout — Step 3 Data Pack

## Purpose
Demonstrate how a Business Analyst can structure checkout funnel data and investigate conversion, payment outcomes, and segment differences using SQL.

## Data provenance
**This is synthetic demonstration data. It is not PayPal internal data, not a PayPal export, and not an estimate of PayPal's actual checkout performance.** All session-level values and relationships were generated for practice. Public PayPal statements inform the case-study question only.

## Files
- `synthetic_checkout_sessions.csv`: 5,000 synthetic session-level rows.
- `checkout_analysis_queries.sql`: SQL checks, funnel metrics, segmentation queries, and trends.
- `data_dictionary.csv`: field definitions and caveats.

## Suggested workflow
1. Load the CSV into SQLite, PostgreSQL, SQL Server, or another database.
2. Run the data quality query.
3. Run the funnel query and validate denominators.
4. Compare segments by device, checkout version, and authentication readiness.
5. Treat observed synthetic differences as practice outputs only. Do not claim they describe PayPal.
6. For real causal claims, use a properly designed randomized experiment or appropriate causal method with actual authorized data.

## Metric definitions
- Stage conversion rate = sessions reaching next stage / sessions reaching prior stage.
- Checkout start-to-purchase rate = completed purchases / checkout starts.
- Authorization rate = authorized attempts / payment attempts.
- Simulated completed order value is not PayPal revenue, TPV, or net revenue.

## Key caveat
The synthetic data-generating process includes deliberately modeled relationships to make analysis exercises possible. The data is not suitable for inferring real-world effect sizes or making actual PayPal business claims.
