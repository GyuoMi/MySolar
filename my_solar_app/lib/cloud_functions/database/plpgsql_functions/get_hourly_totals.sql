DECLARE
    result JSON;
BEGIN
    SELECT json_agg(
        json_build_object(
            'record_interval', calculate_hourly_totals.record_interval,
            'total_production', calculate_hourly_totals.total_production_power,
            'total_usage', calculate_hourly_totals.total_usage_power
        )
    ) INTO result
    FROM calculate_hourly_totals(id);

    RETURN result;
END;