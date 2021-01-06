SELECT
  UPPER(TRIM(doi)) as doi,
  is_oa,
  journal_is_in_doaj as is_in_doaj,
  
  CASE 
    WHEN journal_is_in_doaj OR (best_oa_location.host_type = "publisher" AND best_oa_location.license is not null AND not journal_is_in_doaj) THEN TRUE
    ELSE FALSE
  END 
    as gold,
  
  CASE
    WHEN journal_is_in_doaj THEN TRUE
    ELSE FALSE
  END 
    as gold_just_doaj,
  
  CASE
    WHEN (best_oa_location.host_type = "publisher" AND best_oa_location.license is not null AND not journal_is_in_doaj) THEN TRUE
    ELSE FALSE
  END 
    as hybrid,
  
  CASE
    WHEN (best_oa_location.host_type = "publisher" AND best_oa_location.license is not null AND not journal_is_in_doaj) THEN TRUE
    ELSE FALSE
  END
    as bronze,
  
  CASE
    WHEN (SELECT COUNT(1) FROM UNNEST(oa_locations) AS location WHERE location.host_type IN ('repository')) > 0 THEN TRUE
    ELSE FALSE
  END
    as green,
  
  CASE
    WHEN (SELECT COUNT(1) FROM UNNEST(oa_locations) AS location WHERE location.host_type IN ('repository')) > 0 AND 
      NOT (journal_is_in_doaj OR best_oa_location.host_type = "publisher") THEN TRUE
    ELSE FALSE
  END 
    as green_only,
    
  CASE
    WHEN (SELECT COUNT(1) FROM UNNEST(oa_locations) AS location WHERE location.host_type IN ('repository')) > 0 AND 
      NOT (journal_is_in_doaj OR (best_oa_location.host_type = "publisher" AND best_oa_location.license is not null)) THEN TRUE
    ELSE FALSE
  END 
    as green_only_ignoring_bronze,
  
  ARRAY((SELECT url FROM UNNEST(oa_locations) WHERE host_type = "repository")) as repository_locations,
  best_oa_location.url_for_landing_page,
  best_oa_location.url_for_pdf

FROM @table