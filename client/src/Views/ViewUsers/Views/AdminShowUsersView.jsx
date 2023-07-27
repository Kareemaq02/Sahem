import { useEffect, useState } from "react";
import ShowUsersDataGrid from "../Components/showUsersDataGrid";
import GetUser from "../Service/GetUserApi";


const AdminShowUsersView = () => {

    const [users, setUsers] = useState([])

    const [userId, setUserId] = useState(null)

    const selectedUser = users.find((user) => user.intId === userId)

    useEffect(() => {
        const setShowUser = async () => {
            const response = await GetUser();
            setUsers(response.data)
        };
        setShowUser();
    }, [])

    return(
        <ShowUsersDataGrid data={users} id={selectedUser} />
    )
}

export default AdminShowUsersView;
