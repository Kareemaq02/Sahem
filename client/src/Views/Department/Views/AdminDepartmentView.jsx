import { Grid, Typography } from "@mui/material";
import DepartmentTypeDataGrid from "../Components/DepartmentTypeDataGrid";

import { useEffect, useState } from "react";
import { Tty } from "@mui/icons-material";
import GetDepartmentType from "../Service/GetDepartmentTypes";
import DepartmentTypeForm from "../../Department/Components/DepartmentTypeForm";

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
      <Typography variant="h1" sx={{ fontFamily: 'Droid Arabic Naskh, sans-serif' }}>عرض الاقسام</Typography>
      <Grid container spacing={2}>
        <Grid item xs={12} md={8}>
          <DepartmentTypeDataGrid data={department} />
        </Grid>
        <Grid item xs={12} md={4}>
          <DepartmentTypeForm refreshDataGrid={setDepartment} />
        </Grid>
      </Grid>
    </div>
  );
}

export default AdminDepartmentView;
