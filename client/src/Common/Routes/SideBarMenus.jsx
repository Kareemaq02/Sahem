import {
  HomeOutlined,
  Groups2Outlined,
  ReceiptLongOutlined,
  AssignmentIndOutlined,
  AssessmentOutlined,
  TodayOutlined,
  CalendarMonthOutlined,
  Domain,
  PieChartOutlined,
  DisplaySettingsOutlined,
  Public,
  ContentPaste,
  Map,
  TableChart,
} from "@mui/icons-material";
import FormatListBulletedIcon from "@mui/icons-material/FormatListBulleted";
import InsertPageBreakIcon from "@mui/icons-material/Add";
import AssignmentTurnedInIcon from '@mui/icons-material/AssignmentTurnedIn';
import EngineeringIcon from '@mui/icons-material/Engineering';

const AdminMenus = [
  {
    text: "اللوحة الرئيسية",
    path: "/auth/home",
    icon: <HomeOutlined />,
  },
  {
    text: "المشاكل",
    path: "/auth/complaints",
    icon: <ContentPaste />,
    children: [
      {
        text: "عرض المشاكل",
        path: "/auth/complaints",
        icon: <TableChart />,
      },
      {
        text: "انواع المشاكل",
        path: "/auth/complainttype",
        icon: <FormatListBulletedIcon />,
      },
      {
        text: "خريطة المشاكل",
        path: "/auth/compMap",
        icon: <Map />,
      },
    ],
  },
  {
    text: "العمال",
    path: "/auth/workers",
    icon: <EngineeringIcon />,
  },
  {
    text: "المواطنين",
    path: "/auth/users",
    icon: <Groups2Outlined />,
  },
  {
    text: "الاعمال",
    path: "/auth/tasks",
    icon: <AssignmentIndOutlined />,
    children: [
      {
        text: "عرض الاعمال",
        path: "/auth/tasks",
        icon: <TableChart />,
      },
      {
        text: "انواع الاعمال",
        path: "/auth/tasktype",
        icon: <FormatListBulletedIcon />,
      },
      {
        text: "خريطة الاعمال",
        path: "/auth/taskMap",
        icon: <Map />,
      },
    ],
  },
  //Start Department
  {
    text: "انواع الاقسام",
    path: "/auth/department-type",
    icon: <AssignmentIndOutlined />,
    children: [
      {
        text: "عرض انواع الاقسام",
        path: "/auth/department-type",
        icon: <TableChart />,
      },
    ],
  },
  {
    text: "المهن",
    path: "/auth/proffession",
    icon: <AssignmentIndOutlined />,
    children: [
      {
        text: "عرض المهن",
        path: "/auth/proffession",
        icon: <TableChart />,
      },
    ],
  },
];

const WorkerMenus = [
  {
    text: "الرئيسية",
    path: "/auth/home",
    icon: <HomeOutlined />,
  },
  {
    text: "البلاغات العامة",
    path: "/auth/generalcomplaints",
    icon: <Public />,
    children: [
      {
        text: "عرض البلاغات",
        path: "/auth/generalcomplaints",
        icon: <TableChart />,
      },
      {
        text: "خريطة البلاغات",
        path: "/auth/taskMapWorker",
        icon: <Map />,
      },
    ],
  },
  {
    text: "الاعمال",
    path: "/auth/tasks",
    icon: <AssignmentIndOutlined />,
  },
  {
    text: "اعمالي",
    path: "/auth/mytasks",
    icon: <AssignmentTurnedInIcon />,
  },
];

const UserMenus = [
  {
    text: "اللوحة الرئيسية",
    path: "/auth/home",
    icon: <HomeOutlined />,
  },
  {
    text: "البلاغات العامة",
    path: "/auth/generalcomplaints",
    icon: <Public />,
    children: [
      {
        text: "عرض البلاغات العامة",
        path: "/auth/generalcomplaints",
        icon: <TableChart />,
      },
      {
        text: "الخريطة",
        path: "/auth/compMapUserGen",
        icon: <Map />,
      },
    ],
  },
  {
    text: "بلاغاتي",
    path: "/auth/complaints",
    icon: <ContentPaste />,
    children: [
      {
        text: "عرض بلاغاتي",
        path: "/auth/complaints",
        icon: <TableChart />,
      },
      {
        text: "الخريطة",
        path: "/auth/compMapUser",
        icon: <Map />,
      },
    ],
  },
];

export default function GetMenus(userType) {
  switch (userType) {
    case "admin":
      return AdminMenus;
    case "worker":
      return WorkerMenus;
    case "user":
      return UserMenus;
    default:
      return UserMenus;
  }
}