import { Typography } from "@mui/material";
import { useEffect, useState } from "react";
import ProffessionDataGrid from "../Components/ProffessionDataGrid";
import GetProffession from "../Service/GetProffession";

function AdminProffession() {
  const [proffession, setProffession] = useState([]);

  useEffect(() => {
    const setProffessions = async () => {
      const response = await GetProffession();
      setProffession(response.data);
    };
    setProffessions();
  }, []);

  return (
    <div>
      <Typography variant="h1">View Proffessions</Typography>
      <ProffessionDataGrid data={proffession} />
    </div>
  );
}

export default AdminProffession;
