library(vitessceR)
library(shiny)

# Define the image file options object.
file_options = obj_list(
    schemaVersion = "0.0.2",
    images = list(
        obj_list(
            name = "My Image",
            type = "ome-tiff",
            url = "https://vitessce-demo-data.storage.googleapis.com/exemplar-001/exemplar-001.pyramid.ome.tif"
        )
    ),
    renderLayers = list(
        "My Image"
    )
)

ui <- fluidPage(
    "Vitessce ome-tiff in a Shiny app",
    vitessce_output(output_id = "vitessce_visualization", height = "600px"),
)
# Create Vitessce view config
server <- function(input, output, session) {
    output$vitessce_visualization <- render_vitessce(expr = {
        vc <- VitessceConfig$new(schema_version = "1.0.16", name = "My config")
        dataset <- vc$add_dataset("My dataset")$add_file(
            data_type = DataType$RASTER,
            file_type = FileType$RASTER_JSON,
            options = file_options
        )
        spatial <- vc$add_view(dataset, Component$SPATIAL)
        spatial_layers <- vc$add_view(dataset, Component$LAYER_CONTROLLER)
        status <- vc$add_view(dataset, Component$STATUS)
        desc <- vc$add_view(dataset, Component$DESCRIPTION)
        desc <- desc$set_props(description = "Visualization of an OME-TIFF file.")
        vc$layout(hconcat(
            spatial,
            hconcat(spatial_layers, vconcat(desc, status))
        ))
        
        vc$widget(theme = "light", width = "100%")
    })
}

shinyApp(ui, server)