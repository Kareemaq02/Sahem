// Project Imports
import AdminViewAccountDetails from "./Views/AdminViewAccountDetails";
import CitizenViewAccountDetails from "./Views/CitizenViewAccountDetails";
import { IdentityHelper } from "../../Common/Utils/IdentityHelper";
import NotFoundPage from "../NotFound";

function Home() {
  const userType = IdentityHelper.UserData.userType;
  switch (userType) {
    case "admin":
      return <AdminViewAccountDetails />;
    case "user":
      return <CitizenViewAccountDetails />;
    default:
      return <NotFoundPage />;
  }
}

export default Home;
