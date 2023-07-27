import CitizenViewComplaints from "./Views/CitizenViewGeneralComplaints"
import GeneralCompDataGrid from "./Components/generalCompDateGrid"
import { IdentityHelper } from "../../Common/Utils/IdentityHelper"
import NotFoundPage from "../NotFound"

function Home() {
    const userType = IdentityHelper.UserData.userType;
    switch(userType) {
        case "admin":
            return <NotFoundPage />;
        case "user":
            return <CitizenViewComplaints />;
        default:
            return <NotFoundPage />;
    }
}

export default Home