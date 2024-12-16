
SELECT
A.as_of_date
,A.as_of_date_l
,A.cusip
,A.factset_entity_id
,A.fsym_id

-- Price & Market Cap
/**/

,MAX(A.price_ent) price_ent
,MAX(A.volume_ent) volume_ent
,MAX(A.tr_1m_ent) tr_1m_ent
,MAX(A.shrsout_fp_ent) shrsout_fp_ent
,MAX(A.mktcap_fp_ent) mktcap_fp_ent
,MAX(A.div_ent) div_ent
,MAX(A.divSpec_ent) divSpec_ent
,MAX(A.divSpin_ent) divSpin_ent
 

-- Financial Statement Data
 
-- Sales
,MAX(qf_ltm.ff_sales) ff_sales_ltm
,MAX(af.ff_sales) ff_sales_a
,MAX(qf_ltm_l.ff_sales) ff_sales_ltm_l
,MAX(af_l.ff_sales) ff_sales_a_l
-- Gross Income
,MAX(qf_ltm.ff_gross_inc) ff_gross_inc_ltm
,MAX(af.ff_gross_inc) ff_gross_inc_a
,MAX(qf_ltm_l.ff_gross_inc) ff_gross_inc_ltm_l
,MAX(af_l.ff_gross_inc) ff_gross_inc_a_l
-- EBITDA
,MAX(qdf_ltm.ff_ebitda_oper) ff_ebitda_oper_ltm
,MAX(adf.ff_ebitda_oper) ff_ebitda_oper_a
,MAX(qdf_ltm_l.ff_ebitda_oper) ff_ebitda_oper_ltm_l
,MAX(adf_l.ff_ebitda_oper) ff_ebitda_oper_a_l
-- EBIT
,MAX(qdf_ltm.ff_ebit_oper) ff_ebit_oper_ltm
,MAX(adf.ff_ebit_oper) ff_ebit_oper_a
,MAX(qdf_ltm_l.ff_ebit_oper) ff_ebit_oper_ltm_l
,MAX(adf_l.ff_ebit_oper) ff_ebit_oper_a_l
-- Interest Expense
,MAX(qdf_ltm.ff_int_exp_net) ff_int_exp_net_ltm
,MAX(adf.ff_int_exp_net) ff_int_exp_net_a
,MAX(qdf_ltm_l.ff_int_exp_net) ff_int_exp_net_ltm_l
,MAX(adf_l.ff_int_exp_net) ff_int_exp_net_a_l
-- Net Income
,MAX(qf_ltm.ff_net_income) ff_net_income_ltm
,MAX(af.ff_net_income) ff_net_income_a
,MAX(qf_ltm_l.ff_net_income) ff_net_income_ltm_l
,MAX(af_l.ff_net_income) ff_net_income_a_l
-- Current Assets
,MAX(qf_c.ff_assets_curr) ff_assets_curr_c
,MAX(af.ff_assets_curr) ff_assets_curr_a
,MAX(af_l.ff_assets_curr) ff_assets_curr_a_l
-- Inventory
,MAX(qf_c.ff_inven) ff_inven_c
,MAX(af.ff_inven) ff_inven_a
,MAX(af_l.ff_inven) ff_inven_a_l
-- Total Assets
,MAX(qf_c.ff_assets) ff_assets_c
,MAX(af.ff_assets) ff_assets_a
,MAX(af_l.ff_assets) ff_assets_a_l
-- Current Liabilities
,MAX(qf_c.ff_liabs_curr) ff_liabs_curr_c
,MAX(af.ff_liabs_curr) ff_liabs_curr_a
,MAX(af_l.ff_liabs_curr) ff_liabs_curr_a_l
-- Total Debt
,MAX(qf_c.ff_debt) ff_debt_c
,MAX(af.ff_debt) ff_debt_a
,MAX(af_l.ff_debt) ff_debt_a_l
-- Shareholders Equity
,MAX(qf_c.ff_shldrs_eq) ff_shldrs_eq_c
,MAX(af.ff_shldrs_eq) ff_shldrs_eq_a
,MAX(af_l.ff_shldrs_eq) ff_shldrs_eq_a_l
-- Operating CashFlow
,MAX(qdf_ltm.ff_oper_cf) ff_oper_cf_ltm
,MAX(adf.ff_oper_cf) ff_oper_cf_a
,MAX(qdf_ltm_l.ff_oper_cf) ff_oper_cf_ltm_l
,MAX(adf_l.ff_oper_cf) ff_oper_cf_a_l


