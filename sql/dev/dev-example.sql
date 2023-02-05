SELECT
    DATE_TRUNC(executionDate, MONTH) AS month
FROM
    `<your-table-name>`
WHERE
    executionDate <= CURRENT_DATE()
GROUP BY
    executionDate
ORDER BY
    month