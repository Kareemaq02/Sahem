import { createContext, useState } from "react";

const TaskCreationContext = createContext();
export const TaskCreationProvider = ({ children }) => {
  // Fetch states
  const [workers, setWorkers] = useState([]);

  // Team states
  const [leader, setLeader] = useState(null);
  const [members, setMembers] = useState([]);

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
    startDate: null,
    dueDate: null,
    taskType: null,
    comment: "",
  });

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
  };

  /////////////
  return (
    <TaskCreationContext.Provider value={values}>
      {children}
    </TaskCreationContext.Provider>
  );
};

export default TaskCreationContext;
