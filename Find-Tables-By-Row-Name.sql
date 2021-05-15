SELECT
       c.name AS ColName,
       t.name AS TableName
FROM sys.columns c
    JOIN sys.tables t ON c.object_id = t.object_id
WHERE c.name LIKE 'Par_Consecutivo' -- and c.name like '%t%i%m%';