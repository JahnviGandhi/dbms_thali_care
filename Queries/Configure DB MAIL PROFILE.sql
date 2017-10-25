

/*EXECUTE msdb.dbo.sysmail_help_profileaccount_sp
   @profile_name = 'Thali Care Administrator Profile';



   EXECUTE msdb.dbo.sysmail_help_profileaccount_sp;
   */

   -- Create a Database Mail account
EXECUTE msdb.dbo.sysmail_add_account_sp
    @account_name = 'ThaliCare Administrator 1',
    @description = 'Mail account for administrative e-mail.',
    @email_address = 'jahnvi2610@gmail.com',
    @replyto_address = 'jahnvi2610@gmail.com',
    @display_name = 'Thali_Care Automated Mailer',
    @mailserver_name = 'smtp.gmail.com' ;

EXECUTE msdb.dbo.sysmail_update_account_sp
	@account_id = 3
    ,@account_name = 'ThaliCare Administrator 1'
    ,@description = 'Mail account for administrative e-mail.'
    ,@email_address = 'donotreplysmartpower@gmail.com'
    ,@display_name = 'Thali Care Automated Mailer'
    ,@replyto_address = NULL
    ,@mailserver_name = 'smtp.gmail.com'
    ,@mailserver_type = 'SMTP'
    ,@port = 587
    ,@timeout = 300
    ,@username = 'donotreplysmartpower@gmail.com'
    ,@password = 'donotreplysmartpower1'
    ,@use_default_credentials = 0
    ,@enable_ssl = 0;

-- Create a Database Mail profile
EXECUTE msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'Thali Care Administrator Profile 1',
    @description = 'Profile used for administrative mail.' ;

-- Add the account to the profile
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'Thali Care Administrator Profile 1',
    @account_name = 'ThaliCare Administrator 1',
    @sequence_number =1 ;

-- Grant access to the profile to the DBMailUsers role
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
    @profile_name = 'Thali Care Administrator Profile 1',
    @principal_name = 'Public',
    @is_default = 1 ;