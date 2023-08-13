import CitizenViewComplaints from "./Views/CitizenViewGeneralComplaints"
import GeneralCompDataGrid from "./Components/generalCompDateGrid"
import { IdentityHelper } from "../../Common/Utils/IdentityHelper"
import NotFoundPage from "../NotFound"

function Home() {
    const userType = IdentityHelper.UserData.userType;
    return(
        <CitizenViewComplaints />
    )
}

export default Home