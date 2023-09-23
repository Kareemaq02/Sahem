import AdminShowWorkersView from "./Views/AdminShowWorkersView"


function Home() {

    return (
        <div>
            <h1 style={{fontFamily: 'Droid Arabic Naskh, sans-serif'}}>قائمة العمال</h1>
            <AdminShowWorkersView />
        </div>
    )
}

export default Home