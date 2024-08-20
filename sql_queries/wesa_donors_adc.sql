SELECT DISTINCT 
	replace(replace(don_counts.location_id, '010', '1000'),'090','9000') AS "Store_no",
    don_counts.don_dt AS "PostingDate",
    sum(don_counts.count) AS "No_of_ADC_Donors"
FROM dw.don_counts
LEFT JOIN dw.gia_locations ON don_counts.location_id = gia_locations.location_id
WHERE don_counts.dedupe_flg = 'Y'::text 
	AND (don_counts.count_type <> ALL (ARRAY['Total'::text, 'Hr Sum'::text, 'Vol. Hrs'::text])) 
	AND (gia_locations.location_type = ANY (ARRAY['D'::text, 'W'::text, 'I'::text, 'B'::text])) 
	AND don_counts.don_dt = (CURRENT_DATE - '1 day'::interval)
	AND gia_locations.current_version_flg = 'Y'::text
GROUP BY don_counts.location_id, don_counts.don_dt;
