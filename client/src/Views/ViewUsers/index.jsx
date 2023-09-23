import AdminShowUsersView from "../ViewUsers/Views/AdminShowUsersView"


function Home() {

    return(
        <div>
            <h1 style={{fontFamily: 'Droid Arabic Naskh, sans-serif'}}>قائمة المستخدمين</h1>
            <AdminShowUsersView />
        </div>
    )
}

export default Home;