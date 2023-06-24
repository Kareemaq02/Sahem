import { Typography } from "@mui/material";
import DepartmentTypeDataGrid from "../Components/DepartmentTypeDataGrid";

import { useEffect, useState } from "react";
import { Tty } from "@mui/icons-material";
import GetDepartmentType from "../Service/GetDepartmentTypes";

function AdminDepartmentView() {
  const [department, setDepartment] = useState([]);

  useEffect(() => {
    const setDepartmentType = async () => {
      const response = await GetDepartmentType();
      console.log(response.data);
      setDepartment(response.data);
    };
    setDepartmentType();
  }, []);

  return (
    <div>
      <Typography variant="h1">View Department Type</Typography>
      <DepartmentTypeDataGrid data={department} />
    </div>
  );
}

export default AdminDepartmentView;
