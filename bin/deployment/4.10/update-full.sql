-- Ratemanagement3
-- Abubakar
USE `Ratemanagement3`;

INSERT INTO `tblresourcecategories` (`ResourceCategoryName`, `CompanyID`) VALUES ('BillingDashboardSummaryWidgets.View', '1');
INSERT INTO `tblresourcecategories` (`ResourceCategoryName`, `CompanyID`) VALUES ('BillingDashboardMissingGatewayWidget.View', '1');
INSERT INTO `tblResourceCategories` (`ResourceCategoryName`, `CompanyID`) VALUES ('BillingDashboardInvoiceExpenseWidgets.View', '1');
INSERT INTO `tblResourceCategories` (`ResourceCategoryName`, `CompanyID`) VALUES ('BillingDashboardPincodeWidget.View', '1');

UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='BillingDashboardSummaryWidgets.View' limit 1) WHERE  `ResourceName`='BillingDashboard.invoice_expense_total';
UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='BillingDashboardSummaryWidgets.View' limit 1) WHERE  `ResourceName`='BillingDashboard.invoice_expense_total_widget';

UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='BillingDashboardMissingGatewayWidget.View' limit 1) WHERE  `ResourceName`='Dashboard.ajax_get_missing_accounts';
UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='BillingDashboardInvoiceExpenseWidgets.View' limit 1) WHERE  `ResourceName`='BillingDashboard.invoice_expense_chart';

UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='BillingDashboardPincodeWidget.View' limit 1) WHERE  `ResourceName`='BillingDashboard.ajax_top_pincode';

UPDATE `tblResource` SET `CategoryID`=(select ResourceCategoryID FROM tblResourceCategories WHERE ResourceCategoryName='BillingDashboardInvoiceExpenseWidgets.View' limit 1) WHERE  `ResourceName`='BillingDashboard.invoice_expense_total_widget';

DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='FreshdeskDomain';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='FreshdeskEmail';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='Freshdeskkey';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='FreshdeskPassword';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='PAYPAL_IPN';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='OUTLOOKCALENDAR_API';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='EXTRA_SMTP';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='Amazon';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='ErrorEmail';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='FILE_RETENTION_EMAIL';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='SITE_URL';
DELETE FROM `tblCompanyConfiguration` WHERE  `Key`='SIPPY_CSVDECODER';

UPDATE `tblcompanyconfiguration` SET `Value`='UPLOAD_PATH' WHERE  `Key`='UPLOADPATH';
UPDATE `tblcompanyconfiguration` SET `Value`='WEB_PATH' WHERE  `Key`='SITE_URL';
UPDATE `tblcompanyconfiguration` SET `Value`='NEON_API_URL' WHERE  `Key`='Neon_API_URL';
UPDATE `tblcompanyconfiguration` SET `Value`='PHP_EXE_PATH' WHERE  `Key`='PHPExePath';
UPDATE `tblcompanyconfiguration` SET `Value`='RM_ARTISAN_FILE_LOCATION' WHERE  `Key`='RMArtisanFileLocation';
UPDATE `tblcompanyconfiguration` SET `Value`='Quickbook' WHERE  `Key`='QUICKBOOK';

INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'BILLING_DASHBOARD_CUSTOMER', 'BillingDashboardPincodeWidget,BillingDashboardTotalInvoiceSent,BillingDashboardTotalInvoiceReceived,BillingDashboardPaymentReceived,BillingDashboardPaymentSent,BillingDashboardUnbilledAmount');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'EMAIL_TO_CUSTOMER', '0');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'ACC_DOC_PATH','/home/neon_branches/dev/tmp');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'PAYMENT_PROOF_PATH', '/home/neon_branches/dev/tmp');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'CRM_ALLOWED_FILE_UPLOAD_EXTENSIONS', 'bmp,csv,doc,docx,gif,ini,jpg,msg,odt,pdf,png,ppt,pptx,rar,rtf,txt,xls,xlsx,zip,7z');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'SUPER_ADMIN_EMAILS', '{"registration":{"from":"","from_name":"","email":""}}');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'CACHE_EXPIRE', '60');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'MAX_UPLOAD_FILE_SIZE', '5M');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'PAGE_SIZE', '50');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'DEFAULT_PREFERENCE', '5');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'WEB_URL', 'http://linux1.neon-soft.com/rm.abubakar/public');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'DEMO_DATA_PATH', '/home/neon_branches/dev/tmp');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'TRANSACTION_LOG_EMAIL_FREQUENCY', 'Daily');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'DEFAULT_TIMEZONE', 'GMT');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'DEFAULT_BILLING_TIMEZONE', 'Europe/London');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'DELETE_CDR_TIME', '3 month');
INSERT INTO `tblCompanyConfiguration` (`CompanyID`, `Key`, `Value`) VALUES ('1', 'DELETE_SUMMARY_TIME', '4 days');

-- Bhavin

USE `Ratemanagement3`;

DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTable`;

DELIMITER |
CREATE PROCEDURE `prc_WSGenerateRateTable`(
	IN `p_jobId` INT,
	IN `p_RateGeneratorId` INT,
	IN `p_RateTableId` INT,
	IN `p_rateTableName` VARCHAR(200),
	IN `p_EffectiveDate` VARCHAR(10),
	IN `p_delete_exiting_rate` INT,
	IN `p_EffectiveRate` VARCHAR(50)
)
GenerateRateTable:BEGIN


	DECLARE v_RTRowCount_ INT;
	DECLARE v_RatePosition_ INT;
	DECLARE v_Use_Preference_ INT;
	DECLARE v_CurrencyID_ INT;
	DECLARE v_CompanyCurrencyID_ INT;
	DECLARE v_Average_ TINYINT;
	DECLARE v_CompanyId_ INT;
	DECLARE v_codedeckid_ INT;
	DECLARE v_trunk_ INT;
	DECLARE v_rateRuleId_ INT;
	DECLARE v_RateGeneratorName_ VARCHAR(200);
	DECLARE v_pointer_ INT ;
	DECLARE v_rowCount_ INT ;


	-- ----- LCR Variables
	DECLARE v_tmp_code_cnt int ;
	DECLARE v_tmp_code_pointer int;
	DECLARE v_p_code varchar(50);
	DECLARE v_Codlen_ int;
	DECLARE v_p_code__ VARCHAR(50);
	DECLARE v_Commit int;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		   ROLLBACK;
		   CALL prc_WSJobStatusUpdate(p_jobId, 'F', 'RateTable generation failed', '');

    END;

     SET @@session.collation_connection='utf8_unicode_ci';
     SET @@session.character_set_client='utf8';

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

   --

    SET p_EffectiveDate = CAST(p_EffectiveDate AS DATE);

    -- when Rate Table Name is given to generate new Rate Table.
    	IF p_rateTableName IS NOT NULL
	 	THEN


        SET v_RTRowCount_ = (SELECT
                COUNT(*)
            FROM tblRateTable
            WHERE RateTableName = p_rateTableName
            AND CompanyId = (SELECT
                    CompanyId
                FROM tblRateGenerator
                WHERE RateGeneratorID = p_RateGeneratorId));

        IF v_RTRowCount_ > 0
        THEN
            CALL prc_WSJobStatusUpdate  (p_jobId, 'F', 'RateTable Name is already exist, Please try using another RateTable Name', '');
            LEAVE GenerateRateTable;
        END IF;
    	END IF;

		DROP TEMPORARY TABLE IF EXISTS tmp_Rates_;
		CREATE TEMPORARY TABLE tmp_Rates_  (
		  code VARCHAR(50) COLLATE utf8_unicode_ci,
		  rate DECIMAL(18, 6),
		  ConnectionFee DECIMAL(18, 6),
		  INDEX tmp_Rates_code (`code`) ,
  	     UNIQUE KEY `unique_code` (`code`)

		);
		DROP TEMPORARY TABLE IF EXISTS tmp_Rates2_;
		CREATE TEMPORARY TABLE tmp_Rates2_  (
		  code VARCHAR(50) COLLATE utf8_unicode_ci,
		  rate DECIMAL(18, 6),
		  ConnectionFee DECIMAL(18, 6),
		  INDEX tmp_Rates2_code (`code`)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_Codedecks_;
		CREATE TEMPORARY TABLE tmp_Codedecks_ (
        CodeDeckId INT
    	);
     	DROP TEMPORARY TABLE IF EXISTS tmp_Raterules_;

     	CREATE TEMPORARY TABLE tmp_Raterules_  (
        rateruleid INT,
        code VARCHAR(50) COLLATE utf8_unicode_ci,
        RowNo INT,
        INDEX tmp_Raterules_code (`code`),
        INDEX tmp_Raterules_rateruleid (`rateruleid`),
        INDEX tmp_Raterules_RowNo (`RowNo`)
    	);
     	DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_;
     	CREATE TEMPORARY TABLE tmp_Vendorrates_  (
        code VARCHAR(50) COLLATE utf8_unicode_ci,
        rate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        AccountId INT,
        RowNo INT,
        PreferenceRank INT,
        INDEX tmp_Vendorrates_code (`code`),
        INDEX tmp_Vendorrates_rate (`rate`)
    	);


    	DROP TEMPORARY TABLE IF EXISTS tmp_VRatesstage2_;
     	CREATE TEMPORARY TABLE tmp_VRatesstage2_  (
		RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
        code VARCHAR(50) COLLATE utf8_unicode_ci,
        rate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        FinalRankNumber int,
        INDEX tmp_Vendorrates_stage2__code (`RowCode`)
    	);
     DROP TEMPORARY TABLE IF EXISTS tmp_dupVRatesstage2_;
     	CREATE TEMPORARY TABLE tmp_dupVRatesstage2_  (
		RowCode VARCHAR(50)  COLLATE utf8_unicode_ci,
        FinalRankNumber int,
        INDEX tmp_dupVendorrates_stage2__code (`RowCode`)
    	);
     DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_stage3_;
     CREATE TEMPORARY TABLE tmp_Vendorrates_stage3_  (
        RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
        rate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        INDEX tmp_Vendorrates_stage2__code (`RowCode`)
    	);

     	DROP TEMPORARY TABLE IF EXISTS tmp_code_;
     	CREATE TEMPORARY TABLE tmp_code_  (
        code VARCHAR(50) COLLATE utf8_unicode_ci,
        INDEX tmp_code_code (`code`)
    	);

     DROP TEMPORARY TABLE IF EXISTS tmp_all_code_;
  CREATE TEMPORARY TABLE tmp_all_code_ (
     RowCode  varchar(50) COLLATE utf8_unicode_ci,
     Code  varchar(50) COLLATE utf8_unicode_ci,
     RowNo int,
     INDEX Index2 (Code)
   );



      DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_;
       CREATE TEMPORARY TABLE tmp_VendorRate_stage_ (
          RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
          AccountId INT ,
          AccountName VARCHAR(100) ,
          Code VARCHAR(50) COLLATE utf8_unicode_ci,
          Rate DECIMAL(18,6) ,
          ConnectionFee DECIMAL(18,6) ,
          EffectiveDate DATETIME ,
          Description VARCHAR(255),
          Preference INT,
          MaxMatchRank int ,
          prev_prev_RowCode VARCHAR(50),
          prev_AccountID int
        );
-- LCR Logic Table
 DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
  CREATE TEMPORARY TABLE tmp_VendorRate_ (
     AccountId INT ,
     AccountName VARCHAR(100) ,
     Code VARCHAR(50) COLLATE utf8_unicode_ci,
     Rate DECIMAL(18,6) ,
     ConnectionFee DECIMAL(18,6) ,
     EffectiveDate DATETIME ,
     Description VARCHAR(255),
     Preference INT,
     RowCode VARCHAR(50) COLLATE utf8_unicode_ci
   );
   DROP TEMPORARY TABLE IF EXISTS tmp_final_VendorRate_;
  CREATE TEMPORARY TABLE tmp_final_VendorRate_ (
     AccountId INT ,
     AccountName VARCHAR(100) ,
     Code VARCHAR(50) COLLATE utf8_unicode_ci,
     Rate DECIMAL(18,6) ,
     ConnectionFee DECIMAL(18,6) ,
     EffectiveDate DATETIME ,
     Description VARCHAR(255),
     Preference INT,
     RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
     FinalRankNumber int,
		INDEX IX_CODE (RowCode)
   );

   DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_(
			AccountId int,
            AccountName varchar(200),
			Code varchar(50) COLLATE utf8_unicode_ci,
			Description varchar(200) ,
			Rate DECIMAL(18,6) ,
               ConnectionFee DECIMAL(18,6) ,
			EffectiveDate date,
			TrunkID int,
			CountryID int,
			RateID int,
			Preference int,
			INDEX IX_CODE (Code)
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates1_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates1_(
		AccountId int,
		AccountName varchar(200),
		Code varchar(50),
		Description varchar(200),
		Rate DECIMAL(18,6) ,
		ConnectionFee DECIMAL(18,6) ,
		EffectiveDate date,
		TrunkID int,
		CountryID int,
		RateID int,
		Preference int,
		INDEX IX_Code (Code),
		INDEX tmp_VendorCurrentRates_AccountId (`AccountId`,`TrunkID`,`RateId`,`EffectiveDate`)
	);

    	SELECT CurrencyID INTO v_CurrencyID_ FROM  tblRateGenerator WHERE RateGeneratorId = p_RateGeneratorId;

    	SELECT
        UsePreference,
        rateposition,
        companyid ,
        CodeDeckId,
        tblRateGenerator.TrunkID,
        tblRateGenerator.UseAverage  ,
        tblRateGenerator.RateGeneratorName INTO v_Use_Preference_, v_RatePosition_, v_CompanyId_, v_codedeckid_, v_trunk_, v_Average_, v_RateGeneratorName_
    	FROM tblRateGenerator
    	WHERE RateGeneratorId = p_RateGeneratorId;


	SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = v_CompanyId_;


      -- select v_Use_Preference_,v_CurrencyID_,v_RatePosition_, v_CompanyId_, v_codedeckid_, v_trunk_, v_Average_, v_RateGeneratorName_;

    	INSERT INTO tmp_Raterules_
	   SELECT
            rateruleid,
            tblRateRule.code,
            @row_num := @row_num+1 AS RowID
        FROM tblRateRule,(SELECT @row_num := 0) x
        WHERE rategeneratorid = p_RateGeneratorId
        ORDER BY tblRateRule.Code DESC;

	     INSERT INTO tmp_Codedecks_
	        SELECT DISTINCT
	            tblVendorTrunk.CodeDeckId
	        FROM tblRateRule
	        INNER JOIN tblRateRuleSource
	            ON tblRateRule.RateRuleId = tblRateRuleSource.RateRuleId
	        INNER JOIN tblAccount
	            ON tblAccount.AccountID = tblRateRuleSource.AccountId and tblAccount.IsVendor = 1
			JOIN tblVendorTrunk
	                ON tblAccount.AccountId = tblVendorTrunk.AccountID
	                AND  tblVendorTrunk.TrunkID = v_trunk_
	                AND tblVendorTrunk.Status = 1
	        WHERE RateGeneratorId = p_RateGeneratorId;

	    SET v_pointer_ = 1;
	    SET v_rowCount_ = (SELECT COUNT(distinct Code ) FROM tmp_Raterules_);


		-- Step 1
		-- Get all Codes in one go.
		insert into tmp_code_
          SELECT  DISTINCT LEFT(f.Code, x.RowNo) as loopCode FROM (
          SELECT @RowNo  := @RowNo + 1 as RowNo
          FROM mysql.help_category
          ,(SELECT @RowNo := 0 ) x
          limit 15
          ) x
          INNER JOIN
          (SELECT
                    distinct
	                tblRate.code
	            FROM tblRate
	            JOIN tmp_Raterules_ rr
	                ON tblRate.code LIKE (REPLACE(rr.code,
	                '*', '%%'))
					where  tblRate.CodeDeckId = v_codedeckid_
	          Order by tblRate.code
          ) as f
          ON   x.RowNo   <= LENGTH(f.Code)
          order by loopCode   desc;



	/*
 	-- Step3
	-- get All VendorRates against tmp_code_
  		*/

		SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = v_CompanyId_;
		SET @IncludeAccountIds = (SELECT GROUP_CONCAT(AccountId) from tblRateRule rr inner join  tblRateRuleSource rrs on rr.RateRuleId = rrs.RateRuleId where rr.RateGeneratorId = p_RateGeneratorId ) ;



	  -- Collect Vendor Rates
	 INSERT INTO tmp_VendorCurrentRates1_
	 Select DISTINCT AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
      FROM (
				SELECT  tblVendorRate.AccountId,tblAccount.AccountName, tblRate.Code, tblRate.Description,
				 CASE WHEN  tblAccount.CurrencyId = v_CurrencyID_
								THEN
									   tblVendorRate.Rate
					 WHEN  v_CompanyCurrencyID_ = v_CurrencyID_
							 THEN
								  (
								   ( tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ) )
								 )
							  ELSE
							  (
										-- Convert to base currrncy and x by RateGenerator Exhange
								  (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = v_CurrencyID_ and  CompanyID = v_CompanyId_ )
									* (tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ))
							  )
							 END
								as  Rate,
								 ConnectionFee,
			  DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate,
			    tblVendorRate.TrunkID, tblRate.CountryID, tblRate.RateID,IFNULL(vp.Preference, 5) AS Preference,
				@row_num := IF(@prev_AccountId = tblVendorRate.AccountID AND @prev_TrunkID = tblVendorRate.TrunkID AND @prev_RateId = tblVendorRate.RateID AND @prev_EffectiveDate >= tblVendorRate.EffectiveDate, @row_num + 1, 1) AS RowID,
				@prev_AccountId := tblVendorRate.AccountID,
				@prev_TrunkID := tblVendorRate.TrunkID,
				@prev_RateId := tblVendorRate.RateID,
				@prev_EffectiveDate := tblVendorRate.EffectiveDate
			  FROM      tblVendorRate

					 Inner join tblVendorTrunk vt on vt.CompanyID = v_CompanyId_ AND vt.AccountID = tblVendorRate.AccountID and
							-- ( p_codedeckID = 0 OR ( p_codedeckID > 0 AND vt.CodeDeckId = p_codedeckID ) )
							  vt.Status =  1 and vt.TrunkID =  v_trunk_
                              inner join tmp_Codedecks_ tcd on vt.CodeDeckId = tcd.CodeDeckId
						INNER JOIN tblAccount   ON  tblAccount.CompanyID = v_CompanyId_ AND tblVendorRate.AccountId = tblAccount.AccountID and tblAccount.IsVendor = 1
						INNER JOIN tblRate ON tblRate.CompanyID = v_CompanyId_  AND tblRate.CodeDeckId = vt.CodeDeckId  AND    tblVendorRate.RateId = tblRate.RateID
						INNER JOIN tmp_code_ tcode ON tcode.Code  = tblRate.Code
						LEFT JOIN tblVendorPreference vp
										 ON vp.AccountId = tblVendorRate.AccountId
										 AND vp.TrunkID = tblVendorRate.TrunkID
										 AND vp.RateId = tblVendorRate.RateId
						LEFT OUTER JOIN tblVendorBlocking AS blockCode   ON tblVendorRate.RateId = blockCode.RateId
																	  AND tblVendorRate.AccountId = blockCode.AccountId
																	  AND tblVendorRate.TrunkID = blockCode.TrunkID
						LEFT OUTER JOIN tblVendorBlocking AS blockCountry    ON tblRate.CountryID = blockCountry.CountryId
																	  AND tblVendorRate.AccountId = blockCountry.AccountId
																	  AND tblVendorRate.TrunkID = blockCountry.TrunkID

						,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '', @prev_RateId := '', @prev_EffectiveDate := '') x

			  WHERE
						(
					  		(p_EffectiveRate = 'now' AND EffectiveDate <= NOW())
								OR
							(p_EffectiveRate = 'future' AND EffectiveDate > NOW())
							  	OR
							(p_EffectiveRate = 'effective' AND EffectiveDate <= p_EffectiveDate)
						)
						AND tblAccount.IsVendor = 1
						AND tblAccount.Status = 1
						AND tblAccount.CurrencyId is not NULL
						AND tblVendorRate.TrunkID = v_trunk_
						AND blockCode.RateId IS NULL
					   AND blockCountry.CountryId IS NULL
						AND ( @IncludeAccountIds = NULL
							  OR ( @IncludeAccountIds IS NOT NULL
								   AND FIND_IN_SET(tblVendorRate.AccountId,@IncludeAccountIds) > 0
								 )
							)
				ORDER BY tblVendorRate.AccountId, tblVendorRate.TrunkID, tblVendorRate.RateId, tblVendorRate.EffectiveDate DESC
		) tbl
		order by Code asc;

      INSERT INTO tmp_VendorCurrentRates_
	  Select AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
      FROM (
			  SELECT * ,
				@row_num := IF(@prev_AccountId = AccountID AND @prev_TrunkID = TrunkID AND @prev_RateId = RateID AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
				@prev_AccountId := AccountID,
				@prev_TrunkID := TrunkID,
				@prev_RateId := RateID,
				@prev_EffectiveDate := EffectiveDate
			  FROM tmp_VendorCurrentRates1_
			  ,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '', @prev_RateId := '', @prev_EffectiveDate := '') x
           ORDER BY AccountId, TrunkID, RateId, EffectiveDate DESC
		) tbl
		 WHERE RowID = 1
		order by Code asc;

	--  3 Sort with Rank by Preference or Rate as per setting in RateGenerator

     -- select * from tmp_VendorCurrentRates_;

     -- Collect Codes pressent in vendor Rates from above query.
          /*
                    9372     9372    1
                    9372     937     2
                    9372     93      3
                    9372     9       4

            */

        insert into tmp_all_code_ (RowCode,Code,RowNo)
               select RowCode , loopCode,RowNo
               from (
                    select   RowCode , loopCode,
                    @RowNo := ( CASE WHEN (@prev_Code  = tbl1.RowCode  ) THEN @RowNo + 1
                                   ELSE 1
                                   END

                              )      as RowNo,
                    @prev_Code := tbl1.RowCode

                    from (
                              SELECT distinct f.Code as RowCode, LEFT(f.Code, x.RowNo) as loopCode FROM (
                                SELECT @RowNo  := @RowNo + 1 as RowNo
                                FROM mysql.help_category
                                ,(SELECT @RowNo := 0 ) x
                                limit 15
                              ) x
                              INNER JOIN
										(
											select distinct Code from
											tmp_VendorCurrentRates_
										) AS f
                              ON  x.RowNo   <= LENGTH(f.Code)
                              order by RowCode desc,  LENGTH(loopCode) DESC
                    ) tbl1
                    , ( Select @RowNo := 0 ) x
                ) tbl order by RowCode desc,  LENGTH(loopCode) DESC ;






-- --------- Split Logic ----------
/* DESC             MaxMatchRank 1  MaxMatchRank 2
923 Pakistan :       *923 V1          92 V1
923 Pakistan :       *92 V2            -

now take only where  MaxMatchRank =  1
*/
                                             DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1;
                                             CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate_stage_1 as (select * from tmp_VendorRate_stage_);

                                              insert ignore into tmp_VendorRate_stage_1 (
                                                	     RowCode,
                                                  	AccountId ,
                                                  	AccountName ,
                                                  	Code ,
                                                  	Rate ,
                                                  	ConnectionFee,
                                                  	EffectiveDate ,
                                                  	Description ,
                                                  	Preference
                                             )
                                             SELECT
                                             distinct
                                        	RowCode,
                                        	v.AccountId ,
                                        	v.AccountName ,
                                        	v.Code ,
                                        	v.Rate ,
                                        	v.ConnectionFee,
                                        	v.EffectiveDate ,
                                        	v.Description ,
                                        	v.Preference
                                             FROM tmp_VendorCurrentRates_ v
                                             Inner join  tmp_all_code_
                                   			SplitCode   on v.Code = SplitCode.Code
                                            where  SplitCode.Code is not null
                                            order by AccountID,SplitCode.RowCode desc ,LENGTH(SplitCode.RowCode), v.Code desc, LENGTH(v.Code)  desc;

-- --------------------------------------------------------

                                             insert into tmp_VendorRate_stage_
                                             SELECT
                    						RowCode,
                    						v.AccountId ,
                    						v.AccountName ,
                    						v.Code ,
                    						v.Rate ,
                    						v.ConnectionFee,
                    						v.EffectiveDate ,
                    						v.Description ,
                    						v.Preference,
                    						@rank := ( CASE WHEN ( @prev_RowCode   = RowCode and   @prev_AccountID = v.AccountId   )
                                                            THEN @rank + 1
                                                            ELSE 1  END ) AS MaxMatchRank,

                    						@prev_RowCode := RowCode	 as prev_RowCode,
                                                  @prev_AccountID := v.AccountId as prev_AccountID
                    					 FROM tmp_VendorRate_stage_1 v
                                             , (SELECT  @prev_RowCode := '',  @rank := 0 , @prev_Code := '' , @prev_AccountID := Null) f
                                             order by AccountID,RowCode desc ;


                                       truncate tmp_VendorRate_;
                                       insert into tmp_VendorRate_
                                       select
									 AccountId ,
									 AccountName ,
									 Code ,
									 Rate ,
         						           ConnectionFee,
									 EffectiveDate ,
									 Description ,
									 Preference,
									 RowCode
							   from tmp_VendorRate_stage_
                                           where MaxMatchRank = 1 order by RowCode desc;




			-- -----------------------------LCR Logic
		-- select * from tmp_final_VendorRate_;
		-- Truncate tmp_VendorRate_;
	  WHILE v_pointer_ <= v_rowCount_
	    DO

             SET v_rateRuleId_ = (SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = v_pointer_);
           --  SET @IncludeAccountIds = (SELECT GROUP_CONCAT(AccountId) from tblRateRuleSource where RateRuleId = v_rateRuleId_ ) ;

		INSERT INTO tmp_Rates2_ (code,rate,ConnectionFee)
		select  code,rate,ConnectionFee from tmp_Rates_;



		truncate tmp_final_VendorRate_;

		IF( v_Use_Preference_ = 0 )
     	THEN

			insert into tmp_final_VendorRate_
			SELECT
			     AccountId ,
			     AccountName ,
			     Code ,
			     Rate ,
                    ConnectionFee,
			     EffectiveDate ,
			     Description ,
			     Preference,
			     RowCode,
	  		     FinalRankNumber
				from
				(
					SELECT
					  vr.AccountId ,
				     vr.AccountName ,
				     vr.Code ,
				     vr.Rate ,
                 vr.ConnectionFee,
				     vr.EffectiveDate ,
				     vr.Description ,
				     vr.Preference,
				     vr.RowCode,
   			         @rank := CASE WHEN ( @prev_RowCode = vr.RowCode  AND @prev_Rate <  vr.Rate ) THEN @rank+1
                                      WHEN ( @prev_RowCode  = vr.RowCode  AND @prev_Rate = vr.Rate) THEN @rank
						   ELSE
						   1
						   END
				  		  AS FinalRankNumber,
				  	@prev_RowCode  := vr.RowCode,
					@prev_Rate  := vr.Rate
					from (
								select tmpvr.*
							  from tmp_VendorRate_  tmpvr
							  inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = v_rateRuleId_ and tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%'))
			     			  inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountId = tmpvr.AccountId
					) vr
					,(SELECT @rank := 0 , @prev_RowCode := '' , @prev_Rate := 0  ) x
				 	order by vr.RowCode,vr.Rate,vr.AccountId ASC

				) tbl1
				where FinalRankNumber <= v_RatePosition_;

		 ELSE

		 	 insert into tmp_final_VendorRate_
			SELECT
				AccountId ,
			     AccountName ,
			     Code ,
			     Rate ,
                    ConnectionFee,
			     EffectiveDate ,
			     Description ,
			     Preference,
			     RowCode,
	  		     FinalRankNumber
				from
				(
					SELECT
     				 	vr.AccountId ,
				     vr.AccountName ,
				     vr.Code ,
				     vr.Rate ,
                 vr.ConnectionFee,
				     vr.EffectiveDate ,
				     vr.Description ,
				     vr.Preference,
				     vr.RowCode,
                              @preference_rank := CASE WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference > vr.Preference /*AND @prev_Rate2 <  Rate*/)   THEN @preference_rank + 1
                                                       WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference = vr.Preference AND @prev_Rate < vr.Rate) THEN @preference_rank + 1
                                                       WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference = vr.Preference AND @prev_Rate = vr.Rate) THEN @preference_rank
                                                       ELSE 1 END AS FinalRankNumber,
                              @prev_Code := vr.RowCode,
                              @prev_Preference := vr.Preference,
                              @prev_Rate := vr.Rate
					from (
						select tmpvr.*
					  from tmp_VendorRate_  tmpvr
					  inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = v_rateRuleId_ and tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%'))
	     			  inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountId = tmpvr.AccountId
						) vr

                          ,(SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
     			 	 order by vr.RowCode ASC ,vr.Preference DESC ,vr.Rate ASC ,vr.AccountId ASC

				) tbl1
				where 				FinalRankNumber <= v_RatePosition_;

		 END IF;



		truncate   tmp_VRatesstage2_;
		-- Select only code which needs to add margin for currenct  RateRule Only.
	               INSERT INTO tmp_VRatesstage2_
     			SELECT
     				vr.RowCode,
     				vr.code,
     				vr.rate,
     				vr.ConnectionFee,
                         vr.FinalRankNumber
     			FROM tmp_final_VendorRate_ vr
     			 left join tmp_Rates2_ rate on rate.Code = vr.RowCode
     			WHERE  rate.code is null
                   order by vr.FinalRankNumber desc ;



	        IF v_Average_ = 0
	        THEN
                                   insert into tmp_dupVRatesstage2_
                                   SELECT RowCode , MAX(FinalRankNumber) AS MaxFinalRankNumber
                                           FROM tmp_VRatesstage2_ GROUP BY RowCode;

                              truncate tmp_Vendorrates_stage3_;
                              INSERT INTO tmp_Vendorrates_stage3_
                              select  vr.RowCode as RowCode , vr.rate as rate , vr.ConnectionFee as  ConnectionFee
                              from tmp_VRatesstage2_ vr
                              INNER JOIN tmp_dupVRatesstage2_ vr2
                                ON (vr.RowCode = vr2.RowCode AND  vr.FinalRankNumber = vr2.FinalRankNumber);

                    INSERT IGNORE INTO tmp_Rates_
                    SELECT RowCode,
				CASE WHEN rule_mgn.RateRuleId is not null
				THEN
					CASE WHEN AddMargin LIKE '%p'
						THEN ( vRate.rate + (CAST(REPLACE(AddMargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate)
					 ELSE  vRate.rate + AddMargin
					END
				ELSE
				vRate.rate
				END as Rate,
                    ConnectionFee
				  FROM tmp_Vendorrates_stage3_ vRate
				  left join tblRateRuleMargin rule_mgn on  rule_mgn.RateRuleId = v_rateRuleId_ and vRate.rate Between rule_mgn.MinRate and rule_mgn.MaxRate;



	         ELSE -- AVERAGE

	           INSERT IGNORE INTO tmp_Rates_
				SELECT RowCode,
						CASE WHEN rule_mgn.AddMargin is not null
						THEN
							CASE WHEN AddMargin LIKE '%p'
								THEN ( vRate.rate + (CAST(REPLACE(AddMargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate)
							 ELSE  vRate.rate + AddMargin
							END
						ELSE
						vRate.rate
						END as Rate,
                              ConnectionFee
				  FROM (
								select RowCode,
				                    AVG(Rate) as Rate,
				                    AVG(ConnectionFee) as ConnectionFee
								 	from tmp_VRatesstage2_
							 		group by RowCode
				     )  vRate
				  left join tblRateRuleMargin rule_mgn on  rule_mgn.RateRuleId = v_rateRuleId_ and vRate.rate Between rule_mgn.MinRate and rule_mgn.MaxRate;
	        END IF;


	         SET v_pointer_ = v_pointer_ + 1;


	     END WHILE;



        START TRANSACTION;

	    IF p_RateTableId = -1
	    THEN

	        INSERT INTO tblRateTable (CompanyId, RateTableName, RateGeneratorID, TrunkID, CodeDeckId,CurrencyID)
	            VALUES (v_CompanyId_, p_rateTableName, p_RateGeneratorId, v_trunk_, v_codedeckid_,v_CurrencyID_);

	        SET p_RateTableId = LAST_INSERT_ID();

	        INSERT INTO tblRateTableRate (RateID,
	        RateTableId,
	        Rate,
	        EffectiveDate,
	        PreviousRate,
	        Interval1,
	        IntervalN,
	        ConnectionFee
	        )
	            SELECT DISTINCT
	                RateId,
	                p_RateTableId,
	                 Rate,
	                p_EffectiveDate,
	                Rate,
	                Interval1,
	                IntervalN,
	                ConnectionFee
	            FROM tmp_Rates_ rate
	            INNER JOIN tblRate
	                ON rate.code  = tblRate.Code
	            WHERE tblRate.CodeDeckId = v_codedeckid_;

	    ELSE

	    	IF p_delete_exiting_rate = 1
	    	 THEN
			 	 DELETE tblRateTableRate
		            FROM tblRateTableRate
		        WHERE tblRateTableRate.RateTableId = p_RateTableId;
		    END IF;

	        INSERT INTO tblRateTableRate (RateID,
	        RateTableId,
	        Rate,
	        EffectiveDate,
	        PreviousRate,
	        Interval1,
	        IntervalN,
	        ConnectionFee
	        )
	            SELECT DISTINCT
	                tblRate.RateId,
	                p_RateTableId RateTableId,
	                rate.Rate,
	                p_EffectiveDate EffectiveDate,
	                rate.Rate,
	                tblRate.Interval1,
	                tblRate.IntervalN,
	                rate.ConnectionFee
	            FROM tmp_Rates_ rate
	            INNER JOIN tblRate
	                ON rate.code  = tblRate.Code
	            LEFT JOIN tblRateTableRate tbl1
	                ON tblRate.RateId = tbl1.RateId
	                AND tbl1.RateTableId = p_RateTableId
	            LEFT JOIN tblRateTableRate tbl2
	            ON tblRate.RateId = tbl2.RateId
	            and tbl2.EffectiveDate = p_EffectiveDate
	            AND tbl2.RateTableId = p_RateTableId
	            WHERE  (    tbl1.RateTableRateID IS NULL
	                    OR
	                    (
	                        tbl2.RateTableRateID IS NULL
	                        AND  tbl1.EffectiveDate != p_EffectiveDate

	                    )
	                 )
	            AND tblRate.CodeDeckId = v_codedeckid_;

	        UPDATE tblRateTableRate
	        INNER JOIN tblRate
	            ON tblRate.RateId = tblRateTableRate.RateId
	            AND tblRateTableRate.RateTableId = p_RateTableId
	            AND tblRateTableRate.EffectiveDate = p_EffectiveDate
	         INNER JOIN tmp_Rates_ as rate
	          ON  rate.code  = tblRate.Code
	          SET tblRateTableRate.PreviousRate = tblRateTableRate.Rate,
	            tblRateTableRate.EffectiveDate = p_EffectiveDate,
	            tblRateTableRate.Rate = rate.Rate,
	            tblRateTableRate.ConnectionFee = rate.ConnectionFee,
	            tblRateTableRate.updated_at = NOW(),
	            tblRateTableRate.ModifiedBy = 'RateManagementService',
	            tblRateTableRate.Interval1 = tblRate.Interval1,
	            tblRateTableRate.IntervalN = tblRate.IntervalN
	        WHERE tblRate.CodeDeckId = v_codedeckid_
	        AND rate.rate != tblRateTableRate.Rate;

	        DELETE tblRateTableRate
	            FROM tblRateTableRate
	        WHERE tblRateTableRate.RateTableId = p_RateTableId
	            AND RateId NOT IN (SELECT DISTINCT
	                    RateId
	                FROM tmp_Rates_ rate
	                INNER JOIN tblRate
	                    ON rate.code  = tblRate.Code
	                WHERE tblRate.CodeDeckId = v_codedeckid_)
	            AND tblRateTableRate.EffectiveDate = p_EffectiveDate;


	    END IF;


		UPDATE tblRateTable
	   SET RateGeneratorID = p_RateGeneratorId,
		  TrunkID = v_trunk_,
		  CodeDeckId = v_codedeckid_,
		  updated_at = now()
		WHERE RateTableID = p_RateTableId;

      SELECT p_RateTableId as RateTableID;

    	CALL prc_WSJobStatusUpdate(p_jobId, 'S', 'RateTable Created Successfully', '');

    COMMIT;


    	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;



END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTableWithPrefix`;

