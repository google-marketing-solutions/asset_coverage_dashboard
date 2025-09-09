CREATE OR REPLACE TABLE `${raw_dataset}.active_video_ids`
AS (
  WITH
    active_assets AS (
      SELECT
        PARSE_NUMERIC(SPLIT(`video_string`, '/')[SAFE_OFFSET(3)]) AS asset_id
      FROM
        `{raw_dataset}.demand_gen_campaign_assets`,
        UNNEST(ad_demand_gen_video_responsive_ad_videos) AS video_string
      UNION DISTINCT
      SELECT
        PARSE_NUMERIC(SPLIT(`ad_video_ad_video_asset`, '/')[SAFE_OFFSET(3)]) AS asset_id
      FROM `{raw_dataset}.video_campaigns`
    )
  SELECT VA.video_id
  FROM `{raw_dataset}.video_assets` AS VA
  INNER JOIN active_assets AS AA
    USING (asset_id)
  LEFT JOIN `{raw_dataset}.video_aspect_ratios` AS AR
    USING (video_id)
  WHERE
    VA.video_id IS NOT NULL
    AND AR.video_id IS NULL
  ORDER BY VA.video_id
)
