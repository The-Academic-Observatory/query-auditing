SELECT
  year,
  COUNT(doi) AS doi,
  COUNTIF(is_oa is TRUE) AS is_oa,
  COUNTIF(best_oa_location.host_type = "publisher") AS publisher,
  COUNTIF(best_oa_location.host_type = "repository") AS repository,
  COUNTIF(journal_is_in_doaj) AS full_gold_doaj,
  COUNTIF(journal_is_oa 
    AND NOT journal_is_in_doaj) AS full_gold_non_doaj,
  COUNTIF(best_oa_location.host_type = "publisher" 
    AND best_oa_location.license is not null
    AND NOT (journal_is_in_doaj OR journal_is_oa)) AS hybrid,
  COUNTIF(best_oa_location.host_type = "publisher" 
    AND best_oa_location.license is null
    AND NOT (journal_is_in_doaj OR journal_is_oa)) AS bronze,
  COUNTIF(best_oa_location.host_type = "repository") AS green_only,


FROM `@table`
WHERE (genre = 'posted-content' and year IN (2020,2019,2018,2017,2016))

GROUP BY year
ORDER BY year