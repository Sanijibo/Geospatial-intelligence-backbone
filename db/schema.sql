-- Enable PostGIS for geospatial intelligence capabilities
CREATE EXTENSION IF NOT EXISTS postgis;

-- Create the core data table for large-scale field survey ingestion
CREATE TABLE survey_responses (
    id SERIAL PRIMARY KEY,
    agent_id INT NOT NULL,
    -- '4326' is the standard WGS 84 coordinate system used by GPS
    location GEOGRAPHY(Point, 4326) NOT NULL, 
    survey_payload JSONB NOT NULL, -- Flexible storage for diverse survey data
    received_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Optimization for sub-second query latency (Melon requirement)
-- GIST index allows fast location-based searches across millions of rows
CREATE INDEX idx_spatial_location ON survey_responses USING GIST(location);
