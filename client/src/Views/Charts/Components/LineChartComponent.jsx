import React from 'react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts';
import { mockLineData } from '../Services/mockData'


const allModes = [
  "plane",
  "helicopter",
  "boat",
  "train",
  "subway",
  "bus",
  "car",
  "moto",
  "bicycle",
  "horse",
  "skate",
  "others"
];

const colors = {
  japan: 'red',
  france: 'blue',
  us: 'green',
};

const LineChartComponent = () => {
  return (
    <LineChart
      width={800}
      height={400}
      data={allModes.map(mode => ({
        x: mode,
        ...mockLineData.reduce((acc, countryData) => {
          const countryDatum = countryData.data.find(d => d.x === mode);
          acc[countryData.id] = countryDatum ? countryDatum.y : null;
          return acc;
        }, {}),
      }))}
      margin={{ top: 20, right: 30, left: 20, bottom: 5 }}
    >
      <CartesianGrid strokeDasharray="3 3" />
      <XAxis dataKey="x" />
      <YAxis />
      <Tooltip />
      <Legend />

      {mockLineData.map(countryData => (
        <Line
          key={countryData.id}
          dataKey={countryData.id}
          name={countryData.id}
          stroke={colors[countryData.id]}
          dot={false}
        />
      ))}
    </LineChart>
  );
};

export default LineChartComponent;