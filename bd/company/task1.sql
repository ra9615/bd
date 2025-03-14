WITH RECURSIVE EmployeeHierarchy AS (
    -- Выбираем Ивана Иванова и его непосредственных подчинённых
    SELECT e.EmployeeID,
           e.Name,
           e.ManagerID,
           e.DepartmentID,
           e.RoleID
    FROM Employees e
    WHERE e.EmployeeID = 1 -- Иван Иванов

    UNION ALL

    -- Рекурсивно выбираем подчинённых сотрудников
    SELECT e.EmployeeID,
           e.Name,
           e.ManagerID,
           e.DepartmentID,
           e.RoleID
    FROM Employees e
             INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID)

SELECT eh.EmployeeID,
       eh.Name                                                                                  AS EmployeeName,
       eh.ManagerID,
       d.DepartmentName,
       r.RoleName,
       COALESCE(GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', '), '') AS ProjectsNames,
       COALESCE(GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', '), '')       AS TasksNames
FROM EmployeeHierarchy eh
         LEFT JOIN Departments d ON eh.DepartmentID = d.DepartmentID
         LEFT JOIN Roles r ON eh.RoleID = r.RoleID
         LEFT JOIN Projects p ON p.DepartmentID = eh.DepartmentID
         LEFT JOIN Tasks t ON eh.EmployeeID = t.AssignedTo
GROUP BY eh.EmployeeID, eh.Name, eh.ManagerID, d.DepartmentName, r.RoleName
ORDER BY eh.Name;
