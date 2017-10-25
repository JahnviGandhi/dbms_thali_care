EXEC msdb.dbo.sp_send_dbmail
        @profile_name = 'Thali Care Administrator Profile 1',
        @recipients = 'jahnvi2610@gmail.com',
        @body = 'Don''t forget to print a report for the sales force.',
        @subject = 'Reminder';


SELECT * FROM msdb.dbo.sysmail_allitems;

-- DELETE FROM msdb.dbo.sysmail_allitems