,IIF(MAX(A.currency) = 'USD',1,MAX(curr_q_c.exch_rate_usd)) as fx_q_c
,IIF(MAX(A.currency) = 'USD',1,MAX(curr_q_ltm.exch_rate_usd)) as fx_q_ltm
,IIF(MAX(A.currency) = 'USD',1,MAX(curr_af.exch_rate_usd)) as fx_af
,IIF(MAX(A.currency) = 'USD',1,MAX(curr_af_l.exch_rate_usd)) as fx_af_l
,IIF(MAX(A.currency) = 'USD',1,MAX(curr_q_ltm_l.exch_rate_usd)) as fx_q_ltm_l

--,MAX()


FROM(
SELECT 
univ.as_of_date
,univ.as_of_date_l
,univ.cusip
,univ.factset_entity_id
,MAX(univ.fsym_id) fsym_id
,MAX(univ.current_fsym_id) current_fsym_id
,MAX(univ.ticker) ticker
,MAX(univ.industry3code) industry3code
,MAX(univ.maturity) maturity
,MAX(univ.rating) rating
,MAX(univ.duration) duration
,MAX(univ.oas) oas
,MAX(univ.eff_yield) eff_yield
,MAX(univ.face_val) face_val
,MAX(univ.mkt_val) mkt_val


--,COUNT(fsym_id) reg_id_cnt
,MAX(univ.[des]) [des]
,MAX(univ.currency) as currency
/**/
,SUM(p_price*shrsout_fp)/SUM(shrsout_fp) price_ent
,SUM(volume) volume_ent
,SUM(tr_1m*mktcap_fp)/SUM(mktcap_fp) tr_1m_ent
,SUM(shrsout_fp) shrsout_fp_ent
,SUM(mktcap_fp) mktcap_fp_ent
,SUM(isnull(div,0)) AS div_ent
,SUM(isnull(divSpec,0)) AS divSpec_ent
,SUM(isnull(divSpin,0)) AS divSpin_ent


FROM(
SELECT 
EOMONTH(univ.as_of_date) as_of_date
,EOMONTH(univ.as_of_date,-12) as_of_date_l
,univ.[index]
,univ.[des]
,univ.cusip
,univ.ticker
,univ.industry3code
,univ.maturity
,univ.rating
,univ.sprd_duration as duration
,univ.oas
,univ.eff_yield
,univ.face_val
,univ.mkt_val
--> Add other universe fields here.
,ultimate.fsym_id as current_fsym_id
,region_id.fsym_id
,cov.currency
,cov.fsym_security_id
,ent.factset_entity_id
/**/
,px.p_price
,px_edate.volume
,px_tr.tr_1m
,so_dates.p_com_shs_out AS shrsout_fp
,px.p_price*so_dates.p_com_shs_out AS mktcap_fp
,isnull(sumdiv.sumDiv,0) AS div
,isnull(sumdiv.sumDivSpec,0) AS divSpec
,isnull(sumdiv.sumDivSpin,0) AS divSpin

,ff_cov.ff_gen_ind
,px_edate.fsym_id fsym_id_px_edate

FROM Server.DB.baml_universe_holdings univ

INNER JOIN Server.DB.baml_cusip_fsym_mapping ultimate
on univ.cusip = ultimate.cusip

INNER JOIN Server.DB.fds_corporate_fsym_mapping region_id
ON 
univ.[index] = region_id.[index]
AND univ.cusip = region_id.cusip
AND EOMONTH(univ.as_of_date,0) BETWEEN region_id.[min_date] AND region_id.[max_date]

-- `cov` ----------------------------------------------------------------------------------------
LEFT JOIN (SELECT fsym_id, fsym_security_id, fref_listing_exchange, currency FROM Server2.DB.[sym_coverage] 
where sym_coverage.fsym_id = sym_coverage.fsym_regional_id
) as cov
ON region_id.fsym_id = cov.fsym_id COLLATE Latin1_General_100_CI_AS

-- `ent` ----------------------------------------------------------------------------------------
--> Security ID from sym_coverage = fsym_id in sec_entity
/**/
JOIN 
(SELECT * FROM 
Server2.DB.fp_sec_entity 
)
ent 
ON cov.fsym_security_id = ent.fsym_id COLLATE Latin1_General_100_CI_AS

-- join on entity related data ----------------------------------------------------------------------------------------

JOIN ( 
Select * FROM Server2.DB.ff_sec_coverage 
WHERE ff_is_adr = 0 AND ((ff_iscomp = 1 AND ff_is_multi_share=0) OR (ff_is_multi_share=1 AND ff_is_dually_listed=0))
) ff_cov ON ff_cov.fsym_id = cov.fsym_id  
/**/
----------------------------------------------------------------------------------------
/* fp_sec_coverage - Not really sure how/why its used, removes a lot of obs, no dependencies, is this for US equities only? */
/**/
JOIN (
Select * FROM Server2.DB.fp_sec_coverage 
WHERE currency = 'USD' 
AND p_sec_type_code IN ('10','11','12','13') 
-- what do the p_sec_type_code 
) fp_cov 
ON cov.fsym_id = fp_cov.fsym_id 

----------------------------------------------------------------------------------------
/* Exchange map? Not really sure how/why its used, removes a lot of obs. */
/**/
JOIN (
SELECT * FROM Server2.DB.fref_sec_exchange_map exch_map WHERE exch_map.fref_exchange_location_code ='US') ref_exch
ON cov.fref_listing_exchange = ref_exch.fref_exchange_code

----------------------------------------------------------------------------------------
--> Commenting out returns about 25% more records (for 2024-07-30), so considerable on a historical basis.
/* Returns ltrade_date and volumen for each fsym_id */
LEFT JOIN
(
    SELECT C.fsym_id, MAX(C.p_date) ltrade_date, 
    SUM(iif(p_date<=p_split_date,p_volume/isnull(p_split_factor, 1),p_volume)) volume 
    FROM
    (
    SELECT a.fsym_id, a.p_date, a.p_volume, p_split_factor, p_split_date 
    FROM
    (
        Select fsym_id, p_date, p_volume
        FROM Server2.DB.fp_basic_prices px
  -- ask about this
        WHERE px.currency = 'USD'
    ) a
    LEFT JOIN Server2.DB.fp_basic_splits b
    ON a.fsym_id = b.fsym_id AND
    eomonth(a.p_date,0) = eomonth(b.p_split_date,0)
    ) C
    GROUP BY fsym_id, eomonth(p_date,0)
) px_edate
ON cov.fsym_id = px_edate.fsym_id
AND eomonth(univ.as_of_date,0) = eomonth(px_edate.ltrade_date,0) 
/**/
-------------------------------------------------------------------------------
--> Prices Table. 
/**/
LEFT JOIN Server2.DB.fp_basic_prices px
 ON cov.fsym_id = px.fsym_id
 AND px_edate.ltrade_date = px.p_date
 
-------------------------------------------------------------------------------
--> Total Returns.
/**/
LEFT JOIN 
(SELECT fsym_id, eomonth(p_date,0) eom_date
    , EXP(SUM(LOG(1+iif(one_day_pct<=-100,-99.99999999999,one_day_pct)/100)))-1 AS tr_1m 
    FROM Server2.DB.fp_total_returns_daily
    GROUP BY fsym_id, EOMONTH(p_date,0) ) px_tr 
ON cov.fsym_id = px_tr.fsym_id 
AND eomonth(px.p_date,1) = px_tr.eom_date 

-------------------------------------------------------------------------------
--> Dividend Data: fsym_id mnth fstExDate sumDiv sumDivSpec sumDivSpin
/**/
LEFT JOIN
    (Select div.fsym_id, eomonth(div.p_divs_exdate,0) AS mnth, MIN(div.p_divs_exdate) AS fstExDate,
      SUM(isnull(div.p_divs_pd,0)) AS sumDiv, SUM(isnull(div.p_divs_s_pd*div.p_divs_pd,0)) AS sumDivSpec, 
      SUM(isnull(div.p_divs_s_spinoff*div.p_divs_pd,0)) AS sumDivSpin
      FROM
      Server2.DB.fp_basic_dividends AS div 
      GROUP BY div.fsym_id, eomonth(div.p_divs_exdate,0)) AS sumdiv
    ON cov.fsym_id = sumdiv.fsym_id 
    AND eomonth(px.p_date,1) = sumdiv.mnth

-------------------------------------------------------------------------------
--> Shares Outstanding Data
/**/
LEFT JOIN 
    (Select shrsout.fsym_id,shrsout.p_date
      ,LEAD(shrsout.p_date,1,'1/1/2300') OVER 
      (PARTITION BY fsym_id ORDER BY shrsout.p_date ASC) AS n_so_date
      , shrsout.p_com_shs_out
      FROM
      Server2.DB.fp_basic_shares_hist AS shrsout) AS so_dates
    ON cov.fsym_id = so_dates.fsym_id 
    AND univ.as_of_date>=so_dates.p_date
    AND univ.as_of_date<  so_dates.n_so_date
 
where ticker != 'CASH' 

) univ
GROUP BY univ.as_of_date
,univ.as_of_date_l
,univ.cusip
,univ.factset_entity_id
) A

 LEFT JOIN( 
 SELECT date,fsym_id 
 ,ff_assets_curr
 ,ff_inven
 ,ff_assets
 ,ff_liabs_curr
 ,ff_debt
 ,ff_shldrs_eq
 ,ff_com_shs_out
 ,ff_price_close_fp

 FROM Server2.DB.ff_basic_qf) qf_c ON 
 A.fsym_id = qf_c.fsym_id COLLATE Latin1_General_100_CI_AS
 AND eomonth(A.as_of_date,-3) <= eomonth(qf_c.date,0) AND eomonth(A.as_of_date,0) >= eomonth(qf_c.date,0)  
 
 
 LEFT JOIN( 
 SELECT date,fsym_id 
 ,ff_oper_cf
 ,ff_mkt_val
 ,ff_ebit_oper
 ,ff_ebitda_oper
 ,ff_int_exp_net

 FROM Server2.DB.ff_basic_der_qf) AS qdf_c ON 
 qf_c.fsym_id = qdf_c.fsym_id COLLATE Latin1_General_100_CI_AS
 AND qf_c.date = qdf_c.date

 LEFT JOIN( 
 SELECT date, fsym_id
 ,ff_sales
 ,ff_net_income
 ,ff_gross_inc


 FROM fds.[ff_v3].[ff_basic_ltm]) qf_ltm ON 
 A.fsym_id = qf_ltm.fsym_id COLLATE Latin1_General_100_CI_AS
 AND eomonth(A.as_of_date,-3) <= eomonth(qf_ltm.date,0) AND eomonth(A.as_of_date,0) >= eomonth(qf_ltm.date,0) 

 LEFT JOIN(
 SELECT date, fsym_id
 ,ff_oper_cf
 ,ff_mkt_val
 ,ff_ebit_oper
 ,ff_ebitda_oper
 ,ff_int_exp_net

 FROM Server2.DB.ff_basic_der_qf) AS qdf_ltm ON qf_ltm.fsym_id = qdf_ltm.fsym_id COLLATE Latin1_General_100_CI_AS
 AND qf_ltm.date = qdf_ltm.date

 LEFT JOIN(
 SELECT date, fsym_id
 ,ff_assets_curr
 ,ff_inven
 ,ff_assets
 ,ff_liabs_curr
 ,ff_debt
 ,ff_shldrs_eq
 ,ff_gross_inc
 ,ff_net_income
 ,ff_sales
 ,ff_com_shs_out
 ,ff_price_close_fp

 FROM Server2.DB.ff_basic_af) AS af ON A.fsym_id = af.fsym_id COLLATE Latin1_General_100_CI_AS
 AND eomonth(A.as_of_date,-12) <= eomonth(af.date,0) AND eomonth(A.as_of_date,0) >= eomonth(af.date,0) 

 LEFT JOIN(
 SELECT date, fsym_id
 ,ff_oper_cf
 ,ff_mkt_val
 ,ff_ebit_oper
 ,ff_ebitda_oper
 ,ff_int_exp_net
 FROM Server2.DB.ff_basic_der_af ) AS adf ON af.fsym_id = adf.fsym_id COLLATE Latin1_General_100_CI_AS
 AND af.date = adf.date

 LEFT JOIN(
 SELECT date, fsym_id
 ,ff_sales
 ,ff_net_income
 ,ff_gross_inc

 FROM fds.[ff_v3].[ff_basic_ltm]) AS qf_ltm_l ON A.fsym_id = qf_ltm_l.fsym_id COLLATE Latin1_General_100_CI_AS
 AND eomonth(A.as_of_date_l,-3) <= eomonth(qf_ltm_l.date,0) AND eomonth(A.as_of_date_l,0) >= eomonth(qf_ltm_l.date,0) 

 LEFT JOIN(
 SELECT date, fsym_id
 ,ff_oper_cf
 ,ff_mkt_val
 ,ff_ebit_oper
 ,ff_ebitda_oper
 ,ff_int_exp_net
 FROM Server2.DB.ff_basic_der_qf) AS qdf_ltm_l ON qf_ltm.fsym_id = qdf_ltm_l.fsym_id COLLATE Latin1_General_100_CI_AS
 AND qf_ltm_l.date = qdf_ltm_l.date

 LEFT JOIN(
 SELECT date, fsym_id
 ,ff_assets_curr
 ,ff_inven
 ,ff_assets
 ,ff_liabs_curr
 ,ff_debt
 ,ff_shldrs_eq
 ,ff_gross_inc
 ,ff_sales
 ,ff_net_income
 ,ff_com_shs_out
 ,ff_price_close_fp

 FROM Server2.DB.ff_basic_af) af_l ON A.fsym_id = af_l.fsym_id COLLATE Latin1_General_100_CI_AS
 AND eomonth(A.as_of_date_l,-12) <= eomonth(af_l.date,0) AND eomonth(A.as_of_date_l,0) >= eomonth(af_l.date,0) 


 LEFT JOIN(
 SELECT date, fsym_id
 ,ff_oper_cf
 ,ff_mkt_val
 ,ff_ebit_oper
 ,ff_ebitda_oper
 ,ff_int_exp_net
 FROM Server2.DB.ff_basic_der_af) AS adf_l ON af_l.fsym_id = adf_l.fsym_id COLLATE Latin1_General_100_CI_AS
 AND af_l.date = adf_l.date

LEFT JOIN Server.DB.view_fds_fx_rates_usd curr_q_c ON A.currency = curr_q_c.iso_currency AND qf_c.date = curr_q_c.date
LEFT JOIN Server.DB.view_fds_fx_rates_usd curr_q_ltm ON A.currency = curr_q_ltm.iso_currency AND qf_ltm.date = curr_q_ltm.date
LEFT JOIN Server.DB.view_fds_fx_rates_usd curr_af ON A.currency = curr_af.iso_currency AND af.date = curr_af.date
LEFT JOIN view_fds_fx_rates_usd curr_q_ltm_l ON A.currency = curr_q_ltm_l.iso_currency AND qf_ltm_l.date = curr_q_ltm_l.date
LEFT JOIN view_fds_fx_rates_usd curr_af_l ON A.currency = curr_af_l.iso_currency AND af_l.date = curr_af_l.date
group by 
A.as_of_date
,A.as_of_date_l
,A.cusip
,A.factset_entity_id
,A.fsym_id
