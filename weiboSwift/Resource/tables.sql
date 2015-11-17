-- 创建微博数据库
CREATE TABLE IF NOT EXISTS "T_Status" (
"statusId" integer NOT NULL PRIMARY KEY,
"status" text,
"userId" integer,
"createTime" text DEFAULT (datetime('now', 'localtime'))
);