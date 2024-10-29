--Sample SQLite statements for debugging and troubleshooting

--1. Determine the path to the SQLite.db file by looking at the <Database DataSource=... line in VIX.Render.config.
--2. Open a cmd window and cd to the parent path from the previous step.
--3. Enter: SQLite3 SQLiteDb.db -readonly
--4. Enter: .help to see the commands you can run or the other commands below

--List the table names
.tables

--Get the ImageFiles record for a ImageUid
--Locate the ImageUid by looking at VIX.Render.log for [Image added to group.] {"ImageUid":"6877c943-4c57-48eb-8d7c-e892a9243662", ...
SELECT AbsolutePath FROM ImageParts WHERE ImageUid = '6877c943-4c57-48eb-8d7c-e892a9243662';

--Get the field names of a table
.schema DisplayContexts

--Get the ContextId from the VIX.Viewer.log and paste it below
select ImageCount from DisplayContexts where ContextId = 'urn:vastudy:660-26758-1008861107V475740';

.exit