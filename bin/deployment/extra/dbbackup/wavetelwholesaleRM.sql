-- MySQL dump 10.13  Distrib 5.7.11, for Linux (x86_64)
--
-- Host: localhost    Database: wavetelwholesaleRM
-- ------------------------------------------------------
-- Server version	5.7.11

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `AccountEmailLog`
--

DROP TABLE IF EXISTS `AccountEmailLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AccountEmailLog` (
  `AccountEmailLogID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `ContactID` int(11) DEFAULT NULL,
  `UserType` tinyint(4) DEFAULT '0' COMMENT '0 for account,1 for contact',
  `UserID` int(11) DEFAULT NULL,
  `JobId` int(11) DEFAULT NULL,
  `ProcessID` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `Emailfrom` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailTo` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Subject` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Message` longtext COLLATE utf8_unicode_ci,
  `Cc` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Bcc` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AttachmentPaths` longtext COLLATE utf8_unicode_ci,
  `EmailType` int(11) DEFAULT '0',
  `EmailfromName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `MessageID` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailParent` int(11) NOT NULL DEFAULT '0',
  `EmailID` int(11) NOT NULL DEFAULT '0',
  `EmailCall` int(11) NOT NULL DEFAULT '0' COMMENT '0 for sent,1 for received, 2 for draft',
  PRIMARY KEY (`AccountEmailLogID`)
) ENGINE=InnoDB AUTO_INCREMENT=15969 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TMPtblRate`
--

DROP TABLE IF EXISTS `TMPtblRate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TMPtblRate` (
  `RateID` int(11) NOT NULL AUTO_INCREMENT,
  `CountryID` int(11) DEFAULT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  `CodeDeckId` int(11) DEFAULT NULL,
  `Code` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Description` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `Country__tobe_delete` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Interval1` int(11) DEFAULT '1',
  `IntervalN` int(11) DEFAULT '1',
  PRIMARY KEY (`RateID`)
) ENGINE=InnoDB AUTO_INCREMENT=448987 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `queue` longtext COLLATE utf8_unicode_ci,
  `payload` longtext COLLATE utf8_unicode_ci,
  `attempts` int(11) DEFAULT NULL,
  `reserved` int(11) DEFAULT NULL,
  `reserved_at` int(11) DEFAULT NULL,
  `available_at` int(11) DEFAULT NULL,
  `created_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrations` (
  `migration` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quickbooks_config`
--

DROP TABLE IF EXISTS `quickbooks_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quickbooks_config` (
  `quickbooks_config_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `qb_username` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `module` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `cfgkey` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `cfgval` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `cfgtype` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `cfgopts` text COLLATE utf8_unicode_ci NOT NULL,
  `write_datetime` datetime NOT NULL,
  `mod_datetime` datetime NOT NULL,
  PRIMARY KEY (`quickbooks_config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quickbooks_log`
--

DROP TABLE IF EXISTS `quickbooks_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quickbooks_log` (
  `quickbooks_log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `quickbooks_ticket_id` int(10) unsigned DEFAULT NULL,
  `batch` int(10) unsigned NOT NULL,
  `msg` text COLLATE utf8_unicode_ci NOT NULL,
  `log_datetime` datetime NOT NULL,
  PRIMARY KEY (`quickbooks_log_id`),
  KEY `batch` (`batch`),
  KEY `quickbooks_ticket_id` (`quickbooks_ticket_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quickbooks_oauth`
--

DROP TABLE IF EXISTS `quickbooks_oauth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quickbooks_oauth` (
  `quickbooks_oauth_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `app_username` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `app_tenant` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `oauth_request_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `oauth_request_token_secret` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `oauth_access_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `oauth_access_token_secret` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qb_realm` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qb_flavor` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qb_user` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `request_datetime` datetime NOT NULL,
  `access_datetime` datetime DEFAULT NULL,
  `touch_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`quickbooks_oauth_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quickbooks_queue`
--

DROP TABLE IF EXISTS `quickbooks_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quickbooks_queue` (
  `quickbooks_queue_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `quickbooks_ticket_id` int(10) unsigned DEFAULT NULL,
  `qb_username` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `qb_action` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `ident` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `extra` text COLLATE utf8_unicode_ci,
  `qbxml` text COLLATE utf8_unicode_ci,
  `priority` int(10) unsigned DEFAULT '0',
  `qb_status` char(1) COLLATE utf8_unicode_ci NOT NULL,
  `msg` text COLLATE utf8_unicode_ci,
  `enqueue_datetime` datetime NOT NULL,
  `dequeue_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`quickbooks_queue_id`),
  KEY `priority` (`priority`),
  KEY `qb_status` (`qb_status`),
  KEY `qb_username` (`qb_username`,`qb_action`,`ident`,`qb_status`),
  KEY `quickbooks_ticket_id` (`quickbooks_ticket_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quickbooks_recur`
--

DROP TABLE IF EXISTS `quickbooks_recur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quickbooks_recur` (
  `quickbooks_recur_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `qb_username` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `qb_action` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `ident` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `extra` text COLLATE utf8_unicode_ci,
  `qbxml` text COLLATE utf8_unicode_ci,
  `priority` int(10) unsigned DEFAULT '0',
  `run_every` int(10) unsigned NOT NULL,
  `recur_lasttime` int(10) unsigned NOT NULL,
  `enqueue_datetime` datetime NOT NULL,
  PRIMARY KEY (`quickbooks_recur_id`),
  KEY `priority` (`priority`),
  KEY `qb_username` (`qb_username`,`qb_action`,`ident`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quickbooks_ticket`
--

DROP TABLE IF EXISTS `quickbooks_ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quickbooks_ticket` (
  `quickbooks_ticket_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `qb_username` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `ticket` char(36) COLLATE utf8_unicode_ci NOT NULL,
  `processed` int(10) unsigned DEFAULT '0',
  `lasterror_num` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lasterror_msg` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ipaddr` char(15) COLLATE utf8_unicode_ci NOT NULL,
  `write_datetime` datetime NOT NULL,
  `touch_datetime` datetime NOT NULL,
  PRIMARY KEY (`quickbooks_ticket_id`),
  KEY `ticket` (`ticket`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quickbooks_user`
--

DROP TABLE IF EXISTS `quickbooks_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quickbooks_user` (
  `qb_username` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `qb_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `qb_company_file` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qbwc_wait_before_next_update` int(10) unsigned DEFAULT '0',
  `qbwc_min_run_every_n_seconds` int(10) unsigned DEFAULT '0',
  `status` char(1) COLLATE utf8_unicode_ci NOT NULL,
  `write_datetime` datetime NOT NULL,
  `touch_datetime` datetime NOT NULL,
  PRIMARY KEY (`qb_username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccount`
--

DROP TABLE IF EXISTS `tblAccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccount` (
  `AccountID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountType` tinyint(3) unsigned DEFAULT NULL,
  `CompanyId` int(11) DEFAULT NULL,
  `CurrencyId` int(11) DEFAULT NULL,
  `Title` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Owner` int(11) DEFAULT NULL,
  `Number` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `NamePrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FirstName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LastName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LeadStatus` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Rating` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LeadSource` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Skype` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailOptOut` tinyint(1) DEFAULT NULL,
  `Twitter` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SecondaryEmail` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Email` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IsVendor` tinyint(1) DEFAULT NULL,
  `IsCustomer` tinyint(1) DEFAULT NULL,
  `Ownership` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Website` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Phone` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Fax` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Employee` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` longtext COLLATE utf8_unicode_ci,
  `Address1` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address2` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address3` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `City` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `State` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PostCode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Country` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `RateEmail` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillingEmail` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TechnicalEmail` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `VatNumber` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Status` int(11) DEFAULT NULL,
  `PaymentMethod` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PaymentDetail` longtext COLLATE utf8_unicode_ci,
  `Converted` tinyint(1) DEFAULT NULL,
  `ConvertedDate` datetime DEFAULT NULL,
  `ConvertedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TimeZone` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `VerificationStatus` tinyint(3) unsigned DEFAULT '0',
  `Subscription` tinyint(1) DEFAULT '0',
  `SubscriptionQty` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` longtext COLLATE utf8_unicode_ci,
  `Picture` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AutorizeProfileID` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tags` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Autopay` tinyint(3) unsigned DEFAULT NULL,
  `NominalAnalysisNominalAccountNumber` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `InboudRateTableID` int(11) DEFAULT NULL,
  `ResellerEmail` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Billing` tinyint(1) DEFAULT '0',
  `Blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`AccountID`),
  KEY `IX_tblAccount_AccountType_CompanyId_IsVendor_Status_Verificati10` (`AccountType`,`CompanyId`,`IsVendor`,`Status`,`VerificationStatus`,`AccountName`),
  KEY `CurrencyId` (`CurrencyId`),
  KEY `IX_tblAccount_CompanyId_AccountName_AccountID_5E166` (`CompanyId`,`AccountName`),
  KEY `IX_tblAccount_AccountType_CompanyId_Status_738CD` (`AccountType`,`CompanyId`,`Status`,`AccountName`)
) ENGINE=InnoDB AUTO_INCREMENT=3487 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccountActivity`
--

DROP TABLE IF EXISTS `tblAccountActivity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountActivity` (
  `ActivityID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `Title` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Date` datetime DEFAULT NULL,
  `ActivityType` tinyint(3) unsigned NOT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ActivityID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccountApproval`
--

DROP TABLE IF EXISTS `tblAccountApproval`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountApproval` (
  `AccountApprovalID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyId` int(11) NOT NULL,
  `CountryId` int(11) DEFAULT NULL,
  `Key` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Required` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `AccountType` tinyint(3) unsigned DEFAULT NULL,
  `Status` tinyint(3) unsigned DEFAULT NULL,
  `DocumentFile` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Infomsg` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillingType` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`AccountApprovalID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccountApprovalList`
--

DROP TABLE IF EXISTS `tblAccountApprovalList`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountApprovalList` (
  `AccountApprovalListID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyId` int(11) NOT NULL,
  `AccountApprovalID` int(11) NOT NULL,
  `AccountID` int(11) NOT NULL,
  `FileName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`AccountApprovalListID`),
  KEY `FK_tblAccountApprovalList_tblAccountApproval` (`AccountApprovalID`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccountAuthenticate`
--

DROP TABLE IF EXISTS `tblAccountAuthenticate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountAuthenticate` (
  `AccountAuthenticateID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `AccountID` int(11) NOT NULL,
  `CustomerAuthRule` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CustomerAuthValue` varchar(8000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `VendorAuthRule` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `VendorAuthValue` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`AccountAuthenticateID`),
  KEY `IX_AccountID` (`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=1063 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccountBalance`
--

DROP TABLE IF EXISTS `tblAccountBalance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountBalance` (
  `AccountBalanceID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountID` int(11) NOT NULL DEFAULT '0',
  `PermanentCredit` decimal(18,6) DEFAULT NULL,
  `TemporaryCredit` decimal(18,6) DEFAULT NULL,
  `TemporaryCreditDateTime` datetime DEFAULT NULL,
  `BalanceThreshold` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BalanceAmount` decimal(18,6) DEFAULT NULL,
  `EmailToCustomer` tinyint(4) DEFAULT '0',
  `UnbilledAmount` decimal(18,6) DEFAULT NULL,
  `SOAOffset` decimal(18,6) DEFAULT NULL,
  `VendorUnbilledAmount` decimal(18,6) DEFAULT NULL,
  PRIMARY KEY (`AccountBalanceID`),
  UNIQUE KEY `AccountID` (`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=3078 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccountBalanceHistory`
--

DROP TABLE IF EXISTS `tblAccountBalanceHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountBalanceHistory` (
  `AccountBalanceHistoryID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountID` int(11) NOT NULL DEFAULT '0',
  `PermanentCredit` decimal(18,6) DEFAULT NULL,
  `TemporaryCredit` decimal(18,6) DEFAULT NULL,
  `BalanceThreshold` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`AccountBalanceHistoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=163 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccountBilling`
--

DROP TABLE IF EXISTS `tblAccountBilling`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountBilling` (
  `AccountBillingID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountID` int(11) NOT NULL DEFAULT '0',
  `PaymentDueInDays` int(11) DEFAULT NULL,
  `RoundChargesAmount` int(11) DEFAULT NULL,
  `CDRType` int(11) DEFAULT NULL,
  `InvoiceTemplateID` int(11) DEFAULT NULL,
  `BillingType` tinyint(3) unsigned DEFAULT NULL,
  `TaxRateId` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillingTimezone` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillingCycleType` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillingCycleValue` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SendInvoiceSetting` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillingStartDate` date DEFAULT NULL,
  `LastInvoiceDate` date DEFAULT NULL,
  `NextInvoiceDate` date DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `BillingClassID` int(11) DEFAULT NULL,
  PRIMARY KEY (`AccountBillingID`),
  UNIQUE KEY `AccountID` (`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=2230 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccountBillingPeriod`
--

DROP TABLE IF EXISTS `tblAccountBillingPeriod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountBillingPeriod` (
  `AccountBillingPeriodID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountID` int(11) NOT NULL DEFAULT '0',
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  PRIMARY KEY (`AccountBillingPeriodID`)
) ENGINE=InnoDB AUTO_INCREMENT=13501 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccountDiscountPlan`
--

DROP TABLE IF EXISTS `tblAccountDiscountPlan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountDiscountPlan` (
  `AccountDiscountPlanID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountID` int(11) NOT NULL,
  `DiscountPlanID` int(11) NOT NULL,
  `Type` tinyint(4) DEFAULT '1',
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`AccountDiscountPlanID`),
  UNIQUE KEY `AccountID` (`Type`,`AccountID`),
  KEY `FK_tblAccountDiscountPlan_tblDiscountPlan` (`DiscountPlanID`),
  CONSTRAINT `tblAccountDiscountPlan_ibfk_1` FOREIGN KEY (`DiscountPlanID`) REFERENCES `tblDiscountPlan` (`DiscountPlanID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccountDiscountPlanHistory`
--

DROP TABLE IF EXISTS `tblAccountDiscountPlanHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountDiscountPlanHistory` (
  `AccountDiscountPlanHistoryID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountID` int(11) NOT NULL,
  `AccountDiscountPlanID` int(11) NOT NULL,
  `DiscountPlanID` int(11) NOT NULL,
  `Type` tinyint(4) DEFAULT '1',
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Applied` datetime DEFAULT NULL,
  `Changed` datetime DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`AccountDiscountPlanHistoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccountDiscountScheme`
--

DROP TABLE IF EXISTS `tblAccountDiscountScheme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountDiscountScheme` (
  `AccountDiscountSchemeID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountDiscountPlanID` int(11) NOT NULL,
  `DiscountID` int(11) NOT NULL,
  `Threshold` int(11) NOT NULL,
  `Discount` int(11) NOT NULL,
  `Unlimited` tinyint(1) NOT NULL DEFAULT '0',
  `SecondsUsed` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`AccountDiscountSchemeID`),
  KEY `FK_tblAccountDiscountScheme_tblAccountDiscountPlan` (`AccountDiscountPlanID`),
  KEY `FK_tblAccountDiscountScheme_tblDiscount` (`DiscountID`),
  CONSTRAINT `tblAccountDiscountScheme_ibfk_1` FOREIGN KEY (`AccountDiscountPlanID`) REFERENCES `tblAccountDiscountPlan` (`AccountDiscountPlanID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `tblAccountDiscountScheme_ibfk_2` FOREIGN KEY (`DiscountID`) REFERENCES `tblDiscount` (`DiscountID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccountDiscountSchemeHistory`
--

DROP TABLE IF EXISTS `tblAccountDiscountSchemeHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountDiscountSchemeHistory` (
  `AccountDiscountSchemeHistoryID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountDiscountSchemeID` int(11) NOT NULL,
  `AccountDiscountPlanID` int(11) NOT NULL,
  `DiscountID` int(11) NOT NULL,
  `Threshold` int(11) NOT NULL,
  `Discount` int(11) NOT NULL,
  `Unlimited` tinyint(1) NOT NULL DEFAULT '0',
  `SecondsUsed` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`AccountDiscountSchemeHistoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccountNextBilling`
--

DROP TABLE IF EXISTS `tblAccountNextBilling`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountNextBilling` (
  `AccountNextBillingID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountID` int(11) NOT NULL DEFAULT '0',
  `BillingCycleType` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillingCycleValue` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LastInvoiceDate` date DEFAULT NULL,
  `NextInvoiceDate` date DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`AccountNextBillingID`),
  UNIQUE KEY `AccountID` (`AccountID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccountPaymentProfile`
--

DROP TABLE IF EXISTS `tblAccountPaymentProfile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountPaymentProfile` (
  `AccountPaymentProfileID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `AccountID` int(11) NOT NULL,
  `PaymentGatewayID` int(11) NOT NULL,
  `Title` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Options` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Status` tinyint(3) unsigned DEFAULT NULL,
  `isDefault` tinyint(3) unsigned DEFAULT NULL,
  `Blocked` tinyint(3) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`AccountPaymentProfileID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccountTickets`
--

DROP TABLE IF EXISTS `tblAccountTickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountTickets` (
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
  `ApiCreatedDate` datetime DEFAULT NULL,
  `ApiUpdateDate` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=231 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Fresh desk tickets will save  here temporarily\r\nprc_getAccountTimeLine will use it';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAlert`
--

DROP TABLE IF EXISTS `tblAlert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAlert` (
  `AlertID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `Name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AlertType` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AlertGroup` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Status` tinyint(4) DEFAULT NULL,
  `LowValue` int(11) DEFAULT NULL,
  `HighValue` int(11) DEFAULT NULL,
  `Settings` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `UpdatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedByCustomer` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`AlertID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAlertLog`
--

DROP TABLE IF EXISTS `tblAlertLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAlertLog` (
  `AlertLogID` int(11) NOT NULL AUTO_INCREMENT,
  `AlertID` int(11) DEFAULT NULL,
  `AccountEmailLogID` int(11) DEFAULT NULL,
  `send_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `SendBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`AlertLogID`)
) ENGINE=InnoDB AUTO_INCREMENT=707 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblBillingClass`
--

DROP TABLE IF EXISTS `tblBillingClass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblBillingClass` (
  `BillingClassID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `PaymentDueInDays` int(11) DEFAULT NULL,
  `RoundChargesAmount` int(11) DEFAULT NULL,
  `CDRType` int(11) DEFAULT NULL,
  `InvoiceTemplateID` int(11) DEFAULT NULL,
  `Name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TaxRateID` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillingTimezone` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SendInvoiceSetting` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PaymentReminderStatus` tinyint(4) DEFAULT NULL,
  `PaymentReminderSettings` varchar(5000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `InvoiceReminderStatus` tinyint(4) DEFAULT NULL,
  `InvoiceReminderSettings` varchar(5000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LowBalanceReminderStatus` tinyint(4) DEFAULT NULL,
  `LowBalanceReminderSettings` varchar(5000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `UpdatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`BillingClassID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCLIRateTable`
--

DROP TABLE IF EXISTS `tblCLIRateTable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCLIRateTable` (
  `CLIRateTableID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `AccountID` int(11) NOT NULL,
  `CLI` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `RateTableID` int(11) NOT NULL,
  PRIMARY KEY (`CLIRateTableID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCRMBoardColumn`
--

DROP TABLE IF EXISTS `tblCRMBoardColumn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCRMBoardColumn` (
  `BoardColumnID` int(11) NOT NULL AUTO_INCREMENT,
  `BoardID` int(11) NOT NULL,
  `CompanyID` int(11) NOT NULL,
  `BoardColumnName` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Height` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Width` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Order` int(11) NOT NULL,
  `SetCompleted` tinyint(4) NOT NULL DEFAULT '0',
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`BoardColumnID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCRMBoards`
--

DROP TABLE IF EXISTS `tblCRMBoards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCRMBoards` (
  `BoardID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `BoardName` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Status` tinyint(4) NOT NULL DEFAULT '1',
  `BoardType` int(11) NOT NULL DEFAULT '1',
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`BoardID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCRMComments`
--

DROP TABLE IF EXISTS `tblCRMComments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCRMComments` (
  `CommentID` int(11) NOT NULL AUTO_INCREMENT,
  `ParentID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `CommentText` longtext COLLATE utf8_unicode_ci,
  `AttachmentPaths` longtext COLLATE utf8_unicode_ci,
  `CommentType` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CompanyID` int(11) NOT NULL,
  PRIMARY KEY (`CommentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCRMTemplate`
--

DROP TABLE IF EXISTS `tblCRMTemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCRMTemplate` (
  `TemplateID` char(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TemplateName` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Subject` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TemplateBody` longtext COLLATE utf8_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblChargeCode`
--

DROP TABLE IF EXISTS `tblChargeCode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblChargeCode` (
  `Prefix` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ChargeCode` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  KEY `ChargeCode` (`ChargeCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCodeDeck`
--

DROP TABLE IF EXISTS `tblCodeDeck`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCodeDeck` (
  `CodeDeckId` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyId` int(11) NOT NULL,
  `CodeDeckName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Type` tinyint(3) unsigned DEFAULT NULL,
  `DefaultCodedeck` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`CodeDeckId`),
  UNIQUE KEY `IXUnique_CodeDeckName_CompanyId` (`CodeDeckName`,`CompanyId`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCompany`
--

DROP TABLE IF EXISTS `tblCompany`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCompany` (
  `CompanyID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyName` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `VAT` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CustomerAccountPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FirstName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LastName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Email` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Phone` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SMTPServer` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SMTPUsername` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SMTPPassword` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Port` int(11) DEFAULT NULL,
  `IsSSL` tinyint(3) unsigned DEFAULT NULL,
  `EmailFrom` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `InvoiceBCCAddress` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AutoProcessResultEmailTo` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FileLocation` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `VendorRateIncreaseWarningEmail` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `RateEmailFrom` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ServerUsername` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ServerPassword` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `NetworkFileLocation` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `City` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PostCode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Country` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address1` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address2` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address3` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Status` tinyint(3) unsigned DEFAULT '0',
  `TimeZone` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CurrencyId` int(11) DEFAULT NULL,
  `PaymentRequestEmail` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `DueSheetEmail` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `InvoiceGenerationEmail` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `RateSheetExcellNote` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `InvoiceStatus` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`CompanyID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCompanyConfiguration`
--

DROP TABLE IF EXISTS `tblCompanyConfiguration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCompanyConfiguration` (
  `CompanyConfigurationID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `Key` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Value` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`CompanyConfigurationID`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCompanyGateway`
--

DROP TABLE IF EXISTS `tblCompanyGateway`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCompanyGateway` (
  `CompanyGatewayID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `GatewayID` int(11) DEFAULT NULL,
  `Title` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Settings` longtext COLLATE utf8_unicode_ci,
  `Status` tinyint(3) unsigned DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `TimeZone` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillingTime` tinyint(3) unsigned DEFAULT NULL,
  `BillingTimeZone` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `UniqueID` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`CompanyGatewayID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCompanySetting`
--

DROP TABLE IF EXISTS `tblCompanySetting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCompanySetting` (
  `CompanyID` int(11) NOT NULL,
  `Key` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Value` longtext COLLATE utf8_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCompanyThemes`
--

DROP TABLE IF EXISTS `tblCompanyThemes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCompanyThemes` (
  `ThemeID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL DEFAULT '0',
  `DomainUrl` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `Logo` varchar(500) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `Favicon` varchar(500) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `Title` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `FooterText` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `FooterUrl` varchar(500) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `LoginMessage` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `CustomCss` text COLLATE utf8_unicode_ci,
  `ThemeStatus` enum('inactive','active') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'active',
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ThemeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblContact`
--

DROP TABLE IF EXISTS `tblContact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblContact` (
  `ContactID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyId` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `Title` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Owner` int(11) DEFAULT NULL,
  `Department` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `NamePrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FirstName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LastName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `DateOfBirth` date DEFAULT NULL,
  `Skype` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailOptOut` tinyint(1) DEFAULT NULL,
  `Twitter` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Email` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SecondaryEmail` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `HomePhone` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Phone` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Fax` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `OtherPhone` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` longtext COLLATE utf8_unicode_ci,
  `Address1` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address2` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address3` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `City` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `State` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PostCode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Country` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ContactID`),
  KEY `UserID` (`Owner`)
) ENGINE=InnoDB AUTO_INCREMENT=344 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblContactNote`
--

DROP TABLE IF EXISTS `tblContactNote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblContactNote` (
  `NoteID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `ContactID` int(11) NOT NULL,
  `Title` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Note` longtext COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`NoteID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCountry`
--

DROP TABLE IF EXISTS `tblCountry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCountry` (
  `CountryID` int(11) NOT NULL AUTO_INCREMENT,
  `Prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Country` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ISO2` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ISO3` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`CountryID`)
) ENGINE=InnoDB AUTO_INCREMENT=285 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCronJob`
--

DROP TABLE IF EXISTS `tblCronJob`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCronJob` (
  `CronJobID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CronJobCommandID` int(11) DEFAULT NULL,
  `Settings` longtext COLLATE utf8_unicode_ci,
  `Status` tinyint(3) unsigned NOT NULL,
  `LastRunTime` datetime DEFAULT NULL,
  `NextRunTime` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Active` int(11) DEFAULT '0',
  `JobTitle` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `DownloadActive` int(11) DEFAULT '0',
  `PID` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailSendTime` datetime DEFAULT NULL,
  `CdrBehindEmailSendTime` datetime DEFAULT NULL,
  `CdrBehindDuration` int(11) DEFAULT NULL,
  PRIMARY KEY (`CronJobID`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCronJobCommand`
--

DROP TABLE IF EXISTS `tblCronJobCommand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCronJobCommand` (
  `CronJobCommandID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `GatewayID` int(11) DEFAULT NULL,
  `Title` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Command` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Settings` longtext COLLATE utf8_unicode_ci,
  `Status` tinyint(3) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`CronJobCommandID`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCronJobLog`
--

DROP TABLE IF EXISTS `tblCronJobLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCronJobLog` (
  `CronJobLogID` int(11) NOT NULL AUTO_INCREMENT,
  `CronJobID` int(11) NOT NULL,
  `CronJobStatus` tinyint(3) unsigned DEFAULT NULL,
  `Message` longtext COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`CronJobLogID`),
  KEY `IX_created_at` (`CronJobID`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3760183 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCurrency`
--

DROP TABLE IF EXISTS `tblCurrency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCurrency` (
  `CurrencyId` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyId` int(11) NOT NULL,
  `Code` varchar(3) COLLATE utf8_unicode_ci NOT NULL,
  `Description` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Status` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Symbol` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`CurrencyId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCurrencyConversion`
--

DROP TABLE IF EXISTS `tblCurrencyConversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCurrencyConversion` (
  `ConversionID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CurrencyID` int(11) NOT NULL,
  `Value` decimal(18,6) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EffectiveDate` datetime DEFAULT NULL,
  PRIMARY KEY (`ConversionID`),
  KEY `IX_CurrencyID_CompanyID` (`CurrencyID`,`CompanyID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCurrencyConversionLog`
--

DROP TABLE IF EXISTS `tblCurrencyConversionLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCurrencyConversionLog` (
  `ConversionLogID` int(11) NOT NULL AUTO_INCREMENT,
  `CurrencyID` int(11) NOT NULL,
  `CompanyID` int(11) NOT NULL,
  `EffectiveDate` datetime NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `Value` decimal(18,6) DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ConversionLogID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCurrencyExchange`
--

DROP TABLE IF EXISTS `tblCurrencyExchange`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCurrencyExchange` (
  `CurrencyExchangeID` int(11) NOT NULL AUTO_INCREMENT,
  `FromCurrencyID` int(11) NOT NULL,
  `ToCurrencyID` int(11) NOT NULL,
  `Rate` decimal(18,6) DEFAULT NULL,
  `InverseRate` decimal(18,6) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `createdby` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updatedby` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`CurrencyExchangeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCustomerRate`
--

DROP TABLE IF EXISTS `tblCustomerRate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCustomerRate` (
  `CustomerRateID` int(11) NOT NULL AUTO_INCREMENT,
  `RateID` int(11) NOT NULL,
  `CustomerID` int(11) NOT NULL,
  `LastModifiedDate` datetime DEFAULT NULL,
  `LastModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TrunkID` int(11) DEFAULT NULL,
  `Rate` decimal(18,6) NOT NULL DEFAULT '0.000000',
  `EffectiveDate` date DEFAULT NULL,
  `PreviousRate` decimal(18,6) DEFAULT '0.000000',
  `Interval1` int(11) DEFAULT NULL,
  `IntervalN` int(11) DEFAULT NULL,
  `RoutinePlan` int(11) DEFAULT NULL,
  `ConnectionFee` decimal(18,6) DEFAULT NULL,
  PRIMARY KEY (`CustomerRateID`),
  UNIQUE KEY `IXUnique_RateId_CustomerId_TrunkId_EffectiveDate` (`RateID`,`CustomerID`,`TrunkID`,`EffectiveDate`),
  KEY `IX_tblCustomerRate_CustomerID_9494E` (`CustomerID`),
  KEY `IX_tblCustomerRate_CustomerID_EffectiveDate_61B1F` (`CustomerID`,`EffectiveDate`),
  KEY `IX_tblCustomerRate_CustomerID_TrunkID_Rate_FDB55` (`CustomerID`,`TrunkID`,`Rate`),
  KEY `IX_tblCustomerRate_CustomerID_TrunkID_effectivedate` (`CustomerID`,`TrunkID`,`EffectiveDate`),
  CONSTRAINT `tblCustomerRate_ibfk_1` FOREIGN KEY (`RateID`) REFERENCES `tblRate` (`RateID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=34863063 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCustomerRateArchive`
--

DROP TABLE IF EXISTS `tblCustomerRateArchive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCustomerRateArchive` (
  `CustomerRateArchiveID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerRateID` int(11) NOT NULL,
  `CustomerId` int(11) NOT NULL,
  `TrunkId` int(11) NOT NULL,
  `RateId` int(11) NOT NULL,
  `Rate` decimal(18,6) NOT NULL,
  `EffectiveDate` datetime NOT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `Notes` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`CustomerRateArchiveID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCustomerRate_Backup`
--

DROP TABLE IF EXISTS `tblCustomerRate_Backup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCustomerRate_Backup` (
  `CustomerRateID` int(11) NOT NULL,
  `RateID` int(11) NOT NULL,
  `CustomerID` int(11) NOT NULL,
  `LastModifiedDate` datetime DEFAULT NULL,
  `LastModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TrunkID` int(11) DEFAULT NULL,
  `Rate` decimal(18,6) NOT NULL DEFAULT '0.000000',
  `EffectiveDate` date DEFAULT NULL,
  `PreviousRate` decimal(18,6) DEFAULT '0.000000',
  `Interval1` int(11) DEFAULT NULL,
  `IntervalN` int(11) DEFAULT NULL,
  `RoutinePlan` int(11) DEFAULT NULL,
  `ConnectionFee` decimal(18,6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCustomerTrunk`
--

DROP TABLE IF EXISTS `tblCustomerTrunk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCustomerTrunk` (
  `CustomerTrunkID` int(11) NOT NULL AUTO_INCREMENT,
  `RateTableID` bigint(20) DEFAULT NULL,
  `CompanyID` int(11) NOT NULL,
  `CodeDeckId` int(11) DEFAULT NULL,
  `AccountID` int(11) NOT NULL,
  `TrunkID` int(11) NOT NULL,
  `Prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IncludePrefix` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Status` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `RoutinePlanStatus` tinyint(3) unsigned DEFAULT NULL,
  `RateTableAssignDate` datetime DEFAULT NULL,
  `UseInBilling` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`CustomerTrunkID`),
  UNIQUE KEY `IX_AccountIDTrunkID_Unique` (`AccountID`,`TrunkID`),
  KEY `Index_AccountID_TrunkID_Status` (`TrunkID`,`AccountID`,`Status`),
  KEY `FK_tblCustomerTrunk_tblRateTable` (`RateTableID`),
  KEY `temp_index` (`AccountID`,`Status`)
) ENGINE=InnoDB AUTO_INCREMENT=4962 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblDestinationGroup`
--

DROP TABLE IF EXISTS `tblDestinationGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblDestinationGroup` (
  `DestinationGroupID` int(11) NOT NULL AUTO_INCREMENT,
  `DestinationGroupSetID` int(11) NOT NULL,
  `CompanyID` int(11) NOT NULL,
  `Name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`DestinationGroupID`),
  UNIQUE KEY `CompanyID` (`CompanyID`,`DestinationGroupSetID`,`Name`),
  KEY `FK_tblDestinationGroup_tblDestinationGroupSet` (`DestinationGroupSetID`),
  CONSTRAINT `tblDestinationGroup_ibfk_1` FOREIGN KEY (`DestinationGroupSetID`) REFERENCES `tblDestinationGroupSet` (`DestinationGroupSetID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblDestinationGroupCode`
--

DROP TABLE IF EXISTS `tblDestinationGroupCode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblDestinationGroupCode` (
  `DestinationGroupCodeID` int(11) NOT NULL AUTO_INCREMENT,
  `DestinationGroupID` int(11) NOT NULL,
  `RateID` int(11) NOT NULL,
  PRIMARY KEY (`DestinationGroupCodeID`),
  UNIQUE KEY `IX_DestinationGroupID_RateID` (`RateID`,`DestinationGroupID`),
  KEY `FK_tblDestinationGroupCode_tblDestinationGroup` (`DestinationGroupID`),
  CONSTRAINT `tblDestinationGroupCode_ibfk_1` FOREIGN KEY (`DestinationGroupID`) REFERENCES `tblDestinationGroup` (`DestinationGroupID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblDestinationGroupSet`
--

DROP TABLE IF EXISTS `tblDestinationGroupSet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblDestinationGroupSet` (
  `DestinationGroupSetID` int(11) NOT NULL AUTO_INCREMENT,
  `CodedeckID` int(11) NOT NULL,
  `Status` int(11) DEFAULT NULL,
  `CompanyID` int(11) NOT NULL,
  `Name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`DestinationGroupSetID`),
  UNIQUE KEY `GroupName` (`CompanyID`,`Name`),
  KEY `IX_CodedeckID` (`CodedeckID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblDialString`
--

DROP TABLE IF EXISTS `tblDialString`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblDialString` (
  `DialStringID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `Name` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`DialStringID`),
  UNIQUE KEY `CompanyID_Name` (`CompanyID`,`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblDialStringCode`
--

DROP TABLE IF EXISTS `tblDialStringCode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblDialStringCode` (
  `DialStringCodeID` int(11) NOT NULL AUTO_INCREMENT,
  `DialStringID` int(11) NOT NULL,
  `DialString` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `ChargeCode` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Description` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Forbidden` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`DialStringCodeID`),
  UNIQUE KEY `IXUnique_DialStringID_DialString` (`DialStringID`,`DialString`),
  KEY `IX_tblDialStringCode_DialStringID` (`DialStringID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblDiscount`
--

DROP TABLE IF EXISTS `tblDiscount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblDiscount` (
  `DiscountID` int(11) NOT NULL AUTO_INCREMENT,
  `DiscountPlanID` int(11) NOT NULL,
  `DestinationGroupID` int(11) NOT NULL,
  `Service` int(11) NOT NULL COMMENT '1=minutes;',
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `UpdatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`DiscountID`),
  KEY `FK_tblDiscount_tblDestinationGroup` (`DestinationGroupID`),
  KEY `FK_tblDiscount_tblDiscountPlan` (`DiscountPlanID`),
  CONSTRAINT `tblDiscount_ibfk_1` FOREIGN KEY (`DestinationGroupID`) REFERENCES `tblDestinationGroup` (`DestinationGroupID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `tblDiscount_ibfk_2` FOREIGN KEY (`DiscountPlanID`) REFERENCES `tblDiscountPlan` (`DiscountPlanID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblDiscountPlan`
--

DROP TABLE IF EXISTS `tblDiscountPlan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblDiscountPlan` (
  `DiscountPlanID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `DestinationGroupSetID` int(11) NOT NULL,
  `CurrencyID` int(11) NOT NULL,
  `Name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Description` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `UpdatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`DiscountPlanID`),
  KEY `FK_tblDiscountPlan_tblDestinationGroupSet` (`DestinationGroupSetID`),
  CONSTRAINT `tblDiscountPlan_ibfk_1` FOREIGN KEY (`DestinationGroupSetID`) REFERENCES `tblDestinationGroupSet` (`DestinationGroupSetID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblDiscountScheme`
--

DROP TABLE IF EXISTS `tblDiscountScheme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblDiscountScheme` (
  `DiscountSchemeID` int(11) NOT NULL AUTO_INCREMENT,
  `DiscountID` int(11) NOT NULL,
  `Threshold` int(11) NOT NULL,
  `Discount` int(11) NOT NULL,
  `Unlimited` tinyint(1) NOT NULL DEFAULT '0',
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `UpdatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`DiscountSchemeID`),
  KEY `FK_tblDiscountScheme_tblDiscount` (`DiscountID`),
  CONSTRAINT `tblDiscountScheme_ibfk_1` FOREIGN KEY (`DiscountID`) REFERENCES `tblDiscount` (`DiscountID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblEmailTemplate`
--

DROP TABLE IF EXISTS `tblEmailTemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblEmailTemplate` (
  `TemplateID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `TemplateName` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Subject` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TemplateBody` longtext COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `userID` int(11) DEFAULT NULL,
  `Type` tinyint(3) unsigned DEFAULT NULL,
  `EmailFrom` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `StaticType` tinyint(4) DEFAULT '0' COMMENT '0 for allow deleted,1 for not  allowed to delete',
  `SystemType` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Status` tinyint(4) DEFAULT '1',
  `StatusDisabled` tinyint(4) DEFAULT '0' COMMENT '0 for allow disable,1 for not  allow disable',
  PRIMARY KEY (`TemplateID`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblFileUploadTemplate`
--

DROP TABLE IF EXISTS `tblFileUploadTemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblFileUploadTemplate` (
  `FileUploadTemplateID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `Title` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Options` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TemplateFile` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Type` tinyint(3) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`FileUploadTemplateID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblGateway`
--

DROP TABLE IF EXISTS `tblGateway`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblGateway` (
  `GatewayID` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Status` tinyint(3) unsigned DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`GatewayID`),
  KEY `IX_tblGatewaySetting` (`GatewayID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblGatewayConfig`
--

DROP TABLE IF EXISTS `tblGatewayConfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblGatewayConfig` (
  `GatewayConfigID` int(11) NOT NULL AUTO_INCREMENT,
  `GatewayID` int(11) NOT NULL,
  `Title` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Status` tinyint(3) unsigned NOT NULL,
  `Created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`GatewayConfigID`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblGlobalAdmin`
--

DROP TABLE IF EXISTS `tblGlobalAdmin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblGlobalAdmin` (
  `GlobalAdminID` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `LastName` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `EmailAddress` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `password` longtext COLLATE utf8_unicode_ci NOT NULL,
  `Status` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `remember_token` longtext COLLATE utf8_unicode_ci,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`GlobalAdminID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblGlobalSetting`
--

DROP TABLE IF EXISTS `tblGlobalSetting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblGlobalSetting` (
  `GlobalSettingID` int(11) NOT NULL AUTO_INCREMENT,
  `Key` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Value` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`GlobalSettingID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblHelpDeskTickets`
--

DROP TABLE IF EXISTS `tblHelpDeskTickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblHelpDeskTickets` (
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
) ENGINE=InnoDB AUTO_INCREMENT=231 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Fresh desk tickets will save  here temporarily\r\nprc_getAccountTimeLine will use it';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblIP`
--

DROP TABLE IF EXISTS `tblIP`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblIP` (
  `Account` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IP` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblIntegration`
--

DROP TABLE IF EXISTS `tblIntegration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblIntegration` (
  `IntegrationID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyId` int(11) DEFAULT NULL,
  `Title` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Slug` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ParentID` int(11) DEFAULT '0',
  `MultiOption` enum('Y','N') COLLATE utf8_unicode_ci DEFAULT 'N',
  PRIMARY KEY (`IntegrationID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Integration categories';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblIntegrationConfiguration`
--

DROP TABLE IF EXISTS `tblIntegrationConfiguration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblIntegrationConfiguration` (
  `IntegrationConfigurationID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyId` int(11) DEFAULT NULL,
  `IntegrationID` int(11) DEFAULT NULL,
  `ParentIntegrationID` int(11) DEFAULT NULL,
  `Settings` longtext COLLATE utf8_unicode_ci,
  `Status` tinyint(4) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`IntegrationConfigurationID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='tblIntegration configiration details';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblJob`
--

DROP TABLE IF EXISTS `tblJob`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblJob` (
  `JobID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `AccountID` int(11) DEFAULT '0',
  `ProcessID` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `JobTypeID` tinyint(3) unsigned NOT NULL,
  `JobStatusID` tinyint(3) unsigned NOT NULL,
  `JobLoggedUserID` int(11) NOT NULL,
  `TemplateID` int(11) DEFAULT NULL,
  `Title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Options` longtext COLLATE utf8_unicode_ci,
  `JobStatusMessage` longtext COLLATE utf8_unicode_ci,
  `EmailSentStatus` tinyint(3) unsigned DEFAULT '0',
  `EmailSentStatusMessage` longtext COLLATE utf8_unicode_ci,
  `OutputFilePath` longtext COLLATE utf8_unicode_ci,
  `HasRead` tinyint(3) unsigned DEFAULT '0',
  `ShowInCounter` tinyint(3) unsigned DEFAULT '1',
  `LogID` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PID` int(11) DEFAULT NULL,
  `LastRunTime` datetime DEFAULT NULL,
  PRIMARY KEY (`JobID`),
  KEY `IX_CompanyID` (`CompanyID`)
) ENGINE=InnoDB AUTO_INCREMENT=99621 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblJobFile`
--

DROP TABLE IF EXISTS `tblJobFile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblJobFile` (
  `JobFileID` int(11) NOT NULL AUTO_INCREMENT,
  `JobID` int(11) NOT NULL,
  `FileName` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `FilePath` longtext COLLATE utf8_unicode_ci,
  `HttpPath` tinyint(1) NOT NULL DEFAULT '0',
  `Options` longtext COLLATE utf8_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`JobFileID`)
) ENGINE=InnoDB AUTO_INCREMENT=22083 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblJobStatus`
--

DROP TABLE IF EXISTS `tblJobStatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblJobStatus` (
  `JobStatusID` int(11) NOT NULL AUTO_INCREMENT,
  `Code` varchar(3) COLLATE utf8_unicode_ci NOT NULL,
  `Title` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Description` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `ModifiedDate` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`JobStatusID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblJobType`
--

DROP TABLE IF EXISTS `tblJobType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblJobType` (
  `JobTypeID` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `Code` varchar(3) COLLATE utf8_unicode_ci NOT NULL,
  `Title` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Description` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `ModifiedDate` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`JobTypeID`),
  UNIQUE KEY `UNIQUE_Code` (`Code`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblLastPrefixNo`
--

DROP TABLE IF EXISTS `tblLastPrefixNo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblLastPrefixNo` (
  `CompanyID` int(11) DEFAULT NULL,
  `LastPrefixNo` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblLog`
--

DROP TABLE IF EXISTS `tblLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblLog` (
  `LogID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `ProcessID` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Process` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Message` longtext COLLATE utf8_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`LogID`)
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblMessages`
--

DROP TABLE IF EXISTS `tblMessages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblMessages` (
  `MsgID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `AccountID` int(11) DEFAULT '0',
  `ProcessID` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `MsgLoggedUserID` int(11) NOT NULL,
  `Title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Options` longtext COLLATE utf8_unicode_ci,
  `MsgStatusMessage` longtext COLLATE utf8_unicode_ci,
  `EmailSentStatus` tinyint(3) unsigned DEFAULT '0',
  `EmailSentStatusMessage` longtext COLLATE utf8_unicode_ci,
  `OutputFilePath` longtext COLLATE utf8_unicode_ci,
  `HasRead` tinyint(3) unsigned DEFAULT '0',
  `ShowInCounter` tinyint(3) unsigned DEFAULT '1',
  `EmailID` int(11) DEFAULT NULL,
  `MatchType` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `MatchID` int(11) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`MsgID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblNote`
--

DROP TABLE IF EXISTS `tblNote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblNote` (
  `NoteID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `AccountID` int(11) NOT NULL,
  `Title` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Note` longtext COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`NoteID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblNotification`
--

DROP TABLE IF EXISTS `tblNotification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblNotification` (
  `NotificationID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `NotificationType` int(11) DEFAULT NULL,
  `EmailAddresses` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `Status` int(11) DEFAULT '0',
  PRIMARY KEY (`NotificationID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblOpportunity`
--

DROP TABLE IF EXISTS `tblOpportunity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblOpportunity` (
  `OpportunityID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `AccountID` int(11) NOT NULL DEFAULT '0',
  `BoardID` int(11) NOT NULL,
  `BoardColumnID` int(11) DEFAULT NULL,
  `OpportunityName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Company` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Title` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FirstName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LastName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Phone` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Email` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Rating` int(11) DEFAULT NULL,
  `Tags` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Notes` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BackGroundColour` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TextColour` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ClosingDate` datetime DEFAULT NULL,
  `Status` int(11) DEFAULT NULL,
  `Order` int(11) DEFAULT NULL,
  `AttachmentPaths` longtext COLLATE utf8_unicode_ci,
  `TaggedUsers` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Worth` decimal(18,8) DEFAULT '0.00000000',
  `OpportunityClosed` tinyint(4) DEFAULT '0',
  `ExpectedClosing` datetime DEFAULT NULL,
  PRIMARY KEY (`OpportunityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblPaymentGateway`
--

DROP TABLE IF EXISTS `tblPaymentGateway`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblPaymentGateway` (
  `PaymentGatewayID` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  `Status` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`PaymentGatewayID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblPaymentUploadTemplate`
--

DROP TABLE IF EXISTS `tblPaymentUploadTemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblPaymentUploadTemplate` (
  `PaymentUploadTemplateID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `Title` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Options` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TemplateFile` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`PaymentUploadTemplateID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblPermission`
--

DROP TABLE IF EXISTS `tblPermission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblPermission` (
  `PermissionID` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `action` longtext COLLATE utf8_unicode_ci,
  `resource` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`PermissionID`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblQuickBookLog`
--

DROP TABLE IF EXISTS `tblQuickBookLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblQuickBookLog` (
  `QuickBookLogID` int(11) NOT NULL AUTO_INCREMENT,
  `Note` longtext COLLATE utf8_unicode_ci,
  `Type` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`QuickBookLogID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRate`
--

DROP TABLE IF EXISTS `tblRate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRate` (
  `RateID` int(11) NOT NULL AUTO_INCREMENT,
  `CountryID` int(11) DEFAULT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  `CodeDeckId` int(11) NOT NULL,
  `Code` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Description` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `Country__tobe_delete` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Interval1` int(11) DEFAULT '1',
  `IntervalN` int(11) DEFAULT '1',
  PRIMARY KEY (`RateID`),
  UNIQUE KEY `IXUnique_CompanyID_Code_CodedeckID` (`CompanyID`,`Code`,`CodeDeckId`),
  KEY `IX_tblRate_companyId_codedeckid` (`CompanyID`,`CodeDeckId`,`RateID`,`CountryID`,`Code`,`Description`),
  KEY `IX_country_company_codedeck` (`CountryID`,`CompanyID`,`CodeDeckId`),
  KEY `IX_tblrate_code` (`Code`),
  KEY `IX_tblrate_CodeDescription` (`RateID`,`CompanyID`,`CountryID`,`Code`,`Description`),
  KEY `IX_tblRate_CompanyCodeDeckIdCode` (`CompanyID`,`CodeDeckId`,`Code`),
  KEY `IX_tblRate_CountryId` (`CountryID`),
  KEY `IX_tblrate_desc` (`Description`)
) ENGINE=InnoDB AUTO_INCREMENT=1382761 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRateDevTmp`
--

DROP TABLE IF EXISTS `tblRateDevTmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRateDevTmp` (
  `RateID` int(11) NOT NULL AUTO_INCREMENT,
  `CountryID` int(11) DEFAULT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  `CodeDeckId` int(11) DEFAULT NULL,
  `Code` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Description` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Interval1` int(11) DEFAULT '1',
  `IntervalN` int(11) DEFAULT '1',
  PRIMARY KEY (`RateID`),
  KEY `Index 3` (`Code`)
) ENGINE=InnoDB AUTO_INCREMENT=27568 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRateGenerator`
--

DROP TABLE IF EXISTS `tblRateGenerator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRateGenerator` (
  `RateGeneratorId` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `CodeDeckId` int(11) DEFAULT NULL,
  `RateGeneratorName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `TrunkID` int(11) DEFAULT NULL,
  `RatePosition` int(11) NOT NULL DEFAULT '1',
  `RateTableId` int(11) DEFAULT NULL,
  `UseAverage` tinyint(1) NOT NULL DEFAULT '0',
  `UsePreference` tinyint(1) DEFAULT NULL,
  `Sources` varchar(50) COLLATE utf8_unicode_ci DEFAULT 'All',
  `Status` tinyint(3) unsigned DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CurrencyID` int(11) DEFAULT NULL,
  `Policy` int(11) DEFAULT NULL,
  PRIMARY KEY (`RateGeneratorId`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRateRule`
--

DROP TABLE IF EXISTS `tblRateRule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRateRule` (
  `RateRuleId` int(11) NOT NULL AUTO_INCREMENT,
  `RateGeneratorId` int(11) NOT NULL,
  `Code` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`RateRuleId`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRateRuleMargin`
--

DROP TABLE IF EXISTS `tblRateRuleMargin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRateRuleMargin` (
  `RateRuleMarginId` int(11) NOT NULL AUTO_INCREMENT,
  `RateRuleId` int(11) NOT NULL,
  `MinRate` decimal(18,6) DEFAULT '0.000000',
  `MaxRate` decimal(18,6) DEFAULT '0.000000',
  `AddMargin` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`RateRuleMarginId`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRateRuleSource`
--

DROP TABLE IF EXISTS `tblRateRuleSource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRateRuleSource` (
  `RateRuleSourceId` int(11) NOT NULL AUTO_INCREMENT,
  `RateRuleId` int(11) NOT NULL,
  `AccountId` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`RateRuleSourceId`),
  KEY `IX_RateRuleId_AccountID` (`AccountId`,`RateRuleId`)
) ENGINE=InnoDB AUTO_INCREMENT=831 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRateSheet`
--

DROP TABLE IF EXISTS `tblRateSheet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRateSheet` (
  `RateSheetID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerID` int(11) NOT NULL,
  `RateSheet` longblob,
  `DateGenerated` datetime NOT NULL,
  `FileName` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Level` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `GeneratedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`RateSheetID`),
  KEY `IX_tblRateSheet_CustomerID_Level_69B7F` (`CustomerID`,`Level`)
) ENGINE=InnoDB AUTO_INCREMENT=48439 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRateSheetArchive`
--

DROP TABLE IF EXISTS `tblRateSheetArchive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRateSheetArchive` (
  `RateSheetID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerID` int(11) NOT NULL,
  `RateSheet` longblob,
  `DateGenerated` datetime NOT NULL,
  `FileName` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Level` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `GeneratedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`RateSheetID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRateSheetDetails`
--

DROP TABLE IF EXISTS `tblRateSheetDetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRateSheetDetails` (
  `RateSheetDetailsID` int(11) NOT NULL AUTO_INCREMENT,
  `RateID` int(11) NOT NULL,
  `RateSheetID` int(11) NOT NULL,
  `Destination` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `Code` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Rate` decimal(18,6) NOT NULL DEFAULT '0.000000',
  `Change` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `EffectiveDate` datetime NOT NULL,
  `Interval1` int(11) DEFAULT NULL,
  `IntervalN` int(11) DEFAULT NULL,
  PRIMARY KEY (`RateSheetDetailsID`),
  KEY `IX_tblRateSheetDetails_RateSheetID_DBEE5` (`RateSheetID`,`RateSheetDetailsID`),
  KEY `IX_tblRateSheetDetails_RateSheetID_77B8B` (`RateSheetID`,`RateSheetDetailsID`)
) ENGINE=InnoDB AUTO_INCREMENT=144746800 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRateSheetDetailsArchive`
--

DROP TABLE IF EXISTS `tblRateSheetDetailsArchive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRateSheetDetailsArchive` (
  `RateSheetDetailsID` int(11) NOT NULL AUTO_INCREMENT,
  `RateID` int(11) NOT NULL,
  `RateSheetID` int(11) NOT NULL,
  `Destination` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `Code` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Rate` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `Change` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `EffectiveDate` datetime NOT NULL,
  PRIMARY KEY (`RateSheetDetailsID`),
  KEY `FK_tblRateSheetDetailsArchive_tblRateSheetArchive` (`RateSheetID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRateSheetFormate`
--

DROP TABLE IF EXISTS `tblRateSheetFormate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRateSheetFormate` (
  `RateSheetFormateID` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Description` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Customer` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Vendor` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Status` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `UpdatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`RateSheetFormateID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRateSheetHistory`
--

DROP TABLE IF EXISTS `tblRateSheetHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRateSheetHistory` (
  `RateSheetHistoryID` int(11) NOT NULL AUTO_INCREMENT,
  `JobID` int(11) NOT NULL,
  `Title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` longtext COLLATE utf8_unicode_ci,
  `Type` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`RateSheetHistoryID`),
  KEY `IX_tblRateSheetHistory_JobID_Type_6D56E` (`JobID`,`Type`,`RateSheetHistoryID`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=106012 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRateTable`
--

DROP TABLE IF EXISTS `tblRateTable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRateTable` (
  `RateTableId` bigint(20) NOT NULL AUTO_INCREMENT,
  `CompanyId` int(11) NOT NULL,
  `CodeDeckId` int(11) NOT NULL,
  `RateTableName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `RateGeneratorID` int(11) NOT NULL,
  `TrunkID` int(11) NOT NULL,
  `Status` tinyint(3) unsigned DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CurrencyID` int(11) DEFAULT NULL,
  PRIMARY KEY (`RateTableId`),
  KEY `CompanyCodedeck` (`CompanyId`,`CodeDeckId`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRateTableRate`
--

DROP TABLE IF EXISTS `tblRateTableRate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRateTableRate` (
  `RateTableRateID` bigint(20) NOT NULL AUTO_INCREMENT,
  `RateID` int(11) NOT NULL,
  `RateTableId` bigint(20) NOT NULL,
  `Rate` decimal(18,6) NOT NULL DEFAULT '0.000000',
  `EffectiveDate` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PreviousRate` decimal(18,6) DEFAULT NULL,
  `Interval1` int(11) DEFAULT NULL,
  `IntervalN` int(11) DEFAULT NULL,
  `ConnectionFee` decimal(18,6) DEFAULT NULL,
  PRIMARY KEY (`RateTableRateID`),
  UNIQUE KEY `IX_Unique_RateID_RateTableId_EffectiveDate` (`RateID`,`RateTableId`,`EffectiveDate`),
  KEY `FK_tblRateTableRate_tblRate` (`RateID`),
  KEY `XI_RateID_RatetableID` (`RateID`,`RateTableRateID`),
  KEY `IX_RateTableId` (`RateTableId`),
  KEY `IX_RateTableId_RateID_EffectiveDate` (`RateTableId`,`RateID`,`EffectiveDate`),
  KEY `RateTableIDEffectiveDate` (`RateTableId`,`EffectiveDate`,`RateID`),
  CONSTRAINT `tblRateTableRate_ibfk_1` FOREIGN KEY (`RateID`) REFERENCES `tblRate` (`RateID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6577620 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRateTableRateArchive`
--

DROP TABLE IF EXISTS `tblRateTableRateArchive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRateTableRateArchive` (
  `RateTableRateArchiveID` int(11) NOT NULL AUTO_INCREMENT,
  `RateTableRateID` int(11) NOT NULL,
  `RateTableId` int(11) NOT NULL,
  `RateId` int(11) NOT NULL,
  `Rate` decimal(18,6) NOT NULL,
  `EffectiveDate` datetime NOT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `Notes` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`RateTableRateArchiveID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRate_Backup`
--

DROP TABLE IF EXISTS `tblRate_Backup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRate_Backup` (
  `RateID` int(11) NOT NULL,
  `CountryID` int(11) DEFAULT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  `CodeDeckId` int(11) DEFAULT NULL,
  `Code` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Description` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `Country__tobe_delete` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Interval1` int(11) DEFAULT '1',
  `IntervalN` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblResource`
--

DROP TABLE IF EXISTS `tblResource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblResource` (
  `ResourceID` int(11) NOT NULL AUTO_INCREMENT,
  `ResourceName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ResourceValue` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CompanyID` int(11) NOT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `CategoryID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ResourceID`)
) ENGINE=InnoDB AUTO_INCREMENT=2165 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblResourceCategories`
--

DROP TABLE IF EXISTS `tblResourceCategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblResourceCategories` (
  `ResourceCategoryID` int(11) NOT NULL AUTO_INCREMENT,
  `ResourceCategoryName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ResourceCategoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=1253 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblResourceCategoryMapping`
--

DROP TABLE IF EXISTS `tblResourceCategoryMapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblResourceCategoryMapping` (
  `MappingID` int(11) NOT NULL AUTO_INCREMENT,
  `ResourceID` int(11) DEFAULT NULL,
  `ResourceCategoryID` int(11) DEFAULT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  PRIMARY KEY (`MappingID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRole`
--

DROP TABLE IF EXISTS `tblRole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRole` (
  `RoleID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `RoleName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Active` tinyint(3) unsigned DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`RoleID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRolePermission`
--

DROP TABLE IF EXISTS `tblRolePermission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRolePermission` (
  `RolePermissionID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `roleID` int(11) NOT NULL,
  `resourceID` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`RolePermissionID`)
) ENGINE=InnoDB AUTO_INCREMENT=572 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblServerInfo`
--

DROP TABLE IF EXISTS `tblServerInfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblServerInfo` (
  `ServerInfoID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `ServerInfoTitle` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ServerInfoUrl` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ServerInfoID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTags`
--

DROP TABLE IF EXISTS `tblTags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTags` (
  `TagID` int(11) NOT NULL AUTO_INCREMENT,
  `TagName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  `TagType` int(11) DEFAULT NULL,
  PRIMARY KEY (`TagID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTask`
--

DROP TABLE IF EXISTS `tblTask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTask` (
  `TaskID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `UsersIDs` int(11) NOT NULL,
  `AccountIDs` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BoardID` int(11) NOT NULL,
  `BoardColumnID` int(11) NOT NULL,
  `BackGroundColour` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TextColour` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Subject` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `Description` longtext COLLATE utf8_unicode_ci NOT NULL,
  `DueDate` datetime DEFAULT NULL,
  `Priority` tinyint(4) NOT NULL DEFAULT '0',
  `ClosingDate` datetime DEFAULT NULL,
  `Order` int(11) NOT NULL DEFAULT '0',
  `taskClosed` tinyint(4) NOT NULL DEFAULT '0',
  `Tags` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TaggedUsers` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AttachmentPaths` mediumtext COLLATE utf8_unicode_ci,
  `Task_type` int(11) NOT NULL DEFAULT '0',
  `ParentID` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CalendarEventID` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`TaskID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTaxRate`
--

DROP TABLE IF EXISTS `tblTaxRate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTaxRate` (
  `TaxRateId` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyId` int(11) DEFAULT NULL,
  `Title` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Amount` decimal(18,2) NOT NULL,
  `TaxType` tinyint(3) unsigned DEFAULT NULL,
  `FlatStatus` tinyint(3) unsigned DEFAULT NULL,
  `Status` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TaxRateId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempAccount`
--

DROP TABLE IF EXISTS `tblTempAccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempAccount` (
  `tblTempAccountID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountType` tinyint(3) unsigned DEFAULT NULL,
  `CompanyId` int(11) DEFAULT NULL,
  `Title` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Owner` int(11) DEFAULT NULL,
  `Number` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `NamePrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FirstName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LastName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LeadStatus` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LeadSource` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Email` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Phone` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address1` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address2` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address3` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `City` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PostCode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Country` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Status` int(11) DEFAULT NULL,
  `tags` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `ProcessID` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillingTimezone` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Website` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Fax` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Skype` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Twitter` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Employee` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` longtext COLLATE utf8_unicode_ci,
  `BillingEmail` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Currency` int(11) DEFAULT NULL,
  `VatNumber` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`tblTempAccountID`),
  KEY `IX_tblAccount_AccountType_CompanyId_Status` (`AccountType`,`CompanyId`,`Status`,`AccountName`),
  KEY `IX_tblAccount_CompanyId_AccountName` (`CompanyId`,`AccountName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempCodeDeck`
--

DROP TABLE IF EXISTS `tblTempCodeDeck`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempCodeDeck` (
  `TempCodeDeckRateID` int(11) NOT NULL AUTO_INCREMENT,
  `CountryId` int(11) DEFAULT NULL,
  `CompanyId` int(11) NOT NULL,
  `CodeDeckId` int(11) DEFAULT NULL,
  `ProcessId` bigint(20) unsigned NOT NULL,
  `Code` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Country` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Action` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Interval1` int(11) DEFAULT NULL,
  `IntervalN` int(11) DEFAULT NULL,
  PRIMARY KEY (`TempCodeDeckRateID`),
  KEY `PK_tblTempCodeDeck` (`ProcessId`,`Code`,`CompanyId`,`CodeDeckId`),
  KEY `PK_tblTempCdprocess` (`ProcessId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempCustomerRate`
--

DROP TABLE IF EXISTS `tblTempCustomerRate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempCustomerRate` (
  `TempCustomerRateID` int(11) NOT NULL AUTO_INCREMENT,
  `Select` tinyint(1) DEFAULT '0',
  `RateID` int(11) NOT NULL,
  `CustomerID` int(11) NOT NULL,
  `Rate` decimal(18,4) DEFAULT '0.0000',
  `EffectiveDate` date DEFAULT NULL,
  `PreviousRate` decimal(18,4) DEFAULT '0.0000',
  `Trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempCustomerRateID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempDialString`
--

DROP TABLE IF EXISTS `tblTempDialString`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempDialString` (
  `TempDialStringID` int(11) NOT NULL AUTO_INCREMENT,
  `DialStringID` int(11) NOT NULL,
  `DialString` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `ChargeCode` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Description` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Forbidden` tinyint(1) NOT NULL DEFAULT '0',
  `ProcessId` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `Action` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempDialStringID`),
  KEY `PK_tblTempDialPlanprocess` (`ProcessId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempRateLog`
--

DROP TABLE IF EXISTS `tblTempRateLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempRateLog` (
  `TempRateLogID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `MessageType` int(11) NOT NULL,
  `Message` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `SentStatus` int(11) NOT NULL,
  `RateDate` date NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`TempRateLogID`),
  UNIQUE KEY `IX_DuplicateMessage` (`CompanyID`,`CompanyGatewayID`,`MessageType`,`Message`,`RateDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempRateTableRate`
--

DROP TABLE IF EXISTS `tblTempRateTableRate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempRateTableRate` (
  `TempRateTableRateID` int(11) NOT NULL AUTO_INCREMENT,
  `CodeDeckId` int(11) DEFAULT NULL,
  `Code` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Description` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `Rate` decimal(18,6) NOT NULL DEFAULT '0.000000',
  `EffectiveDate` datetime NOT NULL,
  `Change` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessId` bigint(20) unsigned NOT NULL,
  `Preference` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ConnectionFee` decimal(18,6) DEFAULT NULL,
  `Interval1` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IntervalN` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempRateTableRateID`),
  KEY `IX_tblTempRateTableRate_Code_Change_ProcessId_5D43F` (`Code`,`Change`,`ProcessId`),
  KEY `IX_tblTempRateTableRateCodedeckCodeProcessID` (`Code`,`CodeDeckId`,`ProcessId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempVendorRate`
--

DROP TABLE IF EXISTS `tblTempVendorRate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempVendorRate` (
  `TempVendorRateID` int(11) NOT NULL AUTO_INCREMENT,
  `CodeDeckId` int(11) DEFAULT NULL,
  `Code` text COLLATE utf8_unicode_ci NOT NULL,
  `Description` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `Rate` decimal(18,6) NOT NULL DEFAULT '0.000000',
  `EffectiveDate` datetime NOT NULL,
  `Change` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProcessId` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `Preference` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ConnectionFee` decimal(18,6) DEFAULT NULL,
  `Interval1` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IntervalN` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Forbidden` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TempVendorRateID`),
  KEY `IX_tblTempVendorRateProcessID` (`ProcessId`),
  KEY `IX_tblTempVendorRateCodedeckCodeProcessID` (`CodeDeckId`,`Code`(100),`ProcessId`),
  KEY `IX_tblTempVendorRate_Code_Change_ProcessId_5D43F` (`Code`(100),`Change`,`ProcessId`)
) ENGINE=InnoDB AUTO_INCREMENT=2671420 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTemplate`
--

DROP TABLE IF EXISTS `tblTemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTemplate` (
  `TemplateID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `Title` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Description` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `ModifiedDate` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TemplateID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTrunk`
--

DROP TABLE IF EXISTS `tblTrunk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTrunk` (
  `TrunkID` int(11) NOT NULL AUTO_INCREMENT,
  `Trunk` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `CompanyId` int(11) NOT NULL,
  `RatePrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Status` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`TrunkID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUploadedFiles`
--

DROP TABLE IF EXISTS `tblUploadedFiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUploadedFiles` (
  `UploadedFileID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `UserID` int(11) DEFAULT NULL,
  `UploadedFileName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `UploadedFilePath` longtext COLLATE utf8_unicode_ci,
  `UploadedFileHttpPath` tinyint(4) DEFAULT NULL,
  `created_at` datetime(3) DEFAULT NULL,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`UploadedFileID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsage`
--

DROP TABLE IF EXISTS `tblUsage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsage` (
  `PKUsage` bigint(20) NOT NULL AUTO_INCREMENT,
  `AccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AreaName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCharges` decimal(18,3) DEFAULT '0.000',
  `TotalDuration` int(11) DEFAULT NULL,
  `NoOfCDR` int(11) DEFAULT NULL,
  `Minutes` decimal(18,3) DEFAULT NULL,
  `AVGRatePerMin` decimal(18,6) DEFAULT NULL,
  `PeriodFrom` datetime DEFAULT NULL,
  `PeriodTo` datetime DEFAULT NULL,
  `InvoiceCompanyID` int(11) DEFAULT NULL,
  PRIMARY KEY (`PKUsage`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUser`
--

DROP TABLE IF EXISTS `tblUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUser` (
  `UserID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `FirstName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LastName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailAddress` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` longtext COLLATE utf8_unicode_ci,
  `AdminUser` tinyint(1) DEFAULT '0',
  `AccountingUser` tinyint(1) DEFAULT NULL,
  `Status` int(11) DEFAULT '0',
  `Roles` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmailFooter` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Color` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `JobNotification` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUserPermission`
--

DROP TABLE IF EXISTS `tblUserPermission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUserPermission` (
  `UserPermissionID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `resourceID` int(11) NOT NULL,
  `AddRemove` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`UserPermissionID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUserProfile`
--

DROP TABLE IF EXISTS `tblUserProfile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUserProfile` (
  `UserProfileID` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) NOT NULL,
  `City` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `State` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PostCode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Country` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address1` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address2` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address3` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Picture` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Utc` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`UserProfileID`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUserRole`
--

DROP TABLE IF EXISTS `tblUserRole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUserRole` (
  `UserRoleID` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) DEFAULT NULL,
  `RoleID` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`UserRoleID`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblVendorBlocking`
--

DROP TABLE IF EXISTS `tblVendorBlocking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblVendorBlocking` (
  `VendorBlockingId` int(11) NOT NULL AUTO_INCREMENT,
  `AccountId` int(11) NOT NULL,
  `CountryId` int(11) DEFAULT NULL,
  `RateId` int(11) DEFAULT NULL,
  `TrunkID` int(11) NOT NULL,
  `BlockedBy` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `BlockedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`VendorBlockingId`),
  UNIQUE KEY `IX_UniqueAccountId_TrunkId_RateId_CountryId` (`TrunkID`,`RateId`,`CountryId`,`AccountId`),
  KEY `IX_tblVendorBlocking_AccountId` (`AccountId`),
  KEY `IX_tblVendorBlocking_CountryId` (`CountryId`),
  KEY `IX_tblVendorBlocking_RateId` (`RateId`),
  KEY `IX_tblVendorBlocking_TrunkID` (`TrunkID`),
  KEY `IX_tblVendorBlocking_CountryId_TrunkID` (`AccountId`,`CountryId`,`TrunkID`),
  KEY `IX_tblVendorBlocking_TrunkID_4F42B` (`TrunkID`,`VendorBlockingId`,`RateId`)
) ENGINE=InnoDB AUTO_INCREMENT=317089 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblVendorCSVMapping`
--

DROP TABLE IF EXISTS `tblVendorCSVMapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblVendorCSVMapping` (
  `VendorCSVMappingId` int(11) NOT NULL AUTO_INCREMENT,
  `VendorId` int(11) DEFAULT NULL,
  `ExcelColumn` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `MapTo` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`VendorCSVMappingId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblVendorFileUploadTemplate`
--

DROP TABLE IF EXISTS `tblVendorFileUploadTemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblVendorFileUploadTemplate` (
  `VendorFileUploadTemplateID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `Title` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Options` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TemplateFile` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`VendorFileUploadTemplateID`)
) ENGINE=InnoDB AUTO_INCREMENT=247 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblVendorPreference`
--

DROP TABLE IF EXISTS `tblVendorPreference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblVendorPreference` (
  `VendorPreferenceID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountId` int(11) NOT NULL,
  `Preference` int(11) NOT NULL,
  `RateId` int(11) DEFAULT NULL,
  `TrunkID` int(11) NOT NULL,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`VendorPreferenceID`),
  UNIQUE KEY `IX_UniqueAccountId_Pref_RateId_TrunkId` (`Preference`,`RateId`,`TrunkID`,`AccountId`),
  KEY `IX_AccountID_TrunkID_RateID` (`TrunkID`,`RateId`,`AccountId`)
) ENGINE=InnoDB AUTO_INCREMENT=8911 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblVendorRate`
--

DROP TABLE IF EXISTS `tblVendorRate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblVendorRate` (
  `VendorRateID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountId` int(11) NOT NULL,
  `TrunkID` int(11) NOT NULL,
  `RateId` int(11) NOT NULL,
  `Rate` decimal(18,6) NOT NULL DEFAULT '0.000000',
  `EffectiveDate` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Interval1` int(11) DEFAULT NULL,
  `IntervalN` int(11) DEFAULT NULL,
  `ConnectionFee` decimal(18,6) DEFAULT NULL,
  `MinimumCost` decimal(18,6) DEFAULT NULL,
  PRIMARY KEY (`VendorRateID`),
  UNIQUE KEY `IXUnique_AccountId_TrunkId_RateId_EffectiveDate` (`AccountId`,`TrunkID`,`RateId`,`EffectiveDate`),
  KEY `IX_tblVendorRate_RateId_TrunkID_EffectiveDate` (`AccountId`,`Rate`,`TrunkID`,`RateId`,`EffectiveDate`),
  KEY `IX_tblVendorRate_AccountId_TrunkID_9BBE2` (`AccountId`,`TrunkID`,`VendorRateID`,`RateId`,`Rate`,`EffectiveDate`,`updated_at`,`created_at`,`created_by`,`updated_by`,`Interval1`,`IntervalN`),
  KEY `IX_VendorRate_RateID` (`RateId`),
  KEY `IX_VendorRate_RateID_trunkID` (`RateId`,`TrunkID`),
  CONSTRAINT `tblVendorRate_ibfk_1` FOREIGN KEY (`RateId`) REFERENCES `tblRate` (`RateID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=96258438 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblVendorRateArchive`
--

DROP TABLE IF EXISTS `tblVendorRateArchive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblVendorRateArchive` (
  `VendorRateArchiveID` int(11) NOT NULL AUTO_INCREMENT,
  `VendorRateID` int(11) NOT NULL,
  `AccountId` int(11) NOT NULL,
  `TrunkId` int(11) NOT NULL,
  `RateId` int(11) NOT NULL,
  `Rate` decimal(18,6) NOT NULL,
  `EffectiveDate` datetime NOT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `Notes` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`VendorRateArchiveID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblVendorRateDiscontinued`
--

DROP TABLE IF EXISTS `tblVendorRateDiscontinued`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblVendorRateDiscontinued` (
  `DiscontinuedID` int(11) NOT NULL AUTO_INCREMENT,
  `VendorRateID` int(11) NOT NULL,
  `AccountId` int(11) NOT NULL,
  `TrunkID` int(11) NOT NULL,
  `RateId` int(11) NOT NULL,
  `Code` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Description` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Rate` decimal(18,6) NOT NULL DEFAULT '0.000000',
  `EffectiveDate` datetime DEFAULT NULL,
  `Interval1` int(11) DEFAULT NULL,
  `IntervalN` int(11) DEFAULT NULL,
  `ConnectionFee` decimal(18,6) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`DiscontinuedID`),
  KEY `UK_tblVendorRateDiscontinued` (`AccountId`,`RateId`)
) ENGINE=InnoDB AUTO_INCREMENT=10851 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblVendorTrunk`
--

DROP TABLE IF EXISTS `tblVendorTrunk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblVendorTrunk` (
  `VendorTrunkID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `CodeDeckId` int(11) DEFAULT NULL,
  `AccountID` int(11) NOT NULL,
  `TrunkID` int(11) NOT NULL,
  `Prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Status` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `UseInBilling` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`VendorTrunkID`),
  UNIQUE KEY `IX_Unique_TrunkId_AccountId` (`TrunkID`,`AccountID`),
  KEY `IX_AccountID_TrunkID_Status` (`AccountID`,`TrunkID`,`Status`),
  KEY `IX_AccountID_TrunkID_Codedeckid` (`TrunkID`,`CodeDeckId`)
) ENGINE=InnoDB AUTO_INCREMENT=2474 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_Account_Contacts_Activity`
--

DROP TABLE IF EXISTS `tbl_Account_Contacts_Activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_Account_Contacts_Activity` (
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
) ENGINE=InnoDB AUTO_INCREMENT=1437 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test`
--

DROP TABLE IF EXISTS `test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test` (
  `AccountName` text COLLATE utf8_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmpVendorId`
--

DROP TABLE IF EXISTS `tmpVendorId`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmpVendorId` (
  `VendorID` int(11) DEFAULT NULL,
  KEY `Index 1` (`VendorID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmptblcountry`
--

DROP TABLE IF EXISTS `tmptblcountry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmptblcountry` (
  `id` int(11) NOT NULL,
  `iso` char(2) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(80) COLLATE utf8_unicode_ci NOT NULL,
  `nicename` varchar(80) COLLATE utf8_unicode_ci NOT NULL,
  `iso3` char(3) COLLATE utf8_unicode_ci DEFAULT NULL,
  `numcode` smallint(6) DEFAULT NULL,
  `phonecode` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vendor_merge`
--

DROP TABLE IF EXISTS `vendor_merge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vendor_merge` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `customer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `vendor` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `is_vendor_customer` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vendor_merge_to_customer`
--

DROP TABLE IF EXISTS `vendor_merge_to_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vendor_merge_to_customer` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Customer` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Vendor` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Status` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'wavetelwholesaleRM'
--
/*!50003 DROP FUNCTION IF EXISTS `fnFIND_IN_SET` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `fnFIND_IN_SET`(
	`p_String1` LONGTEXT,
	`p_String2` LONGTEXT



) RETURNS int(11)
BEGIN
	DECLARE i int;
	DECLARE counter int;
	
	DROP TEMPORARY TABLE IF EXISTS `table1`;
	CREATE TEMPORARY TABLE `table1` (
	  `splitted_column` varchar(45) NOT NULL
	);
	
	DROP TEMPORARY TABLE IF EXISTS `table2`;
	CREATE TEMPORARY TABLE `table2` (
	  `splitted_column` varchar(45) NOT NULL
	);


	SET i = 1;
	REPEAT
		INSERT INTO table1
		SELECT wavetelwholesaleRM.FnStringSplit(p_String1, ',', i) WHERE wavetelwholesaleRM.FnStringSplit(p_String1, ',', i) IS NOT NULL LIMIT 1;
		SET i = i + 1;
		UNTIL ROW_COUNT() = 0
	END REPEAT;
	
	SET i = 1;
	REPEAT
		INSERT INTO table2
		SELECT wavetelwholesaleRM.FnStringSplit(p_String2, ',', i) WHERE wavetelwholesaleRM.FnStringSplit(p_String2, ',', i) IS NOT NULL LIMIT 1;
		SET i = i + 1;
		UNTIL ROW_COUNT() = 0
	END REPEAT;
	
	SELECT COUNT(*) INTO counter
	FROM table1 
	INNER JOIN table2 ON table1.splitted_column = table2.splitted_column;
	
	RETURN counter;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `FnGetAccountNumber` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `FnGetAccountNumber`(`p_companyId` INT, `p_number` INT) RETURNS varchar(50) CHARSET utf8 COLLATE utf8_unicode_ci
    NO SQL
    DETERMINISTIC
    COMMENT 'Return Next Account Number'
BEGIN
DECLARE lastnumber VARCHAR(50);
DECLARE found_val INT(11);

set lastnumber = (select cs.`Value` FROM tblCompanySetting cs where cs.`Key` = 'LastAccountNo' AND cs.CompanyID = p_companyId);

IF p_number =0
THEN
 set found_val = (select count(*) as total_res from tblAccount where Number=lastnumber);
END IF;

IF p_number != 0
THEN
 set found_val = (select count(*) as total_res from tblAccount where Number=p_number);
 IF found_val=0 THEN
 	SET lastnumber= p_number;
 END IF;	
END IF;


IF found_val>0 then
 SET lastnumber = NULL;




END IF;

 return lastnumber;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnGetCountryIdByCodeAndCountry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `fnGetCountryIdByCodeAndCountry`(`p_code` TEXT, `p_country` TEXT) RETURNS int(11)
BEGIN

DECLARE v_countryId int;

DROP TEMPORARY TABLE IF EXISTS tmp_Prefix;    
CREATE TEMPORARY TABLE tmp_Prefix (Prefix varchar(500) , CountryID int);

INSERT INTO tmp_Prefix 
SELECT DISTINCT
 tblCountry.Prefix,
 tblCountry.CountryID
FROM tblCountry
LEFT OUTER JOIN
 (
	SELECT
	 Prefix
	FROM tblCountry
	GROUP BY Prefix
	HAVING COUNT(*) > 1) d 
	ON tblCountry.Prefix = d.Prefix
Where (p_code LIKE CONCAT(tblCountry.Prefix, '%') AND d.Prefix IS NULL)
	 OR (p_code LIKE CONCAT(tblCountry.Prefix, '%') AND d.Prefix IS NOT NULL 
 		AND (p_country LIKE CONCAT('%', tblCountry.Country, '%'))) ;


DROP TEMPORARY TABLE IF EXISTS tmp_PrefixCopy;  
CREATE TEMPORARY TABLE tmp_PrefixCopy (SELECT * FROM tmp_Prefix);

SELECT DISTINCT p.CountryID   INTO v_countryId
FROM tmp_Prefix  p 
JOIN (
		SELECT MAX(Prefix) AS  Prefix 
		 FROM  tmp_PrefixCopy 
	  ) AS MaxPrefix
	 ON MaxPrefix.Prefix = p.Prefix Limit 1;
	 

RETURN v_countryId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnGetRoundingPoint` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `fnGetRoundingPoint`(
	`p_CompanyID` INT
) RETURNS int(11)
BEGIN

DECLARE v_Round_ int;

SELECT cs.Value INTO v_Round_ from tblCompanySetting cs where cs.`Key` = 'RoundChargesAmount' AND cs.CompanyID = p_CompanyID;

SET v_Round_ = IFNULL(v_Round_,2);

RETURN v_Round_;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `FnStringSplit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `FnStringSplit`(`x` TEXT, `delim` VARCHAR(500), `pos` INTEGER) RETURNS varchar(500) CHARSET utf8 COLLATE utf8_unicode_ci
BEGIN
  DECLARE output VARCHAR(500);
  SET output = REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos)
                 , LENGTH(SUBSTRING_INDEX(x, delim, pos - 1)) + 1)
                 , delim
                 , '');
  IF output = '' THEN SET output = null; END IF;
  RETURN output;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `split_token` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `split_token`(txt TEXT CHARSET utf8, delimiter_text VARCHAR(255) CHARSET utf8, token_index INT UNSIGNED) RETURNS text CHARSET utf8
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT 'Return substring by index in delimited text'
begin
  if CHAR_LENGTH(delimiter_text) = '' then
    return SUBSTRING(txt, token_index, 1);
  else
    return SUBSTRING_INDEX(SUBSTRING_INDEX(txt, delimiter_text, token_index), delimiter_text, -1);
  end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `trim_wspace` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `trim_wspace`(txt TEXT CHARSET utf8) RETURNS text CHARSET utf8
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT 'Trim whitespace characters on both sides'
begin
  declare len INT UNSIGNED DEFAULT 0;
  declare done TINYINT UNSIGNED DEFAULT 0;
  if txt IS NULL then
    return txt;
  end if;
  while not done do
    set len := CHAR_LENGTH(txt);
    set txt = trim(' ' FROM txt);
    set txt = trim('\r' FROM txt);
    set txt = trim('\n' FROM txt);
    set txt = trim('\t' FROM txt);
    set txt = trim('\b' FROM txt);
    if CHAR_LENGTH(txt) = len then
      set done := 1;
    end if;
  end while;
  return txt;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `unquote` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `unquote`(txt TEXT CHARSET utf8) RETURNS text CHARSET utf8
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT 'Unquotes a given text'
begin
  declare quoting_char VARCHAR(1) CHARSET utf8;
  declare terminating_quote_escape_char VARCHAR(1) CHARSET utf8;
  declare current_pos INT UNSIGNED;
  declare end_quote_pos INT UNSIGNED;

  if CHAR_LENGTH(txt) < 2 then
    return txt;
  end if;
  
  set quoting_char := LEFT(txt, 1);
  if not quoting_char in ('''', '"', '`', '/') then
    return txt;
  end if;
  if txt in ('''''', '""', '``', '//') then
    return '';
  end if;
  
  set current_pos := 1;
  terminating_quote_loop: while current_pos > 0 do
    set current_pos := LOCATE(quoting_char, txt, current_pos + 1);
    if current_pos = 0 then
      
      return txt;
    end if;
    if SUBSTRING(txt, current_pos, 2) = REPEAT(quoting_char, 2) then
      set current_pos := current_pos + 1;
      iterate terminating_quote_loop;
    end if;
    set terminating_quote_escape_char := SUBSTRING(txt, current_pos - 1, 1);
    if (terminating_quote_escape_char = quoting_char) or (terminating_quote_escape_char = '\\') then
      
      
      iterate terminating_quote_loop;
    end if;
    
    leave terminating_quote_loop;
  end while;
  if current_pos = CHAR_LENGTH(txt) then
      return SUBSTRING(txt, 2, CHAR_LENGTH(txt) - 2);
    end if;
  return txt;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `unwrap` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `unwrap`(txt TEXT CHARSET utf8) RETURNS text CHARSET utf8
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT 'Unwraps a given text from braces'
begin
  if CHAR_LENGTH(txt) < 2 then
    return txt;
  end if;
  if LEFT(txt, 1) = '{' AND RIGHT(txt, 1) = '}' then
    return SUBSTRING(txt, 2, CHAR_LENGTH(txt) - 2);
  end if;
  if LEFT(txt, 1) = '[' AND RIGHT(txt, 1) = ']' then
    return SUBSTRING(txt, 2, CHAR_LENGTH(txt) - 2);
  end if;
  if LEFT(txt, 1) = '(' AND RIGHT(txt, 1) = ')' then
    return SUBSTRING(txt, 2, CHAR_LENGTH(txt) - 2);
  end if;
  return txt;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnGetLCRCodeByRankNumber` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnGetLCRCodeByRankNumber`(IN `p_companyid` INT, IN `p_codedeckID` INT, IN `p_CurrencyID` INT, IN `p_trunkID` INT, IN `p_code` VARCHAR(50), IN `p_Preference` INT, IN `p_ranknumber` INT,  IN `p_IncludeAccountIDs` TEXT  , IN `p_ExcludeAccountIDs` TEXT)
BEGIN


CALL fnVendorCurrentRates(p_companyid, p_codedeckID, p_trunkID, p_CurrencyID, p_code, p_IncludeAccountIDs);

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
     rankname INT
   );

IF ( SELECT
    COUNT(*)
  FROM tmp_VendorCurrentRates_) > 0 THEN       
       
  DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateByRank_stage_;
  CREATE TEMPORARY TABLE tmp_VendorRateByRank_stage_ (
     AccountId INT ,
     AccountName VARCHAR(100) ,
     Code VARCHAR(50) ,
     Rate DECIMAL(18,6) ,
     ConnectionFee DECIMAL(18,6) ,
     EffectiveDate DATETIME ,
     Description VARCHAR(255),
     TrunkID INT ,
     RateId INT ,
     Preference INT , 
     RowID INT
   );


INSERT IGNORE INTO tmp_VendorRateByRank_stage_
  SELECT
    AccountId,
    AccountName,
    Code,
    Rate,
    ConnectionFee,  
    EffectiveDate,
    Description,
    TrunkID,
    RateId,
    Preference,
    RowID
  FROM (SELECT DISTINCT
      v.AccountId,
      v.AccountName,
      v.Code,
      v.Rate,
      v.ConnectionFee,
      v.EffectiveDate,
      v.Description,
      v.TrunkID,
      v.RateId,
      vp.Preference,
      @row_num := IF(@prev_AccountId = v.AccountId AND @prev_TrunkID = v.TrunkID AND @prev_RateId = v.RateId AND @prev_EffectiveDate >= v.effectivedate, @row_num + 1, 1) AS RowID,
      @prev_AccountId := v.AccountId,
      @prev_TrunkID := v.TrunkID,
      @prev_RateId := v.RateId,
      @prev_EffectiveDate := v.effectivedate
    FROM tmp_VendorCurrentRates_ v
           LEFT JOIN tblVendorPreference vp
             ON vp.AccountId = v.AccountId
             AND vp.TrunkID = v.TrunkID
             AND vp.RateId = v.RateId,
         (SELECT
             @row_num := 1) x,
         (SELECT
             @prev_AccountId := '') a,
         (SELECT
             @prev_TrunkID := '') b,
         (SELECT
             @prev_RateId := '') c,
         (SELECT
             @prev_EffectiveDate := '') d
    WHERE p_ExcludeAccountIDs = ''
    OR (p_ExcludeAccountIDs != ''
    AND FIND_IN_SET(v.AccountId, p_ExcludeAccountIDs) = 0)
    ORDER BY v.AccountId, v.TrunkID, v.RateId, v.EffectiveDate DESC) tbl
  WHERE RowID = 1;

 

 DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_;

 

IF p_Preference = 1 THEN


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
      IFNULL(Preference, 5) AS Preference,
      @preference_rank := CASE WHEN (@prev_Code COLLATE utf8_unicode_ci = Code AND @prev_Preference > IFNULL(Preference, 5)  ) THEN @preference_rank + 1 
                               WHEN (@prev_Code COLLATE utf8_unicode_ci = Code AND @prev_Preference = IFNULL(Preference, 5) AND @prev_Rate < Rate) THEN @preference_rank + 1 
                               WHEN (@prev_Code COLLATE utf8_unicode_ci = Code AND @prev_Preference = IFNULL(Preference, 5) AND @prev_Rate = Rate) THEN @preference_rank 
                               ELSE 1 
                               END AS preference_rank,
      @prev_Code := Code,
      @prev_Preference := IFNULL(Preference, 5),
      @prev_Rate := Rate
    FROM tmp_VendorRateByRank_stage_ AS preference,
         (SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
    ORDER BY preference.Code ASC, preference.Preference DESC, preference.Rate ASC,preference.AccountId ASC
       
     ) tbl
  WHERE preference_rank <= p_ranknumber
  ORDER BY Code, preference_rank;

ELSE



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
      @rank := CASE WHEN (@prev_Code COLLATE utf8_unicode_ci = Code AND @prev_Rate < Rate) THEN @rank + 1 
                    WHEN (@prev_Code COLLATE utf8_unicode_ci = Code AND @prev_Rate = Rate) THEN @rank 
                    ELSE 1 
                    END AS RateRank,
      @prev_Code := Code,
      @prev_Rate := Rate
    FROM tmp_VendorRateByRank_stage_ AS rank,
         (SELECT @rank := 0 , @prev_Code := '' , @prev_Rate := 0) f
    ORDER BY rank.Code ASC, rank.Rate,rank.AccountId ASC) tbl
  WHERE RateRank <= p_ranknumber
  ORDER BY Code, RateRank;

END IF;
END IF;     

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnVendorCurrentRates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnVendorCurrentRates`(IN `p_companyid` INT , IN `p_codedeckID` INT, IN `p_trunkID` INT , IN `p_CurrencyID` INT , IN `p_code` VARCHAR(50) , IN `p_accountIDs` TEXT 
    )
BEGIN
 			    
	DECLARE v_CompanyCurrencyID_ INT; 			    
	
	
	
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
			INDEX tmp_VendorCurrentRates_AccountId (`AccountId`,`TrunkID`,`RateId`,`EffectiveDate`)
	);

  SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = p_companyid;


	INSERT INTO tmp_VendorCurrentRates_ 
	  Select DISTINCT AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference					
       FROM (	    
                SELECT tblVendorRate.AccountId,tblAccount.AccountName, tblRate.Code, tblRate.Description, 
                
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
          					  			
                					  (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = p_CurrencyID and  CompanyID = p_companyid )
          					  		* (tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ))
          					  )
          					 END
          						as  Rate,
                                   ConnectionFee,
          	  DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate, 
          	  tblVendorRate.TrunkID, tblRate.CountryID, tblRate.RateID,
                              @row_num := IF(@prev_AccountId = tblVendorRate.AccountID AND @prev_TrunkID = tblVendorRate.TrunkID AND @prev_RateId = tblVendorRate.RateID AND @prev_EffectiveDate >= tblVendorRate.EffectiveDate, @row_num + 1, 1) AS RowID,
          				@prev_AccountId := tblVendorRate.AccountID,
          				@prev_TrunkID := tblVendorRate.TrunkID,
          				@prev_RateId := tblVendorRate.RateID,
          				@prev_EffectiveDate := tblVendorRate.EffectiveDate
                FROM      tblVendorRate
          			 Inner join tblVendorTrunk vt on vt.CompanyID = p_companyid AND vt.AccountID = tblVendorRate.AccountID and 
                              ( p_codedeckID = 0 OR ( p_codedeckID > 0 AND vt.CodeDeckId = p_codedeckID ) )
                              and vt.Status =  1 and vt.TrunkID =  p_trunkID  
                          INNER JOIN tblAccount   ON  tblAccount.CompanyID = p_companyid AND tblVendorRate.AccountId = tblAccount.AccountID 
                          INNER JOIN tblRate  ON tblRate.CompanyID = p_companyid  AND tblRate.CodeDeckId = vt.CodeDeckId  AND    tblVendorRate.RateId = tblRate.RateID
                          LEFT OUTER JOIN tblVendorBlocking AS blockCode   ON tblVendorRate.RateId = blockCode.RateId
                                                                        AND tblVendorRate.AccountId = blockCode.AccountId
                                                                        AND tblVendorRate.TrunkID = blockCode.TrunkID
                          LEFT OUTER JOIN tblVendorBlocking AS blockCountry    ON tblRate.CountryID = blockCountry.CountryId
                                                                        AND tblVendorRate.AccountId = blockCountry.AccountId
                                                                        AND tblVendorRate.TrunkID = blockCountry.TrunkID
                         ,(SELECT @row_num := 1,  @prev_AccountId := '',@prev_TrunkID := '', @prev_RateId := '', @prev_EffectiveDate := '') x
                WHERE      
                          ( EffectiveDate <= NOW() )
                          
                          
                          AND tblAccount.IsVendor = 1
                          AND tblAccount.Status = 1
                          AND tblAccount.CurrencyId is not NULL
                          AND tblVendorRate.TrunkID = p_trunkID
                          AND ( CHAR_LENGTH(RTRIM(p_code)) = 0
                                OR tblRate.Code LIKE REPLACE(p_code,'*', '%')
                              )
                          AND blockCode.RateId IS NULL
                         AND blockCountry.CountryId IS NULL
                          AND ( p_accountIDs = ''
                                OR ( p_accountIDs != ''
                                     AND FIND_IN_SET(tblVendorRate.AccountId,p_accountIDs) > 0                    
                                   )
                              )

             ORDER BY tblVendorRate.AccountId, tblVendorRate.TrunkID, tblVendorRate.RateId, tblVendorRate.EffectiveDate DESC	
	     ) tbl
		 WHERE RowID = 1
		order by Code asc;
          
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnVendorSippySheet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnVendorSippySheet`(IN `p_AccountID` int, IN `p_Trunks` longtext, IN `p_Effective` VARCHAR(50))
BEGIN
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorSippySheet_(
            RateID int,
            `Action [A|D|U|S|SA` varchar(50),
            id varchar(10),
            Prefix varchar(50),
            COUNTRY varchar(200),
            Preference int,
            `Interval 1` int,
            `Interval N` int,
            `Price 1` float,
            `Price N` float,
            `1xx Timeout` int,
            `2xx Timeout` INT,
            Huntstop int,
            Forbidden int,
            `Activation Date` varchar(10),
            `Expiration Date` varchar(10),
            AccountID int,
            TrunkID int
    );
    

    call vwVendorCurrentRates(p_AccountID,p_Trunks,p_Effective); 
    
        SELECT NULL AS RateID,
               'A' AS `Action [A|D|U|S|SA]`,
               '' AS id,
               Concat(tblTrunk.Prefix , vendorRate.Code)  AS PREFIX,
               vendorRate.Description AS COUNTRY,
               5 AS Preference,
               CASE
                   WHEN vendorRate.Description LIKE '%gambia%'
                        OR vendorRate.Description LIKE '%mexico%' THEN 60
                   ELSE 1
               END AS `Interval 1`,
               CASE
                   WHEN vendorRate.Description LIKE '%mexico%' THEN 60
                   ELSE 1
               END AS `Interval N`,
               vendorRate.Rate AS `Price 1`,
               vendorRate.Rate AS `Price N`,
               10 AS `1xx Timeout`,
               60 AS `2xx Timeout`,
               0 AS Huntstop,
               CASE WHEN (tblVendorBlocking.VendorBlockingId IS NOT NULL AND  FIND_IN_SET(vendorRate.TrunkId,p_Trunks) != 0) OR (blockCountry.VendorBlockingId IS NOT NULL AND FIND_IN_SET(vendorRate.TrunkId,p_Trunks) != 0 ) 
                THEN 1 
                ELSE 0 
                END AS Forbidden,
               'NOW' AS `Activation Date`,
               '' AS `Expiration Date`,
               tblAccount.AccountID,
               tblTrunk.TrunkID
        FROM tmp_VendorSippySheet_ AS vendorRate
        INNER JOIN tblAccount ON vendorRate.AccountId = tblAccount.AccountID
        LEFT OUTER JOIN tblVendorBlocking ON vendorRate.RateID = tblVendorBlocking.RateId
        AND tblAccount.AccountID = tblVendorBlocking.AccountId
        AND vendorRate.TrunkID = tblVendorBlocking.TrunkID
        LEFT OUTER JOIN tblVendorBlocking AS blockCountry ON vendorRate.CountryID = blockCountry.CountryId
        AND tblAccount.AccountID = blockCountry.AccountId
        AND vendorRate.TrunkID = blockCountry.TrunkID
        INNER JOIN tblTrunk ON tblTrunk.TrunkID = vendorRate.TrunkID
        WHERE vendorRate.AccountId = p_AccountID
          AND FIND_IN_SET(vendorRate.TrunkId,p_Trunks) != 0
          AND vendorRate.Rate > 0;


     
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_AccountPaymentReminder` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_AccountPaymentReminder`(IN `p_CompanyID` INT, IN `p_AccountID` INT, IN `p_BillingClassID` INT)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	CALL wavetelwholesaleBilling.prc_updateSOAOffSet(p_CompanyID,p_AccountID);
	
	
	SELECT
		a.AccountID,
		ab.SOAOffset
	FROM tblAccountBalance ab 
	INNER JOIN tblAccount a 
		ON a.AccountID = ab.AccountID
	INNER JOIN tblAccountBilling abg 
		ON abg.AccountID  = a.AccountID
	INNER JOIN tblBillingClass b
		ON b.BillingClassID = abg.BillingClassID
	WHERE a.CompanyId = p_CompanyID
	AND (p_AccountID = 0 OR  a.AccountID = p_AccountID)
	AND (p_BillingClassID = 0 OR  b.BillingClassID = p_BillingClassID)
	AND ab.SOAOffset > 0
	AND a.`Status` = 1;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_ActiveCronJobEmail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_ActiveCronJobEmail`(IN `p_CompanyID` INT)
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT
		tblCronJobCommand.*,
		tblCronJob.*
	FROM tblCronJob
	INNER JOIN tblCronJobCommand
		ON tblCronJobCommand.CronJobCommandID = tblCronJob.CronJobCommandID
	WHERE tblCronJob.CompanyID = p_CompanyID
	AND tblCronJob.Active = 1
	AND tblCronJobCommand.Command != 'activecronjobemail';
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_AddAccountIPCLI` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_AddAccountIPCLI`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_CustomerVendorCheck` INT,
	IN `p_IPCLIString` LONGTEXT,
	IN `p_IPCLICheck` LONGTEXT

)
BEGIN

	DECLARE i int;
	DECLARE v_COUNTER int;
	DECLARE v_IPCLI LONGTEXT;
	DECLARE v_IPCLICheck VARCHAR(10);
	DECLARE v_Check int;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DROP TEMPORARY TABLE IF EXISTS `AccountIPCLI`; 
		CREATE TEMPORARY TABLE `AccountIPCLI` (
		  `AccountName` varchar(45) NOT NULL,
		  `IPCLI` LONGTEXT NOT NULL
		);

	DROP TEMPORARY TABLE IF EXISTS `AccountIPCLITable1`; 
		CREATE TEMPORARY TABLE `AccountIPCLITable1` (
		  `splitted_column` varchar(45) NOT NULL
		);
		
	DROP TEMPORARY TABLE IF EXISTS `AccountIPCLITable2`; 
		CREATE TEMPORARY TABLE `AccountIPCLITable2` (
		  `splitted_column` varchar(45) NOT NULL
		);
	
		
	INSERT INTO AccountIPCLI
	SELECT acc.AccountName,
	CONCAT(
	IFNULL(((CASE WHEN CustomerAuthRule = p_IPCLICheck THEN accauth.CustomerAuthValue ELSE '' END)),''),',',
	IFNULL(((CASE WHEN VendorAuthRule = p_IPCLICheck THEN accauth.VendorAuthValue ELSE '' END)),'')) as Authvalue
	FROM tblAccountAuthenticate accauth
	INNER JOIN tblAccount acc ON acc.AccountID = accauth.AccountID
	AND accauth.CompanyID = p_CompanyID
	AND ((CustomerAuthRule = p_IPCLICheck) OR (VendorAuthRule = p_IPCLICheck))
	WHERE (SELECT wavetelwholesaleRM.fnFIND_IN_SET(CONCAT(IFNULL(accauth.CustomerAuthValue,''),',',IFNULL(accauth.VendorAuthValue,'')),p_IPCLIString)) > 0;
	
	SELECT COUNT(AccountName) INTO v_COUNTER FROM AccountIPCLI;
	
	
	IF v_COUNTER > 0 THEN
		SELECT *  FROM AccountIPCLI;
		
		
		SET i = 1;
		REPEAT
			INSERT INTO AccountIPCLITable1
			SELECT wavetelwholesaleRM.FnStringSplit(p_IPCLIString, ',', i) WHERE wavetelwholesaleRM.FnStringSplit(p_IPCLIString, ',', i) IS NOT NULL LIMIT 1;
			SET i = i + 1;
			UNTIL ROW_COUNT() = 0
		END REPEAT;
		
		
		INSERT INTO AccountIPCLITable2
		SELECT AccountIPCLITable1.splitted_column FROM AccountIPCLI,AccountIPCLITable1
		WHERE FIND_IN_SET(AccountIPCLITable1.splitted_column,AccountIPCLI.IPCLI)>0
		GROUP BY AccountIPCLITable1.splitted_column;
		
		
		DELETE t1 FROM AccountIPCLITable1 t1
		INNER JOIN AccountIPCLITable2 t2 ON t1.splitted_column = t2.splitted_column
		WHERE t1.splitted_column=t2.splitted_column;
		
		SELECT GROUP_CONCAT(t.splitted_column separator ',') INTO p_IPCLIString FROM AccountIPCLITable1 t;
		
		
		DELETE t1,t2 FROM AccountIPCLITable1 t1,AccountIPCLITable2 t2;
	END IF;
	
	
	SELECT 
	accauth.AccountAuthenticateID, 
	(CASE WHEN p_CustomerVendorCheck = 1 THEN accauth.CustomerAuthValue ELSE accauth.VendorAuthValue END) as AuthValue,
	(CASE WHEN p_CustomerVendorCheck = 1 THEN accauth.CustomerAuthRule ELSE accauth.VendorAuthRule END) as AuthRule INTO v_Check,v_IPCLI,v_IPCLICheck
	FROM tblAccountAuthenticate accauth 
	WHERE accauth.CompanyID =  p_CompanyID
	AND accauth.AccountID = p_AccountID;
			
	IF v_Check > 0 && p_IPCLIString IS NOT NULL && p_IPCLIString!='' THEN
		IF v_IPCLICheck != p_IPCLICheck THEN
		
			IF p_CustomerVendorCheck = 1 THEN
				UPDATE tblAccountAuthenticate accauth SET accauth.CustomerAuthValue = ''
				WHERE accauth.CompanyID =  p_CompanyID
				AND accauth.AccountID = p_AccountID;
			ELSEIF p_CustomerVendorCheck = 2 THEN
				UPDATE tblAccountAuthenticate accauth SET accauth.VendorAuthValue = ''
				WHERE accauth.CompanyID =  p_CompanyID
				AND accauth.AccountID = p_AccountID;
			END IF;
			SET v_IPCLI = p_IPCLIString;
		ELSE
			
				SET i = 1;
				REPEAT
					INSERT INTO AccountIPCLITable1
					SELECT wavetelwholesaleRM.FnStringSplit(v_IPCLI, ',', i) WHERE wavetelwholesaleRM.FnStringSplit(v_IPCLI, ',', i) IS NOT NULL LIMIT 1;
					SET i = i + 1;
					UNTIL ROW_COUNT() = 0
				END REPEAT;
			
				SET i = 1;
				REPEAT
					INSERT INTO AccountIPCLITable2
					SELECT wavetelwholesaleRM.FnStringSplit(p_IPCLIString, ',', i) WHERE wavetelwholesaleRM.FnStringSplit(p_IPCLIString, ',', i) IS NOT NULL LIMIT 1;
					SET i = i + 1;
					UNTIL ROW_COUNT() = 0
				END REPEAT;
				
				
				SELECT GROUP_CONCAT(t.splitted_column separator ',') INTO v_IPCLI
				FROM
				(
				SELECT splitted_column FROM AccountIPCLITable1
				UNION
				SELECT splitted_column FROM AccountIPCLITable2
				GROUP BY splitted_column
				ORDER BY splitted_column
				) t;
		END IF;
			
			
		IF p_CustomerVendorCheck = 1 THEN
			UPDATE tblAccountAuthenticate accauth SET accauth.CustomerAuthValue = v_IPCLI, accauth.CustomerAuthRule = p_IPCLICheck
			WHERE accauth.CompanyID =  p_CompanyID
			AND accauth.AccountID = p_AccountID;
		ELSEIF p_CustomerVendorCheck = 2 THEN
			UPDATE tblAccountAuthenticate accauth SET accauth.VendorAuthValue = v_IPCLI, accauth.VendorAuthRule = p_IPCLICheck
			WHERE accauth.CompanyID =  p_CompanyID
			AND accauth.AccountID = p_AccountID;
		END IF;
	ELSEIF v_Check IS NULL && p_IPCLIString IS NOT NULL && p_IPCLIString!='' THEN
	
		IF p_CustomerVendorCheck = 1 THEN
			INSERT INTO tblAccountAuthenticate(CompanyID,AccountID,CustomerAuthRule,CustomerAuthValue)
			SELECT p_CompanyID,p_AccountID,p_IPCLICheck,p_IPCLIString;
		ELSEIF p_CustomerVendorCheck = 2 THEN
			INSERT INTO tblAccountAuthenticate(CompanyID,AccountID,VendorAuthRule,VendorAuthValue)
			SELECT p_CompanyID,p_AccountID,p_IPCLICheck,p_IPCLIString;
		END IF;
	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_applyAccountDiscountPlan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_applyAccountDiscountPlan`(IN `p_AccountID` INT, IN `p_tbltempusagedetail_name` VARCHAR(200), IN `p_processId` INT, IN `p_inbound` INT)
BEGIN
	
	DECLARE v_DiscountPlanID_ INT;
	DECLARE v_AccountDiscountPlanID_ INT;
	DECLARE v_StartDate DATE;
	DECLARE v_EndDate DATE;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_codes_;
	CREATE TEMPORARY TABLE tmp_codes_ (
		RateID INT,
		Code VARCHAR(50),
		DiscountID INT
	);
	
	DROP TEMPORARY TABLE IF EXISTS tmp_discountsecons_;
	CREATE TEMPORARY TABLE tmp_discountsecons_ (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		TempUsageDetailID INT,
		TotalSecond INT,
		AccountDiscountPlanID INT,
		DiscountID INT,
		RemainingSecond INT,
		Discount INT,
		ThresholdReached INT DEFAULT 0,
		Unlimited INT
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_discountsecons2_;
	CREATE TEMPORARY TABLE tmp_discountsecons2_ (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		TempUsageDetailID INT,
		TotalSecond INT,
		AccountDiscountPlanID INT,
		DiscountID INT,
		RemainingSecond INT,
		Discount INT,
		ThresholdReached INT DEFAULT 0,
		Unlimited INT
	);
	
	
	SELECT AccountDiscountPlanID,DiscountPlanID,StartDate,EndDate INTO  v_AccountDiscountPlanID_,v_DiscountPlanID_,v_StartDate,v_EndDate FROM tblAccountDiscountPlan WHERE AccountID = p_AccountID AND 
	( (p_inbound = 0 AND Type = 1) OR  (p_inbound = 1 AND Type = 2 ) );
	
	
	INSERT INTO tmp_codes_
	SELECT 
		r.RateID,
		r.Code,
		d.DiscountID
	FROM tblDiscountPlan dp
	INNER JOIN tblDiscount d ON d.DiscountPlanID = dp.DiscountPlanID
	INNER JOIN tblDestinationGroupCode dgc ON dgc.DestinationGroupID = d.DestinationGroupID
	INNER JOIN tblRate r ON r.RateID = dgc.RateID
	WHERE dp.DiscountPlanID = v_DiscountPlanID_;
	
	
	SET @stm = CONCAT('
	INSERT INTO tmp_discountsecons_ (TempUsageDetailID,TotalSecond,DiscountID)
	SELECT 
		d.TempUsageDetailID,
		@t := IF(@pre_DiscountID = d.DiscountID, @t + TotalSecond,TotalSecond) as TotalSecond,
		@pre_DiscountID := d.DiscountID
	FROM
	(
		SELECT 
			billed_duration as TotalSecond,
			TempUsageDetailID,
			area_prefix,
			DiscountID,
			AccountID
		FROM wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' ud
		INNER JOIN tmp_codes_ c
			ON ud.ProcessID = ' , p_processId , '
			AND ud.is_inbound = ',p_inbound,' 
			AND ud.AccountID = ' , p_AccountID , '
			AND area_prefix =  c.Code
			AND DATE(ud.disconnect_time) >= "', v_StartDate ,'"
			AND DATE(ud.disconnect_time) < "',v_EndDate, '"
		ORDER BY c.DiscountID asc , disconnect_time asc
	) d
	CROSS JOIN (SELECT @t := 0) i
	CROSS JOIN (SELECT @pre_DiscountID := 0) j
	');
	
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	
	
	UPDATE tmp_discountsecons_ SET AccountDiscountPlanID  = v_AccountDiscountPlanID_;
	
	
	UPDATE tmp_discountsecons_ d
	INNER JOIN tblAccountDiscountPlan adp 
 		ON adp.AccountID = p_AccountID
	INNER JOIN tblAccountDiscountScheme adc 
		ON adc.AccountDiscountPlanID =  adp.AccountDiscountPlanID 
		AND adc.DiscountID = d.DiscountID AND adp.AccountDiscountPlanID = d.AccountDiscountPlanID
	SET d.RemainingSecond = (adc.Threshold - adc.SecondsUsed),d.Discount=adc.Discount,d.Unlimited = adc.Unlimited;
	
	
	UPDATE  tmp_discountsecons_ SET ThresholdReached=1   WHERE Unlimited = 0 AND TotalSecond > RemainingSecond;
	
	INSERT INTO tmp_discountsecons2_
	SELECT * FROM tmp_discountsecons_;
	
	
	SET @stm = CONCAT('
	UPDATE wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' ud  INNER JOIN
	tmp_discountsecons_ d ON d.TempUsageDetailID = ud.TempUsageDetailID 
	SET cost = (cost - d.Discount*cost/100)
	WHERE ThresholdReached = 0;
	');
	
	PREPARE stmt FROM @stm;
 	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	
	UPDATE tblAccountDiscountPlan adp 
	INNER JOIN tblAccountDiscountScheme adc 
		ON adc.AccountDiscountPlanID =  adp.AccountDiscountPlanID 
	INNER JOIN(
		SELECT 
			MAX(TotalSecond) as SecondsUsed,
			DiscountID,
			AccountDiscountPlanID 
		FROM tmp_discountsecons_
		WHERE ThresholdReached = 0
		GROUP BY DiscountID,AccountDiscountPlanID
	)d 
	ON adc.DiscountID = d.DiscountID
	SET adc.SecondsUsed = adc.SecondsUsed+d.SecondsUsed
	WHERE adp.AccountID = p_AccountID AND adp.AccountDiscountPlanID = d.AccountDiscountPlanID;
	

	
	SET @stm =CONCAT('
	UPDATE tmp_discountsecons_ d
	INNER JOIN( 
		SELECT MIN(RowID) as RowID  FROM tmp_discountsecons2_ WHERE ThresholdReached = 1
	GROUP BY DiscountID
	) tbl ON tbl.RowID = d.RowID
	INNER JOIN wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' ud
		ON ud.TempUsageDetailID = d.TempUsageDetailID
	INNER JOIN tblAccountDiscountPlan adp 
	 		ON adp.AccountID = ',p_AccountID,'
	INNER JOIN tblAccountDiscountScheme adc 
			ON adc.AccountDiscountPlanID =  adp.AccountDiscountPlanID 
			AND adc.DiscountID = d.DiscountID AND d.AccountDiscountPlanID = adp.AccountDiscountPlanID
	SET ud.cost = cost*(TotalSecond - RemainingSecond)/billed_duration,adc.SecondsUsed = adc.SecondsUsed + billed_duration - (TotalSecond - RemainingSecond);
	');
	
	PREPARE stmt FROM @stm;
 	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_ArchiveOldCustomerRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_ArchiveOldCustomerRate`(IN `p_CustomerIds` longtext, IN `p_TrunkIds` longtext)
BEGIN
	 SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		DELETE cr
      FROM tblCustomerRate cr
      INNER JOIN tblCustomerRate cr2
      ON cr2.CustomerID = cr.CustomerID
      AND cr2.TrunkID = cr.TrunkID
      AND cr2.RateID = cr.RateID
      WHERE  FIND_IN_SET(cr.CustomerID,p_CustomerIds) != 0 AND FIND_IN_SET(cr.TrunkID,p_TrunkIds) != 0 AND cr.EffectiveDate <= NOW()
			AND FIND_IN_SET(cr2.CustomerID,p_CustomerIds) != 0 AND FIND_IN_SET(cr2.TrunkID,p_TrunkIds) != 0 AND cr2.EffectiveDate <= NOW()
         AND cr.EffectiveDate < cr2.EffectiveDate;

	DROP TEMPORARY TABLE IF EXISTS _tmp_ArchiveOldEffectiveRates;
   CREATE TEMPORARY TABLE _tmp_ArchiveOldEffectiveRates (
    	  RowID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
     	  CustomerRateID INT,
        RateID INT,
        CustomerID INT,
        TrunkId INT,
        Rate DECIMAL(18, 6),
        EffectiveDate DATETIME,
        INDEX _tmp_ArchiveOldEffectiveRates_CustomerRateID (`CustomerRateID`,`RateID`,`TrunkId`)
	);
	DROP TEMPORARY TABLE IF EXISTS _tmp_ArchiveOldEffectiveRates2;
	CREATE TEMPORARY TABLE _tmp_ArchiveOldEffectiveRates2 (
    	  RowID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
     	  CustomerRateID INT,
        RateID INT,
        CustomerID INT,
        TrunkId INT,
        Rate DECIMAL(18, 6),
        EffectiveDate DATETIME,
       INDEX _tmp_ArchiveOldEffectiveRates_CustomerRateID (`CustomerRateID`,`RateID`,`TrunkId`)
	);

    


    
   INSERT INTO _tmp_ArchiveOldEffectiveRates (CustomerRateID,RateID,CustomerID,TrunkID,Rate,EffectiveDate)	
	SELECT
	   cr.CustomerRateID,
	   cr.RateID,
	   cr.CustomerID,
	   cr.TrunkID,
	   cr.Rate,
	   cr.EffectiveDate
	FROM tblCustomerRate cr
	WHERE  FIND_IN_SET(cr.CustomerID,p_CustomerIds) != 0 AND FIND_IN_SET(cr.TrunkID,p_TrunkIds) != 0 
	ORDER BY cr.CustomerID ASC,cr.TrunkID ,cr.RateID ASC,EffectiveDate ASC;
	
	INSERT INTO _tmp_ArchiveOldEffectiveRates2
	SELECT * FROM _tmp_ArchiveOldEffectiveRates;

    DELETE tblCustomerRate
        FROM tblCustomerRate
        INNER JOIN(
        SELECT
            tt.CustomerRateID
        FROM _tmp_ArchiveOldEffectiveRates t
        INNER JOIN _tmp_ArchiveOldEffectiveRates2 tt
            ON tt.RowID = t.RowID + 1
            AND  t.CustomerId = tt.CustomerId
			AND  t.TrunkId = tt.TrunkId
            AND t.RateID = tt.RateID
            AND t.Rate = tt.Rate) aold on aold.CustomerRateID = tblCustomerRate.CustomerRateID;

     
   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_ArchiveOldRateTableRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_ArchiveOldRateTableRate`(IN `p_RateTableId` INT)
BEGIN

 	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;  
 	
 	DELETE rtr
      FROM tblRateTableRate rtr
      INNER JOIN tblRateTableRate rtr2
      ON rtr.RateTableId = rtr2.RateTableId
      AND rtr.RateID = rtr2.RateID
      WHERE  FIND_IN_SET(rtr.RateTableId,p_RateTableId) != 0  AND rtr.EffectiveDate <= NOW()
			AND FIND_IN_SET(rtr2.RateTableId,p_RateTableId) != 0 AND rtr2.EffectiveDate <= NOW()
         AND rtr.EffectiveDate < rtr2.EffectiveDate;
    
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_ArchiveOldVendorRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_ArchiveOldVendorRate`(IN `p_AccountIds` longtext
, IN `p_TrunkIds` longtext)
BEGIN
 	 SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	
   DELETE vr
      FROM tblVendorRate vr
      INNER JOIN tblVendorRate vr2
      ON vr2.AccountId = vr.AccountId
      AND vr2.TrunkID = vr.TrunkID
      AND vr2.RateID = vr.RateID
      WHERE  FIND_IN_SET(vr.AccountId,p_AccountIds) != 0 AND FIND_IN_SET(vr.TrunkID,p_TrunkIds) != 0 AND vr.EffectiveDate <= NOW()
			AND FIND_IN_SET(vr2.AccountId,p_AccountIds) != 0 AND FIND_IN_SET(vr2.TrunkID,p_TrunkIds) != 0 AND vr2.EffectiveDate <= NOW()
         AND vr.EffectiveDate < vr2.EffectiveDate;
	
   DROP TEMPORARY TABLE IF EXISTS _tmp_ArchiveOldEffectiveRates;
   CREATE TEMPORARY TABLE _tmp_ArchiveOldEffectiveRates (
    	  RowID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
     	  VendorRateID INT,
        RateID INT,
        CustomerID INT,
        TrunkId INT,
        Rate DECIMAL(18, 6),
        EffectiveDate DATETIME,
        INDEX _tmp_ArchiveOldEffectiveRates_VendorRateID (`VendorRateID`,`RateID`,`TrunkId`,`CustomerID`)
	);
	DROP TEMPORARY TABLE IF EXISTS _tmp_ArchiveOldEffectiveRates2;
	CREATE TEMPORARY TABLE _tmp_ArchiveOldEffectiveRates2 (
    	  RowID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
     	  VendorRateID INT,
        RateID INT,
        CustomerID INT,
        TrunkId INT,
        Rate DECIMAL(18, 6),
        EffectiveDate DATETIME,
       INDEX _tmp_ArchiveOldEffectiveRates_VendorRateID (`VendorRateID`,`RateID`,`TrunkId`,`CustomerID`)
	);

    


    
   INSERT INTO _tmp_ArchiveOldEffectiveRates (VendorRateID,RateID,CustomerID,TrunkID,Rate,EffectiveDate)	
	SELECT
	   VendorRateID,
	   RateID,
	   AccountId,
	   TrunkID,
	   Rate,
	   EffectiveDate
	FROM tblVendorRate 
	WHERE  FIND_IN_SET(AccountId,p_AccountIds) != 0 AND FIND_IN_SET(TrunkID,p_TrunkIds) != 0 
	ORDER BY AccountId ASC,TrunkID ,RateID ASC,EffectiveDate ASC;
	
	INSERT INTO _tmp_ArchiveOldEffectiveRates2
	SELECT * FROM _tmp_ArchiveOldEffectiveRates;

	
    DELETE tblVendorRate
        FROM tblVendorRate
        INNER JOIN(
        SELECT
            tt.VendorRateID
        FROM _tmp_ArchiveOldEffectiveRates t
        INNER JOIN _tmp_ArchiveOldEffectiveRates2 tt
            ON tt.RowID = t.RowID + 1
            AND  t.CustomerID = tt.CustomerID
			   AND  t.TrunkId = tt.TrunkId
            AND t.RateID = tt.RateID
            AND t.Rate = tt.Rate) aold on aold.VendorRateID = tblVendorRate.VendorRateID;
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_BlockVendorCodes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_BlockVendorCodes`(IN `p_companyid` INT , IN `p_AccountId` TEXT, IN `p_trunkID` INT, IN `p_CountryIDs` TEXT, IN `p_Codes` TEXT, IN `p_Username` VARCHAR(100), IN `p_action` INT, IN `p_isCountry` INT, IN `p_isAllCountry` INT, IN `p_criteria` INT)
BEGIN	 

		
	 SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;	
	 
	 
		
  	IF p_isAllCountry = 1		
	THEN	
		SELECT GROUP_CONCAT(CountryID) INTO p_CountryIDs  FROM tblCountry;
	END IF;
	
	IF p_isCountry = 0
	THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_codes_;
	   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_codes_(
				Code varchar(20)
		);
	END IF;	
	
   		IF p_criteria = 0 and p_isCountry = 0 
		THEN
   		insert into tmp_codes_
		   SELECT  distinct tblRate.Code 
            FROM    tblRate
          INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId  AND tblVendorRate.TrunkID = p_trunkID   
          INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId  AND tblVendorTrunk.TrunkID = p_trunkID   
           WHERE    tblRate.CompanyID = p_companyid  AND ( p_Codes  = '' OR FIND_IN_SET(tblRate.Code,p_Codes) != 0 );
        END IF;   

        IF p_criteria = 1 and p_isCountry = 0 
		THEN
   		insert into tmp_codes_
		   SELECT  distinct tblRate.Code 
            FROM    tblRate
          INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId  AND tblVendorRate.TrunkID = p_trunkID   
          INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId  AND tblVendorTrunk.TrunkID = p_trunkID   
           WHERE    tblRate.CompanyID = p_companyid  AND ( p_Codes  = '' OR Code LIKE REPLACE(p_Codes,'*', '%') );
        END IF; 
		
		IF p_criteria = 2 and p_isCountry = 0 
		THEN
   		insert into tmp_codes_
		   SELECT  distinct tblRate.Code 
            FROM    tblRate
          INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId  AND tblVendorRate.TrunkID = p_trunkID   
          INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId  AND tblVendorTrunk.TrunkID = p_trunkID   
           WHERE    tblRate.CompanyID = p_companyid  AND ( p_CountryIDs  = 0 OR FIND_IN_SET(tblRate.CountryID,p_CountryIDs) != 0 );
        END IF; 
		
		IF p_criteria = 3 and p_isCountry = 0 
		THEN
   		insert into tmp_codes_
		   SELECT  distinct tblRate.Code 
            FROM    tblRate
          INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId  AND tblVendorRate.TrunkID = p_trunkID   
          INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId  AND tblVendorTrunk.TrunkID = p_trunkID   
           WHERE    tblRate.CompanyID = p_companyid;
        END IF; 
	
	 
	IF p_isCountry = 0 AND p_action = 1 
   THEN 

		INSERT INTO tblVendorBlocking (AccountId,RateId,TrunkID,BlockedBy)
			SELECT DISTINCT tblVendorRate.AccountID,tblRate.RateID,tblVendorRate.TrunkID,p_Username
			FROM tblVendorRate
			INNER JOIN tblRate ON tblRate.RateID = tblVendorRate.RateId 
				AND tblRate.CompanyID = p_companyid
			Inner join tmp_codes_ c on c.Code = tblRate.Code
			LEFT JOIN tblVendorBlocking ON tblVendorBlocking.AccountId = tblVendorRate.AccountId 
				AND tblVendorBlocking.RateId = tblRate.RateID 
				AND tblVendorBlocking.TrunkID = p_trunkID
			WHERE tblVendorBlocking.VendorBlockingId IS NULL
			 
			 AND tblVendorRate.TrunkID = p_trunkID 
			 AND FIND_IN_SET (tblVendorRate.AccountID,p_AccountId) != 0 ;
	END IF; 

	IF p_isCountry = 0 AND p_action = 0 
	THEN
		DELETE  tblVendorBlocking
	  	FROM      tblVendorBlocking
	  	INNER JOIN tblVendorRate ON tblVendorRate.RateID = tblVendorBlocking.RateId
			AND tblVendorRate.TrunkID =  p_trunkID
	  	INNER JOIN tblRate ON  tblRate.RateID = tblVendorRate.RateId AND tblRate.CompanyID = p_companyid
	  	Inner join tmp_codes_ c on c.Code = tblRate.Code
		WHERE FIND_IN_SET (tblVendorRate.AccountID,p_AccountId) != 0 ;
	END IF;
	
	
	IF p_isCountry = 1 AND p_action = 1 
	THEN
		INSERT INTO tblVendorBlocking (AccountId,CountryId,TrunkID,BlockedBy)
		SELECT DISTINCT tblVendorRate.AccountID,tblRate.CountryID,p_trunkID,p_Username
		FROM tblVendorRate  
		INNER JOIN tblRate ON tblVendorRate.RateId = tblRate.RateID 
			AND tblRate.CompanyID = p_companyid
			AND  FIND_IN_SET(tblRate.CountryID,p_CountryIDs) != 0
		LEFT JOIN tblVendorBlocking ON tblVendorBlocking.AccountId = tblVendorRate.AccountID 
			AND tblRate.CountryID = tblVendorBlocking.CountryId
			AND tblVendorBlocking.TrunkID = p_trunkID
		WHERE tblVendorBlocking.VendorBlockingId IS NULL AND FIND_IN_SET (tblVendorRate.AccountID,p_AccountId) != 0
			AND tblVendorRate.TrunkID = p_trunkID;
		 
	END IF;
	
	
	IF p_isCountry = 1 AND p_action = 0 
	THEN
		DELETE FROM tblVendorBlocking
		WHERE tblVendorBlocking.TrunkID = p_trunkID AND FIND_IN_SET (tblVendorBlocking.AccountId,p_AccountId) !=0 AND FIND_IN_SET(tblVendorBlocking.CountryID,p_CountryIDs) != 0;
	END IF;
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_checkAccountIP` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_checkAccountIP`(IN `p_CompanyID` INT, IN `p_AccountIP` VARCHAR(50))
BEGIN
   
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    SELECT AccountID
    FROM tblAccountAuthenticate 
    WHERE CompanyID = p_CompanyID AND  
	 ( FIND_IN_SET(p_AccountIP,CustomerAuthValue)!= 0 OR FIND_IN_SET(p_AccountIP,VendorAuthValue)!= 0 );  
	 
	 SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_checkCustomerCli` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_checkCustomerCli`(
	IN `p_CompanyID` INT,
	IN `p_CustomerCLI` varchar(50)
)
BEGIN
     
	 SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SELECT AccountID
    FROM tblAccountAuthenticate 
    WHERE CompanyID = p_CompanyID AND  
	 ( FIND_IN_SET(p_CustomerCLI,CustomerAuthValue)!= 0 OR FIND_IN_SET(p_CustomerCLI,VendorAuthValue)!= 0 );  
    
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_checkDialstringAndDupliacteCode` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_checkDialstringAndDupliacteCode`(IN `p_companyId` INT, IN `p_processId` VARCHAR(200) , IN `p_dialStringId` INT, IN `p_effectiveImmediately` INT, IN `p_dialcodeSeparator` VARCHAR(50))
BEGIN
	
    DECLARE totaldialstringcode INT(11) DEFAULT 0;	 
    DECLARE     v_CodeDeckId_ INT ;
  	 DECLARE totalduplicatecode INT(11);	 
  	 DECLARE errormessage longtext;
	 DECLARE errorheader longtext;


DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateDialString_ ;			
	 CREATE TEMPORARY TABLE `tmp_VendorRateDialString_` (						
						`CodeDeckId` int ,
						`Code` varchar(50) ,
						`Description` varchar(200) ,
						`Rate` decimal(18, 6) ,
						`EffectiveDate` Datetime ,
						`Change` varchar(100) ,
						`ProcessId` varchar(200) ,
						`Preference` varchar(100) ,
						`ConnectionFee` decimal(18, 6),
						`Interval1` int,
						`IntervalN` int,
						`Forbidden` varchar(100) 
					);
		
		
		
		CALL prc_SplitVendorRate(p_processId,p_dialcodeSeparator);					
		
		
		DROP TEMPORARY TABLE IF EXISTS tmp_split_VendorRate_2;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_split_VendorRate_2 as (SELECT * FROM tmp_split_VendorRate_);
                                             
	     DELETE n1 FROM tmp_split_VendorRate_ n1, tmp_split_VendorRate_2 n2 
     WHERE n1.EffectiveDate < n2.EffectiveDate 
	 	AND n1.CodeDeckId = n2.CodeDeckId
		AND  n1.Code = n2.Code
		AND  n1.ProcessId = n2.ProcessId
 		AND  n1.ProcessId = p_processId AND n2.ProcessId = p_processId;

		  INSERT INTO tmp_TempVendorRate_
	        SELECT DISTINCT `CodeDeckId`,
			  						`Code`,
									`Description`,
									`Rate`,
									`EffectiveDate`,
									`Change`,
									`ProcessId`,
									`Preference`,
									`ConnectionFee`,
									`Interval1`,
									`IntervalN`,
									`Forbidden`
						 FROM tmp_split_VendorRate_
						 	 WHERE tmp_split_VendorRate_.ProcessId = p_processId;
			
		
	 	     SELECT CodeDeckId INTO v_CodeDeckId_ 
					FROM tmp_TempVendorRate_
						 WHERE ProcessId = p_processId  LIMIT 1;

            UPDATE tmp_TempVendorRate_ as tblTempVendorRate
            LEFT JOIN tblRate
                ON tblRate.Code = tblTempVendorRate.Code
                AND tblRate.CompanyID = p_companyId
                AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
                AND tblRate.CodeDeckId =  v_CodeDeckId_
            SET  
                tblTempVendorRate.Interval1 = CASE WHEN tblTempVendorRate.Interval1 is not null  and tblTempVendorRate.Interval1 > 0
                                            THEN    
                                                tblTempVendorRate.Interval1
                                            ELSE
                                            CASE WHEN tblRate.Interval1 is not null  
                                            THEN    
                                                tblRate.Interval1
                                            ELSE CASE WHEN tblTempVendorRate.Interval1 is null and (tblTempVendorRate.Description LIKE '%gambia%' OR tblTempVendorRate.Description LIKE '%mexico%')
                                                 THEN 
                                                    60
                                            ELSE CASE WHEN tblTempVendorRate.Description LIKE '%USA%' 
                                                 THEN 
                                                    6
                                                 ELSE 
                                                    1
                                                END
                                            END

                                            END
                                            END,
                tblTempVendorRate.IntervalN = CASE WHEN tblTempVendorRate.IntervalN is not null  and tblTempVendorRate.IntervalN > 0
                                            THEN    
                                                tblTempVendorRate.IntervalN
                                            ELSE
                                                CASE WHEN tblRate.IntervalN is not null 
                                          THEN
                                            tblRate.IntervalN
                                          ElSE
                                            CASE
                                                WHEN tblTempVendorRate.Description LIKE '%mexico%' THEN 60
                                            ELSE CASE
                                                WHEN tblTempVendorRate.Description LIKE '%USA%' THEN 6
                                                
                                            ELSE 
                                            1
                                            END
                                            END
                                          END
                                          END;

 			
			IF  p_effectiveImmediately = 1
            THEN
            
            	
            
                UPDATE tmp_TempVendorRate_
           	     SET EffectiveDate = DATE_FORMAT (NOW(), '%Y-%m-%d')
           		     WHERE EffectiveDate < DATE_FORMAT (NOW(), '%Y-%m-%d');

            END IF;
			
			
			SELECT count(*) INTO totalduplicatecode FROM(
				SELECT count(code) as c,code FROM tmp_TempVendorRate_  GROUP BY Code,EffectiveDate HAVING c>1) AS tbl;
				
			
			IF  totalduplicatecode > 0
			THEN	
			
			
				SELECT GROUP_CONCAT(code) into errormessage FROM(
					SELECT DISTINCT code, 1 as a FROM(
						SELECT   count(code) as c,code FROM tmp_TempVendorRate_  GROUP BY Code,EffectiveDate HAVING c>1) AS tbl) as tbl2 GROUP by a;				
				
				INSERT INTO tmp_JobLog_ (Message)
				  SELECT DISTINCT 
				  CONCAT(code , ' DUPLICATE CODE')
				  	FROM(
						SELECT   count(code) as c,code FROM tmp_TempVendorRate_  GROUP BY Code,EffectiveDate HAVING c>1) AS tbl;				
					
			END IF;
							
   IF	totalduplicatecode = 0
   THEN
						
	 
    IF p_dialstringid >0
    THEN
    		
    		DROP TEMPORARY TABLE IF EXISTS tmp_DialString_;
    		CREATE TEMPORARY TABLE tmp_DialString_ (
				`DialStringID` INT,
				`DialString` VARCHAR(250),
				`ChargeCode` VARCHAR(250),
				`Description` VARCHAR(250),
				`Forbidden` VARCHAR(50),
				INDEX tmp_DialStringID (`DialStringID`),			
	         INDEX tmp_DialStringID_ChargeCode (`DialStringID`,`ChargeCode`)
         );

         INSERT INTO tmp_DialString_ 
			SELECT DISTINCT
				`DialStringID`,
				`DialString`,
				`ChargeCode`,
				`Description`,
				`Forbidden`
			FROM tblDialStringCode
				WHERE DialStringID = p_dialstringid;
				
         
         SELECT  COUNT(*) as count INTO totaldialstringcode
			FROM tmp_TempVendorRate_ vr
				LEFT JOIN tmp_DialString_ ds
					ON vr.Code = ds.ChargeCode 
				WHERE vr.ProcessId = p_processId 
					AND ds.DialStringID IS NULL
					AND vr.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');
		   
         IF totaldialstringcode > 0
         THEN
         
				INSERT INTO tmp_JobLog_ (Message)
				  SELECT DISTINCT CONCAT(Code , ' No PREFIX FOUND')
				  	FROM tmp_TempVendorRate_ vr
						LEFT JOIN tmp_DialString_ ds
							ON vr.Code = ds.ChargeCode
						WHERE vr.ProcessId = p_processId
							AND ds.DialStringID IS NULL				
							AND vr.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');
         
         END IF;

         IF totaldialstringcode = 0
         THEN
				 
				 	INSERT INTO tmp_VendorRateDialString_ 	
					 SELECT DISTINCT
							`CodeDeckId`,
							`DialString`,
							CASE WHEN ds.Description IS NULL OR ds.Description = ''
								THEN    
									tblTempVendorRate.Description									
								ELSE
									ds.Description
							END
								AS Description,
							`Rate`,
							`EffectiveDate`,
							`Change`,
							`ProcessId`,
							`Preference`,
							`ConnectionFee`,
							`Interval1`,
							`IntervalN`,
							tblTempVendorRate.Forbidden as Forbidden 
					   FROM tmp_TempVendorRate_ as tblTempVendorRate
							INNER JOIN tmp_DialString_ ds
							  	ON tblTempVendorRate.Code = ds.ChargeCode
						 WHERE tblTempVendorRate.ProcessId = p_processId
							AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');							
											
					
					DELETE  FROM tmp_TempVendorRate_ WHERE  ProcessId = p_processId; 
					
					INSERT INTO tmp_TempVendorRate_(
							CodeDeckId,
							Code,
							Description,
							Rate,
							EffectiveDate,
							`Change`,
							ProcessId,
							Preference,
							ConnectionFee,
							Interval1,
							IntervalN,
							Forbidden
						)
					SELECT DISTINCT 
						`CodeDeckId`,
						`Code`,
						`Description`,
						`Rate`,
						`EffectiveDate`,
						`Change`,
						`ProcessId`,
						`Preference`,
						`ConnectionFee`,
						`Interval1`,
						`IntervalN`,
						`Forbidden` 
					 FROM tmp_VendorRateDialString_;
					   
				  	UPDATE tmp_TempVendorRate_ as tblTempVendorRate
					JOIN tmp_DialString_ ds
						ON tblTempVendorRate.Code = ds.DialString
							AND tblTempVendorRate.ProcessId = p_processId
							AND ds.Forbidden = 1
					SET tblTempVendorRate.Forbidden = 'B';
					
					UPDATE tmp_TempVendorRate_ as  tblTempVendorRate
					JOIN tmp_DialString_ ds
						ON tblTempVendorRate.Code = ds.DialString
							AND tblTempVendorRate.ProcessId = p_processId
							AND ds.Forbidden = 0
					SET tblTempVendorRate.Forbidden = 'UB';
					
			END IF;	  
        
    END IF;	
   
END IF; 
 	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_CronJobAllPending` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_CronJobAllPending`(IN `p_CompanyID` INT)
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
    SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'CDR'
		AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
	ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'CDR'
		AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;


   
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID,
	   TBL1.JobLoggedUserID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'BI'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'BI'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;



	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'CD'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Porta"%'	
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'CD'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Porta"%'	
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;


   
	SELECT
		tblCronJobCommand.Command,
		tblCronJob.CronJobID
	FROM tblCronJob
	INNER JOIN tblCronJobCommand
		ON tblCronJobCommand.CronJobCommandID = tblCronJob.CronJobCommandID
	WHERE tblCronJob.CompanyID = p_CompanyID
	AND tblCronJob.Status = 1
	AND tblCronJob.Active = 0;


	
	

	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'BIS'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'BIS'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;


	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'VD'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Porta"%'	
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'VD'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Porta"%'	
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;


	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'RCC'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'RCC'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;

	
	 

	


	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'INU'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'INU'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;
	
	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'CD'
			AND js.Code = 'p'
			AND j.CompanyID = p_CompanyID
			AND j.Options like '%"Format":"Rate Sheet"%'
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'CD'
			AND js.Code = 'I'
			AND j.CompanyID = p_CompanyID
			AND j.Options like '%"Format":"Rate Sheet"%'
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;

	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'BIR'
			AND js.Code = 'p'
			AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'BIR'
			AND js.Code = 'I'
			AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;

	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'BLE'
			AND js.Code = 'p'
			AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'BLE'
			AND js.Code = 'I'
			AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;

	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'BAE'
			AND js.Code = 'p'
			AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'BAE'
			AND js.Code = 'I'
			AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;


	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'VU'
			AND js.Code = 'p'
			AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'VU'
			AND js.Code = 'I'
			AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;

	 
    SELECT
    	  "CodeDeckUpload",
        TBL1.JobID,
        TBL1.Options,
        TBL1.AccountID
    FROM
    (
        SELECT
            j.Options,
            j.AccountID,
            j.JobID,
            j.JobLoggedUserID,
            @row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			   @prev_JobLoggedUserID  := j.JobLoggedUserID,
 			   @prev_created_at  := created_at
        FROM tblJob j
        INNER JOIN tblJobType jt
            ON j.JobTypeID = jt.JobTypeID
        INNER JOIN tblJobStatus js
            ON j.JobStatusID = js.JobStatusID
         ,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
        WHERE jt.Code = 'CDU'
            AND js.Code = 'p'
            AND j.CompanyID = p_CompanyID
         ORDER BY j.JobLoggedUserID,j.created_at ASC
    ) TBL1
    LEFT JOIN
    (
        SELECT
            JobLoggedUserID
        FROM tblJob j
        INNER JOIN tblJobType jt
            ON j.JobTypeID = jt.JobTypeID
        INNER JOIN tblJobStatus js
            ON j.JobStatusID = js.JobStatusID
        WHERE jt.Code = 'CDU'
            AND js.Code = 'I'
            AND j.CompanyID = p_CompanyID
    ) TBL2
        ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
    WHERE TBL1.rowno = 1
    AND TBL2.JobLoggedUserID IS NULL;

	   
    SELECT
        TBL1.JobID,
        TBL1.Options,
        TBL1.AccountID
    FROM
    (
        SELECT
            j.Options,
            j.AccountID,
            j.JobID,
            j.JobLoggedUserID,
            @row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
				@prev_JobLoggedUserID  := j.JobLoggedUserID,
				@prev_created_at  := created_at
        FROM tblJob j
        INNER JOIN tblJobType jt
            ON j.JobTypeID = jt.JobTypeID
        INNER JOIN tblJobStatus js
            ON j.JobStatusID = js.JobStatusID
         ,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
        WHERE jt.Code = 'IR'
            AND js.Code = 'p'
            AND j.CompanyID = p_CompanyID
         ORDER BY j.JobLoggedUserID,j.created_at ASC
    ) TBL1
    LEFT JOIN
    (
        SELECT
            JobLoggedUserID
        FROM tblJob j
        INNER JOIN tblJobType jt
            ON j.JobTypeID = jt.JobTypeID
        INNER JOIN tblJobStatus js
            ON j.JobStatusID = js.JobStatusID
        WHERE jt.Code = 'IR'
            AND js.Code = 'I'
            AND j.CompanyID = p_CompanyID
    ) TBL2
        ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
    WHERE TBL1.rowno = 1
    AND TBL2.JobLoggedUserID IS NULL;



	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'CD'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Sippy"%'	
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'CD'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Sippy"%'	
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;


	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'VD'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Sippy"%'
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'VD'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Sippy"%'	
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;



	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'CD'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Vos 3.2"%'	
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'CD'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Vos 3.2"%'	
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;


	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'VD'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Vos 3.2"%'	
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'VD'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
		AND j.Options like '%"Format":"Vos 3.2"%'	
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;


	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'GRT'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'GRT'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;
	
	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'RTU'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'RTU'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;
	
	
    SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'VDR'
		AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
	ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'VDR'
		AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;
	
	
	
		
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'MGA'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'MGA'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;
	
	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'DSU'
        AND js.Code = 'P'
		AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'DSU'
        AND js.Code = 'I'
		AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;
	
	
	SELECT
		TBL1.JobID,
		TBL1.Options,
		TBL1.AccountID
	FROM
	(
		SELECT
			j.Options,
			j.AccountID,
			j.JobID,
			j.JobLoggedUserID,
			@row_num := IF(@prev_JobLoggedUserID=j.JobLoggedUserID and @prev_created_at <= j.created_at ,@row_num+1,1) AS rowno,
			@prev_JobLoggedUserID  := j.JobLoggedUserID,
			@prev_created_at  := created_at
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		,(SELECT @row_num := 1) x,(SELECT @prev_JobLoggedUserID := '') y,(SELECT @prev_created_at := '') z
		WHERE jt.Code = 'QIP'
			AND js.Code = 'p'
			AND j.CompanyID = p_CompanyID
		ORDER BY j.JobLoggedUserID,j.created_at ASC
	) TBL1
	LEFT JOIN
	(
		SELECT
			JobLoggedUserID
		FROM tblJob j
		INNER JOIN tblJobType jt
			ON j.JobTypeID = jt.JobTypeID
		INNER JOIN tblJobStatus js
			ON j.JobStatusID = js.JobStatusID
		WHERE jt.Code = 'QIP'
			AND js.Code = 'I'
			AND j.CompanyID = p_CompanyID
	) TBL2
		ON TBL1.JobLoggedUserID = TBL2.JobLoggedUserID
	WHERE TBL1.rowno = 1
	AND TBL2.JobLoggedUserID IS NULL;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_CronJobGeneratePortaSheet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_CronJobGeneratePortaSheet`(IN `p_CustomerID` INT , IN `p_trunks` VARCHAR(200) , IN `p_Effective` VARCHAR(50))
BEGIN
    
    DECLARE v_codedeckid_ INT;
    DECLARE v_ratetableid_ INT;
    DECLARE v_RateTableAssignDate_ DATETIME;
    DECLARE v_NewA2ZAssign_ INT;
    DECLARE v_companyid_ INT;
    DECLARE v_TrunkID_ INT;
    DECLARE v_pointer_ INT ;
    DECLARE v_rowCount_ INT ;
   
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
   
    
    DROP TEMPORARY TABLE IF EXISTS tmp_customerrateall_;
    CREATE TEMPORARY TABLE tmp_customerrateall_ (
        RateID INT,
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18, 6),
        RoutinePlanName VARCHAR(50),
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        CustomerRateId INT,
        TrunkID INT,
        RateTableRateId INT,
        IncludePrefix TINYINT,
        Prefix VARCHAR(50),
        RatePrefix VARCHAR(50),
        AreaPrefix VARCHAR(50)
    );
        
    DROP TEMPORARY TABLE IF EXISTS tmp_trunks_;
    CREATE TEMPORARY TABLE tmp_trunks_  (
        TrunkID INT,
        RowNo INT
    );
            
            
    SELECT 
        CompanyId INTO v_companyid_
    FROM tblAccount
    WHERE AccountID = p_CustomerID; 
        
        
        
    INSERT INTO tmp_trunks_
    SELECT TrunkID,
        @row_num := @row_num+1 AS RowID
    FROM tblCustomerTrunk,(SELECT @row_num := 0) x
    WHERE  FIND_IN_SET(tblCustomerTrunk.TrunkID,p_Trunks)!= 0 
        AND tblCustomerTrunk.AccountID = p_CustomerID;
        
    SET v_pointer_ = 1;
    SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_trunks_);
        
        
    WHILE v_pointer_ <= v_rowCount_
    DO
         
        SET v_TrunkID_ = (SELECT TrunkID FROM tmp_trunks_ t WHERE t.RowNo = v_pointer_);
     
        CALL prc_GetCustomerRate(v_companyid_,p_CustomerID,v_TrunkID_,null,null,null,p_Effective,1,0,0,0,'','',-1);
        
        INSERT INTO tmp_customerrateall_
        SELECT * FROM tmp_customerrate_;
        
        SET v_pointer_ = v_pointer_ + 1;
    END WHILE; 
            
	 SELECT distinct 
       Code as `Destination` ,
       Description  as `Description`,
       Interval1 as `First Interval`,
       IntervalN as `Next Interval`,
       Abs(Rate) as `First Price` ,
       Abs(Rate) as `Next Price`,
       DATE_FORMAT(EffectiveDate ,'%d/%m/%Y') as  `Effective From`,
       CASE WHEN Rate < 0 THEN 'Y' ELSE '' END  `Payback Rate` ,
		 CASE WHEN ConnectionFee > 0 THEN
			CONCAT('SEQ=', ConnectionFee,'&int1x1@price1&intNxN@priceN')
		 ELSE
			''
		 END as `Formula`
     FROM tmp_customerrateall_;
	 
		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_CronJobGeneratePortaVendorSheet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_CronJobGeneratePortaVendorSheet`(IN `p_AccountID` INT , IN `p_trunks` VARCHAR(200), IN `p_Effective` VARCHAR(50))
BEGIN
		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
		
		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
    CREATE TEMPORARY TABLE tmp_VendorRate_ (
        TrunkId INT,
   	  RateId INT,
        Rate DECIMAL(18,6),
        EffectiveDate DATE,
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18,6),
        INDEX tmp_RateTable_RateId (`RateId`)  
    );
        INSERT INTO tmp_VendorRate_
        SELECT   `TrunkID`, `RateId`, `Rate`, `EffectiveDate`, `Interval1`, `IntervalN`, `ConnectionFee`
		  FROM tblVendorRate WHERE tblVendorRate.AccountId =  p_AccountID 
								AND FIND_IN_SET(tblVendorRate.TrunkId,p_trunks) != 0 
                        AND 
								(
					  				(p_Effective = 'Now' AND EffectiveDate <= NOW()) 
								  	OR 
								  	(p_Effective = 'Future' AND EffectiveDate > NOW())
								  	OR 
								  	(p_Effective = 'All')
								);
								
		 DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate4_;		
       CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate4_ as (select * from tmp_VendorRate_);	        
      DELETE n1 FROM tmp_VendorRate_ n1, tmp_VendorRate4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate 
 	   AND n1.TrunkID = n2.TrunkID
	   AND  n1.RateId = n2.RateId
		AND n1.EffectiveDate <= NOW()
		AND n2.EffectiveDate <= NOW();
                        
         
       
       SELECT Distinct  tblRate.Code as `Destination`,
               tblRate.Description as `Description` ,
               CASE WHEN tblVendorRate.Interval1 IS NOT NULL
                   THEN tblVendorRate.Interval1
                   ElSE tblRate.Interval1
               END AS `First Interval`,
               CASE WHEN tblVendorRate.IntervalN IS NOT NULL
                   THEN tblVendorRate.IntervalN
                   ElSE tblRate.IntervalN
               END  AS `Next Interval`,
               Abs(tblVendorRate.Rate) as `First Price`,
               Abs(tblVendorRate.Rate) as `Next Price`,
               tblVendorRate.EffectiveDate as `Effective From` ,
               IFNULL(Preference,5) as `Preference`,
               CASE
                   WHEN (blockCode.VendorBlockingId IS NOT NULL AND
                   	FIND_IN_SET(tblVendorRate.TrunkId,blockCode.TrunkId) != 0
                       )OR
                       (blockCountry.VendorBlockingId IS NOT NULL AND
                       FIND_IN_SET(tblVendorRate.TrunkId,blockCountry.TrunkId) != 0
                       ) THEN 'Y'
                   ELSE 'N'
               END AS `Forbidden`,
               CASE WHEN tblVendorRate.Rate < 0 THEN 'Y' ELSE '' END AS 'Payback Rate' ,
               CASE WHEN ConnectionFee > 0 THEN
						CONCAT('SEQ=',ConnectionFee,'&int1x1@price1&intNxN@priceN')
					ELSE
						''
					END as `Formula`,
					'N' AS `Discontinued`
       FROM    tmp_VendorRate_ as tblVendorRate 
               JOIN tblRate on tblVendorRate.RateId =tblRate.RateID
               LEFT JOIN tblVendorBlocking as blockCode
                   ON tblVendorRate.RateID = blockCode.RateId
                   AND blockCode.AccountId = p_AccountID
                   AND tblVendorRate.TrunkID = blockCode.TrunkID
               LEFT JOIN tblVendorBlocking AS blockCountry
                   ON tblRate.CountryID = blockCountry.CountryId
                   AND blockCountry.AccountId = p_AccountID
                   AND tblVendorRate.TrunkID = blockCountry.TrunkID
					LEFT JOIN tblVendorPreference 
						ON tblVendorPreference.AccountId = p_AccountID
						AND tblVendorPreference.TrunkID = tblVendorRate.TrunkID
						AND tblVendorPreference.RateId = tblVendorRate.RateId
       UNION ALL
		                  
		    SELECT 
			 		vrd.Code AS `Destination`,
			 		vrd.Description AS `Description` ,
			 		vrd.Interval1 AS `First Interval`,
			 		vrd.IntervalN AS `Next Interval`,
			 		Abs(vrd.Rate) AS `First Price`,
			 		Abs(vrd.Rate) AS `Next Price`,
			 		vrd.EffectiveDate AS `Effective From`,
			 		'' AS `Preference`,
			 		'' AS `Forbidden`,
			 		CASE WHEN vrd.Rate < 0 THEN 'Y' ELSE '' END AS 'Payback Rate' ,
			 		CASE WHEN vrd.ConnectionFee > 0 THEN
						CONCAT('SEQ=',vrd.ConnectionFee,'&int1x1@price1&intNxN@priceN')
					ELSE
						''
					END as `Formula`,
			 		'Y' AS `Discontinued`
			  FROM tblVendorRateDiscontinued vrd
					LEFT JOIN tblVendorRate vr
						ON vrd.AccountId = vr.AccountId 
							AND vrd.TrunkID = vr.TrunkID				
							AND vrd.RateId = vr.RateId
					WHERE FIND_IN_SET(vrd.TrunkID,p_trunks) != 0
						AND vrd.AccountId = p_AccountID
						AND vr.VendorRateID IS NULL ;           
						
						
      SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_CustomerBulkRateClear` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_CustomerBulkRateClear`(IN `p_AccountIdList` LONGTEXT , IN `p_TrunkId` INT , IN `p_CodeDeckId` int, IN `p_code` VARCHAR(50), IN `p_description` VARCHAR(200) , IN `p_CountryId` INT , IN `p_CompanyId` INT)
BEGIN

   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; 
	delete tblCustomerRate
	from tblCustomerRate
   INNER JOIN ( 
		SELECT c.CustomerRateID
      FROM   tblCustomerRate c
      INNER JOIN tblCustomerTrunk
          ON tblCustomerTrunk.TrunkID = c.TrunkID
          AND tblCustomerTrunk.AccountID = c.CustomerID
          AND tblCustomerTrunk.Status = 1
      INNER JOIN tblRate r
          ON c.RateID = r.RateID and r.CodeDeckId=p_CodeDeckId
		WHERE c.TrunkID = p_TrunkId
			   AND FIND_IN_SET(c.CustomerID,p_AccountIdList) != 0 
				AND ( ( p_code IS NULL ) OR ( p_code IS NOT NULL AND r.Code LIKE REPLACE(p_code,'*', '%')))
				AND ( ( p_description IS NULL ) OR ( p_description IS NOT NULL AND r.Description LIKE REPLACE(p_description,'*', '%')))
				AND ( ( p_CountryId IS NULL )  OR ( p_CountryId IS NOT NULL AND r.CountryID = p_CountryId ) ) 
		) cr ON cr.CustomerRateID = tblCustomerRate.CustomerRateID;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_CustomerBulkRateUpdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_CustomerBulkRateUpdate`(IN `p_AccountIdList` LONGTEXT , IN `p_TrunkId` INT , IN `p_CodeDeckId` int, IN `p_code` VARCHAR(50) , IN `p_description` VARCHAR(200) , IN `p_CountryId` INT , IN `p_CompanyId` INT , IN `p_Rate` DECIMAL(18, 6) , IN `p_ConnectionFee` DECIMAL(18, 6) , IN `p_EffectiveDate` DATETIME , IN `p_Interval1` INT, IN `p_IntervalN` INT, IN `p_RoutinePlan` INT, IN `p_ModifiedBy` VARCHAR(50))
BEGIN

 	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
   UPDATE  tblCustomerRate
   INNER JOIN ( 
		SELECT c.CustomerRateID, 
			c.EffectiveDate,
			CASE WHEN ctr.TrunkID IS NOT NULL 
				THEN p_RoutinePlan 
			ELSE NULL
				END AS RoutinePlan
      FROM   tblCustomerRate c
    	INNER JOIN tblCustomerTrunk 
			ON tblCustomerTrunk.TrunkID = c.TrunkID
         AND tblCustomerTrunk.AccountID = c.CustomerID
         AND tblCustomerTrunk.Status = 1
      INNER JOIN tblRate r 
			ON c.RateID = r.RateID and r.CodeDeckId=p_CodeDeckId
		LEFT JOIN tblCustomerTrunk ctr
			ON ctr.TrunkID = c.TrunkID
			AND ctr.AccountID = c.CustomerID
			AND ctr.RoutinePlanStatus = 1
      WHERE  ( ( p_code IS NULL ) OR ( p_code IS NOT NULL AND r.Code LIKE REPLACE(p_code,'*', '%')))
				AND ( ( p_description IS NULL ) OR ( p_description IS NOT NULL AND r.Description LIKE REPLACE(p_description,'*', '%')))
				AND ( ( p_CountryId IS NULL )  OR ( p_CountryId IS NOT NULL AND r.CountryID = p_CountryId ) ) 
				AND c.TrunkID = p_TrunkId
	         AND FIND_IN_SET(c.CustomerID,p_AccountIdList) != 0
			) cr ON cr.CustomerRateID = tblCustomerRate.CustomerRateID and cr.EffectiveDate = p_EffectiveDate
		 SET tblCustomerRate.PreviousRate = Rate ,
           tblCustomerRate.Rate = p_Rate ,
			  tblCustomerRate.ConnectionFee = p_ConnectionFee ,
           tblCustomerRate.EffectiveDate = p_EffectiveDate ,
           tblCustomerRate.Interval1 = p_Interval1, 
			  tblCustomerRate.IntervalN = p_IntervalN,
			  tblCustomerRate.RoutinePlan = cr.RoutinePlan,
           tblCustomerRate.LastModifiedBy = p_ModifiedBy ,
           tblCustomerRate.LastModifiedDate = NOW();



        INSERT  INTO tblCustomerRate
                ( RateID ,
                  CustomerID ,
                  TrunkID ,
                  Rate ,
				  		ConnectionFee,
                  EffectiveDate ,
                  Interval1, 
				  		IntervalN ,
				  		RoutinePlan,
                  CreatedDate ,
                  LastModifiedBy ,
                  LastModifiedDate
                )
                SELECT  r.RateID ,
                        r.AccountId ,
                        p_TrunkId ,
                        p_Rate ,
								p_ConnectionFee,
                        p_EffectiveDate ,
                        p_Interval1, 
					    		p_IntervalN,
								RoutinePlan,
                        NOW() ,
                        p_ModifiedBy ,
                        NOW()
                FROM    ( SELECT    RateID,Code,AccountId,CompanyID,CodeDeckId,Description,CountryID,RoutinePlan
                          FROM      tblRate ,
                                    (  SELECT   a.AccountId,
													CASE WHEN ctr.TrunkID IS NOT NULL 
														THEN p_RoutinePlan 
														ELSE NULL
													END AS RoutinePlan
                                       FROM tblAccount a 
													INNER JOIN tblCustomerTrunk 
														ON TrunkID = p_TrunkId
                                       	AND a.AccountID    = tblCustomerTrunk.AccountID
                                          AND tblCustomerTrunk.Status = 1
													LEFT JOIN tblCustomerTrunk ctr
														ON ctr.TrunkID = p_TrunkId
														AND ctr.AccountID = a.AccountID
														AND ctr.RoutinePlanStatus = 1
												WHERE FIND_IN_SET(a.AccountID,p_AccountIdList) != 0
                                    ) a
                        ) r
                        LEFT OUTER JOIN ( SELECT DISTINCT
                                                    RateID ,
                                                    c.CustomerID as AccountId ,
                                                    c.TrunkID,
                                                    c.EffectiveDate
                                          FROM      tblCustomerRate c
														INNER JOIN tblCustomerTrunk 
															ON tblCustomerTrunk.TrunkID = c.TrunkID
                                          	AND tblCustomerTrunk.AccountID = c.CustomerID
                                             AND tblCustomerTrunk.Status = 1
                                          WHERE FIND_IN_SET(c.CustomerID,p_AccountIdList) != 0 AND c.TrunkID = p_TrunkId
                                        ) cr ON r.RateID = cr.RateID
                                                AND r.AccountId = cr.AccountId
                                                AND r.CompanyID = p_CompanyId    
                                                and cr.EffectiveDate = p_EffectiveDate
                WHERE   r.CompanyID = p_CompanyId
						AND r.CodeDeckId=p_CodeDeckId 
                  AND ( ( p_code IS NULL ) OR ( p_code IS NOT NULL AND r.Code LIKE REPLACE(p_code,'*', '%')))
						AND ( ( p_description IS NULL ) OR ( p_description IS NOT NULL AND r.Description LIKE REPLACE(p_description,'*', '%')))
						AND ( ( p_CountryId IS NULL )  OR ( p_CountryId IS NOT NULL AND r.CountryID = p_CountryId ) )
      				AND cr.RateID IS NULL; 
      				
     CALL prc_ArchiveOldCustomerRate(p_AccountIdList, p_TrunkId);

    	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_CustomerPanel_GetinboundRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_CustomerPanel_GetinboundRate`(IN `p_companyid` INT, IN `p_AccountID` INT, IN `p_ratetableid` INT, IN `p_trunkID` INT, IN `p_contryID` INT, IN `p_code` VARCHAR(50), IN `p_description` VARCHAR(50), IN `p_Effective` VARCHAR(50), IN `p_effectedRates` INT, IN `p_RoutinePlan` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT )
BEGIN
   DECLARE v_codedeckid_ INT;
   DECLARE v_ratetableid_ INT;
   DECLARE v_RateTableAssignDate_ DATETIME;
   DECLARE v_NewA2ZAssign_ INT;
   DECLARE v_OffSet_ int;
   DECLARE v_IncludePrefix_ INT;
   DECLARE v_Prefix_ VARCHAR(50);
   DECLARE v_RatePrefix_ VARCHAR(50);
   DECLARE v_AreaPrefix_ VARCHAR(50);
   
   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
   SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	SELECT CodeDeckId INTO v_codedeckid_ FROM tblRateTable where RateTableId=p_ratetableid and CompanyId=p_companyid;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate_;
    CREATE TEMPORARY TABLE tmp_RateTableRate_ (
    	  RateID INT,	
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18, 6),
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        INDEX tmp_RateTableRate_RateID (`RateID`)
    );
    
   INSERT INTO tmp_RateTableRate_
	select 
	      r.RateID,
			r.Code,
			r.Description,			
			ifnull(rtr.Interval1,1) as Interval1,
         ifnull(rtr.IntervalN,1) as IntervalN,
			rtr.ConnectionFee,
			IFNULL(rtr.Rate, 0) as Rate,
			IFNULL(rtr.EffectiveDate, NOW()) as EffectiveDate
		 from tblRate r LEFT JOIN tblRateTableRate rtr on r.RateID=rtr.RateID
		 AND r.CodeDeckId = v_codedeckid_ AND  
						 (
						 	( p_Effective = 'Now' AND rtr.EffectiveDate <= NOW() )
						 	OR
						 	( p_Effective = 'Future' AND rtr.EffectiveDate > NOW())
						 	OR p_Effective = 'All'
						 )
		 where rtr.RateTableId = p_ratetableid AND r.CompanyID=p_companyid
		  AND	(p_contryID IS NULL OR r.CountryID = p_contryID)
        AND (p_code IS NULL OR r.Code LIKE REPLACE(p_code, '*', '%'))
        AND (p_description IS NULL OR r.Description LIKE REPLACE(p_description, '*', '%'));
        
        IF p_Effective = 'Now'
		THEN
		   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_RateTableRate4_ as (select * from tmp_RateTableRate_);	        
         DELETE n1 FROM tmp_RateTableRate_ n1, tmp_RateTableRate4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate 
		   AND  n1.RateID = n2.RateID;
		END IF;
        
        IF p_isExport = 0
    THEN


         SELECT         
				RateID,
                Code,
                Description,
                Interval1,
                IntervalN,
                ConnectionFee,
                Rate,
                EffectiveDate
            FROM tmp_RateTableRate_ 
            ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeDESC') THEN Code
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeASC') THEN Code
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN Description
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN Description
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateDESC') THEN Rate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateASC') THEN Rate
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1DESC') THEN Interval1
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1ASC') THEN Interval1
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNDESC') THEN IntervalN
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNASC') THEN IntervalN
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeDESC') THEN ConnectionFee
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeASC') THEN ConnectionFee
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateDESC') THEN EffectiveDate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateASC') THEN EffectiveDate
                END ASC
            LIMIT p_RowspPage OFFSET v_OffSet_;

        SELECT
            COUNT(RateID) AS totalcount
        FROM tmp_RateTableRate_;

    END IF;
    
    IF p_isExport = 1
    THEN
			 
          select 
            RateID,
                Code,
                Description,
                Interval1,
                IntervalN,
                ConnectionFee,
                Rate,
                EffectiveDate
            FROM tmp_RateTableRate_;

    END IF;
    
 
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_CustomerRateClear` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_CustomerRateClear`(IN `p_CustomerRateId` int)
BEGIN
  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;  
  DELETE FROM tblCustomerRate
    WHERE CustomerRateId = p_CustomerRateId;
    
 SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_CustomerRateUpdateBySelectedRateId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_CustomerRateUpdateBySelectedRateId`(IN `p_CompanyId` INT, IN `p_AccountIdList` LONGTEXT , IN `p_RateIDList` LONGTEXT , IN `p_TrunkId` VARCHAR(100) , IN `p_Rate` DECIMAL(18, 6) , IN `p_ConnectionFee` DECIMAL(18, 6) , IN `p_EffectiveDate` DATETIME , IN `p_Interval1` INT, IN `p_IntervalN` INT, IN `p_RoutinePlan` INT, IN `p_ModifiedBy` VARCHAR(50))
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	UPDATE  tblCustomerRate
	INNER JOIN ( 
		SELECT c.CustomerRateID,c.EffectiveDate,
			CASE WHEN ctr.TrunkID IS NOT NULL 
				THEN p_RoutinePlan 
			ELSE 0
				END AS RoutinePlan
      FROM   tblCustomerRate c
			
         INNER JOIN tblCustomerTrunk ON tblCustomerTrunk.TrunkID = c.TrunkID
         	AND tblCustomerTrunk.AccountID = c.CustomerID
            AND tblCustomerTrunk.Status = 1
            AND c.EffectiveDate = p_EffectiveDate
			LEFT JOIN tblCustomerTrunk ctr
				ON ctr.TrunkID = c.TrunkID
				AND ctr.AccountID = c.CustomerID
				AND ctr.RoutinePlanStatus = 1
            ) cr ON cr.CustomerRateID = tblCustomerRate.CustomerRateID and cr.EffectiveDate = p_EffectiveDate
		SET     
			tblCustomerRate.PreviousRate = Rate ,
         tblCustomerRate.Rate = p_Rate ,
			tblCustomerRate.ConnectionFee = p_ConnectionFee,
         tblCustomerRate.EffectiveDate = p_EffectiveDate ,
         tblCustomerRate.Interval1 = p_Interval1, 
			tblCustomerRate.IntervalN = p_IntervalN,
         tblCustomerRate.LastModifiedBy = p_ModifiedBy ,
			tblCustomerRate.RoutinePlan = cr.RoutinePlan,
         tblCustomerRate.LastModifiedDate = NOW()
			WHERE tblCustomerRate.TrunkID = p_TrunkId
         AND FIND_IN_SET(tblCustomerRate.RateID,p_RateIDList) != 0
         AND FIND_IN_SET(tblCustomerRate.CustomerID,p_AccountIdList) != 0;
                           
                           
        INSERT  INTO tblCustomerRate
                ( RateID ,
                  CustomerID ,
                  TrunkID ,
                  Rate ,
					   ConnectionFee,
                  EffectiveDate ,
                  Interval1, 
				  		IntervalN ,
				  		RoutinePlan,
                  CreatedDate ,
                  LastModifiedBy ,
                  LastModifiedDate
                )
                SELECT  r.RateID,
                        r.AccountId ,
                        p_TrunkId ,
                        p_Rate ,
								p_ConnectionFee,
                        p_EffectiveDate ,
                        p_Interval1, 
					    		p_IntervalN,
								RoutinePlan,
                        NOW() ,
                        p_ModifiedBy ,
                        NOW()
                FROM    ( SELECT    tblRate.RateID ,
                                    a.AccountId,
                                    tblRate.CompanyID,
									RoutinePlan
                          FROM      tblRate ,
                                    ( SELECT  a.AccountId,
													CASE WHEN ctr.TrunkID IS NOT NULL 
														THEN p_RoutinePlan 
														ELSE 0
													END AS RoutinePlan
                                      FROM tblAccount a 
												  INNER JOIN tblCustomerTrunk ON TrunkID = p_TrunkId
                                      		AND a.AccountId = tblCustomerTrunk.AccountID
                                          AND tblCustomerTrunk.Status = 1
												LEFT JOIN tblCustomerTrunk ctr
													ON ctr.TrunkID = p_TrunkId
													AND ctr.AccountID = a.AccountID
													AND ctr.RoutinePlanStatus = 1
												WHERE  FIND_IN_SET(a.AccountID,p_AccountIdList) != 0 
                                    ) a
                          WHERE FIND_IN_SET(tblRate.RateID,p_RateIDList) != 0     
                        ) r
                        LEFT JOIN ( SELECT DISTINCT
                                                    c.RateID,
                                                    c.CustomerID as AccountId ,
                                                    c.TrunkID,
                                                    c.EffectiveDate
                                          FROM      tblCustomerRate c
                                                    INNER JOIN tblCustomerTrunk ON tblCustomerTrunk.TrunkID = c.TrunkID
                                                              AND tblCustomerTrunk.AccountID = c.CustomerID
                                                              AND tblCustomerTrunk.Status = 1
                                          WHERE FIND_IN_SET(c.CustomerID,p_AccountIdList) != 0 AND c.TrunkID = p_TrunkId
                                        ) cr ON r.RateID = cr.RateID
                                                AND r.AccountId = cr.AccountId
                                                AND r.CompanyID = p_CompanyId   
                                                and cr.EffectiveDate = p_EffectiveDate 
                WHERE  
                 r.CompanyID = p_CompanyId       
                 and cr.RateID is NULL;
  
       CALL prc_ArchiveOldCustomerRate(p_AccountIdList, p_TrunkId);
       SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;                            
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_deleteJobOrCronJobLogByRetention` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_deleteJobOrCronJobLogByRetention`(IN `p_CompanyID` INT, IN `p_DeleteDate` DATETIME, IN `p_ActionName` VARCHAR(200))
BEGIN
 	
 	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	
	IF p_ActionName = 'Cronjob'
	THEN
		
		DELETE
			 tblCronJobLog
		FROM tblCronJobLog
		INNER JOIN tblCronJob
		 	 ON tblCronJob.CronJobID = tblCronJobLog.CronJobID
		WHERE tblCronJob.CompanyID = p_CompanyID
			 AND tblCronJobLog.created_at < p_DeleteDate;
	
	END IF;	

	
	IF p_ActionName = 'Job'
	THEN
		
		DELETE 
			tblJobFile
		FROM tblJobFile
		INNER JOIN  tblJob
			ON tblJob.JobID = tblJobFile.JobID
	  	INNER JOIN tblJobType
			 ON tblJob.JobTypeID = tblJobType.JobTypeID
		WHERE tblJobType.`Code` NOT IN('CD','VD','VU') 
			AND tblJob.CompanyID = p_CompanyID 
			AND tblJob.created_at < p_DeleteDate;

		
			
		DELETE
			tblJob
		FROM tblJob
		INNER JOIN tblJobType
			ON tblJob.JobTypeID = tblJobType.JobTypeID
		WHERE tblJobType.`Code` NOT IN('CD','VD','VU')
			AND tblJob.CompanyID = p_CompanyID 
	  		AND tblJob.created_at < p_DeleteDate;
	
	END IF;	
	
	
	IF p_ActionName = 'CustomerRateSheet'
	THEN
		
			
		DELETE
			 tblJob
		FROM tblJob
		INNER JOIN tblJobType
			ON tblJob.JobTypeID = tblJobType.JobTypeID
		WHERE tblJobType.`Code` IN('CD')
			AND tblJob.CompanyID = p_CompanyID 
	  		AND tblJob.created_at < p_DeleteDate;
	
	END IF;	
	
	
	IF p_ActionName = 'VendorRateSheet'
	THEN
		
		
		DELETE 
			tblJobFile
		FROM tblJobFile
		INNER JOIN  tblJob
			ON tblJob.JobID = tblJobFile.JobID
	  	INNER JOIN tblJobType
			 ON tblJob.JobTypeID = tblJobType.JobTypeID
		WHERE tblJobType.`Code` IN('VD','VU') 
			AND tblJob.CompanyID = p_CompanyID 
			AND tblJob.created_at < p_DeleteDate;	
			
		DELETE
			 tblJob
		FROM tblJob
		INNER JOIN tblJobType
			ON tblJob.JobTypeID = tblJobType.JobTypeID
		WHERE tblJobType.`Code` IN('VD','VU')
			AND tblJob.CompanyID = p_CompanyID 
	  		AND tblJob.created_at < p_DeleteDate;
	
	END IF;	
		
   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_DialStringCodekBulkUpdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_DialStringCodekBulkUpdate`(IN `p_dialstringid` int, IN `p_up_chargecode` int, IN `p_up_description` int, IN `p_up_forbidden` int, IN `p_critearea` int, IN `p_dialstringcode` varchar(500), IN `p_critearea_dialstring` varchar(250), IN `p_critearea_chargecode` varchar(250), IN `p_critearea_description` varchar(250), IN `p_critearea_forbidden` INT, IN `p_chargecode` varchar(250), IN `p_description` varchar(250), IN `p_forbidden` varchar(250), IN `p_isAction` int )
BEGIN

   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; 
   
   DROP TEMPORARY TABLE IF EXISTS tmp_dialstringcode;
    CREATE TEMPORARY TABLE tmp_dialstringcode (
      DialStringCodeID INT
    ); 
    
    IF p_critearea = 0
    THEN
    	
    		INSERT INTO tmp_dialstringcode
			  SELECT DialStringCodeID from tblDialStringCode
				where FIND_IN_SET(DialStringCodeID,p_dialstringcode)
						AND DialStringID = p_dialstringid;
    	
    END IF;
    
    IF p_critearea = 1
    THEN
    	
    		INSERT INTO tmp_dialstringcode
			  SELECT DialStringCodeID
			   FROM tblDialStringCode
				WHERE DialStringID = p_dialstringid
						AND (Forbidden = p_critearea_forbidden)
						AND (p_critearea_dialstring IS NULL OR DialString LIKE REPLACE(p_critearea_dialstring, '*', '%'))
		            AND (p_critearea_chargecode IS NULL OR ChargeCode LIKE REPLACE(p_critearea_chargecode, '*', '%'))
      		      AND (p_critearea_description IS NULL OR Description LIKE REPLACE(p_critearea_description, '*', '%'));
    	
    END IF;
    
    IF p_isAction = 0
    THEN
    
    	IF p_up_chargecode = 1
    	THEN
			    	
    		UPDATE tblDialStringCode
    		 INNER JOIN tmp_dialstringcode dc 
    		 	ON dc.DialStringCodeID = tblDialStringCode.DialStringCodeID
    		 SET ChargeCode = p_chargecode
			 WHERE tblDialStringCode.DialStringID = p_dialstringid;	
    	
    	END IF;
    	
    	IF p_up_description = 1
    	THEN

    		UPDATE tblDialStringCode
    		 INNER JOIN tmp_dialstringcode dc 
    		 	ON dc.DialStringCodeID = tblDialStringCode.DialStringCodeID
    		 SET Description = p_description
			 WHERE tblDialStringCode.DialStringID = p_dialstringid;	
    	
    	END IF;
    	
    	IF p_up_forbidden = 1
    	THEN
    	
    		UPDATE tblDialStringCode
    		 INNER JOIN tmp_dialstringcode dc 
    		 	ON dc.DialStringCodeID = tblDialStringCode.DialStringCodeID
    		 SET Forbidden = p_forbidden
			 WHERE tblDialStringCode.DialStringID = p_dialstringid;	
    	
    	END IF;
    
    END IF;
    
    IF p_isAction = 1
    THEN
    	
    	DELETE tblDialStringCode
    		FROM tblDialStringCode
    		 INNER JOIN( SELECT dc.DialStringCodeID FROM tmp_dialstringcode dc) dpc 
    		 	ON dpc.DialStringCodeID = tblDialStringCode.DialStringCodeID
			 WHERE tblDialStringCode.DialStringID = p_dialstringid;	
    	
    END IF;
    
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetAccountBalanceHistory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetAccountBalanceHistory`(IN `p_CompanyID` INT, IN `p_AccountID` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

   DECLARE v_OffSet_ int;
   SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	 
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	
    IF p_isExport = 0
    THEN
         
		SELECT
			abh.PermanentCredit,
			abh.BalanceThreshold,
			abh.CreatedBy,
			abh.created_at
		FROM tblAccountBalanceHistory abh
      WHERE abh.AccountID = p_AccountID
      ORDER BY                
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PermanentCreditDESC') THEN abh.PermanentCredit
			END DESC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PermanentCreditASC') THEN abh.PermanentCredit
			END ASC,				
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ThresholdASC') THEN abh.BalanceThreshold
			END ASC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ThresholdDESC') THEN abh.BalanceThreshold
			END DESC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN abh.created_at
			END ASC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN abh.created_at
			END DESC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByASC') THEN abh.CreatedBy
			END ASC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByDESC') THEN abh.CreatedBy
			END DESC
		LIMIT p_RowspPage OFFSET v_OffSet_;


     SELECT
         COUNT(abh.AccountBalanceHistoryID) as totalcount
     FROM tblAccountBalanceHistory abh
         WHERE abh.AccountID = p_AccountID;
    END IF;

    IF p_isExport = 1
    THEN
        SELECT
			abh.PermanentCredit,
			abh.BalanceThreshold,
			abh.CreatedBy,
			abh.created_at
		FROM tblAccountBalanceHistory abh
      WHERE abh.AccountID = p_AccountID;
    END IF;
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getAccountDiscountPlan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getAccountDiscountPlan`(IN `p_AccountID` INT, IN `p_Type` INT)
BEGIN
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT 
		dg.Name,
		ROUND(adc.Threshold/60,0) as Threshold,
		IF (adc.Unlimited=1,'Unlimited','') as Unlimited,
		ROUND(adc.SecondsUsed/60,0) as MinutesUsed,
		StartDate,
		EndDate,
		adp.created_at,
		adp.CreatedBy
	FROM tblAccountDiscountPlan adp
	INNER JOIN tblAccountDiscountScheme adc
		ON adc.AccountDiscountPlanID = adp.AccountDiscountPlanID
	INNER JOIN tblDiscount d
		ON d.DiscountID = adc.DiscountID
	INNER JOIN tblDestinationGroup dg
		ON dg.DestinationGroupID = d.DestinationGroupID
	WHERE AccountID = p_AccountID 
		AND Type = p_Type;
	

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetAccounts` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetAccounts`(
	IN `p_CompanyID` int,
	IN `p_userID` int ,
	IN `p_IsVendor` int ,
	IN `p_isCustomer` int ,
	IN `p_activeStatus` int,
	IN `p_VerificationStatus` int,
	IN `p_AccountNo` VARCHAR(100),
	IN `p_ContactName` VARCHAR(50),
	IN `p_AccountName` VARCHAR(50),
	IN `p_tags` VARCHAR(50),
	IN `p_IPCLI` VARCHAR(50),
	IN `p_low_balance` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT 


)
BEGIN
	DECLARE v_OffSet_ int;
	DECLARE v_Round_ int;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	IF p_isExport = 0
	THEN

		SELECT
			tblAccount.AccountID,
			tblAccount.Number, 
			tblAccount.AccountName,
			CONCAT(tblAccount.FirstName,' ',tblAccount.LastName) as Ownername,
			tblAccount.Phone, 
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.SOAOffset,0),v_Round_)) as OutStandingAmount,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.UnbilledAmount,0),v_Round_) - ROUND(COALESCE(abc.VendorUnbilledAmount,0),v_Round_)) as UnbilledAmount,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.PermanentCredit,0),v_Round_)) as PermanentCredit,
			tblAccount.Email, 
			tblAccount.IsCustomer, 
			tblAccount.IsVendor,
			tblAccount.VerificationStatus,
			tblAccount.Address1,
			tblAccount.Address2,
			tblAccount.Address3,
			tblAccount.City,
			tblAccount.Country,
			tblAccount.PostCode,
			tblAccount.Picture,			
			IF ( (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount AND abc.BalanceThreshold <> 0 ,1,0) as BalanceWarning,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.UnbilledAmount,0),v_Round_)) as CUA,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.VendorUnbilledAmount,0),v_Round_)) as VUA,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.BalanceAmount,0),v_Round_)) as AE,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,IF(ROUND(COALESCE(abc.PermanentCredit,0),v_Round_) - ROUND(COALESCE(abc.BalanceAmount,0),v_Round_)<0,0,ROUND(COALESCE(abc.PermanentCredit,0),v_Round_) - ROUND(COALESCE(abc.BalanceAmount,0),v_Round_))) as ACL,
			abc.BalanceThreshold,
			tblAccount.Blocked			
		FROM tblAccount
		LEFT JOIN tblAccountBalance abc
			ON abc.AccountID = tblAccount.AccountID
		LEFT JOIN tblUser
			ON tblAccount.Owner = tblUser.UserID
		LEFT JOIN tblContact
			ON tblContact.Owner=tblAccount.AccountID
		LEFT JOIN tblAccountAuthenticate
			ON tblAccountAuthenticate.AccountID = tblAccount.AccountID
		WHERE   tblAccount.CompanyID = p_CompanyID
			AND tblAccount.AccountType = 1
			AND tblAccount.Status = p_activeStatus
			AND tblAccount.VerificationStatus = p_VerificationStatus
			AND (p_userID = 0 OR tblAccount.Owner = p_userID)
			AND ((p_IsVendor = 0 OR tblAccount.IsVendor = 1))
			AND ((p_isCustomer = 0 OR tblAccount.IsCustomer = 1))
			AND ((p_AccountNo = '' OR tblAccount.Number like p_AccountNo))
			AND ((p_AccountName = '' OR tblAccount.AccountName like Concat('%',p_AccountName,'%')))
			AND ((p_IPCLI = '' OR CONCAT(IFNULL(tblAccountAuthenticate.CustomerAuthValue,''),',',IFNULL(tblAccountAuthenticate.VendorAuthValue,'')) LIKE CONCAT('%',p_IPCLI,'%')))
			AND ((p_tags = '' OR tblAccount.tags like Concat(p_tags,'%')))
			AND ((p_ContactName = '' OR (CONCAT(IFNULL(tblContact.FirstName,'') ,' ', IFNULL(tblContact.LastName,''))) like Concat('%',p_ContactName,'%')))
			AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount) )
		GROUP BY tblAccount.AccountID
		ORDER BY
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN tblAccount.AccountName
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN tblAccount.AccountName
			END DESC,                
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NumberDESC') THEN tblAccount.Number
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NumberASC') THEN tblAccount.Number
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OwnernameDESC') THEN tblUser.FirstName
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OwnernameASC') THEN tblUser.FirstName
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PhoneDESC') THEN tblAccount.Phone
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PhoneASC') THEN tblAccount.Phone
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OutStandingAmountDESC') THEN abc.SOAOffset
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OutStandingAmountASC') THEN abc.SOAOffset
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PermanentCreditDESC') THEN abc.PermanentCredit
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PermanentCreditASC') THEN abc.PermanentCredit
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'UnbilledAmountDESC') THEN (ROUND(COALESCE(abc.UnbilledAmount,0),v_Round_) - ROUND(COALESCE(abc.VendorUnbilledAmount,0),v_Round_))
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'UnbilledAmountASC') THEN (ROUND(COALESCE(abc.UnbilledAmount,0),v_Round_) - ROUND(COALESCE(abc.VendorUnbilledAmount,0),v_Round_))
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EmailDESC') THEN tblAccount.Email
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EmailASC') THEN tblAccount.Email
			END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(tblAccount.AccountID) AS totalcount
		FROM tblAccount
		LEFT JOIN tblAccountBalance abc
			ON abc.AccountID = tblAccount.AccountID
		LEFT JOIN tblUser
			ON tblAccount.Owner = tblUser.UserID
		LEFT JOIN tblContact
			ON tblContact.Owner=tblAccount.AccountID
		LEFT JOIN tblAccountAuthenticate
			ON tblAccountAuthenticate.AccountID = tblAccount.AccountID
		WHERE   tblAccount.CompanyID = p_CompanyID
			AND tblAccount.AccountType = 1
			AND tblAccount.Status = p_activeStatus
			AND tblAccount.VerificationStatus = p_VerificationStatus
			AND (p_userID = 0 OR tblAccount.Owner = p_userID)
			AND ((p_IsVendor = 0 OR tblAccount.IsVendor = 1))
			AND ((p_isCustomer = 0 OR tblAccount.IsCustomer = 1))
			AND ((p_AccountNo = '' OR tblAccount.Number like p_AccountNo))
			AND ((p_AccountName = '' OR tblAccount.AccountName like Concat('%',p_AccountName,'%')))
			AND ((p_IPCLI = '' OR CONCAT(IFNULL(tblAccountAuthenticate.CustomerAuthValue,''),',',IFNULL(tblAccountAuthenticate.VendorAuthValue,'')) LIKE CONCAT('%',p_IPCLI,'%')))
			AND ((p_tags = '' OR tblAccount.tags like Concat(p_tags,'%')))
			AND ((p_ContactName = '' OR (CONCAT(IFNULL(tblContact.FirstName,'') ,' ', IFNULL(tblContact.LastName,''))) like Concat('%',p_ContactName,'%')))
			AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount) );

	END IF;
	IF p_isExport = 1
	THEN
		SELECT
			tblAccount.Number as NO,
			tblAccount.AccountName,
			CONCAT(tblAccount.FirstName,' ',tblAccount.LastName) as Name,
			tblAccount.Phone, 
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.SOAOffset,0),v_Round_)) as 'OutStanding',
			tblAccount.Email,
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.UnbilledAmount,0),v_Round_)  - ROUND(COALESCE(abc.VendorUnbilledAmount,0),v_Round_)) as 'Unbilled Amount',
			CONCAT((SELECT Symbol FROM tblCurrency WHERE tblCurrency.CurrencyId = tblAccount.CurrencyId) ,ROUND(COALESCE(abc.PermanentCredit,0),v_Round_)) as 'Credit Limit',
			CONCAT(tblUser.FirstName,' ',tblUser.LastName) as 'Account Owner'
		FROM tblAccount
		LEFT JOIN tblAccountBalance abc
			ON abc.AccountID = tblAccount.AccountID
		LEFT JOIN tblUser
			ON tblAccount.Owner = tblUser.UserID
		LEFT JOIN tblContact
			ON tblContact.Owner=tblAccount.AccountID
		LEFT JOIN tblAccountAuthenticate
			ON tblAccountAuthenticate.AccountID = tblAccount.AccountID
		WHERE   tblAccount.CompanyID = p_CompanyID
			AND tblAccount.AccountType = 1
			AND tblAccount.Status = p_activeStatus
			AND tblAccount.VerificationStatus = p_VerificationStatus
			AND (p_userID = 0 OR tblAccount.Owner = p_userID)
			AND ((p_IsVendor = 0 OR tblAccount.IsVendor = 1))
			AND ((p_isCustomer = 0 OR tblAccount.IsCustomer = 1))
			AND ((p_AccountNo = '' OR tblAccount.Number like p_AccountNo))
			AND ((p_AccountName = '' OR tblAccount.AccountName like Concat('%',p_AccountName,'%')))
			AND ((p_IPCLI = '' OR CONCAT(IFNULL(tblAccountAuthenticate.CustomerAuthValue,''),',',IFNULL(tblAccountAuthenticate.VendorAuthValue,'')) LIKE CONCAT('%',p_IPCLI,'%')))
			AND ((p_tags = '' OR tblAccount.tags like Concat(p_tags,'%')))
			AND ((p_ContactName = '' OR (CONCAT(IFNULL(tblContact.FirstName,'') ,' ', IFNULL(tblContact.LastName,''))) like Concat('%',p_ContactName,'%')))
			AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.BalanceThreshold <> 0 AND (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount) )
		GROUP BY tblAccount.AccountID;
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getAccountTimeLine` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getAccountTimeLine`(
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


if(p_Start>0)
THEN
	DELETE FROM tbl_Account_Contacts_Activity  WHERE  `TableCreated_at` < DATE_SUB(p_Time, INTERVAL 2 DAY);
END IF;
if(p_Start= 0)
THEN
		
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
			
			
		SELECT 
		(CASE WHEN tac.Email = tac.BillingEmail THEN tac.Email ELSE concat(tac.Email,',',tac.BillingEmail) END) 
		FROM
			tblAccount tac
		WHERE 
			tac.AccountID = p_AccountID	INTO v_contacts_emails;	
		
		select concat(v_contacts_emails,',',v_contacts_emails) into v_account_contacts_emails;


			
			
			
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
			
			
			
			INSERT INTO tbl_Account_Contacts_Activity(  `Timeline_type`,  `TaskTitle`,  `TaskName`,  `TaskPriority`,  `DueDate`,  `TaskDescription`,  `TaskStatus`,  `followup_task`,  `TaskID`,  `Emailfrom`,  `EmailTo`,  `EmailToName`,  `EmailSubject`,  `EmailMessage`,  `EmailCc`, `EmailBcc`,  `EmailAttachments`,  `AccountEmailLogID`,  `NoteID`,  `Note`,  `TicketID`,  `TicketSubject`,  `TicketStatus`,  `RequestEmail`,  `TicketPriority`,  `TicketType`,  `TicketGroup`,  `TicketDescription`,  `CreatedBy`,  `created_at`,  `updated_at`,  `GUID`,`TableCreated_at`)
			select 3 as Timeline_type,'' as TaskTitle,'' as TaskName,'' as TaskPriority, '0000-00-00 00:00:00' as DueDate, '' as TaskDescription,'' as TaskStatus, 0 as Task_type,0 as TaskID, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID,NoteID,Note,0 as TicketID, '' as 	TicketSubject,	'' as	TicketStatus,	'' as 	RequestEmail,	'' as 	TicketPriority,	'' as 	TicketType,	'' as 	TicketGroup,	'' as TicketDescription,created_by,created_at,updated_at ,p_GUID as GUID,p_Time as TableCreated_at
			from `tblNote` 
			where (`CompanyID` = p_CompanyID and `AccountID` = p_AccountID) order by created_at desc;
			
			INSERT INTO tbl_Account_Contacts_Activity(  `Timeline_type`,  `TaskTitle`,  `TaskName`,  `TaskPriority`,  `DueDate`,  `TaskDescription`,  `TaskStatus`,  `followup_task`,  `TaskID`,  `Emailfrom`,  `EmailTo`,  `EmailToName`,  `EmailSubject`,  `EmailMessage`,  `EmailCc`, `EmailBcc`,  `EmailAttachments`,  `AccountEmailLogID`,  `ContactNoteID`,  `Note`,  `TicketID`,  `TicketSubject`,  `TicketStatus`,  `RequestEmail`,  `TicketPriority`,  `TicketType`,  `TicketGroup`,  `TicketDescription`,  `CreatedBy`,  `created_at`,  `updated_at`,  `GUID`,`TableCreated_at`)
			select 3 as Timeline_type,'' as TaskTitle,'' as TaskName,'' as TaskPriority, '0000-00-00 00:00:00' as DueDate, '' as TaskDescription,'' as TaskStatus, 0 as Task_type,0 as TaskID, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID,NoteID,Note,0 as TicketID, '' as 	TicketSubject,	'' as	TicketStatus,	'' as 	RequestEmail,	'' as 	TicketPriority,	'' as 	TicketType,	'' as 	TicketGroup,	'' as TicketDescription,created_by,created_at,updated_at ,p_GUID as GUID,p_Time as TableCreated_at
			from `tblContactNote` where (`CompanyID` = p_CompanyID and FIND_IN_SET(ContactID,(v_contacts_ids)))  order by created_at desc;
			
			
			
			
				
			IF p_TicketType=2 
			THEN
			INSERT INTO tbl_Account_Contacts_Activity(  `Timeline_type`,  `TaskTitle`,  `TaskName`,  `TaskPriority`,  `DueDate`,  `TaskDescription`,  `TaskStatus`,  `followup_task`,  `TaskID`,  `Emailfrom`,  `EmailTo`,  `EmailToName`,  `EmailSubject`,  `EmailMessage`,  `EmailCc`, `EmailBcc`,  `EmailAttachments`,  `AccountEmailLogID`,  `NoteID`,  `Note`,  `TicketID`,  `TicketSubject`,  `TicketStatus`,  `RequestEmail`,  `TicketPriority`,  `TicketType`,  `TicketGroup`,  `TicketDescription`,  `CreatedBy`,  `created_at`,  `updated_at`,  `GUID`,`TableCreated_at`)
			select 4 as Timeline_type,'' as TaskTitle,'' as TaskName,'' as TaskPriority, '0000-00-00 00:00:00' as DueDate, '' as TaskDescription,'' as TaskStatus, 0 as Task_type,0 as TaskID, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID, 0 as NoteID,'' as Note,
			TAT.TicketID,	TAT.Subject as 	TicketSubject,	TAT.Status as	TicketStatus,	TAT.RequestEmail as 	RequestEmail,	TAT.Priority as 	TicketPriority,	TAT.`Type` as 	TicketType,	TAT.`Group` as 	TicketGroup,	TAT.`Description` as TicketDescription,created_by,ApiCreatedDate as created_at,ApiUpdateDate as updated_at,p_GUID as GUID,p_Time as TableCreated_at 
			from 
				`tblHelpDeskTickets` TAT 
			where 
				(TAT.`CompanyID` = p_CompanyID and TAT.`AccountID` = p_AccountID and TAT.GUID = p_GUID);
			END IF;

			IF p_TicketType=1 
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
			
			where 			
				TT.`CompanyID` = p_CompanyID and 
			
			FIND_IN_SET(TT.Requester,(v_account_contacts_emails));	
			END IF;
			
END IF;
	select * from tbl_Account_Contacts_Activity where GUID = p_GUID order by created_at desc LIMIT p_RowspPage OFFSET v_OffSet_ ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetActiveCronJob` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetActiveCronJob`(IN `p_companyid` INT, IN `p_Title` VARCHAR(500), IN `p_Status` INT, IN `p_Active` INT, IN `p_Type` INT, IN `p_CurrentDateTime` DATETIME, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT 
)
BEGIN

   DECLARE v_OffSet_ int;
   SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	 
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	
    IF p_isExport = 0
    THEN
         
		SELECT
			jb.Active,
			jb.PID,
			jb.JobTitle,                
			CONCAT(TIMESTAMPDIFF(HOUR,LastRunTime,p_CurrentDateTime),' Hours, ',TIMESTAMPDIFF(minute,LastRunTime,p_CurrentDateTime)%60,' Minutes, ',TIMESTAMPDIFF(second,LastRunTime,p_CurrentDateTime)%60 , ' Seconds' ) AS RunningTime,
			
 			jb.LastRunTime,
			jb.NextRunTime,			
			jb.CronJobID,
			jb.Status,	                 	
          jb.CronJobCommandID,
          jb.Settings	,
 		   (select CronJobStatus from tblCronJobLog where tblCronJobLog.CronJobID = jb.CronJobID order by  CronJobLogID desc limit 1)  as  CronJobStatus
			 	                 							
		FROM tblCronJob jb
		INNER JOIN tblCronJobCommand cm ON cm.CronJobCommandID = jb.CronJobCommandID
      WHERE jb.CompanyID = p_companyid 
		AND (p_Title = '' OR (p_Title != '' AND jb.JobTitle like concat('%', p_Title , '%') ) )
		AND  (p_Status = -1 OR (p_Status != -1 and jb.Status = p_Status ) )
		 AND (p_Active = -1 OR (p_Active != -1 and  jb.Active = p_Active ) )
		 AND (p_Type = 0 OR (p_Type != 0 and  jb.CronJobCommandID = p_Type ) )
      ORDER BY                
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'JobTitleDESC') THEN jb.JobTitle
			END DESC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'JobTitleASC') THEN jb.JobTitle
			END ASC,				
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PIDDESC') THEN jb.PID
			END DESC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PIDASC') THEN jb.PID
			END ASC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastRunTimeASC') THEN jb.LastRunTime
			END ASC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastRunTimeDESC') THEN jb.LastRunTime
			END DESC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NextRunTimeASC') THEN jb.NextRunTime
			END ASC,
			CASE
			  WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NextRunTimeDESC') THEN jb.NextRunTime
			END DESC
		
		LIMIT p_RowspPage OFFSET v_OffSet_;


     SELECT
         COUNT(jb.CronJobID) as totalcount
     FROM tblCronJob jb
		INNER JOIN tblCronJobCommand cm ON cm.CronJobCommandID = jb.CronJobCommandID
      WHERE jb.CompanyID = p_companyid 
		AND (p_Title = '' OR (p_Title != '' AND jb.JobTitle like concat('%', p_Title , '%') ) )
		AND  (p_Status = -1 OR (p_Status != -1 and jb.Status = p_Status ) )
		AND (p_Active = -1 OR (p_Active != -1 and  jb.Active = p_Active ) )
		AND (p_Type = 0 OR (p_Type != 0 and  jb.CronJobCommandID = p_Type ) );
		 
    END IF;

    IF p_isExport = 1
    THEN
        SELECT
			jb.Active,
			jb.PID,
			jb.JobTitle,                
			CONCAT(TIMESTAMPDIFF(HOUR,LastRunTime,p_CurrentDateTime),' Hours, ',TIMESTAMPDIFF(minute,LastRunTime,p_CurrentDateTime)%60,' Minutes, ',TIMESTAMPDIFF(second,LastRunTime,p_CurrentDateTime)%60 , ' Seconds' ) AS RunningTime,
 			jb.LastRunTime,
			jb.NextRunTime
        FROM tblCronJob jb
			INNER JOIN tblCronJobCommand cm ON cm.CronJobCommandID = jb.CronJobCommandID
	      WHERE jb.CompanyID = p_companyid 
			AND (p_Title = '' OR (p_Title != '' AND jb.JobTitle like concat('%', p_Title , '%') ) )
			AND  (p_Status = -1 OR (p_Status != -1 and jb.Status = p_Status ) )
			AND (p_Active = -1 OR (p_Active != -1 and  jb.Active = p_Active ) )
			AND (p_Type = 0 OR (p_Type != 0 and  jb.CronJobCommandID = p_Type ) );
		 	
		 	
    END IF;
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getActiveCronJobCommand` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getActiveCronJobCommand`(IN `p_CompanyID` INT, IN `p_CronJobID` INT)
BEGIN

   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT
		tblCronJobCommand.Command,
		tblCronJob.CronJobID
	FROM tblCronJob
	INNER JOIN tblCronJobCommand
		ON tblCronJobCommand.CronJobCommandID = tblCronJob.CronJobCommandID
	WHERE tblCronJob.CronJobID = p_CronJobID and tblCronJob.CompanyID = p_CompanyID 
	AND tblCronJob.Status = 1;

   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetAjaxActionList` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetAjaxActionList`(IN `p_CompanyID` INT, IN `p_ResourceCategoryID` LONGTEXT, IN `p_action` int)
BEGIN

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;  
	
	IF p_action = 1
    THEN
	select distinct r.ResourceID,r.ResourceName,
		case when rcm.ResourceID>0
		then
		1
		else
		null
		end As Checked 
	From `tblResource` r left join  `tblResourceCategoryMapping` rcm on r.ResourceID=rcm.ResourceID and (FIND_IN_SET(rcm.ResourceCategoryID,p_ResourceCategoryID) != 0 ) 
		where r.CompanyID=p_CompanyID
	order by
		 case when rcm.ResourceID>0
	 then
		1
     else
	    null
     end
	  desc, ResourceName asc;
	
	 END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetAjaxResourceList` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetAjaxResourceList`(IN `p_CompanyID` INT, IN `p_userid` LONGTEXT, IN `p_roleids` LONGTEXT, IN `p_action` int)
BEGIN

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;  
	
	IF p_action = 1
    THEN

        select distinct tblResourceCategories.ResourceCategoryID,tblResourceCategories.ResourceCategoryName,usrper.AddRemove,rolres.Checked
			from tblResourceCategories
			LEFT OUTER JOIN(
			select distinct rs.ResourceID, rs.ResourceName,usrper.AddRemove
			from tblResource rs
			inner join tblUserPermission usrper on usrper.resourceID = rs.ResourceID and FIND_IN_SET(usrper.UserID ,p_userid) != 0 ) usrper
			on usrper.ResourceID = tblResourceCategories.ResourceCategoryID
			LEFT OUTER JOIN(
			select distinct res.ResourceID, res.ResourceName,'true' as Checked
			from `tblResource` res
			inner join `tblRolePermission` rolper on rolper.resourceID = res.ResourceID and FIND_IN_SET(rolper.roleID ,p_roleids) != 0) rolres
			on rolres.ResourceID = tblResourceCategories.ResourceCategoryID
			where tblResourceCategories.CompanyID= p_CompanyID order by rolres.Checked desc,usrper.AddRemove desc,tblResourceCategories.ResourceCategoryName;
    
	
	END IF;
	
	IF p_action = 2
	THEN

		select  distinct `tblResourceCategories`.`ResourceCategoryID`, `tblResourceCategories`.`ResourceCategoryName`, tblRolePermission.resourceID as Checked ,case when tblRolePermission.resourceID>0
	 then
		1
     else
	    0
     end as check2
		from tblResourceCategories left join tblRolePermission on `tblRolePermission`.`resourceID` = `tblResourceCategories`.`ResourceCategoryID` 
		and `tblRolePermission`.`CompanyID` = p_CompanyID and FIND_IN_SET(`tblRolePermission`.`roleID`,p_roleids) != 0
		order by
		case when tblRolePermission.resourceID>0
	 then
		1
     else
	    0
     end
	  desc,`tblResourceCategories`.`ResourceCategoryName` asc;
	
	
	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetAjaxRoleList` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetAjaxRoleList`(IN `p_CompanyID` INT, IN `p_UserID` LONGTEXT, IN `p_ResourceID` LONGTEXT, IN `p_action` int)
BEGIN

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;  
	
	IF p_action = 1
	THEN

	select distinct `tblRole`.`RoleID`, `tblRole`.`RoleName`, tblUserRole.RoleID as Checked,case when tblUserRole.RoleID>0
	 then
		1
     else
	    0
     end as check2
	 from tblRole 
	 left join tblUserRole on `tblUserRole`.`RoleID` = `tblRole`.`RoleID` and `tblRole`.`CompanyID` = p_CompanyID and  FIND_IN_SET(`tblUserRole`.`UserID`, p_UserID) != 0
	 order by
	 case when tblUserRole.RoleID>0
	 then
		1
     else
	    0
     end
	  desc,`tblRole`.`RoleName` asc;

	END IF;
	
	IF p_action = 2
	THEN

	select distinct `tblRole`.`RoleID`, `tblRole`.`RoleName`, tblRolePermission.RoleID as Checked,case when tblRolePermission.RoleID>0
	 then
		1
     else
	    0
     end as check2
	 from tblRole 
	 left join tblRolePermission on `tblRolePermission`.`roleID` = `tblRole`.`RoleID` and `tblRolePermission`.`CompanyID` = p_CompanyID and FIND_IN_SET(`tblRolePermission`.`resourceID`,p_ResourceID) != 0
	  order by
	  case when tblRolePermission.RoleID>0
	 then
		1
     else
	    0
     end
	  desc,`tblRole`.`RoleName` asc;
	
	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetAjaxUserList` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetAjaxUserList`(IN `p_CompanyID` INT, IN `p_ResourceCategoryID` LONGTEXT, IN `p_roleids` LONGTEXT, IN `p_action` int)
BEGIN

   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;  
	
	IF p_action = 1
	THEN

	select distinct `tblUser`.`UserID`, (CONCAT(tblUser.FirstName,' ',tblUser.LastName)) as UserName,case when tblUserRole.RoleID>0
	 then
		1
     else
	    null
     end As Checked 
		from tblUser left join tblUserRole on `tblUserRole`.`UserID` = `tblUser`.`UserID` 
		and `tblUser`.`CompanyID` = p_CompanyID and FIND_IN_SET(`tblUserRole`.`RoleID`,p_roleids)  != 0
		where `AdminUser` != '1' or `AdminUser` is null
		 order by
		 case when tblUserRole.RoleID>0
	 then
		1
     else
	    null
     end
	  desc, UserName asc;

	END IF;
	
	IF p_action = 2
	THEN

	SELECT distinct u.UserID,(CONCAT(u.FirstName,' ',u.LastName)) as UserName,Perm.Checked, UPerm.AddRemove
		FROM tblUser u
		LEFT OUTER JOIN
		(SELECT distinct u.userid,'true' as Checked,tblResourceCategories.ResourceCategoryName as permname
		FROM tblUser u
		inner join tblUserRole ur on u.UserID = ur.UserID
		inner join tblRole r on ur.RoleID = r.RoleID
		inner join tblRolePermission rp on r.RoleID = rp.roleID
		inner join tblResourceCategories on rp.resourceID = tblResourceCategories.ResourceCategoryID
		WHERE  FIND_IN_SET(tblResourceCategories.ResourceCategoryID,p_ResourceCategoryID) != 0 ) Perm
		ON u.UserID = Perm.UserID
		LEFT OUTER JOIN
		(SELECT distinct u.userid, up.AddRemove,tblResourceCategories.ResourceCategoryName as permname
		FROM tblUser u
		inner join tblUserPermission up on u.UserID = up.UserID
		inner join tblResourceCategories on up.resourceID = tblResourceCategories.ResourceCategoryID
		WHERE FIND_IN_SET(tblResourceCategories.ResourceCategoryID ,p_ResourceCategoryID) != 0 ) UPerm
		on u.userid = UPerm.userid
		where u.CompanyID = p_CompanyID and u.AdminUser != 1 or u.AdminUser is null
		order by Perm.Checked desc, UPerm.AddRemove desc,UserName asc;

	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getAlert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getAlert`(
	IN `p_CompanyID` INT,
	IN `p_AlertGroup` VARCHAR(50),
	IN `p_AlertType` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN

	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	IF p_isExport = 0
	THEN

		SELECT
			Name,
			AlertType,
			Status,
			LowValue,
			HighValue,
			updated_at,
			UpdatedBy,
			AlertID,
			Settings
		FROM tblAlert
		WHERE  CompanyID = p_CompanyID
			AND CreatedByCustomer = 0 
			AND (p_AlertGroup = '' OR AlertGroup = p_AlertGroup)
			AND (p_AlertType = '' OR AlertType = p_AlertType)
		ORDER BY
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameDESC') THEN Name
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameASC') THEN Name
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'UpdatedByDESC') THEN UpdatedBy
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'UpdatedByASC') THEN UpdatedBy
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN updated_at
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN updated_at
			END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(AlertID) AS totalcount
		FROM tblAlert
		WHERE  CompanyID = p_CompanyID
			AND CreatedByCustomer = 0 
			AND (p_AlertGroup = '' OR AlertGroup = p_AlertGroup)
			AND (p_AlertType = '' OR AlertType = p_AlertType);

	END IF;

	IF p_isExport = 1
	THEN
	
		SELECT
			Name,
			UpdatedBy,
			updated_at
		FROM tblAlert
		WHERE  CompanyID = p_CompanyID
			AND CreatedByCustomer = 0 
			AND (p_AlertGroup = '' OR AlertGroup = p_AlertGroup)
			AND (p_AlertType = '' OR AlertType = p_AlertType);
	
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getAlertHistory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getAlertHistory`(
	IN `p_CompanyID` INT,
	IN `p_AlertID` INT,
	IN `p_AlertType` VARCHAR(50),
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_SearchText` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN

	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	IF p_isExport = 0
	THEN
		SELECT
			tblAlert.Name,
			tblAlert.AlertType,
			tblAlertLog.send_at,
			AccountEmailLog.Subject,
			AccountEmailLog.Message
		FROM tblAlert
		INNER JOIN tblAlertLog 
			ON tblAlert.AlertID = tblAlertLog.AlertID
		INNER JOIN AccountEmailLog 
			ON tblAlertLog.AccountEmailLogID = AccountEmailLog.AccountEmailLogID
		WHERE tblAlert.CompanyID = p_CompanyID
			AND (p_AlertID = 0 OR tblAlert.AlertID = p_AlertID)
			AND (p_AlertType = '' OR tblAlert.AlertType = p_AlertType)
			AND tblAlertLog.send_at BETWEEN p_StartDate and p_EndDate
			AND (p_SearchText='' OR tblAlert.Name LIKE CONCAT('%',p_SearchText,'%'))
		ORDER BY
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MessageDESC') THEN tblAlert.Name
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MessageASC') THEN tblAlert.Name
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AlertTypeDESC') THEN tblAlert.AlertType
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AlertTypeASC') THEN tblAlert.AlertType
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN tblAlertLog.send_at
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN tblAlertLog.send_at
			END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(tblAlertLog.AlertLogID) as totalcount
		FROM tblAlert
		INNER JOIN tblAlertLog 
			ON tblAlert.AlertID = tblAlertLog.AlertID
		WHERE CompanyID = p_CompanyID
			AND (p_AlertID = 0 OR tblAlert.AlertID = p_AlertID)
			AND (p_AlertType = '' OR tblAlert.AlertType = p_AlertType)
			AND tblAlertLog.send_at BETWEEN p_StartDate and p_EndDate
			AND (p_SearchText='' OR tblAlert.Name LIKE CONCAT('%',p_SearchText,'%'));
	END IF;

	IF p_isExport = 1
	THEN
		SELECT
			tblAlert.Name,
			tblAlert.AlertType,
			tblAlertLog.send_at
		FROM tblAlert
		INNER JOIN tblAlertLog 
			ON tblAlert.AlertID = tblAlertLog.AlertID
		WHERE CompanyID = p_CompanyID
			AND (p_AlertID = 0 OR tblAlert.AlertID = p_AlertID)
			AND (p_AlertType = '' OR tblAlert.AlertType = p_AlertType)
			AND tblAlertLog.send_at BETWEEN p_StartDate and p_EndDate
			AND (p_SearchText='' OR tblAlert.Name LIKE CONCAT('%',p_SearchText,'%'));
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetAllDashboardData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetAllDashboardData`(IN `p_companyId` INT, IN `p_userId` INT, IN `p_isadmin` INT)
BEGIN
  DECLARE v_isAccountManager_ int;
   
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
 

SELECT count(*) as TotalDueCustomer,DAYSDIFF from (
			SELECT distinct  a.AccountName,a.AccountID,cr.TrunkID,cr.EffectiveDate,TIMESTAMPDIFF(DAY,cr.EffectiveDate, NOW()) as DAYSDIFF
			FROM tblCustomerRate cr
			INNER JOIN tblRate  r on r.RateID =cr.RateID
			INNER JOIN tblCountry c on c.CountryID = r.CountryID
			INNER JOIN tblAccount a on a.AccountID = cr.CustomerID
			WHERE a.CompanyId =@companyId
			AND TIMESTAMPDIFF(DAY, cr.EffectiveDate, DATE_FORMAT (NOW(),120)) BETWEEN -1 AND 1

		) as tbl
		LEFT JOIN tblJob ON tblJob.AccountID = tbl.AccountID
					AND tblJob.JobID IN(select JobID from tblJob where JobTypeID = (select JobTypeID from tblJobType where Code='CD'))
					AND FIND_IN_SET (tbl.TrunkID,JSON_EXTRACT(tblJob.Options, '$.Trunks')) != 0

					AND ( TIMESTAMPDIFF(DAY, tblJob.created_at, NOW()) = DAYSDIFF or TIMESTAMPDIFF(DAY, tblJob.created_at, EffectiveDate)  BETWEEN -1 AND 0)

		where JobStatusID is null or JobStatusID <> (select JobStatusID from tblJobStatus where Code='S')
		group by DAYSDIFF
		order by DAYSDIFF desc;

 
        

        SELECT count(*) as TotalDueVendor ,DAYSDIFF from (
				SELECT  DISTINCT a.AccountName,a.AccountID,vr.TrunkID,vr.EffectiveDate,TIMESTAMPDIFF(DAY,vr.EffectiveDate, NOW()) as DAYSDIFF
			FROM tblVendorRate vr
			INNER JOIN tblRate  r on r.RateID =vr.RateID
			INNER JOIN tblCountry c on c.CountryID = r.CountryID
			INNER JOIN tblAccount a on a.AccountID = vr.AccountId
			WHERE a.CompanyId = @companyId
			AND TIMESTAMPDIFF(DAY,vr.EffectiveDate, NOW()) BETWEEN -1 AND 1
	   ) as tbl
		LEFT JOIN tblJob ON tblJob.AccountID = tbl.AccountID
					AND tblJob.JobID IN(select JobID from tblJob where JobTypeID = (select JobTypeID from tblJobType where Code='VD'))
					AND FIND_IN_SET (tbl.TrunkID,JSON_EXTRACT(tblJob.Options, '$.Trunks')) != 0
					AND ( TIMESTAMPDIFF(DAY, tblJob.created_at, NOW()) = DAYSDIFF or TIMESTAMPDIFF(DAY, tblJob.created_at, EffectiveDate)  BETWEEN -1 AND 0)

		where JobStatusID is null or JobStatusID <> (select JobStatusID from tblJobStatus where Code='S')
		group by DAYSDIFF
		order by DAYSDIFF desc;
  
   
     select `tblJob`.`JobID`, `tblJob`.`Title`, `tblJobStatus`.`Title` as Status, `tblJob`.`HasRead`, `tblJob`.`CreatedBy`, `tblJob`.`created_at` 
     from tblJob inner join tblJobStatus on `tblJob`.`JobStatusID` = `tblJobStatus`.`JobStatusID` inner join tblJobType on `tblJob`.`JobTypeID` = `tblJobType`.`JobTypeID` 
     where `tblJob`.`CompanyID` = p_companyId AND ( p_isadmin = 1 OR (p_isadmin = 0 and tblJob.JobLoggedUserID = p_userId) )
     order by `tblJob`.`ShowInCounter` desc, `tblJob`.`updated_at` desc,tblJob.JobID desc
	  limit 10;
     
    
 
    select count(*) as aggregate from tblJob inner join tblJobStatus on `tblJob`.`JobStatusID` = `tblJobStatus`.`JobStatusID` 
    where `tblJobStatus`.`Title` = 'Pending' and `tblJob`.`CompanyID` = p_companyId AND 
     ( p_isadmin = 1 OR ( p_isadmin = 0 and tblJob.JobLoggedUserID = p_userId) );
   
  
 
      select `tblJob`.`JobID`, `tblJob`.`Title`, `tblJobStatus`.`Title` as Status, `tblJob`.`CreatedBy`, `tblJob`.`created_at` from tblJob inner join tblJobStatus on `tblJob`.`JobStatusID` = `tblJobStatus`.`JobStatusID` inner join tblJobType on `tblJob`.`JobTypeID` = `tblJobType`.`JobTypeID` 
        where ( tblJobStatus.Title = 'Success' OR tblJobStatus.Title = 'Completed' ) and `tblJob`.`CompanyID` = p_companyId and
        ( p_isadmin = 1 OR ( p_isadmin = 0 and `tblJob`.`JobLoggedUserID` = p_userId))  and `tblJob`.`updated_at` >= DATE_SUB(NOW(), INTERVAL 7 DAY)
		  limit 10; 
        
	  
        select AccountID,AccountName,Phone,Email,created_by,created_at from tblAccount where (`AccountType` = '0' and `CompanyID` = p_companyId and `Status` = '1') order by `tblAccount`.`AccountID` desc limit 10;
    
 
    select AccountID,AccountName,Phone,Email,created_by,created_at from tblAccount 
          where 
          `AccountType` = '1' and CompanyID = p_companyId and `Status` = '1' 
          AND (  v_isAccountManager_ = 0 OR (v_isAccountManager_ = 1 AND tblAccount.Owner = p_userId ) )
    order by `tblAccount`.`AccountID` desc
	 limit 10;
  
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetAllEmailMessages` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetAllEmailMessages`(
	IN `p_companyid` INT,
	IN `p_UserID` INT,
	IN `p_isadmin` INT,
	IN `p_EmailCall` VARCHAR(50),
	IN `p_Search` VARCHAR(200),
	IN `p_Unread` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT


)
    DETERMINISTIC
BEGIN
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	IF p_EmailCall = 1 
	THEN
         SELECT
           	   ae.AccountEmailLogID,
           	   ae.EmailfromName,
           	   ae.Subject,           	   
           	   ae.AttachmentPaths,
           	   tblMessages.created_at,              
               ae.AccountID,
               tblMessages.HasRead              
         FROM
				tblMessages
			INNER JOIN
					 AccountEmailLog ae
			ON 
				ae.AccountEmailLogID = tblMessages.EmailID			
         WHERE
				tblMessages.CompanyID = p_companyid        
				AND ae.EmailCall = p_EmailCall
				AND (p_isadmin = 1 OR (p_isadmin = 0 AND tblMessages.MsgLoggedUserID = p_UserID)) 
				AND (p_Search = '' OR (ae.Subject like Concat('%',p_Search,'%') OR ae.Message like Concat('%',p_Search,'%')))
				AND (p_Unread = 0 OR (p_Unread = 1 AND tblMessages.HasRead=0))				
		   ORDER BY
				tblMessages.MsgID desc      
         LIMIT
				p_RowspPage OFFSET p_PageNumber;
          
		  	  
         SELECT
				COUNT(tblMessages.MsgID) as totalcount
		   FROM tblMessages
				INNER JOIN AccountEmailLog ae
				ON ae.AccountEmailLogID = tblMessages.EmailID
		   WHERE tblMessages.CompanyID = p_companyid
				AND ae.EmailCall = p_EmailCall
				AND  (p_isadmin = 1 OR (p_isadmin = 0 AND tblMessages.MsgLoggedUserID = p_UserID))
				AND (p_Search = '' OR (ae.Subject like Concat('%',p_Search,'%') OR ae.Message like Concat('%',p_Search,'%')))
				AND (p_Unread = 0 OR (p_Unread = 1 AND tblMessages.HasRead=0));
   	END IF;
	 	IF p_EmailCall = 0 
		THEN
		SELECT
           	   ae.AccountEmailLogID as AccountEmailLogID,
           	   ae.EmailfromName as EmailfromName,
           	   ae.Subject as Subject,           	   
           	   ae.AttachmentPaths as AttachmentPaths, 
           	   ae.created_at as created_at,
               ae.CreatedBy as CreatedBy,
               ae.AccountID as AccountID,
               ae.EmailTo as EmailTo
      FROM
				AccountEmailLog ae						
      WHERE
				ae.CompanyID = p_companyid        
				AND ae.EmailCall = p_EmailCall
				AND  (p_isadmin = 1 OR (p_isadmin = 0 AND ae.UserID = p_UserID))  
				AND (p_Search = '' OR (ae.Subject like Concat('%',p_Search,'%') OR ae.Message like Concat('%',p_Search,'%')))
		ORDER BY
				ae.AccountEmailLogID desc      
      LIMIT
				p_RowspPage OFFSET p_PageNumber;
          
		  	  
         SELECT
				COUNT(ae.AccountEmailLogID) as totalcount
		   FROM AccountEmailLog ae
		   WHERE ae.CompanyID = p_companyid
				AND ae.EmailCall = p_EmailCall
				AND  (p_isadmin = 1 OR (p_isadmin = 0 AND ae.UserID = p_UserID))  
				AND (p_Search = '' OR (ae.Subject like Concat('%',p_Search,'%') OR ae.Message like Concat('%',p_Search,'%')));
	  END IF;  
			IF p_EmailCall = 2 
		THEN
				
			  SELECT
           	   ae.AccountEmailLogID,
           	   ae.EmailTo,
           	   ae.Subject,           	   
           	   ae.AttachmentPaths,
           	   ae.created_at           
            FROM
				AccountEmailLog ae						
            WHERE
				 ae.CompanyID = p_companyid   
				AND ae.EmailCall = p_EmailCall
				AND  (p_isadmin = 1 OR (p_isadmin = 0 AND ae.UserID = p_UserID)) 
				AND (p_Search = '' OR (ae.Subject like Concat('%',p_Search,'%')) OR (ae.Message like Concat('%',p_Search,'%')))			
		    order by
				ae.AccountEmailLogID desc      
           LIMIT
				p_RowspPage OFFSET p_PageNumber;
				
				  
           SELECT
				COUNT(ae.AccountEmailLogID) as totalcount
		   FROM AccountEmailLog ae
		   WHERE ae.CompanyID = p_companyid
				AND ae.EmailCall = p_EmailCall
				AND  (p_isadmin = 1 OR (p_isadmin = 0 AND ae.UserID = p_UserID))  
				AND (p_Search = '' OR (ae.Subject like Concat('%',p_Search,'%')) OR (ae.Message like Concat('%',p_Search,'%')));
				
			END IF; 	 
			
			
          SELECT
				COUNT(tblMessages.MsgID) as totalcountInbox
		   FROM tblMessages
				INNER JOIN AccountEmailLog ae
				ON ae.AccountEmailLogID = tblMessages.EmailID
	       WHERE
				 tblMessages.CompanyID = p_companyid
				 AND ae.EmailCall = 1
				 AND  (p_isadmin = 1 OR (p_isadmin = 0 AND tblMessages.MsgLoggedUserID = p_UserID))
				 AND  tblMessages.HasRead=0;
				 
				 
			SELECT
				COUNT(ae.AccountEmailLogID) as TotalCountDraft
		   FROM AccountEmailLog ae			
	       WHERE				
				 ae.CompanyID = p_companyid
				 AND ae.EmailCall = 2
				 AND  (p_isadmin = 1 OR (p_isadmin = 0 AND ae.UserID = p_UserID));
			
			
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetAllJobs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetAllJobs`(IN `p_companyid` INT, IN `p_Status` INT, IN `p_Type` INT, IN `p_AccountID` INT, IN `p_UserID` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
    
    

    IF p_isExport = 0
    THEN
          
            SELECT
                tblJob.Title,
                tblJobType.Title as Type,
                tblJobStatus.Title as Status,
                tblJob.created_at,
                tblJob.CreatedBy as CreatedBy,
                tblJob.JobID,
                tblJob.ShowInCounter,
                tblJob.updated_at
            FROM tblJob
           JOIN tblJobStatus 
                ON tblJob.JobStatusID = tblJobStatus.JobStatusID
            JOIN tblJobType 
                ON tblJob.JobTypeID = tblJobType.JobTypeID
            WHERE tblJob.CompanyID = p_companyid
            AND ( p_UserID = 0  OR ( p_UserID > 0 AND  tblJob.JobLoggedUserID = p_UserID )  )
            AND ( p_Status = ''  OR ( p_Status > 0 AND  tblJob.JobStatusID = p_Status )  )
            AND ( p_Type = ''  OR ( p_Type > 0 AND  tblJob.JobTypeID = p_Type )  )
            AND ( p_AccountID = ''  OR ( p_AccountID > 0 AND  tblJob.AccountID = p_AccountID )  )
            ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleDESC') THEN tblJob.Title
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleASC') THEN tblJob.Title
                END ASC,
                 CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TypeDESC') THEN tblJobType.Title
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TypeASC') THEN tblJobType.Title
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN tblJobStatus.Title
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN tblJobStatus.Title
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN tblJob.created_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN tblJob.created_at
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByDESC') THEN tblJob.CreatedBy
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByASC') THEN tblJob.CreatedBy
                END ASC

           LIMIT p_RowspPage OFFSET v_OffSet_;

        SELECT
            COUNT(tblJob.JobID) as totalcount
        FROM tblJob
           JOIN tblJobStatus 
                ON tblJob.JobStatusID = tblJobStatus.JobStatusID
            JOIN tblJobType 
                ON tblJob.JobTypeID = tblJobType.JobTypeID
            WHERE tblJob.CompanyID = p_companyid
            AND ( p_UserID = 0  OR ( p_UserID > 0 AND  tblJob.JobLoggedUserID = p_UserID )  )
            AND ( p_Status = ''  OR ( p_Status > 0 AND  tblJob.JobStatusID = p_Status )  )
            AND ( p_Type = ''  OR ( p_Type > 0 AND  tblJob.JobTypeID = p_Type )  )
            AND ( p_AccountID = ''  OR ( p_AccountID > 0 AND  tblJob.AccountID = p_AccountID )  );


    END IF;

    IF p_isExport = 1
    THEN
        SELECT
            tblJob.Title,
                tblJobType.Title as Type,
                tblJobStatus.Title as Status,
                tblJob.created_at,
                tblJob.CreatedBy as CreatedBy
        FROM tblJob
           JOIN tblJobStatus 
                ON tblJob.JobStatusID = tblJobStatus.JobStatusID
            JOIN tblJobType 
                ON tblJob.JobTypeID = tblJobType.JobTypeID
            WHERE tblJob.CompanyID = p_companyid
            AND ( p_UserID = 0  OR ( p_UserID > 0 AND  tblJob.JobLoggedUserID = p_UserID )  )
            AND ( p_Status = ''  OR ( p_Status > 0 AND  tblJob.JobStatusID = p_Status )  )
            AND ( p_Type = ''  OR ( p_Type > 0 AND  tblJob.JobTypeID = p_Type )  )
            AND ( p_AccountID = ''  OR ( p_AccountID > 0 AND  tblJob.AccountID = p_AccountID )  );
    END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetAllResourceCategoryByUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetAllResourceCategoryByUser`(IN `p_CompanyID` INT, IN `p_userid` LONGTEXT)
BEGIN

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
     select distinct
		case
		when (rolres.Checked is not null and  usrper.AddRemove ='add') or (rolres.Checked is not null and usrper.AddRemove is null ) or	(rolres.Checked is null and  usrper.AddRemove ='add')
		then rescat.ResourceCategoryID
		end as ResourceCategoryID,
		case
		when (rolres.Checked is not null and  usrper.AddRemove ='add') or (rolres.Checked is not null and usrper.AddRemove is null ) or	(rolres.Checked is null and  usrper.AddRemove ='add')
		then rescat.ResourceCategoryName
		end as ResourceCategoryName
		from tblResourceCategories rescat
		LEFT OUTER JOIN(
			select distinct rescat.ResourceCategoryID, rescat.ResourceCategoryName,usrper.AddRemove
			from tblResourceCategories rescat
			inner join tblUserPermission usrper on usrper.resourceID = rescat.ResourceCategoryID and  FIND_IN_SET(usrper.UserID,p_userid) != 0 ) usrper
			on usrper.ResourceCategoryID = rescat.ResourceCategoryID
	      LEFT OUTER JOIN(
			select distinct rescat.ResourceCategoryID, rescat.ResourceCategoryName,'true' as Checked
			from `tblResourceCategories` rescat
			inner join `tblRolePermission` rolper on rolper.resourceID = rescat.ResourceCategoryID and rolper.roleID in(SELECT RoleID FROM `tblUserRole` where FIND_IN_SET(UserID,p_userid) != 0 )) rolres
			on rolres.ResourceCategoryID = rescat.ResourceCategoryID
		where rescat.CompanyID= p_CompanyID;
		
		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getBillingClass` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getBillingClass`(IN `p_CompanyID` INT, IN `p_Name` VARCHAR(50), IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	IF p_isExport = 0
	THEN

		SELECT
			Name,
			UpdatedBy,
			updated_at,
			BillingClassID,
			(SELECT COUNT(*) FROM tblAccountBilling a WHERE a.BillingClassID =  tblBillingClass.BillingClassID) as Applied
		FROM tblBillingClass
		WHERE  CompanyID = p_CompanyID 
			AND (p_Name = '' OR Name LIKE REPLACE(p_Name, '*', '%'))
		ORDER BY
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameDESC') THEN Name
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameASC') THEN Name
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'UpdatedByDESC') THEN UpdatedBy
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'UpdatedByASC') THEN UpdatedBy
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN updated_at
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN updated_at
			END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(BillingClassID) AS totalcount
		FROM tblBillingClass
		WHERE  CompanyID = p_CompanyID 
			AND (p_Name = '' OR Name LIKE REPLACE(p_Name, '*', '%'));

	END IF;

	IF p_isExport = 1
	THEN
	
		SELECT
			Name,
			UpdatedBy,
			updated_at
		FROM tblBillingClass
		WHERE  CompanyID = p_CompanyID 
			AND (p_Name = '' OR Name LIKE REPLACE(p_Name, '*', '%'));
	
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetBlockUnblockAccount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetBlockUnblockAccount`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT

)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT
		DISTINCT
		a.AccountID,
		a.Number,
		a.AccountName,
		(COALESCE(ab.BalanceAmount,0) - COALESCE(ab.PermanentCredit,0)) as Balance,
		IF((COALESCE(ab.BalanceAmount,0) - COALESCE(ab.PermanentCredit,0)) > 0 AND a.`Status` = 1 ,1,0) as BlockStatus,
		a.`Status`,
		a.BillingEmail,
		a.Blocked
	FROM tblAccountBalance ab 
	INNER JOIN tblAccount a 
		ON a.AccountID = ab.AccountID
	INNER JOIN wavetelwholesaleBilling.tblGatewayAccount ga
		ON ga.AccountID = a.AccountID
	WHERE a.CompanyId = p_CompanyID
	AND a.AccountType = 1
	AND ( p_CompanyGatewayID = 0 OR ga.CompanyGatewayID = p_CompanyGatewayID)
	ORDER BY BlockStatus,a.AccountID;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetBlockUnblockVendor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetBlockUnblockVendor`(IN `p_companyid` INT, IN `p_UserID` int , IN `p_TrunkID` INT, IN `p_CountryIDs` TEXT, IN `p_CountryCodes` TEXT, IN `p_isCountry` int , IN `p_action` VARCHAR(10), IN `p_isAllCountry` int , IN `p_criteria` INT)
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
		 
		 
		 
		IF p_isCountry = 0
	THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_codes_;
	   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_codes_(
				Code varchar(20),
			INDEX tmp_Code (`Code`)
		);
	END IF;	
   		IF p_criteria = 0 AND p_isCountry = 0 
		THEN
   		insert into tmp_codes_
		   SELECT  distinct tblRate.Code 
            FROM    tblRate
           WHERE    tblRate.CompanyID = p_companyid  AND ( p_CountryCodes  = '' OR FIND_IN_SET(tblRate.Code,p_CountryCodes) != 0 );
        END IF;   

        IF p_criteria = 1 AND  p_isCountry = 0 
		THEN
   		insert into tmp_codes_
		   SELECT  distinct tblRate.Code 
            FROM    tblRate
           WHERE    tblRate.CompanyID = p_companyid  AND ( p_CountryCodes  = '' OR Code LIKE REPLACE(p_CountryCodes,'*', '%') );
        END IF; 
		
		IF p_criteria =2 AND p_isCountry = 0 
		THEN
			
			insert into tmp_codes_
			SELECT  distinct tblRate.Code 
            FROM    tblRate
           WHERE    tblRate.CompanyID = p_companyid
		   AND ( FIND_IN_SET(tblRate.CountryID,p_CountryIDs) != 0 );
		
		END IF;
		
		IF p_criteria =3 AND p_isCountry = 0 
		THEN
			
			insert into tmp_codes_
			SELECT  distinct tblRate.Code 
            FROM    tblRate
           WHERE    tblRate.CompanyID = p_companyid;
		
		END IF;

	if p_isCountry  = 0 AND p_action = 0  
	Then
			SELECT SQL_CALC_FOUND_ROWS DISTINCT tblVendorRate.AccountId , tblAccount.AccountName
				from tblVendorRate
				inner join tblAccount on tblVendorRate.AccountId = tblAccount.AccountID
						and tblAccount.Status = 1
						and tblAccount.CompanyID = p_companyid 
						AND tblAccount.IsVendor = 1 
						and tblAccount.AccountType = 1						
				inner join tblRate on tblVendorRate.RateId  = tblRate.RateId  				
					and tblVendorRate.TrunkID = p_TrunkID
				Inner join tmp_codes_ c on c.Code = tblRate.Code	
				inner join tblVendorTrunk on tblVendorTrunk.CompanyID = p_companyid
					and tblVendorTrunk.AccountID =	tblVendorRate.AccountID 
					and tblVendorTrunk.Status = 1 
					and tblVendorTrunk.TrunkID = p_TrunkID 
				LEFT OUTER JOIN tblVendorBlocking
					ON tblVendorRate.AccountId = tblVendorBlocking.AccountId
						AND tblVendorTrunk.TrunkID = tblVendorBlocking.TrunkID
						AND tblRate.RateID = tblVendorBlocking.RateId											
			WHERE tblVendorBlocking.VendorBlockingId IS NULL
			ORDER BY tblAccount.AccountName;
			
			SELECT FOUND_ROWS() as totalcount ;
			
	END IF;

	if p_isCountry = 0 AND p_action = 1	

	Then
		select SQL_CALC_FOUND_ROWS DISTINCT tblVendorBlocking.AccountId, tblAccount.AccountName
			from tblVendorBlocking
			inner join tblAccount on tblVendorBlocking.AccountId = tblAccount.AccountID
								and tblAccount.Status = 1
								and tblAccount.CompanyID = p_companyid 
								AND tblAccount.IsVendor = 1 
								and tblAccount.AccountType = 1
			inner join tblRate on tblVendorBlocking.RateId  = tblRate.RateId  
				and tblVendorBlocking.TrunkID = p_TrunkID
			Inner join tmp_codes_ c on c.Code = tblRate.Code	
			inner join tblVendorTrunk on tblVendorTrunk.CompanyID = p_companyid 
				and tblVendorTrunk.AccountID = tblVendorBlocking.AccountID 
				and tblVendorTrunk.Status = 1 
				and tblVendorTrunk.TrunkID = p_TrunkID 
			inner join tblVendorRate on tblVendorRate.RateId = tblRate.RateId 
				and tblVendorRate.AccountID = tblVendorBlocking.AccountID 								
				and tblVendorRate.TrunkID = p_TrunkID 
		ORDER BY tblAccount.AccountName;
		
		SELECT FOUND_ROWS() as totalcount;
		
	END IF;

	
	
	if p_isCountry = 1 AND p_action = 0 
	Then
	
		SELECT SQL_CALC_FOUND_ROWS DISTINCT  tblVendorRate.AccountId , tblAccount.AccountName
			from tblVendorRate
			inner join tblAccount on tblVendorRate.AccountId = tblAccount.AccountID
					and tblAccount.Status = 1
					and tblAccount.CompanyID = p_companyid 
					AND tblAccount.IsVendor = 1 
					and tblAccount.AccountType = 1 										
			inner join tblRate on tblVendorRate.RateId  = tblRate.RateId  
				and  (
						(p_isAllCountry = 1 and p_isCountry = 1 and  tblRate.CountryID in  (SELECT CountryID FROM tblCountry) )
						OR
						(FIND_IN_SET(tblRate.CountryID,p_CountryIDs) != 0 )
						
					)
				
				and tblVendorRate.TrunkID = p_TrunkID
			inner join tblVendorTrunk on tblVendorTrunk.CompanyID = p_companyid
				and tblVendorTrunk.AccountID =	tblVendorRate.AccountID 
				and tblVendorTrunk.Status = 1 
				and tblVendorTrunk.TrunkID = p_TrunkID 
			LEFT OUTER JOIN tblVendorBlocking
				ON tblVendorRate.AccountId = tblVendorBlocking.AccountId
					AND tblVendorTrunk.TrunkID = tblVendorBlocking.TrunkID
					AND tblRate.CountryId = tblVendorBlocking.CountryId												
		WHERE tblVendorBlocking.VendorBlockingId IS NULL
			ORDER BY tblAccount.AccountName;											
			
			SELECT FOUND_ROWS() as totalcount;
										
	END IF;

	if p_isCountry = 1 AND p_action = 1  

	Then
		select SQL_CALC_FOUND_ROWS DISTINCT tblVendorBlocking.AccountId , tblAccount.AccountName
			from tblVendorBlocking
				inner join tblAccount on tblVendorBlocking.AccountId = tblAccount.AccountID
								and tblAccount.Status = 1
								and tblAccount.CompanyID = p_companyid 
								AND tblAccount.IsVendor = 1 
								and tblAccount.AccountType = 1
			inner join tblRate on tblVendorBlocking.CountryId  = tblRate.CountryId  
				and  (
						(p_isAllCountry = 1 and p_isCountry = 1 and tblRate.CountryID in(SELECT CountryID FROM tblCountry) )
						OR
						( FIND_IN_SET(tblRate.CountryID,p_CountryIDs) != 0 )
						
					) 
 				and tblVendorBlocking.TrunkID = p_TrunkID
			inner join tblVendorTrunk on tblVendorTrunk.CompanyID = p_companyid 
				and tblVendorTrunk.AccountID = tblVendorBlocking.AccountID 
				and tblVendorTrunk.Status = 1 
				and tblVendorTrunk.TrunkID = p_TrunkID 
			inner join tblVendorRate on tblVendorRate.RateId = tblRate.RateId 
				and tblVendorRate.AccountID = tblVendorBlocking.AccountID 								
				and tblVendorRate.TrunkID = p_TrunkID 
			ORDER BY tblAccount.AccountName;
			
		SELECT FOUND_ROWS() as totalcount;
			
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetCodeDeck` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetCodeDeck`(IN `p_companyid` int, IN `p_codedeckid` int, IN `p_contryid` int, IN `p_code` varchar(50), IN `p_description` varchar(50), IN `p_PageNumber` int, IN `p_RowspPage` int, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` int )
BEGIN

   DECLARE v_OffSet_ int;
   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	           
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
    

    IF p_isExport = 0
    THEN


        SELECT
            RateID,
            tblCountry.ISO2,
            tblCountry.Country,
            Code,
            Description,
            Interval1,
            IntervalN
        FROM tblRate
        LEFT JOIN tblCountry
            ON tblCountry.CountryID = tblRate.CountryID
        WHERE   (p_contryid = 0 OR tblCountry.CountryID = p_contryid)
            AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
            AND (p_description IS NULL OR Description LIKE REPLACE(p_description, '*', '%'))
            AND (CompanyID = p_companyid AND CodeDeckId = p_codedeckid)
        ORDER BY
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeDESC') THEN Code
            END DESC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeASC') THEN Code
            END ASC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryDESC') THEN Country
            END DESC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryASC') THEN Country
            END ASC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN Description
            END DESC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN Description
            END ASC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ISO2DESC') THEN ISO2
            END DESC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ISO2ASC') THEN ISO2
            END ASC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1DESC') THEN Interval1
            END DESC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1ASC') THEN Interval1
            END ASC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNDESC') THEN IntervalN
            END DESC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNASC') THEN IntervalN
            END ASC
        LIMIT p_RowspPage OFFSET v_OffSet_;

        SELECT
            COUNT(RateID) AS totalcount
        FROM tblRate
        LEFT JOIN tblCountry
            ON tblCountry.CountryID = tblRate.CountryID
        WHERE   (p_contryid = 0 OR tblCountry.CountryID = p_contryid)
            AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
            AND (p_description IS NULL OR Description LIKE REPLACE(p_description, '*', '%'))
            AND (CompanyID = p_companyid AND CodeDeckId = p_codedeckid);

    END IF;

    IF p_isExport = 1
    THEN

        SELECT            
            tblCountry.Country,
            Code,
            tblCountry.ISO2 as 'ISO Code',
            Description,
            Interval1,
            IntervalN
        FROM tblRate
        LEFT JOIN tblCountry
            ON tblCountry.CountryID = tblRate.CountryID
        WHERE   (p_contryid  = 0 OR tblCountry.CountryID = p_contryid)
            AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
            AND (p_description IS NULL OR Description LIKE REPLACE(p_description, '*', '%'))
            AND (CompanyID = p_companyid AND CodeDeckId = p_codedeckid);

    END IF;
    IF p_isExport = 2
    THEN

        SELECT
	        RateID,
	         tblCountry.ISO2,
            tblCountry.Country,
            Code,
            Description,
            Interval1,
            IntervalN            
        FROM tblRate
        LEFT JOIN tblCountry
            ON tblCountry.CountryID = tblRate.CountryID
        WHERE   (p_contryid  = 0 OR tblCountry.CountryID = p_contryid)
            AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
            AND (p_description IS NULL OR Description LIKE REPLACE(p_description, '*', '%'))
            AND (CompanyID = p_companyid AND CodeDeckId = p_codedeckid);

    END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getContactTimeLine` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getContactTimeLine`(
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
	

	IF p_TicketType=2 
	THEN
	INSERT INTO tmp_actvity_timeline_
	select 4 as Timeline_type, '' as Emailfrom ,'' as EmailTo,'' as EmailToName,'' as EmailSubject,'' as Message,''as EmailCc,''as EmailBcc,''as EmailAttachments,0 as AccountEmailLogID, 0 as NoteID,'' as Note,
	TAT.TicketID,	TAT.Subject as 	TicketSubject,	TAT.Status as	TicketStatus,	TAT.RequestEmail as 	RequestEmail,	TAT.Priority as 	TicketPriority,	TAT.`Type` as 	TicketType,	TAT.`Group` as 	TicketGroup,	TAT.`Description` as TicketDescription,created_by,ApiCreatedDate as created_at,ApiUpdateDate as updated_at from `tblHelpDeskTickets` TAT where (TAT.`CompanyID` = p_CompanyID and TAT.`ContactID` = p_ContactID and TAT.GUID = p_GUID);
	END IF;

	IF p_TicketType=1 
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetCRMBoard` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetCRMBoard`(IN `p_CompanyID` INT, IN `p_Status` INT, IN `p_BoardName` VARCHAR(30), IN `p_BoardType` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(30), IN `p_SortOrder` VARCHAR(10), IN `p_isExport` INT)
BEGIN

DECLARE v_OffSet_ int;

   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
 
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	IF p_isExport = 0
	THEN
		SELECT BoardName, `Status`, CreatedBy, BoardID 
		FROM tblCRMBoards op 
		WHERE (op.CompanyID = p_CompanyID) 
			AND (op.BoardType = p_BoardType)
			AND ( p_Status = 2 OR op.`Status` = p_Status) 
			AND (p_BoardName = '' OR op.BoardName like Concat('%',p_BoardName,'%'))
			ORDER BY
				CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'BoardNameASC') THEN op.BoardName
            END ASC,
				CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'BoardNameDESC') THEN op.BoardName
            END DESC,
				CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN op.`Status`
            END ASC,
				CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN op.`Status`
            END DESC,
				CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByASC') THEN op.CreatedBy
            END ASC,
				CASE
               WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByDESC') THEN op.CreatedBy
            END DESC
				                     
		LIMIT p_RowspPage OFFSET v_OffSet_;
				
		SELECT COUNT(*) AS totalcount
		FROM tblCRMBoards op 
		WHERE (op.CompanyID = p_CompanyID) 
			AND (op.BoardType = p_BoardType)
			AND ( p_Status = 2 OR op.`Status` = p_Status)
			AND (p_BoardName ='' OR `BoardName` like Concat('%',p_BoardName,'%'));
	END IF;
	
	IF p_isExport = 1
	THEN
	SELECT BoardName, Status, CreatedBy, BoardID 
		FROM tblCRMBoards op 
		WHERE (op.CompanyID = p_CompanyID)
			AND (op.BoardType=p_BoardType) 
			AND ( p_Status = 2 OR op.`Status` = p_Status)
			AND (p_BoardName ='' OR `BoardName` like Concat('%',p_BoardName,'%'));
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetCRMBoardColumns` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetCRMBoardColumns`(IN `p_CompanyID` INT, IN `p_BoardID` INT)
BEGIN
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT `BoardColumnName`, `Order`,`Height`,`Width`,`SetCompleted`,`BoardColumnID`
FROM `tblCRMBoardColumn` 
WHERE (`CompanyID` = p_CompanyID 
	AND `BoardID` = p_BoardID) 
ORDER BY `Order` ASC;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetCrmDashboardForecast` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetCrmDashboardForecast`(IN `p_CompanyID` INT, IN `p_OwnerID` VARCHAR(500), IN `p_Status` INT, IN `p_CurrencyID` INT, IN `p_Start` DATE, IN `p_End` DATE)
BEGIN
	DECLARE v_CurrencyCode_ VARCHAR(50);
	DECLARE v_Round_ int;
	
	SELECT cr.Symbol INTO v_CurrencyCode_ from tblCurrency cr where cr.CurrencyId =p_CurrencyID;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
		
	 DROP TEMPORARY TABLE IF EXISTS tmp_Dashboard_Oppertunites_Forecast_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Dashboard_Oppertunites_Forecast_(
		   `Status` int,
		   `Worth` decimal(18,8),
			`Year` int,
			`Month` int,
		
			`AssignedUserText` varchar(100),
			`Opportunitescount`	int
	);
	  
		insert into tmp_Dashboard_Oppertunites_Forecast_
		SELECT 		
			   MAX(o.`Status`),
			   SUM(o.Worth),
			   YEAR(IFNULL(o.ExpectedClosing,now())) as Year,
			   MONTH(IFNULL(o.ExpectedClosing,now())) as Month,
				
			   CONCAT(tu.FirstName,' ',tu.LastName) as AssignedUserText,
			   COUNT(*) as Opportunitescount
		FROM tblOpportunity o
		INNER JOIN tblAccount ac on ac.AccountID = o.AccountID
					AND ac.`Status` = 1
		INNER join tblUser tu on o.UserID = tu.UserID
						AND tu.`Status` = 1						
		WHERE
					 o.CompanyID = p_CompanyID
					AND o.OpportunityClosed=0
					AND (p_OwnerID = '' OR find_in_set(o.`UserID`,p_OwnerID))
					AND (p_Status = '' OR o.`Status` = p_Status)		
					AND (IFNULL(o.ExpectedClosing,now()) between p_Start and p_End)
					AND (p_CurrencyID = '' OR ( p_CurrencyID != ''  and ac.CurrencyId = p_CurrencyID))
		GROUP BY 
					YEAR(IFNULL(o.ExpectedClosing,now()))
					,MONTH(IFNULL(o.ExpectedClosing,now()))			
					,CONCAT(tu.FirstName,' ',tu.LastName);
			
		SELECT	ROUND(td.Worth,v_Round_) as TotalWorth,
				v_CurrencyCode_ as CurrencyCode,			
				CONCAT(CONCAT(case when td.Month <10 then concat('0',td.Month) else td.Month End, '/'), td.Year) AS MonthName ,
				td.`Status` as `Status`,
				td.AssignedUserText,
				v_Round_ as round_number,
				Opportunitescount	
	    FROM tmp_Dashboard_Oppertunites_Forecast_ td;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetCrmDashboardPipeLine` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetCrmDashboardPipeLine`(IN `p_CompanyID` INT, IN `p_OwnerID` VARCHAR(500), IN `p_CurrencyID` INT)
BEGIN
	DECLARE v_CurrencyCode_ VARCHAR(50);
	DECLARE v_Round_ int;
	
	SELECT cr.Symbol INTO v_CurrencyCode_ from tblCurrency cr where cr.CurrencyId =p_CurrencyID;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
		
 DROP TEMPORARY TABLE IF EXISTS tmp_Dashboard_Oppertunites_;
CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Dashboard_Oppertunites_(
 	   Worth decimal(18,8),
	   AssignedUserText varchar(100)
		
);  

insert into tmp_Dashboard_Oppertunites_
SELECT 		
 	   o.Worth,
	   concat(tu.FirstName,' ',tu.LastName) as AssignedUserText
FROM tblOpportunity o
Inner JOIN tblAccount ac on ac.AccountID = o.AccountID
inner join tblUser tu on o.UserID = tu.UserID
where
			ac.`Status` = 1
			AND (p_CurrencyID = '' OR ( p_CurrencyID !=''  and ac.CurrencyId = p_CurrencyID))
		   AND o.CompanyID = p_CompanyID
		   AND o.OpportunityClosed =0
		   and o.`Status` = 1
			AND (p_OwnerID = '' OR find_in_set(o.`UserID`,p_OwnerID));

 SELECT			           
			ROUND(sum(Worth),v_Round_) as TotalWorth,
			v_CurrencyCode_,
			v_Round_ as RoundVal,
			AssignedUserText,			
			count(*) as TotalOpportunites	
         FROM tmp_Dashboard_Oppertunites_ 
         group by `AssignedUserText` asc;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetCrmDashboardSales` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetCrmDashboardSales`(IN `p_CompanyID` INT, IN `p_OwnerID` VARCHAR(500), IN `p_Status` VARCHAR(50), IN `p_CurrencyID` INT, IN `p_Start` DATE, IN `p_End` DATE)
BEGIN
	DECLARE v_CurrencyCode_ VARCHAR(50);
	DECLARE v_Round_ int;
	
	SELECT cr.Symbol INTO v_CurrencyCode_ from tblCurrency cr where cr.CurrencyId =p_CurrencyID;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
		
	 DROP TEMPORARY TABLE IF EXISTS tmp_Dashboard_Oppertunites_Sales_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Dashboard_Oppertunites_Sales_(
		   `Status` int,
		   `Worth` decimal(18,8),
			`Year` int,
			`Month` int,		
			`AssignedUserText` varchar(100),
			`Opportunitescount`	int
	);
	  
			insert into tmp_Dashboard_Oppertunites_Sales_
	SELECT 		
			MAX(o.`Status`),
			SUM(o.Worth), 	   
			YEAR(o.ClosingDate) as Year,
			MONTH(o.ClosingDate) as Month,			   
			concat(tu.FirstName,' ',tu.LastName) as AssignedUserText,
			count(*) as Opportunitescount
	FROM tblOpportunity o
	INNER JOIN tblAccount ac on ac.AccountID = o.AccountID
			AND ac.`Status` = 1
	INNER join tblUser tu on o.UserID = tu.UserID
			and tu.`Status` = 1 					 
	WHERE
				o.CompanyID = p_CompanyID
			
				AND (p_OwnerID = '' OR find_in_set(o.`UserID`,p_OwnerID))
				AND (p_Status = '' OR find_in_set(o.`Status`,p_Status))
				AND (ClosingDate between p_Start and p_End)
				AND (p_CurrencyID = '' OR ( p_CurrencyID != ''  and ac.CurrencyId = p_CurrencyID))	
	GROUP BY 
			YEAR(o.ClosingDate) 
			,MONTH(o.ClosingDate)
			,CONCAT(tu.FirstName,' ',tu.LastName);
			
	 SELECT	ROUND(td.Worth,v_Round_) as TotalWorth,
				v_CurrencyCode_,
				CONCAT(CONCAT(case when td.Month <10 then concat('0',td.Month) else td.Month End, '/'), td.Year) AS MonthName ,
				td.`Status` as `Status`,
				td.AssignedUserText,
				v_Round_	 as round_number,
				Opportunitescount		
	 FROM tmp_Dashboard_Oppertunites_Sales_  td;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetCrmDashboardSalesManager` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetCrmDashboardSalesManager`(
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
	FROM wavetelwholesaleBilling.tblInvoice inv
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetCrmDashboardSalesUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetCrmDashboardSalesUser`(
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
	FROM wavetelwholesaleBilling.tblInvoice inv
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetCronJob` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetCronJob`(IN `p_companyid` INT, IN `p_Status` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

   DECLARE v_OffSet_ int;
   SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
          
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

    IF p_isExport = 0
    THEN
          
            SELECT
				tblCronJob.JobTitle,
                tblCronJobCommand.Title,
                tblCronJob.Status,
                tblCronJob.CronJobID,
                tblCronJob.CronJobCommandID,
                tblCronJob.Settings
            FROM tblCronJob
            INNER JOIN tblCronJobCommand
                ON tblCronJobCommand.CronJobCommandID = tblCronJob.CronJobCommandID
            WHERE tblCronJob.CompanyID = p_companyid
            AND (p_Status =2 OR tblCronJob.`Status`=p_Status)
            ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleDESC') THEN tblCronJobCommand.Title
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleASC') THEN tblCronJobCommand.Title
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN tblCronJob.Status
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN tblCronJob.Status
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'JobTitleDESC') THEN tblCronJob.JobTitle
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'JobTitleASC') THEN tblCronJob.JobTitle
                END ASC
            LIMIT p_RowspPage OFFSET v_OffSet_;

        SELECT
            COUNT(tblCronJob.CronJobID) as totalcount
        FROM tblCronJob
            INNER JOIN tblCronJobCommand
                ON tblCronJobCommand.CronJobCommandID = tblCronJob.CronJobCommandID
            WHERE tblCronJob.CompanyID = p_companyid
            AND (p_Status =2 OR tblCronJob.`Status`=p_Status);
    END IF;

    IF p_isExport = 1
    THEN
        SELECT
			tblCronJob.JobTitle,
            tblCronJobCommand.Title,
            tblCronJob.Status
        FROM tblCronJob
        INNER JOIN tblCronJobCommand
            ON tblCronJobCommand.CronJobCommandID = tblCronJob.CronJobCommandID
        WHERE tblCronJob.CompanyID = p_companyid
		  AND (p_Status =2 OR tblCronJob.`Status`=p_Status);
    END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetCronJobHistory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetCronJobHistory`(
	IN `p_CronJobID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_SearchText` VARCHAR(50),
	IN `p_Status` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT


)
BEGIN

   DECLARE v_OffSet_ int;
   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
   
       
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
    IF p_isExport = 0
    THEN
            SELECT
                tblCronJobCommand.Title,
                tblCronJobLog.CronJobStatus,
                tblCronJobLog.Message,
                tblCronJobLog.created_at
            FROM tblCronJob
            INNER JOIN tblCronJobLog 
                ON tblCronJob.CronJobID = tblCronJobLog.CronJobID
                AND tblCronJobLog.CronJobID = p_CronJobID
                AND (p_Status = '' OR tblCronJobLog.CronJobStatus = p_Status)
                AND tblCronJobLog.created_at between p_StartDate and p_EndDate
                AND (p_SearchText='' OR tblCronJobLog.Message like Concat('%',p_SearchText,'%'))
            INNER JOIN tblCronJobCommand
                ON tblCronJobCommand.CronJobCommandID = tblCronJob.CronJobCommandID
            ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleDESC') THEN tblCronJobCommand.Title
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleASC') THEN tblCronJobCommand.Title
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CronJobStatusDESC') THEN tblCronJobLog.CronJobStatus
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CronJobStatusASC') THEN tblCronJobLog.CronJobStatus
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MessageDESC') THEN tblCronJobLog.Message
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MessageASC') THEN tblCronJobLog.Message
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN tblCronJobLog.created_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN tblCronJobLog.created_at
                END ASC
           LIMIT p_RowspPage OFFSET v_OffSet_;

        SELECT
            COUNT(tblCronJobLog.CronJobID) as totalcount
        FROM tblCronJob
            INNER JOIN tblCronJobLog 
                ON tblCronJob.CronJobID = tblCronJobLog.CronJobID
                AND tblCronJobLog.CronJobID = p_CronJobID
                AND (p_Status = '' OR tblCronJobLog.CronJobStatus = p_Status)
                AND tblCronJobLog.created_at between p_StartDate and p_EndDate
                AND (p_SearchText='' OR tblCronJobLog.Message like Concat('%',p_SearchText,'%'))
            INNER JOIN tblCronJobCommand
                ON tblCronJobCommand.CronJobCommandID = tblCronJob.CronJobCommandID;
    END IF;

    IF p_isExport = 1
    THEN
        SELECT
            tblCronJobCommand.Title,
            tblCronJobLog.CronJobStatus,
            tblCronJobLog.Message,
            tblCronJobLog.created_at
        FROM tblCronJob
        INNER JOIN tblCronJobLog 
                ON tblCronJob.CronJobID = tblCronJobLog.CronJobID
                AND tblCronJobLog.CronJobID = p_CronJobID
                AND (p_Status = '' OR tblCronJobLog.CronJobStatus = p_Status)
                AND tblCronJobLog.created_at between p_StartDate and p_EndDate
                AND (p_SearchText='' OR tblCronJobLog.Message like Concat('%',p_SearchText,'%'))
        INNER JOIN tblCronjobCommand
            ON tblCronJobCommand.CronJobCommandID = tblCronJob.CronJobCommandID;
    END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetCronJobSetting` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetCronJobSetting`(IN `p_CronJobID` INT)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	select Settings from tblCronJob where CronJobID=p_CronJobID;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getCustomerCodeRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getCustomerCodeRate`(
	IN `p_AccountID` INT,
	IN `p_trunkID` INT,
	IN `p_RateCDR` INT,
	IN `p_RateMethod` VARCHAR(50),
	IN `p_SpecifyRate` DECIMAL(18,6)
)
BEGIN
	DECLARE v_codedeckid_ INT;
	DECLARE v_ratetableid_ INT;

	SELECT
		CodeDeckId,
		RateTableID
		INTO v_codedeckid_, v_ratetableid_
	FROM tblCustomerTrunk
	WHERE tblCustomerTrunk.TrunkID = p_trunkID
	AND tblCustomerTrunk.AccountID = p_AccountID
	AND tblCustomerTrunk.Status = 1;

	IF p_RateCDR = 0
	THEN 

		DROP TEMPORARY TABLE IF EXISTS tmp_codes_;
		CREATE TEMPORARY TABLE tmp_codes_ (
			RateID INT,
			Code VARCHAR(50),
			INDEX tmp_codes_RateID (`RateID`),
			INDEX tmp_codes_Code (`Code`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_codes2_;
		CREATE TEMPORARY TABLE tmp_codes2_ (
			RateID INT,
			Code VARCHAR(50),
			INDEX tmp_codes2_RateID (`RateID`),
			INDEX tmp_codes2_Code (`Code`)
		);
	
		INSERT INTO tmp_codes_
		SELECT
		DISTINCT
			tblRate.RateID,
			tblRate.Code
		FROM tblRate
		INNER JOIN tblCustomerRate
		ON tblCustomerRate.RateID = tblRate.RateID
		WHERE 
			 tblRate.CodeDeckId = v_codedeckid_
		AND CustomerID = p_AccountID
		AND tblCustomerRate.TrunkID = p_trunkID
		AND tblCustomerRate.EffectiveDate <= NOW();
	
		INSERT INTO tmp_codes2_ 
		SELECT * FROM tmp_codes_;
		
		INSERT INTO tmp_codes_
		SELECT
			DISTINCT
			tblRate.RateID,
			tblRate.Code
		FROM tblRate
		INNER JOIN tblRateTableRate
			ON tblRateTableRate.RateID = tblRate.RateID
		LEFT JOIN  tmp_codes2_ c ON c.RateID = tblRate.RateID
		WHERE 
			 tblRate.CodeDeckId = v_codedeckid_
		AND RateTableID = v_ratetableid_
		AND c.RateID IS NULL
		AND tblRateTableRate.EffectiveDate <= NOW();

	END IF;
	
	IF p_RateCDR = 1
	THEN 

		DROP TEMPORARY TABLE IF EXISTS tmp_codes_;
		CREATE TEMPORARY TABLE tmp_codes_ (
			RateID INT,
			Code VARCHAR(50),
			Rate Decimal(18,6),
			ConnectionFee Decimal(18,6),
			Interval1 INT,
			IntervalN INT,
			INDEX tmp_codes_RateID (`RateID`),
			INDEX tmp_codes_Code (`Code`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_codes2_;
		CREATE TEMPORARY TABLE tmp_codes2_ (
			RateID INT,
			Code VARCHAR(50),
			Rate Decimal(18,6),
			ConnectionFee Decimal(18,6),
			Interval1 INT,
			IntervalN INT,
			INDEX tmp_codes2_RateID (`RateID`),
			INDEX tmp_codes2_Code (`Code`)
		);
	
		INSERT INTO tmp_codes_
		SELECT
		DISTINCT
			tblRate.RateID,
			tblRate.Code,
			tblCustomerRate.Rate,
			tblCustomerRate.ConnectionFee,
			tblCustomerRate.Interval1,
			tblCustomerRate.IntervalN
		FROM tblRate
		INNER JOIN tblCustomerRate
		ON tblCustomerRate.RateID = tblRate.RateID
		WHERE 
			 tblRate.CodeDeckId = v_codedeckid_
		AND CustomerID = p_AccountID
		AND tblCustomerRate.TrunkID = p_trunkID
		AND tblCustomerRate.EffectiveDate <= NOW();
	
		INSERT INTO tmp_codes2_ 
		SELECT * FROM tmp_codes_;
		
		INSERT INTO tmp_codes_
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
		LEFT JOIN  tmp_codes2_ c ON c.RateID = tblRate.RateID
		WHERE 
			 tblRate.CodeDeckId = v_codedeckid_
		AND RateTableID = v_ratetableid_
		AND c.RateID IS NULL
		AND tblRateTableRate.EffectiveDate <= NOW();
		
		
		
		IF p_RateMethod = 'SpecifyRate'
		THEN
		
			UPDATE tmp_codes_ SET Rate=p_SpecifyRate;
			
		END IF;

	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getCustomerInboundRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getCustomerInboundRate`(
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

		
		IF p_RateMethod = 'SpecifyRate'
		THEN

			UPDATE tmp_inboundcodes_ SET Rate=p_SpecifyRate;

		END IF;

	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetCustomerRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetCustomerRate`(IN `p_companyid` INT, IN `p_AccountID` INT, IN `p_trunkID` INT, IN `p_contryID` INT, IN `p_code` VARCHAR(50), IN `p_description` VARCHAR(50), IN `p_Effective` VARCHAR(50), IN `p_effectedRates` INT, IN `p_RoutinePlan` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT )
BEGIN
   DECLARE v_codedeckid_ INT;
   DECLARE v_ratetableid_ INT;
   DECLARE v_RateTableAssignDate_ DATETIME;
   DECLARE v_NewA2ZAssign_ INT;
   DECLARE v_OffSet_ int;
   DECLARE v_IncludePrefix_ INT;
   DECLARE v_Prefix_ VARCHAR(50);
   DECLARE v_RatePrefix_ VARCHAR(50);
   DECLARE v_AreaPrefix_ VARCHAR(50);
   
   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
   SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

    SELECT
        CodeDeckId,
        RateTableID,
        RateTableAssignDate,IncludePrefix INTO v_codedeckid_, v_ratetableid_, v_RateTableAssignDate_,v_IncludePrefix_
    FROM tblCustomerTrunk
    WHERE CompanyID = p_companyid
    AND tblCustomerTrunk.TrunkID = p_trunkID
    AND tblCustomerTrunk.AccountID = p_AccountID
    AND tblCustomerTrunk.Status = 1;
    
    SELECT
        Prefix,RatePrefix,AreaPrefix INTO v_Prefix_,v_RatePrefix_,v_AreaPrefix_
    FROM tblTrunk
    WHERE CompanyID = p_companyid
    AND tblTrunk.TrunkID = p_trunkID
    AND tblTrunk.Status = 1;
    
    

    DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates_;
    CREATE TEMPORARY TABLE tmp_CustomerRates_ (
        RateID INT,
        Interval1 INT,
        IntervalN  INT,
        Rate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        EffectiveDate DATE,
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        CustomerRateId INT,
        RateTableRateID INT,
        TrunkID INT,
        RoutinePlan INT,
        INDEX tmp_CustomerRates__RateID (`RateID`),
        INDEX tmp_CustomerRates__TrunkID (`TrunkID`),
        INDEX tmp_CustomerRates__EffectiveDate (`EffectiveDate`)
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate_;
    CREATE TEMPORARY TABLE tmp_RateTableRate_ (
        RateID INT,
        Interval1 INT,
        IntervalN INT,
        Rate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        EffectiveDate DATE,
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        CustomerRateId INT,
        RateTableRateID INT,
        TrunkID INT,
        INDEX tmp_RateTableRate__RateID (`RateID`),
        INDEX tmp_RateTableRate__TrunkID (`TrunkID`),
        INDEX tmp_RateTableRate__EffectiveDate (`EffectiveDate`)

    );
    
    DROP TEMPORARY TABLE IF EXISTS tmp_customerrate_;
    CREATE TEMPORARY TABLE tmp_customerrate_ (
        RateID INT,
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18, 6),
        RoutinePlanName VARCHAR(50),
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        CustomerRateId INT,
        TrunkID INT,
        RateTableRateId INT,
        IncludePrefix TINYINT,
        Prefix VARCHAR(50),
        RatePrefix VARCHAR(50),
        AreaPrefix VARCHAR(50)
    );
     

    INSERT INTO tmp_CustomerRates_

            SELECT
                tblCustomerRate.RateID,
                tblCustomerRate.Interval1,
                tblCustomerRate.IntervalN,
                
                tblCustomerRate.Rate,
                tblCustomerRate.ConnectionFee,
                tblCustomerRate.EffectiveDate,
                tblCustomerRate.LastModifiedDate,
                tblCustomerRate.LastModifiedBy,
                tblCustomerRate.CustomerRateId,
                NULL AS RateTableRateID,
                p_trunkID as TrunkID,
                tblCustomerRate.RoutinePlan
                     
            FROM tblCustomerRate
            INNER JOIN tblRate
                ON tblCustomerRate.RateID = tblRate.RateID
            WHERE (p_contryID IS NULL OR tblRate.CountryID = p_contryID)
            AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
            AND (p_description IS NULL OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
            AND (tblRate.CompanyID = p_companyid)
            AND tblRate.CodeDeckId = v_codedeckid_
            AND tblCustomerRate.TrunkID = p_trunkID
            AND (p_RoutinePlan = 0 or tblCustomerRate.RoutinePlan = p_RoutinePlan)
            AND CustomerID = p_AccountID
             
            ORDER BY
                tblCustomerRate.TrunkId, tblCustomerRate.CustomerId,tblCustomerRate.RateID,tblCustomerRate.EffectiveDate DESC;
         
    	
		 
		
                
            
    	
	 	DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates4_;
			CREATE TEMPORARY TABLE IF NOT EXISTS tmp_CustomerRates4_ as (select * from tmp_CustomerRates_);	        
			DELETE n1 FROM tmp_CustomerRates_ n1, tmp_CustomerRates4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate 
			AND n1.TrunkID = n2.TrunkID
			AND  n1.RateID = n2.RateID
			AND  n1.EffectiveDate <= NOW()
			AND  n2.EffectiveDate <= NOW();
	 	
	 	DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates2_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_CustomerRates2_ as (select * from tmp_CustomerRates_);
		DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates3_;
	   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_CustomerRates3_ as (select * from tmp_CustomerRates_);
	   DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates5_;
	   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_CustomerRates5_ as (select * from tmp_CustomerRates_);

    INSERT INTO tmp_RateTableRate_
            SELECT
                tblRateTableRate.RateID,
                tblRateTableRate.Interval1,
                tblRateTableRate.IntervalN,
                tblRateTableRate.Rate,
                tblRateTableRate.ConnectionFee,
            	 
      			 tblRateTableRate.EffectiveDate,
                NULL AS LastModifiedDate,
                NULL AS LastModifiedBy,
                NULL AS CustomerRateId,
                tblRateTableRate.RateTableRateID,
                p_trunkID as TrunkID
            FROM tblRateTableRate
            INNER JOIN tblRate
                ON tblRateTableRate.RateID = tblRate.RateID
            WHERE (p_contryID IS NULL OR tblRate.CountryID = p_contryID)
            AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
            AND (p_description IS NULL OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
            AND (tblRate.CompanyID = p_companyid)
            AND tblRate.CodeDeckId = v_codedeckid_
            AND RateTableID = v_ratetableid_
            AND (
						(
							(SELECT count(*) from tmp_CustomerRates2_ cr where cr.RateID = tblRateTableRate.RateID) >0 	
							AND tblRateTableRate.EffectiveDate < 
								( SELECT MIN(cr.EffectiveDate)
                          FROM tmp_CustomerRates_ as cr
                          WHERE cr.RateID = tblRateTableRate.RateID
								)
							AND (SELECT count(*) from tmp_CustomerRates5_ cr where cr.RateID = tblRateTableRate.RateID AND cr.EffectiveDate <= NOW() ) = 0  
						)
						or  (  SELECT count(*) from tmp_CustomerRates3_ cr where cr.RateID = tblRateTableRate.RateID ) = 0
					)
            
                ORDER BY tblRateTableRate.RateTableId,tblRateTableRate.RateID,tblRateTableRate.effectivedate DESC;
            
	 
		 	
		  
		  DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate4_;
		  CREATE TEMPORARY TABLE IF NOT EXISTS tmp_RateTableRate4_ as (select * from tmp_RateTableRate_);	        
        DELETE n1 FROM tmp_RateTableRate_ n1, tmp_RateTableRate4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate 
	 	  AND n1.TrunkID = n2.TrunkID
		  AND  n1.RateID = n2.RateID
		  AND  n1.EffectiveDate <= NOW()
		  AND  n2.EffectiveDate <= NOW();
		 

		
	   
	   
		  INSERT INTO tmp_customerrate_
        SELECT
        			 r.RateID,
                r.Code,
                r.Description,
                CASE WHEN allRates.Interval1 IS NULL
                THEN 
                    r.Interval1
                ELSE
                    allRates.Interval1
                END as Interval1,
                CASE WHEN allRates.IntervalN IS NULL
                THEN 
                    r.IntervalN
                ELSE
                    allRates.IntervalN
                END  IntervalN,
                allRates.ConnectionFee,
                allRates.RoutinePlanName,
                allRates.Rate,
                allRates.EffectiveDate,
                allRates.LastModifiedDate,
                allRates.LastModifiedBy,
                allRates.CustomerRateId,
                p_trunkID as TrunkID,
                allRates.RateTableRateId,
					v_IncludePrefix_ as IncludePrefix ,
   	         CASE  WHEN tblTrunk.TrunkID is not null
               THEN
               	tblTrunk.Prefix
               ELSE
               	v_Prefix_
					END AS Prefix,
					CASE  WHEN tblTrunk.TrunkID is not null
               THEN
               	tblTrunk.RatePrefix
               ELSE
               	v_RatePrefix_
					END AS RatePrefix,
					CASE  WHEN tblTrunk.TrunkID is not null
               THEN
               	tblTrunk.AreaPrefix
               ELSE
               	v_AreaPrefix_
					END AS AreaPrefix
        FROM tblRate r
        LEFT JOIN (SELECT
                CustomerRates.RateID,
                CustomerRates.Interval1,
                CustomerRates.IntervalN,
                tblTrunk.Trunk as RoutinePlanName,
                CustomerRates.ConnectionFee,
                CustomerRates.Rate,
                CustomerRates.EffectiveDate,
                CustomerRates.LastModifiedDate,
                CustomerRates.LastModifiedBy,
                CustomerRates.CustomerRateId,
                NULL AS RateTableRateID,
                p_trunkID as TrunkID,
                RoutinePlan
            FROM tmp_CustomerRates_ CustomerRates
            LEFT JOIN tblTrunk on tblTrunk.TrunkID = CustomerRates.RoutinePlan
            WHERE 
                (
					 	( p_Effective = 'Now' AND CustomerRates.EffectiveDate <= NOW() )
					 	OR
					 	( p_Effective = 'Future' AND CustomerRates.EffectiveDate > NOW())
					 	OR p_Effective = 'All'
					 )


            UNION ALL

            SELECT
            DISTINCT
                rtr.RateID,
                rtr.Interval1,
                rtr.IntervalN,
                NULL,
                rtr.ConnectionFee,
                rtr.Rate,
                rtr.EffectiveDate,
                NULL,
                NULL,
                NULL AS CustomerRateId,
                rtr.RateTableRateID,
                p_trunkID as TrunkID,
                NULL AS RoutinePlan
            FROM tmp_RateTableRate_ AS rtr
            LEFT JOIN tmp_CustomerRates2_ as cr
                ON cr.RateID = rtr.RateID AND 
						 (
						 	( p_Effective = 'Now' AND cr.EffectiveDate <= NOW() )
						 	OR
						 	( p_Effective = 'Future' AND cr.EffectiveDate > NOW())
						 	OR p_Effective = 'All'
						 )
            WHERE (
                (
                    p_Effective = 'Now' AND rtr.EffectiveDate <= NOW()
                    AND (
                            (cr.RateID IS NULL) 
                            OR
                            (cr.RateID IS NOT NULL AND rtr.RateTableRateID IS NULL) 
                        )

                )
                OR
                ( p_Effective = 'Future' AND rtr.EffectiveDate > NOW()
                    AND (
                            (cr.RateID IS NULL) 
                            OR
                            (
                                cr.RateID IS NOT NULL AND rtr.EffectiveDate < (
                                                                                SELECT IFNULL(MIN(crr.EffectiveDate), rtr.EffectiveDate)
                                                                                FROM tmp_CustomerRates3_ as crr
                                                                                WHERE crr.RateID = rtr.RateID
                                                                                )
                            )
                        )
                )
            OR p_Effective = 'All'

            )
				
				) allRates
            ON allRates.RateID = r.RateID
         LEFT JOIN tblTrunk on tblTrunk.TrunkID = RoutinePlan
        WHERE (p_contryID IS NULL OR r.CountryID = p_contryID)
        AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
        AND (p_description IS NULL OR r.Description LIKE REPLACE(p_description, '*', '%'))
        AND (r.CompanyID = p_companyid)
        AND r.CodeDeckId = v_codedeckid_
        AND  ((p_effectedRates = 1 AND Rate IS NOT NULL) OR  (p_effectedRates = 0));

   
    

    IF p_isExport = 0
    THEN


         SELECT
                RateID,
                Code,
                Description,
                Interval1,
                IntervalN,
                ConnectionFee,
                RoutinePlanName,
                Rate,
                EffectiveDate,
                LastModifiedDate,
                LastModifiedBy,
                CustomerRateId,
                TrunkID,
                RateTableRateId
            FROM tmp_customerrate_ 
            ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeDESC') THEN Code
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeASC') THEN Code
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN Description
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN Description
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateDESC') THEN Rate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateASC') THEN Rate
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1DESC') THEN Interval1
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1ASC') THEN Interval1
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNDESC') THEN IntervalN
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNASC') THEN IntervalN
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeDESC') THEN ConnectionFee
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeASC') THEN ConnectionFee
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateDESC') THEN EffectiveDate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateASC') THEN EffectiveDate
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastModifiedDateDESC') THEN LastModifiedDate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastModifiedDateASC') THEN LastModifiedDate
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastModifiedByDESC') THEN LastModifiedBy
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastModifiedByASC') THEN LastModifiedBy
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CustomerRateIdDESC') THEN CustomerRateId
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CustomerRateIdASC') THEN CustomerRateId
                END ASC
            LIMIT p_RowspPage OFFSET v_OffSet_;

        SELECT
            COUNT(RateID) AS totalcount
        FROM tmp_customerrate_;

    END IF;

    IF p_isExport = 1
    THEN
			 
          select 
            Code,
            Description,
            Interval1,
            IntervalN,
            ConnectionFee,
            Rate,
            EffectiveDate,
            LastModifiedDate,
            LastModifiedBy from tmp_customerrate_;

    END IF;
    
    
	IF p_isExport = 2
    THEN
			 
          select 
            Code,
            Description,
            Interval1,
            IntervalN,
            ConnectionFee,
            Rate,
            EffectiveDate from tmp_customerrate_;

    END IF;
    
 
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetDashboardDataJobs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetDashboardDataJobs`(IN `p_companyId` int , IN `p_userId` int , IN `p_isadmin` int)
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT `tblJob`.`JobID`, `tblJob`.`Title`, `tblJobStatus`.`Title` AS `Status`, `tblJob`.`HasRead`, `tblJob`.`CreatedBy`, `tblJob`.`created_at`
	FROM tblJob INNER JOIN tblJobStatus ON `tblJob`.`JobStatusID` = `tblJobStatus`.`JobStatusID` INNER JOIN tblJobType ON `tblJob`.`JobTypeID` = `tblJobType`.`JobTypeID`
	WHERE `tblJob`.`CompanyID` = p_companyId AND ( p_isadmin = 1 OR (p_isadmin = 0 AND tblJob.JobLoggedUserID = p_userId) )
	ORDER BY `tblJob`.`ShowInCounter` DESC, `tblJob`.`updated_at` DESC,tblJob.JobID DESC
	LIMIT 10;


	
	SELECT count(*) AS totalpending FROM tblJob INNER JOIN tblJobStatus ON `tblJob`.`JobStatusID` = `tblJobStatus`.`JobStatusID`
	WHERE `tblJobStatus`.`Title` = 'Pending' AND `tblJob`.`CompanyID` = p_companyId AND
	( p_isadmin = 1 OR ( p_isadmin = 0 AND tblJob.JobLoggedUserID = p_userId) );
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetDashboardDataRecentDueRateSheet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetDashboardDataRecentDueRateSheet`(IN `p_companyId` int)
BEGIN
 SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
        SELECT count(*) as TotalDueCustomer,DAYSDIFF from (
			SELECT distinct  a.AccountName,a.AccountID,cr.TrunkID,cr.EffectiveDate,TIMESTAMPDIFF(DAY,cr.EffectiveDate, NOW()) as DAYSDIFF
			FROM tblCustomerRate cr
			INNER JOIN tblRate  r on r.RateID =cr.RateID
			INNER JOIN tblCountry c on c.CountryID = r.CountryID
			INNER JOIN tblAccount a on a.AccountID = cr.CustomerID
			WHERE a.CompanyId =@companyId
			AND TIMESTAMPDIFF(DAY, cr.EffectiveDate, DATE_FORMAT (NOW(),120)) BETWEEN -1 AND 1

		) as tbl
		LEFT JOIN tblJob ON tblJob.AccountID = tbl.AccountID
					AND tblJob.JobID IN(select JobID from tblJob where JobTypeID = (select JobTypeID from tblJobType where Code='CD'))
					AND FIND_IN_SET (tbl.TrunkID,JSON_EXTRACT(tblJob.Options, '$.Trunks')) != 0

					AND ( TIMESTAMPDIFF(DAY, tblJob.created_at, NOW()) = DAYSDIFF or TIMESTAMPDIFF(DAY, tblJob.created_at, EffectiveDate)  BETWEEN -1 AND 0)

		where JobStatusID is null or JobStatusID <> (select JobStatusID from tblJobStatus where Code='S')
		group by DAYSDIFF
		order by DAYSDIFF desc;

 
        

        SELECT count(*) as TotalDueVendor ,DAYSDIFF from (
				SELECT  DISTINCT a.AccountName,a.AccountID,vr.TrunkID,vr.EffectiveDate,TIMESTAMPDIFF(DAY,vr.EffectiveDate, NOW()) as DAYSDIFF
			FROM tblVendorRate vr
			INNER JOIN tblRate  r on r.RateID =vr.RateID
			INNER JOIN tblCountry c on c.CountryID = r.CountryID
			INNER JOIN tblAccount a on a.AccountID = vr.AccountId
			WHERE a.CompanyId = @companyId
			AND TIMESTAMPDIFF(DAY,vr.EffectiveDate, NOW()) BETWEEN -1 AND 1
	   ) as tbl
		LEFT JOIN tblJob ON tblJob.AccountID = tbl.AccountID
					AND tblJob.JobID IN(select JobID from tblJob where JobTypeID = (select JobTypeID from tblJobType where Code='VD'))
					AND FIND_IN_SET (tbl.TrunkID,JSON_EXTRACT(tblJob.Options, '$.Trunks')) != 0
					AND ( TIMESTAMPDIFF(DAY, tblJob.created_at, NOW()) = DAYSDIFF or TIMESTAMPDIFF(DAY, tblJob.created_at, EffectiveDate)  BETWEEN -1 AND 0)

		where JobStatusID is null or JobStatusID <> (select JobStatusID from tblJobStatus where Code='S')
		group by DAYSDIFF
		order by DAYSDIFF desc;
		
		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetDashboardProcessedFiles` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetDashboardProcessedFiles`(IN `p_companyId` int , IN `p_userId` int , IN `p_isadmin` int)
BEGIN
    select `tblJob`.`JobID`, `tblJob`.`Title`, `tblJobStatus`.`Title` as Status, `tblJob`.`CreatedBy`, `tblJob`.`created_at` from tblJob inner join tblJobStatus on `tblJob`.`JobStatusID` = `tblJobStatus`.`JobStatusID` inner join tblJobType on `tblJob`.`JobTypeID` = `tblJobType`.`JobTypeID`
        where ( tblJobStatus.Title = 'Success' OR tblJobStatus.Title = 'Completed' ) and `tblJob`.`CompanyID` = p_companyId and
        ( p_isadmin = 1 OR ( p_isadmin = 0 and `tblJob`.`JobLoggedUserID` = p_userId))  and `tblJob`.`updated_at` >= DATE_ADD(NOW(),INTERVAL -7 DAY)
		  LIMIT 10;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetDashboardRecentAccounts` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetDashboardRecentAccounts`(
	IN `p_companyId` int ,
	IN `p_userId` VARCHAR(500),
	IN `p_AccountManager` INT

)
BEGIN
    select  AccountID,AccountName,Phone,Email,created_by,created_at from tblAccount
          where
          `AccountType` = '1' and CompanyID = p_companyId and `Status` = '1'
          AND (  p_AccountManager = 0 OR (p_AccountManager = 1 AND find_in_set(tblAccount.Owner,p_userId)) )
    order by `tblAccount`.`AccountID` desc
	 LIMIT 10;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetDashboardRecentLeads` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetDashboardRecentLeads`(IN `p_companyId` int)
BEGIN
    select AccountID,AccountName,Phone,Email,created_by,created_at from tblAccount where (`AccountType` = '0' and `CompanyID` = p_companyId and `Status` = '1') order by `tblAccount`.`AccountID` desc LIMIT 10;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getDefaultCodes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getDefaultCodes`(IN `p_CompanyID` INT)
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_codes_;
	CREATE TEMPORARY TABLE tmp_codes_ (
		RateID INT,
		Code VARCHAR(50),
		INDEX tmp_codes_RateID (`RateID`),
		INDEX tmp_codes_Code (`Code`)
	);

	INSERT INTO tmp_codes_
	SELECT
	DISTINCT
		tblRate.RateID,
		tblRate.Code
	FROM tblRate
	INNER JOIN tblCodeDeck
		ON tblCodeDeck.CodeDeckId = tblRate.CodeDeckId
	WHERE tblCodeDeck.CompanyId = p_CompanyID
	AND tblCodeDeck.DefaultCodedeck = 1 ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getDestinationCode` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getDestinationCode`(IN `p_DestinationGroupSetID` INT, IN `p_DestinationGroupID` INT, IN `p_CountryID` INT, IN `p_Code` VARCHAR(50), IN `p_Selected` INT, IN `p_Description` VARCHAR(50), IN `p_PageNumber` INT, IN `p_RowspPage` INT)
BEGIN
		
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT
		r.RateID,
		r.Code,
		r.Description,
		IF(DestinationGroupCodeID >0,1,0) as DestinationGroupCodeID
	FROM tblRate r
	INNER JOIN tblDestinationGroupSet dg
		ON dg.CodedeckID =r.CodeDeckId
	LEFT JOIN tblDestinationGroupCode dgc
		ON DestinationGroupID = p_DestinationGroupID
		AND dgc.RateID = r.RateID
	WHERE dg.DestinationGroupSetID = p_DestinationGroupSetID
	AND (p_Code = '' OR Code LIKE REPLACE(p_Code, '*', '%'))
	AND (p_Description = '' OR Description LIKE REPLACE(p_Description, '*', '%'))
	AND (p_CountryID = 0 OR r.CountryID = p_CountryID)
	AND (p_Selected = 0 OR (p_Selected = 1 AND DestinationGroupCodeID IS NOT NULL))
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*)  as totalcount
	FROM tblRate r
	INNER JOIN tblDestinationGroupSet dg
		ON dg.CodedeckID =r.CodeDeckId
	LEFT JOIN tblDestinationGroupCode dgc
		ON DestinationGroupID = p_DestinationGroupID
		AND dgc.RateID = r.RateID
	WHERE dg.DestinationGroupSetID = p_DestinationGroupSetID
	AND (p_Code = '' OR Code LIKE REPLACE(p_Code, '*', '%'))
	AND (p_Description = '' OR Description LIKE REPLACE(p_Description, '*', '%'))
	AND (p_CountryID = 0 OR r.CountryID = p_CountryID)
	AND (p_Selected = 0 OR (p_Selected = 1 AND DestinationGroupCodeID IS NOT NULL)); 

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getDestinationGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getDestinationGroup`(IN `p_CompanyID` INT, IN `p_DestinationGroupSetID` INT, IN `p_Name` VARCHAR(50), IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	IF p_isExport = 0
	THEN
		SELECT   
			dg.Name,
			CONCAT(SUBSTRING_INDEX(GROUP_CONCAT(r.Code ORDER BY r.Code ASC SEPARATOR ','), ',', 10),'...') as Code,
			dg.CreatedBy,
			dg.created_at,
			dg.DestinationGroupID,
			dg.DestinationGroupSetID
		FROM tblDestinationGroup dg
		LEFT JOIN tblDestinationGroupCode dgc
		ON dg.DestinationGroupID =  dgc.DestinationGroupID
		LEFT JOIN tblRate r 
			ON r.RateID = dgc.RateID
		WHERE dg.DestinationGroupSetID = p_DestinationGroupSetID
			AND (p_Name ='' OR dg.Name like  CONCAT('%',p_Name,'%'))
		GROUP BY dg.DestinationGroupID
		ORDER BY
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameDESC') THEN dg.Name
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameASC') THEN dg.Name
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByDESC') THEN dg.CreatedBy
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByASC') THEN dg.CreatedBy
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN dg.created_at
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN dg.created_at
			END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(DISTINCT dg.DestinationGroupID) AS totalcount
		FROM tblDestinationGroup dg
		LEFT JOIN tblDestinationGroupCode dgc
		ON dg.DestinationGroupID =  dgc.DestinationGroupID
		LEFT JOIN tblRate r 
			ON r.RateID = dgc.RateID
		WHERE dg.DestinationGroupSetID = p_DestinationGroupSetID
			AND (p_Name ='' OR dg.Name like  CONCAT('%',p_Name,'%'));
	END IF;

	IF p_isExport = 1
	THEN
		
		SELECT
			dg.Name as `Destionatio Group Name`,
			GROUP_CONCAT(r.Code ORDER BY r.Code ASC) as `Destination Codes`,
			dg.CreatedBy,
			dg.created_at
		FROM tblDestinationGroup dg
		LEFT JOIN tblDestinationGroupCode dgc
			ON dg.DestinationGroupID =  dgc.DestinationGroupID
		LEFT JOIN tblRate r 
			ON r.RateID = dgc.RateID
		WHERE dg.DestinationGroupSetID = p_DestinationGroupSetID
			AND (p_Name ='' OR dg.Name like  CONCAT('%',p_Name,'%'))
		GROUP BY dg.DestinationGroupID;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getDestinationGroupSet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getDestinationGroupSet`(IN `p_CompanyID` INT, IN `p_Name` VARCHAR(50), IN `p_CodedeckID` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	IF p_isExport = 0
	THEN
		SELECT   
			dgs.Name,
			cd.CodeDeckName,
			dgs.CreatedBy,
			dgs.created_at,
			dgs.DestinationGroupSetID,
			dgs.CodedeckID,
			dgs.CompanyID,
			(SELECT adp.DiscountPlanID FROM tblDiscountPlan dp  LEFT JOIN tblAccountDiscountPlan adp ON adp.DiscountPlanID = dp.DiscountPlanID WHERE dp.DestinationGroupSetID = dgs.DestinationGroupSetID LIMIT 1) as Applied
		FROM tblDestinationGroupSet dgs
		INNER JOIN tblCodeDeck cd 
			ON cd.CodeDeckId = dgs.CodedeckID
		WHERE dgs.CompanyID = p_CompanyID
			AND (p_Name ='' OR dgs.Name like  CONCAT('%',p_Name,'%'))
			AND (p_CodedeckID = 0 OR dgs.CodedeckID = p_CodedeckID)
		ORDER BY
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameDESC') THEN dgs.Name
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameASC') THEN dgs.Name
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByDESC') THEN dgs.CreatedBy
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByASC') THEN dgs.CreatedBy
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN dgs.created_at
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN dgs.created_at
			END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(dgs.DestinationGroupSetID) AS totalcount
		FROM tblDestinationGroupSet dgs
		INNER JOIN tblCodeDeck cd 
			ON cd.CodeDeckId = dgs.CodedeckID
		WHERE dgs.CompanyID = p_CompanyID
			AND (p_Name ='' OR dgs.Name like  CONCAT('%',p_Name,'%'))
			AND (p_CodedeckID = 0 OR dgs.CodedeckID = p_CodedeckID);
	END IF;

	IF p_isExport = 1
	THEN
		
		SELECT   
			dgs.Name,
			dgs.CreatedBy,
			dgs.created_at
		FROM tblDestinationGroupSet dgs
		INNER JOIN tblCodeDeck cd 
			ON cd.CodeDeckId = dgs.CodedeckID
		WHERE dgs.CompanyID = p_CompanyID
			AND (p_Name ='' OR dgs.Name like  CONCAT('%',p_Name,'%'))
			AND (p_CodedeckID = 0 OR dgs.CodedeckID = p_CodedeckID);

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetDialStrings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetDialStrings`(IN `p_dialstringid` int, IN `p_dialstring` varchar(250), IN `p_chargecode` varchar(250), IN `p_description` varchar(250), IN `p_forbidden` INT, IN `p_PageNumber` int, IN `p_RowspPage` int, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` int )
BEGIN

   DECLARE v_OffSet_ int;
   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	           
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
    

    IF p_isExport = 0
    THEN


        SELECT
            DialStringCodeID,
            DialString,
            ChargeCode,
            Description,
            Forbidden
        FROM tblDialStringCode
        WHERE  (DialStringID = p_dialstringid)
         AND (Forbidden = p_forbidden)
			AND (p_dialstring IS NULL OR DialString LIKE REPLACE(p_dialstring, '*', '%'))
            AND (p_chargecode IS NULL OR ChargeCode LIKE REPLACE(p_chargecode, '*', '%'))
            AND (p_description IS NULL OR Description LIKE REPLACE(p_description, '*', '%'))            
        ORDER BY
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DialStringDESC') THEN DialString
            END DESC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DialStringASC') THEN DialString
            END ASC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ChargeCodeDESC') THEN ChargeCode
            END DESC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ChargeCodeASC') THEN ChargeCode
            END ASC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN Description
            END DESC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN Description
            END ASC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ForbiddenDESC') THEN Forbidden
            END DESC,
            CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ForbiddenASC') THEN Forbidden
            END ASC
        LIMIT p_RowspPage OFFSET v_OffSet_;

        SELECT
            COUNT(DialStringCodeID) AS totalcount
        FROM tblDialStringCode
        WHERE  (DialStringID = p_dialstringid)
         AND (Forbidden = p_forbidden) 
			AND (p_dialstring IS NULL OR DialString LIKE REPLACE(p_dialstring, '*', '%'))
            AND (p_chargecode IS NULL OR ChargeCode LIKE REPLACE(p_chargecode, '*', '%'))
            AND (p_description IS NULL OR Description LIKE REPLACE(p_description, '*', '%'));

    END IF;

    IF p_isExport = 1
    THEN

        SELECT
            DialString,
            ChargeCode,
            Description,
            Forbidden
        FROM tblDialStringCode
        WHERE  (DialStringID = p_dialstringid)
         AND (Forbidden = p_forbidden)
			AND (p_dialstring IS NULL OR DialString LIKE REPLACE(p_dialstring, '*', '%'))
            AND (p_chargecode IS NULL OR ChargeCode LIKE REPLACE(p_chargecode, '*', '%'))
            AND (p_description IS NULL OR Description LIKE REPLACE(p_description, '*', '%'));   

    END IF;
    IF p_isExport = 2
    THEN

        SELECT
            DialStringCodeID,
            DialString,
            ChargeCode,
            Description,
            Forbidden
        FROM tblDialStringCode
        WHERE  (DialStringID = p_dialstringid)
         AND (Forbidden = p_forbidden)
			AND (p_dialstring IS NULL OR DialString LIKE REPLACE(p_dialstring, '*', '%'))
            AND (p_chargecode IS NULL OR ChargeCode LIKE REPLACE(p_chargecode, '*', '%'))
            AND (p_description IS NULL OR Description LIKE REPLACE(p_description, '*', '%'));   

    END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getDiscount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getDiscount`(IN `p_CompanyID` INT, IN `p_DiscountPlanID` INT, IN `p_Name` VARCHAR(50), IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	IF p_isExport = 0
	THEN
		SELECT   
			dg.Name,
			ROUND(ds.Threshold/60,0) as Threshold,
			ds.Discount,
			IF(ds.Unlimited =1 ,'Unlimited','') as UnlimitedText,
			dp.UpdatedBy,
			dp.updated_at,
			dp.DiscountID,
			dp.DiscountPlanID,
			dp.DestinationGroupID,
			ds.DiscountSchemeID,
			dp.Service,
			ds.Unlimited
		FROM tblDiscount dp
		INNER JOIN tblDestinationGroup dg 
			ON dg.DestinationGroupID = dp.DestinationGroupID
		INNER JOIN tblDiscountScheme ds 
			ON ds.DiscountID = dp.DiscountID
		WHERE dp.DiscountPlanID = p_DiscountPlanID
			AND (p_Name ='' OR dg.Name like  CONCAT('%',p_Name,'%'))
		ORDER BY
			CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameDESC') THEN dg.Name
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameASC') THEN dg.Name
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByDESC') THEN dp.CreatedBy
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByASC') THEN dp.CreatedBy
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN dp.created_at
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN dp.created_at
			END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(dp.DiscountID) AS totalcount
		FROM tblDiscount dp
		INNER JOIN tblDestinationGroup dg ON dg.DestinationGroupID = dp.DestinationGroupID
		INNER JOIN tblDiscountScheme ds ON ds.DiscountID = dp.DiscountID
		WHERE dp.DiscountPlanID = p_DiscountPlanID
			AND (p_Name ='' OR dg.Name like  CONCAT('%',p_Name,'%'));
	END IF;

	IF p_isExport = 1
	THEN
		
		SELECT   
			dg.Name,
			dp.Service,
			ds.Threshold,
			ds.Discount,
			IF(ds.Unlimited =1 ,'Unlimited','') as Unlimited,
			dp.UpdatedBy,
			dp.updated_at
		FROM tblDiscount dp
		INNER JOIN tblDestinationGroup dg ON dg.DestinationGroupID = dp.DestinationGroupID
		INNER JOIN tblDiscountScheme ds ON ds.DiscountID = dp.DiscountID
		WHERE dp.DiscountPlanID = p_DiscountPlanID
			AND (p_Name ='' OR dg.Name like  CONCAT('%',p_Name,'%'));

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getDiscountPlan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getDiscountPlan`(IN `p_CompanyID` INT, IN `p_Name` VARCHAR(50), IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	IF p_isExport = 0
	THEN
		SELECT   
			dp.Name,
			dgs.Name as DestinationGroupSet,
			c.Code as Currency,
			dp.UpdatedBy,
			dp.updated_at,
			dp.DiscountPlanID,
			dp.DestinationGroupSetID,
			dp.CurrencyID,
			dp.Description,
			(SELECT adp.DiscountPlanID FROM tblAccountDiscountPlan adp WHERE adp.DiscountPlanID = dp.DiscountPlanID LIMIT 1)as Applied
		FROM tblDiscountPlan dp
		INNER JOIN tblDestinationGroupSet dgs
			ON dgs.DestinationGroupSetID = dp.DestinationGroupSetID
		INNER JOIN tblCurrency c
			ON c.CurrencyId = dp.CurrencyID
		
		WHERE dp.CompanyID = p_CompanyID
			AND (p_Name ='' OR dp.Name like  CONCAT('%',p_Name,'%'))
		ORDER BY
			CASE
					WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameDESC') THEN dp.Name
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameASC') THEN dp.Name
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByDESC') THEN dp.CreatedBy
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByASC') THEN dp.CreatedBy
			END ASC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN dp.created_at
			END DESC,
			CASE
				WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN dp.created_at
			END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(dp.DiscountPlanID) AS totalcount
		FROM tblDiscountPlan dp
		WHERE dp.CompanyID = p_CompanyID
			AND (p_Name ='' OR dp.Name like  CONCAT('%',p_Name,'%'));
	END IF;

	IF p_isExport = 1
	THEN
		
		SELECT   
			dp.Name,
			dp.UpdatedBy,
			dp.updated_at,
			dp.Description
		FROM tblDiscountPlan dp
		WHERE dp.CompanyID = p_CompanyID
			AND (p_Name ='' OR dp.Name like  CONCAT('%',p_Name,'%'));

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetFromEmailAddress` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `prc_GetFromEmailAddress`(
	IN `p_CompanyID` int,
	IN `p_userID` int ,
	IN `p_Ticket` INT,
	IN `p_Admin` INT
)
BEGIN
	DECLARE V_Ticket_Permission int;
	DECLARE V_Ticket_Permission_level int;
	DECLARE V_User_Groups varchar(100);
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;	
	SELECT 0 INTO V_Ticket_Permission;
	SELECT 0 into V_Ticket_Permission_level;			
	IF p_Ticket = 1
	THEN	
		IF p_Admin > 0
		THEN
			SELECT 1 INTO V_Ticket_Permission;
		END IF;
		
		IF p_Admin < 1 
		THEN		
			SELECT 
				count(*) into V_Ticket_Permission
			FROM 
				tblUser u
			inner join 
				tblUserPermission up on u.UserID = up.UserID
			inner join 
				tblResourceCategories tc on up.resourceID = tc.ResourceCategoryID
			WHERE 
				tc.ResourceCategoryName = 'Tickets.View.GlobalAccess'  and u.UserID = p_userID;
		END IF;
		
		IF V_Ticket_Permission > 0 
		THEN
			SELECT 1 into V_Ticket_Permission_level;			
			IF p_Admin > 0
			THEN
				SELECT DISTINCT GroupEmailAddress as EmailFrom FROM tblTicketGroups where CompanyID = p_CompanyID and GroupEmailStatus = 1 and GroupEmailAddress IS NOT NULL
					UNION ALL			
				SELECT  tc.EmailFrom as EmailFrom FROM tblCompany tc where tc.EmailFrom IS NOT NULL AND tc.EmailFrom <> ''
					UNION ALL
				SELECT DISTINCT(tu.EmailAddress) as EmailFrom from tblUser tu;
			END IF;
			IF p_Admin < 1	
			THEN
				SELECT DISTINCT GroupEmailAddress as EmailFrom FROM tblTicketGroups where CompanyID = p_CompanyID and GroupEmailStatus = 1 and GroupEmailAddress IS NOT NULL
					UNION ALL	
				SELECT  tc.EmailFrom as EmailFrom FROM tblCompany tc where tc.EmailFrom IS NOT NULL AND tc.EmailFrom <> ''
					UNION ALL
				SELECT tu.EmailAddress as EmailFrom from tblUser tu where tu.UserID = p_userID;							
			END IF;
		END IF;
		
		IF V_Ticket_Permission_level = 0
			THEN
				SELECT 0 into V_Ticket_Permission;
				SELECT 
				/*distinct u.userid, up.AddRemove,tc.ResourceCategoryName as permname*/
				count(*) into V_Ticket_Permission
			FROM 
				tblUser u
			inner join 
				tblUserPermission up on u.UserID = up.UserID
			inner join 
				tblResourceCategories tc on up.resourceID = tc.ResourceCategoryID
			WHERE 
				tc.ResourceCategoryName = 'Tickets.View.GroupAccess'  and u.UserID = p_userID;
		END IF;

		IF V_Ticket_Permission > 0 and V_Ticket_Permission_level = 0 
		THEN
			SELECT 2 into V_Ticket_Permission_level;
			
			SELECT GROUP_CONCAT(GroupID SEPARATOR ',') into V_User_Groups FROM tblTicketGroupAgents TGA where TGA.UserID = p_userID;
			
			IF p_Admin > 0
			THEN
				SELECT DISTINCT GroupEmailAddress as EmailFrom FROM tblTicketGroups where CompanyID = p_CompanyID and GroupEmailStatus = 1 and GroupEmailAddress IS NOT NULL AND FIND_IN_SET(GroupID,V_User_Groups)
					UNION ALL			
				SELECT  tc.EmailFrom as EmailFrom FROM tblCompany tc where tc.EmailFrom IS NOT NULL AND tc.EmailFrom <> ''
					UNION ALL
				SELECT DISTINCT(tu.EmailAddress) as EmailFrom from tblUser tu;
			END IF;
			IF p_Admin < 1	
			THEN
				SELECT DISTINCT GroupEmailAddress as EmailFrom FROM tblTicketGroups where CompanyID = p_CompanyID and GroupEmailStatus = 1 and GroupEmailAddress IS NOT NULL AND FIND_IN_SET(GroupID,V_User_Groups)
					UNION ALL	
				SELECT  tc.EmailFrom as EmailFrom FROM tblCompany tc where tc.EmailFrom IS NOT NULL AND tc.EmailFrom <> ''
					UNION ALL
				SELECT tu.EmailAddress as EmailFrom from tblUser tu where tu.UserID = p_userID;							
			END IF;
			
		END IF;

		IF V_Ticket_Permission_level = 0 
		THEN
			SELECT 0 into V_Ticket_Permission;
			SELECT 3 into V_Ticket_Permission_level;
			IF p_Admin > 0
			THEN
				SELECT DISTINCT TG.GroupEmailAddress as EmailFrom FROM tblTicketGroups TG INNER JOIN tblTickets TT ON TT.Group = TG.GroupID where TG.CompanyID = p_CompanyID and GroupEmailStatus = 1 and TG.GroupEmailAddress IS NOT NULL AND TT.Agent = p_userID					
					UNION ALL			
				SELECT  tc.EmailFrom as EmailFrom FROM tblCompany tc where tc.EmailFrom IS NOT NULL AND tc.EmailFrom <> ''
					UNION ALL
				SELECT DISTINCT(tu.EmailAddress) as EmailFrom from tblUser tu;
			END IF;
			IF p_Admin < 1	
			THEN
				SELECT DISTINCT TG.GroupEmailAddress as EmailFrom FROM tblTicketGroups TG INNER JOIN tblTickets TT ON TT.Group = TG.GroupID where TG.CompanyID = p_CompanyID and GroupEmailStatus = 1 and TG.GroupEmailAddress IS NOT NULL AND TT.Agent = p_userID
					UNION ALL	
				SELECT  tc.EmailFrom as EmailFrom FROM tblCompany tc where tc.EmailFrom IS NOT NULL AND tc.EmailFrom <> ''
					UNION ALL
				SELECT tu.EmailAddress as EmailFrom from tblUser tu where tu.UserID = p_userID;							
			END IF;
			
		END IF;		
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
			SELECT tu.EmailAddress as EmailFrom from tblUser tu where tu.UserID = p_userID;							
		END IF;
	END IF;
	/*SELECT V_Ticket_Permission_level;*/
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getJobDropdown` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getJobDropdown`(IN `p_CompanyId` int , IN `p_userId` int , IN `p_isadmin` int , IN `p_reset` int )
BEGIN
   
  SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
  IF p_reset = 1 
  THEN
    update `tblJob` set `ShowInCounter` = '0' where `CompanyID` = p_CompanyId and `ShowInCounter` = '1';
  END IF;
        select  `tblJob`.`JobID`, `tblJob`.`Title`, `tblJobStatus`.`Title` as Status, `tblJob`.`HasRead`, `tblJob`.`CreatedBy`, `tblJob`.`created_at`, `tblJobType`.`Title` as JobType 
        from `tblJob` inner join `tblJobStatus` on `tblJob`.`JobStatusID` = `tblJobStatus`.`JobStatusID` 
        inner join `tblJobType` on `tblJob`.`JobTypeID` = `tblJobType`.`JobTypeID` 
        where `tblJob`.`CompanyID` = p_CompanyId AND  `tblJob`.JobLoggedUserID = p_userId
        order by `tblJob`.`ShowInCounter` desc, `tblJob`.`updated_at` desc,`tblJob`.JobID desc 
		  limit 10;

	  select count(*) as totalNonVisitedJobs from `tblJob` 
    inner join `tblJobStatus` on `tblJob`.`JobStatusID` = `tblJobStatus`.`JobStatusID` 
    where `tblJob`.`CompanyID` = p_CompanyId and `tblJob`.`ShowInCounter` = '1' and `tblJob`.JobLoggedUserID = p_userId;
    
    

    select count(*) as totalPendingJobs from `tblJob` inner join `tblJobStatus` on `tblJob`.`JobStatusID` = `tblJobStatus`.`JobStatusID` 
    where `tblJobStatus`.`Title` = 'Pending' and `tblJob`.`CompanyID` = p_CompanyId AND 
	`tblJob`.JobLoggedUserID = p_userId;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetLastRateTableRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetLastRateTableRate`(IN `p_companyid` INT, IN `p_RateTableId` INT, IN `p_EffectiveDate` datetime)
BEGIN
		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
        SELECT
            Code,
            Description,
            tblRateTableRate.Interval1,
            tblRateTableRate.IntervalN,
			ConnectionFee,
            Rate,
            EffectiveDate
        FROM tblRate
        INNER JOIN tblRateTableRate
            ON tblRateTableRate.RateID = tblRate.RateID
            AND tblRateTableRate.RateTableId = p_RateTableId
        INNER JOIN tblRateTable
            ON tblRateTable.RateTableId = tblRateTableRate.RateTableId
        WHERE		(tblRate.CompanyID = p_companyid)
		AND tblRateTableRate.RateTableId = p_RateTableId
		AND EffectiveDate = p_EffectiveDate;
		
		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetLCR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetLCR`(
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
   

DROP TEMPORARY TABLE IF EXISTS tmp_search_code_;
  CREATE TEMPORARY TABLE tmp_search_code_ (
     Code  varchar(50),
     INDEX Index1 (Code)
);


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


 
     
      INSERT INTO tmp_VendorCurrentRates1_ 
      Select DISTINCT AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference 
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
										
								  (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = p_CurrencyID and  CompanyID = p_companyid )
									* (tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ))
							  )
							 END 
								as  Rate,
								 ConnectionFee,
                    		DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate, tblVendorRate.TrunkID, tblRate.CountryID, tblRate.RateID,IFNULL(vp.Preference, 5) AS Preference 
                    		FROM      tblVendorRate
					     Inner join tblVendorTrunk vt on vt.CompanyID = p_companyid AND vt.AccountID = tblVendorRate.AccountID and vt.Status =  1 and vt.TrunkID =  p_trunkID  
							
						INNER JOIN tblAccount   ON  tblAccount.CompanyID = p_companyid AND tblVendorRate.AccountId = tblAccount.AccountID and tblAccount.IsVendor = 1
						INNER JOIN tblRate ON tblRate.CompanyID = p_companyid     AND    tblVendorRate.RateId = tblRate.RateID  
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
     	@rank := ( CASE WHEN( @prev_AccountID = v.AccountId  and @prev_RowCode     = RowCode   ) 
                                   THEN  @rank + 1 
                                   ELSE 1 
                              END 
          ) AS MaxMatchRank,
	     @prev_RowCode := RowCode	 ,															
          @prev_AccountID := v.AccountId   
          FROM tmp_VendorRate_stage_1 v  
          , (SELECT  @prev_RowCode := '',  @rank := 0 , @prev_Code := '' , @prev_AccountID := Null) f
          order by AccountID,RowCode desc ; 
         
    
    

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
           where MaxMatchRank = 1 
          
			  			  order by RowCode desc; 


     
                                   
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
                              @preference_rank := CASE WHEN (@prev_Code     = RowCode AND @prev_Preference > Preference  )   THEN @preference_rank + 1 
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetLCRwithPrefix` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetLCRwithPrefix`(
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
   

DROP TEMPORARY TABLE IF EXISTS tmp_search_code_;
  CREATE TEMPORARY TABLE tmp_search_code_ (
     Code  varchar(50),
     INDEX Index1 (Code)
);


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



         

 
     
     INSERT INTO tmp_VendorCurrentRates1_ 
	  Select DISTINCT AccountId,AccountName,Code,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference 
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
										
								  (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = p_CurrencyID and  CompanyID = p_companyid )
									* (tblVendorRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = p_companyid ))
							  )
							 END
								as  Rate,
								 ConnectionFee,
			  DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate, 
			    tblVendorRate.TrunkID, tblRate.CountryID, tblRate.RateID,IFNULL(vp.Preference, 5) AS Preference 
			  FROM      tblVendorRate
					 Inner join tblVendorTrunk vt on vt.CompanyID = p_companyid AND vt.AccountID = tblVendorRate.AccountID and vt.Status =  1 and vt.TrunkID =  p_trunkID  
							 
						INNER JOIN tblAccount   ON  tblAccount.CompanyID = p_companyid AND tblVendorRate.AccountId = tblAccount.AccountID 
						INNER JOIN tblRate ON tblRate.CompanyID = p_companyid   AND    tblVendorRate.RateId = tblRate.RateID
						
						
						
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

						( CHAR_LENGTH(RTRIM(p_code)) = 0 OR tblRate.Code LIKE REPLACE(p_code,'*', '%') )  
						AND EffectiveDate <= NOW() 
						AND tblAccount.IsVendor = 1
						AND tblAccount.Status = 1
						AND tblAccount.CurrencyId is not NULL
						AND tblVendorRate.TrunkID = p_trunkID
						AND blockCode.RateId IS NULL
					   AND blockCountry.CountryId IS NULL
			
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
 
 	 
			
			
         
          
        
		
		
		 
    
        
        


IF p_Preference = 1 THEN

	
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
                              @preference_rank := CASE WHEN (@prev_Code     = RowCode AND @prev_Preference > Preference  )   THEN @preference_rank + 1 
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetLCR__ORIG` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetLCR__ORIG`(IN `p_companyid` INT, IN `p_trunkID` INT, IN `p_codedeckID` INT, IN `p_contryID` INT, IN `p_code` VARCHAR(50), IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_SortOrder` VARCHAR(50), IN `p_Preference` INT, IN `p_isExport` INT)
BEGIN
    DECLARE v_OffSet_ int;
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
                
    SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
    
  Call fnVendorCurrentRates(p_companyid,p_codedeckID,p_trunkID,p_contryID, p_code,'0');
  DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
  CREATE TEMPORARY TABLE tmp_VendorRate_ (      
     AccountId INT ,
     AccountName VARCHAR(100) ,
     Code VARCHAR(50) ,
     Rate DECIMAL(18,6) ,
     EffectiveDate DATETIME ,
     Description VARCHAR(255),
     rankname INT
   );
        
               
       
    INSERT  INTO tmp_VendorRate_
                SELECT  vr.AccountID ,
                        vr.AccountName ,
                        vr.Code ,
                        vr.Rate ,
                        vr.EffectiveDate ,
                        vr.Description,
                        vr.rankname
                FROM    ( 

                        SELECT 
                                    Description ,
                                    AccountID ,
                                    AccountName ,
                                    Code ,
                                    Rate ,
                                    EffectiveDate ,
                                    case when p_Preference = 1
                                    then preference_rank
                                    else
                                        rankname
                                    end as rankname
                                    
                                FROM (
                                                SELECT 
                                                Description ,
                                                AccountID ,
                                                AccountName ,
                                                Code ,
                                                Preference,
                                                Rate,
                                                EffectiveDate,
                                                preference_rank,
                                                @rank := CASE WHEN (@prev_Code2  = Code  AND @prev_Rate2 <  Rate) THEN @rank+1
                                                	   		  WHEN (@prev_Code2  = Code  AND @prev_Rate2 =  Rate) THEN @rank
                                                				  ELSE
																					1
																				  END
																				  AS rankname,
                                                @prev_Code2  := Code,
                                                @prev_Rate2  := Rate
                                                FROM    (SELECT 
                                                    Description ,
                                                    AccountID ,
                                                    AccountName ,
                                                    Code ,
                                                    Preference,
                                                    Rate,
                                                    EffectiveDate,
                                                    @preference_rank := CASE WHEN (@prev_Code  = Code AND @prev_Preference = Preference AND @prev_Rate2 <  Rate) THEN @preference_rank+1
					                                                	   		  WHEN (@prev_Code  = Code  AND @prev_Preference = Preference AND @prev_Rate2 =  Rate) THEN @preference_rank
               					                                 				  ELSE
																										1
																									  END as preference_rank,
                                                    @prev_Code  := Code,
                                                    @prev_Preference  := Preference,
                                                    @prev_Rate  := Rate
                                                    FROM 
                                                    (SELECT DISTINCT
                                                                r.Description ,
                                                                v.AccountId,v.TrunkID,v.RateId ,
                                                                a.AccountName ,
                                                                r.Code ,
                                                                vp.Preference,
                                                                v.Rate,
                                                                v.EffectiveDate ,
                                                                @row_num := IF(@prev_AccountId=v.AccountId AND @prev_TrunkID=v.TrunkID AND @prev_RateId=v.RateId and @prev_EffectiveDate >= v.effectivedate ,@row_num+1,1) AS RowID,
                                                                @prev_AccountId  := v.AccountId,
                                                                @prev_TrunkID  := v.TrunkID,
                                                                @prev_RateId  := v.RateId,
                                                                @prev_EffectiveDate  := v.effectivedate
                                                      FROM      tblVendorRate AS v
                                                                INNER JOIN tblAccount a ON v.AccountId = a.AccountID
                                                                INNER JOIN tblRate r ON v.RateId = r.RateID and r.CodeDeckId = p_codedeckID
                                                                INNER JOIN  tmp_VendorCurrentRates_ AS e ON 
                                                                    v.AccountId = e.AccountID 
                                                                    AND v.TrunkID = e.TrunkID
                                                                    AND     v.RateId = e.RateId
                                                                    AND v.EffectiveDate = e.EffectiveDate
                                                                    AND v.Rate > 0
                                                             
                                                                LEFT JOIN tblVendorPreference vp 
                                                                    ON vp.AccountId = v.AccountId
                                                                    AND vp.TrunkID = v.TrunkID
                                                                    AND vp.RateId = v.RateId
                                                            ,(SELECT @row_num := 1) x,(SELECT @prev_AccountId := '') a,(SELECT @prev_TrunkID := '') b,(SELECT @prev_RateId := '') c,(SELECT @prev_EffectiveDate := '') d

                                                    ORDER BY v.AccountId,v.TrunkID,v.RateId,v.EffectiveDate DESC
                                                    
                                            )as preference,(SELECT @preference_rank := 1) x,(SELECT @prev_Code := '') a,(SELECT @prev_Preference := '') b,(SELECT @prev_Rate := '') c
                                            where preference.RowID = 1
                                            ORDER BY preference.Code ASC, preference.Preference desc, preference.Rate ASC
                                            
                                        )as rank ,(SELECT @rank := 1) x,(SELECT @prev_Code2 := '') d,(SELECT @prev_Rate2 := '') f
                                        ORDER BY rank.Code ASC, rank.Rate ASC
    
                                    ) tbl
                           
                        ) vr
                WHERE   vr.rankname <= 5 
               ORDER BY rankname; 

         IF p_isExport = 0
        THEN
        
          SELECT
            
        	 CONCAT(t.Code , ' : ' , ANY_VALUE(t.Description)) as Destination,
          GROUP_CONCAT(if(ANY_VALUE(rankname) = 1, CONCAT(ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `Position 1`,
          GROUP_CONCAT(if(ANY_VALUE(rankname) = 2, CONCAT(ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName), '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `Position 2`,
          GROUP_CONCAT(if(ANY_VALUE(rankname) = 3, CONCAT(ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `Position 3`,
          GROUP_CONCAT(if(ANY_VALUE(rankname) = 4, CONCAT(ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `Position 4`,
          GROUP_CONCAT(if(ANY_VALUE(rankname) = 5, CONCAT(ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `Position 5`
        FROM      tmp_VendorRate_ t
          GROUP BY  t.Code
          ORDER BY  CASE WHEN (p_SortOrder = 'DESC') THEN `Destination` END DESC,
                       CASE WHEN (p_SortOrder = 'ASC') THEN `Destination` END ASC
                        
          LIMIT p_RowspPage OFFSET v_OffSet_;     

         select count(*)as totalcount FROM(SELECT code
         from tmp_VendorRate_ 
         GROUP by Code)tbl;
    
    END IF;
    
    
    IF p_isExport = 1
    THEN

        SELECT  
        	 CONCAT(t.Code , ' : ' , ANY_VALUE(t.Description)) as Destination,
          GROUP_CONCAT(if(ANY_VALUE(rankname) = 1, CONCAT(ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `Position 1`,
          GROUP_CONCAT(if(ANY_VALUE(rankname) = 2, CONCAT(ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName), '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `Position 2`,
          GROUP_CONCAT(if(ANY_VALUE(rankname) = 3, CONCAT(ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `Position 3`,
          GROUP_CONCAT(if(ANY_VALUE(rankname) = 4, CONCAT(ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `Position 4`,
          GROUP_CONCAT(if(ANY_VALUE(rankname) = 5, CONCAT(ANY_VALUE(t.Rate), '<br>', ANY_VALUE(t.AccountName) , '<br>', DATE_FORMAT (ANY_VALUE(t.EffectiveDate), '%d/%m/%Y'),'<br>'), NULL))AS `Position 5`
        FROM tmp_VendorRate_  t
          GROUP BY  t.Code
          ORDER BY `Destination` ASC;
        
    END IF;
    
   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getMissingAccountsByGateway` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getMissingAccountsByGateway`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_ProcessID` VARCHAR(250), IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_Export` INT)
BEGIN
     DECLARE v_OffSet_ int;
     
     SET sql_mode = '';
     SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
     SET SESSION sql_mode='';
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	if p_Export = 0
	THEN

		SELECT DISTINCT
				ta.tblTempAccountID,				
				ta.AccountName as AccountName,
				ta.FirstName as FirstName,
				ta.LastName as LastName,
				ta.Email as Email
				from tblTempAccount ta
				left join tblAccount a on ta.AccountName=a.AccountName
				 	AND ta.CompanyID = a.CompanyId
				 	AND ta.AccountType = a.AccountType
				where ta.CompanyID =p_CompanyID 								
				AND ta.AccountType=1
				AND ta.CompanyGatewayID = p_CompanyGatewayID
				AND ta.ProcessID = p_ProcessID
				AND a.AccountID is null
				group by ta.AccountName
				ORDER BY				
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN ta.AccountName
                END DESC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN ta.AccountName
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'FirstNameDESC') THEN ta.FirstName
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'FirstNameASC') THEN ta.FirstName
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastNameDESC') THEN ta.LastName
                END DESC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastNameASC') THEN ta.LastName
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EmailDESC') THEN ta.Email
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EmailASC') THEN ta.Email
                END ASC
				LIMIT p_RowspPage OFFSET v_OffSet_;				
			
			select count(*) as totalcount from(
			SELECT 
				COUNT(ta.tblTempAccountID) as totalcount				
				from tblTempAccount ta
				left join tblAccount a on ta.AccountName=a.AccountName
					 AND ta.CompanyID = a.CompanyId
					 AND ta.AccountType = a.AccountType
				where ta.CompanyID =p_CompanyID 
				AND ta.AccountType=1
				AND ta.CompanyGatewayID = p_CompanyGatewayID
				AND ta.ProcessID = p_ProcessID
				AND a.AccountID is null
				group by ta.AccountName)tbl;

	ELSE

			SELECT DISTINCT				
				ta.AccountName as AccountName,
				ta.FirstName as FirstName,
				ta.LastName as LastName,
				ta.Email as Email
				from tblTempAccount ta
				left join tblAccount a on ta.AccountName=a.AccountName
					 AND ta.CompanyID = a.CompanyId
					 AND ta.AccountType = a.AccountType
				where ta.CompanyID =p_CompanyID 
				AND ta.AccountType=1
				AND ta.CompanyGatewayID = p_CompanyGatewayID
				AND ta.ProcessID = p_ProcessID
				AND a.AccountID is null
				group by ta.AccountName;

	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getMissingAccountsOfQuickbook` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getMissingAccountsOfQuickbook`(IN `p_CompanyID` INT, IN `p_ProcessID` VARCHAR(250), IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_Export` INT)
BEGIN
     DECLARE v_OffSet_ int;
     SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	      
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	if p_Export = 0
	THEN

		SELECT DISTINCT
				max(ta.tblTempAccountID) as tblTempAccountID,				
				ta.AccountName as AccountName,
				max(ta.FirstName) as FirstName,
				max(ta.LastName) as LastName,
				max(ta.Email) as Email
				from tblTempAccount ta
				left join tblAccount a on ta.AccountName=a.AccountName
				 	AND ta.CompanyID = a.CompanyId
				 	AND ta.AccountType = a.AccountType
				where ta.CompanyID =p_CompanyID 								
				AND ta.AccountType=1
				AND ta.LeadSource = 'QuickbookImport'
				AND ta.ProcessID = p_ProcessID
				AND a.AccountID is null
				group by ta.AccountName
				ORDER BY				
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN ta.AccountName
                END DESC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN ta.AccountName
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'FirstNameDESC') THEN max(ta.FirstName)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'FirstNameASC') THEN max(ta.FirstName)
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastNameDESC') THEN max(ta.LastName)
                END DESC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastNameASC') THEN max(ta.LastName)
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EmailDESC') THEN max(ta.Email)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EmailASC') THEN max(ta.Email)
                END ASC
				LIMIT p_RowspPage OFFSET v_OffSet_;				
			
			select count(*) as totalcount from(
			SELECT 
				COUNT(ta.tblTempAccountID) as totalcount				
				from tblTempAccount ta
				left join tblAccount a on ta.AccountName=a.AccountName
					 AND ta.CompanyID = a.CompanyId
					 AND ta.AccountType = a.AccountType
				where ta.CompanyID =p_CompanyID 
				AND ta.AccountType=1
				AND ta.LeadSource = 'QuickbookImport'
				AND ta.ProcessID = p_ProcessID
				AND a.AccountID is null
				group by ta.AccountName)tbl;

	ELSE

			SELECT DISTINCT				
				ta.AccountName as AccountName,
				max(ta.FirstName) as FirstName,
				max(ta.LastName) as LastName,
				max(ta.Email) as Email
				from tblTempAccount ta
				left join tblAccount a on ta.AccountName=a.AccountName
					 AND ta.CompanyID = a.CompanyId
					 AND ta.AccountType = a.AccountType
				where ta.CompanyID =p_CompanyID 
				AND ta.AccountType=1
				AND ta.LeadSource = 'QuickbookImport'
				AND ta.ProcessID = p_ProcessID
				AND a.AccountID is null
				group by ta.AccountName;

	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getMsgsDropdown` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getMsgsDropdown`(
	IN `p_CompanyId` int ,
	IN `p_userId` int ,
	IN `p_isadmin` int ,
	IN `p_reset` int 


)
BEGIN
   
  SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
  IF p_reset = 1 
  THEN
    UPDATE `tblMessages` set `ShowInCounter` = '0' where `CompanyID` = p_CompanyId AND `ShowInCounter` = '1';
  END IF;
        SELECT  
			 `tblMessages`.`MsgID`, `tblMessages`.`Title`,  `tblMessages`.`HasRead`, `tblMessages`.`CreatedBy`, `tblMessages`.`created_at`,`tblMessages`.Description,tblMessages.EmailID
        FROM 
			`tblMessages` 
        WHERE
			`tblMessages`.`CompanyID` = p_CompanyId AND (p_isadmin = 1 OR (p_isadmin = 0 AND tblMessages.MsgLoggedUserID = p_userId))
        order by 
			`tblMessages`.`ShowInCounter` desc, `tblMessages`.`updated_at` desc,`tblMessages`.MsgID desc 
		limit 10;
		  
		SELECT  
			count(*) as totalNonVisitedJobs
        FROM
			`tblMessages` 
			INNER JOIN AccountEmailLog ae
		    ON ae.AccountEmailLogID = tblMessages.EmailID
        WHERE
			`tblMessages`.`CompanyID` = p_CompanyId AND (p_isadmin = 1 OR (p_isadmin = 0 AND tblMessages.MsgLoggedUserID = p_userId))
			AND ae.EmailCall = 1 AND  tblMessages.HasRead=0
        order by
			`tblMessages`.`ShowInCounter` desc, `tblMessages`.`updated_at` desc,`tblMessages`.MsgID desc;
	 
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;  
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetOpportunities` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetOpportunities`(IN `p_CompanyID` INT, IN `p_BoardID` INT, IN `p_OpportunityName` VARCHAR(50), IN `p_Tags` VARCHAR(50), IN `p_OwnerID` VARCHAR(100), IN `p_AccountID` INT, IN `p_Status` VARCHAR(50), IN `p_CurrencyID` INT, IN `p_OpportunityClosed` INT)
BEGIN
 
	DECLARE v_WorthTotal DECIMAL(18,8);
	DECLARE v_Round_ int;
	DECLARE v_CurrencyCode_ VARCHAR(50);
	DECLARE v_Active_ int;
	SET v_Active_ = 1;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	SELECT cr.Symbol INTO v_CurrencyCode_ from tblCurrency cr where cr.CurrencyId = p_CurrencyID;
		
 DROP TEMPORARY TABLE IF EXISTS tmp_Oppertunites_;
CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Oppertunites_(
		BoardColumnID int,
		BoardColumnName varchar(255),
		Height varchar(10),
		Width varchar(10),
		OpportunityID int,
		OpportunityName varchar(255),
		BackGroundColour varchar(10),
		TextColour varchar(10),
		Company varchar(100),
		Title varchar(10),
		FirstName varchar(50),
		LastName varchar(50),
		Owner varchar(100),
		UserID int,
		Phone varchar(50),
		Email varchar(255),
		BoardID int,
		AccountID int,
		Tags varchar(255),
		Rating int,
		TaggedUsers varchar(100),
		`Status` int,
 	   Worth DECIMAL(18,8),
		OpportunityClosed int,
		ClosingDate varchar(15),
		ExpectedClosing varchar(15),
		StartTime varchar(15)
);
  
		INSERT INTO tmp_Oppertunites_
		SELECT 
				bc.BoardColumnID,
				bc.BoardColumnName,
				bc.Height,
				bc.Width,
				o.OpportunityID,
				o.OpportunityName,
				o.BackGroundColour,
				o.TextColour,
				o.Company,
				o.Title,
				o.FirstName,
				o.LastName,
				concat(u.FirstName,concat(' ',u.LastName)) as Owner,
				o.UserID,
				o.Phone,
				o.Email,
				b.BoardID,
				o.AccountID,
				o.Tags,
				o.Rating,
				o.TaggedUsers,
				o.`Status`,
			   o.Worth,
			   o.OpportunityClosed,
			   Date(o.ClosingDate) as ClosingDate,
			   Date(o.ExpectedClosing) as ExpectedClosing,
				Time(o.ExpectedClosing) as StartTime		
		FROM tblCRMBoards b
		INNER JOIN tblCRMBoardColumn bc on bc.BoardID = b.BoardID AND b.BoardID = p_BoardID
		LEFT JOIN tblOpportunity o on o.BoardID = b.BoardID
					AND o.BoardColumnID = bc.BoardColumnID
					AND o.CompanyID = p_CompanyID
					AND (o.OpportunityClosed = p_OpportunityClosed)
					AND (p_Tags = '' OR find_in_set(o.Tags,p_Tags))
					AND (p_OpportunityName = '' OR o.OpportunityName LIKE Concat('%',p_OpportunityName,'%'))
					AND (p_OwnerID = '' OR o.UserID = p_OwnerID)
					AND (p_AccountID = 0 OR o.AccountID = p_AccountID)
					AND (p_Status = '' OR find_in_set(o.`Status`,p_Status))
					AND (p_CurrencyID = 0 OR p_CurrencyID in (Select CurrencyId FROM tblAccount Where tblAccount.AccountID = o.AccountID))
					AND (v_Active_ = (Select `Status` FROM tblAccount Where tblAccount.AccountID = o.AccountID limit 1))
					AND (v_Active_ = (Select `Status` FROM tblUser Where tblUser.UserID = o.UserID limit 1))

	 	LEFT JOIN tblUser u on u.UserID = o.UserID
		ORDER BY bc.`Order`,o.`Order`; 

SELECT sum(Worth) as TotalWorth INTO v_WorthTotal from tmp_Oppertunites_;


 SELECT		*,	           
			ROUND(IFNULL(v_WorthTotal,0.00),v_Round_) as WorthTotal,
			v_CurrencyCode_ as CurrencyCode			
        FROM tmp_Oppertunites_ ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetOpportunityGrid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetOpportunityGrid`(IN `p_CompanyID` INT, IN `p_BoardID` INT, IN `p_OpportunityName` VARCHAR(50), IN `p_Tags` VARCHAR(50), IN `p_OwnerID` VARCHAR(50), IN `p_AccountID` INT, IN `p_Status` VARCHAR(50), IN `p_CurrencyID` INT, IN `p_OpportunityClosed` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(50))
BEGIN
 DECLARE v_OffSet_ int;
 DECLARE v_Round_ int;
 
   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
   SET SESSION group_concat_max_len = 1024;
     
 SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;


	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
SELECT 
  bc.BoardColumnID,
  bc.BoardColumnName,
  o.OpportunityID,
  o.OpportunityName,
  o.BackGroundColour,
  o.TextColour,
  o.Company,
  o.Title,
  o.FirstName,
  o.LastName,
  concat(u.FirstName,concat(' ',u.LastName)) as Owner,
  o.UserID,
  o.Phone,
  o.Email,
  b.BoardID,
  o.AccountID,
  o.Tags,
  o.Rating,
  o.TaggedUsers,
  o.`Status`,
     ROUND(o.Worth,v_Round_) as Worth,
     o.OpportunityClosed,
     Date(o.ClosingDate) as ClosingDate,
     Date(o.ExpectedClosing) as ExpectedClosing,
  Time(o.ExpectedClosing) as StartTime
FROM tblCRMBoards b
INNER JOIN tblCRMBoardColumn bc on bc.BoardID = b.BoardID
   AND (p_BoardID = 0 OR b.BoardID = p_BoardID)
INNER JOIN tblOpportunity o on o.BoardID = b.BoardID
   AND o.BoardColumnID = bc.BoardColumnID
   AND o.CompanyID = p_CompanyID
   AND (o.OpportunityClosed = p_OpportunityClosed)
   AND (p_Tags = '' OR find_in_set(o.Tags,p_Tags))
   AND (p_OpportunityName = '' OR o.OpportunityName LIKE Concat('%',p_OpportunityName,'%'))
   AND (p_OwnerID = '' OR find_in_set(o.`UserID`,p_OwnerID))
   AND (p_AccountID = 0 OR o.AccountID = p_AccountID)
   AND (p_Status = '' OR find_in_set(o.`Status`,p_Status))
INNER JOIN tblAccount ac on o.AccountID = ac.AccountID
 AND ac.`Status` = 1
 AND (p_CurrencyID = 0 OR ac.CurrencyId = p_CurrencyID) 
INNER JOIN tblUser u on o.UserID = u.UserID
	AND u.`Status` = 1
ORDER BY
  CASE
       WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OpportunityNameDESC') THEN o.OpportunityName
   END DESC,
   CASE
       WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'OpportunityNameASC') THEN o.OpportunityName
   END ASC,
   CASE
       WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RatingDESC') THEN o.Rating
   END DESC,
   CASE
       WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RatingASC') THEN o.Rating
   END ASC,
   CASE
       WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN o.`Status`
   END DESC,
   CASE
       WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN o.`Status`
   END ASC,
   CASE
       WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'UserIDDESC') THEN concat(u.FirstName,' ',u.LastName)
   END DESC,
   CASE
       WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'UserIDASC') THEN concat(u.FirstName,' ',u.LastName)
   END ASC,
   CASE
       WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RelatedToDESC') THEN o.Company
   END DESC,
   CASE
       WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RelatedToASC') THEN o.Company
   END ASC,
   CASE
       WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ExpectedClosingASC') THEN o.ExpectedClosing
   END ASC,
   CASE
       WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ExpectedClosingDESC') THEN o.ExpectedClosing
   END DESC,
   CASE
       WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ValueDESC') THEN o.Worth
   END DESC,
   CASE
       WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ValueASC') THEN o.Worth
   END ASC,
   CASE
       WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RatingDESC') THEN o.Rating
   END DESC,
   CASE
       WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RatingASC') THEN o.Rating
   END ASC
  LIMIT p_RowspPage OFFSET v_OffSet_;
  
  SELECT 
  count(*) as totalcount
FROM tblCRMBoards b
INNER JOIN tblCRMBoardColumn bc on bc.BoardID = b.BoardID
  AND (p_BoardID = 0 OR b.BoardID = p_BoardID)
INNER JOIN tblOpportunity o on o.BoardID = b.BoardID
   AND o.BoardColumnID = bc.BoardColumnID
   AND o.CompanyID = p_CompanyID
   AND (o.OpportunityClosed = p_OpportunityClosed)
   AND (p_Tags = '' OR find_in_set(o.Tags,p_Tags))
   AND (p_OpportunityName = '' OR o.OpportunityName LIKE Concat('%',p_OpportunityName,'%'))
   AND (p_OwnerID = '' OR find_in_set(o.`UserID`,p_OwnerID))
   AND (p_AccountID = 0 OR o.AccountID = p_AccountID)
   AND (p_Status = '' OR find_in_set(o.`Status`,p_Status))
   AND (p_CurrencyID = 0 OR p_CurrencyID in (Select CurrencyId FROM tblAccount Where tblAccount.AccountID = o.AccountID))
   AND (1 in (Select `Status` FROM tblAccount Where tblAccount.AccountID = o.AccountID))
   AND (1 in (Select `Status` FROM tblUser Where tblUser.UserID = o.UserID))
INNER JOIN tblAccount ac on o.AccountID = ac.AccountID
 AND ac.`Status` = 1
 AND (p_CurrencyID = 0 OR ac.CurrencyId = p_CurrencyID) 
INNER JOIN tblUser u on o.UserID = u.UserID
	AND u.`Status` = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetRateTableRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetRateTableRate`(
	IN `p_companyid` INT,
	IN `p_RateTableId` INT,
	IN `p_trunkID` INT,
	IN `p_contryID` INT,
	IN `p_code` VARCHAR(50),
	IN `p_description` VARCHAR(50),
	IN `p_effective` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate_;
   CREATE TEMPORARY TABLE tmp_RateTableRate_ (
        ID INT,
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
		  ConnectionFee DECIMAL(18, 6),
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        updated_at DATETIME,
        ModifiedBy VARCHAR(50),
        RateTableRateID INT,
        RateID INT,
        INDEX tmp_RateTableRate_RateID (`RateID`)
    );
    
    
    
    INSERT INTO tmp_RateTableRate_
    SELECT
        RateTableRateID AS ID,
        Code,
        Description,
        ifnull(tblRateTableRate.Interval1,1) as Interval1,
        ifnull(tblRateTableRate.IntervalN,1) as IntervalN,
		  tblRateTableRate.ConnectionFee,
        IFNULL(tblRateTableRate.Rate, 0) as Rate,
        IFNULL(tblRateTableRate.EffectiveDate, NOW()) as EffectiveDate,
        tblRateTableRate.updated_at,
        tblRateTableRate.ModifiedBy,
        RateTableRateID,
        tblRate.RateID
    FROM tblRate
    LEFT JOIN tblRateTableRate
        ON tblRateTableRate.RateID = tblRate.RateID
        AND tblRateTableRate.RateTableId = p_RateTableId
    INNER JOIN tblRateTable
        ON tblRateTable.RateTableId = tblRateTableRate.RateTableId
    WHERE		(tblRate.CompanyID = p_companyid)
		AND (p_contryID = '' OR CountryID = p_contryID)
		AND (p_code = '' OR Code LIKE REPLACE(p_code, '*', '%'))
		AND (p_description = '' OR Description LIKE REPLACE(p_description, '*', '%'))
		AND TrunkID = p_trunkID
		AND (			
			p_effective = 'All' 
		OR (p_effective = 'Now' AND EffectiveDate <= NOW() )
		OR (p_effective = 'Future' AND EffectiveDate > NOW())
			);
	 
	  IF p_effective = 'Now'
		THEN
		   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_RateTableRate4_ as (select * from tmp_RateTableRate_);	        
         DELETE n1 FROM tmp_RateTableRate_ n1, tmp_RateTableRate4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate 
		   AND  n1.RateID = n2.RateID;
		END IF;
	 
    IF p_isExport = 0
    THEN

       SELECT * FROM tmp_RateTableRate_
					ORDER BY CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeDESC') THEN Code
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeASC') THEN Code
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN Description
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN Description
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateDESC') THEN Rate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateASC') THEN Rate
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1DESC') THEN Interval1
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1ASC') THEN Interval1
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNDESC') THEN Interval1
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNASC') THEN Interval1
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateDESC') THEN EffectiveDate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateASC') THEN EffectiveDate
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN updated_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN updated_at
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byDESC') THEN ModifiedBy
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byASC') THEN ModifiedBy
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateTableRateIDDESC') THEN RateTableRateID
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateTableRateIDASC') THEN RateTableRateID
                END ASC,				
				    CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeDESC') THEN ConnectionFee
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeASC') THEN ConnectionFee
                END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;



        SELECT
            COUNT(RateID) AS totalcount
        FROM tmp_RateTableRate_;

        


    END IF;

    IF p_isExport = 1
    THEN

        SELECT
            Code,
            Description,
            Interval1,
            IntervalN,
            ConnectionFee,
            Rate,
            EffectiveDate,
            updated_at,
            ModifiedBy

        FROM   tmp_RateTableRate_;
         

    END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetRecentDueSheet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetRecentDueSheet`(IN `p_companyId` INT , IN `p_isAdmin` INT , IN `p_AccountType` INT, IN `p_DueDate` VARCHAR(10), IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT 
)
BEGIN
	
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;


    DROP TEMPORARY TABLE IF EXISTS tmp_DueSheets_;
    CREATE TEMPORARY TABLE tmp_DueSheets_ (
        AccountID INT,
        AccountName VARCHAR(100),
        Trunk VARCHAR(50),
        EffectiveDate DATE
    );


    IF p_AccountType = 1
    THEN
	  INSERT INTO tmp_DueSheets_
            SELECT DISTINCT
                TBL.AccountID,
                TBL.AccountName,
                TBL.Trunk,
                TBL.EffectiveDate
            FROM (SELECT DISTINCT
                    a.AccountID,
                    a.AccountName,
                    t.Trunk,
					t.TrunkID,
                    vr.EffectiveDate,
					TIMESTAMPDIFF(DAY, vr.EffectiveDate, DATE_FORMAT(NOW(),'%Y-%m-%d')) AS DAYSDIFF
                FROM tblVendorRate vr
				inner join tblVendorTrunk vt on vt.AccountID = vr.AccountId and vt.TrunkID = vr.TrunkID and vt.Status =1
                INNER JOIN tblRate r
                    ON r.RateID = vr.RateID
                INNER JOIN tblCountry c
                    ON c.CountryID = r.CountryID
                INNER JOIN tblAccount a
                    ON a.AccountID = vr.AccountId
                INNER JOIN tblTrunk t
                    ON t.TrunkID = vr.TrunkID
                WHERE a.CompanyId = p_companyId

				AND (
						(p_DueDate = 'Today' AND TIMESTAMPDIFF(DAY, vr.EffectiveDate, NOW()) = 0)
							OR
						(p_DueDate = 'Tomorrow' AND TIMESTAMPDIFF(DAY, vr.EffectiveDate, NOW()) = -1)
							OR
						(p_DueDate = 'Yesterday' AND TIMESTAMPDIFF(DAY, vr.EffectiveDate, NOW()) = 1)
					)
				AND  ((p_isAdmin <> 0 AND a.Owner = p_isAdmin) OR  (p_isAdmin = 0))

				) AS TBL

				Left JOIN tblJob ON tblJob.AccountID = TBL.AccountID
					AND tblJob.JobID IN(select JobID from tblJob where JobTypeID = (select JobTypeID from tblJobType where Code='VD'))
					AND FIND_IN_SET (TBL.TrunkID,JSON_EXTRACT(tblJob.Options, '$.Trunks')) != 0
					AND (
					(p_DueDate = 'Today' AND TIMESTAMPDIFF(DAY, tblJob.created_at, NOW()) = 0)
					OR
					(p_DueDate = 'Yesterday' AND TIMESTAMPDIFF(DAY, tblJob.created_at, NOW()) = DAYSDIFF or TIMESTAMPDIFF(DAY, tblJob.created_at, EffectiveDate)  BETWEEN -1 AND 0)
					)
					where JobStatusID is null or JobStatusID <> (select JobStatusID from tblJobStatus where Code='S');
    END IF;

    IF p_AccountType = 2
    THEN
	  INSERT INTO tmp_DueSheets_
            SELECT  DISTINCT
                TBL.AccountID,
                TBL.AccountName,
                TBL.Trunk,
                TBL.EffectiveDate
            FROM (SELECT DISTINCT
                a.AccountID,
                a.AccountName,
                t.Trunk,
				t.TrunkID,
                cr.EffectiveDate,
				TIMESTAMPDIFF(DAY, cr.EffectiveDate, DATE_FORMAT(NOW(),'%Y-%m-%d')) AS DAYSDIFF
            FROM tblCustomerRate cr
			inner join tblCustomerTrunk ct on ct.AccountID = cr.CustomerID and ct.TrunkID = cr.TrunkID and ct.Status =1
            INNER JOIN tblRate r
                ON r.RateID = cr.RateID
            INNER JOIN tblCountry c
                ON c.CountryID = r.CountryID
            INNER JOIN tblAccount a
                ON a.AccountID = cr.CustomerID
            INNER JOIN tblTrunk t
                ON t.TrunkID = cr.TrunkID
            WHERE a.CompanyId = p_companyId
				AND (
						(p_DueDate = 'Today' AND TIMESTAMPDIFF(DAY, cr.EffectiveDate, NOW()) = 0)
							OR
						(p_DueDate = 'Tomorrow' AND TIMESTAMPDIFF(DAY, cr.EffectiveDate, NOW()) = -1)
							OR
						(p_DueDate = 'Yesterday' AND TIMESTAMPDIFF(DAY, cr.EffectiveDate, NOW()) = 1)
					)
					AND  ((p_isAdmin <> 0 AND a.Owner = p_isAdmin) OR  (p_isAdmin = 0))
			) AS TBL

			LEFT JOIN tblJob ON tblJob.AccountID = TBL.AccountID
					AND tblJob.JobID IN(select JobID from tblJob where JobTypeID = (select JobTypeID from tblJobType where Code='CD'))
					AND FIND_IN_SET (TBL.TrunkID,JSON_EXTRACT(tblJob.Options, '$.Trunks')) != 0
					AND (
					(p_DueDate = 'Today' AND TIMESTAMPDIFF(DAY, tblJob.created_at, NOW()) = 0)
					OR
					(p_DueDate = 'Yesterday' AND TIMESTAMPDIFF(DAY, tblJob.created_at, NOW()) = DAYSDIFF or TIMESTAMPDIFF(DAY, tblJob.created_at, EffectiveDate)  BETWEEN -1 AND 0)
					)
						where JobStatusID is null or JobStatusID <> (select JobStatusID from tblJobStatus where Code='S');

    END IF;

    IF p_isExport = 0
    THEN
        SELECT
            AccountName,
            Trunk,
            EffectiveDate,
            AccountID
        FROM tmp_DueSheets_ AS DueSheets
        ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN AccountName
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN AccountName
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TrunkDESC') THEN Trunk
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TrunkASC') THEN Trunk
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateDESC') THEN EffectiveDate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateASC') THEN EffectiveDate
                END ASC
			LIMIT p_RowspPage OFFSET v_OffSet_;


		SELECT count(AccountName) as totalcount
      FROM tmp_DueSheets_ AS DueSheets;
    END IF;

    IF p_isExport = 1
    THEN
        SELECT
            AccountName,
            Trunk,
            EffectiveDate
        FROM tmp_DueSheets_ TBL;
    END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetRecentDueSheetCronJob` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetRecentDueSheetCronJob`(IN `p_companyId` INT)
BEGIN
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

            SELECT  DISTINCT
                TBL.AccountID,
                TBL.AccountName,
                TBL.Trunk,
                TBL.EffectiveDate,
				TBL.Owner,
				DAYSDIFF,
				'vender' as type
            FROM (SELECT DISTINCT
                    a.AccountID,
                    a.AccountName,
                    t.Trunk,
					t.TrunkID,
                    vr.EffectiveDate,
					a.Owner,
					TIMESTAMPDIFF(DAY,vr.EffectiveDate, NOW()) as DAYSDIFF
                FROM tblVendorRate vr
				inner join tblVendorTrunk vt on vt.AccountID = vr.AccountId and vt.TrunkID = vr.TrunkID and vt.Status =1
                INNER JOIN tblRate r
                    ON r.RateID = vr.RateID
                INNER JOIN tblCountry c
                    ON c.CountryID = r.CountryID
                INNER JOIN tblAccount a
                    ON a.AccountID = vr.AccountId
                INNER JOIN tblTrunk t
                    ON t.TrunkID = vr.TrunkID
                WHERE a.CompanyId = p_companyId

				AND TIMESTAMPDIFF(DAY, vr.EffectiveDate, DATE_FORMAT (NOW(),'%Y-%m-%d')) BETWEEN -1 AND 1

				) AS TBL

				Left JOIN tblJob ON tblJob.AccountID = TBL.AccountID
					AND tblJob.JobTypeID = (select JobTypeID from tblJobType where Code='VD')
					AND FIND_IN_SET (TBL.TrunkID,JSON_EXTRACT(tblJob.Options, '$.Trunks')) != 0
					AND ( TIMESTAMPDIFF(DAY, tblJob.created_at, NOW()) = DAYSDIFF or TIMESTAMPDIFF(DAY, tblJob.created_at, EffectiveDate)  BETWEEN -1 AND 0)
					where JobStatusID is null or JobStatusID <> (select JobStatusID from tblJobStatus where Code='S')

						UNION ALL

            SELECT  DISTINCT
                TBL.AccountID,
                TBL.AccountName,
                TBL.Trunk,
                TBL.EffectiveDate,
				tbl.Owner,
				DAYSDIFF,
				'customer' as type
            FROM (SELECT DISTINCT
                a.AccountID,
                a.AccountName,
				a.Owner,
                t.Trunk,
				t.TrunkID,
                cr.EffectiveDate,
				TIMESTAMPDIFF(DAY,cr.EffectiveDate, NOW()) as DAYSDIFF
            FROM tblCustomerRate cr
			inner join tblCustomerTrunk ct on ct.AccountID = cr.CustomerID and ct.TrunkID = cr.TrunkID and ct.Status =1
            INNER JOIN tblRate r
                ON r.RateID = cr.RateID
            INNER JOIN tblCountry c
                ON c.CountryID = r.CountryID
            INNER JOIN tblAccount a
                ON a.AccountID = cr.CustomerID
            INNER JOIN tblTrunk t
                ON t.TrunkID = cr.TrunkID
            WHERE a.CompanyId = p_companyId
				AND TIMESTAMPDIFF(DAY, cr.EffectiveDate, DATE_FORMAT (NOW(),'%Y-%m-%d')) BETWEEN -1 AND 1
			) AS TBL

			LEFT JOIN tblJob ON tblJob.AccountID = TBL.AccountID
					AND tblJob.JobTypeID = (select JobTypeID from tblJobType where Code='CD')
					AND FIND_IN_SET (TBL.TrunkID,JSON_EXTRACT(tblJob.Options, '$.Trunks')) != 0
					AND ( TIMESTAMPDIFF(DAY, tblJob.created_at, NOW()) = DAYSDIFF or TIMESTAMPDIFF(DAY, tblJob.created_at, EffectiveDate)  BETWEEN -1 AND 0)

						where JobStatusID is null or JobStatusID <> (select JobStatusID from tblJobStatus where Code='S')
						order by Owner,DAYSDIFF,type ASC;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetSkipResourceList` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetSkipResourceList`(IN `p_CompanyID` INT)
BEGIN

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;  
	
	select distinct r.ResourceID,r.ResourceValue,
		case when cs.CompanyID>0
		then
		1
		else
		null
		end As Checked 
	From `tblResource` r left join  `tblCompanySetting` cs on (FIND_IN_SET(r.ResourceID,cs.`Value`) != 0 ) and  r.CompanyID=cs.CompanyID and cs.`Key`='SkipPermissionAction'
		where r.CompanyID=p_CompanyID 
	order by
		 case when cs.CompanyID>0
	 then
		1
     else
	    null
     end
	  desc, r.ResourceValue asc;	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetTasksBoard` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetTasksBoard`(
	IN `p_CompanyID` INT,
	IN `p_BoardID` INT,
	IN `p_TaskName` VARCHAR(50),
	IN `p_UserIDs` VARCHAR(50),
	IN `p_AccountIDs` INT,
	IN `p_Periority` INT,
	IN `p_DueDateFrom` VARCHAR(50),
	IN `p_DueDateTo` VARCHAR(50),
	IN `p_Status` INT,
	IN `p_Closed` INT



)
BEGIN
	DECLARE v_Actve_ int;
	SELECT 1 INTO v_Actve_;
	SELECT 
		bc.BoardColumnID,
		bc.BoardColumnName,
		bc.SetCompleted,
		ts.TaskID,
		ts.UsersIDs,
		(select GROUP_CONCAT( concat(u.FirstName,' ',u.LastName) SEPARATOR ', ') as Users from tblUser u where u.UserID = ts.UsersIDs) as Users,
		ts.AccountIDs,
		(select a.AccountName as company from tblAccount a where a.AccountID = ts.AccountIDs) as company,
		ts.Subject,
		ts.Description,
		Date(ts.DueDate) as DueDate,
		Time(ts.DueDate) as StartTime,
		ts.BoardColumnID as TaskStatus,
		ts.Priority,
		ts.Tags,
		ts.TaggedUsers,
		ts.BoardID,
		concat( u.FirstName,' ',u.LastName) as userName,
		ts.taskClosed
	FROM tblCRMBoards b
	INNER JOIN tblCRMBoardColumn bc on bc.BoardID = b.BoardID
			AND b.BoardID = p_BoardID
	LEFT JOIN tblTask ts on ts.BoardID = b.BoardID
		AND ts.BoardColumnID = bc.BoardColumnID
		AND ts.CompanyID= p_CompanyID
		AND (ts.taskClosed=p_Closed)
		AND (p_TaskName='' OR ts.Subject LIKE Concat('%',p_TaskName,'%'))
		AND (p_UserIDs=0 OR  FIND_IN_SET (ts.UsersIDs,p_UserIDs))
		AND (p_AccountIDs=0 OR ts.AccountIDs=p_AccountIDs)
		AND (p_Periority=0 OR ts.Priority = p_Periority) 
		AND (p_Status=0 OR ts.BoardColumnID=p_Status)
		AND (p_DueDateFrom=0 
				OR (p_DueDateFrom=1 AND (ts.DueDate !='0000-00-00 00:00:00' AND ts.DueDate < NOW() AND bc.SetCompleted=0))
				OR (p_DueDateFrom=2 AND (ts.DueDate !='0000-00-00 00:00:00' AND ts.DueDate >= NOW() AND ts.DueDate <= DATE(DATE_ADD(NOW(), INTERVAL +3 DAY)))) 
				OR ((p_DueDateFrom!='' OR p_DueDateTo!='') AND ts.DueDate BETWEEN STR_TO_DATE(p_DueDateFrom,'%Y-%m-%d %H:%i:%s') AND STR_TO_DATE(p_DueDateTo,'%Y-%m-%d %H:%i:%s'))
			)
		AND (v_Actve_ = (Select MAX(`Status`) FROM tblUser Where tblUser.UserID = ts.UsersIDs))
	LEFT JOIN tblUser u on u.UserID = ts.UsersIDs 
	ORDER BY bc.`Order`,ts.`Order`;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetTasksGrid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetTasksGrid`(
	IN `p_CompanyID` INT,
	IN `p_BoardID` INT,
	IN `p_TaskName` VARCHAR(50),
	IN `p_UserIDs` VARCHAR(50),
	IN `p_AccountIDs` INT,
	IN `p_Periority` INT,
	IN `p_DueDateFrom` VARCHAR(50),
	IN `p_DueDateTo` VARCHAR(50),
	IN `p_Status` INT,
	IN `p_Closed` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(50)






)
BEGIN 
	DECLARE v_OffSet_ int;
	DECLARE v_Active_ int;
   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
   SET SESSION group_concat_max_len = 1024;
   SET v_Active_=1;
	    
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
		
		SELECT 
		bc.BoardColumnID,
		bc.BoardColumnName,
		bc.SetCompleted,
		ts.TaskID,
		ts.UsersIDs,
		(select GROUP_CONCAT( concat(u.FirstName,' ',u.LastName) SEPARATOR ', ') as Users from tblUser u where u.UserID = ts.UsersIDs) as Users,
		ts.AccountIDs,
		(select a.AccountName as company from tblAccount a where a.AccountID = ts.AccountIDs) as company,
		ts.Subject,
		ts.Description,
		Date(ts.DueDate) as DueDate,
		Time(ts.DueDate) as StartTime,
		ts.BoardColumnID as TaskStatus,
		ts.Priority,
		CASE 	WHEN ts.Priority=1 THEN 'High'
			 	WHEN ts.Priority=2 THEN 'Medium'
				WHEN ts.Priority=3 THEN 'Low'
		END as PriorityText,				
		ts.TaggedUsers,
		ts.BoardID,
      concat( u.FirstName,' ',u.LastName) as userName,
      ts.taskClosed
		FROM tblCRMBoards b
		INNER JOIN tblCRMBoardColumn bc on bc.BoardID = b.BoardID
				AND b.BoardID = p_BoardID
		INNER JOIN tblTask ts on ts.BoardID = b.BoardID 
		AND ts.BoardColumnID = bc.BoardColumnID
		AND ts.CompanyID= p_CompanyID
		AND (ts.taskClosed=p_Closed)
		AND (p_TaskName='' OR ts.Subject LIKE Concat('%',p_TaskName,'%'))
		AND (p_UserIDs=0 OR  FIND_IN_SET (ts.UsersIDs,p_UserIDs))
		AND (p_AccountIDs=0 OR ts.AccountIDs=p_AccountIDs)
		AND (p_Periority=0 OR ts.Priority = p_Periority) 
		AND (p_Status=0 OR ts.BoardColumnID=p_Status )
		AND (p_DueDateFrom=0 
				OR (p_DueDateFrom=1 AND (ts.DueDate !='0000-00-00 00:00:00' AND ts.DueDate < NOW() AND bc.SetCompleted=0))
				OR (p_DueDateFrom=2 AND (ts.DueDate !='0000-00-00 00:00:00' AND ts.DueDate >= NOW() AND ts.DueDate <= DATE(DATE_ADD(NOW(), INTERVAL +3 DAY)))) 
				OR ((p_DueDateFrom!='' OR p_DueDateTo!='') AND ts.DueDate BETWEEN STR_TO_DATE(p_DueDateFrom,'%Y-%m-%d %H:%i:%s') AND STR_TO_DATE(p_DueDateTo,'%Y-%m-%d %H:%i:%s'))
			)
		AND (v_Active_ = (Select `Status` FROM tblUser Where tblUser.UserID = ts.UsersIDs limit 1))
		LEFT JOIN tblUser u on u.UserID = ts.UsersIDs
		ORDER BY
		CASE
		     WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'SubjectDESC') THEN ts.Subject
		 END DESC,
		 CASE
		     WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'SubjectASC') THEN ts.Subject
		 END ASC,
		 CASE
		     WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DueDateDESC') THEN ts.DueDate
		 END DESC,
		 CASE
		     WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DueDateASC') THEN ts.DueDate
		 END ASC,
		 CASE
		     WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN bc.`Order`
		 END DESC,
		 CASE
		     WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN bc.`Order`
		 END ASC,
		 CASE
		     WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'UserIDDESC') THEN concat(u.FirstName,' ',u.LastName)
		 END DESC,
		 CASE
		     WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'UserIDASC') THEN concat(u.FirstName,' ',u.LastName)
		 END ASC,
		 CASE
		     WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RelatedToDESC') THEN ts.AccountIDs
		 END DESC,
		 CASE
		     WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RelatedToASC') THEN ts.AccountIDs
		 END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT COUNT(ts.TaskID) as totalcount
		FROM tblCRMBoards b
		INNER JOIN tblCRMBoardColumn bc on bc.BoardID = b.BoardID
				AND b.BoardID = p_BoardID
		INNER JOIN tblTask ts on ts.BoardID = b.BoardID 
		AND ts.BoardColumnID = bc.BoardColumnID
		AND ts.CompanyID= p_CompanyID
		AND (ts.taskClosed=p_Closed)
		AND (p_TaskName='' OR ts.Subject LIKE Concat('%',p_TaskName,'%'))
		AND (p_UserIDs=0 OR  FIND_IN_SET (ts.UsersIDs,p_UserIDs))
		AND (p_Periority=0 OR ts.Priority = p_Periority) 
		AND (p_Status=0 OR ts.BoardColumnID=p_Status )
		AND (p_DueDateFrom=0 
				OR (p_DueDateFrom=1 AND (ts.DueDate !='0000-00-00 00:00:00' AND ts.DueDate < NOW() AND bc.SetCompleted=0))
				OR (p_DueDateFrom=2 AND (ts.DueDate !='0000-00-00 00:00:00' AND ts.DueDate >= NOW() AND ts.DueDate <= DATE(DATE_ADD(NOW(), INTERVAL +2 DAY)))) 
				OR ((p_DueDateFrom!='' OR p_DueDateTo!='') AND ts.DueDate BETWEEN STR_TO_DATE(p_DueDateFrom,'%Y-%m-%d %H:%i:%s') AND STR_TO_DATE(p_DueDateTo,'%Y-%m-%d %H:%i:%s'))
			)
		AND (v_Active_ = (Select `Status` FROM tblUser Where tblUser.UserID = ts.UsersIDs limit 1))
		LEFT JOIN tblUser u on u.UserID = ts.UsersIDs;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetTasksSingle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetTasksSingle`(IN `p_TaskID` INT)
BEGIN
	SELECT 
		t.Subject,
		 group_concat( concat(u.FirstName,' ',u.LastName)separator ',') as Name,		
		 case when t.Priority =1
			  then 'High'
			    else
			  'Low' end as Priority,
			DueDate,
		t.Description,
		bc.BoardColumnName as TaskStatus,
		t.created_at,
		t.Task_type as followup_task,
		t.CreatedBy as created_by,
		t.TaskID
	FROM tblTask t
	INNER JOIN tblCRMBoardColumn bc on  t.BoardColumnID = bc.BoardColumnID	
	INNER JOIN tblUser u on  u.UserID = t.UsersIDs		
	WHERE t.TaskID = p_TaskID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getUsers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getUsers`(
	IN `p_CompanyID` INT,
	IN `p_Status` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_Export` INT


)
BEGIN
     DECLARE v_OffSet_ int;
     SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	      
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	if p_Export = 0
	THEN
	
	select  
	u.Status,
	u.FirstName,
	u.LastName,
	u.EmailAddress,
	CASE WHEN u.AdminUser=1
	then 'Super Admin'
	Else group_concat(DISTINCT r.RoleName ORDER BY r.RoleName ASC SEPARATOR ', ')
	END as Roles,
	u.JobNotification,
	u.UserID	
	 from `tblUser` u 
	left join tblUserRole ur on u.UserID=ur.UserID
	left join tblRole r on ur.RoleID=r.RoleID 	
	where u.CompanyID=p_CompanyID and u.`Status`=p_Status
	group by u.UserID
	order by 
	CASE
                WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN Status
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN Status
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'FirstNameDESC') THEN FirstName
                END DESC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'FirstNameASC') THEN FirstName
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastNameDESC') THEN LastName
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastNameASC') THEN LastName
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EmailAddressDESC') THEN EmailAddress
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EmailAddressASC') THEN EmailAddress
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RoleDESC') THEN AdminUser
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RoleASC') THEN AdminUser
                END ASC
            LIMIT p_RowspPage OFFSET v_OffSet_;
            
         SELECT  			
			COUNT(UserID)	 AS totalcount
		   from `tblUser`
			where CompanyID=p_CompanyID and `Status`=p_Status;

	ELSE

			select  
			u.FirstName,
			u.LastName,
			u.EmailAddress,
			CASE WHEN u.AdminUser=1
			then 'Admin'
			Else group_concat(r.RoleName)
			END as AdminUser,
			u.JobNotification,
			u.UserID	
			 from `tblUser` u 
			left join tblUserRole ur on u.UserID=ur.UserID
			left join tblRole r on ur.RoleID=r.RoleID 	
			where u.CompanyID=p_CompanyID and u.`Status`=p_Status
			group by u.UserID
			order by FirstName ASC;

	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetVendorBlockByCode` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetVendorBlockByCode`(IN `p_companyid` INT , IN `p_AccountID` INT, IN `p_trunkID` INT, IN `p_contryID` INT , IN `p_status` VARCHAR(50) , IN `p_code` VARCHAR(50), IN `p_PageNumber` INT , IN `p_RowspPage` INT , IN `p_lSortCol` VARCHAR(50) , IN `p_SortOrder` VARCHAR(5) , IN `p_isExport` INT)
BEGIN
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
   IF p_isExport = 0
   THEN
   
		SELECT  Distinct
            `tblRate`.RateID
           ,`tblRate`.Code
           ,CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END as Status 
           ,`tblRate`.Description
           ,VendorBlockingId
	    FROM      `tblRate`
       INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId AND AccountID = p_AccountID AND tblVendorRate.TrunkID = p_trunkID   
	    INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId AND tblVendorTrunk.AccountID = p_AccountID AND tblVendorTrunk.TrunkID = p_trunkID   
       LEFT JOIN tblVendorBlocking ON tblVendorBlocking.RateId = tblVendorRate.RateID and tblVendorRate.TrunkID = tblVendorBlocking.TrunkID and tblVendorRate.AccountId = tblVendorBlocking.AccountId
		 WHERE ( p_contryID IS NULL OR tblRate.CountryID = p_contryID)
             AND ( tblRate.CompanyID = p_companyid )
             AND ( p_code IS NULL OR Code LIKE REPLACE(p_code,'*', '%') )
             AND ( p_status = 'All' or ( CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END ) = p_status)  
		 ORDER BY
		 		 	CASE WHEN ( CONCAT(p_lSortCol,p_SortOrder) = 'CodeDESC') THEN Code
					END DESC ,
					CASE WHEN ( CONCAT(p_lSortCol,p_SortOrder) = 'CodeASC') THEN Code
					END ASC ,
					CASE WHEN ( CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN tblRate.Description
					END DESC ,
					CASE WHEN ( CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN tblRate.Description
					END ASC,
					CASE WHEN ( CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN VendorBlockingId
					END DESC,
					CASE WHEN ( CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN VendorBlockingId
					END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;
            
      
		SELECT COUNT(DISTINCT tblRate.RateID) AS totalcount
      FROM    tblRate
      INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId AND AccountID = p_AccountID AND tblVendorRate.TrunkID = p_trunkID   
		INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId AND tblVendorTrunk.AccountID = p_AccountID AND tblVendorTrunk.TrunkID = p_trunkID   
      LEFT JOIN tblVendorBlocking ON tblVendorBlocking.RateId = tblVendorRate.RateID and tblVendorRate.TrunkID = tblVendorBlocking.TrunkID and tblVendorRate.AccountId = tblVendorBlocking.AccountId
      WHERE   ( p_contryID IS NULL OR tblRate.CountryID = p_contryID)
      		AND ( tblRate.CompanyID = p_companyid )
            AND ( p_code IS NULL OR Code LIKE REPLACE(p_code,'*', '%') )
            AND ( p_status = 'All' or ( CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END ) = p_status);  
	END IF;
  
   IF p_isExport = 1
   THEN 
		SELECT Distinct  Code
      		,CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END as Status
            ,tblRate.Description

		FROM    tblRate
      INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId AND AccountID = p_AccountID AND tblVendorRate.TrunkID = p_trunkID   
		INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId AND tblVendorTrunk.AccountID = p_AccountID AND tblVendorTrunk.TrunkID = p_trunkID   
      LEFT JOIN tblVendorBlocking ON tblVendorBlocking.RateId = tblVendorRate.RateID and tblVendorRate.TrunkID = tblVendorBlocking.TrunkID and tblVendorRate.AccountId = tblVendorBlocking.AccountId		
		WHERE   ( p_contryID IS NULL OR tblRate.CountryID = p_contryID)
      		AND ( tblRate.CompanyID = p_companyid )
            AND ( p_code IS NULL OR Code LIKE REPLACE(p_code,'*', '%') )
            AND ( p_status = 'All' or ( CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END ) = p_status)    
		ORDER BY Code,Status  ;                    
   END IF;
   IF p_isExport = 2
   THEN 
		SELECT Distinct  
			    tblRate.RateID as RateID
				,Code
      		,CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END as Status
            ,tblRate.Description

		FROM    tblRate
      INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId AND AccountID = p_AccountID AND tblVendorRate.TrunkID = p_trunkID   
		INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId AND tblVendorTrunk.AccountID = p_AccountID AND tblVendorTrunk.TrunkID = p_trunkID   
      LEFT JOIN tblVendorBlocking ON tblVendorBlocking.RateId = tblVendorRate.RateID and tblVendorRate.TrunkID = tblVendorBlocking.TrunkID and tblVendorRate.AccountId = tblVendorBlocking.AccountId		
		WHERE   ( p_contryID IS NULL OR tblRate.CountryID = p_contryID)
      		AND ( tblRate.CompanyID = p_companyid )
            AND ( p_code IS NULL OR Code LIKE REPLACE(p_code,'*', '%') )
            AND ( p_status = 'All' or ( CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END ) = p_status)    
		ORDER BY Code,Status  ;                    
   END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetVendorBlockByCountry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetVendorBlockByCountry`(IN `p_AccountID` INT, IN `p_trunkID` INT, IN `p_contryID` INT , IN `p_status` VARCHAR(50) , IN `p_PageNumber` INT , IN `p_RowspPage` INT , IN `p_lSortCol` VARCHAR(50) , IN `p_SortOrder` VARCHAR(5) , IN `p_isExport` INT)
BEGIN
       
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;      
		  
	IF p_isExport = 0
   THEN
  
		SELECT 
      	tblCountry.CountryID,
         Country,
         CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END as Status
		FROM      tblCountry
      LEFT JOIN tblVendorBlocking ON tblVendorBlocking.CountryId = tblCountry.CountryID AND TrunkID = p_trunkID AND AccountId = p_AccountID
      WHERE         ( p_contryID IS NULL OR tblCountry.CountryID = p_contryID)
      	AND ( p_status = 'All' or ( CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END ) = p_status)  
      ORDER BY 
	   	CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryDESC') THEN Country
	      END DESC ,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryASC')	THEN Country
	      END ASC ,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN VendorBlockingId
	      END DESC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN VendorBlockingId
	      END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT  COUNT(tblCountry.CountryID) AS totalcount
      FROM    tblCountry
      LEFT JOIN tblVendorBlocking ON tblVendorBlocking.CountryId = tblCountry.CountryID AND TrunkID = p_trunkID AND AccountId = p_AccountID
      WHERE   ( p_contryID IS NULL OR tblCountry.CountryID = p_contryID)
      	AND ( p_status = 'All' or ( CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END ) = p_status);  
	END IF;
  
   IF p_isExport = 1
   THEN 
  
   	SELECT   Country,
      			CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END as Status
		FROM    tblCountry
      LEFT JOIN tblVendorBlocking ON tblVendorBlocking.CountryId = tblCountry.CountryID AND TrunkID = p_trunkID AND AccountId = p_AccountID
      WHERE   ( p_contryID IS NULL OR tblCountry.CountryID = p_contryID)
      	AND ( p_status = 'All' or ( CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END ) = p_status);    
	END IF;
	IF p_isExport = 2
   THEN 
  
   	SELECT   tblCountry.CountryID,
					Country,
      			CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END as Status
		FROM    tblCountry
      LEFT JOIN tblVendorBlocking ON tblVendorBlocking.CountryId = tblCountry.CountryID AND TrunkID = p_trunkID AND AccountId = p_AccountID
      WHERE   ( p_contryID IS NULL OR tblCountry.CountryID = p_contryID)
      	AND ( p_status = 'All' or ( CASE WHEN tblVendorBlocking.VendorBlockingId IS NULL THEN 'Not Blocked' ELSE 'Blocked' END ) = p_status);    
	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorCodeRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorCodeRate`(IN `p_AccountID` INT, IN `p_trunkID` INT, IN `p_RateCDR` INT)
BEGIN
 
	IF p_RateCDR = 0
	THEN 

		DROP TEMPORARY TABLE IF EXISTS tmp_vcodes_;
		CREATE TEMPORARY TABLE tmp_vcodes_ (
			RateID INT,
			Code VARCHAR(50),
			INDEX tmp_vcodes_RateID (`RateID`),
			INDEX tmp_vcodes_Code (`Code`)
		);

		INSERT INTO tmp_vcodes_
		SELECT
		DISTINCT
			tblRate.RateID,
			tblRate.Code
		FROM tblRate
		INNER JOIN tblVendorRate
		ON tblVendorRate.RateID = tblRate.RateID
		WHERE 
			 tblVendorRate.AccountId = p_AccountID
		AND tblVendorRate.TrunkID = p_trunkID
		AND tblVendorRate.EffectiveDate <= NOW();

	END IF;
	
	IF p_RateCDR = 1
	THEN 

		DROP TEMPORARY TABLE IF EXISTS tmp_vcodes_;
		CREATE TEMPORARY TABLE tmp_vcodes_ (
			RateID INT,
			Code VARCHAR(50),
			Rate Decimal(18,6),
			ConnectionFee Decimal(18,6),
			Interval1 INT,
			IntervalN INT,
			INDEX tmp_vcodes_RateID (`RateID`),
			INDEX tmp_vcodes_Code (`Code`)
		);
		
		INSERT INTO tmp_vcodes_
		SELECT
		DISTINCT
			tblRate.RateID,
			tblRate.Code,
			tblVendorRate.Rate,
			tblVendorRate.ConnectionFee,
			tblVendorRate.Interval1,
			tblVendorRate.IntervalN
		FROM tblRate
		INNER JOIN tblVendorRate
		ON tblVendorRate.RateID = tblRate.RateID
		WHERE 
			 tblVendorRate.AccountId = p_AccountID
		AND tblVendorRate.TrunkID = p_trunkID
		AND tblVendorRate.EffectiveDate <= NOW();
	
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetVendorCodes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetVendorCodes`(IN `p_companyid` INT , IN `p_trunkID` INT, IN `p_contryID` VARCHAR(50) , IN `p_code` VARCHAR(50), IN `p_PageNumber` INT , IN `p_RowspPage` INT , IN `p_lSortCol` NVARCHAR(50) , IN `p_SortOrder` NVARCHAR(5) , IN `p_isExport` INT)
BEGIN

	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
        
        IF p_isExport = 0	
		  THEN
		  
		 	 SELECT  RateID,Code FROM(
                                SELECT distinct tblRate.Code as RateID
                                    ,tblRate.Code
                                FROM      tblRate                              
                                WHERE ( tblRate.CompanyID = p_companyid )
                                AND ( p_contryID  = '' OR  FIND_IN_SET(tblRate.CountryID,p_contryID) != 0  )
                                AND ( p_code = '' OR Code LIKE REPLACE(p_code,'*', '%') )
                            ) AS TBL2
            ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeDESC') THEN Code
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeASC') THEN Code
                END ASC
				LIMIT p_RowspPage OFFSET v_OffSet_;    
  
				
				      
                                      
                    
    
		
		
		 Select Count(*) AS totalcount
      FROM
      (
      
            SELECT distinct tblRate.Code 
                                FROM      tblRate                              
                                WHERE ( tblRate.CompanyID = p_companyid )
                                AND ( p_contryID  = '' OR  FIND_IN_SET(tblRate.CountryID,p_contryID) != 0  )
                                AND ( p_code = '' OR Code LIKE REPLACE(p_code,'*', '%') )
		)	AS tbl ;
                    
    END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
       
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetVendorPreference` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetVendorPreference`(IN `p_companyid` INT , IN `p_AccountID` INT, IN `p_trunkID` INT, IN `p_contryID` INT , IN `p_code` VARCHAR(50) , IN `p_description` VARCHAR(50) , IN `p_PageNumber` INT , IN `p_RowspPage` INT , IN `p_lSortCol` VARCHAR(50) , IN `p_SortOrder` VARCHAR(5) , IN `p_isExport` INT )
BEGIN	

		 
		DECLARE v_CodeDeckId_ int;
		DECLARE v_OffSet_ int;
		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
		select CodeDeckId into v_CodeDeckId_  from tblVendorTrunk where AccountID = p_AccountID and TrunkID = p_trunkID;
        
         IF p_isExport = 0
			THEN

				SELECT
				   DISTINCT
					tblRate.RateID,
					Code,
					Preference,
					Description,
					VendorPreferenceID
				FROM  tblVendorRate
				JOIN tblRate
					ON tblVendorRate.RateId = tblRate.RateId
				LEFT JOIN tblVendorPreference 
					ON tblVendorPreference.AccountId = tblVendorRate.AccountId
                    AND tblVendorPreference.TrunkID = tblVendorRate.TrunkID
                    AND tblVendorPreference.RateId = tblVendorRate.RateId
				WHERE (p_contryID IS NULL OR CountryID = p_contryID)
				AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
				AND (p_description IS NULL OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
				AND (tblRate.CompanyID = p_companyid)
				AND tblVendorRate.TrunkID = p_trunkID
				AND tblVendorRate.AccountID = p_AccountID
				AND CodeDeckId = v_CodeDeckId_
				ORDER BY CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeDESC') THEN Code
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeASC') THEN Code
					END ASC,					 
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateDESC') THEN Preference
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateASC') THEN Preference
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'VendorPreferenceIDDESC') THEN VendorPreferenceID
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'VendorPreferenceIDASC') THEN VendorPreferenceID
					END ASC
			LIMIT p_RowspPage OFFSET v_OffSet_;



				SELECT
					COUNT(DISTINCT RateID) AS totalcount
				FROM (SELECT
					tblRate.RateId,
					EffectiveDate
				FROM tblVendorRate
				JOIN tblRate
					ON tblVendorRate.RateId = tblRate.RateId
				LEFT JOIN tblVendorPreference 
					ON tblVendorPreference.AccountId = tblVendorRate.AccountId
                    AND tblVendorPreference.TrunkID = tblVendorRate.TrunkID
                    AND tblVendorPreference.RateId = tblVendorRate.RateId
				WHERE (p_contryID IS NULL
				OR CountryID = p_contryID)
				AND (p_code IS NULL
				OR Code LIKE REPLACE(p_code, '*', '%'))
				AND (p_description IS NULL
				OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
				AND (tblRate.CompanyID = p_companyid)
				AND tblVendorRate.TrunkID = p_trunkID
				AND tblVendorRate.AccountID = p_AccountID
				AND CodeDeckId = v_CodeDeckId_
				
			) AS tbl2;

		END IF;
	
		IF p_isExport = 1
		THEN

			SELECT DISTINCT
				Code,
				tblVendorPreference.Preference,
				Description
			FROM tblVendorRate
			JOIN tblRate
				ON tblVendorRate.RateId = tblRate.RateId
			LEFT JOIN tblVendorPreference 
					ON tblVendorPreference.AccountId = tblVendorRate.AccountId
                    AND tblVendorPreference.TrunkID = tblVendorRate.TrunkID
                    AND tblVendorPreference.RateId = tblVendorRate.RateId
			WHERE (p_contryID IS NULL OR CountryID = p_contryID)
			AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
			AND (p_description IS NULL OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
			AND (tblRate.CompanyID = p_companyid)
			AND tblVendorRate.TrunkID = p_trunkID
			AND tblVendorRate.AccountID = p_AccountID
			AND CodeDeckId = v_CodeDeckId_;
			
		END IF;
		IF p_isExport = 2
		THEN

			SELECT DISTINCT
				tblRate.RateID as RateID,
            Code,
            tblVendorPreference.Preference,
            Description
			FROM tblVendorRate
			JOIN tblRate
				ON tblVendorRate.RateId = tblRate.RateId
			LEFT JOIN tblVendorPreference 
					ON tblVendorPreference.AccountId = tblVendorRate.AccountId
                    AND tblVendorPreference.TrunkID = tblVendorRate.TrunkID
                    AND tblVendorPreference.RateId = tblVendorRate.RateId
			WHERE (p_contryID IS NULL OR CountryID = p_contryID)
			AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
			AND (p_description IS NULL OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
			AND (tblRate.CompanyID = p_companyid)
			AND tblVendorRate.TrunkID = p_trunkID
			AND tblVendorRate.AccountID = p_AccountID
			AND CodeDeckId = v_CodeDeckId_;
			
		END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetVendorRates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetVendorRates`(IN `p_companyid` INT , IN `p_AccountID` INT, IN `p_trunkID` INT, IN `p_contryID` INT , IN `p_code` VARCHAR(50) , IN `p_description` VARCHAR(50) , IN `p_effective` varchar(100), IN `p_PageNumber` INT , IN `p_RowspPage` INT , IN `p_lSortCol` VARCHAR(50) , IN `p_SortOrder` VARCHAR(5) , IN `p_isExport` INT )
BEGIN	
		
 
	DECLARE v_CodeDeckId_ int;
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
		 

		select CodeDeckId into v_CodeDeckId_  from tblVendorTrunk where AccountID = p_AccountID and TrunkID = p_trunkID;
		
		
		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
	   CREATE TEMPORARY TABLE tmp_VendorRate_ (
	        VendorRateID INT,
	        Code VARCHAR(50),
	        Description VARCHAR(200),
			  ConnectionFee DECIMAL(18, 6),
	        Interval1 INT,
	        IntervalN INT,
	        Rate DECIMAL(18, 6),
	        EffectiveDate DATE,
	        updated_at DATETIME,
	        updated_by VARCHAR(50),
	        INDEX tmp_VendorRate_RateID (`Code`)
	    );
	    
	    INSERT INTO tmp_VendorRate_
		 SELECT
					VendorRateID,
					Code,
					tblRate.Description,
					tblVendorRate.ConnectionFee,
					CASE WHEN tblVendorRate.Interval1 IS NOT NULL
					THEN tblVendorRate.Interval1
					ELSE tblRate.Interval1
					END AS Interval1,
					CASE WHEN tblVendorRate.IntervalN IS NOT NULL
					THEN tblVendorRate.IntervalN
					ELSE tblRate.IntervalN
					END AS IntervalN ,
					Rate,
					EffectiveDate,
					tblVendorRate.updated_at,
					tblVendorRate.updated_by
				FROM tblVendorRate
				JOIN tblRate
					ON tblVendorRate.RateId = tblRate.RateId
				WHERE (p_contryID IS NULL
				OR CountryID = p_contryID)
				AND (p_code IS NULL
				OR Code LIKE REPLACE(p_code, '*', '%'))
				AND (p_description IS NULL
				OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
				AND (tblRate.CompanyID = p_companyid)
				AND TrunkID = p_trunkID
				AND tblVendorRate.AccountID = p_AccountID
				AND CodeDeckId = v_CodeDeckId_
				AND
					(
					(p_effective = 'Now' AND EffectiveDate <= NOW() )
					OR 
					(p_effective = 'Future' AND EffectiveDate > NOW())
					);
		IF p_effective = 'Now'
		THEN
		   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate2_ as (select * from tmp_VendorRate_);	        
         DELETE n1 FROM tmp_VendorRate_ n1, tmp_VendorRate2_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate 
		   AND  n1.Code = n2.Code;
		END IF;        
        
		  
		   IF p_isExport = 0
			THEN
		 		SELECT
					VendorRateID,
					Code,
					Description,
					ConnectionFee,
					Interval1,
					IntervalN,
					Rate,
					EffectiveDate,
					updated_at,
					updated_by
					
				FROM  tmp_VendorRate_
				ORDER BY CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeDESC') THEN Code
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeASC') THEN Code
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN Description
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN Description
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateDESC') THEN Rate
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RateASC') THEN Rate
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeDESC') THEN ConnectionFee
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ConnectionFeeASC') THEN ConnectionFee
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1DESC') THEN Interval1
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'Interval1ASC') THEN Interval1
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNDESC') THEN IntervalN
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IntervalNASC') THEN IntervalN
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateDESC') THEN EffectiveDate
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EffectiveDateASC') THEN EffectiveDate
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN updated_at
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN updated_at
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byDESC') THEN updated_by
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_byASC') THEN updated_by
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'VendorRateIDDESC') THEN VendorRateID
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'VendorRateIDASC') THEN VendorRateID
					END ASC
				LIMIT p_RowspPage OFFSET v_OffSet_;



				SELECT
					COUNT(code) AS totalcount
				FROM tmp_VendorRate_;


			END IF;
	
       IF p_isExport = 1
		THEN

			SELECT
				Code,
				Description,
				Rate,
				EffectiveDate,
				updated_at AS `Modified Date`,
				updated_by AS `Modified By`

			FROM tmp_VendorRate_;
		END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_InsertDiscontinuedVendorRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_InsertDiscontinuedVendorRate`(IN `p_AccountId` INT, IN `p_TrunkId` INT)
BEGIN
	 SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		
		
	 	
	 	
	 	
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
		
		
		
		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateDiscontinued_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRateDiscontinued_ (PRIMARY KEY (DiscontinuedID), INDEX tmp_UK_tblVendorRateDiscontinued (AccountId, RateId)) as (select * from tblVendorRateDiscontinued);

		  DELETE n1 FROM tblVendorRateDiscontinued n1, tmp_VendorRateDiscontinued_ n2 WHERE n1.DiscontinuedID < n2.DiscontinuedID
		  	 AND  n1.RateId = n2.RateId
		  	 AND  n1.AccountId = n2.AccountId
			 AND  n1.AccountId = p_AccountId;
	
		
	
		DELETE tblVendorRate
			FROM tblVendorRate
				INNER JOIN(	SELECT dv.VendorRateID FROM tmp_Delete_VendorRate dv) tmdv
					ON tmdv.VendorRateID = tblVendorRate.VendorRateID			
			WHERE tblVendorRate.AccountId = p_AccountId;
									
		CALL prc_ArchiveOldVendorRate(p_AccountId,p_TrunkId);
		
   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_insertUpdateDestinationCode` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_insertUpdateDestinationCode`(IN `p_DestinationGroupID` INT, IN `p_RateID` TEXT, IN `p_CountryID` INT, IN `p_Code` VARCHAR(50), IN `p_Description` VARCHAR(50), IN `p_Action` VARCHAR(50))
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	IF p_Action = 'Insert'
	THEN

		INSERT INTO tblDestinationGroupCode (DestinationGroupID,RateID)
		SELECT p_DestinationGroupID,r.RateID
		FROM tblRate r
		INNER JOIN tblDestinationGroupSet dgs
			ON dgs.CodedeckID =r.CodeDeckId
		INNER JOIN tblDestinationGroup dg
			ON dgs.DestinationGroupSetID = dg.DestinationGroupSetID
		LEFT JOIN tblDestinationGroupCode dgc 
			ON dgc.DestinationGroupID = dg.DestinationGroupID 
			AND r.RateID = dgc.RateID
		WHERE dg.DestinationGroupID = p_DestinationGroupID
		AND (p_RateID = '' OR (p_RateID !='' AND FIND_IN_SET (r.RateID,p_RateID)!= 0 ))
		AND (p_Code = '' OR Code LIKE REPLACE(p_Code, '*', '%'))
		AND (p_Description = '' OR Description LIKE REPLACE(p_Description, '*', '%'))
		AND (p_CountryID = 0 OR r.CountryID = p_CountryID)
		AND dgc.DestinationGroupCodeID IS NULL;

	END IF;
	
	IF p_Action = 'Delete'
	THEN

		DELETE dgc
		FROM tblDestinationGroupCode dgc
		INNER JOIN tblRate r 
			ON r.RateID = dgc.RateID
		INNER JOIN tblDestinationGroup dg
			ON dg.DestinationGroupID = dgc.DestinationGroupID
		WHERE dg.DestinationGroupID = p_DestinationGroupID
		AND (p_RateID = '' OR (p_RateID !='' AND FIND_IN_SET (r.RateID,p_RateID)!= 0 ))
		AND (p_Code = '' OR Code LIKE REPLACE(p_Code, '*', '%'))
		AND (p_Description = '' OR Description LIKE REPLACE(p_Description, '*', '%'))
		AND (p_CountryID = 0 OR r.CountryID = p_CountryID);

	END IF;
	

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_isDiscountPlanApplied` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_isDiscountPlanApplied`(IN `p_Action` VARCHAR(50), IN `p_DestinationGroupSetID` INT, IN `p_DiscountPlanID` INT)
BEGIN
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	IF p_Action = 'DestinationGroupSet'
	THEN
		
		SELECT 
			dgs.DestinationGroupSetID 
		FROM tblDestinationGroupSet dgs
		INNER JOIN tblDiscountPlan dp
			ON dp.DestinationGroupSetID = dgs.DestinationGroupSetID
		INNER JOIN tblAccountDiscountPlan adp
			ON adp.DiscountPlanID = dp.DiscountPlanID
		WHERE dgs.DestinationGroupSetID = p_DestinationGroupSetID;
	
	END IF;
	
	IF p_Action = 'DiscountPlan'
	THEN
		
		SELECT 
			dp.DiscountPlanID 
		FROM tblDiscountPlan dp
		INNER JOIN tblAccountDiscountPlan adp
			ON adp.DiscountPlanID = dp.DiscountPlanID
		WHERE adp.DiscountPlanID = p_DiscountPlanID;
	
	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_LowBalanceReminder` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_LowBalanceReminder`(IN `p_CompanyID` INT, IN `p_AccountID` INT, IN `p_BillingClassID` INT)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	CALL wavetelwholesaleBilling.prc_updateSOAOffSet(p_CompanyID,p_AccountID);
	
	
	SELECT
		IF ( (CASE WHEN ab.BalanceThreshold LIKE '%p' THEN REPLACE(ab.BalanceThreshold, 'p', '')/ 100 * ab.PermanentCredit ELSE ab.BalanceThreshold END) < ab.BalanceAmount AND ab.BalanceThreshold <> 0 ,1,0) as BalanceWarning,
		a.AccountID
	FROM tblAccountBalance ab 
	INNER JOIN tblAccount a 
		ON a.AccountID = ab.AccountID
	INNER JOIN tblAccountBilling abg 
		ON abg.AccountID  = a.AccountID
	INNER JOIN tblBillingClass b
		ON b.BillingClassID = abg.BillingClassID
	WHERE a.CompanyId = p_CompanyID
	AND (p_AccountID = 0 OR  a.AccountID = p_AccountID)
	AND (p_BillingClassID = 0 OR  b.BillingClassID = p_BillingClassID)
	AND ab.PermanentCredit IS NOT NULL
	AND ab.BalanceThreshold IS NOT NULL
	AND a.`Status` = 1;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_ProcessDiscountPlan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_ProcessDiscountPlan`(IN `p_processId` INT, IN `p_tbltempusagedetail_name` VARCHAR(200))
BEGIN
	
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;	
	DECLARE v_AccountID_ INT;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	
	DROP TEMPORARY TABLE IF EXISTS tmp_Accounts_;
	CREATE TEMPORARY TABLE tmp_Accounts_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT
	);
	SET @stm = CONCAT('
	INSERT INTO tmp_Accounts_(AccountID)
	SELECT DISTINCT ud.AccountID FROM wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud 
	INNER JOIN tblAccountDiscountPlan adp
		ON ud.AccountID = adp.AccountID AND Type = 1
	WHERE ProcessID="' , p_processId , '" AND ud.is_inbound = 0;
	');
	
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;	
	
	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_Accounts_);

	WHILE v_pointer_ <= v_rowCount_
	DO

		SET v_AccountID_ = (SELECT AccountID FROM tmp_Accounts_ t WHERE t.RowID = v_pointer_);
		
		
		CALL prc_applyAccountDiscountPlan(v_AccountID_,p_tbltempusagedetail_name,p_processId,0);
		
		SET v_pointer_ = v_pointer_ + 1;
	END WHILE;
	
	
	DROP TEMPORARY TABLE IF EXISTS tmp_Accounts_;
	CREATE TEMPORARY TABLE tmp_Accounts_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT
	);
	SET @stm = CONCAT('
	INSERT INTO tmp_Accounts_(AccountID)
	SELECT DISTINCT ud.AccountID FROM wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud 
	INNER JOIN tblAccountDiscountPlan adp
		ON ud.AccountID = adp.AccountID AND Type = 2
	WHERE ProcessID="' , p_processId , '" AND ud.is_inbound = 1;
	');
	
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_Accounts_);

	WHILE v_pointer_ <= v_rowCount_
	DO

		SET v_AccountID_ = (SELECT AccountID FROM tmp_Accounts_ t WHERE t.RowID = v_pointer_);
		
		
		CALL prc_applyAccountDiscountPlan(v_AccountID_,p_tbltempusagedetail_name,p_processId,1);
		
		SET v_pointer_ = v_pointer_ + 1;
	END WHILE;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_RateDeleteFromCodedeck` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_RateDeleteFromCodedeck`(IN `p_CompanyId` INT, IN `p_CodeDeckId` INT, IN `p_RateID` LONGTEXT, IN `p_CountryId` INT, IN `p_code` VARCHAR(50), IN `p_description` VARCHAR(200))
BEGIN

   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; 
   
	delete tblRate FROM tblRate INNER JOIN(
	  select r.RateID FROM `tblRate` r
		where (r.CompanyID = p_CompanyId)
		AND (r.CodeDeckId = p_CodeDeckId)
		and ( p_RateID ='' OR  FIND_IN_SET(r.RateID, p_RateID) )
		AND (p_CountryId = 0 OR r.CountryID = p_CountryId)
		AND (p_code = '' OR r.Code LIKE REPLACE(p_code, '*', '%'))
		AND (p_description = '' OR r.Description LIKE REPLACE(p_description, '*', '%')))
	  tr on tr.RateID=tblRate.RateID;				
	  
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_RateTableRateInsertUpdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_RateTableRateInsertUpdate`(IN `p_CompanyID` INT, IN `p_RateTableRateID` LONGTEXT
, IN `p_RateTableId` INT 
, IN `p_Rate` DECIMAL(18, 6) 
, IN `p_EffectiveDate` DATETIME
, IN `p_ModifiedBy` VARCHAR(50)
, IN `p_Interval1` INT
, IN `p_IntervalN` INT
, IN `p_ConnectionFee` DECIMAL(18, 6)
, IN `p_Critearea` INT
, IN `p_Critearea_TrunkID` INT
, IN `p_Critearea_CountryID` INT
, IN `p_Critearea_Code` VARCHAR(50)
, IN `p_Critearea_Description` VARCHAR(50)
, IN `p_Critearea_Effective` VARCHAR(50)
, IN `p_Update_EffectiveDate` INT
, IN `p_Update_Rate` INT
, IN `p_Update_Interval1` INT
, IN `p_Update_IntervalN` INT
, IN `p_Update_ConnectionFee` INT
, IN `p_Action` INT
)
BEGIN
              
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    DROP TEMPORARY TABLE IF EXISTS tmp_Update_RateTable_;
    CREATE TEMPORARY TABLE tmp_Update_RateTable_ (
      RateID INT,
      EffectiveDate DATE,
      RateTableRateID INT
    ); 
    
    DROP TEMPORARY TABLE IF EXISTS tmp_Insert_RateTable_;
    CREATE TEMPORARY TABLE tmp_Insert_RateTable_ (
      RateID INT,
      EffectiveDate DATE,
      RateTableRateID INT
    );
    
    DROP TEMPORARY TABLE IF EXISTS tmp_all_RateId_;
    CREATE TEMPORARY TABLE tmp_all_RateId_ (
      RateID INT,
      EffectiveDate DATE,
      RateTableRateID INT
	  );
	 
    
    DROP TEMPORARY TABLE IF EXISTS tmp_RateTable_;
      CREATE TEMPORARY TABLE tmp_RateTable_ (
         RateID INT,
         EffectiveDate DATE,
         RateTableRateID INT,
			INDEX tmp_RateTable_RateId (`RateId`)  
     );
    
   IF p_Critearea = 0
	THEN
 		INSERT INTO tmp_RateTable_
			  SELECT RateID,EffectiveDate,RateTableRateID
			   FROM tblRateTableRate
					WHERE (FIND_IN_SET(RateTableRateID,p_RateTableRateID) != 0 );
	
	END IF;
	
	
	IF p_Critearea = 1
	THEN
		
		
		 INSERT INTO tmp_RateTable_
				SELECT
					 tblRateTableRate.RateID,
                IFNULL(tblRateTableRate.EffectiveDate, NOW()) as EffectiveDate,
                tblRateTableRate.RateTableRateID
            FROM tblRate
            LEFT JOIN tblRateTableRate
                ON tblRateTableRate.RateID = tblRate.RateID
                AND tblRateTableRate.RateTableId = p_RateTableId
            INNER JOIN tblRateTable
                ON tblRateTable.RateTableId = tblRateTableRate.RateTableId
            WHERE		(tblRate.CompanyID = p_CompanyID)
					AND (p_Critearea_CountryID = 0 OR CountryID = p_Critearea_CountryID)
					AND (p_Critearea_Code IS NULL OR Code LIKE REPLACE(p_Critearea_Code, '*', '%'))
					AND (p_Critearea_Description IS NULL OR Description LIKE REPLACE(p_Critearea_Description, '*', '%'))
					AND TrunkID = p_Critearea_TrunkID
					AND (			
							p_Critearea_Effective = 'All' 
						OR (p_Critearea_Effective = 'Now' AND EffectiveDate <= NOW() )
						OR (p_Critearea_Effective = 'Future' AND EffectiveDate > NOW())
						);
		 
		  IF p_Critearea_Effective = 'Now'
		  THEN 
			 CREATE TEMPORARY TABLE IF NOT EXISTS tmp_RateTable4_ as (select * from tmp_RateTable_);	        
          DELETE n1 FROM tmp_RateTable_ n1, tmp_RateTable4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate 
	 	   AND  n1.RateId = n2.RateId;
		  
		  END IF;
		  		  
	END IF;
	
	IF p_action = 1
	THEN
	
	IF p_Update_EffectiveDate = 0
	THEN
	
	INSERT INTO tmp_Update_RateTable_
		SELECT RateID,EffectiveDate,RateTableRateID
			 FROM tmp_RateTable_ ;	
				
	END IF;			
	
	IF p_Update_EffectiveDate = 1
	THEN
	

		INSERT INTO tmp_Update_RateTable_
		SELECT tblRateTableRate.RateID,
				p_EffectiveDate,
				tblRateTableRate.RateTableRateID
			 FROM tblRateTableRate 
			 	INNER JOIN tmp_RateTable_ r on tblRateTableRate.RateID = r.RateID
			 	 WHERE RateTableId = p_RateTableId   
					AND tblRateTableRate.EffectiveDate = p_EffectiveDate;
	
		INSERT INTO tmp_all_RateId_
		SELECT  tblRateTableRate.RateID,
					MAX(tblRateTableRate.EffectiveDate),
					MAX(tblRateTableRate.RateTableRateID)
				 FROM tblRateTableRate
				 	 INNER JOIN tmp_RateTable_ r on tblRateTableRate.RateID = r.RateID
					 	 WHERE tblRateTableRate.RateTableId = p_RateTableId
						  GROUP BY tblRateTableRate.RateID;
	
		INSERT INTO tmp_Insert_RateTable_
		SELECT r.RateID,p_EffectiveDate,r.RateTableRateID
			 FROM tmp_all_RateId_ r
			 	 LEFT JOIN tmp_Update_RateTable_ ur
					 ON r.RateID=ur.RateID
			   WHERE ur.RateID is null ;
				
		
		INSERT INTO tblRateTableRate (
			RateID,
			RateTableId,
			Rate,
			EffectiveDate,
			created_at,
			CreatedBy,
			Interval1,
			IntervalN,
			ConnectionFee
		)
	    SELECT DISTINCT  tr.RateID,
		 						RateTableId,
		 						CASE WHEN p_Update_Rate = 1
									THEN    
										p_Rate									
									ELSE
										tr.Rate
									END
								AS Rate,
								p_EffectiveDate as EffectiveDate,
								NOW() as created_at,
								p_ModifiedBy as CreatedBy,
								CASE WHEN p_Update_Interval1 = 1
									THEN    
										p_Interval1									
									ELSE
										tr.Interval1
									END
								AS Interval1,
								CASE WHEN p_Update_IntervalN = 1
									THEN    
										p_IntervalN									
									ELSE
										tr.IntervalN
									END
								AS IntervalN,
								CASE WHEN p_Update_ConnectionFee = 1
									THEN    
										p_ConnectionFee									
									ELSE
										tr.ConnectionFee
									END
								AS ConnectionFee	
			 FROM tblRateTableRate tr
		   	 INNER JOIN tmp_Insert_RateTable_ r
			 		 ON  r.RateID = tr.RateID
			 		 	AND r.RateTableRateID = tr.RateTableRateID
	   		 		AND  RateTableId = p_RateTableId; 
	
	END IF; 
	
	
	
	SET @stm = '';		
	
	IF p_Update_Rate = 1
	THEN
		SET @stm = CONCAT(@stm,',Rate = ',p_Rate);		
	END IF;	
	
	IF p_Update_Interval1 = 1
	THEN
		SET @stm = CONCAT(@stm,',Interval1 = ',p_Interval1);		
	END IF;	
	
	IF p_Update_IntervalN = 1
	THEN
		SET @stm = CONCAT(@stm,',IntervalN = ',p_IntervalN);		
	END IF;	
	
	IF p_Update_ConnectionFee = 1
	THEN
		SET @stm = CONCAT(@stm,',ConnectionFee = ',p_ConnectionFee);		
	END IF;	
	
	IF @stm != ''
	THEN					
			SET @stm = CONCAT('
							UPDATE tblRateTableRate tr
						    INNER JOIN tmp_Update_RateTable_ r
							 	 ON  r.RateID = tr.RateID 
							 	 	AND r.RateTableRateID = tr.RateTableRateID  
										SET updated_at=NOW(),ModifiedBy="',p_ModifiedBy,'"',@stm,'
								    WHERE  RateTableId = ',p_RateTableId,';
						');
						
			PREPARE stmt FROM @stm;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;
							
	END IF;						
		
	CALL prc_ArchiveOldRateTableRate(p_RateTableId); 
	
	END IF;
	
	IF p_action = 2
	THEN
		DELETE tblRateTableRate
			 FROM tblRateTableRate
				INNER JOIN tmp_RateTable_ 
					ON tblRateTableRate.RateTableRateID = tmp_RateTable_.RateTableRateID;
		
		
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_setAccountDiscountPlan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_setAccountDiscountPlan`(IN `p_AccountID` INT, IN `p_DiscountPlanID` INT, IN `p_Type` INT, IN `p_BillingDays` INT, IN `p_DayDiff` INT, IN `p_CreatedBy` VARCHAR(50))
BEGIN
	
	DECLARE v_AccountDiscountPlanID INT;
	DECLARE v_StartDate DATE;
	DECLARE v_EndDate DATE;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT StartDate,EndDate INTO v_StartDate,v_EndDate FROM tblAccountBillingPeriod WHERE AccountID = p_AccountID AND StartDate <= DATE(NOW()) AND EndDate > DATE(NOW());
	
	INSERT INTO tblAccountDiscountPlanHistory(AccountID,AccountDiscountPlanID,DiscountPlanID,Type,CreatedBy,Applied,Changed,StartDate,EndDate)
	SELECT AccountID,AccountDiscountPlanID,DiscountPlanID,Type,CreatedBy,created_at,NOW(),StartDate,EndDate FROM tblAccountDiscountPlan WHERE AccountID = p_AccountID AND Type = p_Type;
	
	INSERT INTO tblAccountDiscountSchemeHistory (AccountDiscountSchemeID,AccountDiscountPlanID,DiscountID,Threshold,Discount,Unlimited,SecondsUsed)
	SELECT ads.AccountDiscountSchemeID,ads.AccountDiscountPlanID,ads.DiscountID,ads.Threshold,ads.Discount,ads.Unlimited,ads.SecondsUsed 
	FROM tblAccountDiscountScheme ads
	INNER JOIN tblAccountDiscountPlan adp
		ON adp.AccountDiscountPlanID = ads.AccountDiscountPlanID
	WHERE AccountID = p_AccountID 
		AND Type = p_Type;
	
	DELETE ads FROM tblAccountDiscountScheme ads
	INNER JOIN tblAccountDiscountPlan adp
		ON adp.AccountDiscountPlanID = ads.AccountDiscountPlanID
	WHERE AccountID = p_AccountID 
		AND Type = p_Type;
		
	DELETE FROM tblAccountDiscountPlan WHERE AccountID = p_AccountID AND Type = p_Type; 
	
	IF p_DiscountPlanID > 0
	THEN
	 
		INSERT INTO tblAccountDiscountPlan (AccountID,DiscountPlanID,Type,CreatedBy,created_at,StartDate,EndDate)
		VALUES (p_AccountID,p_DiscountPlanID,p_Type,p_CreatedBy,now(),v_StartDate,v_EndDate);
		
		SET v_AccountDiscountPlanID = LAST_INSERT_ID(); 
		
		INSERT INTO tblAccountDiscountScheme(AccountDiscountPlanID,DiscountID,Threshold,Discount,Unlimited)
		SELECT v_AccountDiscountPlanID,d.DiscountID,Threshold*(p_DayDiff/p_BillingDays),Discount,Unlimited
		FROM tblDiscountPlan dp
		INNER JOIN tblDiscount d 
			ON d.DiscountPlanID = dp.DiscountPlanID
		INNER JOIN tblDiscountScheme ds
			ON ds.DiscountID = d.DiscountID
		WHERE dp.DiscountPlanID = p_DiscountPlanID;
	
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_SplitAndInsertVendorRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_SplitAndInsertVendorRate`(IN `TempVendorRateID` INT, IN `Code` VARCHAR(500))
BEGIN

	DECLARE v_First_ INT;
	DECLARE v_Last_ INT;	
		
	SELECT  REPLACE(SUBSTRING(SUBSTRING_INDEX(Code, '-', 1)
                 , LENGTH(SUBSTRING_INDEX(Code, '-', 0)) + 1)
                 , '-'
                 , '') INTO v_First_;
                 
	 SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(Code, '-', 2)
                 , LENGTH(SUBSTRING_INDEX(Code, '-', 1)) + 1)
                 , '-'
                 , '') INTO v_Last_;                 
	
	
   WHILE v_Last_ >= v_First_
	DO
   	 INSERT my_splits VALUES (TempVendorRateID,v_Last_);
	    SET v_Last_ = v_Last_ - 1;
  END WHILE;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_SplitVendorRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_SplitVendorRate`(IN `p_processId` VARCHAR(200), IN `p_dialcodeSeparator` VARCHAR(50))
BEGIN

	DECLARE i INTEGER;
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;	
	DECLARE v_TempVendorRateID_ INT;
	DECLARE v_Code_ VARCHAR(500);	
	DECLARE newcodecount INT(11) DEFAULT 0;
	
	IF p_dialcodeSeparator !='null'
	THEN
	
	
	
	
	
	DROP TEMPORARY TABLE IF EXISTS `my_splits`;
	CREATE TEMPORARY TABLE `my_splits` (
		`TempVendorRateID` INT(11) NULL DEFAULT NULL,
		`Code` Text NULL DEFAULT NULL
	);
    
  SET i = 1;
  REPEAT
    INSERT INTO my_splits (TempVendorRateID, Code)
      SELECT TempVendorRateID , FnStringSplit(Code, p_dialcodeSeparator, i)  FROM tblTempVendorRate
      WHERE FnStringSplit(Code, p_dialcodeSeparator , i) IS NOT NULL
			 AND ProcessId = p_processId;
    SET i = i + 1;
    UNTIL ROW_COUNT() = 0
  END REPEAT;
  
  UPDATE my_splits SET Code = trim(Code);
  
	
  
  
  DROP TEMPORARY TABLE IF EXISTS tmp_newvendor_splite_;
	CREATE TEMPORARY TABLE tmp_newvendor_splite_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		TempVendorRateID INT(11) NULL DEFAULT NULL,
		Code VARCHAR(500) NULL DEFAULT NULL
	);
	
	INSERT INTO tmp_newvendor_splite_(TempVendorRateID,Code)
	SELECT 
		TempVendorRateID,
		Code
	FROM my_splits
	WHERE Code like '%-%'
		AND TempVendorRateID IS NOT NULL;

  
  
	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_newvendor_splite_);
	
	WHILE v_pointer_ <= v_rowCount_
	DO
		SET v_TempVendorRateID_ = (SELECT TempVendorRateID FROM tmp_newvendor_splite_ t WHERE t.RowID = v_pointer_); 
		SET v_Code_ = (SELECT Code FROM tmp_newvendor_splite_ t WHERE t.RowID = v_pointer_);
		
		Call prc_SplitAndInsertVendorRate(v_TempVendorRateID_,v_Code_);
		
	SET v_pointer_ = v_pointer_ + 1;
	END WHILE;
	
	
	
	DELETE FROM my_splits
		WHERE Code like '%-%'
			AND TempVendorRateID IS NOT NULL;

	

	
	
	 INSERT INTO tmp_split_VendorRate_
	SELECT DISTINCT
		   my_splits.TempVendorRateID as `TempVendorRateID`,
		   `CodeDeckId`,
		   my_splits.Code as Code,
		   `Description`,
			`Rate`,
			`EffectiveDate`,
			`Change`,
			`ProcessId`,
			`Preference`,
			`ConnectionFee`,
			`Interval1`,
			`IntervalN`,
			`Forbidden`
		 FROM my_splits
		   INNER JOIN tblTempVendorRate 
				ON my_splits.TempVendorRateID = tblTempVendorRate.TempVendorRateID
		  WHERE	tblTempVendorRate.ProcessId = p_processId;	
		  
	END IF;
	
	IF p_dialcodeSeparator = 'null'
	THEN
	
		INSERT INTO tmp_split_VendorRate_
		SELECT DISTINCT
			  `TempVendorRateID`,
			  `CodeDeckId`,
			   `Code`,
			   `Description`,
				`Rate`,
				`EffectiveDate`,
				`Change`,
				`ProcessId`,
				`Preference`,
				`ConnectionFee`,
				`Interval1`,
				`IntervalN`,
				`Forbidden`
			 FROM tblTempVendorRate
			  WHERE ProcessId = p_processId;	
	
	END IF;	
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_tmpUseTempTable` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_tmpUseTempTable`()
BEGIN

    
 
    
     Call prc_createtemptable();

	select * from tmpSplit;
	
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_UpdateAccountsStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_UpdateAccountsStatus`(IN `p_CompanyID` int, IN `p_userID` int , IN `p_IsVendor` int , IN `p_isCustomer` int , IN `p_VerificationStatus` int, IN `p_AccountNo` VARCHAR(100), IN `p_ContactName` VARCHAR(50), IN `p_AccountName` VARCHAR(50), IN `p_tags` VARCHAR(50), IN `p_low_balance` INT, IN `P_status` INT)
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	UPDATE   tblAccount ta
	LEFT JOIN tblContact tc 
		ON tc.Owner=ta.AccountID
	LEFT JOIN tblAccountBalance abc
		ON abc.AccountID = ta.AccountID
	SET ta.Status = P_status
	WHERE ta.CompanyID = p_CompanyID
		AND ta.AccountType = 1
		AND ta.VerificationStatus = p_VerificationStatus
		AND (p_userID = 0 OR ta.Owner = p_userID)
		AND ((p_IsVendor = 0 OR ta.IsVendor = 1))
		AND ((p_isCustomer = 0 OR ta.IsCustomer = 1))
		AND ((p_AccountNo = '' OR ta.Number like p_AccountNo))
		AND ((p_AccountName = '' OR ta.AccountName like Concat('%',p_AccountName,'%')))
		AND ((p_tags = '' OR ta.tags like Concat(p_tags,'%')))
		AND ((p_ContactName = '' OR (CONCAT(IFNULL(tc.FirstName,'') ,' ', IFNULL(tc.LastName,''))) like Concat('%',p_ContactName,'%')))
		AND (p_low_balance = 0 OR ( p_low_balance = 1 AND abc.PermanentCredit > 0 AND (CASE WHEN abc.BalanceThreshold LIKE '%p' THEN REPLACE(abc.BalanceThreshold, 'p', '')/ 100 * abc.PermanentCredit ELSE abc.BalanceThreshold END) < abc.BalanceAmount) );

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_UpdateFailedJobToPending` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_UpdateFailedJobToPending`(IN `p_JobID` INT)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
 	
 	
 	
 	UPDATE tblJob 
 	SET 
 	
		JobStatusID = ( Select tblJobStatus.JobStatusID from tblJobStatus where tblJobStatus.Code = 'P' ),
		PID = NULL,
		updated_at = now()
 	WHERE 
 	JobID  = p_JobID;
	 
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_UpdateInProgressJobStatusToFail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_UpdateInProgressJobStatusToFail`(IN `p_JobID` INT, IN `p_JobStatusID` INT, IN `p_JobStatusMessage` LONGTEXT, IN `p_UserName` VARCHAR(250))
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
 	
 	
 	
 	
 	IF (SELECT count(*) from tblJob WHERE JobID  = p_JobID 	AND JobStatusID = ( Select tblJobStatus.JobStatusID from tblJobStatus where tblJobStatus.Code = 'I' ) ) = 1
	 THEN
 	
		 	UPDATE tblJob 
		 	SET 
		 	
				JobStatusID = p_JobStatusID,
				PID = NULL,
				ModifiedBy  = p_UserName,
				updated_at = now()
				
		 	WHERE 
		 	JobID  = p_JobID
			AND JobStatusID = ( Select tblJobStatus.JobStatusID from tblJobStatus where tblJobStatus.Code = 'I' );
 	
		 	IF p_JobStatusMessage != '' THEN
		
				UPDATE tblJob 
				SET 
					JobStatusMessage = concat(JobStatusMessage ,'\n' ,p_JobStatusMessage)
				WHERE 
				JobID  = p_JobID;
			 
		 	END IF;

		
   		SELECT '1' as result;
	
	ELSE
	
		SELECT '0' as result;	
		
	END IF;
	
 	
	 
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_UpdatePendingJobToCanceled` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_UpdatePendingJobToCanceled`(IN `p_JobID` INT, IN `p_UserName` VARCHAR(500))
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
 	
 	
 	
 	UPDATE tblJob 
 	SET 
		JobStatusID = ( Select tblJobStatus.JobStatusID from tblJobStatus where tblJobStatus.Code = 'C' ),
		ModifiedBy  = p_UserName,
		JobStatusMessage = concat(  p_UserName , ' has cancelled the job. ', '\n' , JobStatusMessage  ),
		updated_at = now()
 	WHERE 
 	JobID  = p_JobID
 	AND JobStatusID = ( Select tblJobStatus.JobStatusID from tblJobStatus where tblJobStatus.Code = 'P' );
	 
	 
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_VendorBlockByCodeBlock` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_VendorBlockByCodeBlock`(IN `p_AccountId` int , IN `p_Trunk` varchar(50) , IN `p_RateId` int , IN `p_Username` varchar(100)
)
BEGIN
   
   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	IF  (SELECT COUNT(*) FROM tblVendorBlocking WHERE AccountId = p_AccountId AND TrunkID = p_Trunk AND RateId = p_RateId) = 0
	THEN 
	
	  INSERT INTO tblVendorBlocking
	      (
	         `AccountId`        
	         ,`RateId`
	         ,`TrunkID`
	         ,`BlockedBy`
	      )          
	      VALUES (
	        p_AccountId  
	        ,p_RateId
	        ,p_Trunk
	        ,p_Username 
	        );
	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_VendorBlockByCodeUnblock` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_VendorBlockByCodeUnblock`(IN `p_AccountId` int , IN `p_Trunk` varchar(50) , IN `p_RateId` int)
BEGIN
   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;


  
  DELETE FROM `tblVendorBlocking`
   WHERE AccountId = p_AccountId
    AND TrunkID = p_Trunk AND RateId = p_RateId;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_VendorBlockByCountryBlock` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_VendorBlockByCountryBlock`(IN `p_AccountId` int , IN `p_Trunk` varchar(50) , IN `p_CountryId` int , IN `p_Username` varchar(100)
)
BEGIN
  
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
  
	IF  (SELECT COUNT(*) FROM tblVendorBlocking WHERE AccountId = p_AccountId AND TrunkID = p_Trunk AND CountryId = p_CountryId) = 0
	THEN 

		  INSERT INTO tblVendorBlocking
	      (
	         `AccountId`        
	         ,CountryId
	         ,`TrunkID`
	         ,`BlockedBy`
	      )          
	      VALUES (
	        p_AccountId  
	        ,p_CountryId
	        ,p_Trunk
	        ,p_Username 
	        );
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_VendorBlockByCountryUnblock` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_VendorBlockByCountryUnblock`(IN `p_AccountId` int , IN `p_Trunk` varchar(50) , IN `p_CountryId` int)
BEGIN 
  
  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
  DELETE FROM `tblVendorBlocking`
   WHERE AccountId = p_AccountId
    AND TrunkID = p_Trunk AND CountryId = p_CountryId;
    
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_VendorBlockUnblockByAccount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_VendorBlockUnblockByAccount`(IN `p_CompanyId` int, IN `p_AccountId` int, IN `p_code` VARCHAR(50),`p_RateId` longtext,IN `p_CountryId` longtext,IN `p_TrunkID` varchar(50) ,     IN `p_Username` varchar(100),IN `p_action` varchar(100) )
BEGIN
 
  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

  if(p_action ='country_block')
  THEN
		  
			  INSERT INTO tblVendorBlocking
			  (
					 `AccountId`
					 ,CountryId
					 ,`TrunkID`
					 ,`BlockedBy`
			  )
			  SELECT  
				p_AccountId as AccountId
				,tblCountry.CountryID as CountryId
				,p_TrunkID as TrunkID
				,p_Username as BlockedBy
				FROM    tblCountry
				LEFT JOIN tblVendorBlocking ON tblVendorBlocking.CountryId = tblCountry.CountryID AND TrunkID = p_TrunkID AND AccountId = p_AccountId
				WHERE  ( p_CountryId ='' OR  FIND_IN_SET(tblCountry.CountryID, p_CountryId) ) AND tblVendorBlocking.VendorBlockingId is null;
							  
  END IF;
  
  if(p_action ='country_unblock')
  THEN
  
	delete  from tblVendorBlocking 
	WHERE  AccountId = p_AccountId AND TrunkID = p_TrunkID AND ( p_CountryId ='' OR FIND_IN_SET(CountryId, p_CountryId) );
			

  END IF;

  IF(p_action ='code_block')
  THEN
		   
					IF(p_RateId = '' ) 
					THEN
                            
					  INSERT INTO tblVendorBlocking
					  (
						 `AccountId`
						 ,`RateId`
						 ,`TrunkID`
						 ,`BlockedBy`
					  )
					  SELECT tblVendorRate.AccountID, tblVendorRate.RateId ,tblVendorRate.TrunkID,p_Username as BlockedBy
					  FROM    `tblRate`
					  INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId AND tblVendorRate.AccountID = p_AccountId AND tblVendorRate.TrunkID = p_TrunkID
					  INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId AND tblVendorTrunk.AccountID = p_AccountId AND tblVendorTrunk.TrunkID = p_TrunkID
					  LEFT JOIN tblVendorBlocking ON tblVendorBlocking.RateId = tblVendorRate.RateID and tblVendorRate.TrunkID = tblVendorBlocking.TrunkID and tblVendorRate.AccountId = tblVendorBlocking.AccountId
					  WHERE tblVendorBlocking.VendorBlockingId is null AND ( tblRate.CompanyID = p_CompanyId ) AND ( p_code = '' OR  tblRate.Code LIKE REPLACE(p_code,'*', '%') );
						
					ELSE 
     
						  INSERT INTO tblVendorBlocking
						  (
							 `AccountId`
							 ,`RateId`
							 ,`TrunkID`
							 ,`BlockedBy`
						  )
						  SELECT p_AccountId as AccountId, RateID ,p_TrunkID as TrunkID ,p_Username as BlockedBy 
						  FROM tblRate 
						  WHERE FIND_IN_SET(RateId, p_RateId) > 0 AND CompanyID = p_CompanyId;
					 
					  
			 		END IF;				
				
END IF;
 IF(p_action ='code_unblock')
  THEN
 
			IF(p_RateId = ''  ) THEN
			
			     
				delete tblVendorBlocking from tblVendorBlocking 
					INNER JOIN(
						select VendorBlockingId 
						FROM `tblVendorBlocking` vb  
						INNER JOIN 
						(
							SELECT tblRate.RateID ,tblVendorRate.AccountID
								FROM    `tblRate`
							INNER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId AND tblVendorRate.AccountID = p_AccountId AND tblVendorRate.TrunkID = p_TrunkID
							INNER JOIN tblVendorTrunk ON tblVendorTrunk.CodeDeckId = tblRate.CodeDeckId AND tblVendorTrunk.AccountID = p_AccountId AND tblVendorTrunk.TrunkID = p_TrunkID
							LEFT JOIN tblVendorBlocking ON tblVendorBlocking.RateId = tblVendorRate.RateID and tblVendorRate.TrunkID = tblVendorBlocking.TrunkID and tblVendorRate.AccountId = tblVendorBlocking.AccountId
							WHERE ( tblRate.CompanyID = p_CompanyId )
							 AND ( p_code = '' OR tblRate.Code LIKE REPLACE(p_code,'*', '%') )
						) v on v.AccountID = vb.AccountId  AND  vb.RateID = v.RateID  AND vb.TrunkID = p_TrunkID 
						
					)vb2 on vb2.VendorBlockingId=tblVendorBlocking.VendorBlockingId;	

			ELSE 

                    
				delete tblVendorBlocking from tblVendorBlocking WHERE AccountId = p_AccountId AND TrunkID = p_TrunkID AND FIND_IN_SET(RateId, p_RateId) > 0;
				
				
			END IF;	
 
  END IF;
  
  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_VendorBulkRateDelete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_VendorBulkRateDelete`(IN `p_CompanyId` INT
, IN `p_AccountId` INT
, IN `p_TrunkId` INT 
, IN `p_VendorRateIds` TEXT, IN `p_code` varchar(50)
, IN `p_description` varchar(200)
, IN `p_CountryId` INT
, IN `p_effective` VARCHAR(50)
, IN `p_action` INT)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	 
	DROP TEMPORARY TABLE IF EXISTS tmp_Delete_VendorRate;
	CREATE TEMPORARY TABLE tmp_Delete_VendorRate (
     	VendorRateID INT,
      AccountId INT,
      TrunkID INT,
      RateId INT,
      Code VARCHAR(50),
      Description VARCHAR(200),
      Rate DECIMAL(18, 6),
      EffectiveDate DATETIME,
		Interval1 INT,
		IntervalN INT,
		ConnectionFee DECIMAL(18, 6),
		deleted_at DATETIME,
        INDEX tmp_VendorRateDiscontinued_VendorRateID (`VendorRateID`)
	);
	 
	 IF p_action = 1
	 THEN
	 
	  
	 INSERT INTO tmp_Delete_VendorRate(
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
		SELECT
		  VendorRateID,
		  p_AccountId AS AccountId,
		  p_TrunkId AS TrunkID,
		  v.RateId,
		  r.Code,
		  r.Description,
		  Rate,
		  EffectiveDate,
		  v.Interval1,
		  v.IntervalN,
		  ConnectionFee,
		  now() AS deleted_at
		FROM tblVendorRate v
		  INNER JOIN tblRate r
		  		ON r.RateID = v.RateId
		  INNER JOIN tblVendorTrunk vt
		  		ON vt.trunkID = p_TrunkId
				   AND vt.AccountID = p_AccountId
					AND vt.CodeDeckId = r.CodeDeckId
		WHERE 
			((p_CountryId IS NULL) OR (p_CountryId IS NOT NULL AND r.CountryId = p_CountryId))
			AND ((p_code IS NULL) OR (p_code IS NOT NULL AND r.Code like REPLACE(p_code,'*', '%')))
			AND ((p_description IS NULL) OR (p_description IS NOT NULL AND r.Description like REPLACE(p_description,'*', '%')))
		 	AND ((p_effective = 'Now' AND v.EffectiveDate <= NOW() ) OR (p_effective = 'Future' AND v.EffectiveDate> NOW() ) )
		 	AND v.AccountId = p_AccountId
			AND v.TrunkID = p_TrunkId;

	 END IF;
	
	IF p_action = 2
	THEN
		
		
		
			
		 INSERT INTO tmp_Delete_VendorRate(
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
		SELECT
		  VendorRateID,
		  p_AccountId AS AccountId,
		  p_TrunkId AS TrunkID,
		  v.RateId,
		  r.Code,
		  r.Description,
		  Rate,
		  EffectiveDate,
		  v.Interval1,
		  v.IntervalN,
		  ConnectionFee,
		  now() AS deleted_at
		FROM tblVendorRate v
		  INNER JOIN tblRate r
		  		ON r.RateID = v.RateId
		WHERE v.AccountId = p_AccountId
				AND v.TrunkID = p_TrunkId
				AND ((p_VendorRateIds IS NULL) OR FIND_IN_SET(VendorRateID,p_VendorRateIds)!=0)
				;
	END IF; 	
	
	
	
	CALL prc_InsertDiscontinuedVendorRate(p_AccountId,p_TrunkId);
	
		 
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_VendorBulkRateUpdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_VendorBulkRateUpdate`(IN `p_AccountId` INT
, IN `p_TrunkId` INT 
, IN `p_code` varchar(50)
, IN `p_description` varchar(200)
, IN `p_CountryId` INT
, IN `p_CompanyId` INT
, IN `p_Rate` decimal(18,6)
, IN `p_EffectiveDate` DATETIME
, IN `p_ConnectionFee` decimal(18,6)
, IN `p_Interval1` INT
, IN `p_IntervalN` INT
, IN `p_ModifiedBy` varchar(50)
, IN `p_effective` VARCHAR(50)
, IN `p_action` INT)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	IF p_action = 1
	
	THEN
	
	UPDATE tblVendorRate

	INNER JOIN
	( 
	SELECT VendorRateID
	  FROM tblVendorRate v
	  INNER JOIN tblRate r ON r.RateID = v.RateId
	  INNER JOIN tblVendorTrunk vt on vt.trunkID = p_TrunkId AND vt.AccountID = p_AccountId AND vt.CodeDeckId = r.CodeDeckId
	 WHERE 
	 ((p_CountryId IS NULL) OR (p_CountryId IS NOT NULL AND r.CountryId = p_CountryId))
	 AND ((p_code IS NULL) OR (p_code IS NOT NULL AND r.Code like REPLACE(p_code,'*', '%')))
	 AND ((p_description IS NULL) OR (p_description IS NOT NULL AND r.Description like REPLACE(p_description,'*', '%')))
	 AND  ((p_effective = 'Now' and v.EffectiveDate <= NOW() ) OR (p_effective = 'Future' and v.EffectiveDate> NOW() ) )
	 AND v.AccountId = p_AccountId AND v.TrunkID = p_TrunkId
	 ) vr 
	 ON vr.VendorRateID = tblVendorRate.VendorRateID
	 	SET 
		Rate = p_Rate, 
		EffectiveDate = p_EffectiveDate,
		Interval1 = p_Interval1, 
		IntervalN = p_IntervalN,
		updated_by = p_ModifiedBy,
		ConnectionFee = p_ConnectionFee,
		updated_at = NOW(); 
 	END IF;

	 CALL prc_ArchiveOldVendorRate(p_AccountId,p_TrunkId);

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_VendorPreferenceUpdateBySelectedRateId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_VendorPreferenceUpdateBySelectedRateId`(IN `p_CompanyId` INT, IN `p_AccountId` LONGTEXT , IN `p_RateIDList` LONGTEXT , IN `p_TrunkId` VARCHAR(100) , IN `p_Preference` INT, IN `p_ModifiedBy` VARCHAR(50)
, IN `p_contryID` INT, IN `p_code` VARCHAR(50), IN `p_description` VARCHAR(50), IN `p_action` INT)
BEGIN


	DECLARE v_CodeDeckId_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
 
	select CodeDeckId into v_CodeDeckId_  from tblVendorTrunk where AccountID = p_AccountID and TrunkID = p_trunkID;
	
	IF p_action = 0
	THEN	
			  DROP TEMPORARY TABLE IF EXISTS tblVendorRate_;
			  CREATE TEMPORARY TABLE tblVendorRate_  (
				RateID INT(11),				
				INDEX tmp_RateID (`RateID`) 
			  );
			  
			  INSERT INTO tblVendorRate_
			  SELECT RateID from tblRate 
				where FIND_IN_SET(RateID,p_RateIDList);
			  
			  SELECT *FROM	tblVendorRate_;
	END IF; 	
	
	IF p_action = 1
	THEN	
			DROP TEMPORARY TABLE IF EXISTS tblVendorRate_;
			  CREATE TEMPORARY TABLE tblVendorRate_  (
				RateID INT(11),
				INDEX tmp_RateID (`RateID`) 
			  );
  
			INSERT INTO tblVendorRate_
			SELECT 
				tblRate.RateID as RateID
			FROM tblVendorRate
			JOIN tblRate
				ON tblVendorRate.RateId = tblRate.RateId
			LEFT JOIN tblVendorPreference 
					ON tblVendorPreference.AccountId = tblVendorRate.AccountId
                    AND tblVendorPreference.TrunkID = tblVendorRate.TrunkID
                    AND tblVendorPreference.RateId = tblVendorRate.RateId
			WHERE (p_contryID IS NULL OR CountryID = p_contryID)
			AND (p_code IS NULL OR Code LIKE REPLACE(p_code, '*', '%'))
			AND (p_description IS NULL OR tblRate.Description LIKE REPLACE(p_description, '*', '%'))
			AND (tblRate.CompanyID = p_companyid)
			AND tblVendorRate.TrunkID = p_trunkID
			AND tblVendorRate.AccountID = p_AccountID
			AND CodeDeckId = v_CodeDeckId_;
	END IF;			
			
			UPDATE  tblVendorPreference v
		    INNER JOIN (
			select  tvp.VendorPreferenceID,tvp.RateId from tblVendorPreference tvp
			LEFT JOIN tblVendorRate_ vr on tvp.RateId = vr.RateID  			
			  where tvp.AccountId = p_AccountId
				and tvp.TrunkID = p_TrunkId
				and vr.RateID IS NOT NULL
		    )vp on vp.VendorPreferenceID = v.VendorPreferenceID
			SET Preference = p_Preference;
			
			INSERT  INTO tblVendorPreference
		   (  RateID ,
			AccountId ,
			  TrunkID ,
			  Preference,
			  CreatedBy,
			  created_at
		   )
		   
		   SELECT  DISTINCT
			 vr.RateID,
			 p_AccountId ,
			 p_TrunkId,
			 p_Preference ,
			 p_ModifiedBy,
			 NOW()
			 from tblVendorRate_ vr 
			 LEFT JOIN tblVendorPreference vp 
				ON vr.RateID = vp.RateID and vp.AccountId = p_AccountId and vp.TrunkID = p_TrunkId 
				where vp.RateID is null;
				
			IF p_Preference = 0
			THEN		
			delete tblVendorPreference FROM tblVendorPreference INNER JOIN(
				select vr.RateId FROM tblVendorRate_ vr)
				tr on tr.RateId=tblVendorPreference.RateID WHERE tblVendorPreference.AccountId = p_AccountId
	            AND tblVendorPreference.TrunkID = p_TrunkId;		
			END IF;	
	
			
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSCronJobDeleteOldCustomerRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSCronJobDeleteOldCustomerRate`()
BEGIN
     
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

   DELETE cr
   FROM tblCustomerRate cr
   INNER JOIN tblCustomerRate cr2
   ON cr2.CustomerID = cr.CustomerID
   AND cr2.TrunkID = cr.TrunkID
   AND cr2.RateID = cr.RateID
   WHERE   cr.EffectiveDate <= NOW() AND cr2.EffectiveDate <= NOW() AND cr.EffectiveDate < cr2.EffectiveDate;

    DROP TEMPORARY TABLE IF EXISTS _tmp_ArchiveOldEffectiveRates;
   CREATE TEMPORARY TABLE _tmp_ArchiveOldEffectiveRates (
    	  RowID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
     	  CustomerRateID INT,
        RateID INT,
        CustomerID INT,
        TrunkId INT,
        Rate DECIMAL(18, 6),
        EffectiveDate DATETIME,
        INDEX _tmp_ArchiveOldEffectiveRates_CustomerRateID (`CustomerRateID`,`RateID`,`TrunkId`)
	);
	DROP TEMPORARY TABLE IF EXISTS _tmp_ArchiveOldEffectiveRates2;
	CREATE TEMPORARY TABLE _tmp_ArchiveOldEffectiveRates2 (
    	  RowID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
     	  CustomerRateID INT,
        RateID INT,
        CustomerID INT,
        TrunkId INT,
        Rate DECIMAL(18, 6),
        EffectiveDate DATETIME,
       INDEX _tmp_ArchiveOldEffectiveRates_CustomerRateID (`CustomerRateID`,`RateID`,`TrunkId`)
	);
    
   INSERT INTO _tmp_ArchiveOldEffectiveRates (CustomerRateID,RateID,CustomerID,TrunkID,Rate,EffectiveDate)	
	SELECT
	   cr.CustomerRateID,
	   cr.RateID,
	   cr.CustomerID,
	   cr.TrunkID,
	   cr.Rate,
	   cr.EffectiveDate
	FROM tblCustomerRate cr
	ORDER BY cr.CustomerID ASC,cr.TrunkID ASC,cr.RateID ASC,EffectiveDate ASC;
	
	INSERT INTO _tmp_ArchiveOldEffectiveRates2
	SELECT * FROM _tmp_ArchiveOldEffectiveRates;

    DELETE tblCustomerRate
        FROM tblCustomerRate
        INNER JOIN(
        SELECT
            tt.CustomerRateID
        FROM _tmp_ArchiveOldEffectiveRates t
        INNER JOIN _tmp_ArchiveOldEffectiveRates2 tt
        ON tt.RowID = t.RowID + 1
            AND  t.CustomerId = tt.CustomerId
			   AND  t.TrunkId = tt.TrunkId
            AND t.RateID = tt.RateID
            AND t.Rate = tt.Rate) aold on aold.CustomerRateID = tblCustomerRate.CustomerRateID;
            
   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;         
	            
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSCronJobDeleteOldRateSheetDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSCronJobDeleteOldRateSheetDetails`()
BEGIN
     
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    DELETE tblRateSheetDetails
    FROM tblRateSheetDetails
    INNER JOIN
    (
       SELECT
				DISTINCT
            rs.RateSheetID
         FROM tblRateSheet rs,tblRateSheet rs2
         WHERE rs.CustomerID = rs2.CustomerID
         AND rs.`Level` = rs2.`Level`
         AND rs.RateSheetID < rs2.RateSheetID 
    ) tbl ON tblRateSheetDetails.RateSheetID = tbl.RateSheetID;
        
   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSCronJobDeleteOldRateTableRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSCronJobDeleteOldRateTableRate`()
BEGIN
    
	 SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; 

   DELETE rtr
      FROM tblRateTableRate rtr
      INNER JOIN tblRateTableRate rtr2
      ON rtr.RateTableId = rtr2.RateTableId
      AND rtr.RateID = rtr2.RateID
      WHERE rtr.EffectiveDate <= NOW()
			AND rtr2.EffectiveDate <= NOW()
         AND rtr.EffectiveDate < rtr2.EffectiveDate;
            
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;            

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSCronJobDeleteOldVendorRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSCronJobDeleteOldVendorRate`()
BEGIN
 	 SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
  
   DELETE vr
      FROM tblVendorRate vr
      INNER JOIN tblVendorRate vr2
      ON vr2.AccountId = vr.AccountId
      AND vr2.TrunkID = vr.TrunkID
      AND vr2.RateID = vr.RateID
      WHERE   vr.EffectiveDate <= NOW()
			AND  vr2.EffectiveDate <= NOW()
         AND vr.EffectiveDate < vr2.EffectiveDate;
	
   DROP TEMPORARY TABLE IF EXISTS _tmp_ArchiveOldEffectiveRates;
   CREATE TEMPORARY TABLE _tmp_ArchiveOldEffectiveRates (
    	  RowID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
     	  VendorRateID INT,
        RateID INT,
        CustomerID INT,
        TrunkId INT,
        Rate DECIMAL(18, 6),
        EffectiveDate DATETIME,
        INDEX _tmp_ArchiveOldEffectiveRates_VendorRateID (`VendorRateID`,`RateID`,`TrunkId`,`CustomerID`)
	);
	DROP TEMPORARY TABLE IF EXISTS _tmp_ArchiveOldEffectiveRates2;
	CREATE TEMPORARY TABLE _tmp_ArchiveOldEffectiveRates2 (
    	  RowID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
     	  VendorRateID INT,
        RateID INT,
        CustomerID INT,
        TrunkId INT,
        Rate DECIMAL(18, 6),
        EffectiveDate DATETIME,
       INDEX _tmp_ArchiveOldEffectiveRates_VendorRateID (`VendorRateID`,`RateID`,`TrunkId`,`CustomerID`)
	);

    
   INSERT INTO _tmp_ArchiveOldEffectiveRates (VendorRateID,RateID,CustomerID,TrunkID,Rate,EffectiveDate)	
	SELECT
	   VendorRateID,
	   RateID,
	   AccountId,
	   TrunkID,
	   Rate,
	   EffectiveDate
	FROM tblVendorRate 
 	ORDER BY AccountId ASC,TrunkID ,RateID ASC,EffectiveDate ASC;
	
	INSERT INTO _tmp_ArchiveOldEffectiveRates2
	SELECT * FROM _tmp_ArchiveOldEffectiveRates;

    DELETE tblVendorRate
        FROM tblVendorRate
        INNER JOIN(
        SELECT
            tt.VendorRateID
        FROM _tmp_ArchiveOldEffectiveRates t
        INNER JOIN _tmp_ArchiveOldEffectiveRates2 tt
            ON tt.RowID = t.RowID + 1
            AND  t.CustomerID = tt.CustomerID
			   AND  t.TrunkId = tt.TrunkId
            AND t.RateID = tt.RateID
            AND t.Rate = tt.Rate) aold on aold.VendorRateID = tblVendorRate.VendorRateID;
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSDeleteOldRateSheetDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSDeleteOldRateSheetDetails`(IN `p_LatestRateSheetID` INT , IN `p_customerID` INT , IN `p_rateSheetCategory` VARCHAR(50)
)
BEGIN
		SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
        
        DELETE  tblRateSheetDetails
        FROM    tblRateSheetDetails
                JOIN tblRateSheet ON tblRateSheet.RateSheetID = tblRateSheetDetails.RateSheetID
        WHERE   CustomerID = p_customerID
                AND Level = p_rateSheetCategory
                AND tblRateSheetDetails.RateSheetID <> p_LatestRateSheetID; 
      SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
                
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSGenerateRateSheet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSGenerateRateSheet`(IN `p_CustomerID` INT, IN `p_Trunk` VARCHAR(100)
)
BEGIN
    DECLARE v_trunkDescription_ VARCHAR(50);
    DECLARE v_lastRateSheetID_ INT ;
    DECLARE v_IncludePrefix_ TINYINT;
    DECLARE v_Prefix_ VARCHAR(50);
    DECLARE v_codedeckid_  INT;
    DECLARE v_ratetableid_ INT;
    DECLARE v_RateTableAssignDate_  DATETIME;
    DECLARE v_NewA2ZAssign_ INT;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;


       SELECT trunk INTO v_trunkDescription_
         FROM   tblTrunk
         WHERE  TrunkID = p_Trunk;

    DROP TEMPORARY TABLE IF EXISTS tmp_RateSheetRate_;
    CREATE TEMPORARY TABLE tmp_RateSheetRate_(
        RateID        INT,
        Destination   VARCHAR(200),
        Codes         VARCHAR(50),
        Interval1     INT,
        IntervalN     INT,
        Rate          DECIMAL(18, 6),
        `level`         VARCHAR(10),
        `change`        VARCHAR(50),
        EffectiveDate  DATE,
			  INDEX tmp_RateSheetRate_RateID (`RateID`)
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates_;
    CREATE TEMPORARY TABLE tmp_CustomerRates_ (
        RateID INT,
        Interval1 INT,
        IntervalN  INT,
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        LastModifiedDate DATETIME,
        INDEX tmp_CustomerRates_RateId (`RateID`)
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate_;
    CREATE TEMPORARY TABLE tmp_RateTableRate_ (
        RateID INT,
        Interval1 INT,
        IntervalN  INT,
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        updated_at DATETIME,
        INDEX tmp_RateTableRate_RateId (`RateID`)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_RateSheetDetail_;
    CREATE TEMPORARY TABLE tmp_RateSheetDetail_ (
        ratesheetdetailsid int,
        RateID int ,
        RateSheetID int,
        Destination varchar(200),
        Code varchar(50),
        Rate DECIMAL(18, 6),
        `change` varchar(50),
        EffectiveDate Date,
			  INDEX tmp_RateSheetDetail_RateId (`RateID`,`RateSheetID`)
    );
    SELECT RateSheetID INTO v_lastRateSheetID_
    FROM   tblRateSheet
    WHERE  CustomerID = p_CustomerID
        AND level = v_trunkDescription_
    ORDER  BY RateSheetID DESC LIMIT 1 ;

    SELECT includeprefix INTO v_IncludePrefix_
    FROM   tblCustomerTrunk
    WHERE  AccountID = p_CustomerID
      AND TrunkID = p_Trunk;

    SELECT prefix INTO v_Prefix_
    FROM   tblCustomerTrunk
    WHERE  AccountID = p_CustomerID
      AND TrunkID = p_Trunk;


    SELECT
        CodeDeckId,
        RateTableID,
        RateTableAssignDate
        INTO v_codedeckid_, v_ratetableid_, v_RateTableAssignDate_
    FROM tblCustomerTrunk
    WHERE tblCustomerTrunk.TrunkID = p_Trunk
    AND tblCustomerTrunk.AccountID = p_CustomerID
    AND tblCustomerTrunk.Status = 1;

  INSERT INTO tmp_CustomerRates_
      SELECT  RateID,
              Interval1,
              IntervalN,
              tblCustomerRate.Rate,
              effectivedate,
              lastmodifieddate
      FROM   tblAccount
         JOIN tblCustomerRate
           ON tblAccount.AccountID = tblCustomerRate.CustomerID
      WHERE  tblAccount.AccountID = p_CustomerID
          AND tblCustomerRate.Rate > 0
         AND tblCustomerRate.TrunkID = p_Trunk
         ORDER BY tblCustomerRate.CustomerID,tblCustomerRate.TrunkID,tblCustomerRate.RateID,tblCustomerRate.EffectiveDate DESC;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates4_;
	DROP TEMPORARY TABLE IF EXISTS tmp_CustomerRates2_;
	
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_CustomerRates4_ as (select * from tmp_CustomerRates_);
   DELETE n1 FROM tmp_CustomerRates_ n1, tmp_CustomerRates4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
   AND  n1.RateId = n2.RateId;

   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_CustomerRates2_ as (select * from tmp_CustomerRates_);

	INSERT INTO tmp_RateTableRate_
		SELECT
			tblRateTableRate.RateID,
         tblRateTableRate.Interval1,
         tblRateTableRate.IntervalN,
         tblRateTableRate.Rate,         
         tblRateTableRate.EffectiveDate,
         tblRateTableRate.updated_at
      FROM tblAccount
      JOIN tblCustomerTrunk
           ON tblCustomerTrunk.AccountID = tblAccount.AccountID
      JOIN tblRateTable
           ON tblCustomerTrunk.ratetableid = tblRateTable.ratetableid
      JOIN tblRateTableRate
           ON tblRateTableRate.ratetableid = tblRateTable.ratetableid
      LEFT JOIN tmp_CustomerRates_ trc1
            ON trc1.RateID = tblRateTableRate.RateID
      WHERE  tblAccount.AccountID = p_CustomerID
         AND tblRateTableRate.Rate > 0
         AND tblCustomerTrunk.TrunkID = p_Trunk
         AND (( tblRateTableRate.EffectiveDate <= Now()
             AND ( ( trc1.RateID IS NULL )
                OR ( trc1.RateID IS NOT NULL
                   AND tblRateTableRate.ratetablerateid IS NULL )
              ) )
          OR ( tblRateTableRate.EffectiveDate > Now()
             AND ( ( trc1.RateID IS NULL )
                OR ( trc1.RateID IS NOT NULL
                   AND tblRateTableRate.EffectiveDate < (SELECT
									   IFNULL(MIN(crr.EffectiveDate),
									   tblRateTableRate.EffectiveDate)
										  FROM   tmp_CustomerRates2_ crr
										  WHERE  crr.RateID =
					   tblRateTableRate.RateID
                      ) ) ) ) )
      ORDER BY tblRateTableRate.RateID,tblRateTableRate.EffectiveDate desc;

	DROP TEMPORARY TABLE IF EXISTS tmp_RateTableRate4_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_RateTableRate4_ as (select * from tmp_RateTableRate_);
   DELETE n1 FROM tmp_RateTableRate_ n1, tmp_RateTableRate4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
   AND  n1.RateId = n2.RateId;

    INSERt INTO tmp_RateSheetDetail_
      SELECT ratesheetdetailsid,
                     RateID,
                     RateSheetID,
                     Destination,
                     Code,
                     Rate,
                     `change`,
                     effectivedate
              FROM   tblRateSheetDetails
              WHERE  RateSheetID = v_lastRateSheetID_
          ORDER BY RateID,effectivedate desc;

	DROP TEMPORARY TABLE IF EXISTS tmp_RateSheetDetail4_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_RateSheetDetail4_ as (select * from tmp_RateSheetDetail_);
   DELETE n1 FROM tmp_RateSheetDetail_ n1, tmp_RateSheetDetail4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
   AND  n1.RateId = n2.RateId;

      
      DROP TABLE IF EXISTS tmp_CloneRateSheetDetail_ ;
      CREATE TEMPORARY TABLE tmp_CloneRateSheetDetail_ LIKE tmp_RateSheetDetail_;
      INSERT tmp_CloneRateSheetDetail_ SELECT * FROM tmp_RateSheetDetail_;


      INSERT INTO tmp_RateSheetRate_
      SELECT tbl.RateID,
             description,
             Code,
             tbl.Interval1,
             tbl.IntervalN,
             tbl.Rate,
             v_trunkDescription_,
             'NEW' as `change`,
             tbl.EffectiveDate
      FROM   (
			SELECT
				rt.RateID,				
				rt.Interval1,
				rt.IntervalN,
				rt.Rate,
				rt.EffectiveDate
         FROM   tmp_RateTableRate_ rt
         LEFT JOIN tblRateSheet
         	ON tblRateSheet.RateSheetID =
            	v_lastRateSheetID_
         LEFT JOIN tmp_RateSheetDetail_ as  rsd
         	ON rsd.RateID = rt.RateID AND rsd.RateSheetID = v_lastRateSheetID_
			WHERE  rsd.ratesheetdetailsid IS NULL

			UNION

			SELECT
				trc2.RateID,            
            trc2.Interval1,
            trc2.IntervalN,
            trc2.Rate,
            trc2.EffectiveDate
         FROM   tmp_CustomerRates_ trc2
         LEFT JOIN tblRateSheet
         	ON tblRateSheet.RateSheetID =
         		v_lastRateSheetID_
         LEFT JOIN tmp_CloneRateSheetDetail_ as  rsd2
         	ON rsd2.RateID = trc2.RateID AND rsd2.RateSheetID = v_lastRateSheetID_
			WHERE  rsd2.ratesheetdetailsid IS NULL

			) AS tbl
      INNER JOIN tblRate
      	ON tbl.RateID = tblRate.RateID;

      INSERT INTO tmp_RateSheetRate_
      SELECT tbl.RateID,
             description,
             Code,
             tbl.Interval1,
             tbl.IntervalN,
             tbl.Rate,
             v_trunkDescription_,
             tbl.`change`,
             tbl.EffectiveDate
      FROM   (SELECT rt.RateID,
                     description,
                     tblRate.Code,
                     rt.Interval1,
                     rt.IntervalN,
                     rt.Rate,
                     rsd5.Rate AS rate2,
                     rt.EffectiveDate,
                     CASE
                                WHEN rsd5.Rate > rt.Rate
                                     AND rsd5.Destination !=
                                         description THEN
                                'NAME CHANGE & DECREASE'
                                ELSE
                                  CASE
                                    WHEN rsd5.Rate > rt.Rate
                                         AND rt.EffectiveDate <= Now() THEN
                                    'DECREASE'
                                    ELSE
                                      CASE
                                        WHEN ( rsd5.Rate >
                                               rt.Rate
                                               AND rt.EffectiveDate > Now()
                                             )
                                      THEN
                                        'PENDING DECREASE'
                                        ELSE
                                          CASE
                                            WHEN ( rsd5.Rate <
                                                   rt.Rate
                                                   AND rt.EffectiveDate <=
                                                       Now() )
                                          THEN
                                            'INCREASE'
                                            ELSE
                                              CASE
                                                WHEN ( rsd5.Rate
                                                       <
                                                       rt.Rate
                                                       AND rt.EffectiveDate >
                                                           Now() )
                                              THEN
                                                'PENDING INCREASE'
                                                ELSE
                                                  CASE
                                                    WHEN
                                              rsd5.Destination !=
                                              description THEN
                                                    'NAME CHANGE'
                                                    ELSE 'NO CHANGE'
                                                  END
                                              END
                                          END
                                      END
                                  END
                              END as `Change`
              FROM   tblRate
                     INNER JOIN tmp_RateTableRate_ rt
                             ON rt.RateID = tblRate.RateID
                     INNER JOIN tblRateSheet
                             ON tblRateSheet.RateSheetID = v_lastRateSheetID_
                     INNER JOIN tmp_RateSheetDetail_ as  rsd5
                             ON rsd5.RateID = rt.RateID
                                AND rsd5.RateSheetID =
                                    v_lastRateSheetID_
              UNION
              SELECT trc4.RateID,
                     description,
                     tblRate.Code,
                     trc4.Interval1,
                     trc4.IntervalN,
                     trc4.Rate,
                     rsd6.Rate AS rate2,
                     trc4.EffectiveDate,
                     CASE
                                WHEN rsd6.Rate > trc4.Rate
                                     AND rsd6.Destination !=
                                         description THEN
                                'NAME CHANGE & DECREASE'
                                ELSE
                                  CASE
                                    WHEN rsd6.Rate > trc4.Rate
                                         AND trc4.EffectiveDate <= Now() THEN
                                    'DECREASE'
                                    ELSE
                                      CASE
                                        WHEN ( rsd6.Rate >
                                               trc4.Rate
                                               AND trc4.EffectiveDate > Now()
                                             )
                                      THEN
                                        'PENDING DECREASE'
                                        ELSE
                                          CASE
                                            WHEN ( rsd6.Rate <
                                                   trc4.Rate
                                                   AND trc4.EffectiveDate <=
                                                       Now() )
                                          THEN
                                            'INCREASE'
                                            ELSE
                                              CASE
                                                WHEN ( rsd6.Rate
                                                       <
                                                       trc4.Rate
                                                       AND trc4.EffectiveDate >
                                                           Now() )
                                              THEN
                                                'PENDING INCREASE'
                                                ELSE
                                                  CASE
                                                    WHEN
                                              rsd6.Destination !=
                                              description THEN
                                                    'NAME CHANGE'
                                                    ELSE 'NO CHANGE'
                                                  END
                                              END
                                          END
                                      END
                                  END
                              END as  `Change`
              FROM   tblRate
                     INNER JOIN tmp_CustomerRates_ trc4
                             ON trc4.RateID = tblRate.RateID
                     INNER JOIN tblRateSheet
                             ON tblRateSheet.RateSheetID = v_lastRateSheetID_
                     INNER JOIN tmp_CloneRateSheetDetail_ as rsd6
                             ON rsd6.RateID = trc4.RateID
                                AND rsd6.RateSheetID =
                                    v_lastRateSheetID_
				  ) AS tbl ;

      INSERT INTO tmp_RateSheetRate_
      SELECT tblRateSheetDetails.RateID,
             tblRateSheetDetails.Destination,
             tblRateSheetDetails.Code,
             tblRateSheetDetails.Interval1,
             tblRateSheetDetails.IntervalN,
             tblRateSheetDetails.Rate,
             v_trunkDescription_,
             'DELETE',
             tblRateSheetDetails.EffectiveDate
      FROM   tblRate
             INNER JOIN tblRateSheetDetails
                     ON tblRate.RateID = tblRateSheetDetails.RateID
                        AND tblRateSheetDetails.RateSheetID = v_lastRateSheetID_
             LEFT JOIN (SELECT DISTINCT RateID,
                                        effectivedate
                        FROM   tmp_RateTableRate_
                        UNION
                        SELECT DISTINCT RateID,
                                        effectivedate
                        FROM tmp_CustomerRates_) AS TBL
                    ON TBL.RateID = tblRateSheetDetails.RateID
      WHERE  `change` != 'DELETE'
             AND TBL.RateID IS NULL ;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_RateSheetRate4_;	
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_RateSheetRate4_ as (select * from tmp_RateSheetRate_);
	DELETE n1 FROM tmp_RateSheetRate_ n1, tmp_RateSheetRate4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate
	AND  n1.RateId = n2.RateId;

      IF v_IncludePrefix_ = 1
        THEN
            SELECT rsr.RateID AS rateid,
                 rsr.Interval1 AS interval1,
                 rsr.IntervalN AS intervaln,
                 rsr.Destination AS destination,
                 rsr.Codes AS codes,
                 v_Prefix_ AS `tech prefix`,
                 CONCAT(rsr.Interval1,'/',rsr.IntervalN) AS `interval`,
                 FORMAT(rsr.Rate,6) AS `rate per minute (usd)`,
                 rsr.`level`,
                 rsr.`change`,
                 rsr.EffectiveDate AS `effective date`
            FROM   tmp_RateSheetRate_ rsr
            WHERE rsr.Rate > 0
            ORDER BY rsr.Destination,rsr.Codes desc;
      ELSE
            SELECT rsr.RateID AS rateid ,
                           rsr.Interval1 AS interval1,
                           rsr.IntervalN AS intervaln,
                           rsr.Destination AS destination,
                           rsr.Codes AS codes,
                           CONCAT(rsr.Interval1,'/',rsr.IntervalN) AS  `interval`,
                           FORMAT(rsr.Rate, 6) AS `rate per minute (usd)`,
                           rsr.`level`,
                           rsr.`change`,
                           rsr.EffectiveDate AS `effective date`
            FROM   tmp_RateSheetRate_ rsr
            WHERE rsr.Rate > 0
          	ORDER BY rsr.Destination,rsr.Codes DESC;
        END IF; 
        
        SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTable` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSGenerateRateTable`(
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
    
   

    SET p_EffectiveDate = CAST(p_EffectiveDate AS DATE);
       
    
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

 
  
	
          
		SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = v_CompanyId_;
		SET @IncludeAccountIds = (SELECT GROUP_CONCAT(AccountId) from tblRateRule rr inner join  tblRateRuleSource rrs on rr.RateRuleId = rrs.RateRuleId where rr.RateGeneratorId = p_RateGeneratorId ) ;
     
	
	
	  
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
						
 
		 
		
			
		
		
	  WHILE v_pointer_ <= v_rowCount_
	    DO

             SET v_rateRuleId_ = (SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = v_pointer_);
           

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
                              @preference_rank := CASE WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference > vr.Preference  )   THEN @preference_rank + 1 
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
                                   
                 			 
						 
	         ELSE 

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
    	


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTableTest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSGenerateRateTableTest`(IN `p_jobId` INT
, IN `p_RateGeneratorId` INT
, IN `p_RateTableId` INT
, IN `p_rateTableName` VARCHAR(200) 
, IN `p_EffectiveDate` VARCHAR(10))
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
    
   

    SET p_EffectiveDate = CAST(p_EffectiveDate AS DATE);
       
    
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
		  INDEX tmp_Rates_code (`code`) 
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

 
  
	
          
		SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = v_CompanyId_;
		SET @IncludeAccountIds = (SELECT GROUP_CONCAT(AccountId) from tblRateRule rr inner join  tblRateRuleSource rrs on rr.RateRuleId = rrs.RateRuleId where rr.RateGeneratorId = p_RateGeneratorId ) ;
     
	
	
	  
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
						( EffectiveDate <= NOW() )
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
						
 
		 
		
			
		
		
	  WHILE v_pointer_ <= v_rowCount_
	    DO

             SET v_rateRuleId_ = (SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = v_pointer_);
           

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
                              @preference_rank := CASE WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference > vr.Preference  )   THEN @preference_rank + 1 
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

                    INSERT INTO tmp_Rates_
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
                                   
                 			 
						 
	         ELSE 

	           INSERT INTO tmp_Rates_
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
  
  		

    	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTableWithPrefix` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSGenerateRateTableWithPrefix`(
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
    
   

    SET p_EffectiveDate = CAST(p_EffectiveDate AS DATE);
       
    
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

		
		
		
		
		
		
		insert into tmp_code_
		SELECT
			tblRate.code
		FROM tblRate
		JOIN tmp_Codedecks_ cd
			ON tblRate.CodeDeckId = cd.CodeDeckId
		JOIN tmp_Raterules_ rr
			ON tblRate.code LIKE (REPLACE(rr.code,'*', '%%'))
		Order by tblRate.code ;
			

		
		

 
  
	
          
		SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = v_CompanyId_;
		SET @IncludeAccountIds = (SELECT GROUP_CONCAT(AccountId) from tblRateRule rr inner join  tblRateRuleSource rrs on rr.RateRuleId = rrs.RateRuleId where rr.RateGeneratorId = p_RateGeneratorId ) ;
     
	
     
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
							   

		
			
		
		
	  WHILE v_pointer_ <= v_rowCount_
	    DO

             SET v_rateRuleId_ = (SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = v_pointer_);
           

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
                              @preference_rank := CASE WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference > vr.Preference  )   THEN @preference_rank + 1 
                                                       WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate) THEN @preference_rank + 1 
                                                      
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
                                   
                 			 
						 
	         ELSE 

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
    	


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTableWithPrefix_07_11_2016` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSGenerateRateTableWithPrefix_07_11_2016`(IN `p_jobId` INT
, IN `p_RateGeneratorId` INT
, IN `p_RateTableId` INT
, IN `p_rateTableName` VARCHAR(200) 
, IN `p_EffectiveDate` VARCHAR(10))
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
    
   

    SET p_EffectiveDate = CAST(p_EffectiveDate AS DATE);
       
    
    
    	

		DROP TEMPORARY TABLE IF EXISTS tmp_Rates_;
		CREATE TEMPORARY TABLE tmp_Rates_  (
		  code VARCHAR(50) COLLATE utf8_unicode_ci,
		  rate DECIMAL(18, 6),
		  ConnectionFee DECIMAL(18, 6),
		  INDEX tmp_Rates_code (`code`) 
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

		
		
		
		
		
		
		insert into tmp_code_
		SELECT
			tblRate.code
		FROM tblRate
		JOIN tmp_Codedecks_ cd
			ON tblRate.CodeDeckId = cd.CodeDeckId
		JOIN tmp_Raterules_ rr
			ON tblRate.code LIKE (REPLACE(rr.code,'*', '%%'))
		Order by tblRate.code ;
			

		
		

 
  
	
          
		SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = v_CompanyId_;
		SET @IncludeAccountIds = (SELECT GROUP_CONCAT(AccountId) from tblRateRule rr inner join  tblRateRuleSource rrs on rr.RateRuleId = rrs.RateRuleId where rr.RateGeneratorId = p_RateGeneratorId ) ;
     
	
     
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
						( EffectiveDate <= NOW() )
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
							   

		
			
		
		
	  WHILE v_pointer_ <= v_rowCount_
	    DO

             SET v_rateRuleId_ = (SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = v_pointer_);
           

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
                              @preference_rank := CASE WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference > vr.Preference  )   THEN @preference_rank + 1 
                                                       WHEN (@prev_Code  = vr.RowCode  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate) THEN @preference_rank + 1 
                                                      
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

                    INSERT INTO tmp_Rates_
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
                                   
                 			 
						 
	         ELSE 

	           INSERT INTO tmp_Rates_
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
     
     
     SELECT DISTINCT
     
          rate.Code,
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
      WHERE tblRate.CodeDeckId = v_codedeckid_
		and rate.Code = '998';
  
       
    

    	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    	


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTable_old-25-4-2016` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSGenerateRateTable_old-25-4-2016`(IN `p_jobId` INT
, IN `p_RateGeneratorId` INT
, IN `p_RateTableId` INT
, IN `p_rateTableName` VARCHAR(200) 
, IN `p_EffectiveDate` VARCHAR(10))
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
	
     SET @@global.collation_connection='utf8_unicode_ci';
     SET @@local.collation_connection='utf8_unicode_ci';

     SET @@local.character_set_client='utf8';
     SET @@local.character_set_client='utf8';
     
 
	
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    
   

    SET p_EffectiveDate = CAST(p_EffectiveDate AS DATE);
       
    
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
		  code VARCHAR(50) ,
		  rate DECIMAL(18, 6),
		  ConnectionFee DECIMAL(18, 6),
		  INDEX tmp_Rates_code (`code`) 
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_Rates2_;
		CREATE TEMPORARY TABLE tmp_Rates2_  (
		  code VARCHAR(50) ,
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
        code VARCHAR(50)  ,
        RowNo INT,
        INDEX tmp_Raterules_code (`code`),
        INDEX tmp_Raterules_rateruleid (`rateruleid`),
        INDEX tmp_Raterules_RowNo (`RowNo`)
    	);
     	DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_;
     	CREATE TEMPORARY TABLE tmp_Vendorrates_  (
        code VARCHAR(50)  ,
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
		RowCode VARCHAR(50)  ,
        code VARCHAR(50)  ,
        rate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        FinalRankNumber int,
        INDEX tmp_Vendorrates_stage2__code (`RowCode`)
    	);
     DROP TEMPORARY TABLE IF EXISTS tmp_dupVRatesstage2_;
     	CREATE TEMPORARY TABLE tmp_dupVRatesstage2_  (
		RowCode VARCHAR(50)  ,
        FinalRankNumber int,
        INDEX tmp_dupVendorrates_stage2__code (`RowCode`)
    	);
     DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_stage3_;
     CREATE TEMPORARY TABLE tmp_Vendorrates_stage3_  (
        RowCode VARCHAR(50)  ,
        rate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        INDEX tmp_Vendorrates_stage2__code (`RowCode`)
    	);    	
    	
     	DROP TEMPORARY TABLE IF EXISTS tmp_code_;
     	CREATE TEMPORARY TABLE tmp_code_  (
        code VARCHAR(50)  ,
        INDEX tmp_code_code (`code`)
    	);

     DROP TEMPORARY TABLE IF EXISTS tmp_all_code_;
  CREATE TEMPORARY TABLE tmp_all_code_ ( 
     RowCode  varchar(50)  ,
     Code  varchar(50)  ,
     RowNo int
     
   );

 

      DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_;
       CREATE TEMPORARY TABLE tmp_VendorRate_stage_ (
          RowCode VARCHAR(50)  ,
          AccountId INT ,
          AccountName VARCHAR(100) ,
          Code VARCHAR(50)  ,
          Rate DECIMAL(18,6) ,
          ConnectionFee DECIMAL(18,6) ,
          EffectiveDate DATETIME ,
          Description VARCHAR(255),
          Preference INT,
          MaxMatchRank int ,
          prev_prev_RowCode VARCHAR(50),
          prev_AccountID int
        );

 DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
  CREATE TEMPORARY TABLE tmp_VendorRate_ (
     AccountId INT ,
     AccountName VARCHAR(100) ,
     Code VARCHAR(50)  ,
     Rate DECIMAL(18,6) ,
     ConnectionFee DECIMAL(18,6) ,
     EffectiveDate DATETIME ,
     Description VARCHAR(255),
     Preference INT,
     RowCode VARCHAR(50)   
   );
   DROP TEMPORARY TABLE IF EXISTS tmp_final_VendorRate_;
  CREATE TEMPORARY TABLE tmp_final_VendorRate_ (
     AccountId INT ,
     AccountName VARCHAR(100) ,
     Code VARCHAR(50)  ,
     Rate DECIMAL(18,6) ,
     ConnectionFee DECIMAL(18,6) ,
     EffectiveDate DATETIME ,
     Description VARCHAR(255),
     Preference INT,
     RowCode VARCHAR(50) ,
     FinalRankNumber int
   );
   
   DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_(
			AccountId int,
            AccountName varchar(200),
			Code varchar(50) ,
			Description varchar(200) ,
			Rate DECIMAL(18,6) ,
               ConnectionFee DECIMAL(18,6) , 
			EffectiveDate date,
			TrunkID int,
			CountryID int,
			RateID int,
			Preference int,
			INDEX tmp_VendorCurrentRates_AccountId (`AccountId`,`TrunkID`,`RateId`,`EffectiveDate`)
	);
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
     rankname INT
   );

     	DROP TEMPORARY TABLE IF EXISTS tmp_SplitRowCodes_;
		CREATE TEMPORARY TABLE tmp_SplitRowCodes_  (
		  code VARCHAR(50) ,
		  INDEX tmp_Rates_code (`code`) 
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
	            ON tblAccount.AccountID = tblRateRuleSource.AccountId
			JOIN tblVendorTrunk
	                ON tblAccount.AccountId = tblVendorTrunk.AccountID
	                AND  tblVendorTrunk.TrunkID = v_trunk_
	                AND tblVendorTrunk.Status = 1
	        WHERE RateGeneratorId = p_RateGeneratorId;

	    SET v_pointer_ = 1;
	    SET v_rowCount_ = (SELECT COUNT(distinct Code ) FROM tmp_Raterules_);

		
		
		
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
	            JOIN tmp_Codedecks_ cd
	                ON tblRate.CodeDeckId = cd.CodeDeckId
	            JOIN tmp_Raterules_ rr
	                ON tblRate.code LIKE (REPLACE(rr.code,
	                '*', '%%'))
	          Order by tblRate.code 
          ) as f
          ON   x.RowNo   <= LENGTH(f.Code) 
          order by loopCode   desc;


          	
  
	
          
		SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = v_CompanyId_;
		SET @IncludeAccountIds = (SELECT GROUP_CONCAT(AccountId) from tblRateRule rr inner join  tblRateRuleSource rrs on rr.RateRuleId = rrs.RateRuleId where rr.RateGeneratorId = p_RateGeneratorId ) ;
     
	
     
	 INSERT INTO tmp_VendorCurrentRates_ 
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
							
							  vt.Status =  1 and vt.TrunkID =  v_trunk_  
                              inner join tmp_Codedecks_ tcd on vt.CodeDeckId = tcd.CodeDeckId
						INNER JOIN tblAccount   ON  tblAccount.CompanyID = v_CompanyId_ AND tblVendorRate.AccountId = tblAccount.AccountID 
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
						( EffectiveDate <= NOW() )
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
		 WHERE RowID = 1
		order by Code asc;
		
	
	
     
     
     
          
          
        insert into tmp_all_code_ (RowCode,Code,RowNo)
               select RowCode , loopCode,RowNo
               from (
                    select   RowCode , loopCode,
                    @RowNo := ( CASE WHEN (@prev_Code = tbl1.RowCode  ) THEN @RowNo + 1
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
                              INNER JOIN tmp_code_ AS f
                              ON  x.RowNo   <= LENGTH(f.Code) 
                              order by RowCode desc,  LENGTH(loopCode) DESC 
                    ) tbl1
                    , ( Select @RowNo := 0 ) x
                ) tbl order by RowCode desc,  LENGTH(loopCode) DESC ;


	IF v_Use_Preference_ = 1 THEN

	
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
		  @preference_rank := CASE WHEN (@prev_Code  = Code  AND @prev_Preference > Preference  ) THEN @preference_rank + 1 
								   WHEN (@prev_Code = Code  AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1 
								   WHEN (@prev_Code = Code  AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank 
								   ELSE 1 
								   END AS preference_rank,
		  @prev_Code := Code,
		  @prev_Preference := Preference,
		  @prev_Rate := Rate
		FROM tmp_VendorCurrentRates_ AS preference,
			 (SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
		ORDER BY preference.Code ASC, preference.Preference DESC, preference.Rate ASC,preference.AccountId ASC
		   
		 ) tbl
	  WHERE preference_rank <= v_RatePosition_
	  ORDER BY Code, preference_rank;

	ELSE


	
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
		  @rank := CASE WHEN (@prev_Code = Code  AND @prev_Rate < Rate) THEN @rank + 1 
						WHEN (@prev_Code  = Code  AND @prev_Rate = Rate) THEN @rank 
						ELSE 1 
						END AS RateRank,
		  @prev_Code := Code,
		  @prev_Rate := Rate
		FROM tmp_VendorCurrentRates_ AS rank,
			 (SELECT @rank := 0 , @prev_Code := '' , @prev_Rate := 0) f
		ORDER BY rank.Code ASC, rank.Rate,rank.AccountId ASC) tbl
	  WHERE RateRank <= v_RatePosition_
	  ORDER BY Code, RateRank;

	END IF;	

     


                                 
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
                                            where  SplitCode.Code is not null and rankname <= v_RatePosition_ 
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
					AccountId ,
				     AccountName ,
				     Code ,
				     Rate ,
                         ConnectionFee,
				     EffectiveDate ,
				     Description ,
				     Preference,
				     RowCode,
   			         @rank := CASE WHEN ( @prev_RowCode = RowCode  AND @prev_Rate <  Rate ) THEN @rank+1
                                      WHEN ( @prev_RowCode = RowCode  AND @prev_Rate = Rate) THEN @rank 
						   ELSE 
						   1
						   END 
				  		  AS FinalRankNumber,
				  	@prev_RowCode  := RowCode,
					@prev_Rate  := Rate
					from tmp_VendorRate_ 
					,(SELECT @rank := 0 , @prev_RowCode := '' , @prev_Rate := 0  ) x 
				 	order by RowCode,Rate,AccountId ASC
				 
				) tbl1
				where 
				FinalRankNumber <= v_RatePosition_;
				 
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
                              @preference_rank := CASE WHEN (@prev_Code = RowCode  AND @prev_Preference > Preference  )   THEN @preference_rank + 1 
                                                       WHEN (@prev_Code = RowCode  AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1 
                                                       WHEN (@prev_Code = RowCode  AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank 
                                                       ELSE 1 END AS FinalRankNumber,
                              @prev_Code := RowCode,
                              @prev_Preference := Preference,
                              @prev_Rate := Rate
					from tmp_VendorRate_ 
                          ,(SELECT @preference_rank := 0 , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
     			 	 order by RowCode ASC ,Preference DESC ,Rate ASC ,AccountId ASC
                         
				) tbl1
				where 
				FinalRankNumber <= v_RatePosition_;
		 
		 END IF;
			
		
		
	  WHILE v_pointer_ <= v_rowCount_
	    DO

             SET v_rateRuleId_ = (SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = v_pointer_);
             SET @IncludeAccountIds = (SELECT GROUP_CONCAT(AccountId) from tblRateRuleSource where RateRuleId = v_rateRuleId_ ) ;

		INSERT INTO tmp_Rates2_ (code,rate,ConnectionFee)
		select  code,rate,ConnectionFee from tmp_Rates_;

		truncate   tmp_VRatesstage2_;
		
	               INSERT INTO tmp_VRatesstage2_         
     			SELECT
     				vr.RowCode,
     				vr.code,
     				vr.rate,
     				vr.ConnectionFee,
                         vr.FinalRankNumber
     			FROM tmp_final_VendorRate_ vr
                     JOIN tmp_Raterules_ rr ON rr.RateRuleId = v_rateRuleId_ and vr.RowCode LIKE (REPLACE(rr.code,'*', '%%'))
     			 left join tmp_Rates2_ rate on rate.Code = vr.RowCode 
     			WHERE vr.FinalRankNumber <= v_RatePosition_ 
                    AND rate.code is null
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

                    INSERT INTO tmp_Rates_
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
                                   
                 			 
						 
	         ELSE 

	           INSERT INTO tmp_Rates_
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
    	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTable_OLD19042016` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSGenerateRateTable_OLD19042016`(IN `p_jobId` INT
, IN `p_RateGeneratorId` INT
, IN `p_RateTableId` INT
, IN `p_rateTableName` VARCHAR(200) 
, IN `p_EffectiveDate` VARCHAR(10))
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
    	
    	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    	 


    	SET p_EffectiveDate = CAST(p_EffectiveDate AS DATE);
       

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
		  code VARCHAR(50) ,
		  rate DECIMAL(18, 6),
		  ConnectionFee DECIMAL(18, 6),
		  INDEX tmp_Rates_code (`code`) 
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_Rates2_;
		CREATE TEMPORARY TABLE tmp_Rates2_  (
		  code VARCHAR(50) ,
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
        code VARCHAR(50),
        RowNo INT,
        INDEX tmp_Raterules_code (`code`),
        INDEX tmp_Raterules_rateruleid (`rateruleid`),
        INDEX tmp_Raterules_RowNo (`RowNo`)
    	);
     	DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_;
     	CREATE TEMPORARY TABLE tmp_Vendorrates_  (
        code VARCHAR(50),
        rate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        AccountId INT,
        RowNo INT,
        PreferenceRank INT,
        INDEX tmp_Vendorrates_code (`code`),
        INDEX tmp_Vendorrates_rate (`rate`)
    	);
    	
    	
    	DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_stage2_;
     	CREATE TEMPORARY TABLE tmp_Vendorrates_stage2_  (
        code VARCHAR(50),
        rate DECIMAL(18, 6),
        ConnectionFee DECIMAL(18, 6),
        INDEX tmp_Vendorrates_stage2__code (`code`)
    	);
    	
    	
     	DROP TEMPORARY TABLE IF EXISTS tmp_code_;
     	CREATE TEMPORARY TABLE tmp_code_  (
        code VARCHAR(50),
        rateid INT,
        countryid INT,
        INDEX tmp_code_code (`code`),
        INDEX tmp_code_rateid (`rateid`)
    	);
    	DROP TEMPORARY TABLE IF EXISTS tmp_tblVendorRate_;
     	CREATE TEMPORARY TABLE tmp_tblVendorRate_  (
			AccountId INT,
	      RateID INT,
	      Rate FLOAT,
	      ConnectionFee FLOAT,
	      TrunkId INT,
	      EffectiveDate DATE,
			RowID INT,
			INDEX tmp_tblVendorRate_AccountId (`AccountId`,`TrunkId`,`RateID`),
			INDEX tmp_tblVendorRate_EffectiveDate (`EffectiveDate`),
			INDEX tmp_tblVendorRate_Rate (`Rate`)
		);


    	SET  v_Use_Preference_ = (SELECT ifnull( JSON_EXTRACT(Options, '$.Use_Preference'),0)  FROM  tblJob WHERE JobID = p_jobId);
    	SELECT CurrencyID INTO v_CurrencyID_ FROM  tblRateGenerator WHERE RateGeneratorId = p_RateGeneratorId;

    	SELECT
        rateposition,
        companyid ,
        CodeDeckId,
        tblRateGenerator.TrunkID,
        tblRateGenerator.UseAverage  ,
        tblRateGenerator.RateGeneratorName INTO v_RatePosition_, v_CompanyId_, v_codedeckid_, v_trunk_, v_Average_, v_RateGeneratorName_
    	FROM tblRateGenerator
    	WHERE RateGeneratorId = p_RateGeneratorId;
     SET v_codedeckid_ = 2;

		SELECT CurrencyId INTO v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = v_CompanyId_;

    	INSERT INTO tmp_Raterules_
			SELECT
            rateruleid,
            tblRateRule.code,
            @row_num := @row_num+1 AS RowID
        FROM tblRateRule,(SELECT @row_num := 0) x
        WHERE rategeneratorid = p_RateGeneratorId
        ORDER BY tblRateRule.code DESC;

	     INSERT INTO tmp_Codedecks_
	        SELECT DISTINCT
	            tblVendorTrunk.CodeDeckId
	        FROM tblRateRule
	        INNER JOIN tblRateRuleSource
	            ON tblRateRule.RateRuleId = tblRateRuleSource.RateRuleId
	        INNER JOIN tblAccount
	            ON tblAccount.AccountID = tblRateRuleSource.AccountId
			JOIN tblVendorTrunk
	                ON tblAccount.AccountId = tblVendorTrunk.AccountID
	                AND  tblVendorTrunk.TrunkID = v_trunk_
	                AND tblVendorTrunk.Status = 1
	        WHERE RateGeneratorId = p_RateGeneratorId;

	    SET v_pointer_ = 1;
	    SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_Raterules_);

	    WHILE v_pointer_ <= v_rowCount_
	    DO
	        SET v_rateRuleId_ = (SELECT
	                rateruleid
	            FROM tmp_Raterules_ rr
	            WHERE rr.rowno = v_pointer_);

	        INSERT INTO tmp_code_
	            SELECT
	                tblRate.code,
	                tblRate.rateid,
	                tblRate.CountryID

	            FROM tblRate
	            JOIN tmp_Codedecks_ cd
	                ON tblRate.CodeDeckId = cd.CodeDeckId
	            JOIN tmp_Raterules_ rr
	                ON tblRate.code LIKE (REPLACE(rr.code,
	                '*', '%%'))
	            WHERE rr.rowno = v_pointer_;



				 INSERT INTO tmp_tblVendorRate_
	          SELECT AccountId,
	          RateID,
	          Rate,
	          ConnectionFee,
	          TrunkId,
	          EffectiveDate,
				 RowID
				 FROM(SELECT AccountId,
	          RateID,
	          Rate,
	          ConnectionFee,
	          TrunkId,
	          EffectiveDate,
				 @row_num := IF(@prev_RateId=tblVendorRate.RateId AND @prev_TrunkID=tblVendorRate.TrunkID AND @prev_AccountId=tblVendorRate.AccountId and @prev_EffectiveDate >= tblVendorRate.EffectiveDate ,@row_num+1,1) AS RowID,
				 @prev_RateId  := tblVendorRate.RateId,
				 @prev_TrunkID  := tblVendorRate.TrunkID,
				 @prev_AccountId  := tblVendorRate.AccountId,
				 @prev_EffectiveDate  := tblVendorRate.EffectiveDate
	          FROM tblVendorRate ,(SELECT @row_num := 1) x,(SELECT @prev_RateId := '') y,(SELECT @prev_TrunkID := '') z ,(SELECT @prev_AccountId := '') v ,(SELECT @prev_EffectiveDate := '') u
	          WHERE TrunkId = v_trunk_
				 ORDER BY tblVendorRate.AccountId , tblVendorRate.TrunkID, tblVendorRate.RateId, tblVendorRate.EffectiveDate DESC) TBLVENDOR;

	       INSERT INTO tmp_Vendorrates_   (code ,rate ,  ConnectionFee , AccountId ,RowNo ,PreferenceRank )
			  SELECT code,rate,ConnectionFee,AccountId,RowNo,PreferenceRank FROM(SELECT *,
				 @row_num := IF(@prev_Code2 = code AND  @prev_Preference <= Preference ,(@row_num+1),1) AS PreferenceRank,
				 @prev_Code2  := Code,
				 @prev_Rate2  := rate,
				 @prev_Preference  := Preference
				 FROM (SELECT code,
				rate,
				ConnectionFee,
				AccountId,
				Preference,
				@row_num := IF(@prev_Code = code AND @prev_Rate <= rate ,(@row_num+1),1) AS RowNo,
				@prev_Code  := Code,
				@prev_Rate  := rate
				from  (
				SELECT DISTINCT
	                c.code,
					 CASE WHEN  tblAccount.CurrencyId = v_CurrencyID_
						THEN
							tmp_tblVendorRate_.rate
	               WHEN  v_CompanyCurrencyID_ = v_CurrencyID_  
					 THEN
						  (
						   ( tmp_tblVendorRate_.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ) )
						 )
					  ELSE 
					  (
					  			
      					  (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = v_CurrencyID_ and  CompanyID = v_CompanyId_ )
					  		* (tmp_tblVendorRate_.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblAccount.CurrencyId and  CompanyID = v_CompanyId_ ))
					  )
					 END
						as  Rate,
	                tmp_tblVendorRate_.ConnectionFee,
	                tblAccount.AccountId,
					Preference

	            FROM tmp_Raterules_ rateRule
	            JOIN tblRateRuleSource
	                ON tblRateRuleSource.rateruleid = rateRule.rateruleid
	            JOIN tblAccount
	                ON tblAccount.AccountId = tblRateRuleSource.AccountId
	            JOIN tmp_tblVendorRate_
	                ON tblAccount.AccountId = tmp_tblVendorRate_.AccountId
	                AND tmp_tblVendorRate_.TrunkId = v_trunk_ and RowID = 1

	            JOIN tblVendorTrunk
	                ON tmp_tblVendorRate_.AccountId = tblVendorTrunk.AccountID
	                AND tmp_tblVendorRate_.TrunkId = tblVendorTrunk.TrunkID
	                AND tblVendorTrunk.Status = 1
	            JOIN tmp_code_ c
	                ON c.RateID = tmp_tblVendorRate_.RateId
	            LEFT JOIN tblVendorBlocking blockCountry
	                ON tblAccount.AccountId = blockCountry.AccountId
	                AND c.CountryID = blockCountry.CountryId
	                AND blockCountry.TrunkID = v_trunk_
	            LEFT JOIN tblVendorBlocking blockCode
	                ON tblAccount.AccountId = blockCode.AccountId
	                AND c.RateID = blockCode.RateId
	                AND blockCode.TrunkID = v_trunk_
	            LEFT JOIN tblVendorPreference
	                ON tblAccount.AccountId = tblVendorPreference.AccountId
	                AND c.RateID = tblVendorPreference.RateId
	                AND tblVendorPreference.TrunkID = v_trunk_
	            WHERE rateRule.rowno = v_pointer_
	            AND blockCode.VendorBlockingId IS NULL
	            AND blockCountry.VendorBlockingId IS NULL
	            AND CAST(tmp_tblVendorRate_.EffectiveDate AS DATE) <= CAST(NOW() AS DATE)
				) VNDRTBL ,(SELECT @row_num := 1) x,(SELECT @prev_Code := '') y,(SELECT @prev_Rate := '') z
				ORDER BY code , rate
				) VNDRTBL ,(SELECT @row_num := 1) x,(SELECT @prev_Code2 := '') y,(SELECT @prev_Rate2 := '') z,(SELECT @prev_Preference := '') v
			 ORDER BY code,Preference desc,rate) LASTTBL;

	       DELETE FROM tmp_tblVendorRate_;

			 INSERT INTO tmp_Rates2_ (code,rate,ConnectionFee)
			 select  code,rate,ConnectionFee from tmp_Rates_;
 
			 
            truncate   tmp_Vendorrates_stage2_;
            INSERT INTO tmp_Vendorrates_stage2_         
				SELECT
                    vr.code,
                    vr.rate,
                    vr.ConnectionFee
                FROM tmp_Vendorrates_ vr
                left join tmp_Rates2_ rate on rate.code = vr.code 
                WHERE 
                rate.code is null
	             and   (
	                    (v_Use_Preference_ =0 and vr.RowNo <= v_RatePosition_ ) or 
	                    (v_Use_Preference_ =1 and vr.PreferenceRank <= v_RatePosition_)
	                )
	                
					order by
						CASE WHEN v_Use_Preference_ =1 THEN 
							PreferenceRank
						ELSE 
							RowNo
						END desc;
							
	        IF v_Average_ = 0 
	        THEN
	           
	           	
	                 
	              INSERT INTO tmp_Rates_
	                SELECT
	                    code,
	                    (SELECT 
	                            CASE WHEN vRate.rate >= minrate AND
	                            vRate.rate <= maxrate THEN vRate.rate
	                                + (CASE WHEN addmargin LIKE '%p' THEN ((CAST(REPLACE(addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate) ELSE addmargin
	                                END) ELSE vRate.rate
	                            END
	                        FROM tblRateRuleMargin 
	                        WHERE rateruleid = v_rateRuleId_ LIMIT 1
							) as Rate,
	                	ConnectionFee
	                FROM ( 
             					select  max(code) as code , max(rate) as rate , max(ConnectionFee) as  ConnectionFee,
											@row_num := IF(@prev_Code = code   ,(@row_num+1),1) AS RowNoNew,
											@prev_Code  := code
								 	from tmp_Vendorrates_stage2_
										 , (SELECT @row_num := 1 , @prev_Code := '' ) t
							 		group by code 
						 ) vRate;
						 
						 
	         ELSE 
	            
	           INSERT INTO tmp_Rates_
	                SELECT
	                    code,
	                     (SELECT 
	                            CASE WHEN vRate.rate >= minrate AND
	                            vRate.rate <= maxrate THEN vRate.rate
	                                + (CASE WHEN addmargin LIKE '%p' THEN ((CAST(REPLACE(addmargin, 'p', '') AS DECIMAL(18, 2)) / 100)
	                                    * vRate.rate) ELSE addmargin
	                                END) ELSE vRate.rate
	                            END
	                        FROM tblRateRuleMargin 
	                        WHERE rateruleid = v_rateRuleId_ LIMIT 1 
								) as Rate,
	                    ConnectionFee
	                FROM ( 
			                select code,
				                    AVG(Rate) as Rate,
				                    AVG(ConnectionFee) as ConnectionFee
								 	from tmp_Vendorrates_stage2_
							 		group by code 
						 ) vRate;
	
	        END IF;
	        DELETE FROM tmp_Vendorrates_;
	        DELETE FROM tmp_code_;
	
	        SET v_pointer_ = v_pointer_ + 1;
	    END WHILE;

		 
		 
	   
	   
		

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
	                p_RateTableId,
	                rate.Rate,
	                p_EffectiveDate,
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
    	
    	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSGenerateSippySheet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSGenerateSippySheet`(IN `p_CustomerID` INT , IN `p_Trunks` varchar(200) , IN `p_Effective` VARCHAR(50))
BEGIN
    
    DECLARE v_codedeckid_ INT;
    DECLARE v_ratetableid_ INT;
    DECLARE v_RateTableAssignDate_ DATETIME;
    DECLARE v_NewA2ZAssign_ INT;
    DECLARE v_companyid_ INT;
    DECLARE v_TrunkID_ INT;
    DECLARE v_pointer_ INT ;
    DECLARE v_rowCount_ INT ;
   
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
   
    
    DROP TEMPORARY TABLE IF EXISTS tmp_customerrateall_;
    CREATE TEMPORARY TABLE tmp_customerrateall_ (
        RateID INT,
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18, 6),
        RoutinePlanName VARCHAR(50),
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        CustomerRateId INT,
        TrunkID INT,
        RateTableRateId INT,
        IncludePrefix TINYINT,
        Prefix VARCHAR(50),
        RatePrefix VARCHAR(50),
        AreaPrefix VARCHAR(50)
    );
        
    DROP TEMPORARY TABLE IF EXISTS tmp_trunks_;
    CREATE TEMPORARY TABLE tmp_trunks_  (
        TrunkID INT,
        RowNo INT
    );
            
            
    SELECT 
        CompanyId INTO v_companyid_
    FROM tblAccount
    WHERE AccountID = p_CustomerID; 
        
        
        
    INSERT INTO tmp_trunks_
    SELECT TrunkID,
        @row_num := @row_num+1 AS RowID
    FROM tblCustomerTrunk,(SELECT @row_num := 0) x
    WHERE  FIND_IN_SET(tblCustomerTrunk.TrunkID,p_Trunks)!= 0 
        AND tblCustomerTrunk.AccountID = p_CustomerID;
        
    SET v_pointer_ = 1;
    SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_trunks_);
        
        
    WHILE v_pointer_ <= v_rowCount_
    DO
         
        SET v_TrunkID_ = (SELECT TrunkID FROM tmp_trunks_ t WHERE t.RowNo = v_pointer_);
     
        CALL prc_GetCustomerRate(v_companyid_,p_CustomerID,v_TrunkID_,null,null,null,p_Effective,1,0,0,0,'','',-1);
        
        INSERT INTO tmp_customerrateall_
        SELECT * FROM tmp_customerrate_;
        
        SET v_pointer_ = v_pointer_ + 1;
    END WHILE;
            
    SELECT 
            'A' as `Action [A|D|U|S|SA` ,
            '' as id,
            Concat(IFNULL(Prefix,''), Code) as Prefix,
            Description as COUNTRY ,
            Interval1 as `Interval 1`,
            IntervalN as `Interval N`,
            Rate as `Price 1`,
            Rate as `Price N`,
            0  as Forbidden,
            0 as `Grace Period`,
            'NOW' as `Activation Date`,
            '' as `Expiration Date` 
    FROM tmp_customerrateall_

    ORDER BY Prefix;
        
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSGenerateVendorSippySheet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSGenerateVendorSippySheet`(IN `p_VendorID` INT  , IN `p_Trunks` varchar(200), IN `p_Effective` VARCHAR(50))
BEGIN
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
         
        call vwVendorSippySheet(p_VendorID,p_Trunks,p_Effective); 
        SELECT 
				 `Action [A|D|U|S|SA`,
                id ,
                vendorRate.Prefix,
                COUNTRY,
                Preference ,
                `Interval 1` ,
                `Interval N` ,
                `Price 1` ,
                `Price N` ,
                `1xx Timeout` ,
                `2xx Timeout` ,
                `Huntstop` ,
                Forbidden ,
                `Activation Date` ,
                `Expiration Date`
        FROM    tmp_VendorSippySheet_ vendorRate     
        WHERE   vendorRate.AccountId = p_VendorID
        And  FIND_IN_SET(vendorRate.TrunkId,p_Trunks) != 0;
        
      SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSGenerateVendorVersion3VosSheet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSGenerateVendorVersion3VosSheet`(IN `p_VendorID` INT , IN `p_Trunks` varchar(200) , IN `p_Effective` VARCHAR(50))
BEGIN
         SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
         
        call vwVendorVersion3VosSheet(p_VendorID,p_Trunks,p_Effective);
        
        IF p_Effective = 'Now'		
		  THEN
		  
	        SELECT  `Rate Prefix` ,
	                `Area Prefix` ,
	                `Rate Type` ,
	                `Area Name` ,
	                `Billing Rate` ,
	                `Billing Cycle`,
	                `Minute Cost` ,
	                `Lock Type` ,
	                `Section Rate` ,
	                `Billing Rate for Calling Card Prompt` ,
	                `Billing Cycle for Calling Card Prompt`
	        FROM    tmp_VendorVersion3VosSheet_
	        WHERE   AccountID = p_VendorID
	        AND  FIND_IN_SET(TrunkId,p_Trunks)!= 0
	        ORDER BY `Rate Prefix`;
        
        END IF;
        
        IF p_Effective = 'Future'		
		  THEN
		  
	        SELECT  CONCAT(tmp_VendorVersion3VosSheet_.EffectiveDate,' 00:00') as `Time of timing replace`,
						 'Append replace' as `Mode of timing replace`,	
			  			 `Rate Prefix` ,
	                `Area Prefix` ,
	                `Rate Type` ,
	                `Area Name` ,
	                `Billing Rate` ,
	                `Billing Cycle`,
	                `Minute Cost` ,
	                `Lock Type` ,
	                `Section Rate` ,
	                `Billing Rate for Calling Card Prompt` ,
	                `Billing Cycle for Calling Card Prompt`
	        FROM    tmp_VendorVersion3VosSheet_
	        WHERE   AccountID = p_VendorID
	        AND  FIND_IN_SET(TrunkId,p_Trunks)!= 0
	        ORDER BY `Rate Prefix`;
        
        END IF;
        
        SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSGenerateVersion3VosSheet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSGenerateVersion3VosSheet`(IN `p_CustomerID` INT , IN `p_trunks` varchar(200) , IN `p_Effective` VARCHAR(50))
BEGIN
    
    DECLARE v_codedeckid_ INT;
    DECLARE v_ratetableid_ INT;
    DECLARE v_RateTableAssignDate_ DATETIME;
    DECLARE v_NewA2ZAssign_ INT;
    DECLARE v_companyid_ INT;
    DECLARE v_TrunkID_ INT;
    DECLARE v_pointer_ INT ;
    DECLARE v_rowCount_ INT ;
   
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
   
    
    DROP TEMPORARY TABLE IF EXISTS tmp_customerrateall_;
    CREATE TEMPORARY TABLE tmp_customerrateall_ (
        RateID INT,
        Code VARCHAR(50),
        Description VARCHAR(200),
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18, 6),
        RoutinePlanName VARCHAR(50),
        Rate DECIMAL(18, 6),
        EffectiveDate DATE,
        LastModifiedDate DATETIME,
        LastModifiedBy VARCHAR(50),
        CustomerRateId INT,
        TrunkID INT,
        RateTableRateId INT,
        IncludePrefix TINYINT,
        Prefix VARCHAR(50),
        RatePrefix VARCHAR(50),
        AreaPrefix VARCHAR(50)
    );
        
    DROP TEMPORARY TABLE IF EXISTS tmp_trunks_;
    CREATE TEMPORARY TABLE tmp_trunks_  (
        TrunkID INT,
        RowNo INT
    );
            
            
    SELECT 
        CompanyId INTO v_companyid_
    FROM tblAccount
    WHERE AccountID = p_CustomerID; 
        
        
        
    INSERT INTO tmp_trunks_
    SELECT TrunkID,
        @row_num := @row_num+1 AS RowID
    FROM tblCustomerTrunk,(SELECT @row_num := 0) x
    WHERE  FIND_IN_SET(tblCustomerTrunk.TrunkID,p_Trunks)!= 0 
        AND tblCustomerTrunk.AccountID = p_CustomerID;
        
    SET v_pointer_ = 1;
    SET v_rowCount_ = (SELECT COUNT(*)FROM tmp_trunks_);
        
        
    WHILE v_pointer_ <= v_rowCount_
    DO
         
        SET v_TrunkID_ = (SELECT TrunkID FROM tmp_trunks_ t WHERE t.RowNo = v_pointer_);
     
        CALL prc_GetCustomerRate(v_companyid_,p_CustomerID,v_TrunkID_,null,null,null,p_Effective,1,0,0,0,'','',-1);
        
        INSERT INTO tmp_customerrateall_
        SELECT * FROM tmp_customerrate_;
        
        SET v_pointer_ = v_pointer_ + 1;
    END WHILE;
    
    	IF p_Effective = 'Now'		
		  THEN	
            
        SELECT distinct 
                IFNULL(RatePrefix, '') as `Rate Prefix` ,
                Concat(IFNULL(AreaPrefix,''), Code) as `Area Prefix` ,
                'International' as `Rate Type` ,
                Description  as `Area Name`,
                Rate / 60  as `Billing Rate`,
                IntervalN as `Billing Cycle`,
                Rate as `Minute Cost` ,
                'No Lock'  as `Lock Type`,
                CASE WHEN Interval1 != IntervalN  
               	 THEN Concat('0,', Rate, ',',Interval1)
                ELSE 
					 	 ''
                END as `Section Rate`,
                0 AS `Billing Rate for Calling Card Prompt`,
                0  as `Billing Cycle for Calling Card Prompt`
        FROM   tmp_customerrateall_
        ORDER BY `Rate Prefix`; 
       
		 END IF; 
		 
	 	IF p_Effective = 'Future'		
		  THEN	
            
        SELECT distinct 
        			 CONCAT(EffectiveDate,' 00:00') as `Time of timing replace`,
        			 'Append replace' as `Mode of timing replace`,
                IFNULL(RatePrefix, '') as `Rate Prefix` ,
                Concat(IFNULL(AreaPrefix,''), Code) as `Area Prefix` ,
                'International' as `Rate Type` ,
                Description  as `Area Name`,
                Rate / 60  as `Billing Rate`,
                IntervalN as `Billing Cycle`,
                Rate as `Minute Cost` ,
                'No Lock'  as `Lock Type`,
                CASE WHEN Interval1 != IntervalN  
               	 THEN Concat('0,', Rate, ',',Interval1)
                ELSE 
					 	 ''
                END as `Section Rate`,
                0 AS `Billing Rate for Calling Card Prompt`,
                0  as `Billing Cycle for Calling Card Prompt`
        FROM   tmp_customerrateall_
        ORDER BY `Rate Prefix`; 
       
		 END IF;
   
   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSGetJobDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSGetJobDetails`(IN `p_jobId` int)
BEGIN
  SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SELECT tblJob.CompanyID 
  , IFNULL(tblUser.EmailAddress,'')  as EmailAddress
  , tblJob.Title as JobTitle
  , IFNULL(tblJob.JobStatusMessage,'') as JobStatusMessage
  , tblJobStatus.Title as StatusTitle
  ,OutputFilePath
  ,AccountID 
  ,tblJobType.Title as JobType
  FROM tblJob   
    JOIN tblJobStatus 
      ON tblJob.JobStatusID = tblJobStatus.JobStatusID    
    JOIN tblUser
      ON tblUser.UserID = tblJob.JobLoggedUserID
    JOIN tblJobType
	 	ON tblJob.JobTypeID = tblJobType.JobTypeID  
  WHERE tblJob.JobID = p_jobId;   
  
  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSInsertJobLog` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSInsertJobLog`(IN `p_companyId` INT , IN `p_accountId` INT , IN `p_processId` VARCHAR(50) , IN `p_process` VARCHAR(50) , IN `p_message` LONGTEXT)
BEGIN
	 
  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
  
	INSERT  INTO tblLog
    ( CompanyID ,
      AccountID ,
      ProcessID ,
      Process ,
      Message
    )
    SELECT  p_companyId ,
            ( CASE WHEN ( p_accountId IS NOT NULL
                          AND p_accountId > 0
                        ) THEN p_accountId
                   ELSE ( SELECT    AccountID
                          FROM      tblJob
                          WHERE     ProcessID = p_processId
                        )
              END ) ,
            p_processId ,
            p_process ,
            p_message;
     SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;   
  
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSJobStatusUpdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSJobStatusUpdate`(IN `p_JobId` int , IN `p_Status` varchar(5) , IN `p_JobStatusMessage` longtext , IN `p_OutputFilePath` longtext
)
BEGIN
  DECLARE v_JobStatusId_ int;
  SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 

  SELECT  JobStatusId INTO v_JobStatusId_ FROM tblJobStatus WHERE Code = p_Status;

  UPDATE tblJob
  SET JobStatusID = v_JobStatusId_
  , JobStatusMessage = p_JobStatusMessage
  , OutputFilePath = p_OutputFilePath
  , updated_at = NOW()
  , ModifiedBy = 'WindowsService'
  WHERE JobID = p_JobId;
  
  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSProcessCodeDeck` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSProcessCodeDeck`(
	IN `p_processId` VARCHAR(200),
	IN `p_companyId` INT
)
BEGIN

    DECLARE v_AffectedRecords_ INT DEFAULT 0;     
    DECLARE   v_CodeDeckId_ INT;
    DECLARE errormessage longtext;
	 DECLARE errorheader longtext;
	 DECLARE countrycount INT DEFAULT 0;
    
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    
	 DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
    CREATE TEMPORARY TABLE tmp_JobLog_  ( 
        Message longtext   
    );

    SELECT CodeDeckId INTO v_CodeDeckId_ FROM tblTempCodeDeck WHERE ProcessId = p_processId AND CompanyId = p_companyId LIMIT 1;
    
    DELETE n1 
	 FROM tblTempCodeDeck n1 
	 INNER JOIN (
	 	SELECT MAX(TempCodeDeckRateID) as TempCodeDeckRateID FROM tblTempCodeDeck WHERE ProcessId = p_processId
		GROUP BY Code
		HAVING COUNT(*)>1
	) n2 
	 	ON n1.TempCodeDeckRateID = n2.TempCodeDeckRateID
	WHERE n1.ProcessId = p_processId;
 		
 	
	 SELECT COUNT(*) INTO countrycount FROM tblTempCodeDeck WHERE ProcessId = p_processId AND Country !='';
	  
 
    UPDATE tblTempCodeDeck
    SET  
        tblTempCodeDeck.Interval1 = CASE WHEN tblTempCodeDeck.Interval1 is not null  and tblTempCodeDeck.Interval1 > 0
                                    THEN    
                                        tblTempCodeDeck.Interval1
                                    ELSE
                                    CASE WHEN tblTempCodeDeck.Interval1 is null and (tblTempCodeDeck.Description LIKE '%gambia%' OR tblTempCodeDeck.Description LIKE '%mexico%')
                                            THEN 
                                            60
                                    ELSE CASE WHEN tblTempCodeDeck.Description LIKE '%USA%' 
                                            THEN 
                                            6
                                            ELSE 
                                            1
                                        END
                                    END
                                    END,
        tblTempCodeDeck.IntervalN = CASE WHEN tblTempCodeDeck.IntervalN is not null  and tblTempCodeDeck.IntervalN > 0
                                    THEN    
                                        tblTempCodeDeck.IntervalN
                                    ELSE
                                        CASE WHEN tblTempCodeDeck.Description LIKE '%mexico%' THEN 
                                        60
                                    ELSE CASE
                                        WHEN tblTempCodeDeck.Description LIKE '%USA%' THEN 
                                        6
                                    ELSE 
                                        1
                                    END
                                    END
                                    END
    WHERE tblTempCodeDeck.ProcessId = p_processId;
  
    UPDATE tblTempCodeDeck t
	    SET t.CountryId = fnGetCountryIdByCodeAndCountry (t.Code ,t.Country) 
	 WHERE t.ProcessId = p_processId ;
  
   IF countrycount > 0
   THEN
	  	UPDATE tblTempCodeDeck t
		    SET t.CountryId = fnGetCountryIdByCodeAndCountry (t.Code ,t.Description) 
		 WHERE t.ProcessId = p_processId AND  t.CountryId IS NULL;
	END IF;	 

 IF ( SELECT COUNT(*)
                 FROM   tblTempCodeDeck
                 WHERE  tblTempCodeDeck.ProcessId = p_processId
                        AND tblTempCodeDeck.Action = 'D'
               ) > 0
            THEN
      DELETE  tblRate
            FROM    tblRate
                    INNER JOIN tblTempCodeDeck ON tblTempCodeDeck.Code = tblRate.Code
                                                  AND tblRate.CompanyID = p_companyId AND tblRate.CodeDeckId = v_CodeDeckId_
                    LEFT OUTER JOIN tblCustomerRate ON tblRate.RateID = tblCustomerRate.RateID
                    LEFT OUTER JOIN tblRateTableRate ON tblRate.RateID = tblRateTableRate.RateID
                    LEFT OUTER JOIN tblVendorRate ON tblRate.RateID = tblVendorRate.RateId
            WHERE   tblTempCodeDeck.Action = 'D'
          AND tblTempCodeDeck.CompanyID = p_companyId
          AND tblTempCodeDeck.CodeDeckId = v_CodeDeckId_
          AND tblTempCodeDeck.ProcessId = p_processId                    
                    AND tblCustomerRate.CustomerRateID IS NULL
                    AND tblRateTableRate.RateTableRateID IS NULL
                    AND tblVendorRate.VendorRateID IS NULL ;   
		END IF; 
      SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();
  
  
  		SELECT GROUP_CONCAT(Code) into errormessage FROM(
	      SELECT distinct tblRate.Code as Code,1 as a
	      FROM    tblRate
	                    INNER JOIN tblTempCodeDeck ON tblTempCodeDeck.Code = tblRate.Code
	      	    AND tblRate.CompanyID = p_companyId AND tblRate.CodeDeckId = v_CodeDeckId_
	          WHERE   tblTempCodeDeck.Action = 'D'
	          AND tblTempCodeDeck.ProcessId = p_processId
	          AND tblTempCodeDeck.CompanyID = p_companyId AND tblTempCodeDeck.CodeDeckId = v_CodeDeckId_)as tbl GROUP BY a;
	          
	   IF errormessage IS NOT NULL
          THEN
                    INSERT INTO tmp_JobLog_ (Message)                    
                    SELECT distinct 
						  CONCAT(tblRate.Code , ' FAILED TO DELETE - CODE IS IN USE')
					      FROM   tblRate
					              INNER JOIN tblTempCodeDeck ON tblTempCodeDeck.Code = tblRate.Code
					      	    AND tblRate.CompanyID = p_companyId AND tblRate.CodeDeckId = v_CodeDeckId_
					          WHERE   tblTempCodeDeck.Action = 'D'
					          AND tblTempCodeDeck.ProcessId = p_processId
					          AND tblTempCodeDeck.CompanyID = p_companyId AND tblTempCodeDeck.CodeDeckId = v_CodeDeckId_;
	 	END IF;
      
      UPDATE  tblRate
      JOIN tblTempCodeDeck ON tblRate.Code = tblTempCodeDeck.Code
            AND tblTempCodeDeck.ProcessId = p_processId
            AND tblRate.CompanyID = p_companyId
            AND tblRate.CodeDeckId = v_CodeDeckId_
            AND tblTempCodeDeck.Action != 'D'
		SET   tblRate.Description = tblTempCodeDeck.Description,
            tblRate.Interval1 = tblTempCodeDeck.Interval1,
            tblRate.IntervalN = tblTempCodeDeck.IntervalN;
  
  		IF countrycount > 0
  		THEN
  		
	  		UPDATE  tblRate
	      JOIN tblTempCodeDeck ON tblRate.Code = tblTempCodeDeck.Code
	            AND tblTempCodeDeck.ProcessId = p_processId
	            AND tblRate.CompanyID = p_companyId
	            AND tblRate.CodeDeckId = v_CodeDeckId_
	            AND tblTempCodeDeck.Action != 'D'
			SET   tblRate.CountryID = tblTempCodeDeck.CountryId;
		
		END IF;
      
      SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();
      
            INSERT  INTO tblRate
                    ( CountryID ,
                      CompanyID ,
                      CodeDeckId,
                      Code ,
                      Description,
                      Interval1,
                      IntervalN
                    )
                    SELECT  DISTINCT
              tblTempCodeDeck.CountryId ,
                            tblTempCodeDeck.CompanyId ,
                            tblTempCodeDeck.CodeDeckId,
                            tblTempCodeDeck.Code ,
                            tblTempCodeDeck.Description,
                            tblTempCodeDeck.Interval1,
                            tblTempCodeDeck.IntervalN
                    FROM    tblTempCodeDeck left join tblRate on(tblRate.CompanyID = p_companyId AND  tblRate.CodeDeckId = v_CodeDeckId_ AND tblTempCodeDeck.Code=tblRate.Code)
                    WHERE  tblRate.RateID is null
                            AND tblTempCodeDeck.ProcessId = p_processId
              AND tblTempCodeDeck.CompanyID = p_companyId
              AND tblTempCodeDeck.CodeDeckId = v_CodeDeckId_
                            AND tblTempCodeDeck.Action != 'D';
  
      SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();
    
	 INSERT INTO tmp_JobLog_ (Message)
	 SELECT CONCAT(v_AffectedRecords_, ' Records Uploaded \n\r ' );
	 
	DELETE  FROM tblTempCodeDeck WHERE   tblTempCodeDeck.ProcessId = p_processId;
 	 SELECT * from tmp_JobLog_;
	      
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    SELECT * from tmp_JobLog_ limit 0 , 20;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSProcessDialString` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSProcessDialString`(IN `p_processId` VARCHAR(200) , IN `p_dialStringId` INT)
BEGIN

    DECLARE v_AffectedRecords_ INT DEFAULT 0;         
    DECLARE totalduplicatecode INT(11) DEFAULT 0;	 
    DECLARE errormessage longtext;
	 DECLARE errorheader longtext;
    
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    
	 DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
    CREATE TEMPORARY TABLE tmp_JobLog_  ( 
        Message longtext   
    );
    
      
    
    DELETE n1 FROM tblTempDialString n1, tblTempDialString n2 WHERE n1.TempDialStringID < n2.TempDialStringID 
	 	AND n1.DialString = n2.DialString
		AND  n1.ChargeCode = n2.ChargeCode
		AND  n1.DialStringID = n2.DialStringID
		AND  n1.ProcessId = n2.ProcessId
 		AND  n1.DialStringID = p_dialStringId and n2.DialStringID = p_dialStringId
 		AND  n1.ProcessId = p_processId and n2.ProcessId = p_processId;
 		
 	
			SELECT COUNT(*) INTO totalduplicatecode FROM(
				SELECT COUNT(DialString) as c,DialString 
					FROM tblTempDialString 
						WHERE DialStringID = p_dialStringId
							 AND ProcessId = p_processId
					   GROUP BY DialString HAVING c>1) AS tbl;
				
			
			IF  totalduplicatecode > 0
			THEN	
				
				INSERT INTO tmp_JobLog_ (Message)
				  SELECT DISTINCT 
				  CONCAT(DialString , ' DUPLICATE CODE')
				  	FROM(
						SELECT   COUNT(DialString) as c,DialString
							 FROM tblTempDialString
									WHERE DialStringID = p_dialStringId
										 AND ProcessId = p_processId
						  GROUP BY DialString HAVING c>1) AS tbl;				
					
			END IF;	

IF  totalduplicatecode = 0 	
THEN	
 
    
	IF ( SELECT COUNT(*)
                 FROM   tblTempDialString
                 WHERE  tblTempDialString.ProcessId = p_processId
						AND tblTempDialString.DialStringID = p_dialStringId
                        AND tblTempDialString.Action = 'D'
               ) > 0
            THEN
		DELETE  tblDialStringCode
            FROM    tblDialStringCode
                    INNER JOIN tblTempDialString
						ON tblDialStringCode.DialString = tblTempDialString.DialString
                        AND tblDialStringCode.ChargeCode = tblTempDialString.ChargeCode
						AND tblDialStringCode.DialStringID = tblTempDialString.DialStringID
            WHERE   tblTempDialString.Action = 'D' AND tblTempDialString.DialStringID = p_dialStringId AND tblTempDialString.ProcessId = p_processId;   
		END IF; 
		
		SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();
	  
		
		      
		UPDATE  tblDialStringCode
		JOIN tblTempDialString ON tblDialStringCode.DialString = tblTempDialString.DialString
      		AND tblDialStringCode.ChargeCode = tblTempDialString.ChargeCode            
			AND tblDialStringCode.DialStringID = tblTempDialString.DialStringID
			AND tblTempDialString.ProcessId = p_processId
            AND tblTempDialString.DialStringID = p_dialStringId
            AND tblTempDialString.Action != 'D'
		SET   tblDialStringCode.Description = tblTempDialString.Description,
            tblDialStringCode.Forbidden = tblTempDialString.Forbidden;
  
      
		SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();
      
	  
		
		
            INSERT  INTO tblDialStringCode
                    ( DialStringID ,
                      DialString ,
                      ChargeCode,
                      Description ,
                      Forbidden
                    )
                    SELECT  DISTINCT
				tblTempDialString.DialStringID ,
                            tblTempDialString.DialString ,
                            tblTempDialString.ChargeCode,
                            tblTempDialString.Description ,
                            tblTempDialString.Forbidden
                    FROM    tblTempDialString left join tblDialStringCode
						on(tblDialStringCode.DialStringID = tblTempDialString.DialStringID
							AND  tblDialStringCode.DialString = tblTempDialString.DialString)
							
                    WHERE  tblDialStringCode.DialStringCodeID is null
                            AND tblTempDialString.ProcessId = p_processId
							AND tblTempDialString.DialStringID = p_dialStringId
                            AND tblTempDialString.Action != 'D';
  
		SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();
		
 END IF;   
 
		INSERT INTO tmp_JobLog_ (Message)
		SELECT CONCAT(v_AffectedRecords_, ' Records Uploaded \n\r ' );
	 
	 	DELETE  FROM tblTempDialString WHERE   tblTempDialString.ProcessId = p_processId;
		SELECT * from tmp_JobLog_; 
	      
		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSProcessImportAccount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSProcessImportAccount`(
	IN `p_processId` VARCHAR(200) ,
	IN `p_companyId` INT,
	IN `p_companygatewayid` INT,
	IN `p_tempaccountid` TEXT,
	IN `p_option` INT
)
BEGIN

   DECLARE v_AffectedRecords_ INT DEFAULT 0;         
	DECLARE totalduplicatecode INT(11);	 
	DECLARE errormessage longtext;
	DECLARE errorheader longtext;
	DECLARE v_accounttype INT DEFAULT 0;
	
	SET sql_mode = '';	    
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET SESSION sql_mode='';
    
	 DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
    CREATE TEMPORARY TABLE tmp_JobLog_  ( 
        Message longtext     
    );
    
    DROP TEMPORARY TABLE IF EXISTS tmp_accountimport;
				CREATE TEMPORARY TABLE tmp_accountimport (				  
				  `AccountType` tinyint(3) default 0,
				  `CompanyId` INT,
				  `Title` VARCHAR(100),
				  `Owner` INT,
				  `Number` VARCHAR(50),
				  `AccountName` VARCHAR(100),
				  `NamePrefix` VARCHAR(50),
				  `FirstName` VARCHAR(50),
				  `LastName` VARCHAR(50),				  
				  `LeadSource` VARCHAR(50),
				  `Email` VARCHAR(100),
				  `Phone` VARCHAR(50),
				  `Address1` VARCHAR(100),
				  `Address2` VARCHAR(100),
				  `Address3` VARCHAR(100),
				  `City` VARCHAR(50),
				  `PostCode` VARCHAR(50),
				  `Country` VARCHAR(50),
				  `Status` INT,
				  `tags` VARCHAR(250),
				  `Website` VARCHAR(100),
				  `Mobile` VARCHAR(50),
				  `Fax` VARCHAR(50),
				  `Skype` VARCHAR(50),
				  `Twitter` VARCHAR(50),
				  `Employee` VARCHAR(50),
				  `Description` longtext,
				  `BillingEmail` VARCHAR(200),
				  `CurrencyId` INT,
				  `VatNumber` VARCHAR(50),
				  `created_at` datetime,
				  `created_by` VARCHAR(100),
				  `VerificationStatus` tinyint(3) default 0
				) ENGINE=InnoDB;  
				
   IF p_option = 0 
   THEN
   
   SELECT DISTINCT(AccountType) INTO v_accounttype from tblTempAccount WHERE ProcessID=p_processId;
   
	DELETE n1 FROM tblTempAccount n1, tblTempAccount n2 WHERE n1.tblTempAccountID < n2.tblTempAccountID 	 	
		AND  n1.CompanyId = n2.CompanyId		   
		AND  n1.AccountName = n2.AccountName		
		AND  n1.ProcessID = n2.ProcessID
 		AND  n1.ProcessID = p_processId and n2.ProcessID = p_processId;   
		 
		 select count(*) INTO totalduplicatecode FROM(
				SELECT count(`Number`) as n,`Number` FROM tblTempAccount where ProcessID = p_processId  GROUP BY `Number` HAVING n>1) AS tbl;   
				
				
		 IF  totalduplicatecode > 0
				THEN
						SELECT GROUP_CONCAT(Number) into errormessage FROM(
							select distinct Number, 1 as a FROM(
								SELECT count(`Number`) as n,`Number` FROM tblTempAccount where ProcessID = p_processId  GROUP BY `Number` HAVING n>1) AS tbl) as tbl2 GROUP by a;				
								
						SELECT 'DUPLICATE AccountNumber : \n\r' INTO errorheader;		
						
						INSERT INTO tmp_JobLog_ (Message)
							 SELECT CONCAT(errorheader ,errormessage);
							 
							 delete FROM tblTempAccount WHERE Number IN (
								  SELECT Number from(
								  	SELECT count(`Number`) as n,`Number` FROM tblTempAccount where ProcessID = p_processId  GROUP BY `Number` HAVING n>1
									  ) as tbl
								);
							
			END IF;		

			INSERT  INTO tblAccount
				  (	AccountType ,
					CompanyId ,
					Title,
					Owner ,
					`Number`,
					AccountName,
					NamePrefix,
					FirstName,
					LastName,
					LeadStatus,
					LeadSource,
					Email,
					Phone,
					Address1,
					Address2,
					Address3,
					City,
					PostCode,
					Country,
					Status,
					tags,
					Website,
					Mobile,
					Fax,
					Skype,
					Twitter,
					Employee,
					Description,
					BillingEmail,
					CurrencyId,
					VatNumber,
					created_at,
					created_by,
					VerificationStatus
                   )            
				   
				   SELECT  DISTINCT
					ta.AccountType,
					ta.CompanyId,
					ta.Title,
					ta.Owner,
					ta.Number as Number,
					ta.AccountName,
					ta.NamePrefix,
					ta.FirstName,
					ta.LastName,
					ta.LeadStatus,
					ta.LeadSource,
					ta.Email,
					ta.Phone,
					ta.Address1,
					ta.Address2,
					ta.Address3,
					ta.City,
					ta.PostCode,
					ta.Country,
					ta.Status,
					ta.tags,
					ta.Website,
					ta.Mobile,
					ta.Fax,
					ta.Skype,
					ta.Twitter,
					ta.Employee,
					ta.Description,
					ta.BillingEmail,
					ta.Currency as CurrencyId,
					ta.VatNumber,
					ta.created_at,
					ta.created_by,
					2 as VerificationStatus
					from tblTempAccount ta
						left join tblAccount a on ta.AccountName = a.AccountName
						 	AND ta.CompanyId = a.CompanyId
							AND ta.AccountType = a.AccountType 
						where ta.ProcessID = p_processId
						   AND ta.AccountType = v_accounttype
							AND a.AccountID is null
							AND ta.CompanyID = p_companyId;
			
  
      SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();
    
	 INSERT INTO tmp_JobLog_ (Message)
	 SELECT CONCAT(v_AffectedRecords_, ' Records Uploaded \n\r ' );
	 
	  DELETE  FROM tblTempAccount WHERE   tblTempAccount.ProcessID = p_processId;
	
	END IF;
	
		
	IF p_option = 1 	
   THEN
   
   		INSERT INTO tmp_accountimport
				select ta.AccountType ,
					ta.CompanyId ,
					ta.Title,
					ta.Owner ,
					ta.Number,
					ta.AccountName,
					ta.NamePrefix,
					ta.FirstName,
					ta.LastName,					
					ta.LeadSource,
					ta.Email,
					ta.Phone,
					ta.Address1,
					ta.Address2,
					ta.Address3,
					ta.City,
					ta.PostCode,
					ta.Country,
					ta.Status,
					ta.tags,
					ta.Website,
					ta.Mobile,
					ta.Fax,
					ta.Skype,
					ta.Twitter,
					ta.Employee,
					ta.Description,
					ta.BillingEmail,
					ta.Currency as CurrencyId,
					ta.VatNumber,
					ta.created_at,
					ta.created_by,
					2 as VerificationStatus				
				 FROM tblTempAccount ta
				left join tblAccount a on ta.AccountName=a.AccountName
					AND ta.CompanyId = a.CompanyId
					AND ta.AccountType = a.AccountType
				where ta.CompanyID = p_companyId 
				AND ta.ProcessID = p_processId
				AND ta.AccountType = 1
				AND a.AccountID is null			
				AND (p_tempaccountid = '' OR ( p_tempaccountid != '' AND FIND_IN_SET(ta.tblTempAccountID,p_tempaccountid) ))
				AND (p_companygatewayid = 0 OR ( ta.CompanyGatewayID = p_companygatewayid))
				group by ta.AccountName;
				
				
			SELECT GROUP_CONCAT(Number) into errormessage FROM(
			SELECT distinct ta.Number as Number,1 as an  from tblTempAccount ta 
				left join tblAccount a on ta.Number = a.Number				
					AND ta.CompanyId = a.CompanyId
					AND ta.AccountType = a.AccountType
				where ta.CompanyID = p_companyId 
				AND ta.ProcessID = p_processId
				AND ta.AccountType = 1
				AND a.AccountID is not null			
				AND (p_tempaccountid = '' OR ( p_tempaccountid != '' AND FIND_IN_SET(ta.tblTempAccountID,p_tempaccountid) ))
				AND (p_companygatewayid = 0 OR ( ta.CompanyGatewayID = p_companygatewayid)))tbl GROUP by an;
			
		  IF errormessage is not null
		  THEN
		  
		  		SELECT 'AccountNumber Already EXITS : \n\r' INTO errorheader;								
						INSERT INTO tmp_JobLog_ (Message)		
							 SELECT CONCAT(errorheader ,errormessage);
							 
				delete FROM tmp_accountimport WHERE Number IN (
								  SELECT Number from(
								  	SELECT distinct ta.Number as Number,1 as an  from tblTempAccount ta 
										left join tblAccount a on ta.Number = a.Number				
											AND ta.CompanyId = a.CompanyId
											AND ta.AccountType = a.AccountType
										where ta.CompanyID = p_companyId 
										AND ta.ProcessID = p_processId
										AND ta.AccountType = 1
										AND a.AccountID is not null			
										AND (p_tempaccountid = '' OR ( p_tempaccountid != '' AND FIND_IN_SET(ta.tblTempAccountID,p_tempaccountid) ))
										AND (p_companygatewayid = 0 OR ( ta.CompanyGatewayID = p_companygatewayid))
									  ) as tbl
								);			 
		  	
		  END IF;	
		
		INSERT  INTO tblAccount
				  (	AccountType ,
					CompanyId ,
					Title,
					Owner ,
					`Number`,
					AccountName,
					NamePrefix,
					FirstName,
					LastName,
					LeadSource,
					Email,
					Phone,
					Address1,
					Address2,
					Address3,
					City,
					PostCode,
					Country,
					Status,
					tags,
					Website,
					Mobile,
					Fax,
					Skype,
					Twitter,
					Employee,
					Description,
					BillingEmail,
				    CurrencyId,
					VatNumber,
					created_at,
					created_by,
					VerificationStatus
                   )
			SELECT  
					AccountType ,
					CompanyId ,
					Title,
					Owner ,
					`Number`,
					AccountName,
					NamePrefix,
					FirstName,
					LastName,
					LeadSource,
					Email,
					Phone,
					Address1,
					Address2,
					Address3,
					City,
					PostCode,
					Country,
					Status,
					tags,
					Website,
					Mobile,
					Fax,
					Skype,
					Twitter,
					Employee,
					Description,
					BillingEmail,
				    CurrencyId,
					VatNumber,
					created_at,
					created_by,
					VerificationStatus
				from tmp_accountimport;
								

			SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();	

			INSERT INTO tmp_JobLog_ (Message)
			SELECT CONCAT(v_AffectedRecords_, ' Records Uploaded \n\r ' );	
			
		
   
   END IF;   
   
 	 SELECT * from tmp_JobLog_;	      
	      
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSProcessRateTableRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSProcessRateTableRate`(
	IN `p_ratetableid` INT,
	IN `p_replaceAllRates` INT,
	IN `p_effectiveImmediately` INT,
	IN `p_processId` VARCHAR(200),
	IN `p_addNewCodesToCodeDeck` INT,
	IN `p_companyId` INT
)
BEGIN
	DECLARE v_AffectedRecords_ INT DEFAULT 0;
	 DECLARE     v_CodeDeckId_ INT ;
	 DECLARE totalduplicatecode INT(11);	 
	 DECLARE errormessage longtext;
	 DECLARE errorheader longtext;
    
	 SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;    
	 
    DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
    CREATE TEMPORARY TABLE tmp_JobLog_ (
        Message longtext
    );
    DROP TEMPORARY TABLE IF EXISTS tmp_TempRateTableRate_;
    CREATE TEMPORARY TABLE tmp_TempRateTableRate_ (
			`CodeDeckId` int ,
			`Code` varchar(50) ,
			`Description` varchar(200) ,
			`Rate` decimal(18, 6) ,
			`EffectiveDate` Datetime ,
			`Change` varchar(100) ,
			`ProcessId` varchar(200) ,
			`Preference` int ,
			`ConnectionFee` decimal(18, 6),
			`Interval1` int,
			`IntervalN` int,
			INDEX tmp_EffectiveDate (`EffectiveDate`),
			INDEX tmp_Code (`Code`),
			INDEX tmp_Change (`Change`)
    );
    
     DELETE n1 FROM tblTempRateTableRate n1 
	  INNER JOIN 
			(
			  SELECT MIN(EffectiveDate) as EffectiveDate,Code 
			  FROM tblTempRateTableRate WHERE ProcessId = p_processId
			GROUP BY Code
			HAVING COUNT(*)>1
			)n2 
			ON n1.Code = n2.Code
			AND n2.EffectiveDate = n1.EffectiveDate
			WHERE n1.ProcessId = p_processId;

		  INSERT INTO tmp_TempRateTableRate_
        SELECT distinct `CodeDeckId`,`Code`,`Description`,`Rate`,`EffectiveDate`,`Change`,`ProcessId`,`Preference`,`ConnectionFee`,`Interval1`,`IntervalN` FROM tblTempRateTableRate WHERE tblTempRateTableRate.ProcessId = p_processId;
		 
      
		
	 	     SELECT CodeDeckId INTO v_CodeDeckId_ FROM tmp_TempRateTableRate_ WHERE ProcessId = p_processId  LIMIT 1;

            UPDATE tmp_TempRateTableRate_ as tblTempRateTableRate
            LEFT JOIN tblRate
                ON tblRate.Code = tblTempRateTableRate.Code
                AND tblRate.CompanyID = p_companyId
                AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
                AND tblRate.CodeDeckId =  v_CodeDeckId_
            SET  
                tblTempRateTableRate.Interval1 = CASE WHEN tblTempRateTableRate.Interval1 is not null  and tblTempRateTableRate.Interval1 > 0
                                            THEN    
                                                tblTempRateTableRate.Interval1
                                            ELSE
                                            CASE WHEN tblRate.Interval1 is not null  
                                            THEN    
                                                tblRate.Interval1
                                            ELSE CASE WHEN tblTempRateTableRate.Interval1 is null and (tblTempRateTableRate.Description LIKE '%gambia%' OR tblTempRateTableRate.Description LIKE '%mexico%')
                                                 THEN 
                                                    60
                                            ELSE CASE WHEN tblTempRateTableRate.Description LIKE '%USA%' 
                                                 THEN 
                                                    6
                                                 ELSE 
                                                    1
                                                END
                                            END

                                            END
                                            END,
                tblTempRateTableRate.IntervalN = CASE WHEN tblTempRateTableRate.IntervalN is not null  and tblTempRateTableRate.IntervalN > 0
                                            THEN    
                                                tblTempRateTableRate.IntervalN
                                            ELSE
                                                CASE WHEN tblRate.IntervalN is not null 
                                          THEN
                                            tblRate.IntervalN
                                          ElSE
                                            CASE
                                                WHEN tblTempRateTableRate.Description LIKE '%mexico%' THEN 60
                                            ELSE CASE
                                                WHEN tblTempRateTableRate.Description LIKE '%USA%' THEN 6
                                                
                                            ELSE 
                                            1
                                            END
                                            END
                                          END
                                          END;
                                           
          DROP TEMPORARY TABLE IF EXISTS tmp_TempRateTableRate2_;
			 CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempRateTableRate2_ as (select * from tmp_TempRateTableRate_);   
 
			 IF  p_effectiveImmediately = 1
            THEN
                UPDATE tmp_TempRateTableRate_
                SET EffectiveDate = DATE_FORMAT (NOW(), '%Y-%m-%d')
                WHERE EffectiveDate < DATE_FORMAT (NOW(), '%Y-%m-%d');
          END IF;
          
          
          select count(*) INTO totalduplicatecode FROM(
				SELECT count(code) as c,code FROM tmp_TempRateTableRate_  GROUP BY Code,EffectiveDate HAVING c>1) AS tbl;
			
			
			IF  totalduplicatecode > 0
				THEN
						SELECT GROUP_CONCAT(code) into errormessage FROM(
							select distinct code, 1 as a FROM(
								SELECT   count(code) as c,code FROM tmp_TempRateTableRate_  GROUP BY Code,EffectiveDate HAVING c>1) AS tbl) as tbl2 GROUP by a;				
						INSERT INTO tmp_JobLog_ (Message)		
						SELECT DISTINCT
                        CONCAT(code , ' DUPLICATE CODE')
                        FROM(
								SELECT   count(code) as c,code FROM tmp_TempRateTableRate_  GROUP BY Code,EffectiveDate HAVING c>1) as tbl;
							
			END IF;
			
			IF  totalduplicatecode = 0
			THEN					

            IF  p_addNewCodesToCodeDeck = 1
            THEN

                INSERT INTO tblRate (CompanyID,
                Code,
                Description,
                CreatedBy,
                CountryID,
                CodeDeckId,
                Interval1,
                IntervalN)
                    SELECT DISTINCT
                        p_companyId,
                        vc.Code,
                        vc.Description,
                        'WindowsService',
                       
                        fnGetCountryIdByCodeAndCountry (vc.Code ,vc.Description) AS CountryID,
                        CodeDeckId,
                        Interval1,
                        IntervalN
                    FROM
                    (
                        SELECT DISTINCT
                            tblTempRateTableRate.Code,
                            tblTempRateTableRate.Description,
                            tblTempRateTableRate.CodeDeckId,
                            tblTempRateTableRate.Interval1,
                            tblTempRateTableRate.IntervalN

                        FROM tmp_TempRateTableRate_  as tblTempRateTableRate
                        LEFT JOIN tblRate
					             ON tblRate.Code = tblTempRateTableRate.Code
					             AND tblRate.CompanyID = p_companyId
					             AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
                        WHERE tblRate.RateID IS NULL
                        AND tblTempRateTableRate.`Change` NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')
							) vc;
                         
                   
                        
                        


                SELECT GROUP_CONCAT(code) into errormessage FROM(	
                    SELECT DISTINCT
                        tblTempRateTableRate.Code as Code,1 as a
                    FROM tmp_TempRateTableRate_  as tblTempRateTableRate 
                    INNER JOIN tblRate
				             ON tblRate.Code = tblTempRateTableRate.Code
				             AND tblRate.CompanyID = p_companyId
				             AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
						  WHERE tblRate.CountryID IS NULL
                    AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block')) as tbl GROUP BY a;
                    
                    IF errormessage IS NOT NULL
	                 THEN
	                 		INSERT INTO tmp_JobLog_ (Message)
		                  SELECT DISTINCT
      	                  CONCAT(tblTempRateTableRate.Code , ' INVALID CODE - COUNTRY NOT FOUND ')
      	                  FROM tmp_TempRateTableRate_  as tblTempRateTableRate 
                    INNER JOIN tblRate
				             ON tblRate.Code = tblTempRateTableRate.Code
				             AND tblRate.CompanyID = p_companyId
				             AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
						  WHERE tblRate.CountryID IS NULL
                    AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');
                    
					 	 END IF;
					 	 
            ELSE
                SELECT GROUP_CONCAT(code) into errormessage FROM(
                    SELECT DISTINCT
                        c.Code as code, 1 as a
                    FROM
                    (
                        SELECT DISTINCT
                            tblTempRateTableRate.Code,
                            tblTempRateTableRate.Description
                        FROM tmp_TempRateTableRate_  as tblTempRateTableRate 
                        LEFT JOIN tblRate
			                ON tblRate.Code = tblTempRateTableRate.Code
			                AND tblRate.CompanyID = p_companyId
			                AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
								WHERE tblRate.RateID IS NULL
                        AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')) c) as tbl GROUP BY a;
                        
                 IF errormessage IS NOT NULL
                  THEN
                     INSERT INTO tmp_JobLog_ (Message)
	                  SELECT DISTINCT
                        CONCAT(tbl.Code , ' CODE DOES NOT EXIST IN CODE DECK')
                         FROM
               	     (
                        SELECT DISTINCT
                            tblTempRateTableRate.Code,
                            tblTempRateTableRate.Description
                        FROM tmp_TempRateTableRate_  as tblTempRateTableRate 
                        LEFT JOIN tblRate
			                ON tblRate.Code = tblTempRateTableRate.Code
			                AND tblRate.CompanyID = p_companyId
			                AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
								WHERE tblRate.RateID IS NULL
                        AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')) as tbl;									

					 	END IF;


            END IF;

            IF  p_replaceAllRates = 1
            THEN


                DELETE FROM tblRateTableRate
                WHERE RateTableId = p_ratetableid;

            END IF;

            DELETE tblRateTableRate
                FROM tblRateTableRate
                JOIN tblRate
                    ON tblRate.RateID = tblRateTableRate.RateId
                    AND tblRate.CompanyID = p_companyId
                    JOIN tmp_TempRateTableRate_ as tblTempRateTableRate
                        ON tblRate.Code = tblTempRateTableRate.Code
            WHERE tblRateTableRate.RateTableId = p_ratetableid
                AND tblTempRateTableRate.Change IN ('Delete', 'R', 'D', 'Blocked', 'Block');
           

            UPDATE tblRateTableRate
					INNER JOIN tblRate
					ON tblRateTableRate.RateId = tblRate.RateId
					AND tblRateTableRate.RateTableId = p_ratetableid
					INNER JOIN tmp_TempRateTableRate_ as tblTempRateTableRate
					ON tblRate.Code = tblTempRateTableRate.Code
					AND tblRate.CompanyID = p_companyId
					AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
					AND tblRateTableRate.RateId = tblRate.RateId
					SET tblRateTableRate.ConnectionFee = tblTempRateTableRate.ConnectionFee,
					tblRateTableRate.Interval1 = tblTempRateTableRate.Interval1,
					tblRateTableRate.IntervalN = tblTempRateTableRate.IntervalN
					            WHERE tblRateTableRate.RateTableId = p_ratetableid;

            DELETE tblTempRateTableRate
                FROM tmp_TempRateTableRate_ as tblTempRateTableRate
                JOIN tblRate
                    ON tblRate.Code = tblTempRateTableRate.Code
                    JOIN tblRateTableRate
                        ON tblRateTableRate.RateId = tblRate.RateId
                        AND tblRate.CompanyID = p_companyId
                        AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
                        AND tblRateTableRate.RateTableId = p_ratetableid
                        AND tblTempRateTableRate.Rate = tblRateTableRate.Rate
                        AND (
                        tblRateTableRate.EffectiveDate = tblTempRateTableRate.EffectiveDate 
                        OR  
                        (
                        DATE_FORMAT (tblRateTableRate.EffectiveDate, '%Y-%m-%d') = DATE_FORMAT (tblTempRateTableRate.EffectiveDate, '%Y-%m-%d')
                        )
                        OR 1 = (CASE
                            WHEN tblTempRateTableRate.EffectiveDate > NOW() THEN 1 
                            ELSE 0
                        END)
                        )
            WHERE  tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block');

            SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();


            UPDATE tmp_TempRateTableRate_ as tblTempRateTableRate
            JOIN tblRate
                ON tblRate.Code = tblTempRateTableRate.Code
                AND tblRate.CompanyID = p_companyId
                AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
                JOIN tblRateTableRate
                    ON tblRateTableRate.RateId = tblRate.RateId
                    AND tblRateTableRate.RateTableId = p_ratetableid
				SET tblRateTableRate.Rate = tblTempRateTableRate.Rate
            WHERE tblTempRateTableRate.Rate <> tblRateTableRate.Rate
            AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')
            AND DATE_FORMAT (tblRateTableRate.EffectiveDate, '%Y-%m-%d') = DATE_FORMAT (tblTempRateTableRate.EffectiveDate, '%Y-%m-%d');

            SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();


            INSERT INTO tblRateTableRate (RateTableId,
            RateId,
            Rate,
            EffectiveDate,
            ConnectionFee,
            Interval1,
            IntervalN
            )
                SELECT DISTINCT
                    p_ratetableid,
                    tblRate.RateID,
                    tblTempRateTableRate.Rate,
                    tblTempRateTableRate.EffectiveDate,
                    tblTempRateTableRate.ConnectionFee,
                    tblTempRateTableRate.Interval1,
                    tblTempRateTableRate.IntervalN
                FROM tmp_TempRateTableRate_ as tblTempRateTableRate
                JOIN tblRate
                    ON tblRate.Code = tblTempRateTableRate.Code
                    AND tblRate.CompanyID = p_companyId
                    AND tblRate.CodeDeckId = tblTempRateTableRate.CodeDeckId
                LEFT JOIN tblRateTableRate
						   ON tblRate.RateID = tblRateTableRate.RateId
						   AND tblRateTableRate.RateTableId = p_ratetableid
						   AND tblRateTableRate.EffectiveDate =  tblTempRateTableRate.EffectiveDate
					 WHERE tblRateTableRate.RateTableRateID IS NULL
                AND tblTempRateTableRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block')
                AND tblTempRateTableRate.EffectiveDate >= DATE_FORMAT (NOW(), '%Y-%m-%d');

            SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

	END IF;
      
	 INSERT INTO tmp_JobLog_ (Message)
	 SELECT CONCAT(v_AffectedRecords_ , ' Records Uploaded \n\r ' );
	 
 	 SELECT * from tmp_JobLog_;
	 DELETE  FROM tblTempRateTableRate WHERE  ProcessId = p_processId;
	 
	 SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSProcessVendorRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSProcessVendorRate`(
	IN `p_accountId` INT,
	IN `p_trunkId` INT,
	IN `p_replaceAllRates` INT,
	IN `p_effectiveImmediately` INT,
	IN `p_processId` VARCHAR(200),
	IN `p_addNewCodesToCodeDeck` INT,
	IN `p_companyId` INT,
	IN `p_forbidden` INT,
	IN `p_preference` INT,
	IN `p_dialstringid` INT,
	IN `p_dialcodeSeparator` VARCHAR(50)
)
BEGIN

    DECLARE v_AffectedRecords_ INT DEFAULT 0;
	 DECLARE     v_CodeDeckId_ INT ;
    DECLARE totaldialstringcode INT(11) DEFAULT 0;	 
    DECLARE newstringcode INT(11) DEFAULT 0;
	 DECLARE totalduplicatecode INT(11);	 
	 DECLARE errormessage longtext;
	 DECLARE errorheader longtext;
    
	 SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;    
	 
	 
    DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
    CREATE TEMPORARY TABLE tmp_JobLog_ (
        Message longtext
    );
    
    
    
    DROP TEMPORARY TABLE IF EXISTS tmp_split_VendorRate_;
    CREATE TEMPORARY TABLE tmp_split_VendorRate_ (
    		`TempVendorRateID` int,
			`CodeDeckId` int ,
			`Code` varchar(50) ,
			`Description` varchar(200) ,
			`Rate` decimal(18, 6) ,
			`EffectiveDate` Datetime ,
			`Change` varchar(100) ,
			`ProcessId` varchar(200) ,
			`Preference` varchar(100) ,
			`ConnectionFee` decimal(18, 6),
			`Interval1` int,
			`IntervalN` int,
			`Forbidden` varchar(100) ,
			INDEX tmp_EffectiveDate (`EffectiveDate`),
			INDEX tmp_Code (`Code`),
            INDEX tmp_CC (`Code`,`Change`),
			INDEX tmp_Change (`Change`)
    );
    
    DROP TEMPORARY TABLE IF EXISTS tmp_TempVendorRate_;
    CREATE TEMPORARY TABLE tmp_TempVendorRate_ (
			`CodeDeckId` int ,
			`Code` varchar(50) ,
			`Description` varchar(200) ,
			`Rate` decimal(18, 6) ,
			`EffectiveDate` Datetime ,
			`Change` varchar(100) ,
			`ProcessId` varchar(200) ,
			`Preference` varchar(100) ,
			`ConnectionFee` decimal(18, 6),
			`Interval1` int,
			`IntervalN` int,
			`Forbidden` varchar(100) ,
			INDEX tmp_EffectiveDate (`EffectiveDate`),
			INDEX tmp_Code (`Code`),
            INDEX tmp_CC (`Code`,`Change`),
			INDEX tmp_Change (`Change`)
    );
    
    
    
    DROP TEMPORARY TABLE IF EXISTS tmp_Delete_VendorRate;
	CREATE TEMPORARY TABLE tmp_Delete_VendorRate (
     	VendorRateID INT,
      AccountId INT,
      TrunkID INT,
      RateId INT,
      Code VARCHAR(50),
      Description VARCHAR(200),
      Rate DECIMAL(18, 6),
      EffectiveDate DATETIME,
		Interval1 INT,
		IntervalN INT,
		ConnectionFee DECIMAL(18, 6),
		deleted_at DATETIME,
        INDEX tmp_VendorRateDiscontinued_VendorRateID (`VendorRateID`)
	);

    
    		CALL  prc_checkDialstringAndDupliacteCode(p_companyId,p_processId,p_dialstringid,p_effectiveImmediately,p_dialcodeSeparator);
    		
    		SELECT COUNT(*) AS COUNT INTO newstringcode from tmp_JobLog_; 
	
	 
    IF newstringcode = 0
    THEN
   		
	         IF  p_addNewCodesToCodeDeck = 1
            THEN

					
                INSERT INTO tblRate (CompanyID,
                Code,
                Description,
                CreatedBy,
                CountryID,
                CodeDeckId,
                Interval1,
                IntervalN)
                    SELECT DISTINCT
                        p_companyId,
                        vc.Code,
                        vc.Description,
                        'WindowsService',
                       
                       fnGetCountryIdByCodeAndCountry (vc.Code ,vc.Description) AS CountryID,
                        CodeDeckId,
                        Interval1,
                        IntervalN
                    FROM
                    (
                        SELECT DISTINCT
                            tblTempVendorRate.Code,
                            tblTempVendorRate.Description,
                            tblTempVendorRate.CodeDeckId,
                            tblTempVendorRate.Interval1,
                            tblTempVendorRate.IntervalN

                        FROM tmp_TempVendorRate_  as tblTempVendorRate
                   	     LEFT JOIN tblRate
						             ON tblRate.Code = tblTempVendorRate.Code
						             AND tblRate.CompanyID = p_companyId
						             AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
	                        WHERE tblRate.RateID IS NULL
	                     	   AND tblTempVendorRate.`Change` NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')) vc; 
                  						


               	SELECT GROUP_CONCAT(Code) into errormessage FROM(
                    SELECT DISTINCT
                        tblTempVendorRate.Code as Code, 1 as a
                    FROM tmp_TempVendorRate_  as tblTempVendorRate 
	                    INNER JOIN tblRate
					             ON tblRate.Code = tblTempVendorRate.Code
					             AND tblRate.CompanyID = p_companyId
					             AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
							  WHERE tblRate.CountryID IS NULL
	                 		   AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block')) as tbl GROUP BY a;
                    
                  IF errormessage IS NOT NULL
                  THEN
                  
                    INSERT INTO tmp_JobLog_ (Message)
                    	 SELECT DISTINCT
                        CONCAT(tblTempVendorRate.Code , ' INVALID CODE - COUNTRY NOT FOUND')
                        FROM tmp_TempVendorRate_  as tblTempVendorRate 
                    INNER JOIN tblRate
				             ON tblRate.Code = tblTempVendorRate.Code
				             AND tblRate.CompanyID = p_companyId
				             AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
						  WHERE tblRate.CountryID IS NULL
                    AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block');
                        
					 	END IF;		
					 
            ELSE
                
                SELECT GROUP_CONCAT(code) into errormessage FROM(
                    SELECT DISTINCT
                        c.Code as code, 1 as a
                    FROM
                    (
                        SELECT DISTINCT
                            tblTempVendorRate.Code,
                            tblTempVendorRate.Description
                        FROM tmp_TempVendorRate_  as tblTempVendorRate 
                      	  LEFT JOIN tblRate
				                ON tblRate.Code = tblTempVendorRate.Code
				          	      AND tblRate.CompanyID = p_companyId
				         	       AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
									WHERE tblRate.RateID IS NULL
	                  	      AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')) c) as tbl GROUP BY a;
                        
                  IF errormessage IS NOT NULL
                  THEN
                    INSERT INTO tmp_JobLog_ (Message)
                    		SELECT DISTINCT
                        CONCAT(tbl.Code , ' CODE DOES NOT EXIST IN CODE DECK')
                        FROM
                    (
                        SELECT DISTINCT
                            tblTempVendorRate.Code,
                            tblTempVendorRate.Description
                        FROM tmp_TempVendorRate_  as tblTempVendorRate 
                        LEFT JOIN tblRate
			                ON tblRate.Code = tblTempVendorRate.Code
			                AND tblRate.CompanyID = p_companyId
			                AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
								WHERE tblRate.RateID IS NULL
                        AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')) as tbl;
                        
					 	END IF;		


            END IF;

            IF  p_replaceAllRates = 1
            THEN


                DELETE FROM tblVendorRate
                WHERE AccountId = p_accountId
                    AND TrunkID = p_trunkId;

            END IF;
            				
				
       
		 
		          
            	INSERT INTO tmp_Delete_VendorRate(
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
    		SELECT tblVendorRate.VendorRateID,
    			    p_accountId AS AccountId,
					 p_trunkId AS TrunkID,
					 tblVendorRate.RateId,
					 tblRate.Code,
					 tblRate.Description,
					 tblVendorRate.Rate,
					 tblVendorRate.EffectiveDate,
					 tblVendorRate.Interval1,
					 tblVendorRate.IntervalN,
					 tblVendorRate.ConnectionFee,
					 now() AS deleted_at  		
                FROM tblVendorRate
                JOIN tblRate
                    ON tblRate.RateID = tblVendorRate.RateId
                    AND tblRate.CompanyID = p_companyId
                    JOIN tmp_TempVendorRate_ as tblTempVendorRate
                        ON tblRate.Code = tblTempVendorRate.Code
            WHERE tblVendorRate.AccountId = p_accountId
                AND tblVendorRate.TrunkId = p_trunkId
                AND tblTempVendorRate.Change IN ('Delete', 'R', 'D', 'Blocked', 'Block');    
           
           
			  	CALL prc_InsertDiscontinuedVendorRate(p_accountId,p_trunkId); 

            UPDATE tblVendorRate
					INNER JOIN tblRate
						ON tblVendorRate.RateId = tblRate.RateId
						AND tblVendorRate.AccountId = p_accountId
						AND tblVendorRate.TrunkId = p_trunkId
					INNER JOIN tmp_TempVendorRate_ as tblTempVendorRate
						ON tblRate.Code = tblTempVendorRate.Code
						AND tblRate.CompanyID = p_companyId
						AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
						AND tblVendorRate.RateId = tblRate.RateId
					SET tblVendorRate.ConnectionFee = tblTempVendorRate.ConnectionFee,
						tblVendorRate.Interval1 = tblTempVendorRate.Interval1,
							tblVendorRate.IntervalN = tblTempVendorRate.IntervalN
					WHERE tblVendorRate.AccountId = p_accountId
			            AND tblVendorRate.TrunkId = p_trunkId ;
			    
				 
            IF  p_forbidden = 1 OR p_dialstringid > 0
				THEN
					
					INSERT INTO tblVendorBlocking
					(
						 `AccountId`
						 ,`RateId`
						 ,`TrunkID`
						 ,`BlockedBy`
					)
					SELECT distinct
					   p_accountId as AccountId,
					   tblRate.RateID as RateId,						
						p_trunkId as TrunkID,
						'RMService' as BlockedBy
					 FROM tmp_TempVendorRate_ as tblTempVendorRate
					 INNER JOIN tblRate 
						ON tblRate.Code = tblTempVendorRate.Code
						AND tblRate.CompanyID = p_companyId
			         AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
			       LEFT JOIN tblVendorBlocking vb 			       		
					 	ON vb.AccountId=p_accountId
						 AND vb.RateId = tblRate.RateID
						 AND vb.TrunkID = p_trunkId   
					WHERE tblTempVendorRate.Forbidden IN('B')
					 AND vb.VendorBlockingId is null;
					 
					 DELETE tblVendorBlocking 
					 FROM tblVendorBlocking 
					INNER JOIN(
						select VendorBlockingId 
						FROM `tblVendorBlocking` tv
							INNER JOIN(
							 SELECT 
							 	tblRate.RateId as RateId
							 FROM tmp_TempVendorRate_ as tblTempVendorRate
							INNER JOIN tblRate 
								ON tblRate.Code = tblTempVendorRate.Code
								AND tblRate.CompanyID = p_companyId
					         AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
							WHERE tblTempVendorRate.Forbidden IN('UB')
					     )tv1 on  tv.AccountId=p_accountId
						  	AND tv.TrunkID=p_trunkId
						  	AND tv.RateId = tv1.RateID
					 )vb2 on vb2.VendorBlockingId = tblVendorBlocking.VendorBlockingId;
	
				END IF;
				
				
				
				IF  p_preference = 1
				THEN
				
				INSERT INTO tblVendorPreference
					(
						 `AccountId`
						 ,`Preference`
						 ,`RateId`
						 ,`TrunkID`
						 ,`CreatedBy`
						 ,`created_at`
					)
				SELECT 
					   p_accountId AS AccountId,
					   tblTempVendorRate.Preference as Preference,
					   tblRate.RateID AS RateId,						
						p_trunkId AS TrunkID,
						'RMService' AS CreatedBy,
						NOW() AS created_at
					 FROM tmp_TempVendorRate_ as tblTempVendorRate
					INNER JOIN tblRate 
						ON tblRate.Code = tblTempVendorRate.Code
						AND tblRate.CompanyID = p_companyId
			         AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
					LEFT JOIN tblVendorPreference vp 
						ON vp.RateId=tblRate.RateID
						AND vp.AccountId = p_accountId 	
						AND vp.TrunkID = p_trunkId
					WHERE  tblTempVendorRate.Preference IS NOT NULL
					 AND  tblTempVendorRate.Preference > 0
					 AND  vp.VendorPreferenceID IS NULL;
					 
					 
					 UPDATE tblVendorPreference
					 	INNER JOIN tblRate 
					 		ON tblVendorPreference.RateId=tblRate.RateID
				      INNER JOIN tmp_TempVendorRate_ as tblTempVendorRate
							ON tblTempVendorRate.Code = tblRate.Code							
				         AND tblTempVendorRate.CodeDeckId = tblRate.CodeDeckId   
				         AND tblRate.CompanyID = p_companyId
				      SET tblVendorPreference.Preference = tblTempVendorRate.Preference
						WHERE tblVendorPreference.AccountId = p_accountId  
							AND tblVendorPreference.TrunkID = p_trunkId
							AND  tblTempVendorRate.Preference IS NOT NULL
							AND  tblTempVendorRate.Preference > 0
							AND tblVendorPreference.VendorPreferenceID IS NOT NULL; 
							
						DELETE tblVendorPreference
							from	tblVendorPreference
					 	INNER JOIN tblRate 
					 		ON tblVendorPreference.RateId=tblRate.RateID
				      INNER JOIN tmp_TempVendorRate_ as tblTempVendorRate
							ON tblTempVendorRate.Code = tblRate.Code							
				         AND tblTempVendorRate.CodeDeckId = tblRate.CodeDeckId   
				         AND tblRate.CompanyID = p_companyId
						WHERE tblVendorPreference.AccountId = p_accountId  
							AND tblVendorPreference.TrunkID = p_trunkId
							AND  tblTempVendorRate.Preference IS NOT NULL
							AND  tblTempVendorRate.Preference = '' 
							AND tblVendorPreference.VendorPreferenceID IS NOT NULL; 
					 
				END IF; 
				         

            DELETE tblTempVendorRate
                FROM tmp_TempVendorRate_ as tblTempVendorRate
                JOIN tblRate
                    ON tblRate.Code = tblTempVendorRate.Code
                    JOIN tblVendorRate
                        ON tblVendorRate.RateId = tblRate.RateId
                        AND tblRate.CompanyID = p_companyId
                        AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
                        AND tblVendorRate.AccountId = p_accountId
                        AND tblVendorRate.TrunkId = p_trunkId
                        AND tblTempVendorRate.Rate = tblVendorRate.Rate
                        AND (
                        tblVendorRate.EffectiveDate = tblTempVendorRate.EffectiveDate 
                        OR  
                        (
                        DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') = DATE_FORMAT (tblTempVendorRate.EffectiveDate, '%Y-%m-%d')
                        )
                        OR 1 = (CASE
                            WHEN tblTempVendorRate.EffectiveDate > NOW() THEN 1 
                            ELSE 0
                        END)
                        )
            WHERE  tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block'); 

            SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

				
            UPDATE tmp_TempVendorRate_ as tblTempVendorRate
            JOIN tblRate
                ON tblRate.Code = tblTempVendorRate.Code
                AND tblRate.CompanyID = p_companyId
                AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
                JOIN tblVendorRate
                    ON tblVendorRate.RateId = tblRate.RateId
                    AND tblVendorRate.AccountId = p_accountId
                    AND tblVendorRate.TrunkId = p_trunkId
				SET tblVendorRate.Rate = tblTempVendorRate.Rate
            WHERE tblTempVendorRate.Rate <> tblVendorRate.Rate
            AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked', 'Block')
            AND DATE_FORMAT (tblVendorRate.EffectiveDate, '%Y-%m-%d') = DATE_FORMAT (tblTempVendorRate.EffectiveDate, '%Y-%m-%d');



            SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS();

				
            INSERT INTO tblVendorRate (AccountId,
            TrunkID,
            RateId,
            Rate,
            EffectiveDate,
            ConnectionFee,
            Interval1,
            IntervalN
            )
                SELECT DISTINCT
                    p_accountId,
                    p_trunkId,
                    tblRate.RateID,
                    tblTempVendorRate.Rate,
                    tblTempVendorRate.EffectiveDate,
                    tblTempVendorRate.ConnectionFee,
                    tblTempVendorRate.Interval1,
                    tblTempVendorRate.IntervalN
                FROM tmp_TempVendorRate_ as tblTempVendorRate
                JOIN tblRate
                    ON tblRate.Code = tblTempVendorRate.Code
                    AND tblRate.CompanyID = p_companyId
                    AND tblRate.CodeDeckId = tblTempVendorRate.CodeDeckId
                LEFT JOIN tblVendorRate
					      ON tblRate.RateID = tblVendorRate.RateId
					      AND tblVendorRate.AccountId = p_accountId
					      AND tblVendorRate.trunkid = p_trunkId
					      AND tblTempVendorRate.EffectiveDate = tblVendorRate.EffectiveDate
					WHERE tblVendorRate.VendorRateID IS NULL
                AND tblTempVendorRate.Change NOT IN ('Delete', 'R', 'D', 'Blocked','Block')
                AND tblTempVendorRate.EffectiveDate >= DATE_FORMAT (NOW(), '%Y-%m-%d');

            SET v_AffectedRecords_ = v_AffectedRecords_ + FOUND_ROWS(); 

	 
 END IF;	 
	 
	 					 INSERT INTO tmp_JobLog_ (Message)
	 	SELECT CONCAT(v_AffectedRecords_ , ' Records Uploaded \n\r ' );
	 
 	 SELECT * FROM tmp_JobLog_;
      DELETE  FROM tblTempVendorRate WHERE  ProcessId = p_processId; 
	 
	 SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_WSUpdateAllInProgressJobStatusToPending` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_WSUpdateAllInProgressJobStatusToPending`(IN `p_companyid` INT, IN `p_ModifiedBy` LONGTEXT )
BEGIN
  SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  UPDATE tblJob 
  SET JobStatusID = ( Select tblJobStatus.JobStatusID from tblJobStatus where tblJobStatus.Code = 'P' )
  , updated_at = NOW()
  , ModifiedBy = p_ModifiedBy
  where 
  CompanyID =  p_companyid
 AND JobStatusID = ( Select tblJobStatus.JobStatusID from tblJobStatus where tblJobStatus.Code = 'I' )    ;
 
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_split` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `sp_split`(IN `toSplit` text, IN `target` char(255))
BEGIN
	
	SET @tableName = 'tmpSplit';
	SET @fieldName = 'variable';

	
	SET @sql := CONCAT('DROP TABLE IF EXISTS ', @tableName);
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	
	SET @sql := CONCAT('CREATE TEMPORARY TABLE ', @tableName, ' (', @fieldName, ' VARCHAR(1000))');
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	
	SET @vars := toSplit;
	SET @vars := CONCAT("('", REPLACE(@vars, ",", "'),('"), "')");

	
	SET @sql := CONCAT('INSERT INTO ', @tableName, ' VALUES ', @vars);
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	
	IF target IS NULL THEN
		SET @sql := CONCAT('SELECT TRIM(`', @fieldName, '`) AS `', @fieldName, '` FROM ', @tableName);
	ELSE
		SET @sql := CONCAT('INSERT INTO ', target, ' SELECT TRIM(`', @fieldName, '`) FROM ', @tableName);
	END IF;

	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `testProc` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `testProc`(IN `p_code` TEXT, IN `p_country` TEXT)
BEGIN

DECLARE v_countryId int;

DROP TEMPORARY TABLE IF EXISTS tmp_Prefix;    
CREATE TEMPORARY TABLE tmp_Prefix (Prefix varchar(500) , CountryID int);

INSERT INTO tmp_Prefix 
SELECT DISTINCT
 tblCountry.Prefix,
 tblCountry.CountryID
FROM tblCountry
LEFT OUTER JOIN
 (
	SELECT
	 Prefix
	FROM tblCountry
	GROUP BY Prefix
	HAVING COUNT(*) > 1) d 
	ON tblCountry.Prefix = d.Prefix
Where (p_code LIKE CONCAT(tblCountry.Prefix, '%') AND d.Prefix IS NULL)
	 OR (p_code LIKE CONCAT(tblCountry.Prefix, '%') AND d.Prefix IS NOT NULL 
 		AND (p_country LIKE CONCAT('%', tblCountry.Country, '%'))) ;


DROP TEMPORARY TABLE IF EXISTS tmp_PrefixCopy;  
CREATE TEMPORARY TABLE tmp_PrefixCopy (SELECT * FROM tmp_Prefix);

SELECT DISTINCT p.CountryID , p_code  
FROM tmp_Prefix  p 
JOIN (
		SELECT MAX(Prefix) AS  Prefix 
		 FROM  tmp_PrefixCopy 
	  ) AS MaxPrefix
	 ON MaxPrefix.Prefix = p.Prefix ;
	 


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `vwVendorCurrentRates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `vwVendorCurrentRates`(IN `p_AccountID` INT, IN `p_Trunks` LONGTEXT, IN `p_Effective` VARCHAR(50))
BEGIN	

	DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_(
		AccountId int,
		Code varchar(50),
		Description varchar(200),
		Rate float,
		EffectiveDate date,
		TrunkID int,
		CountryID int,
		RateID int,
		Interval1 INT,
		IntervalN varchar(100),
		ConnectionFee float
    );
    
    DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
    CREATE TEMPORARY TABLE tmp_VendorRate_ (
        TrunkId INT,
	 	  RateId INT,
        Rate DECIMAL(18,6),
        EffectiveDate DATE,
        Interval1 INT,
        IntervalN INT,
        ConnectionFee DECIMAL(18,6),
        INDEX tmp_RateTable_RateId (`RateId`)  
    );
        INSERT INTO tmp_VendorRate_
        SELECT   `TrunkID`, `RateId`, `Rate`, `EffectiveDate`, `Interval1`, `IntervalN`, `ConnectionFee`
		  FROM tblVendorRate WHERE tblVendorRate.AccountId =  p_AccountID 
								AND FIND_IN_SET(tblVendorRate.TrunkId,p_Trunks) != 0 
                        AND 
								(
					  				(p_Effective = 'Now' AND EffectiveDate <= NOW()) 
								  	OR 
								  	(p_Effective = 'Future' AND EffectiveDate > NOW())
								  	OR 
								  	(p_Effective = 'All')
								);

    DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate4_;
       CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate4_ as (select * from tmp_VendorRate_);	        
      DELETE n1 FROM tmp_VendorRate_ n1, tmp_VendorRate4_ n2 WHERE n1.EffectiveDate < n2.EffectiveDate 
 	   AND n1.TrunkID = n2.TrunkID
	   AND  n1.RateId = n2.RateId
		AND n1.EffectiveDate <= NOW()
		AND n2.EffectiveDate <= NOW();
		

    INSERT INTO tmp_VendorCurrentRates_ 
    SELECT DISTINCT
    p_AccountID,
    r.Code,
    r.Description,
    v_1.Rate,
    DATE_FORMAT (v_1.EffectiveDate, '%Y-%m-%d') AS EffectiveDate,
    v_1.TrunkID,
    r.CountryID,
    r.RateID,
   	CASE WHEN v_1.Interval1 is not null
   		THEN v_1.Interval1
    	ELSE r.Interval1
    END as  Interval1,
    CASE WHEN v_1.IntervalN is not null
    	THEN v_1.IntervalN
        ELSE r.IntervalN
    END IntervalN,
    v_1.ConnectionFee
    FROM tmp_VendorRate_ AS v_1
	INNER JOIN tblRate AS r
    	ON r.RateID = v_1.RateId;	 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `vwVendorSippySheet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `vwVendorSippySheet`(IN `p_AccountID` INT, IN `p_Trunks` LONGTEXT, IN `p_Effective` VARCHAR(50))
BEGIN

DROP TEMPORARY TABLE IF EXISTS tmp_VendorSippySheet_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorSippySheet_(
			RateID int,
			`Action [A|D|U|S|SA` varchar(50),
			id varchar(10),
			Prefix varchar(50),
			COUNTRY varchar(200),
			Preference int,
			`Interval 1` int,
			`Interval N` int,
			`Price 1` float,
			`Price N` float,
			`1xx Timeout` int,
			`2xx Timeout` INT,
			Huntstop int,
			Forbidden int,
			`Activation Date` varchar(10),
			`Expiration Date` varchar(10),
			AccountID int,
			TrunkID int
	);
	

call vwVendorCurrentRates(p_AccountID,p_Trunks,p_Effective); 

INSERT INTO tmp_VendorSippySheet_ 
SELECT
    NULL AS RateID,
    'A' AS `Action [A|D|U|S|SA`,
    '' AS id,
    Concat('' , tblTrunk.Prefix ,vendorRate.Code) AS Prefix,
    vendorRate.Description AS COUNTRY,
    IFNULL(tblVendorPreference.Preference,5) as Preference,
    vendorRate.Interval1 as `Interval 1`,
    vendorRate.IntervalN as `Interval N`,
    vendorRate.Rate AS `Price 1`,
    vendorRate.Rate AS `Price N`,
    10 AS `1xx Timeout`,
    60 AS `2xx Timeout`,
    0 AS Huntstop,
    CASE
        WHEN (tblVendorBlocking.VendorBlockingId IS NOT NULL AND
        	FIND_IN_SET(vendorRate.TrunkId,tblVendorBlocking.TrunkId) != 0
			OR
            (blockCountry.VendorBlockingId IS NOT NULL AND
            FIND_IN_SET(vendorRate.TrunkId,blockCountry.TrunkId) != 0
            )
            ) THEN 1
        ELSE 0
    END  AS Forbidden,
    'NOW' AS `Activation Date`,
    '' AS `Expiration Date`,
    tblAccount.AccountID,
    tblTrunk.TrunkID
FROM tmp_VendorCurrentRates_ AS vendorRate
INNER JOIN tblAccount
    ON vendorRate.AccountId = tblAccount.AccountID
LEFT OUTER JOIN tblVendorBlocking
    ON vendorRate.RateID = tblVendorBlocking.RateId
    AND tblAccount.AccountID = tblVendorBlocking.AccountId
    AND vendorRate.TrunkID = tblVendorBlocking.TrunkID
LEFT OUTER JOIN tblVendorBlocking AS blockCountry
    ON vendorRate.CountryID = blockCountry.CountryId
    AND tblAccount.AccountID = blockCountry.AccountId
    AND vendorRate.TrunkID = blockCountry.TrunkID
LEFT JOIN tblVendorPreference 
  ON tblVendorPreference.AccountId = vendorRate.AccountId
  AND tblVendorPreference.TrunkID = vendorRate.TrunkID
  AND tblVendorPreference.RateId = vendorRate.RateID
INNER JOIN tblTrunk
    ON tblTrunk.TrunkID = vendorRate.TrunkID
WHERE (vendorRate.Rate > 0);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `vwVendorVersion3VosSheet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `vwVendorVersion3VosSheet`(IN `p_AccountID` INT, IN `p_Trunks` LONGTEXT, IN `p_Effective` VARCHAR(50))
BEGIN



	DROP TEMPORARY TABLE IF EXISTS tmp_VendorVersion3VosSheet_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorVersion3VosSheet_(
			RateID int,
			`Rate Prefix` varchar(50),
			`Area Prefix` varchar(50),
			`Rate Type` varchar(50),
			`Area Name` varchar(200),
			`Billing Rate` float,
			`Billing Cycle` int,
			`Minute Cost` float,
			`Lock Type` varchar(50),
			`Section Rate` varchar(50),
			`Billing Rate for Calling Card Prompt` float,
			`Billing Cycle for Calling Card Prompt` INT,
			AccountID int,
			TrunkID int,
			EffectiveDate date
	);
	 Call vwVendorCurrentRates(p_AccountID,p_Trunks,p_Effective);	
	 
	 
INSERT INTO tmp_VendorVersion3VosSheet_	 
SELECT


    NULL AS RateID,
    IFNULL(tblTrunk.RatePrefix, '') AS `Rate Prefix`,
    Concat('' , IFNULL(tblTrunk.AreaPrefix, '') , vendorRate.Code) AS `Area Prefix`,
    'International' AS `Rate Type`,
    vendorRate.Description AS `Area Name`,
    vendorRate.Rate / 60 AS `Billing Rate`,
    CASE
        WHEN vendorRate.Description LIKE '%mexico%' THEN 
		  	60
        ELSE 
		  1
    END AS `Billing Cycle`,
    CAST(vendorRate.Rate AS DECIMAL(18, 5)) AS `Minute Cost`,
    CASE
        WHEN (tblVendorBlocking.VendorBlockingId IS NOT NULL AND
        FIND_IN_SET(vendorRate.TrunkId,tblVendorBlocking.TrunkId) != 0
             OR
            (blockCountry.VendorBlockingId IS NOT NULL AND
             FIND_IN_SET(vendorRate.TrunkId,blockCountry.TrunkId) != 0
            )) THEN 'No Lock'
        ELSE 'No Lock'
    END
    AS `Lock Type`,
        CASE WHEN vendorRate.Interval1 != vendorRate.IntervalN 
                                      THEN 
                    Concat('0,', vendorRate.Rate, ',',vendorRate.Interval1)
                                      ELSE ''
                                 END as `Section Rate`,
    0 AS `Billing Rate for Calling Card Prompt`,
    0 AS `Billing Cycle for Calling Card Prompt`,
    tblAccount.AccountID,
    vendorRate.TrunkId,
    vendorRate.EffectiveDate
FROM tmp_VendorCurrentRates_ AS vendorRate
INNER JOIN tblAccount 
    ON vendorRate.AccountId = tblAccount.AccountID
LEFT OUTER JOIN tblVendorBlocking
    ON vendorRate.TrunkId = tblVendorBlocking.TrunkID
    AND vendorRate.RateID = tblVendorBlocking.RateId
    AND tblAccount.AccountID = tblVendorBlocking.AccountId
LEFT OUTER JOIN tblVendorBlocking AS blockCountry
    ON vendorRate.TrunkId = blockCountry.TrunkID
    AND vendorRate.CountryID = blockCountry.CountryId
    AND tblAccount.AccountID = blockCountry.AccountId
INNER JOIN tblTrunk
    ON tblTrunk.TrunkID = vendorRate.TrunkId
WHERE (vendorRate.Rate > 0);



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-04-03 11:35:47
