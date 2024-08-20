Drop table if exists public.sales1;
Drop table if exists public.sales2;

SELECT 
 	 a.balance_start_dt AS "Date",
	CAST(a.location_id AS TEXT) AS "StoreNo",
	'All' as "Cashier",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Accessories' THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "AccessoriesUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Accessories'::text THEN a.value ELSE 0::numeric END) AS "AccessoriesSales",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Jewellery'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "JewelryUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Jewellery'::text THEN a.value ELSE 0::numeric END) AS "JewelrySales",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Books'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "BookUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Books'::text THEN a.value ELSE 0::numeric END) AS "BookSales",
	sum(CASE WHEN a.pos_sub_dept_desc = 'AV'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "AVUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'AV'::text THEN a.value ELSE 0::numeric END) AS "AVSales",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Electrical'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "ElectricalUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Electrical'::text THEN a.value ELSE 0::numeric END) AS "ElectricalSales",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Furniture'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "FurnitureUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Furniture'::text THEN a.value ELSE 0::numeric END) AS "FurnitureSales",
	sum(CASE WHEN a.pos_sub_dept_desc = 'Outlet Furniture'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "OutletFurnitureUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Outlet Furniture'::text THEN a.value ELSE 0::numeric END) AS "OutletFurnitureSales",
	sum(CASE WHEN a.pos_dept_desc = 'Outlet'::text AND a.pos_sub_dept_desc != 'Outlet Furniture'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "OutletUnits",
    sum(CASE WHEN a.pos_dept_desc = 'Outlet'::text AND a.pos_sub_dept_desc != 'Outlet Furniture'::text THEN a.value ELSE 0::numeric END) AS "OutletSales",
	sum(CASE WHEN a.pos_sub_dept_desc = 'Footwear'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "ShoeUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Footwear'::text THEN a.value ELSE 0::numeric END) AS "ShoeSales",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Women'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "WomenUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Women'::text THEN a.value ELSE 0::numeric END) AS "WomenSales",
	sum(CASE WHEN a.pos_sub_dept_desc = 'Men'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "MenUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Men'::text THEN a.value ELSE 0::numeric END) AS "MenSales",
	sum(CASE WHEN a.pos_sub_dept_desc = 'Children'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "ChildrenUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Children'::text THEN a.value ELSE 0::numeric END) AS "ChildrenSales",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Boutique'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "BoutiqueUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Boutique'::text THEN a.value ELSE 0::numeric END) AS "BoutiqueSales",
	sum(CASE WHEN a.pos_sub_dept_desc = 'Linens'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "LinenUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Linens'::text THEN a.value ELSE 0::numeric END) AS "LinenSales",
	sum(CASE WHEN a.pos_sub_dept_desc = 'Collectibles'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "CollectiblesUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Collectibles'::text THEN a.value ELSE 0::numeric END) AS "CollectiblesSales",
	sum(CASE WHEN a.pos_sub_dept_desc = 'Sporting Goods'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "SportingGoodsUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Sporting Goods'::text THEN a.value ELSE 0::numeric END) AS "SportingGoodsSales",
	sum(CASE WHEN a.pos_sub_dept_desc = 'Toys'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "ToysUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Toys'::text THEN a.value ELSE 0::numeric END) AS "ToysSales",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Wares'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "WaresUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Wares'::text THEN a.value ELSE 0::numeric END) AS "WaresSales",
	sum(CASE WHEN a.pos_sub_dept_desc = ANY (ARRAY['Seasonal'::text, 'Christmas'::text, 'Halloween%'::text, 'Back to School'::text]) THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "SeasonalUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = ANY (ARRAY['Seasonal'::text, 'Christmas'::text, 'Halloween%'::text, 'Back to School'::text]) THEN a.value ELSE 0::numeric END) AS "SeasonalSales",
	sum(CASE WHEN a.pos_sub_dept_desc = 'Share The Good'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "ShareTheGoodUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Share The Good'::text THEN a.value ELSE 0::numeric END) AS "ShareTheGoodSales",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Events'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "EventsUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Events'::text THEN a.value ELSE 0::numeric END) AS "EventsSales",
	sum(CASE WHEN a.pos_sub_dept_desc = 'Commercial Services'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "Commercial-ICUnits",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Commercial Services'::text THEN a.value ELSE 0::numeric END) AS "Commercial-ICSales",
	sum(CASE WHEN a.pos_sub_dept_desc = 'Gift Card'::text THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "NoGiftCardsIssued",
    sum(CASE WHEN a.pos_sub_dept_desc = 'Gift Card'::text THEN a.value ELSE 0::numeric END) AS "TotalGiftCardsIssued",
	--sum(CASE WHEN a.pos_sub_dept_desc = 'Good Rewards Issued'::text THEN CAST(a.qty AS INTEGER) ELSE 0 END) AS "GoodRewardsUnits", this all zero
    --sum(CASE WHEN a.pos_sub_dept_desc = 'Good Rewards Issued'::text THEN a.value ELSE 0::numeric END) AS "GoodRewardsSales",
	sum(CASE WHEN a.pos_dept_desc = 'Donation'::text THEN CAST(a.qty AS INTEGER) ELSE 0 END) AS "ChangeRoundupUnits",
    sum(CASE WHEN a.pos_dept_desc = 'Donation'::text THEN a.value ELSE 0::numeric END) AS "ChangeRoundup",
	sum(CASE WHEN a.pos_sub_dept_desc ~~ ANY (ARRAY['20LB%'::text, 'Dept%'::text, 'Mask%'::text]) OR a.pos_dept_desc IS NULL THEN CAST(a.qty AS INTEGER)ELSE 0 END) AS "OtherUnits",
    sum(CASE WHEN a.pos_sub_dept_desc ~~ ANY (ARRAY['20LB%'::text, 'Dept%'::text, 'Mask%'::text]) OR a.pos_dept_desc IS NULL THEN a.value ELSE 0::numeric END) AS "OtherSales",
	--sum(CASE WHEN a.pos_dept_desc = 'Total Coupon Discounts'::text THEN CAST(a.qty AS INTEGER) ELSE 0 END) AS "DiscountsUnits", this is equal to Good Rewards down below
    --sum(CASE WHEN a.pos_dept_desc = 'Total Coupon Discounts'::text THEN a.value ELSE 0::numeric END) AS "DiscountsSales",
	0::numeric AS "TotalTax",
	sum(CASE WHEN CAST(a.location_id AS TEXT) != '' THEN a.value ELSE 0::numeric END) AS "DebugTotalSales"
 into sales1
   FROM dw.pos_upc_sales_bal_v  AS a
  WHERE a.balance_start_dt = (CURRENT_DATE - '1 day'::interval) 
  GROUP BY a.location_id, a.balance_start_dt;
 
SELECT	
	sum(CASE WHEN c.tally_id = '3102'::text THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "TransactionCount",
	sum(CASE WHEN c.tally_id = '130'::text THEN CAST(c.qty AS INTEGER) ELSE 0 END) AS "NoVISATransactions",
    sum(CASE WHEN c.tally_id = '130'::text THEN c.value ELSE 0::numeric END) AS "TotalVISACharges",
	sum(CASE WHEN c.tally_id = ANY (ARRAY['131'::text, '104'::text]) THEN CAST(c.qty AS INTEGER) ELSE 0 END) AS "NoMastercardTransactions",
    sum(CASE WHEN c.tally_id = ANY (ARRAY['131'::text, '104'::text]) THEN c.value ELSE 0::numeric END) AS "TotalMastercardCharges",
	sum(CASE WHEN c.tally_id = '132'::text THEN CAST(c.qty AS INTEGER) ELSE 0 END) AS "NoAMEXTransactions",
    sum(CASE WHEN c.tally_id = '132'::text THEN c.value ELSE 0::numeric END) AS "TotalAMEXCharges",
	sum(CASE WHEN c.tally_id = '133'::text THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "NoDiscoverTransactions",
    sum(CASE WHEN c.tally_id = '133'::text THEN c.value ELSE 0::numeric END) AS "TotalDiscoverCharges",
	sum(CASE WHEN c.tally_id = '103'::text THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "NoDebitTransactions",
    sum(CASE WHEN c.tally_id = '103'::text THEN c.value ELSE 0::numeric END) AS "TotalDebitCharges",
	0 AS "NoE-CheckTransactions",
	0 AS "TotalofE-ChecksCollected",
	sum(CASE WHEN c.tally_id = '102'::text THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "NoPaperCheckTransactions",
    sum(CASE WHEN c.tally_id = '102'::text THEN c.value ELSE 0::numeric END) AS "TotalPaperChecksCollected",
	sum(CASE WHEN c.tally_id = '135'::text THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "NoStoreCreditsRedeemed",
    sum(CASE WHEN c.tally_id = '135'::text THEN c.value ELSE 0::numeric END) AS "TotalStoreCreditsRedeemed",
	sum(CASE WHEN c.tally_id = ANY (ARRAY['124'::text, '134'::text]) THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "NoGiftCardsRedeemed",
    sum(CASE WHEN c.tally_id = ANY (ARRAY['124'::text, '134'::text]) THEN c.value ELSE 0::numeric END) AS "TotalGiftCardsRedeemed",
	sum(CASE WHEN c.tally_id = ANY (ARRAY['117'::text, '129'::text]) THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "NoGiftCertificatesRedeemed",
    sum(CASE WHEN c.tally_id = ANY (ARRAY['117'::text, '129'::text]) THEN c.value ELSE 0::numeric END) AS "TotalGiftCertificatesRedeemed",
	--sum(CASE WHEN c.tally_id = '134'::text THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "NoGoodwillGiftCardRedeemed",
    --sum(CASE WHEN c.tally_id = '134'::text THEN c.value ELSE 0::numeric END) AS "TotalGoodwillGiftCardRedeemed",
	sum(CASE WHEN c.tally_id = ANY (ARRAY['153'::text, '125'::text]) THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "NoVouchersRedeemed",
    sum(CASE WHEN c.tally_id = ANY (ARRAY['153'::text, '125'::text]) THEN c.value ELSE 0::numeric END) AS "TotalVouchersRedeemed",
	sum(CASE WHEN c.tally_id = '3303'::text THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "NoOtherCardTransactions", --same as GoodRewardsDiscount, but this is a tender
    sum(CASE WHEN c.tally_id = '3303'::text THEN c.value ELSE 0::numeric END) AS "TotalOtherCardCharges",
	--sum(CASE WHEN c.tally_id = '5105'::text THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "CashDonationUnits", included in ChangeRoudUp
    --sum(CASE WHEN c.tally_id = '5105'::text THEN c.value ELSE 0::numeric END) AS "CashDonation",
	--sum(CASE WHEN c.tally_id = '139'::text THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "ChangeRoundupUnits",
    --sum(CASE WHEN c.tally_id = '139'::text THEN c.value ELSE 0::numeric END) AS "ChangeRoundup",
	sum(CASE WHEN c.tally_id = '101'::text THEN c.value ELSE 0::numeric END) AS "ExpectedCash",
	sum(CASE WHEN c.tally_id = '101'::text THEN c.value ELSE 0::numeric END) AS "TotalCashDeposit", --hand-counted cash
	0 AS "TotalChecksDeposit",
	sum(CASE WHEN c.tally_id = '1007'::text THEN c.value ELSE 0::numeric END) AS "PettyCash",
	sum(CASE WHEN c.tally_id = '3303'::text THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "NoGoodRewardsDiscount",
    sum(CASE WHEN c.tally_id = '3303'::text THEN c.value*-1 ELSE 0::numeric END) AS "TotalGoodRewardsDiscount",
	sum(CASE WHEN c.tally_id = '3343'::text THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "NoTMDiscount",
    sum(CASE WHEN c.tally_id = '3343'::text THEN c.value*-1 ELSE 0::numeric END) AS "TotalTMDiscount",
	sum(CASE WHEN c.tally_id = '3328'::text THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "NoSeniorsDiscount",
    sum(CASE WHEN c.tally_id = '3328'::text THEN c.value*-1 ELSE 0::numeric END) AS "TotalSeniorsDiscount",
	sum(CASE WHEN c.tally_id = ANY (ARRAY['3301'::text, '3302'::text]) THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "NoOtherDiscount",
    sum(CASE WHEN c.tally_id = ANY (ARRAY['3301'::text, '3302'::text]) THEN c.value*-1 ELSE 0::numeric END) AS "TotalOtherDiscount",
	--sum(CASE WHEN c.tally_cat_desc = 'Discount'::text THEN CAST(c.qty AS INTEGER)ELSE 0 END) AS "NoTotalDiscount",
    --sum(CASE WHEN c.tally_cat_desc = 'Discount'::text THEN c.value*-1 ELSE 0::numeric END) AS "TotalTotalDiscount",
	c.location_id AS "StoreNo2",
    c.balance_start_dt AS "Date2"
 into sales2
   FROM dw.pos_clk_sales_bal AS c
  WHERE c.balance_start_dt = (CURRENT_DATE - '1 day'::interval) 
  GROUP BY c.location_id, c.balance_start_dt;
  
 SELECT * FROM
 sales1
 JOIN
 sales2
ON sales1."StoreNo" = sales2."StoreNo2" AND sales1."Date" = sales2."Date2"
;
