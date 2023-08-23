import React, { useState, useEffect } from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts';
import { mockBarData } from '../Services/mockData'

// project
import { GetAnalyticsApi } from '../Services/GetAnalyticsApi';

const BarChartComponent = ({ selectedComplaintTypes, selectedDate, onTotalComplaintsChange  }) => {

  const [data, setData] = useState([]);
  const [totalComplaints, setTotalComplaints] = useState(0);

  useEffect(() => {
    async function fetchData() {
      try {
        const response = await GetAnalyticsApi(selectedComplaintTypes, selectedDate);
        setData(response.data);
        const total = response.data.reduce((sum, item) => sum + item.intCount, 0);
        setTotalComplaints(total);

        onTotalComplaintsChange(total);
      } catch (error) {
        console.error(error);
      }
    }

    fetchData();
  }, [selectedComplaintTypes, selectedDate]);

  return (
    <div>
      <BarChart
        width={800}
        height={400}
        data={data}
        margin={{ top: 20, right: 30, left: 10, bottom: 5 }}
      >
        <CartesianGrid strokeDasharray="3 3" />
        <XAxis dataKey="strNameAr" />
        <YAxis />
        <Tooltip />
        <Bar dataKey="intCount" stackId="a" fill="#82ca9d" />
        <Bar dataKey="completedComplaintsPercentage" stackId="a" fill="#82ca9d" />
        <Bar dataKey="rejectedComplaintsPercentage" stackId="a" fill="#ffc658" />
        <Bar dataKey="pendingComplaintsPercentage" stackId="a" fill="#ff7300" />
      </BarChart>
    </div>
  );
};

export default BarChartComponent;

