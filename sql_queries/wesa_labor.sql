
 SELECT gia_locations.location_name AS "Department Description",
		EXTRACT(month FROM emp_hou_bal.balance_start_dt::date) ||
		'/' ||
		EXTRACT(day FROM emp_hou_bal.balance_start_dt::date) ||
		'/' ||
		EXTRACT(year FROM emp_hou_bal.balance_start_dt::date)
		AS "Date",
    sum(
        CASE
            WHEN emp_hou_bal.paycode_name = ANY (ARRAY['REG'::text, 'TRNG'::text]) THEN emp_hou_bal.hours
            ELSE 0::numeric
        END) AS "Regular Hours",
    sum(
        CASE
            WHEN emp_hou_bal.paycode_name = ANY (ARRAY['REG'::text, 'TRNG'::text]) THEN emp_hou_bal.earnings
            ELSE 0::numeric
        END) AS "Regular Earnings",
    sum(
        CASE
            WHEN emp_hou_bal.paycode_name = 'OT'::text THEN emp_hou_bal.hours
            ELSE 0::numeric
        END) AS "Overtime Hours",
    sum(
        CASE
            WHEN emp_hou_bal.paycode_name = 'OT'::text THEN emp_hou_bal.earnings
            ELSE 0::numeric
        END) AS "Overtime Earnings",
    sum(
        CASE
            WHEN emp_hou_bal.paycode_name = 'BRVMT'::text THEN emp_hou_bal.hours
            ELSE 0::numeric
        END) AS "Bereav Hours",
    sum(
        CASE
            WHEN emp_hou_bal.paycode_name = 'BRVMT'::text THEN emp_hou_bal.earnings
            ELSE 0::numeric
        END) AS "Bereav Earnings",
    sum(
        CASE
            WHEN emp_hou_bal.paycode_name = ANY (ARRAY['STATH'::text, 'STATS'::text, 'STATW'::text]) THEN emp_hou_bal.hours
            ELSE 0::numeric
        END) AS "Holiday Hours",
    sum(
        CASE
            WHEN emp_hou_bal.paycode_name = ANY (ARRAY['STATH'::text, 'STATS'::text, 'STATW'::text]) THEN emp_hou_bal.earnings
            ELSE 0::numeric
        END) AS "Holiday Earnings",
    sum(
        CASE
            WHEN emp_hou_bal.paycode_name = ANY (ARRAY['VACH'::text, 'VAC'::text, 'WELL'::text, 'WELL-Covid'::text, 'PDSUS'::text, 'EBKTK'::text, 'PBKTK'::text,'PDLOA'::text]) THEN emp_hou_bal.hours
            ELSE 0::numeric
        END) AS "PTO Hours",
    sum(
        CASE
            WHEN emp_hou_bal.paycode_name = ANY (ARRAY['VACH'::text, 'VAC'::text, 'WELL'::text, 'WELL-Covid'::text, 'PDSUS'::text, 'EBKTK'::text, 'PBKTK'::text,'PDLOA'::text]) THEN emp_hou_bal.earnings
            ELSE 0::numeric
        END) AS "PTO Earnings",
    0 AS "FMLA Hours",
    0 AS "FMLA Earnings"
   FROM dw.emp_hou_bal
     LEFT JOIN dw.gia_locations ON emp_hou_bal.location_id = gia_locations.location_id
  WHERE emp_hou_bal.balance_start_dt = (CURRENT_DATE - '1 day'::interval) AND gia_locations.current_version_flg = 'Y'::text
  AND emp_hou_bal.paycode_name !~~ 'Analytics%'::text AND emp_hou_bal.paycode_name != 'Worked Hours'::text 
  AND (emp_hou_bal.paycode_name <> ALL (ARRAY['$WKND'::text, 'LATE'::text, 'NPD S'::text, 'NPD V'::text, 'NPDLV'::text, 'NOSHW'::text, 'NPWCB'::text, 'NPSUS'::text, 
											 'FLEX'::text, 'FLEX TK'::text, 'Un-Approved OT'::text, 'EDUC'::text, 'VACPO'::text, 'VACPT'::text, 'RETRO'::text, 'Worked Hours'::text]))
  AND emp_hou_bal.fin_dept_id = ANY (ARRAY['500'::text, '528'::text, '501'::text])
  AND emp_hou_bal.volunteer = 'N'
  GROUP BY gia_locations.location_name, emp_hou_bal.balance_start_dt;


