
 SELECT DISTINCT gia_locations.location_name AS "StoreName",
    don_counts.don_dt AS "Date",
    sum(don_counts.count) AS "GGCDonors",
    0 AS "TextilesHung",
    0 AS "TextilesRotated",
    0 AS "LabourHours",
    0 AS "OtherLabourHrs"
   FROM dw.don_counts
     LEFT JOIN dw.gia_locations ON don_counts.location_id = gia_locations.location_id
  WHERE don_counts.dedupe_flg = 'Y'::text AND (don_counts.count_type <> ALL (ARRAY['Total'::text, 'Hr Sum'::text, 'Vol. Hrs'::text])) 
  AND gia_locations.location_type = 'R'::text 
  AND don_counts.don_dt = (CURRENT_DATE - '1 day'::interval)
  AND gia_locations.current_version_flg = 'Y'::text
  GROUP BY gia_locations.location_name, don_counts.don_dt;


