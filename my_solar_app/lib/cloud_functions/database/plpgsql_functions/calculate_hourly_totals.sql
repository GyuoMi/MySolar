CREATE OR REPLACE FUNCTION calculate_hourly_totals(id INT)
RETURNS TABLE (
    record_interval TIME,
    total_production_power FLOAT,
    total_usage_power FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        time_intervals.record_interval,
        COALESCE(SUM(CASE WHEN device_tbl.device_usage = true THEN (device_tbl.device_wattage * records_tbl.records_minutes / 60.0) ELSE 0 END), 0) AS total_production_power,
        COALESCE(SUM(CASE WHEN device_tbl.device_usage = false THEN (device_tbl.device_wattage * records_tbl.records_minutes / 60.0) ELSE 0 END), 0) AS total_usage_power
    FROM (
        SELECT '00:00:00'::TIME AS record_interval
        UNION ALL SELECT '04:00:00'::TIME
        UNION ALL SELECT '08:00:00'::TIME
        UNION ALL SELECT '12:00:00'::TIME
        UNION ALL SELECT '16:00:00'::TIME
        UNION ALL SELECT '20:00:00'::TIME
    ) AS time_intervals
    LEFT JOIN records_tbl ON
        records_tbl.records_time::TIME >= time_intervals.record_interval
        AND records_tbl.records_time::TIME < time_intervals.record_interval + '4 hours'::INTERVAL
        AND DATE(records_tbl.records_time) = CURRENT_DATE
        AND records_tbl.user_id = id
    LEFT JOIN device_tbl ON
        records_tbl.device_id = device_tbl.device_id
    GROUP BY time_intervals.record_interval
    ORDER BY time_intervals.record_interval;
END;
$$ LANGUAGE plpgsql;