SELECT 
  UPPER(TRIM(doi)) as doi,
  year,
  genre as output_type,
  publisher,
  journal_name,
  is_oa,
  journal_is_in_doaj as is_in_doaj,
  IF(is_oa,IF(best_oa_location.license IS NOT NULL, TRUE, FALSE), FALSE)                                                                      as has_license,
  IF(is_oa, IF(best_oa_location.license IS NOT NULL, IF( STARTS_WITH(best_oa_location.license, "cc"), TRUE, FALSE), FALSE), FALSE)            as is_cclicensed,
  best_oa_location.license                                                                                                                    as has_specified_license,  
  IF(journal_is_in_doaj, TRUE, FALSE)                                                                                                         as gold_just_doaj,
  IF(journal_is_in_doaj OR (best_oa_location.host_type = "publisher" AND best_oa_location.license is not null AND not journal_is_in_doaj), 
  TRUE, FALSE)                                                                                                                                as gold,
  IF(not journal_is_in_doaj AND best_oa_location.host_type = "publisher" AND best_oa_location.license is not null, TRUE, FALSE)               as hybrid,
  IF((SELECT COUNT(1) FROM UNNEST(oa_locations) AS location WHERE location.host_type IN ('repository')) > 0, TRUE, FALSE)                     as green,
  (SELECT COUNT(1) FROM UNNEST(oa_locations) AS location WHERE location.host_type IN ('repository')) > 0 AND
  (SELECT COUNT(1) FROM UNNEST(oa_locations) AS location WHERE location.host_type IN ('publisher')) = 0                                       as green_only,
  (SELECT COUNT(1) FROM UNNEST(oa_locations) AS location WHERE location.host_type IN ('repository')) > 0 AND NOT
  (NOT journal_is_in_doaj AND (best_oa_location.host_type = "publisher" AND best_oa_location.license is not null))                            as green_only_ingnoring_bronze,
  IF(is_oa, if(best_oa_location.host_type = "publisher" AND best_oa_location.license is null AND not journal_is_in_doaj, TRUE, FALSE), FALSE) as bronze,
  ARRAY((SELECT url FROM UNNEST(oa_locations) WHERE host_type = "repository"))                                                                as repository_locations,
  best_oa_location.url_for_landing_page,
  best_oa_location.url_for_pdf
FROM 
  @table