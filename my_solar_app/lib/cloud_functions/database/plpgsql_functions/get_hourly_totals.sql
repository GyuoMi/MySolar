CREATE OR REPLACE FUNCTION get_hourly_totals(id INT)
RETURNS JSON AS $$

DECLARE
    result JSON;
BEGIN
    SELECT json_agg(
        json_build_object(
            'record_interval', TO_CHAR(calculate_hourly_totals.record_interval, 'HH24:MI'),
            'total_production', calculate_hourly_totals.total_production_power,
            'total_usage', calculate_hourly_totals.total_usage_power,
            'total_solar', calculate_hourly_totals.total_solar_power
        )
    ) INTO result
    FROM calculate_hourly_totals(id);

    RETURN result;
END;
$$ LANGUAGE plpgsql;