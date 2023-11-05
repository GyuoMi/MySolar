CREATE OR REPLACE FUNCTION calculate_weekly_totals(id INT)
RETURNS JSON AS $$
DECLARE
    total_production FLOAT;
    total_grid FLOAT;
    total_solar FLOAT;
    total_usage FLOAT;
BEGIN
    -- Calculate total_production in kW hours for the past 7 days based on records_tbl
    SELECT SUM(device_tbl.device_wattage * records_tbl.records_minutes / 60)
    INTO total_production
    FROM records_tbl
    INNER JOIN device_tbl ON records_tbl.device_id = device_tbl.device_id
    WHERE records_tbl.user_id = id AND records_tbl.records_time >= NOW() - INTERVAL '7 days' AND device_tbl.device_usage = true;

    -- Calculate total_grid and total_solar for the past 7 days based on device_tbl
    SELECT SUM(CASE WHEN device_tbl.device_usage = false AND device_tbl.device_normal = true
                    THEN device_tbl.device_wattage * records_tbl.records_minutes / 60 ELSE 0 END)
    INTO total_grid
    FROM records_tbl
    INNER JOIN device_tbl ON records_tbl.device_id = device_tbl.device_id
    WHERE records_tbl.user_id = id AND records_tbl.records_time >= NOW() - INTERVAL '7 days';

    SELECT SUM(CASE WHEN device_tbl.device_usage = false AND device_tbl.device_normal = false
                    THEN device_tbl.device_wattage * records_tbl.records_minutes / 60 ELSE 0 END)
    INTO total_solar
    FROM records_tbl
    INNER JOIN device_tbl ON records_tbl.device_id = device_tbl.device_id
    WHERE records_tbl.user_id = id AND records_tbl.records_time >= NOW() - INTERVAL '7 days';


    -- Return the calculated values as a JSON object
    RETURN json_build_object(
        'total_production', total_production,
        'total_grid', total_grid,
        'total_solar', total_solar,
        'total_usage', total_grid + total_solar
    );
END;
$$ LANGUAGE plpgsql;