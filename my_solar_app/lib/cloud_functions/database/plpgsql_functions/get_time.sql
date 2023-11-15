CREATE OR REPLACE FUNCTION get_time()
RETURNS JSON AS $$

DECLARE
    last_record_time TIMESTAMP;
    next_record_time TIMESTAMP;
BEGIN
    -- Set last_record_time and next_record_time to the current time rounded down to the nearest four-hour interval
    last_record_time := CURRENT_TIMESTAMP;
    last_record_time := CURRENT_DATE + ('00:00:00'::TIME+ (EXTRACT(HOUR FROM last_record_time)::INT / 4 * 4) * INTERVAL '1 HOUR');
    next_record_time := last_record_time + '4 hours'::INTERVAL;

    -- Create the result as a JSON object with the date included
    RETURN json_build_object(
      'recent_time', TO_CHAR(last_record_time, 'YYYY-MM-DD HH24:MI:SS'), -- Format the date
      'next_time', TO_CHAR(next_record_time, 'YYYY-MM-DD HH24:MI:SS')
    );
END;
$$ LANGUAGE plpgsql;