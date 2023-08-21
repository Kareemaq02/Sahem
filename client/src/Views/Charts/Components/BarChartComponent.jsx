import React from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts';
import { mockBarData } from '../Services/mockData'

const BarChartComponent = () => {
  return (
    <BarChart
      width={800}
      height={400}
      data={mockBarData}
      margin={{ top: 20, right: 30, left: 10, bottom: 5, }}
    >
      <CartesianGrid strokeDasharray="3 3" />
      <XAxis dataKey="country" />
      <YAxis />
      <Tooltip />
      <Legend />
      <Bar dataKey="hot dog" stackId="a" fill="#8884d8" />
      <Bar dataKey="burger" stackId="a" fill="#82ca9d" />
      <Bar dataKey="kebab" stackId="a" fill="#ffc658" />
      <Bar dataKey="donut" stackId="a" fill="#ff7300" />
    </BarChart>
  );
};

export default BarChartComponent;
