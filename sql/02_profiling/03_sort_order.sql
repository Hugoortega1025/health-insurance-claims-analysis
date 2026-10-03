-- View if the data is sorted by claim_amount in ascending order
WITH ordered AS (
    SELECT
        Id,
        claim,
        LAG(claim) OVER (ORDER BY Id) AS prev_claim
    FROM insurance
)
SELECT
    COUNT(*) AS rows_out_of_order
FROM ordered
WHERE claim < prev_claim;