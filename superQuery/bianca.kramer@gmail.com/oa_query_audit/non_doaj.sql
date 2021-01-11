WITH NewTable AS (
SELECT
  journal_issn_l,
  CASE WHEN countif(journal_is_in_doaj) > 0 THEN TRUE 
  ELSE FALSE
  END
    as journal_is_in_doaj,
  CASE WHEN countif(journal_is_oa) > 0 THEN TRUE 
  ELSE FALSE
  END
    as journal_is_oa,
  CASE WHEN countif(best_oa_location.host_type = "publisher")/count(doi) = 1 THEN TRUE 
  ELSE FALSE
  END
    as journal_is_100_oa,
countif(is_oa)/count(doi) AS perc_oa,
countif(best_oa_location.host_type = "publisher")/count(doi) AS perc_publisher_oa,
count(doi) AS doi,
--the two categories below are ONLY used to further analyze non-DOAJ (and non journal_is_oa) journals
countif(best_oa_location.host_type = "publisher" AND best_oa_location.license is not NULL)/count(doi) AS perc_hybrid,
countif(best_oa_location.host_type = "publisher" AND best_oa_location.license is NULL)/count(doi) AS perc_bronze,

FROM `@table`
WHERE (
  year IN (2020)
  and journal_issn_l IS NOT NULL
  --and genre = "journal-article"
  )

GROUP BY journal_issn_l
ORDER BY journal_issn_l
)

SELECT
  journal_is_in_doaj,
  journal_is_oa,
  journal_is_100_oa,
  count(journal_issn_l) as journal_issn_l,
  sum(doi) as dois,
  --the categories below are ONLY used to analyze non-DOAJ (and non journal_is_oa) journals
  countif(perc_hybrid = 1) as labeled_hybrid_all,
  countif(perc_hybrid > 0 and perc_bronze = 0) as labeled_hybrid_only,
  countif(perc_hybrid > 0 and perc_bronze > 0) as labeled_hybrid_and_bronze,
  countif(perc_hybrid = 0 and perc_bronze > 0) as labeled_bronze_only,
  countif(perc_bronze = 1) as labeled_bronze_all
  
  
FROM NewTable
--WHERE(doi > 10)

GROUP BY 
  journal_is_in_doaj,
  journal_is_oa,
  journal_is_100_oa
  
ORDER BY
  journal_is_in_doaj,
  journal_is_oa,
  journal_is_100_oa