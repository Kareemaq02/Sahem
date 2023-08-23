import React, { lazy } from "react";

// Project imports
import Layout from "../Layouts/MainLayout";
import MinimalLayout from "../Layouts/MinimalLayout";
import Loadable from "../Utils/Loadable";
import PermissionsHelper from "../Utils/PermissionsHelper";

// Views Routing
const Home = Loadable(lazy(() => import("../../Views/Home")));
const ViewComplaints = Loadable(lazy(() => import("../../Views/Complaints")));
const EvaluateTask = Loadable(lazy(() => import("../../Views/Tasks")));
const NotFound = Loadable(lazy(() => import("../../Views/NotFound")));
const Auth = Loadable(lazy(() => import("../../Views/Authentication/")));
const Login = Loadable(lazy(() => import("../../Views/Authentication/Login")));
const ComplaintType = Loadable(lazy(() => import("../../Views/ComplaintsType/index")));
const CompMap = Loadable(lazy(() => import("../../Views/Maps/Map_Complaint/Map_Complaints")));
const TaskMap = Loadable(lazy(() => import("../../Views/Maps/Map_Task/Map_Tasks")));
const WorkerTaskMap = Loadable(lazy(() => import("../../Views/Maps/Map_Tasks_Worker/Map_Tasks_Worker")));
const CompMapUserGen = Loadable(lazy(() => import("../../Views/Maps/Map_Complaint_User_General/Map_Complaint_User_General")));
const CompMapUser = Loadable(lazy(() => import("../../Views/Maps/Map_Complaint_User/Map_Complaint_User")));
const DepartmentType = Loadable(lazy(() => import("../../Views/Department/index")));
const TaskType = Loadable(lazy(() => import("../../Views/TaskType/index")));
const Register = Loadable(
  lazy(() => import("../../Views/Authentication/Register"))
);
const Proffession = Loadable(lazy(() => import("../../Views/Proffessions/index")));
const InsertTaskType = Loadable(lazy(() => import("../../Views/TaskType/InsertTaskType")));
const InsertComplaintType = Loadable(lazy(() => import("../../Views/ComplaintsType/InsertComplaintType")));
const InsertDepartmentType = Loadable(lazy(() => import("../../Views/Department/InsertDepartmentType")));
const InsertProffession = Loadable(lazy(() => import("../../Views/Proffessions/InsertProffession")));
const GeneralComplaints = Loadable(lazy(() => import("../../Views/GeneralComplaints/index")));
const Users = Loadable(lazy(() => import("../../Views/ViewUsers/index")));
const Workers = Loadable(lazy(() => import("../../Views/ViewWorkers/index")));
const MyTask = Loadable(lazy(() => import("../../Views/MyTasks/index")));
const RegWorker = Loadable(lazy(() => import("../../Views/WorkerReg/index")));
const AccSettings = Loadable(lazy(() => import("../../Views/AccountSettings/index")));
const MyWatches = Loadable(lazy(() => import("../../Views/MyWatchs/index")));





const Admin = "admin";
const Worker = "worker";
const User = "user";

const MainRoutes = {
  path: "/auth",
  element: <Layout />,
  children: [
    {
      path: "home",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin, Worker, User]}
          element={<Home />}
        />
      ),
    },
    {
      path: "complaints",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin, User]}
          element={<ViewComplaints />}
        />
      ),
    },
    {
      path: "users",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin]}
          element={<Users />}
        />
      ),
    },
    {
      path: "workers",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin]}
          element={<Workers />}
        />
      ),
    },
    {
      path: "tasks",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin, Worker]}
          element={<EvaluateTask />}
        />
      ),
    },
    {
      path: "generalcomplaints",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin, User,Worker]}
          element={<GeneralComplaints />}
        />
      ),
    },
    {
      path: "compMap",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin]}
          element={<CompMap />}
        />
      ),
    },
    {
      path: "compMapUserGen",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin,User]}
          element={<CompMapUserGen />}
        />
      ),
    },
    {
      path: "compMapUser",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin,User]}
          element={<CompMapUser />}
        />
      ),
    },
    {
      path: "taskMap",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin]}
          element={<TaskMap/>}
        />
      ),
    },
    {
      path: "taskMapWorker",
      element: (
        <PermissionsHelper
          allowedRoles={[Worker]}
          element={<WorkerTaskMap/>}
        />
      ),
    },
    {
      path: "tasktype",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin]}
          element={<TaskType />}
        />
      ),
    },
    {
      path: "insert-task-type",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin]}
          element={<InsertTaskType />}
        />
      ),
    },
    {
      path: "mytasks",
      element: (
        <PermissionsHelper
          allowedRoles={[Worker]}
          element={<MyTask />}
        />
      ),
    },
    {
      path: "complainttype",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin]}
          element={<ComplaintType />}
        />
      ),
    },
    {
      path: "insert-complaint-type",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin]}
          element={<InsertComplaintType />}
        />
      ),
    },
    {
      path: "department-type",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin]}
          element={<DepartmentType />}
        />
      ),
    },
    {
      path: "insert-department-type",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin]}
          element={<InsertDepartmentType />}
        />
      ),
    },
    {
      path: "proffession",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin]}
          element={<Proffession />}
        />
      ),
    },
    {
      path: "insert-proffession",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin]}
          element={<InsertProffession />}
        />
      ),
    },
    {
      path: "registerworker",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin]}
          element={<RegWorker />}
        />
      ),
    },
    {
      path: "account",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin,User]}
          element={<AccSettings />}
        />
      ),
    },
    {
      path: "watchlist",
      element: (
        <PermissionsHelper
          allowedRoles={[Admin,User]}
          element={<MyWatches />}
        />
      ),
    },
    {
      path: "*",
      element: <NotFound />,
    },
  ],
};

export const AuthRoutes = {
  path: "/",
  element: <MinimalLayout />,
  children: [
    {
      path: "",
      element: <Auth />,
      children: [
        {
          path: "",
          element: <Login />,
        },
        {
          path: "register",
          element: <Register />,
        },
      ],
    },
    {
      path: "*",
      element: <NotFound />,
    },
  ],
};

export default MainRoutes;
