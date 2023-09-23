import { createContext, useState } from "react";
import dayjs from "dayjs";

const TaskCreationContext = createContext();
export const TaskCreationProvider = ({ children }) => {
  // Fetch states
  const [workers, setWorkers] = useState([]);

  // Team states
  const [leader, setLeader] = useState(null);
  const [members, setMembers] = useState([]);
  const [startDate, setStartDate] = useState(null);
  const [dueDate, setDueDate] = useState(null);

  const fullTeam =
    members.length > 0
      ? members.map((member) => ({
          intId: member.intId,
          isLeader: member.intId === leader?.intId,
        }))
      : null;

  // Task state
  const [task, setTask] = useState({
    id: "--",
    status: "Scheduled",
    taskType: null,
    comment: "",
  });

   // Formatted dates
   const formattedStartDate = startDate ? dayjs(startDate).format("YYYY-MM-DD HH:mm:ss") : null;
   const formattedDueDate = dueDate ? dayjs(dueDate).format("YYYY-MM-DD HH:mm:ss") : null;
 

  // Shipped states
  const values = {
    workers,
    setWorkers,
    leader,
    fullTeam,
    setLeader,
    members,
    setMembers,
    task,
    setTask,
    formattedStartDate,
    setStartDate,
    formattedDueDate,
    setDueDate,
  };

  /////////////
  return (
    <TaskCreationContext.Provider value={values}>
      {children}
    </TaskCreationContext.Provider>
  );
};

export default TaskCreationContext;
