import React from 'react';
import { Box } from '@mui/material';
import { ComposableMap, Geographies, Geography } from 'react-simple-maps';
import { mockGeographyData } from '../Services/mockData';
import mockGeoFeatures from "../Services/mockGeoFeatures"
import { scaleQuantile } from 'd3-scale';

const GeographyChartComp = () => {

    console.log("mockGeographyData:", mockGeographyData);
    console.log("mockGeoFeatures:", mockGeoFeatures);

    const colorScale = scaleQuantile()
        .domain(mockGeographyData.map(d => d.value))
        .range(['#ffedea', '#ffcec5', '#ffad9f', '#ff8a75', '#ff5533', '#e2492d', '#be3d26', '#9a311f', '#782618']);

    console.log("colorScale:", colorScale);


    return (
        <Box>
            <ComposableMap projection="geoMercator">
                <Geographies geography={mockGeoFeatures}>
                    {({ geographies }) =>
                        geographies.map(geo => {
                            const countryId = geo.properties.id;
                            const countryData = mockGeographyData.find(data => data.id === countryId);

                            return (
                                <Geography
                                    key={geo.rsmKey}
                                    geography={geo}
                                    fill={countryData ? colorScale(countryData.value) : '#EAEAEC'}
                                />
                            );
                        })
                    }
                </Geographies>
            </ComposableMap>
        </Box>
    );
};

export default GeographyChartComp;
