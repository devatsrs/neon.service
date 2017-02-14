#!/bin/sh

# This file will generate a sql file which will be used to insert data after db setup for new company.

#source $(dirname "$0")/config.sh


#mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblCountry > ${POST_INSTALLATION_SQL_SCRIPT}
#mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblCronJobCommand >> ${POST_INSTALLATION_SQL_SCRIPT}
#mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblGateway >> ${POST_INSTALLATION_SQL_SCRIPT}
#mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblGatewayConfig >> ${POST_INSTALLATION_SQL_SCRIPT}
#mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblGlobalAdmin >> ${POST_INSTALLATION_SQL_SCRIPT}
#mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblGlobalSetting >> ${POST_INSTALLATION_SQL_SCRIPT}
#mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblJobStatus >> ${POST_INSTALLATION_SQL_SCRIPT}
#mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblJobType >> ${POST_INSTALLATION_SQL_SCRIPT}
#mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblRateSheetFormate >> ${POST_INSTALLATION_SQL_SCRIPT}
#mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblPermission >> ${POST_INSTALLATION_SQL_SCRIPT}
#mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblResource >> ${POST_INSTALLATION_SQL_SCRIPT}
#mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblResourceCategories >> ${POST_INSTALLATION_SQL_SCRIPT}
#mysqldump --compact --no-create-info  ${STAGING_RM_DB} tblIntegration >> ${POST_INSTALLATION_SQL_SCRIPT}
#mysqldump --compact --no-create-info -w 'CodeDeckId = 1' ${WHOLESALE_RM_DB} tblRate >> ${POST_INSTALLATION_SQL_SCRIPT}

cat <<EOT >> ${POST_INSTALLATION_SQL_SCRIPT}

INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'SSH', '{"host":"_SSH_HOST_","username":"_SSH_HOST_USER_","password":"_SSH_HOST_PASS_"}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'UPLOADPATH', '_UPLOAD_PATH_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'SITE_URL', '_SITE_URL_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'FRONT_STORAGE_PATH', '_FRONT_STORAGE_PATH_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'DELETE_STORAGE_LOG_DAYS', '31');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'TEMP_PATH', '_TEMP_PATH_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'DELETE_TEMP_FILES_DAYS', '3');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'SIPPYFILE_LOCATION', '_SIPPYFILE_LOCATION_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'VOS_LOCATION', '_VOS_LOCATION_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'FILE_RETENTION_EMAIL', 'deven@code-desk.com');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'ErrorEmail', 'support@neon-soft.com');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'LICENCE_KEY', '_LICENCE_KEY_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'PHPExePath', '/usr/bin/php');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'RMArtisanFileLocation', '_RMArtisanFileLocation_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'PBX_CRONJOB', '{"MaxInterval":"1440","CdrBehindDuration":"200","CdrBehindDurationEmail":"120","ThresholdTime":"30","SuccessEmail":"","ErrorEmail":"sumera@code-desk.com,bhavin@code-desk.com,girish.vadher@code-desk.com,deven@code-desk.com","JobTime":"MINUTE","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'PORTA_CRONJOB', '{"MaxInterval":"1440","CdrBehindDuration":"120","CdrBehindDurationEmail":"120","ThresholdTime":"30","SuccessEmail":"","ErrorEmail":"sumera@code-desk.com,bhavin@code-desk.com,girish.vadher@code-desk.com,deven@code-desk.com","JobTime":"MINUTE","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'SIPPYSFTP_DOWNLOAD_CRONJOB', '{"FilesDownloadLimit":"50","ThresholdTime":"120","SuccessEmail":"","ErrorEmail":"bhavin@code-desk.com,sumera@code-desk.com,girish.vadher@code-desk.com,deven@code-desk.com","JobTime":"MINUTE","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'SIPPYSFTP_PROCESS_CRONJOB', '{"FilesMaxProccess":"3","CdrBehindDuration":"200","CdrBehindDurationEmail":"180","ThresholdTime":"60","SuccessEmail":"","ErrorEmail":"bhavin@code-desk.com,sumera@code-desk.com,girish.vadher@code-desk.com,deven@code-desk.com","JobTime":"MINUTE","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'VOS_DOWNLOAD_CRONJOB', '{"FilesDownloadLimit":"10","ThresholdTime":"120","SuccessEmail":"","ErrorEmail":"bhavin@code-desk.com,sumera@code-desk.com,girish.vadher@code-desk.com,deven@code-desk.com","JobTime":"MINUTE","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'VOS_PROCESS_CRONJOB', '{"FilesMaxProccess":"5","CdrBehindDuration":"200","CdrBehindDurationEmail":"180","ThresholdTime":"30","SuccessEmail":"","ErrorEmail":"bhavin@code-desk.com,sumera@code-desk.com,girish.vadher@code-desk.com,deven@code-desk.com","JobTime":"MINUTE","JobInterval":"2","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM","CompanyGatewayID":""}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'CUSTOMER_SUMMARYDAILY_CRONJOB', '{"ThresholdTime":"500","SuccessEmail":"","ErrorEmail":"bhavin@code-desk.com,sumera@code-desk.com,girish.vadher@code-desk.com,deven@code-desk.com","JobTime":"DAILY","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM"}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'CUSTOMER_SUMMARYLIVE_CRONJOB', '{"ThresholdTime":"30","SuccessEmail":"","ErrorEmail":"bhavin@code-desk.com,sumera@code-desk.com,girish.vadher@code-desk.com,deven@code-desk.com","JobTime":"MINUTE","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM"}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'VENDOR_SUMMARYDAILY_CRONJOB', '{"ThresholdTime":"500","SuccessEmail":"","ErrorEmail":"bhavin@code-desk.com,sumera@code-desk.com,girish.vadher@code-desk.com,deven@code-desk.com","JobTime":"DAILY","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"2:00:00 AM"}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'VENDOR_SUMMARYLIVE_CRONJOB', '{"ThresholdTime":"30","SuccessEmail":"","ErrorEmail":"bhavin@code-desk.com,sumera@code-desk.com,girish.vadher@code-desk.com,deven@code-desk.com","JobTime":"MINUTE","JobInterval":"1","JobDay":["SUN","MON","TUE","WED","THU","FRI","SAT"],"JobStartTime":"12:00:00 AM"}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'CRM_DASHBOARD', '_CRM_DASHBOARD_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'CUSTOMER_COMMERCIAL_DISPLAY', '1');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'CUSTOMER_NOTIFICATION_DISPLAY', '1');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'BILLING_DASHBOARD', '_BILLING_DASHBOARD_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'USAGE_PBX_INTERVAL', '180');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'USAGE_INTERVAL', '100');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'CUSTOMER_MONITOR_DASHBOARD', 'CallMonitor');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'MONITOR_DASHBOARD', 'CallMonitor');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'BILLING_DASHBOARD_CUSTOMER', '_BILLING_DASHBOARD_CUSTOMER_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'EMAIL_TO_CUSTOMER', '_EMAIL_TO_CUSTOMER_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'NEON_API_URL', '_NEON_API_URL_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'ACC_DOC_PATH', '_ACC_DOC_PATH_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'PAYMENT_PROOF_PATH', '_PAYMENT_PROOF_PATH_');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'CRM_ALLOWED_FILE_UPLOAD_EXTENSIONS', 'bmp,csv,doc,docx,gif,ini,jpg,msg,odt,pdf,png,ppt,pptx,rar,rtf,txt,xls,xlsx,zip,7z');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'SUPER_ADMIN_EMAILS', '{"registration":{"from":"","from_name":"","email":""}}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'CACHE_EXPIRE', '60');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'MAX_UPLOAD_FILE_SIZE', '50M');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'PAGE_SIZE', '50');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES (1, 'DEFAULT_PREFERENCE', '5');


INSERT INTO tblCompany (CompanyID, CompanyName,  CustomerAccountPrefix, FirstName, LastName, Email, Phone,  Status, TimeZone, created_at, created_by)
VALUES (1, '${DB_COMPANY_NAME}', '22221', '${FIRST_NAME}', '${LAST_NAME}', '${COMPANY_EMAIL}', '',  1, 'Etc/GMT', '2017-02-17 10:12:25', 'Dev');

INSERT INTO tblUser (UserID, CompanyID, FirstName, LastName, EmailAddress, password, AdminUser, AccountingUser, Status, Roles, remember_token, updated_at, created_at, created_by, updated_by, EmailFooter, Color, JobNotification)
VALUES (1, 1, '${FIRST_NAME}', '${LAST_NAME}', '${COMPANY_EMAIL}', '$2y$10$PlVXiwVLUxkuiwSyKQJyUeHAVysVkya6VDuinVOrG2GLTmPr1wk4.', 1, 1, 1, 'Admin,Billing Admin', 'mJZaptV7wrwCooghFLeaFtXfQcG3dgAYasFMPzlWGEWuUAxrZ8EqTZF8f1sA', '2016-11-17 10:26:12', '2015-02-07 07:24:02', NULL, '${FIRST_NAME} ${LAST_NAME}', 'From ,<br><br><b>${FIRST_NAME} ${LAST_NAME}</b><br><br>', '', 1);


INSERT INTO tblCRMBoards (CompanyID, BoardName, Status, BoardType, CreatedBy, created_at)
SELECT * FROM (SELECT 1 as CompanyID,'TaskBoard', 1 as Status, 2 as BoardType, 'System' as CreatedBy, Now() as created_at) AS tmp
WHERE NOT EXISTS (
SELECT BoardName FROM tblCRMBoards
WHERE tblCRMBoards.BoardName = 'TaskBoard'
and tblCRMBoards.BoardType = 2
and tblCRMBoards.CompanyID = 1
) LIMIT 1;


SELECT br.BoardID into @taskBoardID FROM tblCRMBoards br
WHERE br.BoardName = 'TaskBoard'
and br.BoardType = 2
and br.CompanyID = 1
limit 1;

INSERT INTO tblCRMBoardColumn ( BoardID, CompanyID, BoardColumnName, Height, Width, Order, SetCompleted, CreatedBy, ModifiedBy, created_at, updated_at) VALUES ( @taskBoardID, 1, 'Not Started', '100%', '300px', 0, 0, 'System', 'System', NOW(), NOW());
INSERT INTO tblCRMBoardColumn ( BoardID, CompanyID, BoardColumnName, Height, Width, Order, SetCompleted, CreatedBy, ModifiedBy, created_at, updated_at) VALUES ( @taskBoardID, 1, 'In Progress', '100%', '300px', 1, 0, 'System', 'System', NOW(), NOW());
INSERT INTO tblCRMBoardColumn ( BoardID, CompanyID, BoardColumnName, Height, Width, Order, SetCompleted, CreatedBy, ModifiedBy, created_at, updated_at) VALUES ( @taskBoardID, 1, 'Waiting', '100%', '300px', 2, 0, 'System', 'System', NOW(), NOW());
INSERT INTO tblCRMBoardColumn ( BoardID, CompanyID, BoardColumnName, Height, Width, Order, SetCompleted, CreatedBy, ModifiedBy, created_at, updated_at) VALUES ( @taskBoardID, 1, 'Completed', '100%', '300px', 3, 0, 'System', 'System', NOW(), NOW());
INSERT INTO tblCRMBoardColumn ( BoardID, CompanyID, BoardColumnName, Height, Width, Order, SetCompleted, CreatedBy, ModifiedBy, created_at, updated_at) VALUES ( @taskBoardID, 1, 'Deferred', '100%', '300px', 4, 0, 'System', 'System', NOW(), NOW());


INSERT INTO tblCodeDeck (CodeDeckId, CompanyId, CodeDeckName, created_at, CreatedBy, updated_at, ModifiedBy, Type, DefaultCodedeck) VALUES (1, 1, 'Default Codedeck', '2016-11-18 09:17:21', 'Dev', '2016-11-18 09:36:18', NULL, NULL, 1);

-- # One time set up for dim tables
USE ${DB_DATABASEREPORT};

call prc_datedimbuild('2017-01-01','2027-01-01');
call prc_timedimbuild();
EOT

#Replace config values

sed -i 's/_SSH_HOST_USER_/='${SSH_HOST_USER}'/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/_SSH_HOST_PASS_/='${SSH_HOST_PASS}'/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/_SSH_HOST_/='${SSH_HOST}'/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/_UPLOAD_PATH_/='${UPLOAD_PATH}'/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/_TEMP_FOLDER_/='${TEMP_FOLDER}'/g' ${POST_INSTALLATION_SQL_SCRIPT}

sed -i 's/_FRONT_STORAGE_PATH_/='${FRONT_STORAGE_PATH}'/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/_SIPPYFILE_LOCATION_/='${SIPPYFILE_LOCATION}'/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/_VOS_LOCATION_/='${VOS_LOCATION}'/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/_LICENCE_KEY_/='${LICENCE_KEY}'/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/_RMArtisanFileLocation_/='${RMArtisanFileLocation}'/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/_CRM_DASHBOARD_/='${CRM_DASHBOARD}'/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/_BILLING_DASHBOARD_/='${BILLING_DASHBOARD}'/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/_BILLING_DASHBOARD_CUSTOMER_/='${BILLING_DASHBOARD_CUSTOMER}'/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/_EMAIL_TO_CUSTOMER_/='${EMAIL_TO_CUSTOMER}'/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/_NEON_API_URL_/='${NEON_API_URL}'/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/_ACC_DOC_PATH_/='${ACC_DOC_PATH}'/g' ${POST_INSTALLATION_SQL_SCRIPT}
sed -i 's/_PAYMENT_PROOF_PATH_/='${PAYMENT_PROOF_PATH}'/g' ${POST_INSTALLATION_SQL_SCRIPT}

mysql ${DB_DATABASE} < ${POST_INSTALLATION_SQL_SCRIPT}

exit 0
