import React, { useState, useEffect } from "react";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
} from "recharts";
import { mockBarData } from "../Services/mockData";

// project
import { GetAnalyticsApi } from "../Services/GetAnalyticsApi";

const BarChartComponent = ({
  selectedComplaintTypes,
  selectedDate,
  selectedDueDate,
  onTotalComplaintsChange,
}) => {
  const [data, setData] = useState([]);
  const [totalComplaints, setTotalComplaints] = useState(0);

  useEffect(() => {
    async function fetchData() {
      try {
        const response = await GetAnalyticsApi(
          selectedComplaintTypes,
          selectedDate,
          selectedDueDate
        );
        setData(response.data);
        const total = response.data.reduce(
          (sum, item) => sum + item.intCount,
          0
        );
        setTotalComplaints(total);

        onTotalComplaintsChange(total);
      } catch (error) {
        console.error(error);
      }
    }

    fetchData();
  }, [selectedComplaintTypes, selectedDate, selectedDueDate]);

  return (
    <div>
      <BarChart
        width={1580}
        height={700}
        data={data}
        margin={{ top: 20, right: 10, left: 10, bottom: 5 }}
      >
        <CartesianGrid strokeDasharray="3 3" />
        <YAxis />
        <Tooltip />
        <Bar
          dataKey="completedComplaints"
          stackId="a"
          fill="#9b5fe0"
          barSize={40}
        />
        <Bar
          dataKey="rejectedComplaints"
          stackId="a"
          fill="#16a4d8"
          barSize={40}
        />
        <Bar
          dataKey="pendingComplaints"
          stackId="a"
          fill="#60dbe8"
          barSize={40}
        />
        <Bar
          dataKey="refiledComplaints"
          stackId="a"
          fill="#8bd346"
          barSize={40}
        />
        <Bar
          dataKey="scheduledComplaints"
          stackId="a"
          fill="#efdf48"
          barSize={40}
        />
        <Bar
          dataKey="waitingEvaluationComplaints"
          stackId="a"
          fill="#f9a52c"
          barSize={40}
        />
        <Bar
          dataKey="inProgressComplaints"
          stackId="a"
          fill="#d64e12"
          barSize={40}
        />
      </BarChart>
    </div>
  );
};

export default BarChartComponent;