DELIMITER |
CREATE PROCEDURE `prc_WSGenerateRateTableWithPrefix`(
	IN `p_jobId` INT,
	IN `p_RateGeneratorId` INT,
	IN `p_RateTableId` INT,
	IN `p_rateTableName` VARCHAR(200),
	IN `p_EffectiveDate` VARCHAR(10),
	IN `p_delete_exiting_rate` INT,
	IN `p_EffectiveRate` VARCHAR(50)
)
GenerateRateTable:BEGIN


	DECLARE v_RTRowCount_ INT;
	DECLARE v_RatePosition_ INT;
	DECLARE v_Use_Preference_ INT;
	DECLARE v_CurrencyID_ INT;
	DECLARE v_CompanyCurrencyID_ INT;
	DECLARE v_Average_ TINYINT;
	DECLARE v_CompanyId_ INT;
	DECLARE v_codedeckid_ INT;
	DECLARE v_trunk_ INT;
	DECLARE v_rateRuleId_ INT;
	DECLARE v_RateGeneratorName_ VARCHAR(200);
	DECLARE v_pointer_ INT ;
	DECLARE v_rowCount_ INT ;


	-- ----- LCR Variables
	DECLARE v_tmp_code_cnt int ;
	DECLARE v_tmp_code_pointer int;
	DECLARE v_p_code varchar(50);
	DECLARE v_Codlen_ int;
	DECLARE v_p_code__ VARCHAR(50);
	DECLARE v_Commit int;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
             show warnings;
		   ROLLBACK;
		   CALL prc_WSJobStatusUpdate(p_jobId, 'F', 'RateTable generation failed', '');

    END;

     SET @@session.collation_connection='utf8_unicode_ci';
     SET @@session.character_set_client='utf8';

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

   --

    SET p_EffectiveDate = CAST(p_EffectiveDate AS DATE);

    -- when Rate Table Name is given to generate new Rate Table.
    	IF p_rateTableName IS NOT NULL
	 	THEN


        SET v_RTRowCount_ = (SELECT
                COUNT(*)
            FROM tblRateTable
            WHERE RateTableName = p_rateTableName
            AND CompanyId = (SELECT
                    CompanyId
                FROM tblRateGenerator
                WHERE RateGeneratorID = p_RateGeneratorId));

        IF v_RTRowCount_ > 0
        THEN
            CALL prc_WSJobStatusUpdate  (p_jobId, 'F', 'RateTable Name is already exist, Please try using another RateTable Name', '');
            LEAVE GenerateRateTable;
        END IF;
    	END IF;

		DROP TEMPORARY TABLE IF EXISTS tmp_Rates_;
		CREATE TEMPORARY TABLE tmp_Rates_  (
		  code VARCHAR(50) COLLATE utf8_unicode_ci,
		  rate DECIMAL(18, 6),
		  ConnectionFee DECIMAL(18, 6),
		  INDEX tmp_Rates_code (`code`),
 	     UNIQUE KEY `unique_code` (`code`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_Rates2_;
		CREATE TEMPORARY TABLE tmp_Rates2_  (
		  code VARCHAR(50) COLLATE utf8_unicode_ci,
		  rate DECIMAL(18, 6),
		  ConnectionFee DECIMAL(18, 6),
		  INDEX tmp_Rates2_code (`code`)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_Codedecks_;
		CREATE TEMPORARY TABLE tmp_Codedecks_ (
        CodeDeckId INT
    	);
     	DROP TEMPORARY TABLE IF EXISTS tmp_Raterules_;

     	CREATE TEMPORARY TABLE tmp_Raterules_  (
        rateruleid INT,
        code VARCHAR(50) COLLATE utf8_unicode_ci,
        RowNo INT,
        INDEX tmp_Raterules_code (`code`),
        INDEX tmp_Raterules_rateruleid (`rateruleid`),
        INDEX tmp_Raterules_RowNo (`RowNo`)
    	);
     	DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_;
     	CREATE TEMPORARY TABLE tmp_Vendorrates_  (
        code VARCHAR(50) COLLATE utf8_unicode_ci,
        rate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        AccountId INT,
        RowNo INT,
        PreferenceRank INT,
        INDEX tmp_Vendorrates_code (`code`),
        INDEX tmp_Vendorrates_rate (`rate`)
    	);


    	DROP TEMPORARY TABLE IF EXISTS tmp_VRatesstage2_;
     	CREATE TEMPORARY TABLE tmp_VRatesstage2_  (
		RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
        code VARCHAR(50) COLLATE utf8_unicode_ci,
        rate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        FinalRankNumber int,
        INDEX tmp_Vendorrates_stage2__code (`RowCode`)
    	);
     DROP TEMPORARY TABLE IF EXISTS tmp_dupVRatesstage2_;
     	CREATE TEMPORARY TABLE tmp_dupVRatesstage2_  (
		RowCode VARCHAR(50)  COLLATE utf8_unicode_ci,
        FinalRankNumber int,
        INDEX tmp_dupVendorrates_stage2__code (`RowCode`)
    	);
     DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_stage3_;
     CREATE TEMPORARY TABLE tmp_Vendorrates_stage3_  (
        RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
        rate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        INDEX tmp_Vendorrates_stage2__code (`RowCode`)
    	);

     	DROP TEMPORARY TABLE IF EXISTS tmp_code_;
     	CREATE TEMPORARY TABLE tmp_code_  (
        code VARCHAR(50) COLLATE utf8_unicode_ci,
        INDEX tmp_code_code (`code`)
    	);

     DROP TEMPORARY TABLE IF EXISTS tmp_all_code_;
  CREATE TEMPORARY TABLE tmp_all_code_ (
     RowCode  varchar(50) COLLATE utf8_unicode_ci,
     Code  varchar(50) COLLATE utf8_unicode_ci,
     RowNo int,
     INDEX Index2 (Code)
   );



      DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_;
       CREATE TEMPORARY TABLE tmp_VendorRate_stage_ (
          RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
          AccountId INT ,
          AccountName VARCHAR(100) ,
          Code VARCHAR(50) COLLATE utf8_unicode_ci,
          Rate DECIMAL(18,6) ,
          ConnectionFee DECIMAL(18,6) ,
          EffectiveDate DATETIME ,
          Description VARCHAR(255),
          Preference INT,
          MaxMatchRank int ,
          prev_prev_RowCode VARCHAR(50),
          prev_AccountID int
        );
-- LCR Logic Table
 DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
  CREATE TEMPORARY TABLE tmp_VendorRate_ (
     AccountId INT ,
     AccountName VARCHAR(100) ,
     Code VARCHAR(50) COLLATE utf8_unicode_ci,
     Rate DECIMAL(18,6) ,
     ConnectionFee DECIMAL(18,6) ,
     EffectiveDate DATETIME ,
     Description VARCHAR(255),
     Preference INT,
     RowCode VARCHAR(50) COLLATE utf8_unicode_ci
   );
   DROP TEMPORARY TABLE IF EXISTS tmp_final_VendorRate_;
  CREATE TEMPORARY TABLE tmp_final_VendorRate_ (
     AccountId INT ,
     AccountName VARCHAR(100) ,
     Code VARCHAR(50) COLLATE utf8_unicode_ci,
     Rate DECIMAL(18,6) ,
     ConnectionFee DECIMAL(18,6) ,
     EffectiveDate DATETIME ,
     Description VARCHAR(255),
     Preference INT,
     RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
     FinalRankNumber int,
		INDEX IX_CODE (RowCode)
   );

   DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_(
			AccountId int,
            AccountName varchar(200),
			Code varchar(50) COLLATE utf8_unicode_ci,
			Description varchar(200) ,
			Rate DECIMAL(18,6) ,
               ConnectionFee DECIMAL(18,6) ,
			EffectiveDate date,
			TrunkID int,
			CountryID int,
			RateID int,
			Preference int,
			INDEX IX_CODE (Code)
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates1_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates1_(
		AccountId int,
		AccountName varchar(200),
		Code varchar(50),
		Description varchar(200),
		Rate DECIMAL(18,6) ,
		ConnectionFee DECIMAL(18,6) ,
		EffectiveDate date,
		TrunkID int,
		CountryID int,
		RateID int,
		Preference int,
		INDEX IX_Code (Code),
		INDEX tmp_VendorCurrentRates_AccountId (`AccountId`,`TrunkID`,`RateId`,`EffectiveDate`)
	);

    	SELECT CurrencyID INTO v_CurrencyID_ FROM  tblRateGenerator WHERE RateGeneratorId = p_RateGeneratorId;

    	SELECT
        UsePreference,
        rateposition,
        companyid ,
        CodeDeckId,
        tblRateGenerator.TrunkID,
        tblRateGenerator.UseAverage  ,
        tblRateGenerator.RateGeneratorName INTO v_Use_Preference_, v_RatePosition_, v_CompanyId_, v_codedeckid_, v_trunk_, v_Average_, v_RateGeneratorName_
    	FROM tblRateGenerator
    	WHERE RateGeneratorId = p_RateGeneratorId;


	SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = v_CompanyId_;


      -- select v_Use_Preference_,v_CurrencyID_,v_RatePosition_, v_CompanyId_, v_codedeckid_, v_trunk_, v_Average_, v_RateGeneratorName_;

    	INSERT INTO tmp_Raterules_
	   SELECT
            rateruleid,
            tblRateRule.code,
            @row_num := @row_num+1 AS RowID
        FROM tblRateRule,(SELECT @row_num := 0) x
        WHERE rategeneratorid = p_RateGeneratorId
        ORDER BY tblRateRule.Code DESC;

	     INSERT INTO tmp_Codedecks_
	        SELECT DISTINCT
	            tblVendorTrunk.CodeDeckId
	        FROM tblRateRule
	        INNER JOIN tblRateRuleSource
	            ON tblRateRule.RateRuleId = tblRateRuleSource.RateRuleId
	        INNER JOIN tblAccount
	            ON tblAccount.AccountID = tblRateRuleSource.AccountId and tblAccount.IsVendor = 1
			JOIN tblVendorTrunk
	                ON tblAccount.AccountId = tblVendorTrunk.AccountID
	                AND  tblVendorTrunk.TrunkID = v_trunk_
	                AND tblVendorTrunk.Status = 1
	        WHERE RateGeneratorId = p_RateGeneratorId;

	    SET v_pointer_ = 1;
	    SET v_rowCount_ = (SELECT COUNT(distinct Code ) FROM tmp_Raterules_);


		-- Step 1
		-- Get all Codes in one go.


		-- Old Way - Exact Match Code
		insert into tmp_code_
		SELECT
			tblRate.code
		FROM tblRate
		JOIN tmp_Codedecks_ cd
			ON tblRate.CodeDeckId = cd.CodeDeckId
		JOIN tmp_Raterules_ rr
			ON tblRate.code LIKE (REPLACE(rr.code,'*', '%%'))
		Order by tblRate.code ;


		-- New Way 9134,913,91
		/*
		insert into tmp_code_
          SELECT  DISTINCT LEFT(f.Code, x.RowNo) as loopCode FROM (
          SELECT @RowNo  := @RowNo + 1 as RowNo
          FROM mysql.help_category
          ,(SELECT @RowNo := 0 ) x
          limit 15
          ) x
          INNER JOIN
          (SELECT
                    distinct
	                tblRate.code
	            FROM tblRate
	            JOIN tmp_Raterules_ rr
	                ON tblRate.code LIKE (REPLACE(rr.code,
	                '*', '%%'))
					where  tblRate.CodeDeckId = v_codedeckid_
	          Order by tblRate.code
          ) as f
          ON   x.RowNo   <= LENGTH(f.Code)
          order by loopCode   desc;
		  */



	/*
 	-- Step3
	-- get All VendorRates against tmp_code_
  		*/

		SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = v_CompanyId_;
		SET @IncludeAccountIds = (SELECT GROUP_CONCAT(AccountId) from tblRateRule rr inner join  tblRateRuleSource rrs on rr.RateRuleId = rrs.RateRuleId where rr.RateGeneratorId = p_RateGeneratorId ) ;


     -- Collect Vendor Rates
	 INSERT INTO tmp_VendorCurrentRates1_
	 Select DISTINCT AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
      FROM (
				SELECT  tblVendorRate.AccountId,tblAccount.AccountName, tblRate.Code, tblRate.Description,
				 CASE WHEN  tblAccount.CurrencyId = v_CurrencyID_
								THEN
									   tblVendorRate.Rate
					 WHEN  v_CompanyCurrencyID_ = v_CurrencyID_
							 THEN
								  (
								   ( tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ) )
								 )
							  ELSE
							  (
										-- Convert to base currrncy and x by RateGenerator Exhange
								  (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = v_CurrencyID_ and  CompanyID = v_CompanyId_ )
									* (tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ))
							  )
							 END
								as  Rate,
								 ConnectionFee,
			  DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate,
			    tblVendorRate.TrunkID, tblRate.CountryID, tblRate.RateID,IFNULL(vp.Preference, 5) AS Preference,
				@row_num := IF(@prev_AccountId = tblVendorRate.AccountID AND @prev_TrunkID = tblVendorRate.TrunkID AND @prev_RateId = tblVendorRate.RateID AND @prev_EffectiveDate >= tblVendorRate.EffectiveDate, @row_num + 1, 1) AS RowID,
				@prev_AccountId := tblVendorRate.AccountID,
				@prev_TrunkID := tblVendorRate.TrunkID,
				@prev_RateId := tblVendorRate.RateID,
				@prev_EffectiveDate := tblVendorRate.EffectiveDate
			  FROM      tblVendorRate

					 Inner join tblVendorTrunk vt on vt.CompanyID = v_CompanyId_ AND vt.AccountID = tblVendorRate.AccountID and
							-- ( p_codedeckID = 0 OR ( p_codedeckID > 0 AND vt.CodeDeckId = p_codedeckID ) )
							  vt.Status =  1 and vt.TrunkID =  v_trunk_
                              inner join tmp_Codedecks_ tcd on vt.CodeDeckId = tcd.CodeDeckId
						INNER JOIN tblAccount   ON  tblAccount.CompanyID = v_CompanyId_ AND tblVendorRate.AccountId = tblAccount.AccountID and tblAccount.IsVendor = 1
						INNER JOIN tblRate ON tblRate.CompanyID = v_CompanyId_  AND tblRate.CodeDeckId = vt.CodeDeckId  AND    tblVendorRate.RateId = tblRate.RateID
						INNER JOIN tmp_code_ tcode ON tcode.Code  = tblRate.Code
						LEFT JOIN tblVendorPreference vp
										 ON vp.AccountId = tblVendorRate.AccountId
										 AND vp.TrunkID = tblVendorRate.TrunkID
										 AND vp.RateId = tblVendorRate.RateId
						LEFT OUTER JOIN tblVendorBlocking AS blockCode   ON tblVendorRate.RateId = blockCode.RateId
																	  AND tblVendorRate.AccountId = blockCode.AccountId
																	  AND tblVendorRate.TrunkID = blockCode.TrunkID
						LEFT OUTER JOIN tblVendorBlocking AS blockCountry    ON tblRate.CountryID = blockCountry.CountryId
																	  AND tblVendorRate.AccountId = blockCountry.AccountId
																	  AND tblVendorRate.TrunkID = blockCountry.TrunkID

						,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '', @prev_RateId := '', @prev_EffectiveDate := '') x

			  WHERE
						(
					  		(p_EffectiveRate = 'now' AND EffectiveDate <= NOW())
								OR
							(p_EffectiveRate = 'future' AND EffectiveDate > NOW())
							  	OR
							(p_EffectiveRate = 'effective' AND EffectiveDate <= p_EffectiveDate)
						)
						AND tblAccount.IsVendor = 1
						AND tblAccount.Status = 1
						AND tblAccount.CurrencyId is not NULL
						AND tblVendorRate.TrunkID = v_trunk_
						AND blockCode.RateId IS NULL
					   AND blockCountry.CountryId IS NULL
						AND ( @IncludeAccountIds = NULL
							  OR ( @IncludeAccountIds IS NOT NULL
								   AND FIND_IN_SET(tblVendorRate.AccountId,@IncludeAccountIds) > 0
								 )
							)
				ORDER BY tblVendorRate.AccountId, tblVendorRate.TrunkID, tblVendorRate.RateId, tblVendorRate.EffectiveDate DESC
		) tbl
		order by Code asc;

      INSERT INTO tmp_VendorCurrentRates_
	  Select AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
      FROM (
			  SELECT * ,
				@row_num := IF(@prev_AccountId = AccountID AND @prev_TrunkID = TrunkID AND @prev_RateId = RateID AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
				@prev_AccountId := AccountID,
				@prev_TrunkID := TrunkID,
				@prev_RateId := RateID,
				@prev_EffectiveDate := EffectiveDate
			  FROM tmp_VendorCurrentRates1_
			  ,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '', @prev_RateId := '', @prev_EffectiveDate := '') x
           ORDER BY AccountId, TrunkID, RateId, EffectiveDate DESC
		) tbl
		 WHERE RowID = 1
		order by Code asc;

	--  3 Sort with Rank by Preference or Rate as per setting in RateGenerator

     -- select * from tmp_VendorCurrentRates_;

     -- Collect Codes pressent in vendor Rates from above query.
          /*
                    9372     9372    1
                    9372     937     2
                    9372     93      3
                    9372     9       4


        --- Create new tempCode table with all codes offered in VendorRates.
		*/

		-- Old Way
		insert into tmp_all_code_ (RowCode,Code,RowNo)
               select RowCode , loopCode,RowNo
               from (
                    select   RowCode , loopCode,
                    @RowNo := ( CASE WHEN (@prev_Code  = tbl1.RowCode  ) THEN @RowNo + 1
                                   ELSE 1
                                   END

                              )      as RowNo,
                    @prev_Code := tbl1.RowCode
                    from (
							select distinct Code as RowCode, Code as  loopCode from
							tmp_VendorCurrentRates_
                    ) tbl1
                    , ( Select @RowNo := 0 ) x
                ) tbl order by RowCode desc,  LENGTH(loopCode) DESC ;


		-- New Way
        /* insert into tmp_all_code_ (RowCode,Code,RowNo)
               select RowCode , loopCode,RowNo
               from (
                    select   RowCode , loopCode,
                    @RowNo := ( CASE WHEN (@prev_Code  = tbl1.RowCode  ) THEN @RowNo + 1
                                   ELSE 1
                                   END

                              )      as RowNo,
                    @prev_Code := tbl1.RowCode

                    from (
                              SELECT distinct f.Code as RowCode, LEFT(f.Code, x.RowNo) as loopCode FROM (
                                SELECT @RowNo  := @RowNo + 1 as RowNo
                                FROM mysql.help_category
                                ,(SELECT @RowNo := 0 ) x
                                limit 15
                              ) x
                              INNER JOIN
										(
											select distinct Code from
											tmp_VendorCurrentRates_
										) AS f
                              ON  x.RowNo   <= LENGTH(f.Code)
                              order by RowCode desc,  LENGTH(loopCode) DESC
                    ) tbl1
                    , ( Select @RowNo := 0 ) x
                ) tbl order by RowCode desc,  LENGTH(loopCode) DESC ;
			*/





-- ---------New Way MaxMatchRank Logic ----------
/* DESC             MaxMatchRank 1  MaxMatchRank 2
923 Pakistan :       *923 V1          92 V1
923 Pakistan :       *92 V2            -

now take only where  MaxMatchRank =  1
*/
                                          /*   DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1;
                                             CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate_stage_1 as (select * from tmp_VendorRate_stage_);

                                              insert ignore into tmp_VendorRate_stage_1 (
                                                	     RowCode,
                                                  	AccountId ,
                                                  	AccountName ,
                                                  	Code ,
                                                  	Rate ,
                                                  	ConnectionFee,
                                                  	EffectiveDate ,
                                                  	Description ,
                                                  	Preference
                                             )
                                             SELECT
                                             distinct
                                        	RowCode,
                                        	v.AccountId ,
                                        	v.AccountName ,
                                        	v.Code ,
                                        	v.Rate ,
                                        	v.ConnectionFee,
                                        	v.EffectiveDate ,
                                        	v.Description ,
                                        	v.Preference
                                             FROM tmp_VendorCurrentRates_ v
                                             Inner join  tmp_all_code_
                                   			SplitCode   on v.Code = SplitCode.Code
                                            where  SplitCode.Code is not null
                                            order by AccountID,SplitCode.RowCode desc ,LENGTH(SplitCode.RowCode), v.Code desc, LENGTH(v.Code)  desc;





										  insert into tmp_VendorRate_stage_
                                             SELECT
                    						RowCode,
                    						v.AccountId ,
                    						v.AccountName ,
                    						v.Code ,
                    						v.Rate ,
                    						v.ConnectionFee,
                    						v.EffectiveDate ,
                    						v.Description ,
                    						v.Preference,
                    						@rank := ( CASE WHEN ( @prev_RowCode   = RowCode and   @prev_AccountID = v.AccountId   )
                                                            THEN @rank + 1
                                                            ELSE 1  END ) AS MaxMatchRank,

                    						@prev_RowCode := RowCode	 as prev_RowCode,
                                                  @prev_AccountID := v.AccountId as prev_AccountID
                    					 FROM tmp_VendorRate_stage_1 v
                                             , (SELECT  @prev_RowCode := '',  @rank := 0 , @prev_Code := '' , @prev_AccountID := Null) f
                                             order by AccountID,RowCode desc ;


                                       truncate tmp_VendorRate_;
                                       insert into tmp_VendorRate_
                                       select
									 AccountId ,
									 AccountName ,
									 Code ,
									 Rate ,
         						           ConnectionFee,
									 EffectiveDate ,
									 Description ,
									 Preference,
									 RowCode
							   from tmp_VendorRate_stage_
                                           where MaxMatchRank = 1 order by RowCode desc;
									*/
 -- --------------------------------------------------------

								-- Old Way
								insert into tmp_VendorRate_
                                       select
									 AccountId ,
									 AccountName ,
									 Code ,
									 Rate ,
         						     ConnectionFee,
									 EffectiveDate ,
									 Description ,
									 Preference,
									 Code as RowCode
							   from tmp_VendorCurrentRates_;



			-- -----------------------------LCR Logic
		-- select * from tmp_final_VendorRate_;
		-- Truncate tmp_VendorRate_;
	  WHILE v_pointer_ <= v_rowCount_
	    DO

             SET v_rateRuleId_ = (SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = v_pointer_);
           --  SET @IncludeAccountIds = (SELECT GROUP_CONCAT(AccountId) from tblRateRuleSource where RateRuleId = v_rateRuleId_ ) ;

		INSERT INTO tmp_Rates2_ (code,rate,ConnectionFee)
		select  code,rate,ConnectionFee from tmp_Rates_;



		truncate tmp_final_VendorRate_;

		IF( v_Use_Preference_ = 0 )
     	THEN

			insert into tmp_final_VendorRate_
			SELECT
			     AccountId ,
			     AccountName ,
			     Code ,
			     Rate ,
                    ConnectionFee,
			     EffectiveDate ,
			     Description ,
			     Preference,
			     RowCode,
	  		     FinalRankNumber
				from
				(
					SELECT
					  vr.AccountId ,
				     vr.AccountName ,
				     vr.Code ,
				     vr.Rate ,
                 vr.ConnectionFee,
				     vr.EffectiveDate ,
				     vr.Description ,
				     vr.Preference,
				     vr.RowCode,
   			         @rank := CASE WHEN ( @prev_RowCode = vr.RowCode  AND @prev_Rate <=  vr.Rate ) THEN @rank+1
                                      -- WHEN ( @prev_RowCode  = vr.RowCode  AND @prev_Rate = vr.Rate) THEN @rank
						   ELSE
						   1
						   END
				  		  AS FinalRankNumber,
				  	@prev_RowCode  := vr.RowCode,
					@prev_Rate  := vr.Rate
					from (
								select tmpvr.*
							  from tmp_VendorRate_  tmpvr
							  inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = v_rateRuleId_ and tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%'))
			     			  inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountId = tmpvr.AccountId
					) vr
					,(SELECT @rank := 0 , @prev_RowCode := '' , @prev_Rate := 0  ) x
				 	order by vr.RowCode,vr.Rate,vr.AccountId ASC

				) tbl1
				where FinalRankNumber <= v_RatePosition_;

		 ELSE

		 	 insert into tmp_final_VendorRate_
			SELECT
				AccountId ,
			     AccountName ,
			     Code ,
			     Rate ,
                    ConnectionFee,
			     EffectiveDate ,
			     Description ,
			     Preference,
			     RowCode,
	  		     FinalRankNumber
				from
				(
					SELECT
     				 	vr.AccountId ,
				     vr.AccountName ,
				     vr.Code ,
				     vr.Rate ,
                 vr.ConnectionFee,
				     vr.EffectiveDate ,
				     vr.Description ,
				     vr.Preference,
				     vr.RowCode,
                              @preference_rank := CASE WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference > vr.Preference /*AND @prev_Rate2 <  Rate*/)   THEN @preference_rank + 1
                                                       WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate) THEN @preference_rank + 1
                                                      --  WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference = vr.Preference AND @prev_Rate = vr.Rate) THEN @preference_rank
                                                       ELSE 1 END AS FinalRankNumber,
                              @prev_Code := vr.RowCode,
                              @prev_Preference := vr.Preference,
                              @prev_Rate := vr.Rate
					from (
						select tmpvr.*
					  from tmp_VendorRate_  tmpvr
					  inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = v_rateRuleId_ and tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%'))
	     			  inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountId = tmpvr.AccountId
						) vr

                          ,(SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
     			 	 order by vr.RowCode ASC ,vr.Preference DESC ,vr.Rate ASC ,vr.AccountId ASC

				) tbl1
				where FinalRankNumber <= v_RatePosition_;

		 END IF;



		truncate   tmp_VRatesstage2_;
		-- Select only code which needs to add margin for currenct  RateRule Only.
	               INSERT INTO tmp_VRatesstage2_
     			SELECT
     				vr.RowCode,
     				vr.code,
     				vr.rate,
     				vr.ConnectionFee,
                         vr.FinalRankNumber
     			FROM tmp_final_VendorRate_ vr
     			 left join tmp_Rates2_ rate on rate.Code = vr.RowCode
     			WHERE  rate.code is null
                   order by vr.FinalRankNumber desc ;



	        IF v_Average_ = 0
	        THEN
                                   insert into tmp_dupVRatesstage2_
                                   SELECT RowCode , MAX(FinalRankNumber) AS MaxFinalRankNumber
                                           FROM tmp_VRatesstage2_ GROUP BY RowCode;

                              truncate tmp_Vendorrates_stage3_;
                              INSERT INTO tmp_Vendorrates_stage3_
                              select  vr.RowCode as RowCode , vr.rate as rate , vr.ConnectionFee as  ConnectionFee
                              from tmp_VRatesstage2_ vr
                              INNER JOIN tmp_dupVRatesstage2_ vr2
                                ON (vr.RowCode = vr2.RowCode AND  vr.FinalRankNumber = vr2.FinalRankNumber);

                    INSERT IGNORE INTO tmp_Rates_
                   SELECT
	                    RowCode,
	                    IFNULL((SELECT
	                            CASE WHEN vRate.rate  BETWEEN minrate AND maxrate THEN vRate.rate
	                                + (CASE WHEN addmargin LIKE '%p' THEN ((CAST(REPLACE(addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate) ELSE addmargin
	                                END) ELSE vRate.rate
	                            END
	                        FROM tblRateRuleMargin
	                        WHERE rateruleid = v_rateRuleId_
									and vRate.rate  BETWEEN minrate AND maxrate LIMIT 1
							),vRate.Rate) as Rate,
	                	ConnectionFee
	                	FROM tmp_Vendorrates_stage3_ vRate;



	         ELSE -- AVERAGE

	           INSERT IGNORE INTO tmp_Rates_
					SELECT
	                    RowCode,
	                    IFNULL((SELECT
	                            CASE WHEN vRate.rate  BETWEEN minrate AND maxrate THEN vRate.rate
	                                + (CASE WHEN addmargin LIKE '%p' THEN ((CAST(REPLACE(addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate) ELSE addmargin
	                                END) ELSE vRate.rate
	                            END
	                        FROM tblRateRuleMargin
	                        WHERE rateruleid = v_rateRuleId_
									and vRate.rate  BETWEEN minrate AND maxrate LIMIT 1
							),vRate.Rate) as Rate,
	                	ConnectionFee
	                FROM (
								select RowCode,
				                    AVG(Rate) as Rate,
				                    AVG(ConnectionFee) as ConnectionFee
								 	from tmp_VRatesstage2_
							 		group by RowCode
				     )  vRate;




	        END IF;


	         SET v_pointer_ = v_pointer_ + 1;


	     END WHILE;


        START TRANSACTION;

	    IF p_RateTableId = -1
	    THEN

	        INSERT INTO tblRateTable (CompanyId, RateTableName, RateGeneratorID, TrunkID, CodeDeckId,CurrencyID)
	            VALUES (v_CompanyId_, p_rateTableName, p_RateGeneratorId, v_trunk_, v_codedeckid_,v_CurrencyID_);

	        SET p_RateTableId = LAST_INSERT_ID();

	        INSERT INTO tblRateTableRate (RateID,
	        RateTableId,
	        Rate,
	        EffectiveDate,
	        PreviousRate,
	        Interval1,
	        IntervalN,
	        ConnectionFee
	        )
	            SELECT DISTINCT
	                RateId,
	                p_RateTableId,
	                 Rate,
	                p_EffectiveDate,
	                Rate,
	                Interval1,
	                IntervalN,
	                ConnectionFee
	            FROM tmp_Rates_ rate
	            INNER JOIN tblRate
	                ON rate.code  = tblRate.Code
	            WHERE tblRate.CodeDeckId = v_codedeckid_;

	    ELSE

			 IF p_delete_exiting_rate = 1
	         THEN
			 	 DELETE tblRateTableRate
		            FROM tblRateTableRate
		        WHERE tblRateTableRate.RateTableId = p_RateTableId;
		     END IF;

	        INSERT INTO tblRateTableRate (RateID,
	        RateTableId,
	        Rate,
	        EffectiveDate,
	        PreviousRate,
	        Interval1,
	        IntervalN,
	        ConnectionFee
	        )
	            SELECT DISTINCT
	                tblRate.RateId,
	                p_RateTableId RateTableId,
	                rate.Rate,
	                p_EffectiveDate EffectiveDate,
	                rate.Rate,
	                tblRate.Interval1,
	                tblRate.IntervalN,
	                rate.ConnectionFee
	            FROM tmp_Rates_ rate
	            INNER JOIN tblRate
	                ON rate.code  = tblRate.Code
	            LEFT JOIN tblRateTableRate tbl1
	                ON tblRate.RateId = tbl1.RateId
	                AND tbl1.RateTableId = p_RateTableId
	            LEFT JOIN tblRateTableRate tbl2
	            ON tblRate.RateId = tbl2.RateId
	            and tbl2.EffectiveDate = p_EffectiveDate
	            AND tbl2.RateTableId = p_RateTableId
	            WHERE  (    tbl1.RateTableRateID IS NULL
	                    OR
	                    (
	                        tbl2.RateTableRateID IS NULL
	                        AND  tbl1.EffectiveDate != p_EffectiveDate

	                    )
	                 )
	            AND tblRate.CodeDeckId = v_codedeckid_;

	        UPDATE tblRateTableRate
	        INNER JOIN tblRate
	            ON tblRate.RateId = tblRateTableRate.RateId
	            AND tblRateTableRate.RateTableId = p_RateTableId
	            AND tblRateTableRate.EffectiveDate = p_EffectiveDate
	         INNER JOIN tmp_Rates_ as rate
	          ON  rate.code  = tblRate.Code
	          SET tblRateTableRate.PreviousRate = tblRateTableRate.Rate,
	            tblRateTableRate.EffectiveDate = p_EffectiveDate,
	            tblRateTableRate.Rate = rate.Rate,
	            tblRateTableRate.ConnectionFee = rate.ConnectionFee,
	            tblRateTableRate.updated_at = NOW(),
	            tblRateTableRate.ModifiedBy = 'RateManagementService',
	            tblRateTableRate.Interval1 = tblRate.Interval1,
	            tblRateTableRate.IntervalN = tblRate.IntervalN
	        WHERE tblRate.CodeDeckId = v_codedeckid_
	        AND rate.rate != tblRateTableRate.Rate;

	        DELETE tblRateTableRate
	            FROM tblRateTableRate
	        WHERE tblRateTableRate.RateTableId = p_RateTableId
	            AND RateId NOT IN (SELECT DISTINCT
	                    RateId
	                FROM tmp_Rates_ rate
	                INNER JOIN tblRate
	                    ON rate.code  = tblRate.Code
	                WHERE tblRate.CodeDeckId = v_codedeckid_)
	            AND tblRateTableRate.EffectiveDate = p_EffectiveDate;


	    END IF;


		UPDATE tblRateTable
	   SET RateGeneratorID = p_RateGeneratorId,
		  TrunkID = v_trunk_,
		  CodeDeckId = v_codedeckid_,
		  updated_at = now()
		WHERE RateTableID = p_RateTableId;

      SELECT p_RateTableId as RateTableID;

    	CALL prc_WSJobStatusUpdate(p_jobId, 'S', 'RateTable Created Successfully', '');

    COMMIT;


    	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;



END|
DELIMITER ;

-- Dev

USE `Ratemanagement3`;
DROP PROCEDURE IF EXISTS `prc_GetLCRwithPrefix`;
DELIMITER ;;
CREATE  PROCEDURE `prc_GetLCRwithPrefix`(IN `p_companyid` INT, IN `p_trunkID` INT, IN `p_codedeckID` INT, IN `p_CurrencyID` INT, IN `p_code` VARCHAR(50), IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_SortOrder` VARCHAR(50), IN `p_Preference` INT, IN `p_isExport` INT)
BEGIN

DECLARE v_OffSet_ int;
DECLARE v_Code VARCHAR(50) ;
DECLARE v_pointer_ int;
DECLARE v_rowCount_ int;
DECLARE v_p_code VARCHAR(50);
DECLARE v_Codlen_ int;
DECLARE v_position int;
DECLARE v_p_code__ VARCHAR(50);
DECLARE v_has_null_position int ;
DECLARE v_next_position1 VARCHAR(200) ;
DECLARE v_CompanyCurrencyID_ INT;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

     SET @@session.collation_connection='utf8_unicode_ci';
     SET @@session.character_set_results='utf8';

    SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

 -- (IN `p_companyid` INT, IN `p_codedeckID` INT, IN `p_trunkID` INT, IN `p_code` VARCHAR(50), IN `p_Preference` INT, IN `p_ranknumber` INT)

  -- just for taking codes -

DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_;
       CREATE TEMPORARY TABLE tmp_VendorRate_stage_ (
          RowCode VARCHAR(50) ,
          AccountId INT ,
          AccountName VARCHAR(100) ,
          Code VARCHAR(50) ,
          Rate DECIMAL(18,6) ,
          ConnectionFee DECIMAL(18,6) ,
          EffectiveDate DATETIME ,
          Description VARCHAR(255),
          Preference INT,
          MaxMatchRank int ,
          prev_prev_RowCode VARCHAR(50),
          prev_AccountID int
        )
  ;

     DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage2_;
       CREATE TEMPORARY TABLE tmp_VendorRate_stage2_ (
          RowCode VARCHAR(50) ,
          AccountId INT ,
          AccountName VARCHAR(100) ,
          Code VARCHAR(50) ,
          Rate DECIMAL(18,6) ,
          ConnectionFee DECIMAL(18,6) ,
          EffectiveDate DATETIME ,
          Description VARCHAR(255),
          Preference INT,
          MaxMatchRank int ,
          prev_prev_RowCode VARCHAR(50),
          prev_AccountID int
        )
  ;

  DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
  CREATE TEMPORARY TABLE tmp_VendorRate_ (
     AccountId INT ,
     AccountName VARCHAR(100) ,
     Code VARCHAR(50) ,
     Rate DECIMAL(18,6) ,
     ConnectionFee DECIMAL(18,6) ,
     EffectiveDate DATETIME ,
     Description VARCHAR(255),
     Preference INT,
     RowCode VARCHAR(50)
   )
   ;

   DROP TEMPORARY TABLE IF EXISTS tmp_final_VendorRate_;
  CREATE TEMPORARY TABLE tmp_final_VendorRate_ (
     AccountId INT ,
     AccountName VARCHAR(100) ,
     Code VARCHAR(50) ,
     Rate DECIMAL(18,6) ,
     ConnectionFee DECIMAL(18,6) ,
     EffectiveDate DATETIME ,
     Description VARCHAR(255),
     Preference INT,
     RowCode VARCHAR(50),
     FinalRankNumber int
   )
  ;

-- Loop codes
DROP TEMPORARY TABLE IF EXISTS tmp_search_code_;
  CREATE TEMPORARY TABLE tmp_search_code_ (
     Code  varchar(50),
     INDEX Index1 (Code)
);

-- searched codes.
DROP TEMPORARY TABLE IF EXISTS tmp_code_;
  CREATE TEMPORARY TABLE tmp_code_ (
     RowCode  varchar(50),
     Code  varchar(50),
     RowNo int,
     INDEX Index1 (Code)
   );


DROP TEMPORARY TABLE IF EXISTS tmp_all_code_;
  CREATE TEMPORARY TABLE tmp_all_code_ (
     RowCode  varchar(50),
     Code  varchar(50),
     -- RowNo int, not used
     INDEX Index2 (Code)
   )
   ;


DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_;
CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_(
			AccountId int,
         AccountName varchar(200),
			Code varchar(50),
			Description varchar(200),
			Rate DECIMAL(18,6) ,
         ConnectionFee DECIMAL(18,6) ,
			EffectiveDate date,
			TrunkID int,
			CountryID int,
			RateID int,
			Preference int,
			INDEX IX_Code (Code)
	)
  ;

     DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates1_;
CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates1_(
			AccountId int,
         AccountName varchar(200),
			Code varchar(50),
			Description varchar(200),
			Rate DECIMAL(18,6) ,
               ConnectionFee DECIMAL(18,6) ,
			EffectiveDate date,
			TrunkID int,
			CountryID int,
			RateID int,
			Preference int,
			INDEX IX_Code (Code),
			INDEX tmp_VendorCurrentRates_AccountId (`AccountId`,`TrunkID`,`RateId`,`EffectiveDate`)
	)
  ;

 DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateByRank_;
  CREATE TEMPORARY TABLE tmp_VendorRateByRank_ (
     AccountId INT ,
     AccountName VARCHAR(100) ,
     Code VARCHAR(50) ,
     Rate DECIMAL(18,6) ,
     ConnectionFee DECIMAL(18,6) ,
     EffectiveDate DATETIME ,
     Description VARCHAR(255),
     Preference INT,
     rankname INT,
     INDEX IX_Code (Code,rankname)
   )
   ;

	SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = p_companyid;



         /*
			New Way
		 -- Search code based on p_code

          insert into tmp_search_code_
          SELECT  DISTINCT LEFT(f.Code, x.RowNo) as loopCode FROM (
          SELECT @RowNo  := @RowNo + 1 as RowNo
          FROM mysql.help_category
          ,(SELECT @RowNo := 0 ) x
          limit 15
          ) x
          INNER JOIN tblRate AS f
          ON f.CompanyID = p_companyid  AND f.CodeDeckId = p_codedeckID
          AND ( CHAR_LENGTH(RTRIM(p_code)) = 0  OR f.Code LIKE REPLACE(p_code,'*', '%') )
          AND x.RowNo   <= LENGTH(f.Code)
          order by loopCode   desc;
		*/


     -- distinct vendor rates
      INSERT INTO tmp_VendorCurrentRates1_
	  Select DISTINCT AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference /*,RowCode */
      FROM (
				SELECT distinct tblVendorRate.AccountId,tblAccount.AccountName, tblRate.Code, tblRate.Description,
				 CASE WHEN  tblAccount.CurrencyId = p_CurrencyID
								THEN
									   tblVendorRate.Rate
					 WHEN  v_CompanyCurrencyID_ = p_CurrencyID
							 THEN
								  (
								   ( tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ) )
								 )
							  ELSE
							  (
										-- Convert to base currrncy and x by RateGenerator Exhange
								  (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = p_CurrencyID and  CompanyID = p_companyid )
									* (tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ))
							  )
							 END
								as  Rate,
								 ConnectionFee,
			  DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate,
			    tblVendorRate.TrunkID, tblRate.CountryID, tblRate.RateID,IFNULL(vp.Preference, 5) AS Preference -- ,SplitCode.RowCode,
			  FROM      tblVendorRate
					 Inner join tblVendorTrunk vt on vt.CompanyID = p_companyid AND vt.AccountID = tblVendorRate.AccountID and vt.Status =  1 and vt.TrunkID =  p_trunkID
							 -- AND ( p_codedeckID = 0 OR ( p_codedeckID > 0 AND vt.CodeDeckId = p_codedeckID ) )
						INNER JOIN tblAccount   ON  tblAccount.CompanyID = p_companyid AND tblVendorRate.AccountId = tblAccount.AccountID
						INNER JOIN tblRate ON tblRate.CompanyID = p_companyid  /* AND tblRate.CodeDeckId = vt.CodeDeckId */  AND    tblVendorRate.RateId = tblRate.RateID


						-- New Way  INNER JOIN tmp_search_code_  SplitCode   on tblRate.Code = SplitCode.Code
						LEFT JOIN tblVendorPreference vp
										 ON vp.AccountId = tblVendorRate.AccountId
										 AND vp.TrunkID = tblVendorRate.TrunkID
										 AND vp.RateId = tblVendorRate.RateId
						LEFT OUTER JOIN tblVendorBlocking AS blockCode   ON tblVendorRate.RateId = blockCode.RateId
																	  AND tblVendorRate.AccountId = blockCode.AccountId
																	  AND tblVendorRate.TrunkID = blockCode.TrunkID
						LEFT OUTER JOIN tblVendorBlocking AS blockCountry    ON tblRate.CountryID = blockCountry.CountryId
																	  AND tblVendorRate.AccountId = blockCountry.AccountId
																	  AND tblVendorRate.TrunkID = blockCountry.TrunkID
			  WHERE

						( CHAR_LENGTH(RTRIM(p_code)) = 0 OR tblRate.Code LIKE REPLACE(p_code,'*', '%') )  -- OLD WAy
						AND EffectiveDate <= NOW()
						AND tblAccount.IsVendor = 1
						AND tblAccount.Status = 1
						AND tblAccount.CurrencyId is not NULL
						AND tblVendorRate.TrunkID = p_trunkID
						AND blockCode.RateId IS NULL
					   AND blockCountry.CountryId IS NULL
			--	ORDER BY tblVendorRate.AccountId, tblVendorRate.TrunkID, tblVendorRate.RateId, tblVendorRate.EffectiveDate DESC
		) tbl
		order by Code asc;


     -- filter by Effective Dates
     INSERT INTO tmp_VendorCurrentRates_
	  Select AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
      FROM (
			  SELECT * ,
				@row_num := IF(@prev_AccountId = AccountID AND @prev_TrunkID = TrunkID AND @prev_RateId = RateID AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
				@prev_AccountId := AccountID,
				@prev_TrunkID := TrunkID,
				@prev_RateId := RateID,
				@prev_EffectiveDate := EffectiveDate
			  FROM tmp_VendorCurrentRates1_
			  ,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '', @prev_RateId := '', @prev_EffectiveDate := '') x
           ORDER BY AccountId, TrunkID, RateId, EffectiveDate DESC
		) tbl
		 WHERE RowID = 1
		order by Code asc;

         -- Collect Codes pressent in vendor Rates from above query.
          /*
                    9372     9372    1
                    9372     937     2
                    9372     93      3
                    9372     9       4

            */


		/*
		New Way
		insert into tmp_all_code_ (RowCode,Code,RowNo)
               select RowCode , loopCode,RowNo
               from (
                    select   RowCode , loopCode,
                    @RowNo := ( CASE WHEN ( @prev_Code = tbl1.RowCode  ) THEN @RowNo + 1
                                   ELSE 1
                                   END

                              )      as RowNo,
                    @prev_Code := tbl1.RowCode

                    from (
                              SELECT distinct f.Code as RowCode, LEFT(f.Code, x.RowNo) as loopCode FROM (
                                SELECT @RowNo  := @RowNo + 1 as RowNo
                                FROM mysql.help_category
                                ,(SELECT @RowNo := 0 ) x
                                limit 15
                              ) x
                              INNER JOIN tmp_search_code_ AS f
                              ON  x.RowNo   <= LENGTH(f.Code)  AND ( CHAR_LENGTH(RTRIM(p_code)) = 0  OR Code LIKE REPLACE(p_code,'*', '%') )
                              order by RowCode desc,  LENGTH(loopCode) DESC
                    ) tbl1
                    , ( Select @RowNo := 0 ) x
                ) tbl order by RowCode desc,  LENGTH(loopCode) DESC ;
         */

    -- select * from tmp_all_code_;

       /*  IF (p_isExport = 0)
        THEN

					New Way
					insert into tmp_code_
                         select * from tmp_all_code_
                         order by RowCode	LIMIT p_RowspPage OFFSET v_OffSet_ ;



		ELSE

					insert into tmp_code_
                              select * from tmp_all_code_
                              order by RowCode	  ;


		END IF; */


IF p_Preference = 1 THEN

	-- Sort by Preference
	INSERT IGNORE INTO tmp_VendorRateByRank_
	  SELECT
		AccountID,
		AccountName,
		Code,
		Rate,
		ConnectionFee,
		EffectiveDate,
		Description,
		Preference,
		preference_rank
	  FROM (SELECT
		  AccountID,
		  AccountName,
		  Code,
		  Rate,
		  ConnectionFee,
		  EffectiveDate,
		  Description,
		  Preference,
		  @preference_rank := CASE WHEN (@prev_Code     = Code AND @prev_Preference > Preference  ) THEN @preference_rank + 1
								   WHEN (@prev_Code     = Code AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
								   WHEN (@prev_Code    = Code AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
								   ELSE 1
								   END AS preference_rank,
		  @prev_Code := Code,
		  @prev_Preference := IFNULL(Preference, 5),
		  @prev_Rate := Rate
		FROM tmp_VendorCurrentRates_ AS preference,
			 (SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
		ORDER BY preference.Code ASC, preference.Preference DESC, preference.Rate ASC,preference.AccountId ASC

		 ) tbl
	  WHERE preference_rank <= 5
	  ORDER BY Code, preference_rank;

	ELSE


	-- Sort by Rate
	INSERT IGNORE INTO tmp_VendorRateByRank_
	  SELECT
		AccountID,
		AccountName,
		Code,
		Rate,
		ConnectionFee,
		EffectiveDate,
		Description,
		Preference,
		RateRank
	  FROM (SELECT
		  AccountID,
		  AccountName,
		  Code,
		  Rate,
		  ConnectionFee,
		  EffectiveDate,
		  Description,
		  Preference,
		  @rank := CASE WHEN (@prev_Code    = Code AND @prev_Rate < Rate) THEN @rank + 1
						WHEN (@prev_Code    = Code AND @prev_Rate = Rate) THEN @rank
						ELSE 1
						END AS RateRank,
		  @prev_Code := Code,
		  @prev_Rate := Rate
		FROM tmp_VendorCurrentRates_ AS rank,
			 (SELECT @rank := 0 , @prev_Code := '' , @prev_Rate := 0) f
		ORDER BY rank.Code ASC, rank.Rate,rank.AccountId ASC) tbl
	  WHERE RateRank <= 5
	  ORDER BY Code, RateRank;

	END IF;

-- --------- Split Logic ----------
/* DESC             MaxMatchRank 1  MaxMatchRank 2
923 Pakistan :       *923 V1          92 V1
923 Pakistan :       *92 V2            -

now take only where  MaxMatchRank =  1
*/

 /*
 New Way

DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1;
 CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate_stage_1 as (select * from tmp_VendorRate_stage_);

 insert ignore into tmp_VendorRate_stage_1 (
   	     RowCode,
     	AccountId ,
     	AccountName ,
     	Code ,
     	Rate ,
     	ConnectionFee,
     	EffectiveDate ,
     	Description ,
     	Preference
)
          SELECT
          distinct
     	RowCode,
     	v.AccountId ,
     	v.AccountName ,
     	v.Code ,
     	v.Rate ,
     	v.ConnectionFee,
     	v.EffectiveDate ,
     	v.Description ,
     	v.Preference
          FROM tmp_VendorRateByRank_ v
          left join  tmp_all_code_
			SplitCode   on v.Code = SplitCode.Code
         where  SplitCode.Code is not null and rankname <= 5
         order by AccountID,SplitCode.RowCode desc ,LENGTH(SplitCode.RowCode), v.Code desc, LENGTH(v.Code)  desc;


     insert ignore into tmp_VendorRate_stage_
          SELECT
          distinct
     	RowCode,
     	v.AccountId ,
     	v.AccountName ,
     	v.Code ,
     	v.Rate ,
     	v.ConnectionFee,
     	v.EffectiveDate ,
     	v.Description ,
     	v.Preference,
     	@rank := ( CASE WHEN( @prev_AccountID = v.AccountId  and @prev_RowCode     = RowCode    )
                                   THEN  @rank + 1
                                   ELSE 1
                              END
          ) AS MaxMatchRank,
	     @prev_RowCode := RowCode	 ,
          @prev_AccountID := v.AccountId
          from tmp_VendorRateByRank_
		  -- FROM tmp_VendorRate_stage_1 v
          , (SELECT  @prev_RowCode := '',  @rank := 0 , @prev_Code := '' , @prev_AccountID := Null) f
          order by AccountID,RowCode desc ;


    -- select * from tmp_VendorRate_stage_;

              insert ignore into tmp_VendorRate_
              select
                    distinct
				 AccountId ,
				 AccountName ,
				 Code ,
				 Rate ,
                    ConnectionFee,
				 EffectiveDate ,
				 Description ,
				 Preference,
				 RowCode
		   from tmp_VendorRate_stage_
 			  order by RowCode desc;
*/

			-- Old Way
              insert ignore into tmp_VendorRate_
              select
                    distinct
				 AccountId ,
				 AccountName ,
				 Code ,
				 Rate ,
                 ConnectionFee,
				 EffectiveDate ,
				 Description ,
				 Preference,
				 Code as RowCode
		   from tmp_VendorRateByRank_
 			  order by RowCode desc;



-- select * from tmp_VendorRate_;


		IF( p_Preference = 0 )
     	THEN

			insert into tmp_final_VendorRate_
			SELECT
			     AccountId ,
			     AccountName ,
			     Code ,
			     Rate ,
                    ConnectionFee,
			     EffectiveDate ,
			     Description ,
			     Preference,
			     RowCode,
	  		     FinalRankNumber
				from
				(
					SELECT
					AccountId ,
				     AccountName ,
				     Code ,
				     Rate ,
                         ConnectionFee,
				     EffectiveDate ,
				     Description ,
				     Preference,
				     RowCode,
   			         @rank := CASE WHEN ( @prev_RowCode     = RowCode AND @prev_Rate <  Rate ) THEN @rank+1
                                   WHEN ( @prev_RowCode    = RowCode AND @prev_Rate = Rate ) THEN @rank
						   ELSE
						   1
						   END
				  		  AS FinalRankNumber,
				  	@prev_RowCode  := RowCode,
					@prev_Rate  := Rate
					from tmp_VendorRate_
					,( SELECT @rank := 0 , @prev_RowCode := '' , @prev_Rate := 0 ) x
				 	order by RowCode,Rate,AccountId ASC

				) tbl1
				where
				FinalRankNumber <= 5;

		 ELSE

		 	 insert into tmp_final_VendorRate_
			SELECT
				AccountId ,
			     AccountName ,
			     Code ,
			     Rate ,
                    ConnectionFee,
			     EffectiveDate ,
			     Description ,
			     Preference,
			     RowCode,
	  		     FinalRankNumber
				from
				(
					SELECT
     					AccountId ,
     				     AccountName ,
     				     Code ,
     				     Rate ,
                             ConnectionFee,
     				     EffectiveDate ,
     				     Description ,
     				     Preference,
     				     RowCode,
                              @preference_rank := CASE WHEN (@prev_Code     = RowCode AND @prev_Preference > Preference /*AND @prev_Rate2 <  Rate*/)   THEN @preference_rank + 1
                                                       WHEN (@prev_Code     = RowCode AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
                                                       WHEN (@prev_Code    = RowCode AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
                                                       ELSE 1 END AS FinalRankNumber,
                              @prev_Code := RowCode,
                              @prev_Preference := Preference,
                              @prev_Rate := Rate
					from tmp_VendorRate_
                          ,(SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
     			 	 order by RowCode ASC ,Preference DESC ,Rate ASC ,AccountId ASC

				) tbl1
				where
				FinalRankNumber <= 5;

		 END IF;

          -- ------------------------------------------------------------------

          -- select * from tmp_final_VendorRate_;



    IF (p_isExport = 0)
    THEN


					SELECT
			           CONCAT(ANY_VALUE(t.RowCode) , ' : ' , ANY_VALUE(t.Description)) as Destination,
			          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 1, CONCAT(   ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 1`,
			          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 2, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName), '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 2`,
			          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 3, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 3`,
			          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 4, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 4`,
			          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 5, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 5`
			        FROM tmp_final_VendorRate_  t
			          GROUP BY  RowCode
			          ORDER BY RowCode ASC
			     	LIMIT p_RowspPage OFFSET v_OffSet_ ;

               -- select count(distinct RowCode) as totalcount from tmp_all_code_ ; -- where    ( CHAR_LENGTH(RTRIM(p_code)) = 0  OR RowCode LIKE REPLACE(p_code,'*', '%') )    ;

                select count(distinct RowCode) as totalcount from tmp_final_VendorRate_ where    ( CHAR_LENGTH(RTRIM(p_code)) = 0  OR RowCode LIKE REPLACE(p_code,'*', '%') )    ;

   ELSE
		     SELECT
           CONCAT(ANY_VALUE(t.RowCode) , ' : ' , ANY_VALUE(t.Description)) as Destination,
          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 1, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 1`,
          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 2, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName), '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 2`,
          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 3, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 3`,
          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 4, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 4`,
          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 5, CONCAT(  ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 5`
        FROM tmp_final_VendorRate_  t
          GROUP BY  RowCode
          ORDER BY RowCode ASC;



   END IF;


SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;



END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_GetLCR`;
DELIMITER ;;
CREATE PROCEDURE prc_GetLCR(
	IN `p_companyid` INT,
	IN `p_trunkID` INT,
	IN `p_codedeckID` INT,
	IN `p_CurrencyID` INT,
	IN `p_code` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_SortOrder` VARCHAR(50),
	IN `p_Preference` INT,
	IN `p_isExport` INT

)
BEGIN

    -- DECLARE p_contryID int default 0;
    DECLARE v_OffSet_ int;

    DECLARE v_Code VARCHAR(50) ;
DECLARE v_pointer_ int;
DECLARE v_rowCount_ int;
DECLARE v_p_code VARCHAR(50);
DECLARE v_Codlen_ int;
DECLARE v_position int;
DECLARE v_p_code__ VARCHAR(50);
DECLARE v_has_null_position int ;
DECLARE v_next_position1 VARCHAR(200) ;
	DECLARE v_CompanyCurrencyID_ INT;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

     SET @@session.collation_connection='utf8_unicode_ci';
     SET @@session.character_set_results='utf8';

    SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

 -- (IN `p_companyid` INT, IN `p_codedeckID` INT, IN `p_trunkID` INT, IN `p_code` VARCHAR(50), IN `p_Preference` INT, IN `p_ranknumber` INT)

  -- just for taking codes -

DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_;
       CREATE TEMPORARY TABLE tmp_VendorRate_stage_ (
          RowCode VARCHAR(50) ,
          AccountId INT ,
          AccountName VARCHAR(100) ,
          Code VARCHAR(50) ,
          Rate DECIMAL(18,6) ,
          ConnectionFee DECIMAL(18,6) ,
          EffectiveDate DATETIME ,
          Description VARCHAR(255),
          Preference INT,
          MaxMatchRank int ,
          prev_prev_RowCode VARCHAR(50),
          prev_AccountID int
        )
  ;

     DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage2_;
       CREATE TEMPORARY TABLE tmp_VendorRate_stage2_ (
          RowCode VARCHAR(50) ,
          AccountId INT ,
          AccountName VARCHAR(100) ,
          Code VARCHAR(50) ,
          Rate DECIMAL(18,6) ,
          ConnectionFee DECIMAL(18,6) ,
          EffectiveDate DATETIME ,
          Description VARCHAR(255),
          Preference INT,
          MaxMatchRank int ,
          prev_prev_RowCode VARCHAR(50),
          prev_AccountID int
        )
  ;

  DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
  CREATE TEMPORARY TABLE tmp_VendorRate_ (
     AccountId INT ,
     AccountName VARCHAR(100) ,
     Code VARCHAR(50) ,
     Rate DECIMAL(18,6) ,
     ConnectionFee DECIMAL(18,6) ,
     EffectiveDate DATETIME ,
     Description VARCHAR(255),
     Preference INT,
     RowCode VARCHAR(50)
   )
   ;

   DROP TEMPORARY TABLE IF EXISTS tmp_final_VendorRate_;
  CREATE TEMPORARY TABLE tmp_final_VendorRate_ (
     AccountId INT ,
     AccountName VARCHAR(100) ,
     Code VARCHAR(50) ,
     Rate DECIMAL(18,6) ,
     ConnectionFee DECIMAL(18,6) ,
     EffectiveDate DATETIME ,
     Description VARCHAR(255),
     Preference INT,
     RowCode VARCHAR(50),
     FinalRankNumber int
   )
  ;

-- Loop codes
DROP TEMPORARY TABLE IF EXISTS tmp_search_code_;
  CREATE TEMPORARY TABLE tmp_search_code_ (
     Code  varchar(50),
     INDEX Index1 (Code)
);

-- searched codes.
DROP TEMPORARY TABLE IF EXISTS tmp_code_;
  CREATE TEMPORARY TABLE tmp_code_ (
     RowCode  varchar(50),
     Code  varchar(50),
     RowNo int,
     INDEX Index1 (Code)
   );


DROP TEMPORARY TABLE IF EXISTS tmp_all_code_;
  CREATE TEMPORARY TABLE tmp_all_code_ (
     RowCode  varchar(50),
     Code  varchar(50),
     RowNo int,
     INDEX Index2 (Code)
   )
   ;


DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_;
CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_(
			AccountId int,
         AccountName varchar(200),
			Code varchar(50),
			Description varchar(200),
			Rate DECIMAL(18,6) ,
         ConnectionFee DECIMAL(18,6) ,
			EffectiveDate date,
			TrunkID int,
			CountryID int,
			RateID int,
			Preference int,
			INDEX IX_Code (Code)
	)
  ;

     DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates1_;
CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates1_(
			AccountId int,
         AccountName varchar(200),
			Code varchar(50),
			Description varchar(200),
			Rate DECIMAL(18,6) ,
               ConnectionFee DECIMAL(18,6) ,
			EffectiveDate date,
			TrunkID int,
			CountryID int,
			RateID int,
			Preference int,
			INDEX IX_Code (Code),
			INDEX tmp_VendorCurrentRates_AccountId (`AccountId`,`TrunkID`,`RateId`,`EffectiveDate`)
	)
  ;

 DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateByRank_;
  CREATE TEMPORARY TABLE tmp_VendorRateByRank_ (
     AccountId INT ,
     AccountName VARCHAR(100) ,
     Code VARCHAR(50) ,
     Rate DECIMAL(18,6) ,
     ConnectionFee DECIMAL(18,6) ,
     EffectiveDate DATETIME ,
     Description VARCHAR(255),
     Preference INT,
     rankname INT,
     INDEX IX_Code (Code,rankname)
   )
   ;

	SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = p_companyid;



          -- Search code based on p_code
          insert into tmp_search_code_
          SELECT  DISTINCT LEFT(f.Code, x.RowNo) as loopCode FROM (
          SELECT @RowNo  := @RowNo + 1 as RowNo
          FROM mysql.help_category
          ,(SELECT @RowNo := 0 ) x
          limit 15
          ) x
          INNER JOIN tblRate AS f
          ON f.CompanyID = p_companyid  AND f.CodeDeckId = p_codedeckID
          AND ( CHAR_LENGTH(RTRIM(p_code)) = 0  OR f.Code LIKE REPLACE(p_code,'*', '%') )
          AND x.RowNo   <= LENGTH(f.Code)
          order by loopCode   desc;



     -- distinct vendor rates
      INSERT INTO tmp_VendorCurrentRates1_
      Select DISTINCT AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference /*,RowCode */
      FROM (
				SELECT distinct tblVendorRate.AccountId,tblAccount.AccountName, tblRate.Code, tblRate.Description,
				 CASE WHEN  tblAccount.CurrencyId = p_CurrencyID
								THEN
									   tblVendorRate.Rate
					 WHEN  v_CompanyCurrencyID_ = p_CurrencyID
							 THEN
								  (
								   ( tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ) )
								 )
							  ELSE
							  (
										-- Convert to base currrncy and x by RateGenerator Exhange
								  (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = p_CurrencyID and  CompanyID = p_companyid )
									* (tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ))
							  )
							 END
								as  Rate,
								 ConnectionFee,
                    		DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate, tblVendorRate.TrunkID, tblRate.CountryID, tblRate.RateID,IFNULL(vp.Preference, 5) AS Preference -- ,SplitCode.RowCode,
                    		FROM      tblVendorRate
					     Inner join tblVendorTrunk vt on vt.CompanyID = p_companyid AND vt.AccountID = tblVendorRate.AccountID and vt.Status =  1 and vt.TrunkID =  p_trunkID
							-- AND ( p_codedeckID = 0 OR ( p_codedeckID > 0 AND vt.CodeDeckId = p_codedeckID ) )
						INNER JOIN tblAccount   ON  tblAccount.CompanyID = p_companyid AND tblVendorRate.AccountId = tblAccount.AccountID and tblAccount.IsVendor = 1
						INNER JOIN tblRate ON tblRate.CompanyID = p_companyid  /*AND tblRate.CodeDeckId = vt.CodeDeckId */   AND    tblVendorRate.RateId = tblRate.RateID
						INNER JOIN tmp_search_code_  SplitCode   on tblRate.Code = SplitCode.Code
						LEFT JOIN tblVendorPreference vp
										 ON vp.AccountId = tblVendorRate.AccountId
										 AND vp.TrunkID = tblVendorRate.TrunkID
										 AND vp.RateId = tblVendorRate.RateId
						LEFT OUTER JOIN tblVendorBlocking AS blockCode   ON tblVendorRate.RateId = blockCode.RateId
																	  AND tblVendorRate.AccountId = blockCode.AccountId
																	  AND tblVendorRate.TrunkID = blockCode.TrunkID
						LEFT OUTER JOIN tblVendorBlocking AS blockCountry    ON tblRate.CountryID = blockCountry.CountryId
																	  AND tblVendorRate.AccountId = blockCountry.AccountId
																	  AND tblVendorRate.TrunkID = blockCountry.TrunkID
			  WHERE
						( EffectiveDate <= NOW() )
						AND tblAccount.IsVendor = 1
						AND tblAccount.Status = 1
						AND tblAccount.CurrencyId is not NULL
						AND tblVendorRate.TrunkID = p_trunkID
						AND blockCode.RateId IS NULL
					   AND blockCountry.CountryId IS NULL
			--	ORDER BY tblVendorRate.AccountId, tblVendorRate.TrunkID, tblVendorRate.RateId, tblVendorRate.EffectiveDate DESC
		) tbl
		order by Code asc;


     -- filter by Effective Dates
     INSERT INTO tmp_VendorCurrentRates_
	  Select AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
      FROM (
			  SELECT * ,
				@row_num := IF(@prev_AccountId = AccountID AND @prev_TrunkID = TrunkID AND @prev_RateId = RateID AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
				@prev_AccountId := AccountID,
				@prev_TrunkID := TrunkID,
				@prev_RateId := RateID,
				@prev_EffectiveDate := EffectiveDate
			  FROM tmp_VendorCurrentRates1_
			  ,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '', @prev_RateId := '', @prev_EffectiveDate := '') x
           ORDER BY AccountId, TrunkID, RateId, EffectiveDate DESC
		) tbl
		 WHERE RowID = 1
		order by Code asc;

         -- Collect Codes pressent in vendor Rates from above query.
          /*
                    9372     9372    1
                    9372     937     2
                    9372     93      3
                    9372     9       4

            */
        insert into tmp_all_code_ (RowCode,Code,RowNo)
               select RowCode , loopCode,RowNo
               from (
                    select   RowCode , loopCode,
                    @RowNo := ( CASE WHEN ( @prev_Code = tbl1.RowCode  ) THEN @RowNo + 1
                                   ELSE 1
                                   END

                              )      as RowNo,
                    @prev_Code := tbl1.RowCode

                    from (
                              SELECT distinct f.Code as RowCode, LEFT(f.Code, x.RowNo) as loopCode FROM (
                                SELECT @RowNo  := @RowNo + 1 as RowNo
                                FROM mysql.help_category
                                ,(SELECT @RowNo := 0 ) x
                                limit 15
                              ) x
                              INNER JOIN tmp_search_code_ AS f
                              ON  x.RowNo   <= LENGTH(f.Code)  AND ( CHAR_LENGTH(RTRIM(p_code)) = 0  OR Code LIKE REPLACE(p_code,'*', '%') )
                              order by RowCode desc,  LENGTH(loopCode) DESC
                    ) tbl1
                    , ( Select @RowNo := 0 ) x
                ) tbl order by RowCode desc,  LENGTH(loopCode) DESC ;

    -- select * from tmp_all_code_;

        IF (p_isExport = 0)
        THEN

					insert into tmp_code_
                         select * from tmp_all_code_
                         order by RowCode	LIMIT p_RowspPage OFFSET v_OffSet_ ;

		ELSE

     					insert into tmp_code_
                              select * from tmp_all_code_
                              order by RowCode	  ;

		END IF;


IF p_Preference = 1 THEN

	-- Sort by Preference
	INSERT IGNORE INTO tmp_VendorRateByRank_
	  SELECT
		AccountID,
		AccountName,
		Code,
		Rate,
		ConnectionFee,
		EffectiveDate,
		Description,
		Preference,
		preference_rank
	  FROM (SELECT
		  AccountID,
		  AccountName,
		  Code,
		  Rate,
		  ConnectionFee,
		  EffectiveDate,
		  Description,
		  Preference,
		  @preference_rank := CASE WHEN (@prev_Code     = Code AND @prev_Preference > Preference  ) THEN @preference_rank + 1
								   WHEN (@prev_Code     = Code AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
								   WHEN (@prev_Code    = Code AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
								   ELSE 1
								   END AS preference_rank,
		  @prev_Code := Code,
		  @prev_Preference := IFNULL(Preference, 5),
		  @prev_Rate := Rate
		FROM tmp_VendorCurrentRates_ AS preference,
			 (SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
		ORDER BY preference.Code ASC, preference.Preference DESC, preference.Rate ASC,preference.AccountId ASC

		 ) tbl
	  WHERE preference_rank <= 5
	  ORDER BY Code, preference_rank;

	ELSE


	-- Sort by Rate
	INSERT IGNORE INTO tmp_VendorRateByRank_
	  SELECT
		AccountID,
		AccountName,
		Code,
		Rate,
		ConnectionFee,
		EffectiveDate,
		Description,
		Preference,
		RateRank
	  FROM (SELECT
		  AccountID,
		  AccountName,
		  Code,
		  Rate,
		  ConnectionFee,
		  EffectiveDate,
		  Description,
		  Preference,
		  @rank := CASE WHEN (@prev_Code    = Code AND @prev_Rate < Rate) THEN @rank + 1
						WHEN (@prev_Code    = Code AND @prev_Rate = Rate) THEN @rank
						ELSE 1
						END AS RateRank,
		  @prev_Code := Code,
		  @prev_Rate := Rate
		FROM tmp_VendorCurrentRates_ AS rank,
			 (SELECT @rank := 0 , @prev_Code := '' , @prev_Rate := 0) f
		ORDER BY rank.Code ASC, rank.Rate,rank.AccountId ASC) tbl
	  WHERE RateRank <= 5
	  ORDER BY Code, RateRank;

	END IF;

-- --------- Split Logic ----------
/* DESC             MaxMatchRank 1  MaxMatchRank 2
923 Pakistan :       *923 V1          92 V1
923 Pakistan :       *92 V2            -

now take only where  MaxMatchRank =  1
*/


DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1;
 CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate_stage_1 as (select * from tmp_VendorRate_stage_);

 insert ignore into tmp_VendorRate_stage_1 (
   	     RowCode,
     	AccountId ,
     	AccountName ,
     	Code ,
     	Rate ,
     	ConnectionFee,
     	EffectiveDate ,
     	Description ,
     	Preference
)
          SELECT
          distinct
     	RowCode,
     	v.AccountId ,
     	v.AccountName ,
     	v.Code ,
     	v.Rate ,
     	v.ConnectionFee,
     	v.EffectiveDate ,
     	v.Description ,
     	v.Preference
          FROM tmp_VendorRateByRank_ v
          left join  tmp_all_code_
			SplitCode   on v.Code = SplitCode.Code
         where  SplitCode.Code is not null and rankname <= 5
         order by AccountID,SplitCode.RowCode desc ,LENGTH(SplitCode.RowCode), v.Code desc, LENGTH(v.Code)  desc;


     insert ignore into tmp_VendorRate_stage_
          SELECT
          distinct
     	RowCode,
     	v.AccountId ,
     	v.AccountName ,
     	v.Code ,
     	v.Rate ,
     	v.ConnectionFee,
     	v.EffectiveDate ,
     	v.Description ,
     	v.Preference,
     	@rank := ( CASE WHEN( @prev_AccountID = v.AccountId  and @prev_RowCode     = RowCode  /*and @prev_RowNo > SplitCode.RowNo */ )
                                   THEN  @rank + 1
                                   ELSE 1
                              END
          ) AS MaxMatchRank,
	     @prev_RowCode := RowCode	 ,
          @prev_AccountID := v.AccountId
          FROM tmp_VendorRate_stage_1 v
          , (SELECT  @prev_RowCode := '',  @rank := 0 , @prev_Code := '' , @prev_AccountID := Null) f
          order by AccountID,RowCode desc ;
         -- order by AccountId, /*SplitCode.RowCode desc ,*/  LENGTH(v.Code)  desc  ;

    -- select * from tmp_VendorRate_stage_;

              insert ignore into tmp_VendorRate_
              select
                    distinct
				 AccountId ,
				 AccountName ,
				 Code ,
				 Rate ,
                    ConnectionFee,
				 EffectiveDate ,
				 Description ,
				 Preference,
				 RowCode
		   from tmp_VendorRate_stage_
           where MaxMatchRank = 1 -- and   (CHAR_LENGTH(RTRIM(p_code)) = 0  OR RowCode LIKE REPLACE(p_code,'*', '%') )
          -- and AccountID = 447 and (RowCode like '937' OR  RowCode like '93' )
			  			  order by RowCode desc;

-- select * from tmp_VendorRate_;


		IF( p_Preference = 0 )
     	THEN

			insert into tmp_final_VendorRate_
			SELECT
			     AccountId ,
			     AccountName ,
			     Code ,
			     Rate ,
                    ConnectionFee,
			     EffectiveDate ,
			     Description ,
			     Preference,
			     RowCode,
	  		     FinalRankNumber
				from
				(
					SELECT
					AccountId ,
				     AccountName ,
				     Code ,
				     Rate ,
                         ConnectionFee,
				     EffectiveDate ,
				     Description ,
				     Preference,
				     RowCode,
   			         @rank := CASE WHEN ( @prev_RowCode     = RowCode AND @prev_Rate <  Rate ) THEN @rank+1
                                   WHEN ( @prev_RowCode    = RowCode AND @prev_Rate = Rate ) THEN @rank
						   ELSE
						   1
						   END
				  		  AS FinalRankNumber,
				  	@prev_RowCode  := RowCode,
					@prev_Rate  := Rate
					from tmp_VendorRate_
					,( SELECT @rank := 0 , @prev_RowCode := '' , @prev_Rate := 0 ) x
				 	order by RowCode,Rate,AccountId ASC

				) tbl1
				where
				FinalRankNumber <= 5;

		 ELSE

		 	 insert into tmp_final_VendorRate_
			SELECT
				AccountId ,
			     AccountName ,
			     Code ,
			     Rate ,
                    ConnectionFee,
			     EffectiveDate ,
			     Description ,
			     Preference,
			     RowCode,
	  		     FinalRankNumber
				from
				(
					SELECT
     					AccountId ,
     				     AccountName ,
     				     Code ,
     				     Rate ,
                             ConnectionFee,
     				     EffectiveDate ,
     				     Description ,
     				     Preference,
     				     RowCode,
                              @preference_rank := CASE WHEN (@prev_Code     = RowCode AND @prev_Preference > Preference /*AND @prev_Rate2 <  Rate*/)   THEN @preference_rank + 1
                                                       WHEN (@prev_Code     = RowCode AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
                                                       WHEN (@prev_Code    = RowCode AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
                                                       ELSE 1 END AS FinalRankNumber,
                              @prev_Code := RowCode,
                              @prev_Preference := Preference,
                              @prev_Rate := Rate
					from tmp_VendorRate_
                          ,(SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
     			 	 order by RowCode ASC ,Preference DESC ,Rate ASC ,AccountId ASC

				) tbl1
				where
				FinalRankNumber <= 5;

		 END IF;

          -- ------------------------------------------------------------------

          -- select * from tmp_final_VendorRate_;


    IF (p_isExport = 0)
    THEN

    		 SELECT
           CONCAT(ANY_VALUE(t.RowCode) , ' : ' , ANY_VALUE(t.Description)) as Destination,
          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 1, CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 1`,
          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 2, CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName), '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 2`,
          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 3, CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 3`,
          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 4, CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 4`,
          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 5, CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 5`
        FROM tmp_final_VendorRate_  t
          GROUP BY  RowCode
          ORDER BY RowCode ASC
     	LIMIT p_RowspPage OFFSET v_OffSet_ ;


               -- select count(distinct RowCode) as totalcount from tmp_all_code_ ; -- where    ( CHAR_LENGTH(RTRIM(p_code)) = 0  OR RowCode LIKE REPLACE(p_code,'*', '%') )    ;

                select count(distinct RowCode) as totalcount from tmp_final_VendorRate_ where    ( CHAR_LENGTH(RTRIM(p_code)) = 0  OR RowCode LIKE REPLACE(p_code,'*', '%') )    ;


   END IF;

   IF p_isExport = 1
    THEN
		SELECT
           CONCAT(ANY_VALUE(t.RowCode) , ' : ' , ANY_VALUE(t.Description)) as Destination,
          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 1, CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 1`,
          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 2, CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName), '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 2`,
          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 3, CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 3`,
          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 4, CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 4`,
          GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = 5, CONCAT(ANY_VALUE(t.Code), '<br>', ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `POSITION 5`
        FROM tmp_final_VendorRate_  t
          GROUP BY  RowCode
          ORDER BY RowCode ASC;
	END IF;


SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;



END ;;
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_InsertDiscontinuedVendorRate`;
DELIMITER ;;
CREATE  PROCEDURE `prc_InsertDiscontinuedVendorRate`(
	IN `p_AccountId` INT,
	IN `p_TrunkId` INT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
	 SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		--  tmp_Delete_VendorRate table created in prc_VendorBulkRateDelete if vendor delete from front end
		-- tmp_Delete_VendorRate table created in prc_WSProcessVendorRate if vendor delete from service or vendor upload process


	 	-- insert vendor rate in tblVendorRateDiscontinued before delete
	 	INSERT INTO tblVendorRateDiscontinued(
					VendorRateID,
			   	AccountId,
			   	TrunkID,
					RateId,
			   	Code,
			   	Description,
			   	Rate,
			   	EffectiveDate,
			   	Interval1,
			   	IntervalN,
			   	ConnectionFee,
			   	deleted_at
					)
		SELECT DISTINCT
			   	VendorRateID,
			   	AccountId,
			   	TrunkID,
					RateId,
			   	Code,
			   	Description,
			   	Rate,
			   	EffectiveDate,
			   	Interval1,
			   	IntervalN,
			   	ConnectionFee,
			   	deleted_at
		FROM tmp_Delete_VendorRate
			ORDER BY VendorRateID ASC
			;

		-- delete old code or duplicate code from tblVendorRateDiscontinued

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateDiscontinued_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRateDiscontinued_ (PRIMARY KEY (DiscontinuedID), INDEX tmp_UK_tblVendorRateDiscontinued (AccountId, RateId)) as (select * from tblVendorRateDiscontinued);

		  DELETE n1 FROM tblVendorRateDiscontinued n1, tmp_VendorRateDiscontinued_ n2 WHERE n1.DiscontinuedID < n2.DiscontinuedID
		  	 AND  n1.RateId = n2.RateId
		  	 AND  n1.AccountId = n2.AccountId
			 AND  n1.AccountId = p_AccountId;

		-- delete vendor rate from tblVendorRate

		DELETE tblVendorRate
			FROM tblVendorRate
				INNER JOIN(	SELECT dv.VendorRateID FROM tmp_Delete_VendorRate dv) tmdv
					ON tmdv.VendorRateID = tblVendorRate.VendorRateID
			WHERE tblVendorRate.AccountId = p_AccountId;

		CALL prc_ArchiveOldVendorRate(p_AccountId,p_TrunkId);

   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;
END ;
DELIMITER ;;

ALTER TABLE `tblVendorRateDiscontinued`	ADD INDEX `UK_tblVendorRateDiscontinued` (`AccountId`, `RateId`);
-- Duplicate index same column index exists with unique key
ALTER TABLE tblVendorRate DROP INDEX IX_VendorRate_Accountid_EffectiveDate_TrunkID_RateID;


-- Girish

USE `Ratemanagement3`;

CREATE TABLE IF NOT EXISTS `tblCLIRateTable` (
  `CLIRateTableID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `AccountID` int(11) NOT NULL,
  `CLI` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `RateTableID` int(11) NOT NULL,
  PRIMARY KEY (`CLIRateTableID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP PROCEDURE IF EXISTS `migrateCLI`;
DELIMITER |
CREATE  PROCEDURE `migrateCLI`()
BEGIN

DECLARE i INT;
DROP TEMPORARY TABLE IF EXISTS `CLIRateTable`; /*Temp table for matching ipcli account*/
CREATE TEMPORARY TABLE `CLIRateTable` (
	`CompanyID` INT NOT NULL,
  `AccountID` INT NOT NULL,
  `CLI` LONGTEXT NOT NULL
);



SET i = 1;
REPEAT
	INSERT INTO CLIRateTable
	SELECT CompanyID,AccountID,Ratemanagement3.FnStringSplit(CustomerAuthValue, ',', i) FROM tblAccountAuthenticate WHERE CustomerAuthRule = 'CLI' AND Ratemanagement3.FnStringSplit(CustomerAuthValue, ',', i) IS NOT NULL LIMIT 1;
	SET i = i + 1;
	UNTIL ROW_COUNT() = 0
END REPEAT;

INSERT INTO tblCLIRateTable (CompanyID,AccountID,CLI,RateTableID)
SELECT CompanyID,AccountID,CLI,0 FROM CLIRateTable;


END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_GetCrmDashboardSalesManager`;
DELIMITER |
CREATE  PROCEDURE `prc_GetCrmDashboardSalesManager`(
	IN `p_CompanyID` INT,
	IN `p_OwnerID` VARCHAR(500),
	IN `p_CurrencyID` INT,
	IN `p_ListType` VARCHAR(50),
	IN `p_Start` DATETIME,
	IN `p_End` DATETIME
)
BEGIN
	DECLARE v_CurrencyCode_ VARCHAR(50);
	DECLARE v_Round_ INT;

	SELECT cr.Symbol INTO v_CurrencyCode_ from tblCurrency cr where cr.CurrencyId =p_CurrencyID;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	DROP TEMPORARY TABLE IF EXISTS tmp_Dashboard_invoices_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Dashboard_invoices_(
		AssignedUserText VARCHAR(100),
		AssignedUserID INT,
		Revenue decimal(18,8),
		`Year` INT,
		`Month` INT,
		`Week` INT
	);

	INSERT INTO tmp_Dashboard_invoices_
	SELECT
		CONCAT(tu.FirstName,' ',tu.LastName) AS `AssignedUserText`,
		 tu.UserID AS  AssignedUserID,
		sum(`inv`.`GrandTotal`) AS `Revenue`,
		YEAR(inv.IssueDate) AS Year,
		MONTH(inv.IssueDate) AS Month,
		WEEK(inv.IssueDate)	 AS `Week`
	FROM RMBilling3.tblInvoice inv
	Inner JOIN tblAccount ac
		ON ac.AccountID = inv.AccountID
	INNER JOIN tblUser tu
		ON tu.UserID = ac.Owner
	WHERE
		ac.`Status` = 1
	AND tu.`Status` = 1
	AND (p_CurrencyID = '' OR ( p_CurrencyID !=''  AND ac.CurrencyId = p_CurrencyID))
	AND ac.CompanyID = p_CompanyID
	AND (p_OwnerID = '' OR   FIND_IN_SET(tu.UserID,p_OwnerID))
	AND `inv`.`InvoiceType` = 1
	AND `inv`.GrandTotal != 0
	AND (inv.IssueDate BETWEEN p_Start AND p_End)
	GROUP BY
		YEAR(inv.IssueDate)
		,MONTH(inv.IssueDate)
		,WEEK(inv.IssueDate)
		,CONCAT(tu.FirstName,' ',tu.LastName)
		,tu.UserID;

	IF p_ListType = 'Monthly'
	THEN

		SELECT
			td.AssignedUserText AS AssignedUserText,
			td.AssignedUserID AS AssignedUserID,
			ROUND(sum(td.Revenue),v_Round_) AS Revenue,
			v_CurrencyCode_,
			CONCAT(CONCAT(case when td.Month <10 then concat('0',td.Month) else td.Month End, '/'), td.Year) AS MonthName,
			v_Round_ AS round_number
		FROM tmp_Dashboard_invoices_  td
		GROUP BY
			td.Month,
			td.Year,
			td.AssignedUserID,
			td.AssignedUserText;

	END IF;

	IF p_ListType = 'Weekly'
	THEN
		SELECT
			td.AssignedUserText AS AssignedUserText,
			td.AssignedUserID,
			ROUND(sum(td.Revenue),v_Round_) AS Revenue,
			v_CurrencyCode_,
			CONCAT(td.`Week`,'-',MAX( td.Year)) AS `Week`,
			MAX( td.Year) AS `Year`,
			td.`Week` AS `Weekday`,
			v_Round_ AS round_number
		FROM  tmp_Dashboard_invoices_  td
		GROUP BY
			td.`Week`
			,td.AssignedUserText
			,td.AssignedUserID
		ORDER BY
			`Year`,
			`Weekday` ASC;
	END IF;

END|
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_GetCrmDashboardSalesUser
DROP PROCEDURE IF EXISTS `prc_GetCrmDashboardSalesUser`;
DELIMITER |
CREATE  PROCEDURE `prc_GetCrmDashboardSalesUser`(
	IN `p_CompanyID` INT,
	IN `p_OwnerID` VARCHAR(500),
	IN `p_CurrencyID` INT,
	IN `p_ListType` VARCHAR(50),
	IN `p_Start` DATETIME,
	IN `p_End` VARCHAR(50),
	IN `p_WeekOrMonth` INT,
	IN `p_Year` INT
)
BEGIN
	DECLARE v_CurrencyCode_ VARCHAR(50);
	DECLARE v_Round_ int;

	SELECT cr.Symbol INTO v_CurrencyCode_ from tblCurrency cr where cr.CurrencyId =p_CurrencyID;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	DROP TEMPORARY TABLE IF EXISTS tmp_Dashboard_user_invoices_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Dashboard_user_invoices_(
		AssignedUserText varchar(100),
		Revenue decimal(18,8)
	);

	INSERT INTO tmp_Dashboard_user_invoices_
	SELECT
		ac.AccountName  AS `AssignedUserText`,
		SUM(`inv`.`GrandTotal`) AS `Revenue`
	FROM RMBilling3.tblInvoice inv
	INNER JOIN  tblAccount ac
		ON ac.AccountID = inv.AccountID
	INNER JOIN tblUser tu
		ON tu.UserID = ac.Owner
	WHERE
		ac.`Status` = 1
	AND tu.`Status` = 1
	AND (p_CurrencyID = '' OR ( p_CurrencyID !=''  AND ac.CurrencyId = p_CurrencyID))
	AND ac.CompanyID = p_CompanyID
	AND (p_OwnerID = '' OR   FIND_IN_SET(tu.UserID,p_OwnerID))
	AND `inv`.`InvoiceType` = 1
	AND (inv.IssueDate BETWEEN p_Start AND p_End)
	AND (( p_ListType = 'Weekly' AND WEEK(inv.IssueDate) = p_WeekOrMonth AND YEAR(inv.IssueDate) = p_Year) OR ( p_ListType = 'Monthly' AND MONTH(inv.IssueDate) = p_WeekOrMonth AND YEAR(inv.IssueDate) = p_Year))
	GROUP BY
		ac.AccountName;

	SELECT
		td.AssignedUserText,
		ROUND(td.Revenue,v_Round_) AS Revenue,
		v_CurrencyCode_ AS CurrencyCode,
		v_Round_ AS round_number
	FROM  tmp_Dashboard_user_invoices_  td;

END|
DELIMITER ;

-- Dumping structure for procedure Ratemanagement3.prc_getCustomerInboundRate
DROP PROCEDURE IF EXISTS `prc_getCustomerInboundRate`;
DELIMITER |
CREATE  PROCEDURE `prc_getCustomerInboundRate`(
	IN `p_AccountID` INT,
	IN `p_RateCDR` INT,
	IN `p_RateMethod` VARCHAR(50),
	IN `p_SpecifyRate` DECIMAL(18,6),
	IN `p_CLD` VARCHAR(500)
)
BEGIN

	DECLARE v_inboundratetableid_ INT;

	IF p_CLD != ''
	THEN

		SELECT
			RateTableID INTO v_inboundratetableid_
		FROM tblCLIRateTable
		WHERE AccountID = p_AccountID AND CLI = p_CLD;

	ELSE

		SELECT
			InboudRateTableID INTO v_inboundratetableid_
		FROM tblAccount
		WHERE AccountID = p_AccountID;

	END IF;

	IF p_RateCDR = 1
	THEN

		DROP TEMPORARY TABLE IF EXISTS tmp_inboundcodes_;
		CREATE TEMPORARY TABLE tmp_inboundcodes_ (
			RateID INT,
			Code VARCHAR(50),
			Rate Decimal(18,6),
			ConnectionFee Decimal(18,6),
			Interval1 INT,
			IntervalN INT,
			INDEX tmp_inboundcodes_RateID (`RateID`),
			INDEX tmp_inboundcodes_Code (`Code`)
		);
		INSERT INTO tmp_inboundcodes_
		SELECT
			DISTINCT
			tblRate.RateID,
			tblRate.Code,
			tblRateTableRate.Rate,
			tblRateTableRate.ConnectionFee,
			tblRateTableRate.Interval1,
			tblRateTableRate.IntervalN
		FROM tblRate
		INNER JOIN tblRateTableRate
			ON tblRateTableRate.RateID = tblRate.RateID
		WHERE RateTableID = v_inboundratetableid_
		AND tblRateTableRate.EffectiveDate <= NOW();

		/* if Specify Rate is set when cdr rerate */
		IF p_RateMethod = 'SpecifyRate'
		THEN

			UPDATE tmp_inboundcodes_ SET Rate=p_SpecifyRate;

		END IF;

	END IF;
END|
DELIMITER ;


-- Umer
USE `Ratemanagement3`;

CREATE TABLE IF NOT EXISTS `tblHelpDeskTickets` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `TicketID` int(11) DEFAULT NULL,
  `Subject` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `Description` text COLLATE utf8_unicode_ci NOT NULL,
  `Priority` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Status` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Type` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GUID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Group` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `to_emails` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `RequestEmail` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TicketType` tinyint(4) NOT NULL DEFAULT '0',
  `TicketAgent` int(11) NOT NULL DEFAULT '0',
  `ApiCreatedDate` datetime DEFAULT NULL,
  `ApiUpdateDate` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Fresh desk tickets will save  here temporarily\r\nprc_getAccountTimeLine will use it';

-- ##############################################################
-- ALTER TABLE `tblAccountTickets`	ADD COLUMN `TicketType` TINYINT NULL DEFAULT '0' AFTER `RequestEmail`;
-- ALTER TABLE `tblAccountTickets`	CHANGE COLUMN `TicketType` `TicketType` TINYINT(4) NOT NULL DEFAULT '0' AFTER `RequestEmail`;
-- ALTER TABLE `tblAccountTickets`	ADD COLUMN `TicketAgent` INT NOT NULL DEFAULT '0' AFTER `TicketType`;
-- ##############################################################
-- INSERT INTO tblHelpDeskTickets FROM tblAccountTickets;
-- ##############################################################
insert into tblHelpDeskTickets (CompanyID,AccountID,TicketID,Subject,Description,Priority,`Status`,`Type`,GUID,`Group`,to_emails,RequestEmail,TicketType,TicketAgent,ApiCreatedDate,ApiUpdateDate,created_at,created_by,updated_at,updated_by)
select CompanyID,AccountID,TicketID,Subject,Description,Priority,`Status`,`Type`,GUID,`Group`,to_emails,RequestEmail,0 as TicketType, 0 as TicketAgent,ApiCreatedDate,ApiUpdateDate,created_at,created_by,updated_at,updated_by from tblAccountTickets;
-- ##############################################################
ALTER TABLE `AccountEmailLog`
	ADD COLUMN `ContactID` INT(11) NULL DEFAULT NULL AFTER `AccountID`,
	ADD COLUMN `UserType` TINYINT NULL DEFAULT '0' COMMENT '0 for account,1 for contact' AFTER `ContactID`;
-- ##############################################################
ALTER TABLE `tblEmailTemplate`
	ADD COLUMN `EmailFrom` VARCHAR(100) NULL DEFAULT NULL AFTER `Type`,
	ADD COLUMN `StaticType` TINYINT NULL DEFAULT '0' COMMENT '0 for allow deleted,1 for not  allowed to delete' AFTER `EmailFrom`;
ALTER TABLE `tblEmailTemplate`
	ADD COLUMN `SystemType` VARCHAR(100) NULL DEFAULT NULL AFTER `StaticType`;
ALTER TABLE `tblEmailTemplate`
	ADD COLUMN `Status` TINYINT NULL DEFAULT '1' AFTER `SystemType`;
ALTER TABLE `tblEmailTemplate`
	ADD COLUMN `StatusDisabled` TINYINT(4) NULL DEFAULT '0' AFTER `Status`;
ALTER TABLE `tblEmailTemplate`
	CHANGE COLUMN `StatusDisabled` `StatusDisabled` TINYINT(4) NULL DEFAULT '0' COMMENT '0 for allow disable,1 for not  allow disable' AFTER `Status`;
-- ##############################################################
CREATE TABLE IF NOT EXISTS `tbl_Account_Contacts_Activity` (
  `Timeline_id` int(11) NOT NULL AUTO_INCREMENT,
  `Timeline_type` int(11) NOT NULL DEFAULT '0',
  `TaskTitle` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TaskName` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TaskPriority` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `DueDate` datetime DEFAULT NULL,
  `TaskDescription` longtext COLLATE utf8_unicode_ci,
  `TaskStatus` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `followup_task` int(11) DEFAULT NULL,
  `TaskID` int(11) DEFAULT NULL,
  `Emailfrom` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailTo` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailToName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailSubject` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailMessage` longtext COLLATE utf8_unicode_ci,
  `EmailCc` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailBcc` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailAttachments` longtext COLLATE utf8_unicode_ci,
  `AccountEmailLogID` int(11) DEFAULT NULL,
  `NoteID` int(11) DEFAULT NULL,
  `ContactNoteID` int(11) DEFAULT '0',
  `Note` longtext COLLATE utf8_unicode_ci,
  `TicketID` int(11) DEFAULT NULL,
  `TicketSubject` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TicketStatus` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `RequestEmail` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TicketPriority` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TicketType` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TicketGroup` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TicketDescription` longtext COLLATE utf8_unicode_ci,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `TableCreated_at` datetime DEFAULT NULL,
  `GUID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`Timeline_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='temp table';
-- ##############################################################
DROP PROCEDURE IF EXISTS `prc_GetFromEmailAddress`;
DELIMITER //
CREATE PROCEDURE `prc_GetFromEmailAddress`(
	IN `p_CompanyID` int,
	IN `p_userID` int ,
	IN `p_Ticket` INT,
	IN `p_Admin` INT
)
BEGIN
	DECLARE V_Admin int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	/*select count(*) into V_Admin from tblUser tu where tu.UserID=p_userID and tu.Roles like '%Admin';*/

	IF p_Ticket = 1
	THEN
		SELECT DISTINCT GroupEmailAddress as EmailFrom FROM tblTicketGroups where CompanyID = p_CompanyID and GroupEmailStatus = 1 and GroupEmailAddress IS NOT NULL;
	END IF;
	IF p_Ticket = 0
	THEN
		IF p_Admin > 0
		THEN
			SELECT  tc.EmailFrom as EmailFrom FROM tblCompany tc where tc.EmailFrom IS NOT NULL AND tc.EmailFrom <> ''
				UNION ALL
			SELECT DISTINCT(tu.EmailAddress) as EmailFrom from tblUser tu;
		END IF;
		IF p_Admin < 1
		THEN
			SELECT  tc.EmailFrom as EmailFrom FROM tblCompany tc where tc.EmailFrom IS NOT NULL AND tc.EmailFrom <> ''
				UNION ALL
			SELECT tu.EmailAddress as EmailFrom from tblUser tu where tu.UserID = 1;
		END IF;
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;
-- ####################################################################
DROP PROCEDURE IF EXISTS `prc_getAccountTimeLine`;
DELIMITER //
CREATE PROCEDURE `prc_getAccountTimeLine`(
	IN `p_AccountID` INT,
	IN `p_CompanyID` INT,
	IN `p_TicketType` INT,
	IN `p_GUID` VARCHAR(100),
	IN `p_Time` DATE,
	IN `p_Start` INT,
	IN `p_RowspPage` INT
)
BEGIN
DECLARE v_OffSet_ int;
DECLARE v_ActiveSupportDesk int;
DECLARE v_contacts_ids varchar(200);
DECLARE v_contacts_emails varchar(200);
DECLARE v_account_emails varchar(200);
DECLARE v_account_contacts_emails varchar(300);

SET v_OffSet_ = p_Start;
SET sql_mode = 'ALLOW_INVALID_DATES';

/*delete 2 days old records*/
if(p_Start>0)
THEN
	DELETE FROM tbl_Account_Contacts_Activity  WHERE  `TableCreated_at` < DATE_SUB(p_Time, INTERVAL 2 DAY);
END IF;
if(p_Start= 0)
THEN
		/*storing contact ids and email addresses*/
		SELECT
			group_concat(CC.ContactID separator ',')
		FROM
			tblContact CC
		WHERE
			CC.Owner = p_AccountID	INTO v_contacts_ids;

		SELECT
			group_concat(DISTINCT CC.Email separator ',')
		FROM
			tblContact CC
		WHERE
			CC.Owner = p_AccountID	INTO v_contacts_emails;

		/*storing account emails*/
		SELECT
		(CASE WHEN tac.Email = tac.BillingEmail THEN tac.Email ELSE concat(tac.Email,',',tac.BillingEmail) END)
		FROM
			tblAccount tac
		WHERE
			tac.AccountID = p_AccountID	INTO v_contacts_emails;
		/*combining account and contacts emails*/
		select concat(v_contacts_emails,',',v_contacts_emails) into v_account_contacts_emails;


			/*tasks start*/
			INSERT INTO tbl_Account_Contacts_Activity(  `Timeline_type`,  `TaskTitle`,  `TaskName`,  `TaskPriority`,  `DueDate`,  `TaskDescription`,  `TaskStatus`,  `followup_task`,  `TaskID`,  `Emailfrom`,  `EmailTo`,  `EmailToName`,  `EmailSubject`,  `EmailMessage`,  `EmailCc`, `EmailBcc`,  `EmailAttachments`,  `AccountEmailLogID`,  `NoteID`,  `Note`,  `TicketID`,  `TicketSubject`,  `TicketStatus`,  `RequestEmail`,  `TicketPriority`,  `TicketType`,  `TicketGroup`,  `TicketDescription`,  `CreatedBy`,  `created_at`,  `updated_at`,  `GUID`,`TableCreated_at`)
				SELECT
				1 as Timeline_type,
				t.Subject,
				  concat(u.FirstName,' ',u.LastName) as Name,
				 case when t.Priority =1
					  then 'High'
					  else
					   'Low' end  as Priority,
					DueDate,
				t.Description,
				bc.BoardColumnName as TaskStatus,
				t.Task_type,
				t.TaskID,
				'' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID,0 as NoteID,'' as Note ,
				0 as TicketID, '' as 	TicketSubject,	'' as	TicketStatus,	'' as 	RequestEmail,	'' as 	TicketPriority,	'' as 	TicketType,	'' as 	TicketGroup,	'' as TicketDescription,
				t.CreatedBy,t.created_at, t.updated_at,p_GUID as GUID,p_Time as TableCreated_at
			FROM tblTask t
			INNER JOIN tblCRMBoardColumn bc on  t.BoardColumnID = bc.BoardColumnID
			JOIN tblUser u on  u.UserID = t.UsersIDs
			WHERE t.AccountIDs = p_AccountID and t.CompanyID =p_CompanyID;
			/*tasks end*/


			/*emails start*/
			INSERT INTO tbl_Account_Contacts_Activity(  `Timeline_type`,  `TaskTitle`,  `TaskName`,  `TaskPriority`,  `DueDate`,  `TaskDescription`,  `TaskStatus`,  `followup_task`,  `TaskID`,  `Emailfrom`,  `EmailTo`,  `EmailToName`,  `EmailSubject`,  `EmailMessage`,  `EmailCc`, `EmailBcc`,  `EmailAttachments`,  `AccountEmailLogID`,  `NoteID`,  `Note`,  `TicketID`,  `TicketSubject`,  `TicketStatus`,  `RequestEmail`,  `TicketPriority`,  `TicketType`,  `TicketGroup`,  `TicketDescription`,  `CreatedBy`,  `created_at`,  `updated_at`,  `GUID`,`TableCreated_at`)
			select 2 as Timeline_type,'' as TaskTitle,'' as TaskName,'' as TaskPriority, '0000-00-00 00:00:00' as DueDate, '' as TaskDescription,'' as TaskStatus,0 as Task_type,0 as TaskID, Emailfrom, EmailTo,
			case when concat(tu.FirstName,' ',tu.LastName) IS NULL or concat(tu.FirstName,' ',tu.LastName) = ''
					then ael.EmailTo
					else concat(tu.FirstName,' ',tu.LastName)
			   end as EmailToName,
			Subject,Message,Cc,Bcc,AttachmentPaths as EmailAttachments,AccountEmailLogID,0 as NoteID,'' as Note ,0 as TicketID, '' as 	TicketSubject,	'' as	TicketStatus,	'' as 	RequestEmail,	'' as 	TicketPriority,	'' as 	TicketType,	'' as 	TicketGroup,	'' as TicketDescription,ael.CreatedBy,ael.created_at, ael.updated_at,p_GUID as GUID,p_Time as TableCreated_at
			from `AccountEmailLog` ael
			left JOIN tblUser tu
				ON tu.EmailAddress = ael.EmailTo
			where ael.CompanyID = p_CompanyID AND ((ael.AccountID = p_AccountID) OR (FIND_IN_SET(ael.ContactID,(v_contacts_ids)) ))
			and ael.EmailParent=0 order by ael.created_at desc;
			/*emails end*/

			/*nots start*/
			INSERT INTO tbl_Account_Contacts_Activity(  `Timeline_type`,  `TaskTitle`,  `TaskName`,  `TaskPriority`,  `DueDate`,  `TaskDescription`,  `TaskStatus`,  `followup_task`,  `TaskID`,  `Emailfrom`,  `EmailTo`,  `EmailToName`,  `EmailSubject`,  `EmailMessage`,  `EmailCc`, `EmailBcc`,  `EmailAttachments`,  `AccountEmailLogID`,  `NoteID`,  `Note`,  `TicketID`,  `TicketSubject`,  `TicketStatus`,  `RequestEmail`,  `TicketPriority`,  `TicketType`,  `TicketGroup`,  `TicketDescription`,  `CreatedBy`,  `created_at`,  `updated_at`,  `GUID`,`TableCreated_at`)
			select 3 as Timeline_type,'' as TaskTitle,'' as TaskName,'' as TaskPriority, '0000-00-00 00:00:00' as DueDate, '' as TaskDescription,'' as TaskStatus, 0 as Task_type,0 as TaskID, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID,NoteID,Note,0 as TicketID, '' as 	TicketSubject,	'' as	TicketStatus,	'' as 	RequestEmail,	'' as 	TicketPriority,	'' as 	TicketType,	'' as 	TicketGroup,	'' as TicketDescription,created_by,created_at,updated_at ,p_GUID as GUID,p_Time as TableCreated_at
			from `tblNote`
			where (`CompanyID` = p_CompanyID and `AccountID` = p_AccountID) order by created_at desc;

			INSERT INTO tbl_Account_Contacts_Activity(  `Timeline_type`,  `TaskTitle`,  `TaskName`,  `TaskPriority`,  `DueDate`,  `TaskDescription`,  `TaskStatus`,  `followup_task`,  `TaskID`,  `Emailfrom`,  `EmailTo`,  `EmailToName`,  `EmailSubject`,  `EmailMessage`,  `EmailCc`, `EmailBcc`,  `EmailAttachments`,  `AccountEmailLogID`,  `ContactNoteID`,  `Note`,  `TicketID`,  `TicketSubject`,  `TicketStatus`,  `RequestEmail`,  `TicketPriority`,  `TicketType`,  `TicketGroup`,  `TicketDescription`,  `CreatedBy`,  `created_at`,  `updated_at`,  `GUID`,`TableCreated_at`)
			select 3 as Timeline_type,'' as TaskTitle,'' as TaskName,'' as TaskPriority, '0000-00-00 00:00:00' as DueDate, '' as TaskDescription,'' as TaskStatus, 0 as Task_type,0 as TaskID, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID,NoteID,Note,0 as TicketID, '' as 	TicketSubject,	'' as	TicketStatus,	'' as 	RequestEmail,	'' as 	TicketPriority,	'' as 	TicketType,	'' as 	TicketGroup,	'' as TicketDescription,created_by,created_at,updated_at ,p_GUID as GUID,p_Time as TableCreated_at
			from `tblContactNote` where (`CompanyID` = p_CompanyID and FIND_IN_SET(ContactID,(v_contacts_ids)))  order by created_at desc;
			/*notes end*/

			/*tickets start*/
			/*IF v_ActiveSupportDesk=1*/

			IF p_TicketType=2 /*FRESH DESK TICKETS*/
			THEN
			INSERT INTO tbl_Account_Contacts_Activity(  `Timeline_type`,  `TaskTitle`,  `TaskName`,  `TaskPriority`,  `DueDate`,  `TaskDescription`,  `TaskStatus`,  `followup_task`,  `TaskID`,  `Emailfrom`,  `EmailTo`,  `EmailToName`,  `EmailSubject`,  `EmailMessage`,  `EmailCc`, `EmailBcc`,  `EmailAttachments`,  `AccountEmailLogID`,  `NoteID`,  `Note`,  `TicketID`,  `TicketSubject`,  `TicketStatus`,  `RequestEmail`,  `TicketPriority`,  `TicketType`,  `TicketGroup`,  `TicketDescription`,  `CreatedBy`,  `created_at`,  `updated_at`,  `GUID`,`TableCreated_at`)
			select 4 as Timeline_type,'' as TaskTitle,'' as TaskName,'' as TaskPriority, '0000-00-00 00:00:00' as DueDate, '' as TaskDescription,'' as TaskStatus, 0 as Task_type,0 as TaskID, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID, 0 as NoteID,'' as Note,
			TAT.TicketID,	TAT.Subject as 	TicketSubject,	TAT.Status as	TicketStatus,	TAT.RequestEmail as 	RequestEmail,	TAT.Priority as 	TicketPriority,	TAT.`Type` as 	TicketType,	TAT.`Group` as 	TicketGroup,	TAT.`Description` as TicketDescription,created_by,ApiCreatedDate as created_at,ApiUpdateDate as updated_at,p_GUID as GUID,p_Time as TableCreated_at
			from
				`tblHelpDeskTickets` TAT
			where
				(TAT.`CompanyID` = p_CompanyID and TAT.`AccountID` = p_AccountID and TAT.GUID = p_GUID);
			END IF;

			IF p_TicketType=1 /*SYSTEM TICKETS*/
			THEN
			INSERT INTO tbl_Account_Contacts_Activity(  `Timeline_type`,  `TaskTitle`,  `TaskName`,  `TaskPriority`,  `DueDate`,  `TaskDescription`,  `TaskStatus`,  `followup_task`,  `TaskID`,  `Emailfrom`,  `EmailTo`,  `EmailToName`,  `EmailSubject`,  `EmailMessage`,  `EmailCc`, `EmailBcc`,  `EmailAttachments`,  `AccountEmailLogID`,  `NoteID`,  `Note`,  `TicketID`,  `TicketSubject`,  `TicketStatus`,  `RequestEmail`,  `TicketPriority`,  `TicketType`,  `TicketGroup`,  `TicketDescription`,  `CreatedBy`,  `created_at`,  `updated_at`,  `GUID`,`TableCreated_at`)
				select 4 as Timeline_type,'' as TaskTitle,'' as TaskName,'' as TaskPriority, '0000-00-00 00:00:00' as DueDate, '' as TaskDescription,'' as TaskStatus, 0 as Task_type,0 as TaskID, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID, 0 as NoteID,'' as Note,
				TT.TicketID,TT.Subject as 	TicketSubject,	TFV.FieldValueAgent  as	TicketStatus,	TT.Requester as 	RequestEmail,TP.PriorityValue as TicketPriority,	TFVV.FieldValueAgent as 	TicketType,	TG.GroupName as TicketGroup,	TT.`Description` as TicketDescription,TT.created_by,TT.created_at,TT.updated_at,p_GUID as GUID,p_Time as TableCreated_at
			from
				`tblTickets` TT
			LEFT JOIN tblTicketfieldsValues TFV
				ON TFV.ValuesID = TT.Status
			LEFT JOIN tblTicketPriority TP
				ON TP.PriorityID = TT.Priority
			LEFT JOIN tblTicketGroups TG
				ON TG.GroupID = TT.`Group`
			LEFT JOIN tblTicketfieldsValues TFVV
				ON TFVV.ValuesID = TT.Type
			/*LEFT JOIN tblAccount TA
				ON TA.Email = TT.Requester
			LEFT JOIN tblAccount TAT
				ON TAT.BillingEmail = TT.Requester
			LEFT JOIN tblContact TC
				ON TC.Email = TT.Requester	*/
			where
				TT.`CompanyID` = p_CompanyID and
			/*(((TA.`AccountID` = p_AccountID) OR (TAT.`AccountID` = p_AccountID) ) OR (TC.ContactID IN (v_contacts_ids)))*/
			FIND_IN_SET(TT.Requester,(v_account_contacts_emails));
			END IF;
			/*tickets end*/
END IF;
	select * from tbl_Account_Contacts_Activity where GUID = p_GUID order by created_at desc LIMIT p_RowspPage OFFSET v_OffSet_ ;
END//
DELIMITER ;
-- ##########################################################
DROP PROCEDURE IF EXISTS `prc_getContactTimeLine`;
DELIMITER //
CREATE PROCEDURE `prc_getContactTimeLine`(
	IN `p_ContactID` INT,
	IN `p_CompanyID` INT,
	IN `p_TicketType` INT,
	IN `p_GUID` VARCHAR(100),
	IN `p_Start` INT,
	IN `p_RowspPage` INT

)
BEGIN
DECLARE v_OffSet_ int;
DECLARE v_ActiveSupportDesk int;
SET v_OffSet_ = p_Start;
SET sql_mode = 'ALLOW_INVALID_DATES';

	DROP TEMPORARY TABLE IF EXISTS tmp_actvity_timeline_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_actvity_timeline_(
		`Timeline_type` int(11),
		Emailfrom varchar(50),
		EmailTo varchar(50),
		EmailToName varchar(50),
		EmailSubject varchar(200),
		EmailMessage LONGTEXT,
		EmailCc varchar(500),
		EmailBcc varchar(500),
		EmailAttachments LONGTEXT,
		AccountEmailLogID int(11),
	    NoteID int(11),
		Note longtext,
		TicketID int(11),
		TicketSubject varchar(200),
		TicketStatus varchar(100),
		RequestEmail varchar(100),
		TicketPriority varchar(100),
		TicketType varchar(100),
		TicketGroup varchar(100),
		TicketDescription LONGTEXT,
		CreatedBy varchar(50),
		created_at datetime,
		updated_at datetime
	);

	INSERT INTO tmp_actvity_timeline_
	select 2 as Timeline_type, Emailfrom, EmailTo,
	case when concat(tu.FirstName,' ',tu.LastName) IS NULL or concat(tu.FirstName,' ',tu.LastName) = ''
            then ael.EmailTo
            else concat(tu.FirstName,' ',tu.LastName)
       end as EmailToName,
	Subject,Message,Cc,Bcc,AttachmentPaths as EmailAttachments,AccountEmailLogID,0 as NoteID,'' as Note ,0 as TicketID, '' as 	TicketSubject,	'' as	TicketStatus,	'' as 	RequestEmail,	'' as 	TicketPriority,	'' as 	TicketType,	'' as 	TicketGroup,	'' as TicketDescription,ael.CreatedBy,ael.created_at, ael.updated_at
	from `AccountEmailLog` ael
	left JOIN tblUser tu
		ON tu.EmailAddress = ael.EmailTo
	where
	ael.ContactID = p_ContactID and
	ael.CompanyID = p_CompanyID and
	ael.UserType=1 and
	ael.EmailParent=0
	order by ael.created_at desc;

	INSERT INTO tmp_actvity_timeline_
	select 3 as Timeline_type, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID,NoteID,Note,0 as TicketID, '' as 	TicketSubject,	'' as	TicketStatus,	'' as 	RequestEmail,	'' as 	TicketPriority,	'' as 	TicketType,	'' as 	TicketGroup,	'' as TicketDescription,created_by,created_at,updated_at
	from `tblContactNote` where (`CompanyID` = p_CompanyID and `ContactID` = p_ContactID) order by created_at desc;
	/*IF v_ActiveSupportDesk=1*/

	IF p_TicketType=2 /*FRESH DESK TICKETS*/
	THEN
	INSERT INTO tmp_actvity_timeline_
	select 4 as Timeline_type, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID, 0 as NoteID,'' as Note,
	TAT.TicketID,	TAT.Subject as 	TicketSubject,	TAT.Status as	TicketStatus,	TAT.RequestEmail as 	RequestEmail,	TAT.Priority as 	TicketPriority,	TAT.`Type` as 	TicketType,	TAT.`Group` as 	TicketGroup,	TAT.`Description` as TicketDescription,created_by,ApiCreatedDate as created_at,ApiUpdateDate as updated_at from `tblHelpDeskTickets` TAT where (TAT.`CompanyID` = p_CompanyID and TAT.`ContactID` = p_ContactID and TAT.GUID = p_GUID);
	END IF;

	IF p_TicketType=1 /*SYSTEM TICKETS*/
	THEN
	INSERT INTO tmp_actvity_timeline_
		select 4 as Timeline_type, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID, 0 as NoteID,'' as Note,
		TT.TicketID,TT.Subject as 	TicketSubject,	TFV.FieldValueAgent  as	TicketStatus,	TT.Requester as 	RequestEmail,TP.PriorityValue as TicketPriority,	TFVV.FieldValueAgent as 	TicketType,	TG.GroupName as TicketGroup,	TT.`Description` as TicketDescription,TT.created_by,TT.created_at,TT.updated_at
	from
		`tblTickets` TT
	LEFT JOIN tblTicketfieldsValues TFV
		ON TFV.ValuesID = TT.Status
	LEFT JOIN tblTicketPriority TP
		ON TP.PriorityID = TT.Priority
	LEFT JOIN tblTicketGroups TG
		ON TG.GroupID = TT.`Group`
	LEFT JOIN tblTicketfieldsValues TFVV
		ON TFVV.ValuesID = TT.Type
	LEFT JOIN tblContact TC
		ON TC.Email = TT.Requester
	where
		(TT.`CompanyID` = p_CompanyID and TC.`ContactID` = p_ContactID);
	END IF;

	select * from tmp_actvity_timeline_ order by created_at desc LIMIT p_RowspPage OFFSET v_OffSet_ ;
END//
DELIMITER ;
-- ##########################################################
INSERT INTO `tblEmailTemplate` (`CompanyID`, `TemplateName`, `Subject`, `TemplateBody`, `created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`, `userID`, `Type`, `EmailFrom`, `StaticType`, `SystemType`, `Status`, `StatusDisabled`) VALUES (1, 'Invoice Send', 'New Invoice {{InvoiceNumber}} from {{CompanyName}} ', 'Hi {{AccountName}}<br><br>\r\n\r\n\r\n{{CompanyName}} has sent you an invoice of {{InvoiceGrandTotal}} {{Currency}}, \r\nto download copy of your invoice please click the below link.&nbsp;<br><br>\r\n\r\n\r\n<div><a href="{{InvoiceLink}}" style="background-color:#ff9600;border:1px solid #ff9600;border-radius:4px;color:#ffffff;display:inline-block;font-family:sans-serif;font-size:13px;font-weight:bold;line-height:30px;text-align:center;text-decoration:none;width:100px;-webkit-text-size-adjust:none;mso-hide:all;" title="Link: {{InvoiceLink}}">View</a></div>\r\n<br><br>{{InvoiceOutstanding}} &nbsp;{{InvoiceNumber}} &nbsp;{{InvoiceGrandTotal}}{{Signature}}<br><br>\r\n\r\n\r\n\r\nBest Regards,<br><br>\r\n\r\n\r\n{{CompanyName}}<br>', '2017-02-13 10:28:29', '', '2017-03-01 16:18:58', '', NULL, 2, 'abc@email.com', 1, 'InvoiceSingleSend', 1, 1);
INSERT INTO `tblEmailTemplate` (`CompanyID`, `TemplateName`, `Subject`, `TemplateBody`, `created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`, `userID`, `Type`, `EmailFrom`, `StaticType`, `SystemType`, `Status`, `StatusDisabled`) VALUES (1, 'Estimate Send', 'New estimate {{EstimateNumber}} from {{CompanyName}} ', 'Hi {{AccountName}},<br><br>\r\n\r\n\r\n{{CompanyName}} has sent you an estimate of {{EstimateGrandTotal}} {{Currency}}, \r\nto download copy of your estimate please click the below link. <br><br>\r\n\r\n\r\n<div><a href="{{EstimateLink}}" style="background-color:#ff9600;border:2px solid #ff9600;border-radius:4px;color:#ffffff;display:inline-block;font-family:sans-serif;font-size:13px;font-weight:bold;line-height:30px;text-align:center;text-decoration:none;width:100px;-webkit-text-size-adjust:none;mso-hide:all;" title="Link: {{EstimateLink}}">View Estimate</a></div>\r\n<br><br>{{Comment}} &nbsp;<br><br>\r\n\r\n\r\n\r\nBest Regards,<br><br>\r\n\r\n\r\n{{CompanyName}}\r\n<br>{{CompanyAddress1}}<br>{{CompanyAddress2}}<br>{{CompanyAddress3}}<br>{{CompanyVAT}}<br>{{CompanyCountry}}<br>', '2017-02-13 10:28:29', '', '2017-03-01 16:19:12', '', NULL, 5, 'abc@email.com', 1, 'EstimateSingleSend', 1, 1);
INSERT INTO `tblEmailTemplate` (`CompanyID`, `TemplateName`, `Subject`, `TemplateBody`, `created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`, `userID`, `Type`, `EmailFrom`, `StaticType`, `SystemType`, `Status`, `StatusDisabled`) VALUES (1, 'New Comment on Estimate', 'New Comment added to Estimate {{EstimateNumber}}', 'Dear {{AccountName}},<br><br>\r\n\r\nComment added to Estimate {{EstimateNumber}}<br>\r\n{{Comment}}<br><br>\r\n\r\n\r\nBest Regards,<br><br>\r\n\r\n{{CompanyName}}<br>', '2017-02-13 10:28:29', '', '2017-03-01 16:18:45', '', NULL, 5, 'abc@email.com', 1, 'EstimateSingleComment', 1, 0);
INSERT INTO `tblEmailTemplate` (`CompanyID`, `TemplateName`, `Subject`, `TemplateBody`, `created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`, `userID`, `Type`, `EmailFrom`, `StaticType`, `SystemType`, `Status`, `StatusDisabled`) VALUES (1, 'New Comment on Task', 'New Comment by {{User}} on Task', '<meta charset="utf-8">\r\n    <meta name="viewport" content="width=device-width">\r\n    <title>Commit</title>\r\n\r\n\r\n<table style="vertical-align: top; border-collapse: collapse; padding-bottom: 0px; padding-top: 0px; padding-left: 0px; border-spacing: 0; padding-right: 0px; width: 95%; background-color: #f0f0f0" align="center">\r\n    <tbody>\r\n    <tr style="vertical-align: top; padding-bottom: 0px; text-align: center; padding-top: 0px; padding-left: 0px; padding-right: 0px">\r\n        <td style="vertical-align: top; padding-bottom: 0px; text-align: center; padding-top: 0px; padding-left: 0px; padding-right: 0px"><img src="{{Logo}}" title="Image: {{Logo}}" width="" border="0"></td>\r\n    </tr>\r\n    </tbody>\r\n</table>\r\n<br>{{FirstName}}&nbsp;{{LastName}}{{Address1}}{{Address2}}{{Address3}}{{PostCode}}<br><br><br>{{subject}}&nbsp;{{user}} {{Comment}} {{Logo}} &nbsp;{{CompanyCountry}}<br><br><br><table style="vertical-align: top; border-collapse: collapse; padding-bottom: 0px; padding-top: 0px; padding-left: 0px; border-spacing: 0; padding-right: 0px; width: 95%; background-color: #f0f0f0" align="center">\r\n    <tbody>\r\n    <tr style="vertical-align: top; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; padding-right: 0px">\r\n        <td width="5%"></td>\r\n        <td style="font-size: 14px; font-family: \'helvetica\', \'arial\', sans-serif; vertical-align: top; border-collapse: collapse; font-weight: normal; color: #4d4d4d; padding-bottom: 16px; text-align: center; padding-top: 16px; padding-left: 0px; margin: 0px; line-height: 19px; padding-right: 0px; -moz-hyphens: auto; -webkit-hyphens: auto; hyphens: auto" width="90%">\r\n            <div style="width: 90%; padding-bottom: 12px; padding-top: 12px; padding-left: 16px; margin: 0px auto; display: block; padding-right: 16px">\r\n                <h6 style="font-size: 20px; font-family: \'helvetica\', \'arial\', sans-serif; word-break: normal; font-weight: normal; color: #4d4d4d; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; margin: 0px 0px 12px; line-height: 1.3; padding-right: 0px">Update\r\n                </h6>\r\n                <table class="phenom" style="vertical-align: top; border-collapse: collapse; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; margin: 12px 0px; border-spacing: 0; padding-right: 0px" width="100%">\r\n                    <tbody>\r\n                    <tr style="vertical-align: top; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; padding-right: 0px">\r\n                        <td class="phenom-details" style="font-size: 14px; font-family: \'helvetica\', \'arial\', sans-serif; vertical-align: top; border-collapse: collapse; font-weight: normal; color: #4d4d4d; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; margin: 0px; line-height: 19px; padding-right: 0px; -moz-hyphens: auto; -webkit-hyphens: auto; hyphens: auto">\r\n                            <div style="float: left;clear:left;">\r\n                                <strong>{{User}}</strong> Commented on {{subject}}\r\n                                <p style="font-size: 14px; font-family: \'helvetica\', \'arial\', sans-serif; font-weight: normal; color: #4d4d4d; text-align: left; margin: 0px 0px 10px; line-height: 19px; padding: 10px;background-color:#ffffff;border-color: #d6cfcf;border-radius: 10px;border-style: solid;border-width: 1px 3px 3px 1px;margin: 5px;max-width: 95%;padding: 5px;">\r\n                                    {{Comment}}\r\n                                </p>\r\n                            </div>\r\n                        </td>\r\n                    </tr>\r\n                    </tbody>\r\n                </table>\r\n            </div>\r\n        </td>\r\n        <td width="5%"></td>\r\n    </tr>\r\n    </tbody>\r\n</table>', '2017-02-13 10:28:29', '', '2017-03-01 16:18:00', '', NULL, 8, 'abc@email.com', 1, 'TaskCommentEmail', 1, 0);
INSERT INTO `tblEmailTemplate` (`CompanyID`, `TemplateName`, `Subject`, `TemplateBody`, `created_at`, `CreatedBy`, `updated_at`, `ModifiedBy`, `userID`, `Type`, `EmailFrom`, `StaticType`, `SystemType`, `Status`, `StatusDisabled`) VALUES (1, 'New Comment on Opportunity', 'New Comment by {{User}} on Opportunity', '<meta charset="utf-8">\r\n    <meta name="viewport" content="width=device-width">\r\n    <title>Commit</title>\r\n\r\n\r\n{{FirstName}} {{subject}} {{user}} &nbsp;{{CompanyName}} &nbsp;{{CompanyVAT}} {{CompanyCountry}} &nbsp;&nbsp;{{Address3}}<br><br><br>{{Logo}}<br><table style="vertical-align: top; border-collapse: collapse; padding-bottom: 0px; padding-top: 0px; padding-left: 0px; border-spacing: 0; padding-right: 0px; width: 95%; background-color: #f0f0f0" align="center">\r\n    <tbody>\r\n    <tr style="vertical-align: top; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; padding-right: 0px">\r\n        <td width="5%"></td>\r\n        <td style="font-size: 14px; font-family: \'helvetica\', \'arial\', sans-serif; vertical-align: top; border-collapse: collapse; font-weight: normal; color: #4d4d4d; padding-bottom: 16px; text-align: center; padding-top: 16px; padding-left: 0px; margin: 0px; line-height: 19px; padding-right: 0px; -moz-hyphens: auto; -webkit-hyphens: auto; hyphens: auto" width="90%">\r\n            <div style="width: 90%; padding-bottom: 12px; padding-top: 12px; padding-left: 16px; margin: 0px auto; display: block; padding-right: 16px">\r\n                <h6 style="font-size: 20px; font-family: \'helvetica\', \'arial\', sans-serif; word-break: normal; font-weight: normal; color: #4d4d4d; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; margin: 0px 0px 12px; line-height: 1.3; padding-right: 0px">Update\r\n                </h6>\r\n                <table class="phenom" style="vertical-align: top; border-collapse: collapse; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; margin: 12px 0px; border-spacing: 0; padding-right: 0px" width="100%">\r\n                    <tbody>\r\n                    <tr style="vertical-align: top; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; padding-right: 0px">\r\n                        <td class="phenom-details" style="font-size: 14px; font-family: \'helvetica\', \'arial\', sans-serif; vertical-align: top; border-collapse: collapse; font-weight: normal; color: #4d4d4d; padding-bottom: 0px; text-align: left; padding-top: 0px; padding-left: 0px; margin: 0px; line-height: 19px; padding-right: 0px; -moz-hyphens: auto; -webkit-hyphens: auto; hyphens: auto">\r\n                            <div style="float: left;clear:left;">\r\n                                <strong>{{User}}</strong> Commented on {{subject}}\r\n                                <p style="font-size: 14px; font-family: \'helvetica\', \'arial\', sans-serif; font-weight: normal; color: #4d4d4d; text-align: left; margin: 0px 0px 10px; line-height: 19px; padding: 10px;background-color:#ffffff;border-color: #d6cfcf;border-radius: 10px;border-style: solid;border-width: 1px 3px 3px 1px;margin: 5px;max-width: 95%;padding: 5px;">\r\n                                    {{Comment}}\r\n                                </p>\r\n                            </div>\r\n                        </td>\r\n                    </tr>\r\n                    </tbody>\r\n                </table>\r\n            </div>\r\n        </td>\r\n        <td width="5%"></td>\r\n    </tr>\r\n    </tbody>\r\n</table>', '2017-02-13 10:28:29', '', '2017-03-01 16:18:14', '', NULL, 9, 'abc@email.com', 1, 'OpportunityCommentEmail', 1, 0);
-- ###########################################################
update tblEmailTemplate set EmailFrom = (select Email from tblCompany);
-- ###########################################################


-- Billing3

-- Abubakar

USE `RMBilling3`;

ALTER TABLE `tblInvoice`
	ADD COLUMN `RecurringInvoiceID` INT(50) NULL DEFAULT NULL AFTER `EstimateID`,
	ADD COLUMN `ProcessID` VARCHAR(50) NULL DEFAULT NULL AFTER `RecurringInvoiceID`;


-- Dumping structure for function RMBilling3.FnGetInvoiceNumber
DROP FUNCTION IF EXISTS `FnGetInvoiceNumber`;
DELIMITER //
CREATE  FUNCTION `FnGetInvoiceNumber`(
	`p_account_id` INT,
	`p_BillingClassID` INT

) RETURNS int(11)
    NO SQL
    DETERMINISTIC
    COMMENT 'Return Next Invoice Number'
BEGIN
DECLARE v_LastInv VARCHAR(50);
DECLARE v_FoundVal INT(11);
DECLARE v_InvoiceTemplateID INT(11);

SET v_InvoiceTemplateID = CASE WHEN p_BillingClassID=0 THEN (SELECT b.InvoiceTemplateID FROM Ratemanagement3.tblAccountBilling ab INNER JOIN Ratemanagement3.tblBillingClass b ON b.BillingClassID = ab.BillingClassID WHERE AccountID = p_account_id) ELSE (SELECT b.InvoiceTemplateID FROM  Ratemanagement3.tblBillingClass b WHERE b.BillingClassID = p_BillingClassID) END;

SELECT LastInvoiceNumber INTO v_LastInv FROM tblInvoiceTemplate WHERE InvoiceTemplateID =v_InvoiceTemplateID;

set v_FoundVal = (select count(*) as total_res from tblInvoice where FnGetIntegerString(InvoiceNumber)=v_LastInv);
IF v_FoundVal>=1 then
WHILE v_FoundVal>0 DO
	set v_LastInv = v_LastInv+1;
	set v_FoundVal = (select count(*) as total_res from tblInvoice where FnGetIntegerString(InvoiceNumber)=v_LastInv);
END WHILE;
END IF;

return v_LastInv;
END//
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_Convert_Invoices_to_Estimates
DROP PROCEDURE IF EXISTS `prc_Convert_Invoices_to_Estimates`;
DELIMITER //
CREATE  PROCEDURE `prc_Convert_Invoices_to_Estimates`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` VARCHAR(50),
	IN `p_EstimateNumber` VARCHAR(50),
	IN `p_IssueDateStart` DATETIME,
	IN `p_IssueDateEnd` DATETIME,
	IN `p_EstimateStatus` VARCHAR(50),
	IN `p_EstimateID` VARCHAR(50),
	IN `p_convert_all` INT



)
    COMMENT 'test'
BEGIN
	DECLARE estimate_ids int;
	DECLARE note_text varchar(50);
 	SET sql_mode = 'ALLOW_INVALID_DATES';
	set note_text = 'Created From Estimate: ';

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
update tblInvoice  set EstimateID = '';
INSERT INTO tblInvoice (`CompanyID`, `AccountID`, `Address`, `InvoiceNumber`, `IssueDate`, `CurrencyID`, `PONumber`, `InvoiceType`, `SubTotal`, `TotalDiscount`, `TaxRateID`, `TotalTax`, `InvoiceTotal`, `GrandTotal`, `Description`, `Attachment`, `Note`, `Terms`, `InvoiceStatus`, `PDF`, `UsagePath`, `PreviousBalance`, `TotalDue`, `Payment`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `ItemInvoice`, `FooterTerm`,EstimateID)
 	select te.CompanyID,
	 		 te.AccountID,
			 te.Address,
			 FNGetInvoiceNumber(te.AccountID,0) as InvoiceNumber,
			 DATE(NOW()) as IssueDate,
			 te.CurrencyID,
			 te.PONumber,
			 1 as InvoiceType,
			 te.SubTotal,
			 te.TotalDiscount,
			 te.TaxRateID,
			 te.TotalTax,
			 te.EstimateTotal,
			 te.GrandTotal,
			 te.Description,
			 te.Attachment,
			 te.Note,
			 te.Terms,
			 'awaiting' as InvoiceStatus,
			 te.PDF,
			 '' as UsagePath,
			 0 as PreviousBalance,
			 0 as TotalDue,
			 0 as Payment,
			 te.CreatedBy,
			 '' as ModifiedBy,
			NOW() as created_at,
			NOW() as updated_at,
			1 as ItemInvoice,
			te.FooterTerm,
			te.EstimateID
			from tblEstimate te
			where
			(p_convert_all=0 and te.EstimateID = p_EstimateID)
			OR
			(p_EstimateID = '' and p_convert_all =1 and (te.CompanyID = p_CompanyID)
			AND (p_AccountID = '' OR ( p_AccountID != '' AND te.AccountID = p_AccountID))
			AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND te.EstimateNumber = p_EstimateNumber))
			AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND te.IssueDate >= p_IssueDateStart))
			AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND te.IssueDate <= p_IssueDateEnd))
			AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND te.EstimateStatus = p_EstimateStatus)) );


 select 	InvoiceID from tblInvoice inv
INNER JOIN tblEstimate ti ON  inv.EstimateID =  ti.EstimateID
where (p_convert_all=0 and ti.EstimateID = p_EstimateID)
		OR
		(p_EstimateID = '' and p_convert_all =1 and (ti.CompanyID = p_CompanyID)
			AND (p_AccountID = '' OR ( p_AccountID != '' AND ti.AccountID = p_AccountID))
			AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND ti.EstimateNumber = p_EstimateNumber))
			AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND ti.IssueDate >= p_IssueDateStart))
			AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND ti.IssueDate <= p_IssueDateEnd))
			AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND ti.EstimateStatus = p_EstimateStatus)) );

		INSERT INTO tblInvoiceDetail ( `InvoiceID`, `ProductID`, `Description`, `StartDate`, `EndDate`, `Price`, `Qty`, `Discount`, `TaxRateID`,`TaxRateID2`, `TaxAmount`, `LineTotal`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `ProductType`)
			select
				inv.InvoiceID,
				ted.ProductID,
				ted.Description,
				'' as StartDate,
				'' as EndDate,
				ted.Price,
				ted.Qty,
				ted.Discount,
				ted.TaxRateID,
				ted.TaxRateID2,
				ted.TaxAmount,
				ted.LineTotal,
				ted.CreatedBy,
				ted.ModifiedBy,
				ted.created_at,
				NOW() as updated_at,
				ted.ProductType
from tblEstimateDetail ted
INNER JOIN tblInvoice inv ON  inv.EstimateID = ted.EstimateID
INNER JOIN tblEstimate ti ON  ti.EstimateID = ted.EstimateID
where
		 (p_convert_all=0 and ti.EstimateID = p_EstimateID)
		OR	(p_EstimateID = '' and p_convert_all =1 and (ti.CompanyID = p_CompanyID)
			AND (p_AccountID = '' OR ( p_AccountID != '' AND ti.AccountID = p_AccountID))
			AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND ti.EstimateNumber = p_EstimateNumber))
			AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND ti.IssueDate >= p_IssueDateStart))
			AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND ti.IssueDate <= p_IssueDateEnd))
			AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND ti.EstimateStatus = p_EstimateStatus)));

	INSERT INTO tblInvoiceTaxRate ( `InvoiceID`, `TaxRateID`, `TaxAmount`,`InvoiceTaxType`,`Title`, `CreatedBy`,`ModifiedBy`)
	SELECT
		inv.InvoiceID,
		ted.TaxRateID,
		ted.TaxAmount,
		ted.EstimateTaxType,
		ted.Title,
		ted.CreatedBy,
		ted.ModifiedBy
	FROM tblEstimateTaxRate ted
	INNER JOIN tblInvoice inv ON  inv.EstimateID = ted.EstimateID
	INNER JOIN tblEstimate ti ON  ti.EstimateID = ted.EstimateID
	WHERE	(p_convert_all=0 and ti.EstimateID = p_EstimateID)
		OR	(
			p_EstimateID = '' and p_convert_all =1 and (ti.CompanyID = p_CompanyID)
			AND (p_AccountID = '' OR ( p_AccountID != '' AND ti.AccountID = p_AccountID))
			AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND ti.EstimateNumber = p_EstimateNumber))
			AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND ti.IssueDate >= p_IssueDateStart))
			AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND ti.IssueDate <= p_IssueDateEnd))
			AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND ti.EstimateStatus = p_EstimateStatus))
		);

insert into tblInvoiceLog (InvoiceID,Note,InvoiceLogStatus,created_at)
select inv.InvoiceID,concat(note_text, CONCAT(LTRIM(RTRIM(IFNULL(it.EstimateNumberPrefix,''))), LTRIM(RTRIM(ti.EstimateNumber)))) as Note,1 as InvoiceLogStatus,NOW() as created_at  from tblInvoice inv
INNER JOIN tblEstimate ti ON  inv.EstimateID =  ti.EstimateID
INNER JOIN Ratemanagement3.tblAccount ac ON ac.AccountID = inv.AccountID
INNER JOIN Ratemanagement3.tblAccountBilling ab ON ab.AccountID = ac.AccountID
INNER JOIN Ratemanagement3.tblBillingClass b ON ab.BillingClassID = b.BillingClassID
LEFT JOIN tblInvoiceTemplate it on b.InvoiceTemplateID = it.InvoiceTemplateID
where
			(p_convert_all=0 and ti.EstimateID = p_EstimateID)
		OR	(p_EstimateID = '' and p_convert_all =1 and (ti.CompanyID = p_CompanyID)
			AND (p_AccountID = '' OR ( p_AccountID != '' AND ti.AccountID = p_AccountID))
			AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND ti.EstimateNumber = p_EstimateNumber))
			AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND ti.IssueDate >= p_IssueDateStart))
			AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND ti.IssueDate <= p_IssueDateEnd))
			AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND ti.EstimateStatus = p_EstimateStatus)));


update tblEstimate te set te.EstimateStatus='accepted'
where
			(p_convert_all=0 and te.EstimateID = p_EstimateID)
			OR
			(p_EstimateID = '' and p_convert_all =1 and (te.CompanyID = p_CompanyID)
			AND (p_AccountID = '' OR ( p_AccountID != '' AND te.AccountID = p_AccountID))
			AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND te.EstimateNumber = p_EstimateNumber))
			AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND te.IssueDate >= p_IssueDateStart))
			AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND te.IssueDate <= p_IssueDateEnd))
			AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND te.EstimateStatus = p_EstimateStatus)));

	UPDATE tblInvoice
	INNER JOIN tblEstimate ON  tblInvoice.EstimateID =  tblEstimate.EstimateID
	INNER JOIN Ratemanagement3.tblAccount ON tblAccount.AccountID = tblInvoice.AccountID
	INNER JOIN Ratemanagement3.tblAccountBilling ON tblAccount.AccountID = tblAccountBilling.AccountID
	INNER JOIN Ratemanagement3.tblBillingClass ON tblAccountBilling.BillingClassID = tblBillingClass.BillingClassID
	INNER JOIN tblInvoiceTemplate ON tblBillingClass.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID
	SET FullInvoiceNumber = IF(InvoiceType=1,CONCAT(ltrim(rtrim(IFNULL(tblInvoiceTemplate.InvoiceNumberPrefix,''))), ltrim(rtrim(tblInvoice.InvoiceNumber))),ltrim(rtrim(tblInvoice.InvoiceNumber)))
	WHERE FullInvoiceNumber IS NULL AND tblInvoice.CompanyID = p_CompanyID AND tblInvoice.InvoiceType = 1;

				SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END//
DELIMITER ;

-- Dev

Use `RMBilling3`;

DROP PROCEDURE IF EXISTS `prc_getSOA`;
DELIMITER ;;
CREATE  PROCEDURE `prc_getSOA`(
	IN `p_CompanyID` INT,
	IN `p_accountID` INT,
	IN `p_StartDate` datetime,
	IN `p_EndDate` datetime,
	IN `p_isExport` INT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN


    	-- Broght forward - to find balance offset before given range ( if start date = 24/02/2017  - balance offset before 24/02/2017  ).
    DECLARE v_start_date DATETIME ;
	DECLARE v_bf_InvoiceOutAmountTotal NUMERIC(18, 8);
	DECLARE v_bf_PaymentInAmountTotal NUMERIC(18, 8);
	DECLARE v_bf_InvoiceInAmountTotal NUMERIC(18, 8);
	DECLARE v_bf_PaymentOutAmountTotal NUMERIC(18, 8);


    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
     SET SESSION sql_mode='';


   DROP TEMPORARY TABLE IF EXISTS tmp_Invoices;
    CREATE TEMPORARY TABLE tmp_Invoices (
        InvoiceNo VARCHAR(50),
        PeriodCover VARCHAR(50),
        IssueDate Datetime,
        Amount NUMERIC(18, 8),
        InvoiceType int,
        AccountID int,
        InvoiceID INT
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_Invoices_broghtf;
    CREATE TEMPORARY TABLE tmp_Invoices_broghtf (
        Amount NUMERIC(18, 8),
        InvoiceType int
    );


    DROP TEMPORARY TABLE IF EXISTS tmp_Payments;
    CREATE TEMPORARY TABLE tmp_Payments (
        InvoiceNo VARCHAR(50),
        PaymentDate VARCHAR(50),
        IssueDate datetime,
        Amount NUMERIC(18, 8),
        PaymentID INT,
        PaymentType VARCHAR(50),
        InvoiceID INT
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_Payments_broghtf;
    CREATE TEMPORARY TABLE tmp_Payments_broghtf (
        Amount NUMERIC(18, 8),
        PaymentType VARCHAR(50)
    );


    DROP TEMPORARY TABLE IF EXISTS tmp_Disputes;
    CREATE TEMPORARY TABLE tmp_Disputes (
        InvoiceNo VARCHAR(50),
        created_at datetime,
        DisputeAmount NUMERIC(18, 8),
        InvoiceType VARCHAR(50),
        DisputeID INT,
        AccountID INT,
        InvoiceID INT

    );

  DROP TEMPORARY TABLE IF EXISTS tmp_InvoiceOutWithDisputes;
   CREATE TEMPORARY TABLE tmp_InvoiceOutWithDisputes (
        InvoiceOut_InvoiceNo VARCHAR(50),
        InvoiceOut_PeriodCover VARCHAR(50),
        InvoiceOut_IssueDate datetime,
        InvoiceOut_Amount NUMERIC(18, 8),
        InvoiceOut_DisputeAmount NUMERIC(18, 8),
        InvoiceOut_DisputeID INT,
       InvoiceOut_AccountID INT,
       InvoiceOut_InvoiceID INT
    );

  DROP TEMPORARY TABLE IF EXISTS tmp_InvoiceInWithDisputes;
   CREATE TEMPORARY TABLE tmp_InvoiceInWithDisputes (
        InvoiceIn_InvoiceNo VARCHAR(50),
        InvoiceIn_PeriodCover VARCHAR(50),
        InvoiceIn_IssueDate datetime,
        InvoiceIn_Amount NUMERIC(18, 8),
        InvoiceIn_DisputeAmount NUMERIC(18, 8),
        InvoiceIn_DisputeID INT,
        InvoiceIn_AccountID INT,
        InvoiceIn_InvoiceID INT
    );



/*
      New Logic

      -- 1  Invoice In/Out into tmp
      -- 2  Invoice in/out for balance brought forward into tmp
      -- 3  Payment In/Out  into tmp
      -- 4  Payment in/out for balance brought forward into tmp
      -- 5  Unresolved desputes ( Status = 0) into tmp
      -- 6  Invoice Out With Disputes  into tmp
      -- 7  SELECT Invoice Out with Disputes and Payments
      -- 8  Invoice In With Disputes into tmp
      -- 9  SELECT Invoice In With Disputes and Payments
      -- 10 SELECT Total Invoice Sent Amount
      -- 11 SELECT Total Invoice Out Dispute Amount
      -- 12 SELECT Total Payment In Amount
      -- 13 SELECT Total Invoice In Amount
      -- 14 SELECT Total Invoice In Dispute Amount
      -- 15 SELECT Total Payment Out Amount
      -- 16 SELECT Bought forward Total Invoice Out Amount
      -- 17 SELECT Bought forward Total Payment In Amount
      -- 18 SELECT Bought forward Total Invoice In Amount
      -- 19 SELECT Bought forward Total Payment Out Amount
    */


    INSERT into tmp_Invoices
    SELECT
      DISTINCT
         tblInvoice.InvoiceNumber,
         CASE
          WHEN (tblInvoice.ItemInvoice = 1 ) THEN
                DATE_FORMAT(tblInvoice.IssueDate,'%d/%m/%Y')
        WHEN (tblInvoice.ItemInvoice IS NUll AND p_isExport = 0 ) THEN
          Concat(DATE_FORMAT(tblInvoiceDetail.StartDate,'%d/%m/%Y') ,'<br>' , DATE_FORMAT(tblInvoiceDetail.EndDate,'%d/%m/%Y'))
        WHEN (tblInvoice.ItemInvoice IS NUll AND p_isExport = 1) THEN
          (select Concat(DATE_FORMAT(tblInvoiceDetail.StartDate,'%d/%m/%Y') ,'-' , DATE_FORMAT(tblInvoiceDetail.EndDate,'%d/%m/%Y')) from tblInvoiceDetail where tblInvoiceDetail.InvoiceID= tblInvoice.InvoiceID order by InvoiceDetailID  limit 1)
       END AS PeriodCover,
         tblInvoice.IssueDate,
         tblInvoice.GrandTotal,
         tblInvoice.InvoiceType,
        tblInvoice.AccountID,
        tblInvoice.InvoiceID
        FROM tblInvoice
        LEFT JOIN tblInvoiceDetail
		  ON tblInvoice.InvoiceID = tblInvoiceDetail.InvoiceID AND ( (tblInvoice.InvoiceType = 1 AND tblInvoiceDetail.ProductType = 2 ) OR  tblInvoice.InvoiceType =2 )
        WHERE tblInvoice.CompanyID = p_CompanyID
        AND tblInvoice.AccountID = p_accountID
        AND ( (tblInvoice.InvoiceType = 2) OR ( tblInvoice.InvoiceType = 1 AND tblInvoice.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'awaiting') )  )
        AND (p_StartDate = '0000-00-00' OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(tblInvoice.IssueDate,'%Y-%m-%d') >= p_StartDate ) )
      AND (p_EndDate   = '0000-00-00' OR  (p_EndDate   != '0000-00-00' AND  DATE_FORMAT(tblInvoice.IssueDate,'%Y-%m-%d') <= p_EndDate ) )
      AND tblInvoice.GrandTotal != 0
      Order by tblInvoice.IssueDate asc;

	IF ( p_StartDate = '0000-00-00' ) THEN
		  SELECT min(IssueDate) into  v_start_date from tmp_Invoices;
	END IF;

	-- Balance Broght forward
        INSERT into tmp_Invoices_broghtf
      SELECT
		GrandTotal ,
		InvoiceType
		FROM (

		SELECT
		 DISTINCT
         tblInvoice.InvoiceNumber,
         CASE
          WHEN (tblInvoice.ItemInvoice = 1 ) THEN
                DATE_FORMAT(tblInvoice.IssueDate,'%d/%m/%Y')
        WHEN (tblInvoice.ItemInvoice IS NUll AND p_isExport = 0 ) THEN
          Concat(DATE_FORMAT(tblInvoiceDetail.StartDate,'%d/%m/%Y') ,'<br>' , DATE_FORMAT(tblInvoiceDetail.EndDate,'%d/%m/%Y'))
        WHEN (tblInvoice.ItemInvoice IS NUll AND p_isExport = 1) THEN
          (select Concat(DATE_FORMAT(tblInvoiceDetail.StartDate,'%d/%m/%Y') ,'-' , DATE_FORMAT(tblInvoiceDetail.EndDate,'%d/%m/%Y')) from tblInvoiceDetail where tblInvoiceDetail.InvoiceID= tblInvoice.InvoiceID order by InvoiceDetailID  limit 1)
       END AS PeriodCover,
         tblInvoice.IssueDate,
         tblInvoice.GrandTotal,
         tblInvoice.InvoiceType,
        tblInvoice.AccountID,
        tblInvoice.InvoiceID
        FROM tblInvoice
        LEFT JOIN tblInvoiceDetail
		  ON tblInvoice.InvoiceID = tblInvoiceDetail.InvoiceID AND ( (tblInvoice.InvoiceType = 1 AND tblInvoiceDetail.ProductType = 2 ) OR  tblInvoice.InvoiceType =2 )
        WHERE tblInvoice.CompanyID = p_CompanyID
        AND tblInvoice.AccountID = p_accountID
        AND ( (tblInvoice.InvoiceType = 2) OR ( tblInvoice.InvoiceType = 1 AND tblInvoice.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'awaiting') )  )
        AND ( (p_StartDate = '0000-00-00' AND  DATE_FORMAT(tblInvoice.IssueDate,'%Y-%m-%d') < v_start_date ) OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(tblInvoice.IssueDate,'%Y-%m-%d') < p_StartDate ) )
        AND tblInvoice.GrandTotal != 0
      Order by tblInvoice.IssueDate asc
		) t;



     INSERT into tmp_Payments
       SELECT
        DISTINCT
            tblPayment.InvoiceNo,
            DATE_FORMAT(tblPayment.PaymentDate, '%d/%m/%Y') AS PaymentDate,
            tblPayment.PaymentDate as IssueDate,
            tblPayment.Amount,
            tblPayment.PaymentID,
            tblPayment.PaymentType,
            tblPayment.InvoiceID
        FROM tblPayment
        WHERE
            tblPayment.CompanyID = p_CompanyID
      AND tblPayment.AccountID = p_accountID
      AND tblPayment.Status = 'Approved'
        AND tblPayment.Recall = 0
      AND (p_StartDate = '0000-00-00' OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(tblPayment.PaymentDate,'%Y-%m-%d') >= p_StartDate ) )
      AND (p_EndDate   = '0000-00-00' OR  (p_EndDate   != '0000-00-00' AND  DATE_FORMAT(tblPayment.PaymentDate,'%Y-%m-%d') <= p_EndDate ) )
    Order by tblPayment.PaymentDate desc;


	-- Balance Broght forward
    INSERT into tmp_Payments_broghtf
    	SELECT
    	Amount,
    	PaymentType
    	FROM (
       SELECT
         DISTINCT
           tblPayment.InvoiceNo,
            DATE_FORMAT(tblPayment.PaymentDate, '%d/%m/%Y') AS PaymentDate,
            tblPayment.PaymentDate as IssueDate,
            tblPayment.Amount,
            tblPayment.PaymentID,
            tblPayment.PaymentType,
            tblPayment.InvoiceID
        FROM tblPayment
        WHERE
            tblPayment.CompanyID = p_CompanyID
      AND tblPayment.AccountID = p_accountID
      AND tblPayment.Status = 'Approved'
        AND tblPayment.Recall = 0
      AND ( ( p_StartDate = '0000-00-00' AND DATE_FORMAT(tblPayment.PaymentDate,'%Y-%m-%d') < v_start_date )  OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(tblPayment.PaymentDate,'%Y-%m-%d') < p_StartDate ) )
    Order by tblPayment.PaymentDate desc
	 ) t;


     INSERT INTO tmp_Disputes
       SELECT
            InvoiceNo,
        created_at,
            DisputeAmount,
            InvoiceType,
            DisputeID,
            AccountID,
            0 as InvoiceID
      FROM tblDispute
        WHERE
            CompanyID = p_CompanyID
      AND AccountID = p_accountID
      AND Status = 0
      AND (p_StartDate = '0000-00-00' OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(created_at,'%Y-%m-%d') >= p_StartDate ) )
      AND (p_EndDate   = '0000-00-00' OR  (p_EndDate   != '0000-00-00' AND  DATE_FORMAT(created_at,'%Y-%m-%d') <= p_EndDate ) )
      order by created_at;

        DROP TEMPORARY TABLE IF EXISTS tmp_Invoices_dup;
        DROP TEMPORARY TABLE IF EXISTS tmp_Disputes_dup;
        DROP TEMPORARY TABLE IF EXISTS tmp_Payments_dup;


     CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Invoices_dup AS (SELECT * FROM tmp_Invoices);
     CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Disputes_dup AS (SELECT * FROM tmp_Disputes);
     CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Payments_dup AS (SELECT * FROM tmp_Payments);


    INSERT INTO tmp_InvoiceOutWithDisputes
      SELECT
    InvoiceNo as InvoiceOut_InvoiceNo,
    PeriodCover as InvoiceOut_PeriodCover,
    IssueDate as InvoiceOut_IssueDate,
    Amount as InvoiceOut_Amount,
    ifnull(DisputeAmount,0) as InvoiceOut_DisputeAmount,
    DisputeID as InvoiceOut_DisputeID,
    AccountID as InvoiceOut_AccountID,
    InvoiceID as InvoiceOut_InvoiceID

    FROM
     (
      SELECT
      		DISTINCT
            iv.InvoiceNo,
            iv.PeriodCover,
            iv.IssueDate,
            iv.Amount,
            ds.DisputeAmount,
            ds.DisputeID,
       	   iv.AccountID,
       	   iv.InvoiceID

        FROM tmp_Invoices iv
      LEFT JOIN tmp_Disputes ds on ds.InvoiceNo = iv.InvoiceNo AND ds.InvoiceType = iv.InvoiceType  AND ds.InvoiceNo is not null
        WHERE
        iv.InvoiceType = 1


     UNION ALL

     SELECT
        DISTINCT
            ds.InvoiceNo,
            DATE_FORMAT(ds.created_at, '%d/%m/%Y') as PeriodCover,
            ds.created_at as IssueDate,
            0 as Amount,
            ds.DisputeAmount,
            ds.DisputeID,
        ds.AccountID,
        iv.InvoiceID
      FROM tmp_Disputes_dup ds
      LEFT JOIN  tmp_Invoices_dup iv on ds.InvoiceNo = iv.InvoiceNo and iv.InvoiceType = ds.InvoiceType
        WHERE
        ds.InvoiceType = 1
        AND iv.InvoiceNo is null


    ) tbl  ;




    SELECT
      InvoiceOut_InvoiceNo,
      InvoiceOut_PeriodCover,
      ifnull(InvoiceOut_Amount,0) as InvoiceOut_Amount,
      InvoiceOut_DisputeAmount,
      InvoiceOut_DisputeID,
      ifnull(PaymentIn_PeriodCover,'') as PaymentIn_PeriodCover,
      PaymentIn_Amount,
      PaymentIn_PaymentID
    FROM
    (
      SELECT
      DISTINCT
      InvoiceOut_InvoiceNo,
      InvoiceOut_PeriodCover,
      InvoiceOut_IssueDate,
      InvoiceOut_Amount,
      InvoiceOut_DisputeAmount,
      InvoiceOut_DisputeID,
      tmp_Payments.PaymentDate as PaymentIn_PeriodCover,
      tmp_Payments.Amount as PaymentIn_Amount,
      tmp_Payments.PaymentID as PaymentIn_PaymentID
      FROM tmp_InvoiceOutWithDisputes
      INNER JOIN Ratemanagement3.tblAccount on tblAccount.AccountID = p_accountID
      INNER JOIN Ratemanagement3.tblAccountBilling ab ON ab.AccountID = tblAccount.AccountID

      LEFT JOIN tmp_Payments
      ON tmp_Payments.PaymentType = 'Payment In' AND  tmp_Payments.InvoiceNo != '' AND
      tmp_Payments.InvoiceID = tmp_InvoiceOutWithDisputes.InvoiceOut_InvoiceID


      UNION ALL

      select
      DISTINCT
      '' as InvoiceOut_InvoiceNo,
      '' as InvoiceOut_PeriodCover,
      tmp_Payments.IssueDate as InvoiceOut_IssueDate,
      0  as InvoiceOut_Amount,
      0 as InvoiceOut_DisputeAmount,
      0 as InvoiceOut_DisputeID,
      tmp_Payments.PaymentDate as PaymentIn_PeriodCover,
      tmp_Payments.Amount as PaymentIn_Amount,
      tmp_Payments.PaymentID as PaymentIn_PaymentID
      from tmp_Payments_dup as tmp_Payments
      where PaymentType = 'Payment In'

		AND  tmp_Payments.InvoiceID = 0

    ) tbl
    order by InvoiceOut_IssueDate desc,InvoiceOut_InvoiceNo desc;






    INSERT INTO tmp_InvoiceInWithDisputes
    SELECT
    InvoiceNo as InvoiceIn_InvoiceNo,
    PeriodCover as InvoiceIn_PeriodCover,
    IssueDate as InvoiceIn_IssueDate,
    Amount as InvoiceIn_Amount,
    ifnull(DisputeAmount,0) as InvoiceIn_DisputeAmount,
    DisputeID as InvoiceIn_DisputeID,
    AccountID as InvoiceIn_AccountID,
    InvoiceID as InvoiceIn_InvoiceID
    FROM
     (  SELECT
        DISTINCT
            iv.InvoiceNo,
            iv.PeriodCover,
            iv.IssueDate,
            iv.Amount,
            ds.DisputeAmount,
            ds.DisputeID,
            iv.AccountID,
            iv.InvoiceID
        FROM tmp_Invoices iv
      LEFT JOIN tmp_Disputes ds  on  ds.InvoiceNo = iv.InvoiceNo   AND ds.InvoiceType = iv.InvoiceType AND ds.InvoiceNo is not null
        WHERE
        iv.InvoiceType = 2


     UNION ALL

     SELECT
        DISTINCT
            ds.InvoiceNo,
            DATE_FORMAT(ds.created_at, '%d/%m/%Y') as PeriodCover,
            ds.created_at as IssueDate,
            0 as Amount,
            ds.DisputeAmount,
            ds.DisputeID,
            ds.AccountID,
            ds.InvoiceID
      From tmp_Disputes_dup ds
        LEFT JOIN tmp_Invoices_dup iv on ds.InvoiceNo = iv.InvoiceNo AND iv.InvoiceType = ds.InvoiceType
        WHERE  ds.InvoiceType = 2
        AND iv.InvoiceNo is null

    )tbl;




    SELECT
      InvoiceIn_InvoiceNo,
      InvoiceIn_PeriodCover,
      ifnull(InvoiceIn_Amount,0) as InvoiceIn_Amount,
      InvoiceIn_DisputeAmount,
      InvoiceIn_DisputeID,
      ifnull(PaymentOut_PeriodCover,'') as PaymentOut_PeriodCover,
      ifnull(PaymentOut_Amount,0) as PaymentOut_Amount,
      PaymentOut_PaymentID
    FROM
    (
      SELECT
      DISTINCT
      InvoiceIn_InvoiceNo,
      InvoiceIn_PeriodCover,
      InvoiceIn_IssueDate,
      InvoiceIn_Amount,
      InvoiceIn_DisputeAmount,
      InvoiceIn_DisputeID,
      tmp_Payments.PaymentDate as PaymentOut_PeriodCover,
      tmp_Payments.Amount as PaymentOut_Amount,
      tmp_Payments.PaymentID as PaymentOut_PaymentID
      FROM tmp_InvoiceInWithDisputes
      INNER JOIN Ratemanagement3.tblAccount on tblAccount.AccountID = p_accountID
      INNER JOIN Ratemanagement3.tblAccountBilling ab ON ab.AccountID = tblAccount.AccountID

      LEFT JOIN tmp_Payments ON tmp_Payments.PaymentType = 'Payment Out' AND tmp_InvoiceInWithDisputes.InvoiceIn_InvoiceNo = tmp_Payments.InvoiceNo

      UNION ALL

      select
      DISTINCT
      '' as InvoiceIn_InvoiceNo,
      '' as InvoiceIn_PeriodCover,
      tmp_Payments.IssueDate  as InvoiceIn_IssueDate,
      0 as InvoiceIn_Amount,
      0 as InvoiceIn_DisputeAmount,
      0 as InvoiceIn_DisputeID,
      tmp_Payments.PaymentDate as PaymentOut_PeriodCover,
      tmp_Payments.Amount as PaymentOut_Amount,
      tmp_Payments.PaymentID as PaymentOut_PaymentID
      from tmp_Payments_dup as tmp_Payments
      where PaymentType = 'Payment Out' AND  tmp_Payments.InvoiceNo = ''

    ) tbl
    order by InvoiceIn_IssueDate desc;



    select sum(Amount) as InvoiceOutAmountTotal
    from tmp_Invoices where InvoiceType = 1 ;



    select sum(DisputeAmount) as InvoiceOutDisputeAmountTotal
    from tmp_Disputes where InvoiceType = 1;


    select sum(Amount) as PaymentInAmountTotal
    from tmp_Payments where PaymentType = 'Payment In' ;



    select sum(Amount) as InvoiceInAmountTotal
    from tmp_Invoices where InvoiceType = 2 ;



    select sum(DisputeAmount) as InvoiceInDisputeAmountTotal
    from tmp_Disputes where InvoiceType = 2;



    select sum(Amount) as PaymentOutAmountTotal
    from tmp_Payments where PaymentType = 'Payment Out' ;


	-- ------------ broght forward

	select sum(ifnull(Amount,0)) as InvoiceOutAmountTotal  into v_bf_InvoiceOutAmountTotal
    from tmp_Invoices_broghtf where InvoiceType = 1 ;

    select sum(ifnull(Amount,0)) as PaymentInAmountTotal into v_bf_PaymentInAmountTotal
    from tmp_Payments_broghtf where PaymentType = 'Payment In' ;

    select sum(ifnull(Amount,0)) as InvoiceInAmountTotal into v_bf_InvoiceInAmountTotal
    from tmp_Invoices_broghtf where InvoiceType = 2 ;

    select sum(ifnull(Amount,0)) as PaymentOutAmountTotal into v_bf_PaymentOutAmountTotal
    from tmp_Payments_broghtf where PaymentType = 'Payment Out' ;

	SELECT (ifnull(v_bf_InvoiceOutAmountTotal,0) - ifnull(v_bf_PaymentInAmountTotal,0)) - ( ifnull(v_bf_InvoiceInAmountTotal,0) - ifnull(v_bf_PaymentOutAmountTotal,0)) as BroughtForwardOffset;

	-- -------


  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;
DELIMITER ;


-- Girish

USE `RMBilling3`;

DROP PROCEDURE IF EXISTS `prc_getDashboardinvoiceExpense`;
DELIMITER |
CREATE  PROCEDURE `prc_getDashboardinvoiceExpense`(
	IN `p_CompanyID` INT,
	IN `p_CurrencyID` INT,
	IN `p_AccountID` INT,
	IN `p_StartDate` VARCHAR(50),
	IN `p_EndDate` VARCHAR(50),
	IN `p_ListType` VARCHAR(50)
)
BEGIN
	DECLARE v_Round_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_MonthlyTotalDue_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_MonthlyTotalDue_(
		`Year` int,
		`Month` int,
		`Week` int,
		MonthName varchar(50),
		TotalAmount float,
		CurrencyID int,
		InvoiceStatus VARCHAR(50)
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_MonthlyTotalReceived_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_MonthlyTotalReceived_(
		`Year` int,
		`Month` int,
		`Week` int,
		MonthName varchar(50),
		TotalAmount float,
		OutAmount float,
		CurrencyID int
	);
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	INSERT INTO tmp_MonthlyTotalDue_
	SELECT YEAR(IssueDate) as Year
			,MONTH(IssueDate) as Month
			,WEEK(IssueDate) as Week
			,MONTHNAME(MAX(IssueDate)) as  MonthName
			,ROUND(COALESCE(SUM(GrandTotal),0),v_Round_)as TotalAmount
			,CurrencyID
			,InvoiceStatus
	FROM tblInvoice
	WHERE
		CompanyID = p_CompanyID
		AND CurrencyID = p_CurrencyID
		AND InvoiceType = 1 -- Invoice Out
		AND InvoiceStatus NOT IN ( 'cancel' , 'draft' )
		AND (
			(p_EndDate = '0' AND fnGetMonthDifference(IssueDate,NOW()) <= p_StartDate) OR
			(p_EndDate <> '0' AND IssueDate between p_StartDate AND p_EndDate)
			)
		AND (p_AccountID = 0 or AccountID = p_AccountID)
	GROUP BY
			YEAR(IssueDate)
			,MONTH(IssueDate)
			,Week
			,CurrencyID
			,InvoiceStatus
	ORDER BY
			Year
			,Month
			,Week;


	DROP TEMPORARY TABLE IF EXISTS tmp_tblPayment_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblPayment_(
		PaymentDate Date,
		Amount float,
		OutAmount float,
		CurrencyID int
	);
	/* payment recevied invoice*/
	INSERT INTO tmp_tblPayment_ (PaymentDate,Amount,OutAmount,CurrencyID)
	SELECT
		PaymentDate,
		SUM(Amount),
		IF(inv.InvoiceStatus='paid' OR inv.InvoiceStatus='partially_paid' ,inv.GrandTotal - SUM(Amount),-SUM(Amount)) as OutAmount,
		TBL.CurrencyId
	FROM
		(
		SELECT
			CASE WHEN inv.InvoiceID IS NOT NULL
			THEN
				inv.IssueDate
			ELSE
				p.PaymentDate
			END as PaymentDate,
			p.Amount,
			inv.InvoiceID,
			ac.CurrencyId

		FROM tblPayment p
		INNER JOIN Ratemanagement3.tblAccount ac
			ON ac.AccountID = p.AccountID
		LEFT JOIN tblInvoice inv ON p.AccountID = inv.AccountID
			AND p.InvoiceID = inv.InvoiceID
			AND p.Status = 'Approved'
			AND p.AccountID = inv.AccountID
			AND p.Recall=0
			AND InvoiceType = 1
		WHERE
				p.CompanyID = p_CompanyID
			AND ac.CurrencyId = p_CurrencyID
			AND (
				(p_EndDate = '0' AND ((fnGetMonthDifference(p.PaymentDate,NOW()) <= p_StartDate) OR (fnGetMonthDifference(inv.IssueDate,NOW()) <= p_StartDate))) OR
				(p_EndDate<>'0' AND ( p.PaymentDate BETWEEN p_StartDate AND p_EndDate  OR  inv.IssueDate BETWEEN p_StartDate AND p_EndDate))
				)
			AND p.Status = 'Approved'
			AND p.Recall=0
			AND p.PaymentType = 'Payment In'
			AND (p_AccountID = 0 or ac.AccountID = p_AccountID)
			)TBL
	LEFT JOIN tblInvoice inv
		ON TBL.InvoiceID = inv.InvoiceID
	GROUP BY TBL.PaymentDate,TBL.InvoiceID;



	IF p_ListType = 'Weekly'
	THEN

		INSERT INTO tmp_MonthlyTotalReceived_
		SELECT YEAR(p.PaymentDate) as Year
				,MONTH(p.PaymentDate) as Month
				,WEEK(p.PaymentDate) as week
				,MONTHNAME(MAX(p.PaymentDate)) as  MonthName
				,ROUND(COALESCE(SUM(p.Amount),0),v_Round_) as TotalAmount
				,ROUND(COALESCE(SUM(p.OutAmount),0),v_Round_) as OutAmount
				,CurrencyID
		FROM tmp_tblPayment_ p
		GROUP BY
			YEAR(p.PaymentDate)
			,MONTH(p.PaymentDate)
			,week
			,CurrencyID
		ORDER BY
			Year
			,Month
			,week;

		SELECT
			CONCAT(td.`Week`,'-',MAX( td.Year)) AS MonthName ,
			MAX( td.Year) AS `Year`,
			ROUND(COALESCE(SUM(td.TotalAmount),0),v_Round_) TotalInvoice ,
			ROUND(COALESCE(MAX(tr.TotalAmount),0),v_Round_) PaymentReceived,
			ROUND(SUM(IF(InvoiceStatus ='paid' OR InvoiceStatus='partially_paid' ,0,td.TotalAmount)) + COALESCE(MAX(tr.OutAmount),0) ,v_Round_) TotalOutstanding ,
			td.CurrencyID CurrencyID,
			'Weekly' as ftype
		FROM
			tmp_MonthlyTotalDue_ td
		LEFT JOIN tmp_MonthlyTotalReceived_ tr
			ON td.Week = tr.Week
			AND td.Year = tr.Year
			AND td.Month = tr.Month
			AND tr.CurrencyID = td.CurrencyID
		GROUP BY
			td.Week,
			td.Year,
			td.CurrencyID
		ORDER BY
			td.Year
			,td.Week;
	END IF;

	IF p_ListType = 'Monthly'
	THEN
		INSERT INTO tmp_MonthlyTotalReceived_
		SELECT YEAR(p.PaymentDate) as Year
				,MONTH(p.PaymentDate) as Month
				,1
				,MONTHNAME(MAX(p.PaymentDate)) as  MonthName
				,ROUND(COALESCE(SUM(p.Amount),0),v_Round_) as TotalAmount
				,ROUND(COALESCE(SUM(p.OutAmount),0),v_Round_) as OutAmount
				,CurrencyID
		FROM tmp_tblPayment_ p
		GROUP BY
			YEAR(p.PaymentDate)
			,MONTH(p.PaymentDate)
			,CurrencyID
		ORDER BY
			Year
			,Month;


		SELECT
			CONCAT(CONCAT(case when td.Month <10 then concat('0',td.Month) else td.Month End, '/'), td.Year) AS MonthName ,
			td.Year,
			ROUND(COALESCE(SUM(td.TotalAmount),0),v_Round_) TotalInvoice ,
			ROUND(COALESCE(MAX(tr.TotalAmount),0),v_Round_) PaymentReceived,
			ROUND(SUM(IF(InvoiceStatus ='paid' OR InvoiceStatus='partially_paid' ,0,td.TotalAmount)) + COALESCE(MAX(tr.OutAmount),0) ,v_Round_) TotalOutstanding ,
			td.CurrencyID CurrencyID,
			'Monthly' as ftype
		FROM
			tmp_MonthlyTotalDue_ td
		LEFT JOIN tmp_MonthlyTotalReceived_ tr
			ON td.Month = tr.Month
			AND td.Year = tr.Year
			-- AND td.Week = tr.Week
			AND tr.CurrencyID = td.CurrencyID
		GROUP BY
			td.Month,
			td.Year,
			td.CurrencyID
		ORDER BY
			td.Year
			,td.Month;
	END IF;

	IF p_ListType = 'Yearly'
	THEN
			INSERT INTO tmp_MonthlyTotalReceived_
			SELECT YEAR(p.PaymentDate) as Year
					,1 -- MONTH(p.PaymentDate) as Month
					,1
					,'Oct' as  MonthName
					,ROUND(COALESCE(SUM(p.Amount),0),v_Round_) as TotalAmount
					,ROUND(COALESCE(SUM(p.OutAmount),0),v_Round_) as OutAmount
					,CurrencyID
			FROM tmp_tblPayment_ p
			GROUP BY
				YEAR(p.PaymentDate)
			 	-- ,MONTH(p.PaymentDate)
				,CurrencyID
			ORDER BY
				Year;
			-- 	,Month;

		SELECT
			td.Year as MonthName,
			ROUND(COALESCE(SUM(td.TotalAmount),0),v_Round_) TotalInvoice ,
			ROUND(COALESCE(MAX(tr.TotalAmount),0),v_Round_) PaymentReceived,
			ROUND(SUM(IF(InvoiceStatus ='paid' OR InvoiceStatus='partially_paid' ,0,td.TotalAmount)) + COALESCE(MAX(tr.OutAmount),0) ,v_Round_) TotalOutstanding ,
			td.CurrencyID CurrencyID,
			'Yearly' as ftype
		FROM
			tmp_MonthlyTotalDue_ td
		LEFT JOIN tmp_MonthlyTotalReceived_ tr
			ON td.Year = tr.Year
		-- 	AND td.Week = tr.Week
		-- 	AND td.Month = tr.Month
			AND tr.CurrencyID = td.CurrencyID
		GROUP BY
			td.Year,
			td.CurrencyID
		ORDER BY
			td.Year;
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_ProcesssCDR
DROP PROCEDURE IF EXISTS `prc_ProcesssCDR`;
DELIMITER |
CREATE  PROCEDURE `prc_ProcesssCDR`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_RateCDR` INT,
	IN `p_RateFormat` INT,
	IN `p_NameFormat` VARCHAR(50),
	IN `p_RateMethod` VARCHAR(50),
	IN `p_SpecifyRate` DECIMAL(18,6)
)
BEGIN
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_TrunkID_ INT;
	DECLARE v_CDRUpload_ INT;
	DECLARE v_NewAccountIDCount_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_tblTempRateLog_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblTempRateLog_(
		`CompanyID` INT(11) NULL DEFAULT NULL,
		`CompanyGatewayID` INT(11) NULL DEFAULT NULL,
		`MessageType` INT(11) NOT NULL,
		`Message` VARCHAR(500) NOT NULL,
		`RateDate` DATE NOT NULL
	);

	/* insert new account */
	SET @stm = CONCAT('
	INSERT INTO tblGatewayAccount (CompanyID, CompanyGatewayID, GatewayAccountID, AccountName)
	SELECT
		DISTINCT
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.GatewayAccountID,
		ud.GatewayAccountID
	FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
	LEFT JOIN tblGatewayAccount ga
		ON ga.GatewayAccountID = ud.GatewayAccountID
		AND ga.CompanyGatewayID = ud.CompanyGatewayID
		AND ga.CompanyID = ud.CompanyID
	WHERE ProcessID =  "' , p_processId , '"
		AND ga.GatewayAccountID IS NULL
		AND ud.GatewayAccountID IS NOT NULL;
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	/* active new account */
	CALL  prc_getActiveGatewayAccount(p_CompanyID,p_CompanyGatewayID,'0','1',p_NameFormat);

	/* update cdr account */
	SET @stm = CONCAT('
	UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` uh
	INNER JOIN tblGatewayAccount ga
		ON  ga.CompanyID = uh.CompanyID
		AND ga.CompanyGatewayID = uh.CompanyGatewayID
		AND ga.GatewayAccountID = uh.GatewayAccountID
	SET uh.AccountID = ga.AccountID
	WHERE uh.AccountID IS NULL
	AND ga.AccountID is not null
	AND uh.CompanyID = ' ,  p_companyid , '
	AND uh.ProcessID = "' , p_processId , '" ;
	');
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SELECT COUNT(*) INTO v_NewAccountIDCount_
	FROM RMCDR3.tblUsageHeader uh
	INNER JOIN tblGatewayAccount ga
		ON  ga.CompanyID = uh.CompanyID
		AND ga.CompanyGatewayID = uh.CompanyGatewayID
		AND ga.GatewayAccountID = uh.GatewayAccountID
	WHERE uh.AccountID IS NULL
	AND ga.AccountID is not null
	AND uh.CompanyID = p_CompanyID
	AND uh.CompanyGatewayID = p_CompanyGatewayID;

	IF v_NewAccountIDCount_ > 0
	THEN

		/* update header cdr account */
		UPDATE RMCDR3.tblUsageHeader uh
		INNER JOIN tblGatewayAccount ga
			ON  ga.CompanyID = uh.CompanyID
			AND ga.CompanyGatewayID = uh.CompanyGatewayID
			AND ga.GatewayAccountID = uh.GatewayAccountID
		SET uh.AccountID = ga.AccountID
		WHERE uh.AccountID IS NULL
		AND ga.AccountID is not null
		AND uh.CompanyID = p_CompanyID
		AND uh.CompanyGatewayID = p_CompanyGatewayID;

	END IF;

	/* temp accounts and trunks*/
	DROP TEMPORARY TABLE IF EXISTS tmp_AccountTrunkCdrUpload_;
	CREATE TEMPORARY TABLE tmp_AccountTrunkCdrUpload_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		TrunkID INT
	);
	SET @stm = CONCAT('
	INSERT INTO tmp_AccountTrunkCdrUpload_(AccountID,TrunkID)
	SELECT DISTINCT AccountID,TrunkID FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND TrunkID IS NOT NULL AND ud.is_inbound = 0;
	');

	SET v_CDRUpload_ = (SELECT COUNT(*) FROM tmp_AccountTrunkCdrUpload_);

	IF v_CDRUpload_ > 0
	THEN
		/* update UseInBilling when cdr upload*/
		SET @stm = CONCAT('
		UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN Ratemanagement3.tblCustomerTrunk ct
			ON ct.AccountID = ud.AccountID AND ct.TrunkID = ud.TrunkID AND ct.Status =1
		INNER JOIN Ratemanagement3.tblTrunk t
			ON t.TrunkID = ct.TrunkID
			SET ud.UseInBilling=ct.UseInBilling,ud.TrunkPrefix = ct.Prefix
		WHERE  ud.ProcessID = "' , p_processId , '";
		');
	END IF;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	/* if rate format is prefix base not charge code*/
	IF p_RateFormat = 2
	THEN

		/* update trunk without use in billing*/
		SET @stm = CONCAT('
		UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN Ratemanagement3.tblCustomerTrunk ct
			ON ct.AccountID = ud.AccountID AND ct.Status =1
			AND ct.UseInBilling = 0
		INNER JOIN Ratemanagement3.tblTrunk t
			ON t.TrunkID = ct.TrunkID
			SET ud.trunk = t.Trunk,ud.TrunkID =t.TrunkID,ud.UseInBilling=ct.UseInBilling
		WHERE  ud.ProcessID = "' , p_processId , '" AND ud.is_inbound = 0 AND ud.TrunkID IS NULL;
		');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		/* update trunk with use in billing*/
		SET @stm = CONCAT('
		UPDATE RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN Ratemanagement3.tblCustomerTrunk ct
			ON ct.AccountID = ud.AccountID AND ct.Status =1
			AND ct.UseInBilling = 1 AND cld LIKE CONCAT(ct.Prefix , "%")
		INNER JOIN Ratemanagement3.tblTrunk t
			ON t.TrunkID = ct.TrunkID
			SET ud.trunk = t.Trunk,ud.TrunkID =t.TrunkID,ud.UseInBilling=ct.UseInBilling,ud.TrunkPrefix = ct.Prefix
		WHERE  ud.ProcessID = "' , p_processId , '" AND ud.is_inbound = 0 AND ud.TrunkID IS NULL;
		');

		PREPARE stm FROM @stm;
		EXECUTE stm;
		DEALLOCATE PREPARE stm;

	END IF;

	/* if rerate on */
	IF p_RateCDR = 1
	THEN

		SET @stm = CONCAT('UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud SET cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND ( AccountID IS NULL OR TrunkID IS NULL ) ') ;

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;

	/* temp accounts and trunks*/
	DROP TEMPORARY TABLE IF EXISTS tmp_AccountTrunk_;
	CREATE TEMPORARY TABLE tmp_AccountTrunk_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		TrunkID INT
	);
	SET @stm = CONCAT('
	INSERT INTO tmp_AccountTrunk_(AccountID,TrunkID)
	SELECT DISTINCT AccountID,TrunkID FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND TrunkID IS NOT NULL AND ud.is_inbound = 0;
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_AccountTrunk_);

	WHILE v_pointer_ <= v_rowCount_
	DO

		SET v_TrunkID_ = (SELECT TrunkID FROM tmp_AccountTrunk_ t WHERE t.RowID = v_pointer_);
		SET v_AccountID_ = (SELECT AccountID FROM tmp_AccountTrunk_ t WHERE t.RowID = v_pointer_);

		/* get outbound rate process*/
		CALL Ratemanagement3.prc_getCustomerCodeRate(v_AccountID_,v_TrunkID_,p_RateCDR,p_RateMethod,p_SpecifyRate);

		/* update prefix outbound process*/
		/* if rate format is prefix base not charge code*/
		IF p_RateFormat = 2
		THEN
			CALL prc_updatePrefix(v_AccountID_,v_TrunkID_, p_processId, p_tbltempusagedetail_name);
		END IF;

		/* outbound rerate process*/
		IF p_RateCDR = 1
		THEN
			CALL prc_updateOutboundRate(v_AccountID_,v_TrunkID_, p_processId, p_tbltempusagedetail_name);
		END IF;

		SET v_pointer_ = v_pointer_ + 1;
	END WHILE;

	/* if rerate is off and acconts and trunks not setup update prefix from default codedeck*/
	IF p_RateCDR = 0 AND p_RateFormat = 2
	THEN
		/* temp accounts and trunks*/
		DROP TEMPORARY TABLE IF EXISTS tmp_Accounts_;
		CREATE TEMPORARY TABLE tmp_Accounts_  (
			RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			AccountID INT
		);
		SET @stm = CONCAT('
		INSERT INTO tmp_Accounts_(AccountID)
		SELECT DISTINCT AccountID FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND TrunkID IS NOT NULL;
		');

		PREPARE stm FROM @stm;
		EXECUTE stm;
		DEALLOCATE PREPARE stm;

		/* get default code */
		CALL Ratemanagement3.prc_getDefaultCodes(p_CompanyID);

		/* update prefix from default codes
		 if rate format is prefix base not charge code*/
		CALL prc_updateDefaultPrefix(p_processId, p_tbltempusagedetail_name);

	END IF;

	/* inbound rerate process*/
	CALL prc_RerateInboundCalls(p_CompanyID,p_processId,p_tbltempusagedetail_name,p_RateCDR,p_RateMethod,p_SpecifyRate);

	SET @stm = CONCAT('
	INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
	SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,1,  CONCAT( "Account:  " , ga.AccountName ," - Gateway: ",cg.Title," - Doesnt exist in NEON") as Message ,DATE(NOW())
	FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud
	INNER JOIN tblGatewayAccount ga
		ON ga.CompanyGatewayID = ud.CompanyGatewayID
		AND ga.CompanyID = ud.CompanyID
		AND ga.GatewayAccountID = ud.GatewayAccountID
	INNER JOIN Ratemanagement3.tblCompanyGateway cg ON cg.CompanyGatewayID = ud.CompanyGatewayID
	WHERE ud.ProcessID = "' , p_processid  , '" and ud.AccountID IS NULL');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	IF p_RateCDR = 1
	THEN
		SET @stm = CONCAT('
		INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
		SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,2,  CONCAT( "Account:  " , a.AccountName ," - Trunk: ",ud.trunk," - Unable to Rerate number ",IFNULL(ud.cld,"")," - No Matching prefix found") as Message ,DATE(NOW())
		FROM  RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN Ratemanagement3.tblAccount a on  ud.AccountID = a.AccountID
		WHERE ud.ProcessID = "' , p_processid  , '" and ud.is_inbound = 0 AND ud.is_rerated = 0 AND ud.billed_second <> 0 and ud.area_prefix = "Other"');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SET @stm = CONCAT('
		INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
		SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,3,  CONCAT( "Account:  " , a.AccountName ,  " - Unable to Rerate number ",IFNULL(ud.cld,"")," - No Matching prefix found") as Message ,DATE(NOW())
		FROM  RMCDR3.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN Ratemanagement3.tblAccount a on  ud.AccountID = a.AccountID
		WHERE ud.ProcessID = "' , p_processid  , '" and ud.is_inbound = 1 AND ud.is_rerated = 0 AND ud.billed_second <> 0 and ud.area_prefix = "Other"');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SET @stm = CONCAT('
		INSERT INTO Ratemanagement3.tblTempRateLog (CompanyID,CompanyGatewayID,MessageType,Message,RateDate,SentStatus,created_at)
		SELECT rt.CompanyID,rt.CompanyGatewayID,rt.MessageType,rt.Message,rt.RateDate,0 as SentStatus,NOW() as created_at FROM tmp_tblTempRateLog_ rt
		LEFT JOIN Ratemanagement3.tblTempRateLog rt2
			ON rt.CompanyID = rt2.CompanyID
			AND rt.CompanyGatewayID = rt2.CompanyGatewayID
			AND rt.MessageType = rt2.MessageType
			AND rt.Message = rt2.Message
			AND rt.RateDate = rt2.RateDate
		WHERE rt2.TempRateLogID IS NULL;
		');
		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;

	SELECT DISTINCT Message FROM tmp_tblTempRateLog_;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_RerateInboundCalls
DROP PROCEDURE IF EXISTS `prc_RerateInboundCalls`;
DELIMITER |
CREATE  PROCEDURE `prc_RerateInboundCalls`(
	IN `p_CompanyID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_RateCDR` INT,
	IN `p_RateMethod` VARCHAR(50),
	IN `p_SpecifyRate` DECIMAL(18,6)
)
BEGIN

	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_cld_ VARCHAR(500);

	IF p_RateCDR = 1
	THEN

		IF (SELECT COUNT(*) FROM Ratemanagement3.tblCLIRateTable WHERE CompanyID = p_CompanyID AND RateTableID > 0) > 0
		THEN

			/* temp accounts*/
			DROP TEMPORARY TABLE IF EXISTS tmp_Account_;
			CREATE TEMPORARY TABLE tmp_Account_  (
				RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
				AccountID INT,
				cld VARCHAR(500) NULL DEFAULT NULL
			);
			SET @stm = CONCAT('
			INSERT INTO tmp_Account_(AccountID,cld)
			SELECT DISTINCT AccountID,cld FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND ud.is_inbound = 1;
			');

			PREPARE stm FROM @stm;
			EXECUTE stm;
			DEALLOCATE PREPARE stm;

		ELSE


			/* temp accounts*/
			DROP TEMPORARY TABLE IF EXISTS tmp_Account_;
			CREATE TEMPORARY TABLE tmp_Account_  (
				RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
				AccountID INT,
				cld VARCHAR(500) NULL DEFAULT NULL
			);
			SET @stm = CONCAT('
			INSERT INTO tmp_Account_(AccountID,cld)
			SELECT DISTINCT AccountID,"" FROM RMCDR3.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND ud.is_inbound = 1;
			');

			PREPARE stm FROM @stm;
			EXECUTE stm;
			DEALLOCATE PREPARE stm;

		END IF;



		SET v_pointer_ = 1;
		SET v_rowCount_ = (SELECT COUNT(*) FROM tmp_Account_);

		WHILE v_pointer_ <= v_rowCount_
		DO

			SET v_AccountID_ = (SELECT AccountID FROM tmp_Account_ t WHERE t.RowID = v_pointer_);
			SET v_cld_ = (SELECT cld FROM tmp_Account_ t WHERE t.RowID = v_pointer_);

			/* get inbound rate process*/
			CALL Ratemanagement3.prc_getCustomerInboundRate(v_AccountID_,p_RateCDR,p_RateMethod,p_SpecifyRate,v_cld_);

			/* update prefix inbound process*/
			CALL prc_updateInboundPrefix(v_AccountID_, p_processId, p_tbltempusagedetail_name,v_cld_);

			/* inbound rerate process*/
			CALL prc_updateInboundRate(v_AccountID_, p_processId, p_tbltempusagedetail_name,v_cld_);

			SET v_pointer_ = v_pointer_ + 1;

		END WHILE;

	END IF;


END|
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_updateInboundPrefix
DROP PROCEDURE IF EXISTS `prc_updateInboundPrefix`;
DELIMITER |
CREATE  PROCEDURE `prc_updateInboundPrefix`(
	IN `p_AccountID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_CLD` VARCHAR(500)
)
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail_(
		TempUsageDetailID int,
		prefix varchar(50),
		INDEX IX_TempUsageDetailID(`TempUsageDetailID`)
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail2_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail2_(
		TempUsageDetailID int,
		prefix varchar(50),
		INDEX IX_TempUsageDetailID2(`TempUsageDetailID`)
	);

	IF p_CLD != ''
	THEN

		/* find prefix */
		SET @stm = CONCAT('
		INSERT INTO tmp_TempUsageDetail_
		SELECT
			TempUsageDetailID,
			c.code AS prefix
		FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
		INNER JOIN Ratemanagement3.tmp_inboundcodes_ c
		ON ud.ProcessID = ' , p_processId , '
			AND ud.is_inbound = 1
			AND ud.AccountID = ' , p_AccountID , '
			AND ("' , p_CLD , '" = "" OR cld = "' , p_CLD , '")
			AND ud.area_prefix = "Other"
			AND cli like  CONCAT(c.Code,"%");
		');

	ELSE

		/* find prefix */
		SET @stm = CONCAT('
		INSERT INTO tmp_TempUsageDetail_
		SELECT
			TempUsageDetailID,
			c.code AS prefix
		FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
		INNER JOIN Ratemanagement3.tmp_inboundcodes_ c
		ON ud.ProcessID = ' , p_processId , '
			AND ud.is_inbound = 1
			AND ud.AccountID = ' , p_AccountID , '
			AND ud.area_prefix = "Other"
			AND cld like  CONCAT(c.Code,"%");
		');

	END IF;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stm = CONCAT('INSERT INTO tmp_TempUsageDetail2_
	SELECT tbl.TempUsageDetailID,MAX(tbl.prefix)
	FROM tmp_TempUsageDetail_ tbl
	GROUP BY tbl.TempUsageDetailID;');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stm = CONCAT('UPDATE RMCDR3.' , p_tbltempusagedetail_name , ' tbl2
	INNER JOIN tmp_TempUsageDetail2_ tbl
		ON tbl2.TempUsageDetailID = tbl.TempUsageDetailID
	SET area_prefix = prefix
	WHERE tbl2.processId = "' , p_processId , '"
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

END|
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_updateInboundRate
DROP PROCEDURE IF EXISTS `prc_updateInboundRate`;
DELIMITER |
CREATE  PROCEDURE `prc_updateInboundRate`(
	IN `p_AccountID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_CLD` VARCHAR(500)
)
BEGIN

	SET @stm = CONCAT('UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud SET cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND AccountID = "',p_AccountID ,'" AND ("' , p_CLD , '" = "" OR cld = "' , p_CLD , '") AND is_inbound = 1 ') ;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stm = CONCAT('
	UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud
	INNER JOIN Ratemanagement3.tmp_inboundcodes_ cr ON cr.Code = ud.area_prefix
	SET cost =
		CASE WHEN  billed_second >= Interval1
		THEN
			(Rate/60.0)*Interval1+CEILING((billed_second-Interval1)/IntervalN)*(Rate/60.0)*IntervalN+IFNULL(ConnectionFee,0)
		ElSE
			CASE WHEN  billed_second > 0
			THEN
				Rate+IFNULL(ConnectionFee,0)
			ELSE
				0
			END
		END
	,is_rerated=1
	,duration=billed_second
	,billed_duration =
		CASE WHEN  billed_second >= Interval1
		THEN
			Interval1+CEILING((billed_second-Interval1)/IntervalN)*IntervalN
		ElSE
			CASE WHEN  billed_second > 0
			THEN
				Interval1
			ELSE
				0
			END
		END
	WHERE ProcessID = "',p_processId,'"
	AND AccountID = "',p_AccountID ,'"
	AND ("' , p_CLD , '" = "" OR cld = "' , p_CLD , '")
	AND is_inbound = 1') ;

	PREPARE stmt FROM @stm;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

END|
DELIMITER ;

-- Dumping structure for procedure RMBilling3.prc_updateSOAOffSet
DROP PROCEDURE IF EXISTS `prc_updateSOAOffSet`;
DELIMITER |
CREATE  PROCEDURE `prc_updateSOAOffSet`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_AccountSOA;
	CREATE TEMPORARY TABLE tmp_AccountSOA (
		AccountID INT,
		Amount NUMERIC(18, 8),
		PaymentType VARCHAR(50),
		InvoiceType int
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_AccountSOABal;
	CREATE TEMPORARY TABLE tmp_AccountSOABal (
		AccountID INT,
		Amount NUMERIC(18, 8)
	);

     -- 1 Invoices
	INSERT into tmp_AccountSOA(AccountID,Amount,InvoiceType)
	SELECT
		tblInvoice.AccountID,
		tblInvoice.GrandTotal,
		tblInvoice.InvoiceType
	FROM tblInvoice
	WHERE tblInvoice.CompanyID = p_CompanyID
	AND ( (tblInvoice.InvoiceType = 2) OR ( tblInvoice.InvoiceType = 1 AND tblInvoice.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'awaiting') )  )
	AND (p_AccountID = 0 OR  tblInvoice.AccountID = p_AccountID);

     -- 2 Payments
	INSERT into tmp_AccountSOA(AccountID,Amount,PaymentType)
	SELECT
		tblPayment.AccountID,
		tblPayment.Amount,
		tblPayment.PaymentType
	FROM tblPayment
	WHERE tblPayment.CompanyID = p_CompanyID
	AND tblPayment.Status = 'Approved'
	AND tblPayment.Recall = 0
	AND (p_AccountID = 0 OR  tblPayment.AccountID = p_AccountID);

	INSERT INTO tmp_AccountSOABal
	SELECT AccountID,(SUM(IF(InvoiceType=1,Amount,0)) -  SUM(IF(PaymentType='Payment In',Amount,0))) - (SUM(IF(InvoiceType=2,Amount,0)) - SUM(IF(PaymentType='Payment Out',Amount,0))) as SOAOffSet
	FROM tmp_AccountSOA
	GROUP BY AccountID;

	INSERT INTO tmp_AccountSOABal
	SELECT DISTINCT tblAccount.AccountID ,0 FROM Ratemanagement3.tblAccount
	LEFT JOIN tmp_AccountSOA ON tblAccount.AccountID = tmp_AccountSOA.AccountID
	WHERE tblAccount.CompanyID = p_CompanyID
	AND tmp_AccountSOA.AccountID IS NULL
	AND (p_AccountID = 0 OR  tblAccount.AccountID = p_AccountID);

	UPDATE Ratemanagement3.tblAccountBalance
	INNER JOIN tmp_AccountSOABal
		ON  tblAccountBalance.AccountID = tmp_AccountSOABal.AccountID
	SET SOAOffset=tmp_AccountSOABal.Amount;

	UPDATE Ratemanagement3.tblAccountBalance SET tblAccountBalance.BalanceAmount = COALESCE(tblAccountBalance.SOAOffset,0) + COALESCE(tblAccountBalance.UnbilledAmount,0)  - COALESCE(tblAccountBalance.VendorUnbilledAmount,0);

	INSERT INTO Ratemanagement3.tblAccountBalance (AccountID,BalanceAmount,UnbilledAmount,SOAOffset)
	SELECT tmp_AccountSOABal.AccountID,tmp_AccountSOABal.Amount,0,tmp_AccountSOABal.Amount
	FROM tmp_AccountSOABal
	LEFT JOIN Ratemanagement3.tblAccountBalance
		ON tblAccountBalance.AccountID = tmp_AccountSOABal.AccountID
	WHERE tblAccountBalance.AccountID IS NULL;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

DROP PROCEDURE IF EXISTS `prc_getActiveGatewayAccount`;
DELIMITER |
CREATE  PROCEDURE `prc_getActiveGatewayAccount`(
	IN `p_company_id` INT,
	IN `p_gatewayid` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_NameFormat` VARCHAR(50)
)
BEGIN

	DECLARE v_NameFormat_ VARCHAR(10);
	DECLARE v_RTR_ INT;
	DECLARE v_pointer_ INT ;
	DECLARE v_rowCount_ INT ;

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DROP TEMPORARY TABLE IF EXISTS tmp_ActiveAccount;
	CREATE TEMPORARY TABLE tmp_ActiveAccount (
		GatewayAccountID varchar(100),
		AccountID INT,
		AccountName varchar(100)
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_AuthenticateRules_;
	CREATE TEMPORARY TABLE tmp_AuthenticateRules_ (
		RowNo INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AuthRule VARCHAR(50)
	);

	IF p_NameFormat = ''
	THEN

		INSERT INTO tmp_AuthenticateRules_  (AuthRule)
		SELECT
			CASE WHEN Settings LIKE '%"NameFormat":"NAMENUB"%'
			THEN 'NAMENUB'
			ELSE
			CASE WHEN Settings LIKE '%"NameFormat":"NUBNAME"%'
			THEN 'NUBNAME'
			ELSE
			CASE WHEN Settings LIKE '%"NameFormat":"NUB"%'
			THEN 'NUB'
			ELSE
			CASE WHEN Settings LIKE '%"NameFormat":"IP"%'
			THEN 'IP'
			ELSE
			CASE WHEN Settings LIKE '%"NameFormat":"CLI"%'
			THEN 'CLI'
			ELSE
			CASE WHEN Settings LIKE '%"NameFormat":"NAME"%'
			THEN 'NAME'
			ELSE 'NAME' END END END END END END   AS  NameFormat
		FROM Ratemanagement3.tblCompanyGateway
		WHERE Settings LIKE '%NameFormat%' AND
		CompanyGatewayID = p_gatewayid
		LIMIT 1;

	END IF;

	IF p_NameFormat != ''
	THEN

		INSERT INTO tmp_AuthenticateRules_  (AuthRule)
		SELECT p_NameFormat;

	END IF;

	INSERT INTO tmp_AuthenticateRules_  (AuthRule)
	SELECT DISTINCT CustomerAuthRule FROM Ratemanagement3.tblAccountAuthenticate aa WHERE CustomerAuthRule IS NOT NULL
	UNION
	SELECT DISTINCT VendorAuthRule FROM Ratemanagement3.tblAccountAuthenticate aa WHERE VendorAuthRule IS NOT NULL;

	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_AuthenticateRules_);

	WHILE v_pointer_ <= v_rowCount_
	DO

		SET v_NameFormat_ = ( SELECT AuthRule FROM tmp_AuthenticateRules_  WHERE RowNo = v_pointer_ );

		IF  v_NameFormat_ = 'NAMENUB'
		THEN

			INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
				GatewayAccountID,
				a.AccountID,
				a.AccountName
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN tblGatewayAccount ga
				ON concat(a.AccountName , '-' , a.Number) = ga.AccountName
				AND a.Status = 1
			WHERE GatewayAccountID IS NOT NULL
			AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
			AND a.CompanyId = p_company_id
			AND ga.CompanyGatewayID = p_gatewayid;

		END IF;

		IF v_NameFormat_ = 'NUBNAME'
		THEN

			INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
				GatewayAccountID,
				a.AccountID,
				a.AccountName
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN tblGatewayAccount ga
				ON concat(a.Number, '-' , a.AccountName) = ga.AccountName
				AND a.Status = 1
			WHERE GatewayAccountID IS NOT NULL
			AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
			AND a.CompanyId = p_company_id
			AND ga.CompanyGatewayID = p_gatewayid;

		END IF;

		IF v_NameFormat_ = 'NUB'
		THEN

			INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
				GatewayAccountID,
				a.AccountID,
				a.AccountName
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN tblGatewayAccount ga
				ON a.Number = ga.AccountName
				AND a.Status = 1
			WHERE GatewayAccountID IS NOT NULL
			AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
			AND a.CompanyId = p_company_id
			AND ga.CompanyGatewayID = p_gatewayid;

		END IF;

		IF v_NameFormat_ = 'IP'
		THEN

			INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
				GatewayAccountID,
				a.AccountID,
				a.AccountName
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN Ratemanagement3.tblAccountAuthenticate aa
				ON a.AccountID = aa.AccountID AND (aa.CustomerAuthRule = 'IP' OR aa.VendorAuthRule ='IP')
			INNER JOIN tblGatewayAccount ga
				ON   a.Status = 1
			WHERE GatewayAccountID IS NOT NULL
			AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
			AND a.CompanyId = p_company_id
			AND ga.CompanyGatewayID = p_gatewayid
			AND ( FIND_IN_SET(ga.AccountName,aa.CustomerAuthValue) != 0 OR FIND_IN_SET(ga.AccountName,aa.VendorAuthValue) != 0 );

		END IF;


		IF v_NameFormat_ = 'CLI'
		THEN
			/* INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
			GatewayAccountID,
			a.AccountID,
			a.AccountName
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN Ratemanagement3.tblAccountAuthenticate aa ON
			a.AccountID = aa.AccountID AND (aa.CustomerAuthRule = 'CLI' OR aa.VendorAuthRule ='CLI')
			INNER JOIN tblGatewayAccount ga
			ON   a.Status = 1
			WHERE GatewayAccountID IS NOT NULL
			AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
			AND a.CompanyId = p_company_id
			AND ga.CompanyGatewayID = p_gatewayid
			AND ( FIND_IN_SET(ga.AccountName,aa.CustomerAuthValue) != 0 OR FIND_IN_SET(ga.AccountName,aa.VendorAuthValue) != 0 );
			*/

			INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
				GatewayAccountID,
				a.AccountID,
				a.AccountName
			FROM Ratemanagement3.tblAccount  a
			INNER JOIN Ratemanagement3.tblCLIRateTable aa
				ON a.AccountID = aa.AccountID
			INNER JOIN tblGatewayAccount ga
				ON   a.Status = 1
			WHERE GatewayAccountID IS NOT NULL
			AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
			AND a.CompanyId = p_company_id
			AND ga.CompanyGatewayID = p_gatewayid
			AND ga.AccountName = aa.CLI;

		END IF;


		IF v_NameFormat_ = '' OR v_NameFormat_ IS NULL OR v_NameFormat_ = 'NAME'
		THEN

			INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
				GatewayAccountID,
				a.AccountID,
				a.AccountName
			FROM Ratemanagement3.tblAccount  a
			LEFT JOIN Ratemanagement3.tblAccountAuthenticate aa
				ON a.AccountID = aa.AccountID AND (aa.CustomerAuthRule = 'Other' OR aa.VendorAuthRule ='Other')
			INNER JOIN tblGatewayAccount ga
				ON    a.Status = 1
			WHERE GatewayAccountID IS NOT NULL
			AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
			AND a.CompanyId = p_company_id
			AND ga.CompanyGatewayID = p_gatewayid
			AND ((aa.AccountAuthenticateID IS NOT NULL AND (aa.VendorAuthValue = ga.AccountName OR aa.CustomerAuthValue = ga.AccountName  )) OR (aa.AccountAuthenticateID IS NULL AND a.AccountName = ga.AccountName));

		END IF;

		SET v_pointer_ = v_pointer_ + 1;

	END WHILE;

	UPDATE tblGatewayAccount
	INNER JOIN tmp_ActiveAccount a
		ON a.GatewayAccountID = tblGatewayAccount.GatewayAccountID
		AND tblGatewayAccount.CompanyGatewayID = p_gatewayid
	SET tblGatewayAccount.AccountID = a.AccountID
	WHERE tblGatewayAccount.AccountID is null;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_updateOutboundRate`;
DELIMITER |
CREATE  PROCEDURE `prc_updateOutboundRate`(
	IN `p_AccountID` INT,
	IN `p_TrunkID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200)
)
BEGIN

	SET @stm = CONCAT('UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud SET cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND AccountID = "',p_AccountID ,'" AND TrunkID = "',p_TrunkID ,'" AND is_inbound = 0 ') ;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stm = CONCAT('
	UPDATE   RMCDR3.`' , p_tbltempusagedetail_name , '` ud
	INNER JOIN Ratemanagement3.tmp_codes_ cr ON cr.Code = ud.area_prefix
	SET cost =
		CASE WHEN  billed_second >= Interval1
		THEN
			(Rate/60.0)*Interval1+CEILING((billed_second-Interval1)/IntervalN)*(Rate/60.0)*IntervalN+IFNULL(ConnectionFee,0)
		ElSE
			CASE WHEN  billed_second > 0
			THEN
				Rate+IFNULL(ConnectionFee,0)
			ELSE
				0
			END
		END
	,is_rerated=1
	,duration = billed_second
	,billed_duration =
		CASE WHEN  billed_second >= Interval1
		THEN
			Interval1+CEILING((billed_second-Interval1)/IntervalN)*IntervalN
		ElSE
			CASE WHEN  billed_second > 0
			THEN
				Interval1
			ELSE
				0
			END
		END

	WHERE ProcessID = "',p_processId,'"
	AND AccountID = "',p_AccountID ,'"
	AND TrunkID = "',p_TrunkID ,'"
	AND is_inbound = 0') ;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

END|
DELIMITER ;


DROP PROCEDURE IF EXISTS `prc_updatePrefix`;
DELIMITER |
CREATE  PROCEDURE `prc_updatePrefix`(
	IN `p_AccountID` INT,
	IN `p_TrunkID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200)
)
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail_(
		TempUsageDetailID int,
		prefix varchar(50),
		INDEX IX_TempUsageDetailID(`TempUsageDetailID`)
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail2_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail2_(
		TempUsageDetailID int,
		prefix varchar(50),
		INDEX IX_TempUsageDetailID2(`TempUsageDetailID`)
	);

	/* find prefix without use in billing */
	SET @stm = CONCAT('
	INSERT INTO tmp_TempUsageDetail_
	SELECT
		TempUsageDetailID,
		c.code AS prefix
	FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
	INNER JOIN Ratemanagement3.tmp_codes_ c
	ON ud.ProcessID = ' , p_processId , '
		AND ud.is_inbound = 0
		AND ud.AccountID = ' , p_AccountID , '
		AND ud.TrunkID = ' , p_TrunkID , '
		AND ud.UseInBilling = 0
		AND ud.area_prefix = "Other"
		AND ( extension <> cld or extension IS NULL)
		AND cld REGEXP "^[0-9]+$"
		AND cld like  CONCAT(c.Code,"%");
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	/* find prefix with use in billing */
	SET @stm = CONCAT('
	INSERT INTO tmp_TempUsageDetail_
	SELECT
		TempUsageDetailID,
		c.code AS prefix
	FROM RMCDR3.' , p_tbltempusagedetail_name , ' ud
	INNER JOIN Ratemanagement3.tmp_codes_ c
	ON ud.ProcessID = ' , p_processId , '
		AND ud.is_inbound = 0
		AND ud.AccountID = ' , p_AccountID , '
		AND ud.TrunkID = ' , p_TrunkID , '
		AND ud.UseInBilling = 1
		AND ud.area_prefix = "Other"
		AND ( extension <> cld or extension IS NULL)
		AND cld REGEXP "^[0-9]+$"
		AND cld like  CONCAT(ud.TrunkPrefix,c.Code,"%");
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

	SET @stm = CONCAT('INSERT INTO tmp_TempUsageDetail2_
	SELECT tbl.TempUsageDetailID,MAX(tbl.prefix)
	FROM tmp_TempUsageDetail_ tbl
	GROUP BY tbl.TempUsageDetailID;');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stm = CONCAT('UPDATE RMCDR3.' , p_tbltempusagedetail_name , ' tbl2
	INNER JOIN tmp_TempUsageDetail2_ tbl
		ON tbl2.TempUsageDetailID = tbl.TempUsageDetailID
	SET area_prefix = prefix
	WHERE tbl2.processId = "' , p_processId , '"
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

END|
DELIMITER ;


-- RMCDR3
-- Girish
USE `RMCDR3`;

ALTER TABLE `tblUsageDetailFailedCall`
	ADD COLUMN `disposition` VARCHAR(50) NULL DEFAULT NULL;
ALTER TABLE `tblUsageDetails`
	ADD COLUMN `disposition` VARCHAR(50) NULL DEFAULT NULL;

DROP PROCEDURE IF EXISTS `prc_unsetCDRUsageAccount`;
DELIMITER |
CREATE PROCEDURE `prc_unsetCDRUsageAccount`(
	IN `p_CompanyID` INT,
	IN `p_IPs` LONGTEXT,
	IN `p_StartDate` VARCHAR(50),
	IN `p_Confirm` INT
)
BEGIN

	DECLARE v_AccountID int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_AccountID = 0;
		SELECT DISTINCT GAC.AccountID INTO v_AccountID
		FROM RMBilling3.tblGatewayAccount GAC
		WHERE GAC.CompanyID = p_CompanyID
		AND AccountID IS NOT NULL
		AND  FIND_IN_SET(GAC.GatewayAccountID, p_IPs) > 0
		LIMIT 1;

	IF v_AccountID = 0
	THEN
		SELECT DISTINCT AccountID INTO v_AccountID FROM tblUsageHeader UH
			WHERE UH.CompanyID = p_CompanyID
			AND AccountID IS NOT NULL
			AND  FIND_IN_SET(UH.CompanyGatewayID, p_IPs) > 0
			LIMIT 1;
	END IF;

	IF v_AccountID = 0
	THEN
		SELECT DISTINCT AccountID INTO v_AccountID FROM tblVendorCDRHeader VH
			WHERE VH.CompanyID = p_CompanyID
			AND AccountID IS NOT NULL
			AND  FIND_IN_SET(VH.GatewayAccountID, p_IPs) > 0
			LIMIT 1;
	END IF;
	IF v_AccountID >0 AND p_Confirm = 1 THEN
			UPDATE RMBilling3.tblGatewayAccount GAC SET GAC.AccountID = NULL
			WHERE GAC.CompanyID = p_CompanyID
			AND  FIND_IN_SET(GAC.GatewayAccountID, p_IPs) > 0;

			Update tblUsageHeader SET AccountID = NULL
			WHERE CompanyID = p_CompanyID
			AND FIND_IN_SET(GatewayAccountID,p_IPs)>0
			AND StartDate >= p_StartDate;

			Update tblVendorCDRHeader SET AccountID = NULL
			WHERE CompanyID = p_CompanyID
			AND FIND_IN_SET(GatewayAccountID,p_IPs)>0
			AND StartDate >= p_StartDate;
	SET v_AccountID = -1;
	END IF;

	SELECT v_AccountID as `Status`;

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;

DELIMITER |
CREATE PROCEDURE `prc_insertCDR`(
	IN `p_processId` varchar(200),
	IN `p_tbltempusagedetail_name` VARCHAR(200)
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SET SESSION innodb_lock_wait_timeout = 180;




    set @stm2 = CONCAT('
	insert into   tblUsageHeader (CompanyID,CompanyGatewayID,GatewayAccountID,AccountID,StartDate,created_at)
	select distinct d.CompanyID,d.CompanyGatewayID,d.GatewayAccountID,d.AccountID,DATE_FORMAT(connect_time,"%Y-%m-%d"),NOW()
	from `' , p_tbltempusagedetail_name , '` d
	left join tblUsageHeader h
		on h.CompanyID = d.CompanyID
		AND h.CompanyGatewayID = d.CompanyGatewayID
		AND h.GatewayAccountID = d.GatewayAccountID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
		where h.GatewayAccountID is null and processid = "' , p_processId , '";
	');

    PREPARE stmt2 FROM @stm2;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;


	set @stm3 = CONCAT('
	insert into tblUsageDetailFailedCall (UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition)
	select UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition
		 from  `' , p_tbltempusagedetail_name , '` d inner join tblUsageHeader h	 on h.CompanyID = d.CompanyID
		AND h.CompanyGatewayID = d.CompanyGatewayID
		AND h.GatewayAccountID = d.GatewayAccountID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
	where   processid = "' , p_processId , '"
	and billed_duration = 0 and cost = 0 AND ( disposition <> "ANSWERED" or disposition IS NULL);
	');

    PREPARE stmt3 FROM @stm3;
    EXECUTE stmt3;
    DEALLOCATE PREPARE stmt3;


	set @stm4 = CONCAT('
	DELETE FROM `' , p_tbltempusagedetail_name , '` WHERE processid = "' , p_processId , '"  and billed_duration = 0 and cost = 0 AND ( disposition <> "ANSWERED" or disposition IS NULL);
	');

    PREPARE stmt4 FROM @stm4;
    EXECUTE stmt4;
    DEALLOCATE PREPARE stmt4;

	set @stm5 = CONCAT('
	insert into tblUsageDetails (UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition)
	select UsageHeaderID,connect_time,disconnect_time,billed_duration,billed_second,area_prefix,pincode,extension,cli,cld,cost,remote_ip,duration,trunk,ProcessID,ID,is_inbound,disposition
		 from  `' , p_tbltempusagedetail_name , '` d inner join tblUsageHeader h	 on h.CompanyID = d.CompanyID
		AND h.CompanyGatewayID = d.CompanyGatewayID
		AND h.GatewayAccountID = d.GatewayAccountID
		AND h.StartDate = DATE_FORMAT(connect_time,"%Y-%m-%d")
	where   processid = "' , p_processId , '" ;
	');
    PREPARE stmt5 FROM @stm5;
    EXECUTE stmt5;
    DEALLOCATE PREPARE stmt5;

 	set @stm6 = CONCAT('
	DELETE FROM `' , p_tbltempusagedetail_name , '` WHERE processid = "' , p_processId , '" ;
	');
    PREPARE stmt6 FROM @stm6;
    EXECUTE stmt6;
    DEALLOCATE PREPARE stmt6;



	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END|
DELIMITER ;


-- StagingReport

-- Girish
USE `StagingReport`;

DROP PROCEDURE IF EXISTS `prc_updateUnbilledAmount`;
DELIMITER |
CREATE PROCEDURE `prc_updateUnbilledAmount`(
	IN `p_CompanyID` INT,
	IN `p_Today` DATETIME
)
BEGIN

	DECLARE v_Round_ INT;
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_LastInvoiceDate_ DATE;
	DECLARE v_FinalAmount_ DOUBLE;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	DROP TEMPORARY TABLE IF EXISTS tmp_Account_;
	CREATE TEMPORARY TABLE tmp_Account_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		LastInvoiceDate DATE
	);

	INSERT INTO tmp_Account_ (AccountID)
	SELECT DISTINCT tblSummaryHeader.AccountID  FROM tblSummaryHeader INNER JOIN Ratemanagement3.tblAccount ON tblAccount.AccountID = tblSummaryHeader.AccountID WHERE tblSummaryHeader.CompanyID = p_CompanyID;

	UPDATE tmp_Account_ SET LastInvoiceDate = fngetLastInvoiceDate(AccountID);

	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*) FROM tmp_Account_);

	WHILE v_pointer_ <= v_rowCount_
	DO
		SET v_AccountID_ = (SELECT AccountID FROM tmp_Account_ t WHERE t.RowID = v_pointer_);
		SET v_LastInvoiceDate_ = (SELECT LastInvoiceDate FROM tmp_Account_ t WHERE t.RowID = v_pointer_);

		CALL prc_getUnbilledReport(p_CompanyID,v_AccountID_,v_LastInvoiceDate_,p_Today,3);

		SELECT FinalAmount INTO v_FinalAmount_ FROM tmp_FinalAmount_;

		IF (SELECT COUNT(*) FROM Ratemanagement3.tblAccountBalance WHERE AccountID = v_AccountID_) > 0
		THEN
			UPDATE Ratemanagement3.tblAccountBalance SET UnbilledAmount = v_FinalAmount_ WHERE AccountID = v_AccountID_;
		ELSE
			INSERT INTO Ratemanagement3.tblAccountBalance (AccountID,UnbilledAmount,BalanceAmount)
			SELECT v_AccountID_,v_FinalAmount_,v_FinalAmount_;
		END IF;

		SET v_pointer_ = v_pointer_ + 1;

	END WHILE;

	UPDATE
		Ratemanagement3.tblAccountBalance
	INNER JOIN
		(
			SELECT
				DISTINCT tblAccount.AccountID
			FROM Ratemanagement3.tblAccount
			LEFT JOIN tmp_Account_
				ON tblAccount.AccountID = tmp_Account_.AccountID
			WHERE tmp_Account_.AccountID IS NULL AND tblAccount.CompanyID = p_CompanyID
		) TBL
	ON TBL.AccountID = tblAccountBalance.AccountID
	SET UnbilledAmount = 0;

	CALL prc_updateVendorUnbilledAmount(p_CompanyID,p_Today);

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;

-- Dumping structure for procedure StagingReport.prc_updateVendorUnbilledAmount
DROP PROCEDURE IF EXISTS `prc_updateVendorUnbilledAmount`;
DELIMITER |
CREATE  PROCEDURE `prc_updateVendorUnbilledAmount`(
	IN `p_CompanyID` INT,
	IN `p_Today` DATETIME
)
BEGIN

	DECLARE v_Round_ INT;
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_LastInvoiceDate_ DATETIME;
	DECLARE v_FinalAmount_ DOUBLE;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	DROP TEMPORARY TABLE IF EXISTS tmp_Account_;
	CREATE TEMPORARY TABLE tmp_Account_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		LastInvoiceDate DATETIME
	);

	INSERT INTO tmp_Account_ (AccountID)
	SELECT DISTINCT tblSummaryVendorHeader.AccountID  FROM tblSummaryVendorHeader INNER JOIN Ratemanagement3.tblAccount ON tblAccount.AccountID = tblSummaryVendorHeader.AccountID WHERE tblSummaryVendorHeader.CompanyID = p_CompanyID;

	UPDATE tmp_Account_ SET LastInvoiceDate = fngetLastVendorInvoiceDate(AccountID);

	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*) FROM tmp_Account_);

	WHILE v_pointer_ <= v_rowCount_
	DO
		SET v_AccountID_ = (SELECT AccountID FROM tmp_Account_ t WHERE t.RowID = v_pointer_);
		SET v_LastInvoiceDate_ = (SELECT LastInvoiceDate FROM tmp_Account_ t WHERE t.RowID = v_pointer_);

		IF v_LastInvoiceDate_ IS NOT NULL
		THEN

			CALL prc_getVendorUnbilledReport(p_CompanyID,v_AccountID_,v_LastInvoiceDate_,p_Today,3);

			SELECT FinalAmount INTO v_FinalAmount_ FROM tmp_FinalAmount_;

			IF (SELECT COUNT(*) FROM Ratemanagement3.tblAccountBalance WHERE AccountID = v_AccountID_) > 0
			THEN
				UPDATE Ratemanagement3.tblAccountBalance SET VendorUnbilledAmount = v_FinalAmount_ WHERE AccountID = v_AccountID_;
			ELSE
				INSERT INTO Ratemanagement3.tblAccountBalance (AccountID,VendorUnbilledAmount,BalanceAmount)
				SELECT v_AccountID_,v_FinalAmount_,v_FinalAmount_;
			END IF;

		END IF;

		SET v_pointer_ = v_pointer_ + 1;

	END WHILE;

	UPDATE
		Ratemanagement3.tblAccountBalance
	INNER JOIN
		(
			SELECT
				DISTINCT tblAccount.AccountID
			FROM Ratemanagement3.tblAccount
			LEFT JOIN tmp_Account_
				ON tblAccount.AccountID = tmp_Account_.AccountID
			WHERE tmp_Account_.AccountID IS NULL AND tblAccount.CompanyID = p_CompanyID
		) TBL
	ON TBL.AccountID = tblAccountBalance.AccountID
	SET VendorUnbilledAmount = 0;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END|
DELIMITER ;