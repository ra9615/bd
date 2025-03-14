WITH RECURSIVE ManagerHierarchy AS (
    -- Базовый уровень: выбираем всех менеджеров
    SELECT e.EmployeeID,
           e.Name,
           e.ManagerID,
           e.DepartmentID,
           e.RoleID
    FROM Employees e
             INNER JOIN Roles r ON e.RoleID = r.RoleID
    WHERE r.RoleName = 'Менеджер'

    UNION ALL

    -- Рекурсивный уровень: выбираем всех подчинённых менеджеров
    SELECT e.EmployeeID,
           e.Name,
           e.ManagerID,
           e.DepartmentID,
           e.RoleID
    FROM Employees e
             INNER JOIN ManagerHierarchy mh ON e.ManagerID = mh.EmployeeID)

SELECT mh.EmployeeID,
       mh.Name                                                                                  AS EmployeeName,
       mh.ManagerID,
       d.DepartmentName,
       r.RoleName,
       COALESCE(GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', '), '') AS ProjectsNames,
       COALESCE(GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', '), '')       AS TasksNames,
       COUNT(DISTINCT sub.EmployeeID)                                                           AS TotalSubordinates
FROM ManagerHierarchy mh
         LEFT JOIN Departments d ON mh.DepartmentID = d.DepartmentID
         LEFT JOIN Roles r ON mh.RoleID = r.RoleID
         LEFT JOIN Projects p ON mh.DepartmentID = p.DepartmentID
         LEFT JOIN Tasks t ON mh.EmployeeID = t.AssignedTo
         LEFT JOIN Employees sub ON mh.EmployeeID = sub.ManagerID
GROUP BY mh.EmployeeID, mh.Name, mh.ManagerID, d.DepartmentName, r.RoleName
HAVING TotalSubordinates > 0
ORDER BY mh.Name;
