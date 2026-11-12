-- 1
SELECT item.quantityOnHand
FROM item
WHERE item.itemDescription = 'bottle of antibiotics';
-- 2
SELECT DISTINCT volunteer.volunteerName
FROM volunteer
WHERE volunteer.volunteerTelephone NOT LIKE '2%'
AND volunteer.volunteerName NOT LIKE '% Jones';
-- 3
SELECT DISTINCT volunteer.volunteerName
FROM volunteer
JOIN assignment
ON volunteer.volunteerId = assignment.volunteerId
JOIN task
ON assignment.taskCode = task.taskCode
JOIN task_type
ON task.taskTypeId = task_type.taskTypeId
WHERE task_type.taskTypeName = 'transporting';
-- 4
SELECT DISTINCT task.taskDescription
FROM task
WHERE task.taskCode NOT IN (
    SELECT assignment.taskCode
    FROM assignment
);
-- 5
SELECT DISTINCT package_type.packageTypeName
FROM package_type
JOIN package
ON package_type.packageTypeId = package.packageTypeId
JOIN package_contents
ON package.packageId = package_contents.packageId
JOIN item
ON package_contents.itemId = item.itemId
WHERE item.itemDescription LIKE '%bottle%';
-- 6
SELECT DISTINCT item.itemDescription
FROM item
WHERE item.itemId NOT IN (
    SELECT package_contents.itemId
    FROM package_contents
);
-- 7
SELECT DISTINCT task.taskDescription
FROM task
JOIN assignment
ON task.taskCode = assignment.taskCode
JOIN volunteer
ON assignment.volunteerId = volunteer.volunteerId
WHERE volunteer.volunteerAddress LIKE '% NJ';

-- 8
SELECT DISTINCT volunteer.volunteerName
FROM volunteer
JOIN assignment
ON volunteer.volunteerId = assignment.volunteerId
WHERE assignment.startDateTime >= '2021-01-01'
AND assignment.startDateTime < '2021-07-01';

-- 9
SELECT DISTINCT volunteer.volunteerName
FROM volunteer
JOIN assignment
ON volunteer.volunteerId = assignment.volunteerId
JOIN package
ON assignment.taskCode = package.taskCode
JOIN package_contents
ON package.packageId = package_contents.packageId
JOIN item
ON package_contents.itemId = item.itemId
WHERE item.itemDescription LIKE '%spam%';

-- 10
SELECT DISTINCT item.itemDescription
FROM item
JOIN package_contents
ON item.itemId = package_contents.itemId 
WHERE item.itemValue * package_contents.itemQuantity = 100;

-- 11
SELECT task_status.taskStatusName, 
    COUNT(DISTINCT assignment.volunteerId) AS numberOfVolunteers
FROM task_status
JOIN task
ON task_status.taskStatusId = task.taskStatusId
JOIN assignment
ON task.taskCode = assignment.taskCode
GROUP BY task_status.taskStatusName
ORDER BY numberOfVolunteers DESC;

-- 12
SELECT package.taskCode, SUM(package.packageWeight) AS totalWeight
FROM package
GROUP BY package.taskCode
ORDER BY totalWeight DESC
LIMIT 1;

-- 13
SELECT COUNT(*) AS totalTasks 
FROM task
JOIN task_type
ON task.taskTypeId = task_type.taskTypeId
WHERE task_type.taskTypeName != 'packing';

-- 14
SELECT item.itemDescription
FROM item
JOIN package_contents
ON item.itemId = package_contents.itemId
JOIN package
ON package_contents.packageId = package.packageId
JOIN assignment
ON package.taskCode = assignment.taskCode
GROUP BY item.itemId
HAVING COUNT(DISTINCT assignment.volunteerId) < 3;

-- 15
SELECT package_contents.packageId,
    SUM(item.itemValue * package_contents.itemQuantity) AS totalValue
FROM package_contents
JOIN item
ON package_contents.itemId = item.itemId
GROUP BY package_contents.packageId
HAVING SUM(item.itemValue * package_contents.itemQuantity) > 100
ORDER BY totalValue ASC;

