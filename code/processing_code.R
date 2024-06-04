library(dplyr)
library(hubData)

print(getwd())
print(dir(".", full.names = TRUE))

hub_data <- "./hub_test_data/"
repo_viz <- "./hub_test_viz/"

# Prerequisite
json <- jsonlite::read_json(paste0(repo_viz, "hub-config/viz.json"))
exp_quant <- unname(unlist(json$viz_settings$filtering$Interval))
exp_target <- unname(unlist(json$viz_settings$filtering$Outcome))

# Process model-output file
dc <- hubData::connect_hub(hub_data)
df <- dplyr::filter(dc, output_type == "quantile",
                    output_type_id %in% exp_quant, target %in% exp_target)
df <- dplyr::collect(df)

# Write output file
arrow::write_dataset(df, paste0(repo_viz, "model-output/"),
                     partitioning = c("location", "target", "model_id"),
                     hive_style = FALSE)
