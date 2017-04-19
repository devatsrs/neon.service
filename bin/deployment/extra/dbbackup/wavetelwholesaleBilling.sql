-- MySQL dump 10.13  Distrib 5.7.11, for Linux (x86_64)
--
-- Host: localhost    Database: wavetelwholesaleBilling
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
-- Table structure for table `tblAccountOneOffCharge`
--

DROP TABLE IF EXISTS `tblAccountOneOffCharge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountOneOffCharge` (
  `AccountOneOffChargeID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountID` int(11) DEFAULT NULL,
  `ProductID` int(11) DEFAULT NULL,
  `Description` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Price` decimal(18,6) DEFAULT NULL,
  `Qty` int(11) DEFAULT NULL,
  `Discount` decimal(18,2) DEFAULT NULL,
  `TaxRateID` int(11) DEFAULT NULL,
  `TaxAmount` decimal(18,6) DEFAULT NULL,
  `Date` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `TaxRateID2` int(11) DEFAULT NULL,
  PRIMARY KEY (`AccountOneOffChargeID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblAccountSubscription`
--

DROP TABLE IF EXISTS `tblAccountSubscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblAccountSubscription` (
  `AccountSubscriptionID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountID` int(11) NOT NULL,
  `SubscriptionID` int(11) NOT NULL,
  `InvoiceDescription` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Qty` int(11) NOT NULL,
  `StartDate` date NOT NULL,
  `EndDate` date DEFAULT NULL,
  `ExemptTax` tinyint(3) unsigned DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ActivationFee` decimal(18,2) DEFAULT NULL,
  `MonthlyFee` decimal(18,2) DEFAULT NULL,
  `WeeklyFee` decimal(18,2) DEFAULT NULL,
  `DailyFee` decimal(18,2) DEFAULT NULL,
  `SequenceNo` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`AccountSubscriptionID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblBillingSettings`
--

DROP TABLE IF EXISTS `tblBillingSettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblBillingSettings` (
  `BillingSettingID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `InvoiceNumberSequence` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `InvoiceStartNumber` int(11) DEFAULT NULL,
  PRIMARY KEY (`BillingSettingID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblBillingSubscription`
--

DROP TABLE IF EXISTS `tblBillingSubscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblBillingSubscription` (
  `SubscriptionID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `Name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Description` longtext COLLATE utf8_unicode_ci,
  `InvoiceLineDescription` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `ActivationFee` decimal(18,2) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CurrencyID` int(11) DEFAULT NULL,
  `MonthlyFee` decimal(18,2) DEFAULT NULL,
  `WeeklyFee` decimal(18,2) DEFAULT NULL,
  `DailyFee` decimal(18,2) DEFAULT NULL,
  `Advance` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`SubscriptionID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblCDRUploadHistory`
--

DROP TABLE IF EXISTS `tblCDRUploadHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblCDRUploadHistory` (
  `CDRUploadHistoryID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `CompanyGatewayID` int(11) NOT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `StartDate` datetime NOT NULL,
  `EndDate` datetime NOT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`CDRUploadHistoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblDispute`
--

DROP TABLE IF EXISTS `tblDispute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblDispute` (
  `DisputeID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `InvoiceType` tinyint(4) NOT NULL,
  `InvoiceNo` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AccountID` int(11) NOT NULL,
  `DisputeAmount` decimal(18,6) NOT NULL,
  `Status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 - Pending, 1- Setteled , 2 - Canceled',
  `Attachment` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Notes` text COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `CreatedBy` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `ModifiedBy` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`DisputeID`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblEstimate`
--

DROP TABLE IF EXISTS `tblEstimate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblEstimate` (
  `EstimateID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `Address` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EstimateNumber` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IssueDate` datetime DEFAULT NULL,
  `CurrencyID` int(11) DEFAULT NULL,
  `PONumber` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SubTotal` decimal(18,6) DEFAULT NULL,
  `TotalDiscount` decimal(18,2) DEFAULT '0.00',
  `TaxRateID` int(11) DEFAULT NULL,
  `TotalTax` decimal(18,6) DEFAULT '0.000000',
  `EstimateTotal` decimal(18,6) DEFAULT NULL,
  `GrandTotal` decimal(18,6) DEFAULT NULL,
  `Description` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Attachment` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Note` longtext COLLATE utf8_unicode_ci,
  `Terms` longtext COLLATE utf8_unicode_ci,
  `EstimateStatus` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PDF` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Payment` decimal(18,6) DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `FooterTerm` longtext COLLATE utf8_unicode_ci,
  `converted` enum('Y','N') COLLATE utf8_unicode_ci DEFAULT 'N',
  PRIMARY KEY (`EstimateID`),
  KEY `IX_AccountID_Status_CompanyID` (`AccountID`,`EstimateStatus`,`CompanyID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblEstimateDetail`
--

DROP TABLE IF EXISTS `tblEstimateDetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblEstimateDetail` (
  `EstimateDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `EstimateID` int(11) NOT NULL,
  `ProductID` int(11) DEFAULT NULL,
  `Description` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Price` decimal(18,6) NOT NULL,
  `Qty` int(11) DEFAULT NULL,
  `Discount` decimal(18,2) DEFAULT NULL,
  `TaxRateID` int(11) DEFAULT NULL,
  `TaxAmount` decimal(18,6) NOT NULL DEFAULT '0.000000',
  `LineTotal` decimal(18,6) NOT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ProductType` int(11) DEFAULT NULL,
  `TaxRateID2` int(11) DEFAULT NULL,
  PRIMARY KEY (`EstimateDetailID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblEstimateLog`
--

DROP TABLE IF EXISTS `tblEstimateLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblEstimateLog` (
  `EstimateLogID` int(11) NOT NULL AUTO_INCREMENT,
  `EstimateID` int(11) DEFAULT NULL,
  `Note` longtext COLLATE utf8_unicode_ci,
  `EstimateLogStatus` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`EstimateLogID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblEstimateTaxRate`
--

DROP TABLE IF EXISTS `tblEstimateTaxRate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblEstimateTaxRate` (
  `EstimateTaxRateID` int(11) NOT NULL AUTO_INCREMENT,
  `EstimateID` int(11) NOT NULL,
  `TaxRateID` int(11) NOT NULL,
  `TaxAmount` decimal(18,6) NOT NULL,
  `Title` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `EstimateTaxType` tinyint(4) NOT NULL DEFAULT '0',
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`EstimateTaxRateID`),
  UNIQUE KEY `IX_EstimateTaxRateUnique` (`EstimateID`,`TaxRateID`,`EstimateTaxType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblGatewayAccount`
--

DROP TABLE IF EXISTS `tblGatewayAccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblGatewayAccount` (
  `GatewayAccountPKID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `CompanyGatewayID` int(11) NOT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountDetailInfo` longtext COLLATE utf8_unicode_ci,
  `IsVendor` tinyint(3) unsigned DEFAULT NULL,
  `GatewayVendorID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `AccountIP` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`GatewayAccountPKID`),
  KEY `IX_tblGatewayAccount_GatewayAccountID_AccountName_5F8A5` (`GatewayAccountID`,`AccountName`,`CompanyGatewayID`),
  KEY `IX_tblGatewayAccount_AccountID_63248` (`AccountID`,`GatewayAccountID`),
  KEY `IX_tblGatewayAccount_AccountID_CDCF2` (`AccountID`),
  KEY `IX_CID_CGID_GAID_AID` (`CompanyID`,`CompanyGatewayID`,`GatewayAccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=9182 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblInvoice`
--

DROP TABLE IF EXISTS `tblInvoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblInvoice` (
  `InvoiceID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `Address` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `InvoiceNumber` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IssueDate` datetime DEFAULT NULL,
  `CurrencyID` int(11) DEFAULT NULL,
  `PONumber` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `InvoiceType` int(11) DEFAULT NULL,
  `SubTotal` decimal(18,6) DEFAULT NULL,
  `TotalDiscount` decimal(18,2) DEFAULT '0.00',
  `TaxRateID` int(11) DEFAULT NULL,
  `TotalTax` decimal(18,6) DEFAULT '0.000000',
  `InvoiceTotal` decimal(18,6) DEFAULT NULL,
  `GrandTotal` decimal(18,6) DEFAULT NULL,
  `Description` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Attachment` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Note` longtext COLLATE utf8_unicode_ci,
  `Terms` longtext COLLATE utf8_unicode_ci,
  `InvoiceStatus` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PDF` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `UsagePath` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PreviousBalance` decimal(18,6) DEFAULT NULL,
  `TotalDue` decimal(18,6) DEFAULT NULL,
  `Payment` decimal(18,6) DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ItemInvoice` tinyint(3) unsigned DEFAULT NULL,
  `FooterTerm` longtext COLLATE utf8_unicode_ci,
  `EstimateID` int(11) DEFAULT NULL,
  `RecurringInvoiceID` int(50) DEFAULT NULL,
  `ProcessID` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FullInvoiceNumber` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`InvoiceID`),
  KEY `IX_AccountID_Status_CompanyID` (`AccountID`,`InvoiceStatus`,`CompanyID`),
  KEY `IX_FullInvoiceNumber` (`FullInvoiceNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=115357 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblInvoiceDetail`
--

DROP TABLE IF EXISTS `tblInvoiceDetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblInvoiceDetail` (
  `InvoiceDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `InvoiceID` int(11) NOT NULL,
  `ProductID` int(11) DEFAULT NULL,
  `Description` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `StartDate` datetime DEFAULT NULL,
  `EndDate` datetime DEFAULT NULL,
  `Price` decimal(18,6) NOT NULL,
  `Qty` int(11) DEFAULT NULL,
  `Discount` decimal(18,2) DEFAULT NULL,
  `TaxRateID` int(11) DEFAULT NULL,
  `TaxAmount` decimal(18,6) NOT NULL DEFAULT '0.000000',
  `LineTotal` decimal(18,6) NOT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ProductType` int(11) DEFAULT NULL,
  `TotalMinutes` bigint(20) DEFAULT NULL,
  `TaxRateID2` int(11) DEFAULT NULL,
  PRIMARY KEY (`InvoiceDetailID`),
  KEY `IX_InvoiceID` (`InvoiceID`),
  KEY `IX_InvoiceID_ProductType` (`InvoiceID`,`ProductType`)
) ENGINE=InnoDB AUTO_INCREMENT=114978 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblInvoiceLog`
--

DROP TABLE IF EXISTS `tblInvoiceLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblInvoiceLog` (
  `InvoiceLogID` int(11) NOT NULL AUTO_INCREMENT,
  `InvoiceID` int(11) DEFAULT NULL,
  `Note` longtext COLLATE utf8_unicode_ci,
  `InvoiceLogStatus` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`InvoiceLogID`)
) ENGINE=InnoDB AUTO_INCREMENT=93895 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblInvoiceReminder`
--

DROP TABLE IF EXISTS `tblInvoiceReminder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblInvoiceReminder` (
  `InvoiceReminderID` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Days` int(11) DEFAULT NULL,
  `CompanyID` int(11) NOT NULL,
  `AccountID` int(11) NOT NULL,
  `TemplateID` int(11) NOT NULL,
  `Status` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ModifiedBy` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`InvoiceReminderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblInvoiceTaxRate`
--

DROP TABLE IF EXISTS `tblInvoiceTaxRate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblInvoiceTaxRate` (
  `InvoiceTaxRateID` int(11) NOT NULL AUTO_INCREMENT,
  `InvoiceID` int(11) NOT NULL,
  `TaxRateID` int(11) NOT NULL,
  `TaxAmount` decimal(18,6) NOT NULL,
  `Title` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `InvoiceTaxType` tinyint(4) NOT NULL DEFAULT '0',
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`InvoiceTaxRateID`),
  UNIQUE KEY `IX_InvoiceTaxRateUnique` (`InvoiceID`,`TaxRateID`,`InvoiceTaxType`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblInvoiceTemplate`
--

DROP TABLE IF EXISTS `tblInvoiceTemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblInvoiceTemplate` (
  `InvoiceTemplateID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CompanyID` int(11) NOT NULL,
  `InvoiceNumberPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `InvoicePages` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `InvoiceStartNumber` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LastInvoiceNumber` bigint(20) DEFAULT NULL,
  `CompanyLogoAS3Key` longtext COLLATE utf8_unicode_ci,
  `CompanyLogoUrl` longtext COLLATE utf8_unicode_ci,
  `Pages` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Header` longtext COLLATE utf8_unicode_ci,
  `Footer` longtext COLLATE utf8_unicode_ci,
  `ShowZeroCall` tinyint(3) unsigned DEFAULT '0',
  `Terms` longtext COLLATE utf8_unicode_ci,
  `Status` tinyint(3) unsigned DEFAULT '0',
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ShowPrevBal` tinyint(3) unsigned DEFAULT NULL,
  `DateFormat` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Type` int(11) DEFAULT NULL,
  `FooterTerm` longtext COLLATE utf8_unicode_ci,
  `ShowBillingPeriod` int(11) DEFAULT '0',
  `EstimateNumberPrefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EstimateStartNumber` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LastEstimateNumber` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`InvoiceTemplateID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblPayment`
--

DROP TABLE IF EXISTS `tblPayment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblPayment` (
  `PaymentID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `AccountID` int(11) NOT NULL,
  `InvoiceNo` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PaymentDate` datetime NOT NULL,
  `PaymentMethod` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `PaymentType` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `Notes` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Amount` decimal(18,8) NOT NULL,
  `Status` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `ModifyBy` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `PaymentProof` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Recall` tinyint(4) NOT NULL DEFAULT '0',
  `RecallReasoan` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `RecallBy` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `CurrencyID` int(11) NOT NULL,
  `BulkUpload` bit(1) DEFAULT b'0',
  `InvoiceID` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`PaymentID`),
  KEY `IX_AccountID_Status_CompanyID` (`AccountID`,`Status`,`CompanyID`),
  KEY `IX_InvoiceNo` (`InvoiceNo`)
) ENGINE=InnoDB AUTO_INCREMENT=79044 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblPaymentOLD`
--

DROP TABLE IF EXISTS `tblPaymentOLD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblPaymentOLD` (
  `PaymentID` int(11) NOT NULL,
  `CompanyID` int(11) NOT NULL,
  `AccountID` int(11) NOT NULL,
  `InvoiceNo` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PaymentDate` datetime NOT NULL,
  `PaymentMethod` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `PaymentType` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `Notes` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Amount` decimal(18,8) NOT NULL,
  `Status` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `ModifyBy` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `PaymentProof` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Recall` tinyint(4) NOT NULL DEFAULT '0',
  `RecallReasoan` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `RecallBy` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `CurrencyID` int(11) NOT NULL,
  `BulkUpload` bit(1) DEFAULT b'0',
  PRIMARY KEY (`PaymentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblProcessID`
--

DROP TABLE IF EXISTS `tblProcessID`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblProcessID` (
  `ProcessID` bigint(20) NOT NULL AUTO_INCREMENT,
  `Process` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ProcessID`),
  UNIQUE KEY `Process` (`Process`)
) ENGINE=InnoDB AUTO_INCREMENT=853781 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblProduct`
--

DROP TABLE IF EXISTS `tblProduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblProduct` (
  `ProductID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyId` int(11) NOT NULL,
  `Name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Code` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` longtext COLLATE utf8_unicode_ci,
  `Amount` decimal(18,2) DEFAULT NULL,
  `Active` tinyint(3) unsigned DEFAULT '1',
  `Note` longtext COLLATE utf8_unicode_ci,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ProductID`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRecurringInvoice`
--

DROP TABLE IF EXISTS `tblRecurringInvoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRecurringInvoice` (
  `RecurringInvoiceID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `Title` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `Address` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillingClassID` int(11) DEFAULT NULL,
  `BillingCycleType` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillingCycleValue` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Occurrence` int(11) DEFAULT '0',
  `PONumber` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Status` int(11) DEFAULT NULL,
  `LastInvoicedDate` datetime DEFAULT NULL,
  `NextInvoiceDate` datetime DEFAULT NULL,
  `CurrencyID` int(11) DEFAULT NULL,
  `InvoiceType` int(11) DEFAULT NULL,
  `SubTotal` decimal(18,6) DEFAULT NULL,
  `TotalDiscount` decimal(18,2) DEFAULT NULL,
  `TaxRateID` int(11) DEFAULT NULL,
  `TotalTax` decimal(10,6) DEFAULT NULL,
  `RecurringInvoiceTotal` decimal(10,6) DEFAULT NULL,
  `GrandTotal` decimal(10,6) DEFAULT NULL,
  `Description` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Attachment` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Note` longtext COLLATE utf8_unicode_ci,
  `Terms` longtext COLLATE utf8_unicode_ci,
  `ItemInvoice` tinyint(3) DEFAULT NULL,
  `FooterTerm` longtext COLLATE utf8_unicode_ci,
  `PDF` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `UsagePath` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`RecurringInvoiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRecurringInvoiceDetail`
--

DROP TABLE IF EXISTS `tblRecurringInvoiceDetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRecurringInvoiceDetail` (
  `RecurringInvoiceDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `RecurringInvoiceID` int(11) NOT NULL,
  `ProductID` int(11) DEFAULT NULL,
  `Description` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Price` decimal(18,6) NOT NULL,
  `Qty` int(11) DEFAULT NULL,
  `Discount` decimal(18,2) DEFAULT NULL,
  `TaxRateID` int(11) DEFAULT NULL,
  `TaxRateID2` int(11) DEFAULT NULL,
  `TaxAmount` decimal(18,6) NOT NULL DEFAULT '0.000000',
  `LineTotal` decimal(18,6) NOT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ProductType` int(11) DEFAULT NULL,
  PRIMARY KEY (`RecurringInvoiceDetailID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRecurringInvoiceLog`
--

DROP TABLE IF EXISTS `tblRecurringInvoiceLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRecurringInvoiceLog` (
  `RecurringInvoicesLogID` int(11) NOT NULL AUTO_INCREMENT,
  `RecurringInvoiceID` int(11) DEFAULT NULL,
  `Note` longtext COLLATE utf8_unicode_ci,
  `RecurringInvoiceLogStatus` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`RecurringInvoicesLogID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRecurringInvoiceTaxRate`
--

DROP TABLE IF EXISTS `tblRecurringInvoiceTaxRate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRecurringInvoiceTaxRate` (
  `RecurringInvoiceTaxRateID` int(11) NOT NULL AUTO_INCREMENT,
  `RecurringInvoiceID` int(11) NOT NULL,
  `TaxRateID` int(11) NOT NULL,
  `TaxAmount` decimal(18,6) NOT NULL,
  `Title` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `RecurringInvoiceTaxType` tinyint(4) NOT NULL DEFAULT '0',
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ModifiedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`RecurringInvoiceTaxRateID`),
  UNIQUE KEY `RecurringInvoiceTaxRateUnique` (`RecurringInvoiceID`,`TaxRateID`,`RecurringInvoiceTaxType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData`
--

DROP TABLE IF EXISTS `tblSummeryData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=46540 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-01-08-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-01-08-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-01-08-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=45753 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-02-01-2017`
--

DROP TABLE IF EXISTS `tblSummeryData-02-01-2017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-02-01-2017` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=62628 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-02-05-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-02-05-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-02-05-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=65712 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-03-10-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-03-10-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-03-10-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=48904 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-04-07-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-04-07-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-04-07-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=50097 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-05-09-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-05-09-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-05-09-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=49122 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-05-12-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-05-12-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-05-12-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=55032 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-06-02-2017`
--

DROP TABLE IF EXISTS `tblSummeryData-06-02-2017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-06-02-2017` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=51347 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-06-02-2017-new`
--

DROP TABLE IF EXISTS `tblSummeryData-06-02-2017-new`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-06-02-2017-new` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=40445 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-06-03-2017`
--

DROP TABLE IF EXISTS `tblSummeryData-06-03-2017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-06-03-2017` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=57821 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-06-04-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-06-04-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-06-04-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=60620 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-09-01-2017`
--

DROP TABLE IF EXISTS `tblSummeryData-09-01-2017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-09-01-2017` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=64968 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-10-10-2017`
--

DROP TABLE IF EXISTS `tblSummeryData-10-10-2017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-10-10-2017` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=45525 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-11-07-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-11-07-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-11-07-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=57050 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-12-09-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-12-09-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-12-09-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=45691 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-12-12-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-12-12-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-12-12-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=50512 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-13-02-2017`
--

DROP TABLE IF EXISTS `tblSummeryData-13-02-2017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-13-02-2017` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=53183 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-13-06-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-13-06-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-13-06-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=63205 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-14-03-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-14-03-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-14-03-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=65112 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-14-11-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-14-11-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-14-11-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=53504 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-15-08-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-15-08-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-15-08-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=70238 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-16-04-2016-telebiz`
--

DROP TABLE IF EXISTS `tblSummeryData-16-04-2016-telebiz`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-16-04-2016-telebiz` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-17-10-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-17-10-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-17-10-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=51552 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-18-07-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-18-07-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-18-07-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=55878 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-19-09-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-19-09-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-19-09-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=48135 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-19-12-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-19-12-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-19-12-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=59960 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-2016-04-25`
--

DROP TABLE IF EXISTS `tblSummeryData-2016-04-25`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-2016-04-25` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=70570 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-2016-06-06`
--

DROP TABLE IF EXISTS `tblSummeryData-2016-06-06`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-2016-06-06` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=76276 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-2016-11-07`
--

DROP TABLE IF EXISTS `tblSummeryData-2016-11-07`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-2016-11-07` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=53340 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-20-02-2017`
--

DROP TABLE IF EXISTS `tblSummeryData-20-02-2017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-20-02-2017` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=60088 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-20-03-2017`
--

DROP TABLE IF EXISTS `tblSummeryData-20-03-2017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-20-03-2017` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=43635 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-20-06-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-20-06-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-20-06-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=66963 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-21-08-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-21-08-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-21-08-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=80981 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-21-11-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-21-11-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-21-11-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=54101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-21-3-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-21-3-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-21-3-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=68302 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-22-08-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-22-08-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-22-08-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=47133 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-23-01-2017`
--

DROP TABLE IF EXISTS `tblSummeryData-23-01-2017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-23-01-2017` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=55991 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-24-10-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-24-10-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-24-10-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=52044 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-25-07-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-25-07-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-25-07-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=54972 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-26-09-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-26-09-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-26-09-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=47898 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-26-12-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-26-12-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-26-12-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=59947 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-27-02-2017`
--

DROP TABLE IF EXISTS `tblSummeryData-27-02-2017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-27-02-2017` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=62408 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-27-03-2017`
--

DROP TABLE IF EXISTS `tblSummeryData-27-03-2017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-27-03-2017` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=47261 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-27-06-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-27-06-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-27-06-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=86157 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-28-03-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-28-03-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-28-03-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=64280 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-28-11-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-28-11-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-28-11-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=50013 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-29-08-216`
--

DROP TABLE IF EXISTS `tblSummeryData-29-08-216`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-29-08-216` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=50525 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-30-01-2017`
--

DROP TABLE IF EXISTS `tblSummeryData-30-01-2017`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-30-01-2017` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=56297 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-30-05-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-30-05-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-30-05-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=72847 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-PTCL-dec-2015`
--

DROP TABLE IF EXISTS `tblSummeryData-PTCL-dec-2015`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-PTCL-dec-2015` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-PTCL-jan-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-PTCL-jan-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-PTCL-jan-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-PTCL-nov-2015`
--

DROP TABLE IF EXISTS `tblSummeryData-PTCL-nov-2015`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-PTCL-nov-2015` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-Telebiz-862-01-03-2016-to-15-03-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-Telebiz-862-01-03-2016-to-15-03-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-Telebiz-862-01-03-2016-to-15-03-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-Telebiz-862-2016-02-16-2016-02-29`
--

DROP TABLE IF EXISTS `tblSummeryData-Telebiz-862-2016-02-16-2016-02-29`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-Telebiz-862-2016-02-16-2016-02-29` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-old-febdata`
--

DROP TABLE IF EXISTS `tblSummeryData-old-febdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-old-febdata` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=79757 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-ptcl-march-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-ptcl-march-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-ptcl-march-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-sippy-11-07-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-sippy-11-07-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-sippy-11-07-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=46224 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-wavecrest-feb-01`
--

DROP TABLE IF EXISTS `tblSummeryData-wavecrest-feb-01`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-wavecrest-feb-01` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummeryData-xotel-01-03-2016-15-03-2016`
--

DROP TABLE IF EXISTS `tblSummeryData-xotel-01-03-2016-15-03-2016`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummeryData-xotel-01-03-2016-15-03-2016` (
  `SummeryDataID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `IP` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GatewayAccountID` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `Gateway` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AccountName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `AreaPrefix` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AreaName` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCalls` int(11) NOT NULL,
  `Duration` decimal(18,2) NOT NULL,
  `TotalCharge` decimal(18,6) NOT NULL,
  `ProcessID` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`SummeryDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=65136 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempPayment`
--

DROP TABLE IF EXISTS `tblTempPayment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempPayment` (
  `PaymentID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `ProcessID` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `AccountID` int(11) NOT NULL,
  `InvoiceNo` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PaymentDate` datetime NOT NULL,
  `PaymentMethod` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `PaymentType` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `Notes` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Amount` decimal(18,8) NOT NULL,
  `Status` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `InvoiceID` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`PaymentID`)
) ENGINE=InnoDB AUTO_INCREMENT=48674 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTempUsageDownloadLog`
--

DROP TABLE IF EXISTS `tblTempUsageDownloadLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTempUsageDownloadLog` (
  `TempUsageDownloadLogID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `ProcessID` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PostProcessStatus` int(11) DEFAULT '0',
  PRIMARY KEY (`TempUsageDownloadLogID`)
) ENGINE=InnoDB AUTO_INCREMENT=2176285 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTransactionLog`
--

DROP TABLE IF EXISTS `tblTransactionLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTransactionLog` (
  `TransactionLogID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL,
  `AccountID` int(11) NOT NULL,
  `InvoiceID` int(11) DEFAULT NULL,
  `Transaction` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Notes` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Amount` decimal(18,6) NOT NULL,
  `Status` tinyint(3) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `ModifyBy` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Reposnse` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`TransactionLogID`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageDaily`
--

DROP TABLE IF EXISTS `tblUsageDaily`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageDaily` (
  `UsageDailyID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `Trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AreaPrefix` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Pincode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Extension` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCharges` double DEFAULT NULL,
  `TotalBilledDuration` int(11) DEFAULT NULL,
  `TotalDuration` int(11) DEFAULT NULL,
  `NoOfCalls` int(11) DEFAULT NULL,
  `DailyDate` datetime DEFAULT NULL,
  PRIMARY KEY (`UsageDailyID`),
  KEY `IX_AccountID_ComapyGatewayID` (`AccountID`,`CompanyGatewayID`),
  KEY `IX_DailyDate` (`DailyDate`)
) ENGINE=InnoDB AUTO_INCREMENT=5043313 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageDownloadFiles`
--

DROP TABLE IF EXISTS `tblUsageDownloadFiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageDownloadFiles` (
  `UsageDownloadFilesID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyGatewayID` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `UpdatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FileName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `Status` int(11) DEFAULT '1' COMMENT '1=pending;2=progress;3=completed;4=error;',
  `ProcessCount` int(11) DEFAULT '0',
  `process_at` datetime DEFAULT NULL,
  `Message` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`UsageDownloadFilesID`),
  UNIQUE KEY `IX_gateway_filename` (`CompanyGatewayID`,`FileName`)
) ENGINE=InnoDB AUTO_INCREMENT=2174416 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageDownloadFilesArchive`
--

DROP TABLE IF EXISTS `tblUsageDownloadFilesArchive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageDownloadFilesArchive` (
  `UsageDownloadFilesID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyGatewayID` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `CreatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `UpdatedBy` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FileName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `Status` int(11) DEFAULT '1' COMMENT '1=pending;2=progress;3=completed;4=error;',
  `ProcessCount` int(11) DEFAULT '0',
  `process_at` datetime DEFAULT NULL,
  `Message` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`UsageDownloadFilesID`),
  UNIQUE KEY `IX_gateway_filename` (`CompanyGatewayID`,`FileName`)
) ENGINE=InnoDB AUTO_INCREMENT=1057433 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageHourly`
--

DROP TABLE IF EXISTS `tblUsageHourly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageHourly` (
  `UsageHourlyID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `Trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AreaPrefix` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCharges` double DEFAULT '0',
  `TotalDuration` int(11) DEFAULT NULL,
  `NoOfCalls` int(11) DEFAULT NULL,
  `PeriodFrom` datetime DEFAULT NULL,
  `PeriodTo` datetime DEFAULT NULL,
  `Duration` int(11) DEFAULT NULL,
  PRIMARY KEY (`UsageHourlyID`),
  KEY `IX_tblUsageHourly_CompanyID_EC544` (`CompanyID`,`CompanyGatewayID`,`GatewayAccountID`,`AreaPrefix`,`PeriodFrom`,`PeriodTo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tempsummery`
--

DROP TABLE IF EXISTS `tempsummery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tempsummery` (
  `Customer Name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `Prefix` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `Country` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `rate1` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `rate2` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `Number of Calls` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Duration` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `Billed Duration` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Charged Amount` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Currency` varchar(100) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'wavetelwholesaleBilling'
--
/*!50003 DROP FUNCTION IF EXISTS `fnFormateDuration` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `fnFormateDuration`(`p_Duration` INT) RETURNS varchar(50) CHARSET utf8 COLLATE utf8_unicode_ci
BEGIN

DECLARE v_FormateDuration_ varchar(50);

SELECT CONCAT( FLOOR(p_Duration  / 60),':' , p_Duration  % 60) INTO v_FormateDuration_;

RETURN v_FormateDuration_;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnGetBillingTime` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `fnGetBillingTime`(
	`p_GatewayID` INT,
	`p_AccountID` INT

) RETURNS int(11)
BEGIN

	DECLARE v_BillingTime_ INT;

	SELECT 
		CASE WHEN REPLACE(JSON_EXTRACT(cg.Settings, '$.BillingTime'),'"','') > 0
		THEN
			CAST(REPLACE(JSON_EXTRACT(cg.Settings, '$.BillingTime'),'"','') AS UNSIGNED INTEGER)
		ELSE
			NULL
		END
	INTO v_BillingTime_
	FROM wavetelwholesaleRM.tblCompanyGateway cg
	INNER JOIN tblGatewayAccount ga ON ga.CompanyGatewayID = cg.CompanyGatewayID
	WHERE (p_AccountID = 0 OR AccountID = p_AccountID ) AND (p_GatewayID = 0 OR ga.CompanyGatewayID = p_GatewayID)
	LIMIT 1;
	
	SET v_BillingTime_ = IFNULL(v_BillingTime_,1);

	RETURN v_BillingTime_;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `FnGetIntegerString` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `FnGetIntegerString`(`str` VARCHAR(50)) RETURNS char(32) CHARSET utf8 COLLATE utf8_unicode_ci
    NO SQL
BEGIN
DECLARE i, len SMALLINT DEFAULT 1;
  DECLARE ret CHAR(32) DEFAULT '';
  DECLARE c CHAR(1);

  IF str IS NULL
  THEN 
    RETURN "";
  END IF; 

  SET len = CHAR_LENGTH( str );
  REPEAT
    BEGIN
      SET c = MID( str, i, 1 );
      IF c BETWEEN '0' AND '9' THEN 
        SET ret=CONCAT(ret,c);
      END IF;
      SET i = i + 1;
    END;
  UNTIL i > len END REPEAT;
  RETURN ret;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `FnGetInvoiceNumber` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `FnGetInvoiceNumber`(
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

SET v_InvoiceTemplateID = CASE WHEN p_BillingClassID=0 THEN (SELECT b.InvoiceTemplateID FROM wavetelwholesaleRM.tblAccountBilling ab INNER JOIN wavetelwholesaleRM.tblBillingClass b ON b.BillingClassID = ab.BillingClassID WHERE AccountID = p_account_id) ELSE (SELECT b.InvoiceTemplateID FROM  wavetelwholesaleRM.tblBillingClass b WHERE b.BillingClassID = p_BillingClassID) END;

SELECT LastInvoiceNumber INTO v_LastInv FROM tblInvoiceTemplate WHERE InvoiceTemplateID =v_InvoiceTemplateID;

set v_FoundVal = (select count(*) as total_res from tblInvoice where FnGetIntegerString(InvoiceNumber)=v_LastInv);
IF v_FoundVal>=1 then
WHILE v_FoundVal>0 DO
	set v_LastInv = v_LastInv+1;
	set v_FoundVal = (select count(*) as total_res from tblInvoice where FnGetIntegerString(InvoiceNumber)=v_LastInv);
END WHILE;
END IF;

return v_LastInv;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnGetMonthDifference` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `fnGetMonthDifference`(`p_Date1` DATE, `p_Date2` DATE) RETURNS int(11)
BEGIN

DECLARE v_Month INT;

SELECT 12 * (YEAR(p_Date2) - YEAR(p_Date1)) + MONTH(p_Date2) -  MONTH(p_Date1) INTO v_Month;

RETURN v_Month;

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

SELECT cs.Value INTO v_Round_ from wavetelwholesaleRM.tblCompanySetting cs where cs.`Key` = 'RoundChargesAmount' AND cs.CompanyID = p_CompanyID;

SET v_Round_ = IFNULL(v_Round_,2);

RETURN v_Round_;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnRounding` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `fnRounding`(
	`p_InputVal` DECIMAL(18,6)

) RETURNS decimal(18,6)
BEGIN

	DECLARE v_InputVal_ DECIMAL(18,6);
	
	SELECT  CEIL(p_InputVal*1000.0)/1000 INTO v_InputVal_;
	
	RETURN v_InputVal_;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnUsageDetail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnUsageDetail`(IN `p_CompanyID` int , IN `p_AccountID` int , IN `p_GatewayID` int , IN `p_StartDate` datetime , IN `p_EndDate` datetime , IN `p_UserID` INT , IN `p_isAdmin` INT, IN `p_billing_time` INT, IN `p_cdr_type` CHAR(1), IN `p_CLI` VARCHAR(50), IN `p_CLD` VARCHAR(50), IN `p_zerovaluecost` INT)
BEGIN
		DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageDetails_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageDetails_(
			AccountID int,
			AccountName varchar(100),
			GatewayAccountID varchar(100),
			trunk varchar(50),
			area_prefix varchar(50),
			pincode VARCHAR(50),
			extension VARCHAR(50),
			UsageDetailID int,
			duration int,
			billed_duration int,
			billed_second int,
			cli varchar(500),
			cld varchar(500),
			cost decimal(18,6),
			connect_time datetime,
			disconnect_time datetime,
			is_inbound tinyint(1) default 0,
			ID INT
	);
	INSERT INTO tmp_tblUsageDetails_
	SELECT
    *
	FROM (SELECT
		uh.AccountID,
		a.AccountName,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		pincode,
		extension,
		UsageDetailID,
		duration,
		billed_duration,
		billed_second,
		cli,
		cld,
		cost,
		connect_time,
		disconnect_time,
		ud.is_inbound,
		ud.ID
	FROM wavetelwholesaleCDR.tblUsageDetails  ud
	INNER JOIN wavetelwholesaleCDR.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	INNER JOIN wavetelwholesaleRM.tblAccount a
		ON uh.AccountID = a.AccountID
	WHERE
	(p_cdr_type = '' OR  ud.is_inbound = p_cdr_type)
	AND  StartDate >= DATE_ADD(p_StartDate,INTERVAL -1 DAY)
	AND StartDate <= DATE_ADD(p_EndDate,INTERVAL 1 DAY)
	AND uh.CompanyID = p_CompanyID
	AND uh.AccountID is not null
	AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
	AND (p_GatewayID = 0 OR CompanyGatewayID = p_GatewayID)
	AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID)) 
	AND (p_CLI = '' OR cli LIKE REPLACE(p_CLI, '*', '%'))	
	AND (p_CLD = '' OR cld LIKE REPLACE(p_CLD, '*', '%'))	
	AND (p_zerovaluecost = 0 OR ( p_zerovaluecost = 1 AND cost = 0) OR ( p_zerovaluecost = 2 AND cost > 0))	
	) tbl
	WHERE 
	(p_billing_time =1 and connect_time >= p_StartDate AND connect_time <= p_EndDate)
	OR 
	(p_billing_time =2 and disconnect_time >= p_StartDate AND disconnect_time <= p_EndDate)
	AND billed_duration > 0
	ORDER BY disconnect_time DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnUsageDetailbyProcessID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnUsageDetailbyProcessID`(IN `p_ProcessID` VARCHAR(200)

)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageDetailsProcess_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageDetailsProcess_(
			CompanyID int,
			CompanyGatewayID int,
			AccountID int,
			trunk varchar(50),			
			area_prefix varchar(50),			
			pincode varchar(50),
			extension VARCHAR(50),
			UsageDetailID int,
			duration int,
			billed_duration int,
			cli varchar(100),
			cld varchar(100),
			cost float,
			connect_time datetime,
			disconnect_time datetime
	);
	INSERT INTO tmp_tblUsageDetailsProcess_
	 SELECT
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.AccountID,
		trunk,
		area_prefix,
		pincode,
		extension,
		UsageDetailID,
		duration,
		billed_duration,
		cli,
		cld,
		cost,
		connect_time,
		disconnect_time
	FROM wavetelwholesaleCDR.tblUsageDetails ud
	INNER JOIN wavetelwholesaleCDR.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE uh.AccountID is not null
	AND  ud.ProcessID = p_ProcessID;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnUsageDetailbyUsageHeaderID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnUsageDetailbyUsageHeaderID`( 
	p_UsageHeaderID INT

)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageDetailswithHeader_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageDetailswithHeader_(
			CompanyID int,
			CompanyGatewayID int,
			AccountID int,
			trunk varchar(50),			
			area_prefix varchar(50),			
			UsageDetailID int,
			duration int,
			billed_duration int,
			cli varchar(100),
			cld varchar(100),
			cost float,
			connect_time datetime,
			disconnect_time datetime
	);
	INSERT INTO tmp_tblUsageDetailswithHeader_
	 SELECT
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.AccountID,
		trunk,
		area_prefix,
		UsageDetailID,
		duration,
		billed_duration,
		cli,
		cld,
		cost,
		connect_time,
		disconnect_time
	FROM wavetelwholesaleCDR.tblUsageDetails ud
	INNER JOIN wavetelwholesaleCDR.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE uh.AccountID is not null
	AND  uh.UsageHeaderID = p_UsageHeaderID;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnVendorUsageDetail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnVendorUsageDetail`(IN `p_CompanyID` INT, IN `p_AccountID` INT, IN `p_GatewayID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_billing_time` INT, IN `p_CLI` VARCHAR(50), IN `p_CLD` VARCHAR(50), IN `p_ZeroValueBuyingCost` INT)
BEGIN
	
	DROP TEMPORARY TABLE IF EXISTS tmp_tblVendorUsageDetails_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblVendorUsageDetails_(
			AccountID INT,
			AccountName VARCHAR(50),
			trunk VARCHAR(50),
			area_prefix VARCHAR(50),
			VendorCDRID INT,
			billed_duration INT,
			cli VARCHAR(500),
			cld VARCHAR(500),
			selling_cost DECIMAL(18,6),
			buying_cost DECIMAL(18,6),
			connect_time DATETIME,
			disconnect_time DATETIME
	);
	INSERT INTO tmp_tblVendorUsageDetails_
	SELECT
    *
	FROM (SELECT
		uh.AccountID,
		a.AccountName,
		trunk,
		area_prefix,
		VendorCDRID,
		billed_duration,
		cli,
		cld,
		selling_cost,
		buying_cost,
		connect_time,
		disconnect_time
	FROM wavetelwholesaleCDR.tblVendorCDR  ud
	INNER JOIN wavetelwholesaleCDR.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID
	INNER JOIN wavetelwholesaleRM.tblAccount a
		ON uh.AccountID = a.AccountID
	WHERE StartDate >= DATE_ADD(p_StartDate,INTERVAL -1 DAY)
	AND StartDate <= DATE_ADD(p_EndDate,INTERVAL 1 DAY)
	AND uh.CompanyID = p_CompanyID
	AND uh.AccountID is not null
	AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
	AND (p_GatewayID = 0 OR CompanyGatewayID = p_GatewayID)
	AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID)) 
	AND (p_CLI = '' OR cli LIKE REPLACE(p_CLI, '*', '%'))	
	AND (p_CLD = '' OR cld LIKE REPLACE(p_CLD, '*', '%'))	
	AND (p_ZeroValueBuyingCost = 0 OR ( p_ZeroValueBuyingCost = 1 AND buying_cost = 0) OR ( p_ZeroValueBuyingCost = 2 AND buying_cost > 0))        
	
	) tbl
	WHERE 
	
	(p_billing_time =1 and connect_time >= p_StartDate AND connect_time <= p_EndDate)
	OR 
	(p_billing_time =2 and disconnect_time >= p_StartDate AND disconnect_time <= p_EndDate)
	AND billed_duration > 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_checkCDRIsLoadedOrNot` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_checkCDRIsLoadedOrNot`(IN `p_AccountID` INT, IN `p_CompanyID` INT, IN `p_UsageEndDate` DATETIME )
BEGIN

    DECLARE v_end_time_ DATE;
    DECLARE v_notInGateeway_ INT;
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    SELECT COUNT(*) INTO v_notInGateeway_ FROM tblGatewayAccount ga
	 INNER  JOIN  wavetelwholesaleRM.tblCompanyGateway cg ON cg.CompanyGatewayID  = ga.CompanyGatewayID AND cg.Status = 1 
	 WHERE ga.AccountID = p_AccountID and ga.CompanyID  = p_CompanyID;    


    IF v_notInGateeway_ > 0 
    THEN

        SELECT DATE_FORMAT(MIN(end_time), '%y-%m-%d') INTO v_end_time_  
        FROM  (
            SELECT  MAX(tmpusglog.end_time) AS end_time ,ga.CompanyGatewayID  
            FROM  tblGatewayAccount ga  
            INNER  JOIN  tblTempUsageDownloadLog tmpusglog on tmpusglog.CompanyGatewayID = ga.CompanyGatewayID
            INNER  JOIN  wavetelwholesaleRM.tblCompanyGateway cg ON cg.CompanyGatewayID  = ga.CompanyGatewayID AND cg.Status = 1 
            WHERE  ga.AccountID = p_AccountID and ga.CompanyID  = p_CompanyID
            GROUP BY ga.CompanyGatewayID
            )TBL;        

        IF p_UsageEndDate < v_end_time_ 
        THEN
            SELECT '1' AS isLoaded;
        ELSE
            SELECT '0' AS isLoaded;
        END IF;
    
    ELSE
        SELECT '1' AS isLoaded;
    END IF;

 	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_Convert_Invoices_to_Estimates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_Convert_Invoices_to_Estimates`(
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
INNER JOIN wavetelwholesaleRM.tblAccount ac ON ac.AccountID = inv.AccountID
INNER JOIN wavetelwholesaleRM.tblAccountBilling ab ON ab.AccountID = ac.AccountID
INNER JOIN wavetelwholesaleRM.tblBillingClass b ON ab.BillingClassID = b.BillingClassID
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
	INNER JOIN wavetelwholesaleRM.tblAccount ON tblAccount.AccountID = tblInvoice.AccountID
	INNER JOIN wavetelwholesaleRM.tblAccountBilling ON tblAccount.AccountID = tblAccountBilling.AccountID
	INNER JOIN wavetelwholesaleRM.tblBillingClass ON tblAccountBilling.BillingClassID = tblBillingClass.BillingClassID
	INNER JOIN tblInvoiceTemplate ON tblBillingClass.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID
	SET FullInvoiceNumber = IF(InvoiceType=1,CONCAT(ltrim(rtrim(IFNULL(tblInvoiceTemplate.InvoiceNumberPrefix,''))), ltrim(rtrim(tblInvoice.InvoiceNumber))),ltrim(rtrim(tblInvoice.InvoiceNumber)))
	WHERE FullInvoiceNumber IS NULL AND tblInvoice.CompanyID = p_CompanyID AND tblInvoice.InvoiceType = 1;
			
				SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_CreateInvoiceFromRecurringInvoice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_CreateInvoiceFromRecurringInvoice`(
	IN `p_CompanyID` INT,
	IN `p_InvoiceIDs` VARCHAR(200),
	IN `p_ModifiedBy` VARCHAR(50),
	IN `p_LogStatus` INT,
	IN `p_ProsessID` VARCHAR(50),
	IN `p_CurrentDate` DATETIME



)
    COMMENT 'test'
BEGIN
	DECLARE v_Note VARCHAR(100);
	DECLARE v_Check int;
	DECLARE v_SkippedWIthDate VARCHAR(200);
	DECLARE v_SkippedWIthOccurence VARCHAR(200);	
	DECLARE v_Message VARCHAR(200);
	DECLARE v_InvoiceID int;
    
   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_Note = CONCAT('Recurring Invoice Generated by ',p_ModifiedBy,' ');
	
	DROP TEMPORARY TABLE IF EXISTS tmp_Invoices_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Invoices_(
		CompanyID int,
		Title varchar(50),
		AccountID int,
		Address varchar(500),
		InvoiceNumber varchar(30),
		IssueDate datetime,
		CurrencyID int,
		PONumber varchar(30),
		InvoiceType int,
		SubTotal decimal(18,6),
		TotalDiscount decimal(18,6),
		TaxRateID int,
		TotalTax decimal(18,6),
		RecurringInvoiceTotal decimal(18,6),
		GrandTotal decimal(18,6),
		Description varchar(100),
		Attachment varchar(200),
		Note  longtext,
		Terms longtext,
		InvoiceStatus varchar(50),
		PDF varchar(500),
		UsagePath varchar(500),
		PreviousBalance decimal(18,6),
		TotalDue decimal(18,6),
		Payment decimal(18,6),
		CreatedBy varchar(50),
		ModifiedBy varchar(50),
		created_at datetime,
		updated_at datetime,
		ItemInvoice tinyint(3),
		FooterTerm longtext,
		RecurringInvoiceID int,
		ProsessID varchar(50),
		NextInvoiceDate datetime,
		Occurrence int,
		BillingClassID int
	);
	
	INSERT INTO tmp_Invoices_ 
 	SELECT rinv.CompanyID,
 				rinv.Title,
	 		 rinv.AccountID,
			 rinv.Address,
			 null as InvoiceNumber,
			 DATE(p_CurrentDate) as IssueDate,
			 rinv.CurrencyID,
			 '' as PONumber,
			 1 as InvoiceType,
			 rinv.SubTotal,
			 rinv.TotalDiscount,
			 rinv.TaxRateID,
			 rinv.TotalTax,
			 rinv.RecurringInvoiceTotal,
			 rinv.GrandTotal,
			 rinv.Description,
			 rinv.Attachment,
			 rinv.Note,
			 rinv.Terms,
			 'awaiting' as InvoiceStatus,
			 rinv.PDF,
			 '' as UsagePath, 
			 0 as PreviousBalance,
			 0 as TotalDue,
			 0 as Payment,
			 rinv.CreatedBy,
			 '' as ModifiedBy,
			p_CurrentDate as created_at,
			p_CurrentDate as updated_at,
			1 as ItemInvoice,
			rinv.FooterTerm,
			rinv.RecurringInvoiceID,
			p_ProsessID,
			rinv.NextInvoiceDate,
			rinv.Occurrence,
			rinv.BillingClassID
		FROM tblRecurringInvoice rinv		
		WHERE rinv.CompanyID = p_CompanyID
		AND rinv.RecurringInvoiceID=p_InvoiceIDs;
			 
		
     SELECT GROUP_CONCAT(CONCAT(temp.Title,': Skipped with INVOICE DATE ',DATE(temp.NextInvoiceDate)) separator '\n\r') INTO v_SkippedWIthDate
	  FROM tmp_Invoices_ temp
	  WHERE (DATE(temp.NextInvoiceDate) > DATE(p_CurrentDate));
	  
	  
	  SELECT GROUP_CONCAT(CONCAT(temp.Title,': Skipped with exceding limit Occurrence ',(SELECT COUNT(InvoiceID) FROM tblInvoice WHERE InvoiceStatus!='cancel' AND RecurringInvoiceID=temp.RecurringInvoiceID)) separator '\n\r') INTO v_SkippedWIthOccurence
	  FROM tmp_Invoices_ temp
	  	WHERE (temp.Occurrence > 0 
		  	AND (SELECT COUNT(InvoiceID) FROM tblInvoice WHERE InvoiceStatus!='cancel' AND RecurringInvoiceID=temp.RecurringInvoiceID) >= temp.Occurrence);
     
     
     SELECT CASE 
	  				WHEN ((v_SkippedWIthDate IS NOT NULL) OR (v_SkippedWIthOccurence IS NOT NULL)) 
					THEN CONCAT(IFNULL(v_SkippedWIthDate,''),'\n\r',IFNULL(v_SkippedWIthOccurence,'')) ELSE '' 
				END as message INTO v_Message;

	IF(v_Message="") THEN
        

		INSERT INTO tblInvoice (`CompanyID`, `AccountID`, `Address`, `InvoiceNumber`, `IssueDate`, `CurrencyID`, `PONumber`, `InvoiceType`, `SubTotal`, `TotalDiscount`, `TaxRateID`, `TotalTax`, `InvoiceTotal`, `GrandTotal`, `Description`, `Attachment`, `Note`, `Terms`, `InvoiceStatus`, `PDF`, `UsagePath`, `PreviousBalance`, `TotalDue`, `Payment`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `ItemInvoice`, `FooterTerm`,RecurringInvoiceID,ProcessID)
	 	SELECT 
		 rinv.CompanyID,
		 rinv.AccountID,
		 rinv.Address,
		 FNGetInvoiceNumber(rinv.AccountID,rinv.BillingClassID) as InvoiceNumber,
		 DATE(p_CurrentDate) as IssueDate,
		 rinv.CurrencyID,
		 '' as PONumber,
		 1 as InvoiceType,
		 rinv.SubTotal,
		 rinv.TotalDiscount,
		 rinv.TaxRateID,
		 rinv.TotalTax,
		 rinv.RecurringInvoiceTotal,
		 rinv.GrandTotal,
		 rinv.Description,
		 rinv.Attachment,
		 rinv.Note,
		 rinv.Terms,
		 'awaiting' as InvoiceStatus,
		 rinv.PDF,
		 '' as UsagePath, 
		 0 as PreviousBalance,
		 0 as TotalDue,
		 0 as Payment,
		 rinv.CreatedBy,
		 '' as ModifiedBy,
		p_CurrentDate as created_at,
		p_CurrentDate as updated_at,
		1 as ItemInvoice,
		rinv.FooterTerm,
		rinv.RecurringInvoiceID,
		p_ProsessID
		FROM tmp_Invoices_ rinv;
		
		SET v_InvoiceID = LAST_INSERT_ID();

		INSERT INTO tblInvoiceDetail ( `InvoiceID`, `ProductID`, `Description`, `StartDate`, `EndDate`, `Price`, `Qty`, `Discount`, `TaxRateID`,`TaxRateID2`, `TaxAmount`, `LineTotal`, `CreatedBy`, `ModifiedBy`, `created_at`, `updated_at`, `ProductType`)
			select 
				inv.InvoiceID,
				rinvd.ProductID,
				rinvd.Description,
				null as StartDate,
				null as EndDate,
				rinvd.Price,
				rinvd.Qty,
				rinvd.Discount,
				rinvd.TaxRateID,
				rinvd.TaxRateID2,
				rinvd.TaxAmount,
				rinvd.LineTotal,
				rinvd.CreatedBy,
				rinvd.ModifiedBy,	
				rinvd.created_at,	
				p_CurrentDate as updated_at,
				rinvd.ProductType	
				FROM tblRecurringInvoiceDetail rinvd
				INNER JOIN tblInvoice inv ON  inv.RecurringInvoiceID = rinvd.RecurringInvoiceID
				INNER JOIN tblRecurringInvoice rinv ON  rinv.RecurringInvoiceID = rinvd.RecurringInvoiceID
				WHERE rinv.CompanyID = p_CompanyID
				AND inv.InvoiceID = v_InvoiceID;
				
		INSERT INTO tblInvoiceTaxRate ( `InvoiceID`, `TaxRateID`, `TaxAmount`,`InvoiceTaxType`,`Title`, `CreatedBy`,`ModifiedBy`)
		SELECT 
			inv.InvoiceID,
			rinvt.TaxRateID,
			rinvt.TaxAmount,
			rinvt.RecurringInvoiceTaxType,
			rinvt.Title,
			rinvt.CreatedBy,
			rinvt.ModifiedBy
		FROM tblRecurringInvoiceTaxRate rinvt
		INNER JOIN tblInvoice inv ON  inv.RecurringInvoiceID = rinvt.RecurringInvoiceID
		INNER JOIN tblRecurringInvoice rinv ON  rinv.RecurringInvoiceID = rinvt.RecurringInvoiceID
		WHERE rinv.CompanyID = p_CompanyID
		AND inv.InvoiceID = v_InvoiceID;
			
		INSERT INTO tblInvoiceLog (InvoiceID,Note,InvoiceLogStatus,created_at)
		SELECT inv.InvoiceID,CONCAT(v_Note, CONCAT(LTRIM(RTRIM(IFNULL(tblInvoiceTemplate.InvoiceNumberPrefix,''))), LTRIM(RTRIM(inv.InvoiceNumber)))) as Note,1 as InvoiceLogStatus,p_CurrentDate as created_at  
		FROM tblInvoice inv
		INNER JOIN tblRecurringInvoice rinv ON  inv.RecurringInvoiceID =  rinv.RecurringInvoiceID
		INNER JOIN wavetelwholesaleRM.tblBillingClass b ON rinv.BillingClassID = b.BillingClassID
		INNER JOIN tblInvoiceTemplate ON b.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID		
		WHERE rinv.CompanyID = p_CompanyID
		AND inv.InvoiceID = v_InvoiceID;
			
			
		INSERT INTO tblRecurringInvoiceLog (RecurringInvoiceID,Note,RecurringInvoiceLogStatus,created_at)
		SELECT inv.RecurringInvoiceID,CONCAT(v_Note, CONCAT(LTRIM(RTRIM(IFNULL(tblInvoiceTemplate.InvoiceNumberPrefix,''))), LTRIM(RTRIM(inv.InvoiceNumber)))) as Note,p_LogStatus as InvoiceLogStatus,p_CurrentDate as created_at  
		FROM tblInvoice inv
		INNER JOIN tblRecurringInvoice rinv ON  inv.RecurringInvoiceID =  rinv.RecurringInvoiceID
		INNER JOIN wavetelwholesaleRM.tblBillingClass b ON rinv.BillingClassID = b.BillingClassID
		INNER JOIN tblInvoiceTemplate ON b.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID
		WHERE rinv.CompanyID = p_CompanyID
		AND inv.InvoiceID = v_InvoiceID;
		
		
		
		UPDATE tblInvoice inv 
		INNER JOIN tblRecurringInvoice rinv ON  inv.RecurringInvoiceID =  rinv.RecurringInvoiceID
		INNER JOIN wavetelwholesaleRM.tblBillingClass b ON rinv.BillingClassID = b.BillingClassID
		INNER JOIN tblInvoiceTemplate ON b.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID
		SET FullInvoiceNumber = IF(inv.InvoiceType=1,CONCAT(ltrim(rtrim(IFNULL(tblInvoiceTemplate.InvoiceNumberPrefix,''))), ltrim(rtrim(inv.InvoiceNumber))),ltrim(rtrim(inv.InvoiceNumber)))
		WHERE inv.CompanyID = p_CompanyID 
		AND inv.InvoiceID = v_InvoiceID;
	
	END IF;
	
	SELECT v_Message as Message, IFNULL(v_InvoiceID,0) as InvoiceID;
			
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_CustomerPanel_getInvoice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_CustomerPanel_getInvoice`(IN `p_CompanyID` INT, IN `p_AccountID` INT, IN `p_InvoiceNumber` VARCHAR(50), IN `p_IssueDateStart` DATETIME, IN `p_IssueDateEnd` DATETIME, IN `p_InvoiceType` INT, IN `p_IsOverdue` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT, IN `p_zerovalueinvoice` INT)
BEGIN
	DECLARE v_OffSet_ int;
	DECLARE v_Round_ int;
	DECLARE v_CurrencyCode_ VARCHAR(50);
	DECLARE v_TotalCount int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET  sql_mode='ONLY_FULL_GROUP_BY,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	DROP TEMPORARY TABLE IF EXISTS tmp_Invoices_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Invoices_(
		InvoiceType tinyint(1),
		AccountName varchar(100),
		InvoiceNumber varchar(100),
		IssueDate datetime,
		InvoicePeriod varchar(100),
		CurrencySymbol varchar(5),
		GrandTotal decimal(18,6),
		TotalPayment decimal(18,6),
		PendingAmount decimal(18,6),
		InvoiceStatus varchar(50),
		InvoiceID int,
		Description varchar(500),
		Attachment varchar(255),
		AccountID int,
		ItemInvoice tinyint(1),
		BillingEmail varchar(255),
		AccountNumber varchar(100),
		PaymentDueInDays int,
		PaymentDate datetime,
		SubTotal decimal(18,6),
		TotalTax decimal(18,6),
		NominalAnalysisNominalAccountNumber varchar(100)
	);
	
		insert into tmp_Invoices_
		SELECT inv.InvoiceType ,
			ac.AccountName,
			FullInvoiceNumber as InvoiceNumber,
			inv.IssueDate,
			IF(invd.StartDate IS NULL ,'',CONCAT('From ',date(invd.StartDate) ,'<br> To ',date(invd.EndDate))) as InvoicePeriod,
			IFNULL(cr.Symbol,'') as CurrencySymbol,
			inv.GrandTotal as GrandTotal,		
			(select IFNULL(sum(p.Amount),0) from tblPayment p where p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) as TotalPayment,
			(inv.GrandTotal -  (select IFNULL(sum(p.Amount),0) from tblPayment p where p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) ) as `PendingAmount`,
			inv.InvoiceStatus,
			inv.InvoiceID,
			inv.Description,
			inv.Attachment,
			inv.AccountID,
			inv.ItemInvoice,
			IFNULL(ac.BillingEmail,'') as BillingEmail,
			ac.Number,
			(SELECT IFNULL(b.PaymentDueInDays,0) FROM wavetelwholesaleRM.tblAccountBilling ab INNER JOIN wavetelwholesaleRM.tblBillingClass b ON b.BillingClassID =ab.BillingClassID WHERE ab.AccountID = ac.AccountID) as PaymentDueInDays,
			(select PaymentDate from tblPayment p where p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.Recall =0 AND p.AccountID = inv.AccountID order by PaymentID desc limit 1) AS PaymentDate,
			inv.SubTotal,
			inv.TotalTax,
			ac.NominalAnalysisNominalAccountNumber		
			FROM tblInvoice inv
			INNER JOIN wavetelwholesaleRM.tblAccount ac on ac.AccountID = inv.AccountID
			LEFT JOIN tblInvoiceDetail invd on invd.InvoiceID = inv.InvoiceID AND invd.ProductType = 2
			LEFT JOIN wavetelwholesaleRM.tblCurrency cr ON inv.CurrencyID   = cr.CurrencyId 
			WHERE ac.CompanyID = p_CompanyID
					AND (inv.AccountID = p_AccountID)
					AND ( (IFNULL(inv.InvoiceStatus,'') = '') OR  inv.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'awaiting'))
					AND (p_InvoiceNumber = '' OR ( p_InvoiceNumber != '' AND inv.InvoiceNumber = p_InvoiceNumber))
					AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND inv.IssueDate >= p_IssueDateStart))
					AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND inv.IssueDate <= p_IssueDateEnd))
					AND (p_InvoiceType = 0 OR ( p_InvoiceType != 0 AND inv.InvoiceType = p_InvoiceType))
					AND (p_zerovalueinvoice = 0 OR ( p_zerovalueinvoice = 1 AND inv.GrandTotal > 0));
				
	IF p_isExport = 0
	THEN	
		SELECT 
			InvoiceType ,
			AccountName,
			InvoiceNumber,
			IssueDate,
			CONCAT(CurrencySymbol, ROUND(GrandTotal,v_Round_)) as GrandTotal2,
			CONCAT(CurrencySymbol,ROUND(TotalPayment,v_Round_),'/',ROUND(PendingAmount,v_Round_)) as `PendingAmount`,
			InvoiceStatus,
			InvoiceID,
			Description,
			Attachment,
			AccountID,
			PendingAmount as OutstandingAmount, 
			ItemInvoice,
			BillingEmail,
			GrandTotal
		FROM tmp_Invoices_
		WHERE (p_IsOverdue = 0 
							OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
									AND(PendingAmount>0)
								)
						)
		ORDER BY
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN AccountName
			END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN AccountName
			END ASC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceTypeDESC') THEN InvoiceType
			END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceTypeASC') THEN InvoiceType
			END ASC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceStatusDESC') THEN InvoiceStatus
			END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceStatusASC') THEN InvoiceStatus
			END ASC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNumberASC') THEN InvoiceNumber
			END ASC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNumberDESC') THEN InvoiceNumber
			END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IssueDateASC') THEN IssueDate
			END ASC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IssueDateDESC') THEN IssueDate
			END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalDESC') THEN GrandTotal
			END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalASC') THEN GrandTotal
			END ASC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceIDDESC') THEN InvoiceID
			END DESC,
			CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceIDASC') THEN InvoiceID
			END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;


		SELECT COUNT(*) into v_TotalCount FROM tmp_Invoices_
		WHERE (p_IsOverdue = 0 
							OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
									AND(PendingAmount>0)
								)
						);

		SELECT
			v_TotalCount AS totalcount,
			ROUND(sum(GrandTotal),v_Round_) as total_grand,
			ROUND(sum(TotalPayment),v_Round_) as `TotalPayment`, 
			ROUND(sum(PendingAmount),v_Round_) as `TotalPendingAmount`,
			v_CurrencyCode_ as currency_symbol
		FROM tmp_Invoices_
		WHERE (p_IsOverdue = 0 
							OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
									AND(PendingAmount>0)
								)
						);
	END IF;
	IF p_isExport = 1
	THEN
		SELECT
			AccountName,
			InvoiceNumber,
			IssueDate,
			CONCAT(CurrencySymbol, ROUND(GrandTotal,v_Round_)) as GrandTotal2,
			CONCAT(CurrencySymbol,ROUND(TotalPayment,v_Round_),'/',ROUND(PendingAmount,v_Round_)) as `Paid/OS`,
			InvoiceStatus,
			InvoiceType,
			ItemInvoice
		FROM tmp_Invoices_
		WHERE (p_IsOverdue = 0 
						OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
								AND(PendingAmount>0)
							)
					);
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_DeleteCDR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_DeleteCDR`(
	IN `p_CompanyID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AccountID` INT,
	IN `p_CDRType` CHAR(1),
	IN `p_CLI` VARCHAR(50),
	IN `p_CLD` VARCHAR(50),
	IN `p_zerovaluecost` INT,
	IN `p_CurrencyID` INT,
	IN `p_area_prefix` VARCHAR(50),
	IN `p_trunk` VARCHAR(50)
)
BEGIN

	DECLARE v_BillingTime_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT fnGetBillingTime(p_GatewayID,p_AccountID) INTO v_BillingTime_;

	DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageDetail_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageDetail_ AS (

		SELECT
		UsageDetailID
		FROM 
		(
			SELECT
				uh.AccountID,
				a.AccountName,
				trunk,
				area_prefix,
				UsageDetailID,
				duration,
				billed_duration,
				cli,
				cld,
				cost,
				connect_time,
				disconnect_time
			FROM `wavetelwholesaleCDR`.tblUsageDetails  ud 
			INNER JOIN `wavetelwholesaleCDR`.tblUsageHeader uh
				ON uh.UsageHeaderID = ud.UsageHeaderID
			INNER JOIN wavetelwholesaleRM.tblAccount a
				ON uh.AccountID = a.AccountID
			WHERE StartDate >= DATE_ADD(p_StartDate,INTERVAL -1 DAY)
				AND StartDate <= DATE_ADD(p_EndDate,INTERVAL 1 DAY)
				AND uh.CompanyID = p_CompanyID
				AND uh.AccountID is not null
				AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
				AND (p_GatewayID = 0 OR CompanyGatewayID = p_GatewayID)
				AND (p_CDRType = '' OR ud.is_inbound = p_CDRType)
				AND (p_CLI = '' OR cli LIKE REPLACE(p_CLI, '*', '%'))	
				AND (p_CLD = '' OR cld LIKE REPLACE(p_CLD, '*', '%'))	
				AND (p_zerovaluecost = 0 OR ( p_zerovaluecost = 1 AND cost = 0) OR ( p_zerovaluecost = 2 AND cost > 0))
				AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
				AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
				AND (p_trunk = '' OR trunk = p_trunk )

		) tbl
		WHERE 

			(v_BillingTime_ =1 and connect_time >= p_StartDate AND connect_time <= p_EndDate)
			OR 
			(v_BillingTime_ =2 and disconnect_time >= p_StartDate AND disconnect_time <= p_EndDate)
			AND billed_duration > 0
	);


		
	DELETE ud.*
	FROM `wavetelwholesaleCDR`.tblUsageDetails ud
	INNER JOIN tmp_tblUsageDetail_ uds 
		ON ud.UsageDetailID = uds.UsageDetailID;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_DeleteRecurringInvoices` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_DeleteRecurringInvoices`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_RecurringInvoiceStatus` INT,
	IN `p_InvoiceIDs` VARCHAR(200)
)
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DELETE invd FROM tblRecurringInvoiceDetail invd
	INNER JOIN tblRecurringInvoice inv ON invd.RecurringInvoiceID = inv.RecurringInvoiceID
	WHERE inv.CompanyID = p_CompanyID
	AND ((p_InvoiceIDs='' 
			AND (p_AccountID = 0 OR inv.AccountID=p_AccountID) 
			AND (p_RecurringInvoiceStatus=2 OR inv.`Status`=p_RecurringInvoiceStatus))
			OR (p_InvoiceIDs<>'' AND FIND_IN_SET(inv.RecurringInvoiceID ,p_InvoiceIDs))
		 );
	
	DELETE invlg FROM tblRecurringInvoiceLog invlg
	INNER JOIN tblRecurringInvoice inv ON invlg.RecurringInvoiceID = inv.RecurringInvoiceID
	WHERE inv.CompanyID = p_CompanyID
	AND ((p_InvoiceIDs='' 
			AND (p_AccountID = 0 OR inv.AccountID=p_AccountID) 
			AND (p_RecurringInvoiceStatus=2 OR inv.`Status`=p_RecurringInvoiceStatus))
			OR (p_InvoiceIDs<>'' AND FIND_IN_SET(inv.RecurringInvoiceID ,p_InvoiceIDs))
		 );
	
	DELETE invtr FROM tblRecurringInvoiceTaxRate invtr
	INNER JOIN tblRecurringInvoice inv ON invtr.RecurringInvoiceID = inv.RecurringInvoiceID
	WHERE inv.CompanyID = p_CompanyID
	AND ((p_InvoiceIDs='' 
			AND (p_AccountID = 0 OR inv.AccountID=p_AccountID) 
			AND (p_RecurringInvoiceStatus=2 OR inv.`Status`=p_RecurringInvoiceStatus))
			OR (p_InvoiceIDs<>'' AND FIND_IN_SET(inv.RecurringInvoiceID ,p_InvoiceIDs))
		 );
		 
	UPDATE tblInvoice inv
	INNER JOIN tblRecurringInvoice rinv ON inv.RecurringInvoiceID = rinv.RecurringInvoiceID
	AND rinv.CompanyID = p_CompanyID
	AND ((p_InvoiceIDs='' 
			AND (p_AccountID = 0 OR rinv.AccountID=p_AccountID) 
			AND (p_RecurringInvoiceStatus=2 OR rinv.`Status`=p_RecurringInvoiceStatus))
			OR (p_InvoiceIDs<>'' AND FIND_IN_SET(rinv.RecurringInvoiceID ,p_InvoiceIDs))
		 )
	SET inv.RecurringInvoiceID=0;
	
	DELETE inv FROM tblRecurringInvoice inv
	WHERE inv.CompanyID = p_CompanyID
	AND ((p_InvoiceIDs='' 
			AND (p_AccountID = 0 OR inv.AccountID=p_AccountID) 
			AND (p_RecurringInvoiceStatus=2 OR inv.`Status`=p_RecurringInvoiceStatus))
			OR (p_InvoiceIDs<>'' AND FIND_IN_SET(inv.RecurringInvoiceID ,p_InvoiceIDs))
		 );
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_DeleteVCDR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_DeleteVCDR`(
	IN `p_CompanyID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AccountID` INT,
	IN `p_CLI` VARCHAR(250),
	IN `p_CLD` VARCHAR(250),
	IN `p_zerovaluecost` INT,
	IN `p_CurrencyID` INT,
	IN `p_area_prefix` VARCHAR(50),
	IN `p_trunk` VARCHAR(50)
)
    COMMENT 'Delete Vendor CDR'
BEGIN

    DECLARE v_BillingTime_ int;
    SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

		SELECT fnGetBillingTime(p_GatewayID,p_AccountID) INTO v_BillingTime_;
        
        
        CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageDetail_ AS 
        (

	        SELECT
	        VendorCDRID
	        
	        FROM (SELECT
	            ud.VendorCDRID,
	            billed_duration,
	            connect_time,
	            disconnect_time,
	            cli,
	            cld,
	            buying_cost,
	            CompanyGatewayID,
	            uh.AccountID
	
			FROM `wavetelwholesaleCDR`.tblVendorCDR  ud 
			INNER JOIN `wavetelwholesaleCDR`.tblVendorCDRHeader uh
				ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID
	        LEFT JOIN wavetelwholesaleRM.tblAccount a
	            ON uh.AccountID = a.AccountID
	        WHERE StartDate >= DATE_ADD(p_StartDate,INTERVAL -1 DAY)
			  AND StartDate <= DATE_ADD(p_EndDate,INTERVAL 1 DAY)
	        AND uh.CompanyID = p_CompanyID
	        AND uh.AccountID is not null
	        AND (p_AccountID = 0 OR uh.AccountID = p_AccountID)
	        AND (p_GatewayID = 0 OR CompanyGatewayID = p_GatewayID)
	        AND (p_CLI = '' OR cli LIKE REPLACE(p_CLI, '*', '%'))	
			  AND (p_CLD = '' OR cld LIKE REPLACE(p_CLD, '*', '%'))
			  AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
			  AND (p_trunk = '' OR trunk = p_trunk )	
				AND (p_zerovaluecost = 0 OR ( p_zerovaluecost = 1 AND buying_cost = 0) OR ( p_zerovaluecost = 2 AND buying_cost > 0))
			  AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
	        ) tbl
	        WHERE 
	    
	        (v_BillingTime_ =1 and connect_time >= p_StartDate AND connect_time <= p_EndDate)
	        OR 
	        (v_BillingTime_ =2 and disconnect_time >= p_StartDate AND disconnect_time <= p_EndDate)
	        AND billed_duration > 0
        );


		
		 delete ud.*
        From `wavetelwholesaleCDR`.tblVendorCDR ud
        inner join tmp_tblUsageDetail_ uds on ud.VendorCDRID = uds.VendorCDRID;
        
        SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getAccountInvoiceTotal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getAccountInvoiceTotal`(
	IN `p_AccountID` INT,
	IN `p_CompanyID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_checkDuplicate` INT,
	IN `p_InvoiceDetailID` INT
)
BEGIN 
	DECLARE v_InvoiceCount_ INT; 
	DECLARE v_BillingTime_ INT; 
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetBillingTime(p_GatewayID,p_AccountID) INTO v_BillingTime_;
	
	CALL fnUsageDetail(p_CompanyID,p_AccountID,p_GatewayID,p_StartDate,p_EndDate,0,1,v_BillingTime_,'','','',0); 
	
	IF p_checkDuplicate = 1 THEN
	
		SELECT COUNT(inv.InvoiceID) INTO v_InvoiceCount_
		FROM tblInvoice inv
		LEFT JOIN tblInvoiceDetail invd ON invd.InvoiceID = inv.InvoiceID
		WHERE inv.CompanyID = p_CompanyID AND (p_InvoiceDetailID = 0 OR (p_InvoiceDetailID > 0 AND invd.InvoiceDetailID != p_InvoiceDetailID)) AND AccountID = p_AccountID AND 
		(
		 (p_StartDate BETWEEN invd.StartDate AND invd.EndDate) OR
		 (p_EndDate BETWEEN invd.StartDate AND invd.EndDate) OR
		 (invd.StartDate BETWEEN p_StartDate AND p_EndDate) 
		) AND inv.InvoiceStatus != 'cancel'; 
		
		IF v_InvoiceCount_ = 0 THEN
		
			SELECT IFNULL(CAST(SUM(cost) AS DECIMAL(18,8)), 0) AS TotalCharges
			FROM tmp_tblUsageDetails_ ud; 
		ELSE
			SELECT 0 AS TotalCharges; 
		END IF; 
	
	ELSE
		SELECT IFNULL(CAST(SUM(cost) AS DECIMAL(18,8)), 0) AS TotalCharges
		FROM tmp_tblUsageDetails_ ud; 
	END IF; 
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getAccountNameByGatway` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getAccountNameByGatway`(IN `p_company_id` INT, IN `p_gatewayid` INT
)
BEGIN

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    
     SELECT DISTINCT
                    a.AccountID,
                    a.AccountName                    
                FROM wavetelwholesaleRM.tblAccount a
                INNER JOIN tblGatewayAccount ga ON a.AccountiD = ga.AccountiD AND a.Status = 1
                WHERE GatewayAccountID IS NOT NULL                
                AND a.CompanyId = p_company_id
                AND ga.CompanyGatewayID = p_gatewayid 
					 order by a.AccountName ASC;
					 
   SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	             
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getAccountOutstandingAmount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getAccountOutstandingAmount`(IN `p_company_id` INT, IN `p_AccountID` int 
)
BEGIN

	  Declare v_TotalDue_ decimal(18,6);
    Declare v_TotalPaid_ decimal(18,6);
    
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    
	  
      

   
    

    
    Select   ifnull(sum(GrandTotal),0) INTO v_TotalDue_
    from tblInvoice
    where AccountID = p_AccountID
    and CompanyID = p_company_id
    AND InvoiceStatus != 'cancel';   

    

    Select  ifnull(sum(Amount),0) INTO v_TotalPaid_ 
    from tblPayment
    where AccountID = p_AccountID
    and CompanyID = p_company_id
    and Status = 'Approved'
    and Recall = 0;

    

    Select ifnull((v_TotalDue_ - v_TotalPaid_ ),0) as Outstanding;
                
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getAccountPreviousBalance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getAccountPreviousBalance`(IN `p_CompanyID` INT, IN `p_AccountID` INT, IN `p_InvoiceID` INT)
BEGIN

	DECLARE v_PreviousBalance_ DECIMAL(18,6);
	DECLARE v_totalpaymentin_ DECIMAL(18,6);
	DECLARE v_totalpaymentout_ DECIMAL(18,6);
	DECLARE v_totalInvoiceOut_ DECIMAL(18,6);
	DECLARE v_totalInvoiceIn_ DECIMAL(18,6);
	DECLARE v_InvoiceDate_ DATE DEFAULT DATE(NOW());
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	
	IF p_InvoiceID > 0
	THEN 
		SET  v_InvoiceDate_ = (SELECT IssueDate FROM tblInvoice WHERE InvoiceID = p_InvoiceID);
	END IF;
	
	SELECT
		COALESCE(SUM(IF(PaymentType = 'Payment In',Amount,0)),0) as PaymentIn,
		COALESCE(SUM(IF(PaymentType = 'Payment Out',Amount,0)),0) as PaymentOut
	INTO 
		v_totalpaymentin_,
		v_totalpaymentout_
	FROM tblPayment
	WHERE tblPayment.AccountID = p_AccountID
	AND tblPayment.Status = 'Approved'
	AND tblPayment.Recall = 0
	AND tblPayment.PaymentDate < v_InvoiceDate_;

	SELECT
		COALESCE(SUM(IF(InvoiceType = 1,GrandTotal,0)),0) as InvoiceInTotal,
		COALESCE(SUM(IF(InvoiceType = 2,GrandTotal,0)),0) as InvoiceOutTotal
	INTO
		v_totalInvoiceOut_,
		v_totalInvoiceIn_
	FROM tblInvoice inv
	WHERE AccountID = p_AccountID 
	AND CompanyID = p_CompanyID
	AND ( (InvoiceType = 2) OR ( InvoiceType = 1 AND InvoiceStatus NOT IN ( 'cancel' , 'draft' ) )  )
	AND IssueDate < v_InvoiceDate_;

	SET v_PreviousBalance_ = (v_totalInvoiceOut_ - v_totalpaymentin_) - (v_totalInvoiceIn_ - v_totalpaymentout_);

	SELECT IFNULL(v_PreviousBalance_,0) as PreviousBalance;


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getActiveGatewayAccount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getActiveGatewayAccount`(
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
		FROM wavetelwholesaleRM.tblCompanyGateway
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
	SELECT DISTINCT CustomerAuthRule FROM wavetelwholesaleRM.tblAccountAuthenticate aa WHERE CustomerAuthRule IS NOT NULL
	UNION 
	SELECT DISTINCT VendorAuthRule FROM wavetelwholesaleRM.tblAccountAuthenticate aa WHERE VendorAuthRule IS NOT NULL;
	
	IF (SELECT COUNT(*) FROM tmp_AuthenticateRules_ WHERE AuthRule ='CLI' ) = 0  AND (SELECT COUNT(*) FROM wavetelwholesaleRM.tblCLIRateTable WHERE CompanyID = p_company_id) > 0 
	THEN

		INSERT INTO tmp_AuthenticateRules_  (AuthRule)
		SELECT 'CLI';

	END IF;

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
			FROM wavetelwholesaleRM.tblAccount  a
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
			FROM wavetelwholesaleRM.tblAccount  a
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
			FROM wavetelwholesaleRM.tblAccount  a
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
			FROM wavetelwholesaleRM.tblAccount  a
			INNER JOIN wavetelwholesaleRM.tblAccountAuthenticate aa 
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
			

			INSERT INTO tmp_ActiveAccount
			SELECT DISTINCT
				GatewayAccountID,
				a.AccountID,
				a.AccountName
			FROM wavetelwholesaleRM.tblAccount  a
			INNER JOIN wavetelwholesaleRM.tblCLIRateTable aa 
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
			FROM wavetelwholesaleRM.tblAccount  a
			LEFT JOIN wavetelwholesaleRM.tblAccountAuthenticate aa 
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getBillingSubscription` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getBillingSubscription`(
	IN `p_CompanyID` INT,
	IN `p_Advance` INT,
	IN `p_Name` VARCHAR(50),
	IN `p_CurrencyID` INT,
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
	   
   	IF p_Export = 0
	THEN
		SELECT   
			tblBillingSubscription.Name,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.MonthlyFee) AS MonthlyFeeWithSymbol,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.WeeklyFee) AS WeeklyFeeWithSymbol,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.DailyFee) AS DailyFeeWithSymbol,
			tblBillingSubscription.Advance,
			tblBillingSubscription.SubscriptionID,
			tblBillingSubscription.ActivationFee,
			tblBillingSubscription.CurrencyID,
			tblBillingSubscription.InvoiceLineDescription,
			tblBillingSubscription.Description,			
			tblBillingSubscription.MonthlyFee,
			tblBillingSubscription.WeeklyFee,
			tblBillingSubscription.DailyFee
    	FROM tblBillingSubscription
    	LEFT JOIN wavetelwholesaleRM.tblCurrency on tblBillingSubscription.CurrencyID =tblCurrency.CurrencyId 
    	WHERE tblBillingSubscription.CompanyID = p_CompanyID
	        AND(p_CurrencyID =0  OR tblBillingSubscription.CurrencyID   = p_CurrencyID)
			AND(p_Advance is null OR tblBillingSubscription.Advance = p_Advance)
			AND(p_Name ='' OR tblBillingSubscription.Name like Concat('%',p_Name,'%'))
		ORDER BY
			CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameDESC') THEN Name
            END DESC,
            CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameASC') THEN Name
           	END ASC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MonthlyFeeDESC') THEN MonthlyFee
           	END DESC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'MonthlyFeeASC') THEN MonthlyFee
           	END ASC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'WeeklyFeeDESC') THEN WeeklyFee
           	END DESC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'WeeklyFeeASC') THEN WeeklyFee
           	END ASC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DailyFeeDESC') THEN DailyFee
           	END DESC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DailyFeeASC') THEN DailyFee
           	END ASC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AdvanceDESC') THEN Advance
           	END DESC,
           	CASE
           		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AdvanceASC') THEN Advance
           	END ASC
         LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
        	COUNT(tblBillingSubscription.SubscriptionID) AS totalcount
     	FROM tblBillingSubscription
     	WHERE tblBillingSubscription.CompanyID = p_CompanyID
			AND(p_CurrencyID =0  OR tblBillingSubscription.CurrencyID   = p_CurrencyID)
			AND(p_Advance is null OR tblBillingSubscription.Advance = p_Advance)
			AND(p_Name ='' OR tblBillingSubscription.Name like Concat('%',p_Name,'%'));
 	END IF;
      
      
    IF p_Export = 1
	THEN
		
		SELECT   
			tblBillingSubscription.Name,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.MonthlyFee) AS MonthlyFee,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.WeeklyFee) AS WeeklyFee,
			CONCAT(IFNULL(tblCurrency.Symbol,''),tblBillingSubscription.DailyFee) AS DailyFee,
			tblBillingSubscription.ActivationFee,
			tblBillingSubscription.InvoiceLineDescription,
			tblBillingSubscription.Description,
			tblBillingSubscription.Advance
        FROM tblBillingSubscription
        LEFT JOIN wavetelwholesaleRM.tblCurrency on tblBillingSubscription.CurrencyID =tblCurrency.CurrencyId 
        WHERE tblBillingSubscription.CompanyID = p_CompanyID
	    	AND(p_CurrencyID =0  OR tblBillingSubscription.CurrencyID   = p_CurrencyID)
			AND(p_Advance is null OR tblBillingSubscription.Advance = p_Advance)
			AND(p_Name ='' OR tblBillingSubscription.Name like Concat('%',p_Name,'%'));
				
	END IF;       
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetCDR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetCDR`(
	IN `p_company_id` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_start_date` DATETIME,
	IN `p_end_date` DATETIME,
	IN `p_AccountID` INT ,
	IN `p_CDRType` CHAR(1),
	IN `p_CLI` VARCHAR(50),
	IN `p_CLD` VARCHAR(50),
	IN `p_zerovaluecost` INT,
	IN `p_CurrencyID` INT,
	IN `p_area_prefix` VARCHAR(50),
	IN `p_trunk` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT

)
BEGIN 

    DECLARE v_OffSet_ INT;
    DECLARE v_BillingTime_ INT;
    DECLARE v_Round_ INT;
    DECLARE v_CurrencyCode_ VARCHAR(50);

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
    SELECT fnGetRoundingPoint(p_company_id) INTO v_Round_;

    SELECT cr.Symbol INTO v_CurrencyCode_ from wavetelwholesaleRM.tblCurrency cr where cr.CurrencyId =p_CurrencyID;

    SELECT fnGetBillingTime(p_CompanyGatewayID,p_AccountID) INTO v_BillingTime_;

    Call fnUsageDetail(p_company_id,p_AccountID,p_CompanyGatewayID,p_start_date,p_end_date,0,1,v_BillingTime_,p_CDRType,p_CLI,p_CLD,p_zerovaluecost);

    IF p_isExport = 0
    THEN 
        SELECT
            uh.UsageDetailID,
            uh.AccountName,
            uh.connect_time,
            uh.disconnect_time,
            uh.billed_duration,
            CONCAT(IFNULL(v_CurrencyCode_,''),TRIM(uh.cost)+0) AS cost,
            CONCAT(IFNULL(v_CurrencyCode_,''),TRIM(ROUND((uh.cost/uh.billed_duration)*60.0,6))+0) AS rate,
            uh.cli,
            uh.cld,
            uh.area_prefix,
            uh.trunk,
            uh.AccountID,
            p_CompanyGatewayID as CompanyGatewayID,
            p_start_date as StartDate,
            p_end_date as EndDate,
            uh.is_inbound as CDRType  from
            tmp_tblUsageDetails_ uh
        INNER JOIN wavetelwholesaleRM.tblAccount a
            ON uh.AccountID = a.AccountID
        WHERE  (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
        AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
        AND (p_trunk = '' OR trunk = p_trunk )
        LIMIT p_RowspPage OFFSET v_OffSet_;

        SELECT
            COUNT(*) AS totalcount,
            fnFormateDuration(sum(billed_duration)) as total_duration,
            sum(cost) as total_cost,
            v_CurrencyCode_ as CurrencyCode
        FROM  tmp_tblUsageDetails_ uh
        INNER JOIN wavetelwholesaleRM.tblAccount a
            ON uh.AccountID = a.AccountID
        WHERE  (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
        AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
        AND (p_trunk = '' OR trunk = p_trunk );

    END IF;

    IF p_isExport = 1
    THEN

        SELECT
			uh.AccountName as 'Account Name',
			uh.connect_time as 'Connect Time',
			uh.disconnect_time as 'Disconnect Time',
			uh.billed_duration as 'Billed Duration (sec)' ,
			CONCAT(IFNULL(v_CurrencyCode_,''),TRIM(uh.cost)+0) AS 'Cost',
			CONCAT(IFNULL(v_CurrencyCode_,''),TRIM(ROUND((uh.cost/uh.billed_duration)*60.0,6))+0) AS 'Avg. Rate/Min',
			uh.cli as 'CLI',
			uh.cld as 'CLD',
			uh.area_prefix as 'Prefix',
			uh.trunk as 'Trunk',
			uh.is_inbound
        FROM tmp_tblUsageDetails_ uh
        INNER JOIN wavetelwholesaleRM.tblAccount a
            ON uh.AccountID = a.AccountID
        WHERE  (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
        AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
        AND (p_trunk = '' OR trunk = p_trunk );
    END IF;

    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetCDR_Round` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetCDR_Round`(
	IN `p_company_id` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_start_date` DATETIME,
	IN `p_end_date` DATETIME,
	IN `p_AccountID` INT ,
	IN `p_CDRType` CHAR(1),
	IN `p_CLI` VARCHAR(50),
	IN `p_CLD` VARCHAR(50),
	IN `p_zerovaluecost` INT,
	IN `p_CurrencyID` INT,
	IN `p_area_prefix` VARCHAR(50),
	IN `p_trunk` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT


)
BEGIN 

	DECLARE v_OffSet_ INT;
	DECLARE v_BillingTime_ INT;
	DECLARE v_Round_ INT;
	DECLARE v_CurrencyCode_ VARCHAR(50);

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	SELECT fnGetRoundingPoint(p_company_id) INTO v_Round_;

	SELECT cr.Symbol INTO v_CurrencyCode_ from NeonRM.tblCurrency cr where cr.CurrencyId =p_CurrencyID;

	SELECT fnGetBillingTime(p_CompanyGatewayID,p_AccountID) INTO v_BillingTime_;

	Call fnUsageDetail(p_company_id,p_AccountID,p_CompanyGatewayID,p_start_date,p_end_date,0,1,v_BillingTime_,p_CDRType,p_CLI,p_CLD,p_zerovaluecost);

	SET @stm = CONCAT('ALTER TABLE tmp_tblUsageDetails_ ADD INDEX temp_index (`',p_lSortCol,'`);');
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;


	IF p_isExport = 0
	THEN 
		SELECT
			uh.UsageDetailID,
			uh.AccountName,
			uh.connect_time,
			uh.disconnect_time,
			uh.billed_duration,
			CONCAT(IFNULL(v_CurrencyCode_,''),fnRounding(uh.cost)) AS cost,
			uh.cli,
			uh.cld,
			uh.area_prefix,
			uh.trunk,
			uh.AccountID,
			p_CompanyGatewayID as CompanyGatewayID,
			p_start_date as StartDate,
			p_end_date as EndDate,
			uh.is_inbound as CDRType  from
			tmp_tblUsageDetails_ uh
		INNER JOIN NeonRM.tblAccount a
			ON uh.AccountID = a.AccountID
		WHERE  (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
		AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
		AND (p_trunk = '' OR trunk = p_trunk )
		LIMIT p_RowspPage OFFSET v_OffSet_;

		SELECT
			COUNT(*) AS totalcount,
			fnFormateDuration(sum(billed_duration)) as total_duration,
			sum(fnRounding(uh.cost)) as total_cost,
			v_CurrencyCode_ as CurrencyCode
		FROM  tmp_tblUsageDetails_ uh
		INNER JOIN NeonRM.tblAccount a
			ON uh.AccountID = a.AccountID
		WHERE  (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
		AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
		AND (p_trunk = '' OR trunk = p_trunk );

	END IF;

	IF p_isExport = 1
	THEN

		SELECT
			uh.AccountName,
			uh.connect_time,
			uh.disconnect_time,
			uh.billed_duration as duration,
			CONCAT(IFNULL(v_CurrencyCode_,''),fnRounding(uh.cost)) AS cost,
			uh.cli,
			uh.cld,
			uh.area_prefix,
			uh.trunk,
			uh.is_inbound
		FROM tmp_tblUsageDetails_ uh
		INNER JOIN NeonRM.tblAccount a
			ON uh.AccountID = a.AccountID
		WHERE  (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
		AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
		AND (p_trunk = '' OR trunk = p_trunk );
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getDashboardinvoiceExpense` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getDashboardinvoiceExpense`(
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
		AND InvoiceType = 1 
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
		INNER JOIN wavetelwholesaleRM.tblAccount ac 
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
					,1 
					,1			
					,'Oct' as  MonthName
					,ROUND(COALESCE(SUM(p.Amount),0),v_Round_) as TotalAmount
					,ROUND(COALESCE(SUM(p.OutAmount),0),v_Round_) as OutAmount
					,CurrencyID
			FROM tmp_tblPayment_ p 
			GROUP BY 
				YEAR(p.PaymentDate)
			 	
				,CurrencyID		
			ORDER BY 
				Year;
			
			
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
		
		
			AND tr.CurrencyID = td.CurrencyID
		GROUP BY 
			td.Year,
			td.CurrencyID
		ORDER BY 
			td.Year;
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getDashboardinvoiceExpenseDrilDown` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getDashboardinvoiceExpenseDrilDown`(IN `p_CompanyID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` VARCHAR(50), IN `p_EndDate` VARCHAR(50), IN `p_Type` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(50), IN `p_CustomerID` INT, IN `p_Export` INT)
BEGIN
	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
	DECLARE v_CurrencyCode_ VARCHAR(50);
	DECLARE v_TotalCount int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	SELECT cr.Symbol INTO v_CurrencyCode_ from wavetelwholesaleRM.tblCurrency cr where cr.CurrencyId =p_CurrencyID;
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	IF p_Type = 1  
	THEN
		DROP TEMPORARY TABLE IF EXISTS tmp_Payment_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Payment_(
			AccountName varchar(100),
			Amount decimal(18,6),
			PaymentDate datetime,
			CreatedBy varchar(50),
			InvoiceNo varchar(50),
			Notes varchar(500),
			AmountWithSymbol varchar(30)
		);
		
		INSERT INTO tmp_Payment_
		SELECT 
	      ac.AccountName,
	      ROUND(p.Amount,v_Round_) AS Amount,
	      CASE WHEN inv.InvoiceID IS NOT NULL
			THEN
				inv.IssueDate
			ELSE
				p.PaymentDate
			END as PaymentDate,
	      p.CreatedBy,
	      p.InvoiceNo,
	      p.Notes,
	      CONCAT(IFNULL(v_CurrencyCode_,''),ROUND(p.Amount,v_Round_)) as AmountWithSymbol
		FROM tblPayment p 
		INNER JOIN wavetelwholesaleRM.tblAccount ac 
			ON ac.AccountID = p.AccountID
		LEFT JOIN tblInvoice inv on p.InvoiceID = inv.InvoiceID 
			AND p.Status = 'Approved' 
			AND p.AccountID = inv.AccountID 
			AND p.Recall=0
			AND InvoiceType = 1 
		WHERE 
			p.CompanyID = p_CompanyID
			AND ac.CurrencyId = p_CurrencyID
			AND (p_CustomerID=0 OR ac.AccountID = p_CustomerID)
			AND p.Status = 'Approved'
			AND p.Recall=0
			AND p.PaymentType = 'Payment In';
	       
		IF  p_Export = 0
		THEN
			SELECT 
		      AccountName,
		      InvoiceNo,
		      AmountWithSymbol,
		      PaymentDate,
		      CreatedBy,
		      Notes
			FROM tmp_Payment_
			where (PaymentDate BETWEEN p_StartDate AND p_EndDate)
			ORDER BY
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN AccountName
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN AccountName
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNoDESC') THEN InvoiceNo
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNoASC') THEN InvoiceNo
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AmountDESC') THEN Amount
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AmountASC') THEN Amount
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PaymentDateDESC') THEN PaymentDate
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PaymentDateASC') THEN PaymentDate
					END ASC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByDESC') THEN CreatedBy
					END DESC,
					CASE
						WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByASC') THEN CreatedBy
					END ASC
			LIMIT p_RowspPage OFFSET v_OffSet_;
			
			
			SELECT COUNT(AccountName) AS totalcount,ROUND(COALESCE(SUM(Amount),0),v_Round_) as totalsum
			FROM tmp_Payment_
			where (PaymentDate BETWEEN p_StartDate AND p_EndDate);
		END IF;
		
		IF p_Export=1
		THEN
			SELECT 
            AccountName,
            Amount,
            PaymentDate,
            CreatedBy,
            InvoiceNo,
            Notes
				FROM tmp_Payment_
				where (PaymentDate BETWEEN p_StartDate AND p_EndDate); 
		END IF;
	END IF;
	
	IF p_Type=2 || p_Type=3 
	THEN							
	
	DROP TEMPORARY TABLE IF EXISTS tmp_Invoices_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Invoices_(
		InvoiceType tinyint(1),
		AccountName varchar(100),
		InvoiceNumber varchar(100),
		IssueDate datetime,
		InvoicePeriod varchar(100),
		CurrencySymbol varchar(5),
		GrandTotal decimal(18,6),
		TotalPayment decimal(18,6),
		PendingAmount decimal(18,6),
		InvoiceStatus varchar(50),
		InvoiceID int,
		AccountID int,
		ItemInvoice tinyint(1),
		BillingEmail varchar(255),
		AccountNumber varchar(100),
		PaymentDueInDays int,
		PaymentDate datetime,
		SubTotal decimal(18,6)
	);
	
	INSERT INTO tmp_Invoices_
		SELECT inv.InvoiceType ,
			ac.AccountName,
			inv.FullInvoiceNumber as InvoiceNumber,
			inv.IssueDate,
			IF(invd.StartDate IS NULL ,'',CONCAT('From ',date(invd.StartDate) ,'<br> To ',date(invd.EndDate))) as InvoicePeriod,
			IFNULL(cr.Symbol,'') as CurrencySymbol,
			inv.GrandTotal as GrandTotal,		
			(select IFNULL(sum(p.Amount),0) from tblPayment p where p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) as TotalPayment,
			(inv.GrandTotal -  (select IFNULL(sum(p.Amount),0) from tblPayment p where p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) ) as `PendingAmount`,
			inv.InvoiceStatus,
			inv.InvoiceID,
			inv.AccountID,
			inv.ItemInvoice,
			IFNULL(ac.BillingEmail,'') as BillingEmail,
			ac.Number,
			(SELECT IFNULL(b.PaymentDueInDays,0) FROM wavetelwholesaleRM.tblAccountBilling ab INNER JOIN wavetelwholesaleRM.tblBillingClass b ON b.BillingClassID =ab.BillingClassID WHERE ab.AccountID = ac.AccountID) as PaymentDueInDays,
			(select PaymentDate from tblPayment p where p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.Recall =0 AND p.AccountID = inv.AccountID order by PaymentID desc limit 1) AS PaymentDate,
			inv.SubTotal
      FROM tblInvoice inv
      INNER JOIN wavetelwholesaleRM.tblAccount ac ON inv.AccountID = ac.AccountID
      AND (p_CustomerID=0 OR ac.AccountID = p_CustomerID)
      LEFT JOIN tblInvoiceDetail invd on invd.InvoiceID = inv.InvoiceID AND invd.ProductType = 2
		LEFT JOIN wavetelwholesaleRM.tblCurrency cr ON inv.CurrencyID   = cr.CurrencyId 
		WHERE 
		inv.CompanyID = p_CompanyID
		AND cr.CurrencyID = p_CurrencyID
		AND (IssueDate BETWEEN p_StartDate AND p_EndDate)
		AND InvoiceType = 1
		AND ((p_Type=2 AND inv.InvoiceStatus NOT IN ( 'cancel' , 'draft' )) OR (p_Type=3 AND inv.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'paid')))
		AND (GrandTotal<>0);
	IF p_Export = 0
	THEN
      SELECT 
			AccountName,
			InvoiceNumber,
			IssueDate,
			InvoicePeriod,
			CONCAT(CurrencySymbol, ROUND(GrandTotal,v_Round_)) as GrandTotal2,
			CONCAT(CurrencySymbol,ROUND(TotalPayment,v_Round_),'/',ROUND(PendingAmount,v_Round_)) as `PendingAmount`,
			InvoiceStatus,
			InvoiceID,
			AccountID,
			PendingAmount as OutstandingAmount, 
			ItemInvoice,
			BillingEmail,
			GrandTotal
        FROM tmp_Invoices_        
        ORDER BY
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN AccountName
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN AccountName
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceTypeDESC') THEN InvoiceType
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceTypeASC') THEN InvoiceType
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceStatusDESC') THEN InvoiceStatus
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceStatusASC') THEN InvoiceStatus
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNumberASC') THEN InvoiceNumber
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNumberDESC') THEN InvoiceNumber
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IssueDateASC') THEN IssueDate
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IssueDateDESC') THEN IssueDate
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoicePeriodASC') THEN InvoicePeriod
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoicePeriodDESC') THEN InvoicePeriod
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalDESC') THEN GrandTotal
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalASC') THEN GrandTotal
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceIDDESC') THEN InvoiceID
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceIDASC') THEN InvoiceID
            END ASC
			LIMIT p_RowspPage OFFSET v_OffSet_;
        
      	SELECT COUNT(*) AS totalcount,
					ROUND(COALESCE(SUM(GrandTotal),0),v_Round_) as totalsum, 
					ROUND(COALESCE(SUM(TotalPayment),0),v_Round_) totalpaymentsum,
					ROUND(COALESCE(SUM(PendingAmount),0),v_Round_) totalpendingsum,
					v_CurrencyCode_ as currencySymbol
			FROM tmp_Invoices_;
      	
		END IF;
		IF p_Export=1
		THEN
			SELECT 
				AccountName ,
				InvoiceNumber,
				IssueDate,
				REPLACE(InvoicePeriod, '<br>', '') as InvoicePeriod,
				CONCAT(CurrencySymbol, ROUND(GrandTotal,v_Round_)) as GrandTotal,
				CONCAT(CurrencySymbol,ROUND(TotalPayment,v_Round_),'/',ROUND(PendingAmount,v_Round_)) as `Paid/OS`,
				InvoiceStatus,
				InvoiceType,
				ItemInvoice
        FROM tmp_Invoices_;
		END IF;
	END IF;
		
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getDashboardinvoiceExpenseTotalOutstanding` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getDashboardinvoiceExpenseTotalOutstanding`(
	IN `p_CompanyID` INT,
	IN `p_CurrencyID` INT,
	IN `p_AccountID` INT,
	IN `p_StartDate` VARCHAR(50),
	IN `p_EndDate` VARCHAR(50)
)
BEGIN

	DECLARE v_Round_ INT;
	
	DECLARE v_TotalInvoiceIn_ DECIMAL(18,6);
	DECLARE v_TotalInvoiceOut_ DECIMAL(18,6);
	DECLARE v_TotalPaymentIn_ DECIMAL(18,6);
	DECLARE v_TotalPaymentOut_ DECIMAL(18,6);
	DECLARE v_TotalOutstanding_ DECIMAL(18,6);	
	DECLARE v_Outstanding_ DECIMAL(18,6);

	DECLARE v_InvoiceSentTotal_ DECIMAL(18,6);
	DECLARE v_InvoiceRecvTotal_ DECIMAL(18,6);
	DECLARE v_PaymentSentTotal_ DECIMAL(18,6);
	DECLARE v_PaymentRecvTotal_ DECIMAL(18,6);

	DECLARE v_TotalUnpaidInvoices_ DECIMAL(18,6);
	DECLARE v_TotalOverdueInvoices_ DECIMAL(18,6);
	DECLARE v_TotalPaidInvoices_ DECIMAL(18,6);
	DECLARE v_TotalDispute_ DECIMAL(18,6);
	DECLARE v_TotalEstimate_ DECIMAL(18,6);

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	DROP TEMPORARY TABLE IF EXISTS tmp_Invoices_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Invoices_(
		InvoiceType TINYINT(1),
		IssueDate DATETIME,
		GrandTotal DECIMAL(18,6),
		InvoiceStatus VARCHAR(50),
		PaymentDueInDays INT,
		PendingAmount DECIMAL(18,6),
		AccountID INT
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_Payment_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Payment_(
		PaymentAmount DECIMAL(18,6),
		PaymentDate DATETIME,
		PaymentType VARCHAR(50)
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_Dispute_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Dispute_(
		DisputeAmount DECIMAL(18,6)
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_Estimate_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Estimate_(
		EstimateTotal DECIMAL(18,6)
	);

	
	INSERT INTO tmp_Dispute_
	SELECT 
		ds.DisputeAmount 
	FROM tblDispute ds
	INNER JOIN wavetelwholesaleRM.tblAccount ac 
		ON ac.AccountID = ds.AccountID
	WHERE ds.CompanyID = p_CompanyID
	AND ac.CurrencyId = p_CurrencyID
	AND (p_AccountID = 0 or ac.AccountID = p_AccountID)
	AND ds.Status = 0
	AND ((p_EndDate = '0' AND fnGetMonthDifference(ds.created_at,NOW()) <= p_StartDate) OR
			(p_EndDate<>'0' AND ds.created_at between p_StartDate AND p_EndDate));

	
	INSERT INTO tmp_Estimate_
	SELECT 
		es.GrandTotal 
	FROM tblEstimate es
	INNER JOIN wavetelwholesaleRM.tblAccount ac 
		ON ac.AccountID = es.AccountID
	WHERE es.CompanyID = p_CompanyID
	AND (p_AccountID = 0 or ac.AccountID = p_AccountID)
	AND ac.CurrencyId = p_CurrencyID
	AND es.EstimateStatus NOT IN ('draft','accepted','rejected')
	AND ((p_EndDate = '0' AND fnGetMonthDifference(es.IssueDate,NOW()) <= p_StartDate) OR
			(p_EndDate<>'0' AND es.IssueDate between p_StartDate AND p_EndDate));
	
	
	INSERT INTO tmp_Invoices_
	SELECT 
		inv.InvoiceType,
		inv.IssueDate,
		inv.GrandTotal,
		inv.InvoiceStatus,
		(SELECT IFNULL(b.PaymentDueInDays,0) FROM wavetelwholesaleRM.tblAccountBilling ab INNER JOIN wavetelwholesaleRM.tblBillingClass b ON b.BillingClassID =ab.BillingClassID WHERE ab.AccountID = ac.AccountID) as PaymentDueInDays,
		(inv.GrandTotal -  (select IFNULL(sum(p.Amount),0) from tblPayment p where p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) ) as `PendingAmount`,
		ac.AccountID
	FROM tblInvoice inv
	INNER JOIN wavetelwholesaleRM.tblAccount ac 
		ON ac.AccountID = inv.AccountID 
		AND inv.CompanyID = p_CompanyID
		AND inv.CurrencyID = p_CurrencyID
		AND (p_AccountID = 0 or ac.AccountID = p_AccountID)
		AND ( (InvoiceType = 2) OR ( InvoiceType = 1 AND InvoiceStatus NOT IN ( 'cancel' , 'draft') )  )
		AND ((p_EndDate = '0' AND fnGetMonthDifference(IssueDate,NOW()) <= p_StartDate) OR
			(p_EndDate<>'0' AND IssueDate BETWEEN p_StartDate AND p_EndDate));

	
	INSERT INTO tmp_Payment_	
	SELECT 
		p.Amount,
		p.PaymentDate,
		p.PaymentType
		FROM tblPayment p 
	INNER JOIN wavetelwholesaleRM.tblAccount ac 
		ON ac.AccountID = p.AccountID
	WHERE 
		p.CompanyID = p_CompanyID
		AND ac.CurrencyId = p_CurrencyID	
		AND p.Status = 'Approved'
		AND p.Recall=0
		AND (p_AccountID = 0 or ac.AccountID = p_AccountID)
		AND (
			(p_EndDate = '0' AND fnGetMonthDifference(PaymentDate,NOW()) <= p_StartDate) OR
			(p_EndDate<>'0' AND PaymentDate between p_StartDate AND p_EndDate)
			);

	
	
	
	
	SELECT 
		SUM(IF(InvoiceType=1,GrandTotal,0)),
		SUM(IF(InvoiceType=2,GrandTotal,0)) INTO v_TotalInvoiceOut_,v_TotalInvoiceIn_
	FROM tmp_Invoices_;
	
	SELECT 
		SUM(IF(PaymentType='Payment In',PaymentAmount,0)),
		SUM(IF(PaymentType='Payment Out',PaymentAmount,0)) INTO v_TotalPaymentIn_,v_TotalPaymentOut_
	FROM tmp_Payment_;

	SELECT (IFNULL(v_TotalInvoiceOut_,0) - IFNULL(v_TotalPaymentIn_,0)) - (IFNULL(v_TotalInvoiceIn_,0) - IFNULL(v_TotalPaymentOut_,0)) INTO v_Outstanding_;
	
	
	SELECT IFNULL(SUM(GrandTotal),0) INTO v_InvoiceSentTotal_
	FROM tmp_Invoices_ 
	WHERE InvoiceType = 1;

	
	SELECT IFNULL(SUM(GrandTotal),0) INTO v_InvoiceRecvTotal_
	FROM tmp_Invoices_ 
	WHERE  InvoiceType = 2;
	
	
	SELECT IFNULL(SUM(PaymentAmount),0) INTO v_PaymentRecvTotal_
	FROM tmp_Payment_ p
	WHERE p.PaymentType = 'Payment In';
	
	
	SELECT IFNULL(SUM(PaymentAmount),0) INTO v_PaymentSentTotal_
	FROM tmp_Payment_ p
	WHERE p.PaymentType = 'Payment Out';
	
		
	SELECT IFNULL(SUM(GrandTotal),0) INTO v_TotalUnpaidInvoices_
	FROM tmp_Invoices_ 
	WHERE InvoiceType = 1
	AND InvoiceStatus <> 'paid' 
	AND PendingAmount > 0;
		
		
	SELECT IFNULL(SUM(GrandTotal),0) INTO v_TotalOverdueInvoices_
	FROM tmp_Invoices_ 
	WHERE ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
							AND(InvoiceStatus NOT IN('awaiting'))
							AND(PendingAmount>0)
						);
		
	SELECT IFNULL(SUM(GrandTotal),0) INTO v_TotalPaidInvoices_
	FROM tmp_Invoices_ 
	WHERE (InvoiceStatus IN('Paid') AND (PendingAmount=0));
	
		
	SELECT IFNULL(SUM(DisputeAmount),0) INTO v_TotalDispute_
	FROM tmp_Dispute_;
	
	
	SELECT IFNULL(SUM(EstimateTotal),0) INTO v_TotalEstimate_
	FROM tmp_Estimate_;
	
	SELECT 
			
			ROUND(v_Outstanding_,v_Round_) AS Outstanding,
			ROUND(v_PaymentRecvTotal_,v_Round_) AS TotalPaymentsIn,
			ROUND(v_PaymentSentTotal_,v_Round_) AS TotalPaymentsOut,
			ROUND(v_InvoiceRecvTotal_,v_Round_) AS TotalInvoiceIn,
			ROUND(v_InvoiceSentTotal_,v_Round_) AS TotalInvoiceOut,
			ROUND(v_TotalUnpaidInvoices_,v_Round_) as TotalDueAmount,
			ROUND(v_TotalOverdueInvoices_,v_Round_) as TotalOverdueAmount,
			ROUND(v_TotalPaidInvoices_,v_Round_) as TotalPaidAmount,
			ROUND(v_TotalDispute_,v_Round_) as TotalDispute,
			ROUND(v_TotalEstimate_,v_Round_) as TotalEstimate,
			v_Round_ as `Round`;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getDashBoardPinCodes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getDashBoardPinCodes`(IN `p_CompanyID` INT, IN `p_StartDate` DATE, IN `p_EndDate` DATE, IN `p_AccountID` INT, IN `p_Type` INT, IN `p_Limit` INT, IN `p_PinExt` VARCHAR(50), IN `p_CurrencyID` INT)
    COMMENT 'Top 10 pincodes p_Type = 1 = cost,p_Type =2 =Duration'
BEGIN
	DECLARE v_Round_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	CALL fnUsageDetail(p_CompanyID,p_AccountID,0,p_StartDate,p_EndDate,0,1,1,'','','',0);
	
	IF p_Type =1 AND  p_PinExt = 'pincode' 
	THEN 
	
		SELECT ROUND(SUM(ud.cost),v_Round_) as PincodeValue,IFNULL(ud.pincode,'n/a') as Pincode  FROM tmp_tblUsageDetails_ ud 
		INNER JOIN wavetelwholesaleRM.tblAccount a on ud.AccountID = a.AccountID 
		WHERE  ud.cost>0 AND ud.pincode IS NOT NULL AND ud.pincode != ''
			AND a.CurrencyId = p_CurrencyID
		GROUP BY ud.pincode
		ORDER BY PincodeValue DESC
		LIMIT p_Limit;
	
	END IF;
	
	IF p_Type =2 AND  p_PinExt = 'pincode' 
	THEN 
	
		SELECT SUM(ud.billed_duration) as PincodeValue,IFNULL(ud.pincode,'n/a') as Pincode FROM tmp_tblUsageDetails_ ud
		INNER JOIN wavetelwholesaleRM.tblAccount a on ud.AccountID = a.AccountID  
		WHERE  ud.cost>0 AND ud.pincode IS NOT NULL AND ud.pincode != ''
			AND a.CurrencyId = p_CurrencyID
		GROUP BY ud.pincode
		ORDER BY PincodeValue DESC
		LIMIT p_Limit;
	
	END IF;
	
	IF p_Type =1 AND  p_PinExt = 'extension' 
	THEN 
	
		SELECT ROUND(SUM(ud.cost),v_Round_) as PincodeValue,IFNULL(ud.extension,'n/a') as Pincode  FROM tmp_tblUsageDetails_ ud 
		INNER JOIN wavetelwholesaleRM.tblAccount a on ud.AccountID = a.AccountID 
		WHERE  ud.cost>0 AND ud.extension IS NOT NULL AND ud.extension != ''
			AND a.CurrencyId = p_CurrencyID 
		GROUP BY ud.extension
		ORDER BY PincodeValue DESC
		LIMIT p_Limit;
	
	END IF;
	
	IF p_Type =2 AND  p_PinExt = 'extension' 
	THEN 
	
		SELECT SUM(ud.billed_duration) as PincodeValue,IFNULL(ud.extension,'n/a') as Pincode FROM tmp_tblUsageDetails_ ud
		INNER JOIN wavetelwholesaleRM.tblAccount a on ud.AccountID = a.AccountID 
		WHERE  ud.cost>0 AND ud.extension IS NOT NULL AND ud.extension != ''
			AND a.CurrencyId = p_CurrencyID
		GROUP BY ud.extension
		ORDER BY PincodeValue DESC
		LIMIT p_Limit;
	
	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getDashboardTotalOutStanding` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getDashboardTotalOutStanding`(
	IN `p_CompanyID` INT,
	IN `p_CurrencyID` INT,
	IN `p_AccountID` INT


)
BEGIN
	DECLARE v_Round_ int;
	DECLARE v_TotalInvoice_ decimal(18,6);
	DECLARE v_TotalPayment_ decimal(18,6);

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;


	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	SELECT IFNULL(SUM(GrandTotal),0) INTO v_TotalInvoice_
	FROM tblInvoice 
	WHERE 
		CompanyID = p_CompanyID
		AND CurrencyID = p_CurrencyID		
		AND InvoiceType = 1 
		AND InvoiceStatus NOT IN ( 'cancel' , 'draft' )
		AND (p_AccountID = 0 or AccountID = p_AccountID);
		
	SELECT IFNULL(SUM(p.Amount),0) INTO v_TotalPayment_
		FROM tblPayment p 
	INNER JOIN wavetelwholesaleRM.tblAccount ac 
		ON ac.AccountID = p.AccountID
	WHERE 
		p.CompanyID = p_CompanyID
		AND ac.CurrencyId = p_CurrencyID	
		AND p.Status = 'Approved'
		AND p.Recall=0
		AND p.PaymentType = 'Payment In'
		AND (p_AccountID = 0 or ac.AccountID = p_AccountID);
	
	SELECT ROUND((v_TotalInvoice_ - v_TotalPayment_),v_Round_) AS TotalOutstanding ;


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getDisputeDetail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getDisputeDetail`(IN `p_CompanyID` INT, IN `p_DisputeID` INT)
BEGIN

 
 
 
     SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

 

				SELECT   
				ds.DisputeID,
				CASE WHEN ds.InvoiceType = 2 THEN 'Invoice Received' 
				     WHEN ds.InvoiceType = 1 THEN 'Invoice Sent' 
				     ELSE ''
				END as InvoiceType,
		 		a.AccountName,
				ds.InvoiceNo,
				ds.DisputeAmount,
				ds.Notes,
 			   CASE WHEN ds.`Status`= 0 THEN
				 		'Pending' 
				WHEN ds.`Status`= 1 THEN
					'Settled' 
				WHEN ds.`Status`= 2 THEN
					'Cancel' 
				END as `Status`,
				ds.created_at,
				ds.CreatedBy,
		 		ds.Attachment,
		 		ds.updated_at
            from tblDispute ds
            inner join wavetelwholesaleRM.tblAccount a on a.CompanyId = ds.CompanyID and a.AccountID = ds.AccountID
            where ds.CompanyID = p_CompanyID
            AND ds.DisputeID = p_DisputeID
				limit 1;
            
            

 

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getDisputes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getDisputes`(IN `p_CompanyID` INT, IN `p_InvoiceType` INT, IN `p_AccountID` INT, IN `p_InvoiceNumber` VARCHAR(100), IN `p_Status` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(50), IN `p_Export` INT)
BEGIN

     DECLARE v_OffSet_ int;
     SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	      
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;


	if p_Export = 0
	THEN

    			SELECT   
    			ds.InvoiceType,
		 		a.AccountName,
				ds.InvoiceNo,
				ds.DisputeAmount,
				 CASE WHEN ds.`Status`= 0 THEN
				 		'Pending' 
				WHEN ds.`Status`= 1 THEN
					'Settled' 
				WHEN ds.`Status`= 2 THEN
					'Cancel' 
				END as `Status`,
				ds.created_at as `CreatedDate`,
				ds.CreatedBy,
				CASE WHEN LENGTH(ds.Notes) > 100 THEN CONCAT(SUBSTRING(ds.Notes, 1, 100) , '...')
						 ELSE  ds.Notes 
						 END as ShortNotes ,
		 		ds.DisputeID,
		 	   ds.Attachment,
		 	   a.AccountID,
		 		ds.Notes
		 		
            from tblDispute ds
            inner join wavetelwholesaleRM.tblAccount a on a.AccountID = ds.AccountID

				where ds.CompanyID = p_CompanyID

			   AND (p_InvoiceType = 0 OR ( p_InvoiceType != 0 AND ds.InvoiceType = p_InvoiceType))
            AND(p_InvoiceNumber is NULL OR ds.InvoiceNo like Concat('%',p_InvoiceNumber,'%'))
            AND(p_AccountID is NULL OR ds.AccountID = p_AccountID)
            AND(p_Status is NULL OR ds.`Status` = p_Status)
           AND(p_StartDate is NULL OR cast(ds.created_at as Date) >= p_StartDate)
            AND(p_EndDate is NULL OR cast(ds.created_at as Date) <= p_EndDate) 
            
         ORDER BY
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN AccountName
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN AccountName
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNoDESC') THEN InvoiceNo
                END DESC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNoASC') THEN InvoiceNo
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DisputeAmountDESC') THEN DisputeAmount
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DisputeAmountASC') THEN DisputeAmount
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN ds.created_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN ds.created_at
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN ds.Status
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN ds.Status
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DisputeIDDESC') THEN DisputeID
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DisputeIDASC') THEN DisputeID
                END ASC 			 
					 					 					    	             
                
            LIMIT p_RowspPage OFFSET v_OffSet_;

		 

				 SELECT   
		 		COUNT(ds.DisputeID) AS totalcount,
		 		sum(ds.DisputeAmount) as TotalDisputeAmount
            from tblDispute ds
            inner join wavetelwholesaleRM.tblAccount a on a.AccountID = ds.AccountID
				where ds.CompanyID = p_CompanyID

				AND (p_InvoiceType = 0 OR ( p_InvoiceType != 0 AND ds.InvoiceType = p_InvoiceType))
            AND(p_InvoiceNumber is NULL OR ds.InvoiceNo like Concat('%',p_InvoiceNumber,'%'))
            AND(p_AccountID is NULL OR ds.AccountID = p_AccountID)
            AND(p_Status is NULL OR ds.`Status` = p_Status)
            AND(p_StartDate is NULL OR cast(ds.created_at as Date) >= p_StartDate)
            AND(p_EndDate is NULL OR cast(ds.created_at as Date) <= p_EndDate) ;
            
            
	ELSE

				SELECT   
				ds.InvoiceType,
		 		a.AccountName,
				ds.InvoiceNo,
				ds.DisputeAmount,
				 CASE WHEN ds.`Status`= 0 THEN
				 		'Pending' 
				WHEN ds.`Status`= 1 THEN
					'Settled' 
				WHEN ds.`Status`= 2 THEN
					'Cancel' 
				END as `Status`,
				ds.created_at as `CreatedDate`,
				ds.CreatedBy,
				CASE WHEN LENGTH(ds.Notes) > 100 THEN CONCAT(SUBSTRING(ds.Notes, 1, 100) , '...')
						 ELSE  ds.Notes 
						 END as ShortNotes ,
		 		ds.Notes
				

            from tblDispute ds
            inner join wavetelwholesaleRM.tblAccount a on a.AccountID = ds.AccountID
            
            
				where ds.CompanyID = p_CompanyID
            
            AND (p_InvoiceType = 0 OR ( p_InvoiceType != 0 AND ds.InvoiceType = p_InvoiceType))
				AND(p_InvoiceNumber is NULL OR ds.InvoiceNo like Concat('%',p_InvoiceNumber,'%'))
            AND(p_AccountID is NULL OR ds.AccountID = p_AccountID)
            AND(p_Status is NULL OR ds.`Status` = p_Status)
           AND(p_StartDate is NULL OR cast(ds.created_at as Date) >= p_StartDate)
            AND(p_EndDate is NULL OR cast(ds.created_at as Date) <= p_EndDate) ;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getDueInvoice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getDueInvoice`(IN `p_CompanyID` INT, IN `p_AccountID` INT, IN `p_BillingClassID` INT)
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT * FROM(
		SELECT
			inv.InvoiceID AS InvoiceID,
			inv.GrandTotal,
			inv.GrandTotal - (SELECT COALESCE(SUM(p.Amount),0) FROM tblPayment p WHERE p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) AS InvoiceOutStanding,
			inv.FullInvoiceNumber as InvoiceNumber,
			DATE_ADD(inv.IssueDate,INTERVAL b.PaymentDueInDays DAY) as DueDate,
			DATEDIFF(NOW(),DATE_ADD(inv.IssueDate,INTERVAL b.PaymentDueInDays DAY)) as DueDay,
			a.AccountID,
			a.created_at as AccountCreationDate
		FROM tblInvoice inv
		INNER JOIN wavetelwholesaleRM.tblAccount a
			ON inv.AccountID = a.AccountID
		INNER JOIN wavetelwholesaleRM.tblAccountBilling ab
			ON ab.AccountID = a.AccountID	
		INNER JOIN wavetelwholesaleRM.tblBillingClass b
			ON b.BillingClassID = ab.BillingClassID
		WHERE inv.CompanyID = p_CompanyID
		AND ( p_AccountID = 0 OR inv.AccountID =   p_AccountID)
		AND (p_BillingClassID = 0 OR  b.BillingClassID = p_BillingClassID)
		AND InvoiceStatus NOT IN('awaiting','draft','Cancel')
		AND inv.GrandTotal <> 0
	)tbl
	WHERE InvoiceOutStanding > 0 ;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getEstimate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getEstimate`(IN `p_CompanyID` INT, IN `p_AccountID` INT, IN `p_EstimateNumber` VARCHAR(50), IN `p_IssueDateStart` DATETIME, IN `p_IssueDateEnd` DATETIME, IN `p_EstimateStatus` VARCHAR(50), IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_CurrencyID` INT, IN `p_isExport` INT)
BEGIN
    
    DECLARE v_OffSet_ INT;
    DECLARE v_Round_ INT;    
    DECLARE v_CurrencyCode_ VARCHAR(50);
 	 SET sql_mode = 'ALLOW_INVALID_DATES';
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	        
 	 SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
 	 SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	 SELECT cr.Symbol INTO v_CurrencyCode_ from wavetelwholesaleRM.tblCurrency cr where cr.CurrencyId =p_CurrencyID;
    IF p_isExport = 0
    THEN
        SELECT 
        ac.AccountName,
        CONCAT(LTRIM(RTRIM(IFNULL(it.EstimateNumberPrefix,''))), LTRIM(RTRIM(inv.EstimateNumber))) AS EstimateNumber,
        inv.IssueDate,
        CONCAT(IFNULL(cr.Symbol,''),ROUND(inv.GrandTotal,v_Round_)) AS GrandTotal2,		
        inv.EstimateStatus,
        inv.EstimateID,
        inv.Description,
        inv.Attachment,
        inv.AccountID,		  
		  IFNULL(ac.BillingEmail,'') AS BillingEmail,
		  ROUND(inv.GrandTotal,v_Round_) AS GrandTotal,
		  inv.converted
        FROM tblEstimate inv
        INNER JOIN wavetelwholesaleRM.tblAccount ac ON ac.AccountID = inv.AccountID
        INNER JOIN wavetelwholesaleRM.tblAccountBilling ab ON ab.AccountID = ac.AccountID
        INNER JOIN wavetelwholesaleRM.tblBillingClass b ON ab.BillingClassID = b.BillingClassID
		  LEFT JOIN tblInvoiceTemplate it on b.InvoiceTemplateID = it.InvoiceTemplateID
        LEFT JOIN wavetelwholesaleRM.tblCurrency cr ON inv.CurrencyID   = cr.CurrencyId 
        WHERE ac.CompanyID = p_CompanyID
        AND (p_AccountID = 0 OR ( p_AccountID != 0 AND inv.AccountID = p_AccountID))
        AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND inv.EstimateNumber = p_EstimateNumber))
        AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND inv.IssueDate >= p_IssueDateStart))
        AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND inv.IssueDate <= p_IssueDateEnd))
        AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND inv.EstimateStatus = p_EstimateStatus))
		AND (p_CurrencyID = '' OR ( p_CurrencyID != '' AND inv.CurrencyID = p_CurrencyID))
        ORDER BY
                CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN ac.AccountName
            END DESC,
                CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN ac.AccountName
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EstimateStatusDESC') THEN inv.EstimateStatus
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EstimateStatusASC') THEN inv.EstimateStatus
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EstimateNumberASC') THEN inv.EstimateNumber
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EstimateNumberDESC') THEN inv.EstimateNumber
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IssueDateASC') THEN inv.IssueDate
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IssueDateDESC') THEN inv.IssueDate
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalDESC') THEN inv.GrandTotal
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalASC') THEN inv.GrandTotal
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EstimateIDDESC') THEN inv.EstimateID
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EstimateIDASC') THEN inv.EstimateID
            END ASC
        
        LIMIT p_RowspPage OFFSET v_OffSet_;
        
        
        SELECT
            COUNT(*) AS totalcount,  ROUND(SUM(inv.GrandTotal),v_Round_) AS total_grand,v_CurrencyCode_ as currency_symbol
        FROM
        tblEstimate inv
        INNER JOIN wavetelwholesaleRM.tblAccount ac ON ac.AccountID = inv.AccountID
        INNER JOIN wavetelwholesaleRM.tblAccountBilling ab ON ab.AccountID = ac.AccountID
        INNER JOIN wavetelwholesaleRM.tblBillingClass b ON ab.BillingClassID = b.BillingClassID
		  LEFT JOIN tblInvoiceTemplate it on b.InvoiceTemplateID = it.InvoiceTemplateID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_AccountID = 0 OR ( p_AccountID != 0 AND inv.AccountID = p_AccountID))
        AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND inv.EstimateNumber = p_EstimateNumber))
        AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND inv.IssueDate >= p_IssueDateStart))
        AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND inv.IssueDate <= p_IssueDateEnd))
        AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND inv.EstimateStatus = p_EstimateStatus))
		AND (p_CurrencyID = '' OR ( p_CurrencyID != '' AND inv.CurrencyID = p_CurrencyID));
    END IF;
    IF p_isExport = 1
    THEN
        SELECT ac.AccountName ,
        ( CONCAT(LTRIM(RTRIM(IFNULL(it.InvoiceNumberPrefix,''))), LTRIM(RTRIM(inv.EstimateNumber)))) AS EstimateNumber,
        inv.IssueDate,
        ROUND(inv.GrandTotal,v_Round_) AS GrandTotal,
        inv.EstimateStatus
        FROM tblEstimate inv
        INNER JOIN wavetelwholesaleRM.tblAccount ac ON ac.AccountID = inv.AccountID
        INNER JOIN wavetelwholesaleRM.tblAccountBilling ab ON ab.AccountID = ac.AccountID
        INNER JOIN wavetelwholesaleRM.tblBillingClass b ON ab.BillingClassID = b.BillingClassID
		  LEFT JOIN tblInvoiceTemplate it on b.InvoiceTemplateID = it.InvoiceTemplateID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_AccountID = 0 OR ( p_AccountID != 0 AND inv.AccountID = p_AccountID))
        AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND inv.EstimateNumber = p_EstimateNumber))
        AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND inv.IssueDate >= p_IssueDateStart))
        AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND inv.IssueDate <= p_IssueDateEnd))
        AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND inv.EstimateStatus = p_EstimateStatus))
		AND (p_CurrencyID = '' OR ( p_CurrencyID != '' AND inv.CurrencyID = p_CurrencyID));
    END IF;
     IF p_isExport = 2
    THEN
        SELECT ac.AccountID ,
        ac.AccountName,
        ( CONCAT(LTRIM(RTRIM(IFNULL(it.InvoiceNumberPrefix,''))), LTRIM(RTRIM(inv.EstimateNumber)))) AS EstimateNumber,
        inv.IssueDate,
		  ROUND(inv.GrandTotal,v_Round_) AS GrandTotal,
        inv.EstimateStatus,
        inv.EstimateID
        FROM tblEstimate inv
        INNER JOIN wavetelwholesaleRM.tblAccount ac ON ac.AccountID = inv.AccountID
        INNER JOIN wavetelwholesaleRM.tblAccountBilling ab ON ab.AccountID = ac.AccountID
        INNER JOIN wavetelwholesaleRM.tblBillingClass b ON ab.BillingClassID = b.BillingClassID
		  LEFT JOIN tblInvoiceTemplate it on b.InvoiceTemplateID = it.InvoiceTemplateID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_AccountID = 0 OR ( p_AccountID != 0 AND inv.AccountID = p_AccountID))
        AND (p_EstimateNumber = '' OR ( p_EstimateNumber != '' AND inv.EstimateNumber = p_EstimateNumber))
        AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND inv.IssueDate >= p_IssueDateStart))
        AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND inv.IssueDate <= p_IssueDateEnd))
        AND (p_EstimateStatus = '' OR ( p_EstimateStatus != '' AND inv.EstimateStatus = p_EstimateStatus))
		AND (p_CurrencyID = '' OR ( p_CurrencyID != '' AND inv.CurrencyID = p_CurrencyID));
    END IF; 
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetEstimateLog` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetEstimateLog`(IN `p_CompanyID` INT, IN `p_EstimateID` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(50), IN `p_isExport` INT)
BEGIN

	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
    IF p_isExport = 0
    THEN

       
            SELECT
                el.Note,
                el.EstimateLogStatus,
                el.created_at,                
                es.EstimateID                
            FROM tblEstimate es
            INNER JOIN wavetelwholesaleRM.tblAccount ac
                ON ac.AccountID = es.AccountID
            INNER JOIN tblEstimateLog el
                ON el.EstimateID = es.EstimateID
            WHERE ac.CompanyID = p_CompanyID
            AND (p_EstimateID = '' 
            OR (p_EstimateID != ''
            AND es.EstimateID = p_EstimateID))
             ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EstimateLogStatusDESC') THEN el.EstimateLogStatus
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'EstimateLogStatusASC') THEN el.EstimateLogStatus
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN el.created_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN el.created_at
                END ASC
					LIMIT p_RowspPage OFFSET v_OffSet_;

        SELECT
            COUNT(*) AS totalcount
        FROM tblEstimate es
        INNER JOIN wavetelwholesaleRM.tblAccount ac
            ON ac.AccountID = es.AccountID
        INNER JOIN tblEstimateLog el
            ON el.EstimateID = es.EstimateID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_EstimateID = ''
        OR (p_EstimateID != ''
        AND es.EstimateID = p_EstimateID));

    END IF;
    IF p_isExport = 1
    THEN

        SELECT
            el.Note,
            el.created_at,
            el.EstimateLogStatus,
            es.EstimateNumber
        FROM tblEstimate es
        INNER JOIN wavetelwholesaleRM.tblAccount ac
            ON ac.AccountID = es.AccountID
        INNER JOIN tblEstimateLog el
            ON el.EstimateID = es.EstimateID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_EstimateID = ''
        OR (p_EstimateID != ''
        AND es.EstimateID = p_EstimateID));


    END IF;
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getFilesTobeDownload` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getFilesTobeDownload`(IN `p_CompanyGatewayID` INT, IN `p_filenames` LONGTEXT)
BEGIN

	


  select  FileName from tblUsageDownloadFiles where CompanyGatewayID = p_CompanyGatewayID and  FileName not in ( p_filenames ) ; 
  
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getInvoice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getInvoice`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_InvoiceNumber` VARCHAR(50),
	IN `p_IssueDateStart` DATETIME,
	IN `p_IssueDateEnd` DATETIME,
	IN `p_InvoiceType` INT,
	IN `p_InvoiceStatus` VARCHAR(50),
	IN `p_IsOverdue` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_CurrencyID` INT,
	IN `p_isExport` INT,
	IN `p_sageExport` INT,
	IN `p_zerovalueinvoice` INT,
	IN `p_InvoiceID` LONGTEXT

)
BEGIN
    DECLARE v_OffSet_ int;
    DECLARE v_Round_ int;
    DECLARE v_CurrencyCode_ VARCHAR(50);
    DECLARE v_TotalCount int;
    
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	 SET  sql_mode='ONLY_FULL_GROUP_BY,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';   	     
 	 SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
    SELECT cr.Symbol INTO v_CurrencyCode_ from wavetelwholesaleRM.tblCurrency cr where cr.CurrencyId =p_CurrencyID;
    SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;


 
		
 DROP TEMPORARY TABLE IF EXISTS tmp_Invoices_;
CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Invoices_(
	InvoiceType tinyint(1),
	AccountName varchar(100),
	InvoiceNumber varchar(100),
	IssueDate datetime,
	InvoicePeriod varchar(100),
	CurrencySymbol varchar(5),
	GrandTotal decimal(18,6),
	TotalPayment decimal(18,6),
	PendingAmount decimal(18,6),
	InvoiceStatus varchar(50),
	InvoiceID int,
	Description varchar(500),
	Attachment varchar(255),
	AccountID int,
	ItemInvoice tinyint(1),
	BillingEmail varchar(255),
	AccountNumber varchar(100),
	PaymentDueInDays int,
	PaymentDate datetime,
	SubTotal decimal(18,6),
	TotalTax decimal(18,6),
	NominalAnalysisNominalAccountNumber varchar(100)
);
	

    
		insert into tmp_Invoices_
		SELECT inv.InvoiceType ,
			ac.AccountName,
			FullInvoiceNumber as InvoiceNumber,
			inv.IssueDate,
			IF(invd.StartDate IS NULL ,'',CONCAT('From ',date(invd.StartDate) ,'<br> To ',date(invd.EndDate))) as InvoicePeriod,
			IFNULL(cr.Symbol,'') as CurrencySymbol,
			inv.GrandTotal as GrandTotal,		
			(select IFNULL(sum(p.Amount),0) from tblPayment p where p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) as TotalPayment,
			(inv.GrandTotal -  (select IFNULL(sum(p.Amount),0) from tblPayment p where p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) ) as `PendingAmount`,
			inv.InvoiceStatus,
			inv.InvoiceID,
			inv.Description,
			inv.Attachment,
			inv.AccountID,
			inv.ItemInvoice,
			IFNULL(ac.BillingEmail,'') as BillingEmail,
			ac.Number,
			(SELECT IFNULL(b.PaymentDueInDays,0) FROM wavetelwholesaleRM.tblAccountBilling ab INNER JOIN wavetelwholesaleRM.tblBillingClass b ON b.BillingClassID =ab.BillingClassID WHERE ab.AccountID = ac.AccountID) as PaymentDueInDays,
			(select PaymentDate from tblPayment p where p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.Recall =0 AND p.AccountID = inv.AccountID order by PaymentID desc limit 1) AS PaymentDate,
			inv.SubTotal,
			inv.TotalTax,
			ac.NominalAnalysisNominalAccountNumber 			
			FROM tblInvoice inv
			inner join wavetelwholesaleRM.tblAccount ac on ac.AccountID = inv.AccountID
			left join tblInvoiceDetail invd on invd.InvoiceID = inv.InvoiceID AND invd.ProductType = 2
			left join wavetelwholesaleRM.tblCurrency cr ON inv.CurrencyID   = cr.CurrencyId 
			where ac.CompanyID = p_CompanyID
			AND (p_AccountID = 0 OR ( p_AccountID != 0 AND inv.AccountID = p_AccountID))
			AND (p_InvoiceNumber = '' OR (inv.FullInvoiceNumber like Concat('%',p_InvoiceNumber,'%')))
			AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND inv.IssueDate >= p_IssueDateStart))
			AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND inv.IssueDate <= p_IssueDateEnd))
			AND (p_InvoiceType = 0 OR ( p_InvoiceType != 0 AND inv.InvoiceType = p_InvoiceType))
			AND (p_InvoiceStatus = '' OR ( p_InvoiceStatus != '' AND FIND_IN_SET(inv.InvoiceStatus,p_InvoiceStatus) ))
			AND (p_zerovalueinvoice = 0 OR ( p_zerovalueinvoice = 1 AND inv.GrandTotal != 0))
			AND (p_InvoiceID = '' OR (p_InvoiceID !='' AND FIND_IN_SET (inv.InvoiceID,p_InvoiceID)!= 0 ))
			AND (p_CurrencyID = '' OR ( p_CurrencyID != '' AND inv.CurrencyID = p_CurrencyID));
	       


	
    IF p_isExport = 0 and p_sageExport = 0
    THEN
	
	

        SELECT 
		InvoiceType ,
        AccountName,
	    InvoiceNumber,
        IssueDate,
        InvoicePeriod,
        CONCAT(CurrencySymbol, ROUND(GrandTotal,v_Round_)) as GrandTotal2,
	    CONCAT(CurrencySymbol,ROUND(TotalPayment,v_Round_),'/',ROUND(PendingAmount,v_Round_)) as `PendingAmount`,
        InvoiceStatus,
        InvoiceID,
        Description,
        Attachment,
        AccountID,
        PendingAmount as OutstandingAmount, 
        ItemInvoice,
		BillingEmail,
		GrandTotal
        FROM tmp_Invoices_ 
        WHERE (p_IsOverdue = 0 
					OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
							AND(InvoiceStatus NOT IN('awaiting','draft','Cancel'))
							AND(PendingAmount>0)
						)
				)
        ORDER BY
                CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN AccountName
            END DESC,
                CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN AccountName
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceTypeDESC') THEN InvoiceType
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceTypeASC') THEN InvoiceType
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceStatusDESC') THEN InvoiceStatus
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceStatusASC') THEN InvoiceStatus
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNumberASC') THEN InvoiceNumber
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNumberDESC') THEN InvoiceNumber
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IssueDateASC') THEN IssueDate
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'IssueDateDESC') THEN IssueDate
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoicePeriodASC') THEN InvoicePeriod
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoicePeriodDESC') THEN InvoicePeriod
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalDESC') THEN GrandTotal
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalASC') THEN GrandTotal
            END ASC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceIDDESC') THEN InvoiceID
            END DESC,
            CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceIDASC') THEN InvoiceID
            END ASC
				 LIMIT p_RowspPage OFFSET v_OffSet_;
        
        SELECT COUNT(*) into v_TotalCount FROM tmp_Invoices_
		  WHERE (p_IsOverdue = 0 
					OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
							AND(InvoiceStatus NOT IN('awaiting','draft','Cancel'))
							AND(PendingAmount>0)
						)
				);
		   
        SELECT
            v_TotalCount AS totalcount,
			ROUND(sum(GrandTotal),v_Round_) as total_grand,
			ROUND(sum(TotalPayment),v_Round_) as `TotalPayment`, 
			ROUND(sum(PendingAmount),v_Round_) as `TotalPendingAmount`,
			v_CurrencyCode_ as currency_symbol
        FROM tmp_Invoices_ 
			WHERE ((InvoiceStatus IS NULL) OR (InvoiceStatus NOT IN('draft','Cancel')))
			AND (p_IsOverdue = 0 
					OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
							AND(InvoiceStatus NOT IN('awaiting','draft','Cancel'))
							AND(PendingAmount>0)
						)
				);
		
    END IF;
    IF p_isExport = 1
    THEN

        SELECT 
		AccountName ,
        InvoiceNumber,
        IssueDate,
        REPLACE(InvoicePeriod, '<br>', '') as InvoicePeriod,
        CONCAT(CurrencySymbol, ROUND(GrandTotal,v_Round_)) as GrandTotal,
	    CONCAT(CurrencySymbol,ROUND(TotalPayment,v_Round_),'/',ROUND(PendingAmount,v_Round_)) as `Paid/OS`,
        InvoiceStatus,
        InvoiceType,
        ItemInvoice
        FROM tmp_Invoices_
		  WHERE
		  		(p_IsOverdue = 0 
					OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
							AND(InvoiceStatus NOT IN('awaiting','draft','Cancel'))
							AND(PendingAmount>0)
						)
				);
		END IF;
     IF p_isExport = 2
    THEN

		
        SELECT 
		AccountName ,
        InvoiceNumber,
        IssueDate,
        REPLACE(InvoicePeriod, '<br>', '') as InvoicePeriod,
        CONCAT(CurrencySymbol, ROUND(GrandTotal,v_Round_)) as GrandTotal,
	    CONCAT(CurrencySymbol,ROUND(TotalPayment,v_Round_),'/',ROUND(PendingAmount,v_Round_)) as `Paid/OS`,
        InvoiceStatus,
        InvoiceType,
        ItemInvoice,
        InvoiceID
        FROM tmp_Invoices_
		  WHERE
		  		(p_IsOverdue = 0 
					OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
							AND(InvoiceStatus NOT IN('awaiting','draft','Cancel'))
							AND(PendingAmount>0)
						)
				);
        
    END IF;

    IF p_sageExport =1 OR p_sageExport =2
    THEN
    		 
        IF p_sageExport = 2
        THEN 
        UPDATE tblInvoice  inv
        INNER JOIN wavetelwholesaleRM.tblAccount ac
          ON ac.AccountID = inv.AccountID
        INNER JOIN wavetelwholesaleRM.tblAccountBilling ab
          ON ab.AccountID = ac.AccountID
	     INNER JOIN wavetelwholesaleRM.tblBillingClass b
          ON ab.BillingClassID = b.BillingClassID
        INNER JOIN wavetelwholesaleRM.tblCurrency c
          ON c.CurrencyId = ac.CurrencyId
        SET InvoiceStatus = 'paid' 
        WHERE ac.CompanyID = p_CompanyID
                AND (p_AccountID = 0 OR ( p_AccountID != 0 AND inv.AccountID = p_AccountID))
                AND (p_InvoiceNumber = '' OR ( p_InvoiceNumber != '' AND inv.InvoiceNumber = p_InvoiceNumber))
                AND (p_IssueDateStart = '0000-00-00 00:00:00' OR ( p_IssueDateStart != '0000-00-00 00:00:00' AND inv.IssueDate >= p_IssueDateStart))
			       AND (p_IssueDateEnd = '0000-00-00 00:00:00' OR ( p_IssueDateEnd != '0000-00-00 00:00:00' AND inv.IssueDate <= p_IssueDateEnd))
                AND (p_InvoiceType = 0 OR ( p_InvoiceType != 0 AND inv.InvoiceType = p_InvoiceType))
                AND (p_InvoiceStatus = '' OR ( p_InvoiceStatus != '' AND FIND_IN_SET(inv.InvoiceStatus,p_InvoiceStatus) ))
                AND (p_zerovalueinvoice = 0 OR ( p_zerovalueinvoice = 1 AND inv.GrandTotal != 0))
                AND (p_InvoiceID = '' OR (p_InvoiceID !='' AND FIND_IN_SET (inv.InvoiceID,p_InvoiceID)!= 0 ))
				AND (p_CurrencyID = '' OR ( p_CurrencyID != '' AND inv.CurrencyID = p_CurrencyID)) 
				AND (p_IsOverdue = 0 
					OR ((To_days(NOW()) - To_days(IssueDate)) > IFNULL(b.PaymentDueInDays,0)
							AND(InvoiceStatus NOT IN('awaiting','draft','Cancel'))
							AND((inv.GrandTotal -  (select IFNULL(sum(p.Amount),0) from tblPayment p where p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0) )>0)
						)
				);
        END IF; 
        SELECT
          AccountNumber,
          DATE_FORMAT(DATE_ADD(IssueDate,INTERVAL PaymentDueInDays DAY), '%Y-%m-%d') AS DueDate,
          GrandTotal AS GoodsValueInAccountCurrency,
          GrandTotal AS SalControlValueInBaseCurrency,
          1 AS DocumentToBaseCurrencyRate,
          1 AS DocumentToAccountCurrencyRate,
          DATE_FORMAT(IssueDate, '%Y-%m-%d') AS PostedDate,
          InvoiceNumber AS TransactionReference,
          '' AS SecondReference,
          '' AS Source,
          4 AS SYSTraderTranType, 
          DATE_FORMAT(PaymentDate ,'%Y-%m-%d') AS TransactionDate,
          TotalTax AS TaxValue,
          SubTotal AS `NominalAnalysisTransactionValue/1`,
          NominalAnalysisNominalAccountNumber AS `NominalAnalysisNominalAccountNumber/1`,
          'NEON' AS `NominalAnalysisNominalAnalysisNarrative/1`,
          '' AS `NominalAnalysisTransactionAnalysisCode/1`,
          1 AS `TaxAnalysisTaxRate/1`,
          SubTotal AS `TaxAnalysisGoodsValueBeforeDiscount/1`,
          TotalTax as   `TaxAnalysisTaxOnGoodsValue/1`

        FROM tmp_Invoices_
        WHERE
		  		(p_IsOverdue = 0 
					OR ((To_days(NOW()) - To_days(IssueDate)) > PaymentDueInDays
							AND(InvoiceStatus NOT IN('awaiting','draft','Cancel'))
							AND(PendingAmount>0)
						)
				);

		
    END IF;

 
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetInvoiceLog` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetInvoiceLog`(
	IN `p_CompanyID` INT,
	IN `p_InvoiceID` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(50),
	IN `p_isExport` INT
)
BEGIN


	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	            
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;


    IF p_isExport = 0
    THEN

       
            SELECT
                tl.Note,
                tl.InvoiceLogStatus,
                tl.created_at,                
                inv.InvoiceID
                
            FROM tblInvoice inv
            INNER JOIN wavetelwholesaleRM.tblAccount ac
                ON ac.AccountID = inv.AccountID
            INNER JOIN tblInvoiceLog tl
                ON tl.InvoiceID = inv.InvoiceID
            WHERE ac.CompanyID = p_CompanyID
            AND (p_InvoiceID = '' 
            OR (p_InvoiceID != ''
            AND inv.InvoiceID = p_InvoiceID))
             ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceLogStatusDESC') THEN tl.InvoiceLogStatus
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceLogStatusASC') THEN tl.InvoiceLogStatus
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN tl.created_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN tl.created_at
                END ASC
					LIMIT p_RowspPage OFFSET v_OffSet_;

        SELECT
            COUNT(*) AS totalcount
        FROM tblInvoice inv
        INNER JOIN wavetelwholesaleRM.tblAccount ac
            ON ac.AccountID = inv.AccountID
        INNER JOIN tblInvoiceLog tl
            ON tl.InvoiceID = inv.InvoiceID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_InvoiceID = ''
        OR (p_InvoiceID != ''
        AND inv.InvoiceID = p_InvoiceID));

    END IF;
    IF p_isExport = 1
    THEN

        SELECT
            tl.Note,
            tl.created_at,
            tl.InvoiceLogStatus,
            inv.InvoiceNumber
        FROM tblInvoice inv
        INNER JOIN wavetelwholesaleRM.tblAccount ac
            ON ac.AccountID = inv.AccountID
        INNER JOIN tblInvoiceLog tl
            ON tl.InvoiceID = inv.InvoiceID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_InvoiceID = ''
        OR (p_InvoiceID != ''
        AND inv.InvoiceID = p_InvoiceID));


    END IF;
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getInvoicePayments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getInvoicePayments`(IN `p_InvoiceID` INT, IN `p_CompanyID` INT)
BEGIN

	DECLARE v_Round_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	SELECT
		ROUND(SUM(inv.GrandTotal),v_Round_) as total_grand,
		ROUND((SELECT IFNULL(SUM(p.Amount),0) FROM tblPayment p WHERE p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0),v_Round_) as `paid_amount`,
		ROUND(inv.GrandTotal -  (SELECT IFNULL(SUM(p.Amount),0) FROM tblPayment p WHERE p.InvoiceID = inv.InvoiceID AND p.Status = 'Approved' AND p.AccountID = inv.AccountID AND p.Recall =0 ),v_Round_) as due_amount
	FROM tblInvoice inv
	WHERE InvoiceID=p_InvoiceID;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetInvoiceTransactionLog` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetInvoiceTransactionLog`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_InvoiceID` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` int



)
BEGIN
    
    DECLARE v_OffSet_ int;
    DECLARE v_Round_ int;
    DECLARE v_Currency_ VARCHAR(10);
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	


    IF p_isExport = 0
    THEN

         
            SELECT
                `Transaction`,
                tl.Notes,
                ROUND(tl.Amount,v_Round_) as Amount,
                
                tl.Status,
                tl.created_at,
                inv.InvoiceID
                
            FROM tblInvoice inv
            INNER JOIN wavetelwholesaleRM.tblAccount ac
                ON ac.AccountID = inv.AccountID
            INNER JOIN tblTransactionLog tl
                ON tl.InvoiceID = inv.InvoiceID
                AND tl.CompanyID = inv.CompanyID
            WHERE ac.CompanyID = p_CompanyID
            AND (p_AccountID = 0
            OR (p_AccountID != 0
            AND inv.AccountID = p_AccountID))
            AND (p_InvoiceID = ''
            OR (p_InvoiceID != ''
            AND inv.InvoiceID = p_InvoiceID)) 
            ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AmountDESC') THEN tl.Amount
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AmountASC') THEN tl.Amount
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN tl.Status
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN tl.Status
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN tl.created_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN tl.created_at
                END ASC
        LIMIT p_RowspPage OFFSET v_OffSet_;

        SELECT
            COUNT(*) AS totalcount
        FROM tblInvoice inv
        INNER JOIN wavetelwholesaleRM.tblAccount ac
            ON ac.AccountID = inv.AccountID
        INNER JOIN tblTransactionLog tl
            ON tl.InvoiceID = inv.InvoiceID
            AND tl.CompanyID = inv.CompanyID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_AccountID = 0
        OR (p_AccountID != 0
        AND inv.AccountID = p_AccountID))
        AND (p_InvoiceID = ''
        OR (p_InvoiceID != ''
        AND inv.InvoiceID = p_InvoiceID));

    END IF;
    
    IF p_isExport = 1
    THEN

        SELECT
            inv.InvoiceNumber,
				`Transaction`,
            tl.Notes,
            tl.created_at,
            ROUND(tl.Amount,v_Round_) as Amount,
            
            tl.Status,
            inv.InvoiceID
        FROM tblInvoice inv
        INNER JOIN wavetelwholesaleRM.tblAccount ac
            ON ac.AccountID = inv.AccountID
        INNER JOIN tblTransactionLog tl
            ON tl.InvoiceID = inv.InvoiceID
            AND tl.CompanyID = inv.CompanyID
        WHERE ac.CompanyID = p_CompanyID
        AND (p_AccountID = 0
        OR (p_AccountID != 0
        AND inv.AccountID = p_AccountID))
        AND (p_InvoiceID = ''
        OR (p_InvoiceID != ''
        AND inv.InvoiceID = p_InvoiceID));
		  
	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getInvoiceUsage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getInvoiceUsage`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_ShowZeroCall` INT
)
BEGIN
    
	DECLARE v_InvoiceCount_ INT; 
	DECLARE v_BillingTime_ INT; 
	DECLARE v_CDRType_ INT; 
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetBillingTime(p_GatewayID,p_AccountID) INTO v_BillingTime_;

	CALL fnUsageDetail(p_CompanyID,p_AccountID,p_GatewayID,p_StartDate,p_EndDate,0,1,v_BillingTime_,'','','',0); 

	SELECT b.CDRType  INTO v_CDRType_ FROM wavetelwholesaleRM.tblAccountBilling ab INNER JOIN  wavetelwholesaleRM.tblBillingClass b  ON b.BillingClassID = ab.BillingClassID WHERE ab.AccountID = p_AccountID;


            
        
            
    IF( v_CDRType_ = 2) 
    Then

        SELECT
            area_prefix AS AreaPrefix,
            Trunk,
            (SELECT 
                Country
            FROM wavetelwholesaleRM.tblRate r
            INNER JOIN wavetelwholesaleRM.tblCountry c
                ON c.CountryID = r.CountryID
            WHERE  r.Code = ud.area_prefix limit 1)
            AS Country,
            (SELECT Description
            FROM wavetelwholesaleRM.tblRate r
            WHERE  r.Code = ud.area_prefix limit 1 )
            AS Description,
            COUNT(UsageDetailID) AS NoOfCalls,
            CONCAT( FLOOR(SUM(duration ) / 60), ':' , SUM(duration ) % 60) AS Duration,
            CONCAT( FLOOR(SUM(billed_duration ) / 60),':' , SUM(billed_duration ) % 60) AS BillDuration,
            SUM(cost) AS TotalCharges,
            SUM(duration ) as DurationInSec,
            SUM(billed_duration ) as BillDurationInSec

        FROM tmp_tblUsageDetails_ ud
        GROUP BY ud.area_prefix,ud.Trunk,ud.AccountID;

         
    ELSE
        
        
            select
            trunk,
            area_prefix,
            concat("'",cli) as cli,
            concat("'",cld) as cld,
            connect_time,
            disconnect_time,
            billed_duration,
            cost
            FROM tmp_tblUsageDetails_ ud
            WHERE
             ((p_ShowZeroCall =0 and ud.cost >0 )or (p_ShowZeroCall =1 and ud.cost >= 0));
            
    END IF;    
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getMissingAccounts` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getMissingAccounts`(IN `p_CompanyID` int, IN `p_CompanyGatewayID` INT)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SELECT cg.Title,ga.AccountName from tblGatewayAccount ga
	inner join wavetelwholesaleRM.tblCompanyGateway cg on ga.CompanyGatewayID = cg.CompanyGatewayID
	where ga.GatewayAccountID is not null and ga.CompanyID =p_CompanyID and ga.AccountID is null AND cg.`Status` =1
	AND (p_CompanyGatewayID = 0 or ga.CompanyGatewayID = p_CompanyGatewayID )
	ORDER BY ga.CompanyGatewayID,ga.AccountName;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getPaymentPendingInvoice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getPaymentPendingInvoice`(IN `p_CompanyID` INT, IN `p_AccountID` INT, IN `p_PaymentDueInDays` INT )
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT
		MAX(i.InvoiceID) AS InvoiceID,
		(IFNULL(MAX(i.GrandTotal), 0) - IFNULL(SUM(p.Amount), 0)) AS RemaingAmount
	FROM tblInvoice i
	INNER JOIN wavetelwholesaleRM.tblAccount a
		ON i.AccountID = a.AccountID
	INNER JOIN wavetelwholesaleRM.tblAccountBilling ab 
		ON ab.AccountID = a.AccountID
	INNER JOIN wavetelwholesaleRM.tblBillingClass b
		ON b.BillingClassID = ab.BillingClassID
	LEFT JOIN tblPayment p
		ON p.AccountID = i.AccountID
		AND p.InvoiceID = i.InvoiceID AND p.Status = 'Approved' AND p.AccountID = i.AccountID
		AND p.Status = 'Approved'
		AND p.Recall = 0
	WHERE i.CompanyID = p_CompanyID
	AND i.InvoiceStatus != 'cancel'
	AND i.AccountID = p_AccountID
	AND (p_PaymentDueInDays =0  OR (p_PaymentDueInDays =1 AND TIMESTAMPDIFF(DAY, i.IssueDate, NOW()) >= IFNULL(b.PaymentDueInDays,0) ) )

	GROUP BY i.InvoiceID,
			 p.AccountID
	HAVING (IFNULL(MAX(i.GrandTotal), 0) - IFNULL(SUM(p.Amount), 0)) > 0;	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getPayments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getPayments`(
	IN `p_CompanyID` INT,
	IN `p_accountID` INT,
	IN `p_InvoiceNo` varchar(30),
	IN `p_Status` varchar(20),
	IN `p_PaymentType` varchar(20),
	IN `p_PaymentMethod` varchar(20),
	IN `p_RecallOnOff` INT,
	IN `p_CurrencyID` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isCustomer` INT ,
	IN `p_paymentStartDate` DATETIME,
	IN `p_paymentEndDate` DATETIME,
	IN `p_isExport` INT 
)
BEGIN
		
    	DECLARE v_OffSet_ int;
    	DECLARE v_Round_ int;
    	DECLARE v_CurrencyCode_ VARCHAR(50);
    	SET sql_mode = '';
    	
		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
		
		SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
		SELECT cr.Symbol INTO v_CurrencyCode_ from wavetelwholesaleRM.tblCurrency cr where cr.CurrencyId =p_CurrencyID;
	    
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;


	IF p_isExport = 0
    THEN
    select
            tblPayment.PaymentID,
            tblAccount.AccountName,
            tblPayment.AccountID,
            ROUND(tblPayment.Amount,v_Round_) AS Amount,
            CASE WHEN p_isCustomer = 1 THEN
              CASE WHEN PaymentType='Payment Out' THEN 'Payment In' ELSE 'Payment Out'
              END
            ELSE  PaymentType
            END as PaymentType,
            tblPayment.CurrencyID,
            tblPayment.PaymentDate,
            CASE WHEN p_RecallOnOff = -1 AND tblPayment.Recall=1  THEN 'Recalled' ELSE tblPayment.Status END as `Status`,
            tblPayment.CreatedBy,
            tblPayment.PaymentProof,
            tblPayment.InvoiceNo,
            tblPayment.PaymentMethod,
            tblPayment.Notes,
            tblPayment.Recall,
            tblPayment.RecallReasoan,
            tblPayment.RecallBy,
            CONCAT(IFNULL(v_CurrencyCode_,''),ROUND(tblPayment.Amount,v_Round_)) as AmountWithSymbol
            from tblPayment
            left join wavetelwholesaleRM.tblAccount ON tblPayment.AccountID = tblAccount.AccountID
            where tblPayment.CompanyID = p_CompanyID
            AND(p_RecallOnOff = -1 OR tblPayment.Recall = p_RecallOnOff)
            AND(p_accountID = 0 OR tblPayment.AccountID = p_accountID)
            AND((p_InvoiceNo IS NULL OR tblPayment.InvoiceNo like Concat('%',p_InvoiceNo,'%')))
            AND((p_Status IS NULL OR tblPayment.Status = p_Status))
            AND((p_PaymentType IS NULL OR tblPayment.PaymentType = p_PaymentType))
            AND((p_PaymentMethod IS NULL OR tblPayment.PaymentMethod = p_PaymentMethod))
				AND (p_paymentStartDate is null OR ( p_paymentStartDate != '' AND tblPayment.PaymentDate >= p_paymentStartDate))
				AND (p_paymentEndDate  is null OR ( p_paymentEndDate != '' AND tblPayment.PaymentDate <= p_paymentEndDate))
				AND (p_CurrencyID = 0 OR tblPayment.CurrencyId = p_CurrencyID)
            ORDER BY
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN tblAccount.AccountName
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN tblAccount.AccountName
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNoDESC') THEN InvoiceNo
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'InvoiceNoASC') THEN InvoiceNo
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AmountDESC') THEN Amount
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AmountASC') THEN Amount
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PaymentTypeDESC') THEN PaymentType
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PaymentTypeASC') THEN PaymentType
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PaymentDateDESC') THEN PaymentDate
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'PaymentDateASC') THEN PaymentDate
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusDESC') THEN tblPayment.Status
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'StatusASC') THEN tblPayment.Status
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByDESC') THEN tblPayment.CreatedBy
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CreatedByASC') THEN tblPayment.CreatedBy
                END ASC
            LIMIT p_RowspPage OFFSET v_OffSet_;

            SELECT
            COUNT(tblPayment.PaymentID) AS totalcount,CONCAT(IFNULL(v_CurrencyCode_,''),ROUND(sum(Amount),v_Round_)) as total_grand
            from tblPayment
           left join wavetelwholesaleRM.tblAccount ON tblPayment.AccountID = tblAccount.AccountID
            where tblPayment.CompanyID = p_CompanyID
            AND(p_RecallOnOff = -1 OR tblPayment.Recall = p_RecallOnOff)
            AND(p_accountID = 0 OR tblPayment.AccountID = p_accountID)
            AND((p_InvoiceNo IS NULL OR tblPayment.InvoiceNo like Concat('%',p_InvoiceNo,'%')))
            AND((p_Status IS NULL OR tblPayment.Status = p_Status))
            AND((p_PaymentType IS NULL OR tblPayment.PaymentType = p_PaymentType))
            AND((p_PaymentMethod IS NULL OR tblPayment.PaymentMethod = p_PaymentMethod))
			AND (p_paymentStartDate is null OR ( p_paymentStartDate != '' AND tblPayment.PaymentDate >= p_paymentStartDate))
			AND (p_paymentEndDate  is null OR ( p_paymentEndDate != '' AND tblPayment.PaymentDate <= p_paymentEndDate))
			AND (p_CurrencyID = 0 OR tblPayment.CurrencyId = p_CurrencyID);

	END IF;
	IF p_isExport = 1
    THEN

		SELECT 
            AccountName,
            CONCAT(IFNULL(v_CurrencyCode_,''),ROUND(tblPayment.Amount,v_Round_)) as Amount,
            CASE WHEN p_isCustomer = 1 THEN
              CASE WHEN PaymentType='Payment Out' THEN 'Payment In' ELSE 'Payment Out'
              END
            ELSE  PaymentType
            END as PaymentType,
            PaymentDate,
            tblPayment.Status,
            tblPayment.CreatedBy,
            InvoiceNo,
            tblPayment.PaymentMethod,
            Notes 
			from tblPayment
            left join wavetelwholesaleRM.tblAccount ON tblPayment.AccountID = tblAccount.AccountID
            where tblPayment.CompanyID = p_CompanyID
            AND(p_RecallOnOff = -1 OR tblPayment.Recall = p_RecallOnOff)
            AND(p_accountID = 0 OR tblPayment.AccountID = p_accountID)
            AND((p_InvoiceNo IS NULL OR tblPayment.InvoiceNo like Concat('%',p_InvoiceNo,'%')))
            AND((p_Status IS NULL OR tblPayment.Status = p_Status))
            AND((p_PaymentType IS NULL OR tblPayment.PaymentType = p_PaymentType))
            AND((p_PaymentMethod IS NULL OR tblPayment.PaymentMethod = p_PaymentMethod))
			AND (p_paymentStartDate is null OR ( p_paymentStartDate != '' AND tblPayment.PaymentDate >= p_paymentStartDate))
			AND (p_paymentEndDate  is null OR ( p_paymentEndDate != '' AND tblPayment.PaymentDate <= p_paymentEndDate))
			AND (p_CurrencyID = 0 OR tblPayment.CurrencyId = p_CurrencyID);
	END IF;
	
	
	IF p_isExport = 2
    THEN

		SELECT 
            AccountName,
            CONCAT(IFNULL(v_CurrencyCode_,''),ROUND(tblPayment.Amount,v_Round_)) as Amount,
            CASE WHEN p_isCustomer = 1 THEN
              CASE WHEN PaymentType='Payment Out' THEN 'Payment In' ELSE 'Payment Out'
              END
            ELSE  PaymentType
            END as PaymentType,
            PaymentDate,
            tblPayment.Status,
            InvoiceNo,
            tblPayment.PaymentMethod,
            Notes 
			from tblPayment
            left join wavetelwholesaleRM.tblAccount ON tblPayment.AccountID = tblAccount.AccountID
            
            where tblPayment.CompanyID = p_CompanyID
            AND(tblPayment.Recall = p_RecallOnOff)
            AND(p_accountID = 0 OR tblPayment.AccountID = p_accountID)
            AND((p_InvoiceNo IS NULL OR tblPayment.InvoiceNo = p_InvoiceNo))
            AND((p_Status IS NULL OR tblPayment.Status = p_Status))
            AND((p_PaymentType IS NULL OR tblPayment.PaymentType = p_PaymentType))
            AND((p_PaymentMethod IS NULL OR tblPayment.PaymentMethod = p_PaymentMethod))
            AND (p_paymentStartDate is null OR ( p_paymentStartDate != '' AND tblPayment.PaymentDate >= p_paymentStartDate))
			AND (p_paymentEndDate  is null OR ( p_paymentEndDate != '' AND tblPayment.PaymentDate <= p_paymentEndDate))
			AND (p_CurrencyID = 0 OR tblPayment.CurrencyId = p_CurrencyID);
	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getPincodesGrid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getPincodesGrid`(IN `p_CompanyID` INT, IN `p_Pincode` VARCHAR(50), IN `p_PinExt` VARCHAR(50), IN `p_StartDate` DATE, IN `p_EndDate` DATE, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(50), IN `p_isExport` INT)
    COMMENT 'Pincodes Grid For DashBorad'
BEGIN
	DECLARE v_OffSet_ int;
	DECLARE v_Round_ int;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	CALL fnUsageDetail(p_CompanyID,p_AccountID,0,p_StartDate,p_EndDate,0,1,1,'','','',0);
	
	
	IF p_isExport = 0
	THEN
		SELECT
      	cld as DestinationNumber,
         CONCAT(IFNULL(c.Symbol,''),ROUND(SUM(cost),v_Round_)) AS TotalCharges,
 			COUNT(UsageDetailID) AS NoOfCalls
		FROM tmp_tblUsageDetails_ uh
		INNER JOIN wavetelwholesaleRM.tblAccount a ON a.AccountID = uh.AccountID
		LEFT  JOIN wavetelwholesaleRM.tblCurrency c ON c.CurrencyId = a.CurrencyId
      WHERE ((p_PinExt = 'pincode' AND uh.pincode = p_Pincode ) OR (p_PinExt = 'extension' AND uh.extension = p_Pincode )) AND uh.cost>0 AND a.CurrencyId = p_CurrencyID
		GROUP BY uh.cld
		ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DestinationNumberDESC') THEN DestinationNumber
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DestinationNumberASC') THEN DestinationNumber
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NoOfCallsDESC') THEN COUNT(UsageDetailID) 
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NoOfCallsASC') THEN COUNT(UsageDetailID) 
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalChargesDESC') THEN SUM(cost)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalChargesASC') THEN SUM(cost)
                END ASC
		LIMIT p_RowspPage OFFSET v_OffSet_;
		
		SELECT COUNT(*) as totalcount FROM(SELECT
      	DISTINCT cld 
		FROM tmp_tblUsageDetails_ uh
		INNER JOIN wavetelwholesaleRM.tblAccount a on a.AccountID = uh.AccountID
      WHERE ((p_PinExt = 'pincode' AND uh.pincode = p_Pincode ) OR (p_PinExt = 'extension' AND uh.extension = p_Pincode )) AND uh.cost>0 AND a.CurrencyId = p_CurrencyID
		GROUP BY uh.cld) tbl;
		
	END IF;
	
	IF p_isExport = 1
	THEN
		SELECT
      	cld as `Destination Number`,
         CONCAT(IFNULL(c.Symbol,''),ROUND(SUM(cost),v_Round_)) AS `Total Cost`,
 			COUNT(UsageDetailID) AS `Number of Times Dialed`
		FROM tmp_tblUsageDetails_ uh
		INNER JOIN wavetelwholesaleRM.tblAccount a on a.AccountID = uh.AccountID
      WHERE ((p_PinExt = 'pincode' AND uh.pincode = p_Pincode ) OR (p_PinExt = 'extension' AND uh.extension = p_Pincode )) AND uh.cost>0 AND a.CurrencyId = p_CurrencyID
		GROUP BY uh.cld;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getProducts` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getProducts`(IN `p_CompanyID` INT, IN `p_Name` VARCHAR(50), IN `p_Code` VARCHAR(50), IN `p_Active` VARCHAR(1), IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_Export` INT)
BEGIN
     DECLARE v_OffSet_ int;
     SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	      
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;


	if p_Export = 0
	THEN

    SELECT   
			tblProduct.Name,
			tblProduct.Code,
			tblProduct.Amount,
			tblProduct.updated_at,
			tblProduct.Active,
			tblProduct.ProductID,
			tblProduct.Description,
			tblProduct.Note
            from tblProduct
            where tblProduct.CompanyID = p_CompanyID
			AND(p_Name ='' OR tblProduct.Name like Concat('%',p_Name,'%'))
            AND((p_Code ='' OR tblProduct.Code like CONCAT(p_Code,'%')))
            AND((p_Active = '' OR tblProduct.Active = p_Active))
         ORDER BY
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameDESC') THEN Name
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NameASC') THEN Name
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeDESC') THEN Code
                END DESC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CodeASC') THEN Code
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AmountDESC') THEN Amount
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AmountASC') THEN Amount
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atDESC') THEN tblProduct.updated_at
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'updated_atASC') THEN tblProduct.updated_at
                END ASC,
				CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ActiveDESC') THEN Active
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ActiveASC') THEN Active
                END ASC
            LIMIT p_RowspPage OFFSET v_OffSet_;

			SELECT
            COUNT(tblProduct.ProductID) AS totalcount
            from tblProduct
            where tblProduct.CompanyID = p_CompanyID
			AND(p_Name ='' OR tblProduct.Name like Concat('%',p_Name,'%'))
            AND((p_Code ='' OR tblProduct.Code like CONCAT(p_Code,'%')))
            AND((p_Active = '' OR tblProduct.Active = p_Active));

	ELSE

			SELECT
			tblProduct.Name,
			tblProduct.Code,
			tblProduct.Amount,
			tblProduct.updated_at,
			tblProduct.Active
            from tblProduct
			where tblProduct.CompanyID = p_CompanyID
			AND(p_Name ='' OR tblProduct.Name like Concat('%',p_Name,'%'))
            AND((p_Code ='' OR tblProduct.Code like CONCAT(p_Code,'%')))
            AND((p_Active = '' OR tblProduct.Active = p_Active));

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetRecurringInvoiceLog` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetRecurringInvoiceLog`(
	IN `p_CompanyID` INT,
	IN `p_RecurringInvoiceID` INT,
	IN `p_Status` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(50),
	IN `p_isExport` INT

)
BEGIN
	DECLARE v_OffSet_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;         
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
   IF p_isExport = 0
    THEN
      SELECT
          rinvlg.Note,
          rinvlg.RecurringInvoiceLogStatus,
          rinvlg.created_at,                
          inv.RecurringInvoiceID
          
      FROM tblRecurringInvoice inv
      INNER JOIN wavetelwholesaleRM.tblAccount ac
          ON ac.AccountID = inv.AccountID
      INNER JOIN tblRecurringInvoiceLog rinvlg
          ON rinvlg.RecurringInvoiceID = inv.RecurringInvoiceID
      WHERE ac.CompanyID = p_CompanyID
      AND (inv.RecurringInvoiceID = p_RecurringInvoiceID)
      AND (p_Status=0 OR rinvlg.RecurringInvoiceLogStatus=p_Status)
       ORDER BY
          CASE
              WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RecurringInvoiceLogStatusDESC') THEN rinvlg.RecurringInvoiceLogStatus
          END DESC,
          CASE
              WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RecurringInvoiceLogStatusASC') THEN rinvlg.RecurringInvoiceLogStatus
          END ASC,
          CASE
              WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atDESC') THEN rinvlg.created_at
          END DESC,
          CASE
              WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'created_atASC') THEN rinvlg.created_at
          END ASC
			LIMIT p_RowspPage OFFSET v_OffSet_;

     SELECT
         COUNT(*) AS totalcount
     FROM tblRecurringInvoice inv
      INNER JOIN wavetelwholesaleRM.tblAccount ac
          ON ac.AccountID = inv.AccountID
      INNER JOIN tblRecurringInvoiceLog rinvlg
          ON rinvlg.RecurringInvoiceID = inv.RecurringInvoiceID
      WHERE ac.CompanyID = p_CompanyID
      AND (inv.RecurringInvoiceID = p_RecurringInvoiceID)
      AND (p_Status=0 OR rinvlg.RecurringInvoiceLogStatus=p_Status);
    END IF;
    IF p_isExport = 1
    THEN
     SELECT
         rinvlg.Note,
         rinvlg.created_at,
         rinvlg.InvoiceLogStatus,
         inv.InvoiceNumber
     FROM tblRecurringInvoice inv
      INNER JOIN wavetelwholesaleRM.tblAccount ac
          ON ac.AccountID = inv.AccountID
      INNER JOIN tblRecurringInvoiceLog rinvlg
          ON rinvlg.RecurringInvoiceID = inv.RecurringInvoiceID
      WHERE ac.CompanyID = p_CompanyID
      AND (inv.RecurringInvoiceID = p_RecurringInvoiceID)
      AND (p_Status=0 OR rinvlg.RecurringInvoiceLogStatus=p_Status);
    END IF;
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getRecurringInvoices` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getRecurringInvoices`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_Status` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(50),
	IN `p_isExport` INT
)
BEGIN
	DECLARE v_OffSet_ INT;
	DECLARE v_Round_ INT;    
	SET sql_mode = 'ALLOW_INVALID_DATES';
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	     
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	IF p_isExport = 0
	THEN
	  SELECT
	  rinv.RecurringInvoiceID,
	  rinv.Title, 
	  ac.AccountName,
	  DATE(rinv.LastInvoicedDate),
	  DATE(rinv.NextInvoiceDate),
	  CONCAT(IFNULL(cr.Symbol,''),ROUND(rinv.GrandTotal,v_Round_)) AS GrandTotal2,		
	  rinv.`Status`,
	  rinv.Occurrence,
	  (SELECT COUNT(InvoiceID) FROM tblInvoice WHERE (InvoiceStatus!='awaiting' AND InvoiceStatus!='cancel' ) AND RecurringInvoiceID = rinv.RecurringInvoiceID) as Sent,
	  rinv.BillingCycleType,
	  rinv.BillingCycleValue,
	  rinv.AccountID,
	  ROUND(rinv.GrandTotal,v_Round_) AS GrandTotal
	  FROM tblRecurringInvoice rinv
	  INNER JOIN wavetelwholesaleRM.tblAccount ac ON ac.AccountID = rinv.AccountID
	  LEFT JOIN wavetelwholesaleRM.tblCurrency cr ON rinv.CurrencyID   = cr.CurrencyId 
	  WHERE ac.CompanyID = p_CompanyID
	  AND (p_AccountID = 0 OR rinv.AccountID = p_AccountID)
	  AND (p_Status =2 OR rinv.`Status` = p_Status)
	  ORDER BY
	  		CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleDESC') THEN rinv.Title
	      END DESC,
	          CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TitleASC') THEN rinv.Title
	      END ASC,
	   	CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN ac.AccountName
	      END DESC,
	          CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN ac.AccountName
	      END ASC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastInvoicedDateDESC') THEN rinv.LastInvoicedDate
	      END DESC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'LastInvoicedDateASC') THEN rinv.LastInvoicedDate
	      END ASC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NextInvoiceDateDESC') THEN rinv.NextInvoiceDate
	      END DESC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NextInvoiceDateASC') THEN rinv.NextInvoiceDate
	      END ASC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RecurringInvoiceStatusDESC') THEN rinv.`Status`
	      END DESC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'RecurringInvoiceStatusASC') THEN rinv.`Status`
	      END ASC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalDESC') THEN rinv.GrandTotal
	      END DESC,
	      CASE WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GrandTotalASC') THEN rinv.GrandTotal
	      END ASC
	  
	  LIMIT p_RowspPage OFFSET v_OffSet_;
	  
	  
	  SELECT
	      COUNT(*) AS totalcount,  ROUND(SUM(rinv.GrandTotal),v_Round_) AS total_gran 
	  FROM tblRecurringInvoice rinv
	  INNER JOIN wavetelwholesaleRM.tblAccount ac ON ac.AccountID = rinv.AccountID
	  LEFT JOIN wavetelwholesaleRM.tblCurrency cr ON rinv.CurrencyID   = cr.CurrencyId 
	  WHERE ac.CompanyID = p_CompanyID
	  AND (p_AccountID = 0 OR rinv.AccountID = p_AccountID)
	  AND (p_Status =2 OR rinv.`Status` = p_Status);
	END IF;
	IF p_isExport = 1
	THEN
	  SELECT 
	  ac.AccountName,
	  rinv.LastInvoiceNumber,
	  rinv.LastInvoicedDate,		
	  rinv.Description,		  
	  IFNULL(ac.BillingEmail,'') AS BillingEmail,
	  ROUND(rinv.GrandTotal,v_Round_) AS GrandTotal
	  FROM tblRecurringInvoice rinv
	  INNER JOIN wavetelwholesaleRM.tblAccount ac ON ac.AccountID = rinv.AccountID
	  LEFT JOIN wavetelwholesaleRM.tblCurrency cr ON rinv.CurrencyID   = cr.CurrencyId 
	  WHERE ac.CompanyID = p_CompanyID
	  AND (p_AccountID = 0 OR rinv.AccountID = p_AccountID)
	  AND (p_Status =2 OR rinv.`Status` = p_Status);
	END IF;
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getSOA` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getSOA`(
	IN `p_CompanyID` INT,
	IN `p_accountID` INT,
	IN `p_StartDate` datetime,
	IN `p_EndDate` datetime,
	IN `p_isExport` INT 







)
BEGIN
  
  
    	
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
	
	IF ( p_StartDate != '0000-00-00' ) THEN
	
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

	END IF;
     
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

	IF ( p_StartDate != '0000-00-00' ) THEN
	
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
        
     END IF;
     
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
      INNER JOIN wavetelwholesaleRM.tblAccount on tblAccount.AccountID = p_accountID
      INNER JOIN wavetelwholesaleRM.tblAccountBilling ab ON ab.AccountID = tblAccount.AccountID
      
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
      INNER JOIN wavetelwholesaleRM.tblAccount on tblAccount.AccountID = p_accountID
      INNER JOIN wavetelwholesaleRM.tblAccountBilling ab ON ab.AccountID = tblAccount.AccountID
      
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
    
	
	
	
	select sum(ifnull(Amount,0)) as InvoiceOutAmountTotal  into v_bf_InvoiceOutAmountTotal 
    from tmp_Invoices_broghtf where InvoiceType = 1 ;
    
    select sum(ifnull(Amount,0)) as PaymentInAmountTotal into v_bf_PaymentInAmountTotal
    from tmp_Payments_broghtf where PaymentType = 'Payment In' ; 
    
    select sum(ifnull(Amount,0)) as InvoiceInAmountTotal into v_bf_InvoiceInAmountTotal
    from tmp_Invoices_broghtf where InvoiceType = 2 ;
    
    select sum(ifnull(Amount,0)) as PaymentOutAmountTotal into v_bf_PaymentOutAmountTotal
    from tmp_Payments_broghtf where PaymentType = 'Payment Out' ; 

	SELECT (ifnull(v_bf_InvoiceOutAmountTotal,0) - ifnull(v_bf_PaymentInAmountTotal,0)) - ( ifnull(v_bf_InvoiceInAmountTotal,0) - ifnull(v_bf_PaymentOutAmountTotal,0)) as BroughtForwardOffset;
	
	


  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getSOA_24_02_2017` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getSOA_24_02_2017`(
	IN `p_CompanyID` INT,
	IN `p_accountID` INT,
	IN `p_StartDate` datetime,
	IN `p_EndDate` datetime,
	IN `p_isExport` INT 
)
BEGIN
  
  
    
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
      order by created_at
      ;
        
      
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
      INNER JOIN wavetelwholesaleRM.tblAccount on tblAccount.AccountID = p_accountID
      INNER JOIN wavetelwholesaleRM.tblAccountBilling ab ON ab.AccountID = tblAccount.AccountID
      
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
      INNER JOIN wavetelwholesaleRM.tblAccount on tblAccount.AccountID = p_accountID
      INNER JOIN wavetelwholesaleRM.tblAccountBilling ab ON ab.AccountID = tblAccount.AccountID
      
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

   order by InvoiceIn_IssueDate desc
   ;
     
     
    
    
    
    
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
    
     
  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getSOA_invoicenumber` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getSOA_invoicenumber`(IN `p_CompanyID` INT, IN `p_accountID` INT, IN `p_StartDate` datetime, IN `p_EndDate` datetime, IN `p_isExport` INT )
BEGIN
  
  
    
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
     SET SESSION sql_mode='';


   DROP TEMPORARY TABLE IF EXISTS tmp_Invoices;
    CREATE TEMPORARY TABLE tmp_Invoices (
        InvoiceNo VARCHAR(50),
        PeriodCover VARCHAR(50),
        IssueDate Datetime,
        Amount NUMERIC(18, 8),
        InvoiceType int,
        AccountID int
    );
    
    
    
    DROP TEMPORARY TABLE IF EXISTS tmp_Payments;
    CREATE TEMPORARY TABLE tmp_Payments (
        InvoiceNo VARCHAR(50),
        PaymentDate VARCHAR(50),
        IssueDate datetime,
        Amount NUMERIC(18, 8),
        PaymentID INT,
        PaymentType VARCHAR(50)
    );
    
    
    DROP TEMPORARY TABLE IF EXISTS tmp_Disputes;
    CREATE TEMPORARY TABLE tmp_Disputes (
        InvoiceNo VARCHAR(50),
        created_at datetime,
        DisputeAmount NUMERIC(18, 8),
        InvoiceType VARCHAR(50),
        DisputeID INT,
        AccountID INT

    );
  
  
  DROP TEMPORARY TABLE IF EXISTS tmp_InvoiceOutWithDisputes;
   CREATE TEMPORARY TABLE tmp_InvoiceOutWithDisputes (
        InvoiceOut_InvoiceNo VARCHAR(50),
        InvoiceOut_PeriodCover VARCHAR(50),
        InvoiceOut_IssueDate datetime,
        InvoiceOut_Amount NUMERIC(18, 8),
        InvoiceOut_DisputeAmount NUMERIC(18, 8),
        InvoiceOut_DisputeID INT,
       InvoiceOut_AccountID INT
    );
    
  DROP TEMPORARY TABLE IF EXISTS tmp_InvoiceInWithDisputes;
   CREATE TEMPORARY TABLE tmp_InvoiceInWithDisputes (
        InvoiceIn_InvoiceNo VARCHAR(50),
        InvoiceIn_PeriodCover VARCHAR(50),
        InvoiceIn_IssueDate datetime,
        InvoiceIn_Amount NUMERIC(18, 8),
        InvoiceIn_DisputeAmount NUMERIC(18, 8),
        InvoiceIn_DisputeID INT,
        InvoiceIn_AccountID INT
    );
  
  
    

     
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
        tblInvoice.AccountID
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
    
   
     
     INSERT into tmp_Payments
       SELECT
        DISTINCT
            tblPayment.InvoiceNo,
            DATE_FORMAT(tblPayment.PaymentDate, '%d/%m/%Y') AS PaymentDate,
            tblPayment.PaymentDate as IssueDate,
            tblPayment.Amount,
            tblPayment.PaymentID,
            tblPayment.PaymentType
        FROM tblPayment
        WHERE 
            tblPayment.CompanyID = p_CompanyID
      AND tblPayment.AccountID = p_accountID
      AND tblPayment.Status = 'Approved'
        AND tblPayment.Recall = 0
      AND (p_StartDate = '0000-00-00' OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(tblPayment.PaymentDate,'%Y-%m-%d') >= p_StartDate ) )
      AND (p_EndDate   = '0000-00-00' OR  (p_EndDate   != '0000-00-00' AND  DATE_FORMAT(tblPayment.PaymentDate,'%Y-%m-%d') <= p_EndDate ) )
    Order by tblPayment.PaymentDate desc;
    
        
     
     INSERT INTO tmp_Disputes
       SELECT
            InvoiceNo,
        created_at,
            DisputeAmount,
            InvoiceType,
            DisputeID,
            AccountID
      FROM tblDispute 
        WHERE 
            CompanyID = p_CompanyID
      AND AccountID = p_accountID
      AND Status = 0 
      AND (p_StartDate = '0000-00-00' OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(created_at,'%Y-%m-%d') >= p_StartDate ) )
      AND (p_EndDate   = '0000-00-00' OR  (p_EndDate   != '0000-00-00' AND  DATE_FORMAT(created_at,'%Y-%m-%d') <= p_EndDate ) )
      order by created_at
      ;
        
      
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
    AccountID as InvoiceOut_AccountID
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
       	   iv.AccountID
            
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
        ds.AccountID
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
      INNER JOIN wavetelwholesaleRM.tblAccount on tblAccount.AccountID = p_accountID
      INNER JOIN wavetelwholesaleRM.tblAccountBilling ab ON ab.AccountID = tblAccount.AccountID
      INNER JOIN tblInvoiceTemplate  on ab.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID
      LEFT JOIN tmp_Payments
      ON tmp_Payments.PaymentType = 'Payment In' AND  tmp_Payments.InvoiceNo != '' AND (tmp_InvoiceOutWithDisputes.InvoiceOut_InvoiceNo = tmp_Payments.InvoiceNo OR REPLACE(tmp_Payments.InvoiceNo,'-','') = concat( ltrim(rtrim(REPLACE(tblInvoiceTemplate.InvoiceNumberPrefix,'-',''))) , ltrim(rtrim(tmp_InvoiceOutWithDisputes.InvoiceOut_InvoiceNo)) ) )
      
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
      where PaymentType = 'Payment In' AND  tmp_Payments.InvoiceNo = ''
  
    ) tbl
    order by InvoiceOut_IssueDate desc;
     
    
    


    
    INSERT INTO tmp_InvoiceInWithDisputes
    SELECT 
    InvoiceNo as InvoiceIn_InvoiceNo,
    PeriodCover as InvoiceIn_PeriodCover,
    IssueDate as InvoiceIn_IssueDate,
    Amount as InvoiceIn_Amount,
    ifnull(DisputeAmount,0) as InvoiceIn_DisputeAmount,
    DisputeID as InvoiceIn_DisputeID,
    AccountID as InvoiceIn_AccountID
    FROM
     (  SELECT
        DISTINCT
            iv.InvoiceNo,
            iv.PeriodCover,
            iv.IssueDate,
            iv.Amount,
            ds.DisputeAmount,
            ds.DisputeID,
            iv.AccountID
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
            ds.AccountID
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
      INNER JOIN wavetelwholesaleRM.tblAccount on tblAccount.AccountID = p_accountID
      INNER JOIN wavetelwholesaleRM.tblAccountBilling ab ON ab.AccountID = tblAccount.AccountID
      INNER JOIN tblInvoiceTemplate  on ab.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID
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

   order by InvoiceIn_IssueDate desc
   ;
     
     
    
    
    
    
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
    
     
  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getSOA_OLD` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getSOA_OLD`(IN `p_CompanyID` INT, IN `p_accountID` INT, IN `p_StartDate` datetime, IN `p_EndDate` datetime, IN `p_isExport` INT )
BEGIN
	
		
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
     SET SESSION sql_mode='';


	 DROP TEMPORARY TABLE IF EXISTS tmp_Invoices;
    CREATE TEMPORARY TABLE tmp_Invoices (
        InvoiceNo VARCHAR(50),
        PeriodCover VARCHAR(50),
        Amount NUMERIC(18, 8),
        InvoiceType int
       
        
    );
    
    
    
    DROP TEMPORARY TABLE IF EXISTS tmp_Payments;
    CREATE TEMPORARY TABLE tmp_Payments (
        InvoiceNo VARCHAR(50),
        PeriodCover VARCHAR(50),
        Amount NUMERIC(18, 8),
        PaymentID INT,
        PaymentType VARCHAR(50)
    );
    
    
    DROP TEMPORARY TABLE IF EXISTS tmp_Disputes;
    CREATE TEMPORARY TABLE tmp_Disputes (
        InvoiceNo VARCHAR(50),
        created_at datetime,
        DisputeAmount NUMERIC(18, 8),
        InvoiceType VARCHAR(50),
        DisputeID INT

    );
    
    

     
    INSERT into tmp_Invoices
    SELECT
			DISTINCT 
         tblInvoice.InvoiceNumber,
         CASE
         	WHEN (tblInvoice.ItemInvoice = 1 ) THEN
                DATE_FORMAT(tblInvoice.IssueDate,'%d-%m-%Y')
				WHEN (tblInvoice.ItemInvoice IS NUll AND p_isExport = 0 ) THEN
					Concat(DATE_FORMAT(tblInvoiceDetail.StartDate,'%d/%m/%Y') ,'<br>' , DATE_FORMAT(tblInvoiceDetail.EndDate,'%d/%m/%Y'))
				WHEN (tblInvoice.ItemInvoice IS NUll AND p_isExport = 1) THEN
					(select Concat(DATE_FORMAT(tblInvoiceDetail.StartDate,'%d-%m-%Y') ,'-' , DATE_FORMAT(tblInvoiceDetail.EndDate,'%d-%m-%Y')) from tblInvoiceDetail where tblInvoiceDetail.InvoiceID= tblInvoice.InvoiceID order by InvoiceDetailID  limit 1)  
		
       END AS PeriodCover,
         tblInvoice.GrandTotal,
         tblInvoice.InvoiceType
        FROM tblInvoice
        LEFT JOIN tblInvoiceDetail         ON tblInvoice.InvoiceID = tblInvoiceDetail.InvoiceID 
        WHERE tblInvoice.CompanyID = p_CompanyID
        AND tblInvoice.AccountID = p_accountID
        AND ( (tblInvoice.InvoiceType = 2) OR ( tblInvoice.InvoiceType = 1 AND tblInvoice.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'awaiting') )  )
  		  AND (p_StartDate = '0000-00-00' OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(tblInvoice.IssueDate,'%Y-%m-%d') >= p_StartDate ) )
 		  AND (p_EndDate   = '0000-00-00' OR  (p_EndDate   != '0000-00-00' AND  DATE_FORMAT(tblInvoice.IssueDate,'%Y-%m-%d') <= p_EndDate ) )
		  Order by tblInvoice.IssueDate desc
		;
		
	 
     
     INSERT into tmp_Payments
	     SELECT
				DISTINCT
            tblPayment.InvoiceNo,
            DATE_FORMAT(tblPayment.PaymentDate, '%d-%m-%Y') AS PaymentDate,
            tblPayment.Amount,
            tblPayment.PaymentID,
            tblPayment.PaymentType
        FROM tblPayment
        WHERE 
  		      tblPayment.CompanyID = p_CompanyID
		  AND tblPayment.AccountID = p_accountID
		  AND tblPayment.Status = 'Approved'
        AND tblPayment.Recall = 0
		  AND (p_StartDate = '0000-00-00' OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(tblPayment.PaymentDate,'%Y-%m-%d') >= p_StartDate ) )
 		  AND (p_EndDate   = '0000-00-00' OR  (p_EndDate   != '0000-00-00' AND  DATE_FORMAT(tblPayment.PaymentDate,'%Y-%m-%d') <= p_EndDate ) )
		Order by tblPayment.PaymentDate desc;
    
    	  
     
     INSERT INTO tmp_Disputes
    	 SELECT
            InvoiceNo,
				created_at,
            DisputeAmount,
            InvoiceType,
            DisputeID
		  FROM tblDispute 
        WHERE 
  		      CompanyID = p_CompanyID
		  AND AccountID = p_accountID
		  AND Status = 0 
		  AND (p_StartDate = '0000-00-00' OR  (p_StartDate != '0000-00-00' AND  DATE_FORMAT(created_at,'%Y-%m-%d') >= p_StartDate ) )
 		  AND (p_EndDate   = '0000-00-00' OR  (p_EndDate   != '0000-00-00' AND  DATE_FORMAT(created_at,'%Y-%m-%d') <= p_EndDate ) )
			order by created_at
			;
      	
    	
		 CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Invoices_dup AS (SELECT * FROM tmp_Invoices);
		 CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Disputes_dup AS (SELECT * FROM tmp_Disputes);
		     			
     
     	SELECT  
		InvoiceNo as InvoiceOut_InvoiceNo,
		PeriodCover as InvoiceOut_PeriodCover,
		Amount as InvoiceOut_Amount,
		ifnull(DisputeAmount,0) as InvoiceOut_DisputeAmount,
		DisputeID as InvoiceOut_DisputeID
		FROM
	   (
     SELECT
				DISTINCT
            iv.InvoiceNo,
            iv.PeriodCover,
            iv.Amount,
            ds.DisputeAmount,
            ds.DisputeID
            
        FROM tmp_Invoices iv
		  LEFT JOIN tmp_Disputes ds on ds.InvoiceNo = iv.InvoiceNo AND ds.InvoiceType = iv.InvoiceType  AND ds.InvoiceNo is not null
        WHERE 
        iv.InvoiceType = 1          
       
		
		 UNION ALL
		
		 SELECT
				DISTINCT
            ds.InvoiceNo,
            DATE_FORMAT(ds.created_at, '%d-%m-%Y') as PeriodCover,
            0 as Amount,
            ds.DisputeAmount,
            ds.DisputeID
		  FROM tmp_Disputes_dup ds 
		  LEFT JOIN  tmp_Invoices_dup iv on ds.InvoiceNo = iv.InvoiceNo and iv.InvoiceType = ds.InvoiceType 
        WHERE 
        ds.InvoiceType = 1  
        AND iv.InvoiceNo is null
        
	 
		) tbl  ;
	 	
		
		
		select 
		 InvoiceNo as PaymentIn_InvoiceNo,
        PeriodCover as PaymentIn_PeriodCover,
        Amount as PaymentIn_Amount,
        PaymentID as PaymentIn_PaymentID
		 from tmp_Payments 
		where PaymentType = 'Payment In'  ;
		
		
		
		SELECT 
		InvoiceNo as InvoiceIn_InvoiceNo,
		PeriodCover as InvoiceIn_PeriodCover,
		Amount as InvoiceIn_Amount,
		ifnull(DisputeAmount,0) as InvoiceIn_DisputeAmount,
		DisputeID as InvoiceIn_DisputeID
		FROM
	   (  SELECT
				DISTINCT
            iv.InvoiceNo,
            iv.PeriodCover,
            iv.Amount,
            ds.DisputeAmount,
            ds.DisputeID
        FROM tmp_Invoices iv
		  LEFT JOIN tmp_Disputes ds  on  ds.InvoiceNo = iv.InvoiceNo   AND ds.InvoiceType = iv.InvoiceType AND ds.InvoiceNo is not null
        WHERE 
        iv.InvoiceType = 2          
        
		
		 UNION ALL
		
		 SELECT
				DISTINCT
            ds.InvoiceNo,
            DATE_FORMAT(ds.created_at, '%d-%m-%Y') as PeriodCover,
            0 as Amount,
            ds.DisputeAmount,
            ds.DisputeID
		  From tmp_Disputes_dup ds 
        LEFT JOIN tmp_Invoices_dup iv on ds.InvoiceNo = iv.InvoiceNo AND iv.InvoiceType = ds.InvoiceType 
        WHERE  ds.InvoiceType = 2  
        AND iv.InvoiceNo is null
        
		)tbl;
    	
      
		select 
		  InvoiceNo as PaymentOut_InvoiceNo,
        PeriodCover as PaymentOut_PeriodCover,
        Amount as PaymentOut_Amount,
        PaymentID as PaymentOut_PaymentID
		   from tmp_Payments 
		where PaymentType = 'Payment Out' ;
		 
   	
   	
   	
   	
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
   	
     
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getSOA_OLD_OLD` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getSOA_OLD_OLD`(IN `p_CompanyID` INT, IN `p_accountID` INT, IN `p_StartDate` datetime, IN `p_EndDate` datetime, IN `p_isExport` INT )
BEGIN
	
		
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET SESSION sql_mode='ONLY_FULL_GROUP_BY,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

    DROP TEMPORARY TABLE IF EXISTS tmp_AOS_;
    CREATE TEMPORARY TABLE tmp_AOS_ (
        AccountName VARCHAR(50),
        InvoiceNo VARCHAR(50),
        PaymentType VARCHAR(15),
        PaymentDate LONGTEXT,
        PaymentMethod VARCHAR(20),
        Amount NUMERIC(18, 8),
		  DisputeAmount NUMERIC(18, 8),
        Currency VARCHAR(15),
        PeriodCover VARCHAR(30),
		  StartDate datetime,
  		  EndDate datetime,
        Type VARCHAR(10),
        InvoiceAmount NUMERIC(18, 8),
        CreatedDate VARCHAR(15),
        PaymentsID INT
    );
 
    INSERT INTO tmp_AOS_
        SELECT
						DISTINCT 
            tblAccount.AccountName,
            tblInvoice.InvoiceNumber,
            tblPayment.PaymentType,
            CASE
            WHEN p_isExport = 1
            THEN
                DATE_FORMAT(tblPayment.PaymentDate,'%d/%m/%Y')
            ELSE
                DATE_FORMAT(tblPayment.PaymentDate, '%d/%m/%Y')
            END AS dates,
            tblPayment.PaymentMethod,
            tblPayment.Amount,
            tblDispute.DisputeAmount,
            tblPayment.CurrencyID,
            CASE
            	WHEN (tblInvoice.ItemInvoice = 1 AND p_isExport = 1) THEN
	                DATE_FORMAT(tblInvoice.IssueDate,'%d/%m/%Y')
	            WHEN (tblInvoice.ItemInvoice = 1 AND p_isExport = 0) THEN
	            	 DATE_FORMAT(tblInvoice.IssueDate,'%d-%m-%Y')
					WHEN (tblInvoice.ItemInvoice IS NUll AND p_isExport = 1) THEN
	            	Concat(DATE_FORMAT(tblInvoiceDetail.StartDate,'%d/%m/%Y') ,' - ' , DATE_FORMAT(tblInvoiceDetail.EndDate,'%d/%m/%Y'))
	            WHEN (tblInvoice.ItemInvoice IS NUll AND p_isExport = 0) THEN
	            	 Concat(DATE_FORMAT(tblInvoiceDetail.StartDate,'%d-%m-%Y') , ' => ' , DATE_FORMAT(tblInvoiceDetail.EndDate,'%d-%m-%Y'))
            END AS dates,
			tblInvoiceDetail.StartDate,
			tblInvoiceDetail.EndDate,
            tblInvoice.InvoiceType,
            tblInvoice.GrandTotal,
            tblInvoice.created_at,
            tblPayment.PaymentID
        FROM tblInvoice
        LEFT JOIN tblInvoiceDetail
            ON tblInvoice.InvoiceID = tblInvoiceDetail.InvoiceID AND ( (tblInvoice.InvoiceType = 1 AND tblInvoiceDetail.ProductType = 2 ) OR  tblInvoice.InvoiceType =2 )
        INNER JOIN wavetelwholesaleRM.tblAccount
            ON tblInvoice.AccountID = tblAccount.AccountID
		  LEFT JOIN tblDispute on tblDispute.CompanyID = tblInvoice.CompanyID  and tblDispute.InvoiceNo = tblInvoice.InvoiceNumber 
        LEFT JOIN tblInvoiceTemplate  on tblAccount.InvoiceTemplateID = tblInvoiceTemplate.InvoiceTemplateID
        LEFT JOIN tblPayment
            ON (tblInvoice.InvoiceNumber = tblPayment.InvoiceNo OR REPLACE(tblPayment.InvoiceNo,'-','') = concat( ltrim(rtrim(REPLACE(tblInvoiceTemplate.InvoiceNumberPrefix,'-',''))) , ltrim(rtrim(tblInvoice.InvoiceNumber)) ) )
            AND tblPayment.Status = 'Approved' 
            AND tblPayment.Recall = 0
        WHERE tblInvoice.CompanyID = p_CompanyID
        AND ( (IFNULL(tblInvoice.InvoiceStatus,'') = '') OR  tblInvoice.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'awaiting'))
        AND (p_accountID = 0
        OR tblInvoice.AccountID = p_accountID)
		AND 
		(
			(p_StartDate = '0000-00-00 00:00:00' OR  p_EndDate = '0000-00-00 00:00:00') OR ((p_StartDate != '0000-00-00 00:00:00' AND p_EndDate != '0000-00-00 00:00:00') AND str_to_date(tblInvoice.IssueDate,'%Y-%m-%d') between  str_to_date(p_StartDate,'%Y-%m-%d') and str_to_date(p_EndDate,'%Y-%m-%d') )
		)
        
			
        UNION ALL
        SELECT
						DISTINCT
            tblAccount.AccountName,
            tblPayment.InvoiceNo,
            tblPayment.PaymentType,
            CASE
            WHEN p_isExport = 1
            THEN
               DATE_FORMAT(tblPayment.PaymentDate, '%d/%m/%Y')
            ELSE
               DATE_FORMAT(tblPayment.PaymentDate, '%d/%m/%Y')
            END AS dates,
            tblPayment.PaymentMethod,
            tblPayment.Amount,
            '' as DisputeAmount,
            tblPayment.CurrencyID,
            '' AS dates,
			tblPayment.PaymentDate,
			tblPayment.PaymentDate,
            CASE
			WHEN tblPayment.PaymentType = 'Payment In'
            THEN
                1
            ELSE
                2
            END AS InvoiceType,
            0 AS GrandTotal,
            tblPayment.created_at,
            tblPayment.PaymentID
        FROM tblPayment
        INNER JOIN wavetelwholesaleRM.tblAccount
            ON tblPayment.AccountID = tblAccount.AccountID
        WHERE tblPayment.Status = 'Approved'
        AND tblPayment.Recall = 0
        AND tblPayment.AccountID = p_accountID
        AND tblPayment.CompanyID = p_CompanyID
        AND tblPayment.InvoiceNo = ''
		AND 
		(
			(p_StartDate = '0000-00-00 00:00:00' OR  p_EndDate = '0000-00-00 00:00:00') OR ((p_StartDate != '0000-00-00 00:00:00' AND p_EndDate != '0000-00-00 00:00:00') AND str_to_date(tblPayment.PaymentDate,'%Y-%m-%d') between  str_to_date(p_StartDate,'%Y-%m-%d') and str_to_date(p_EndDate,'%Y-%m-%d') )
		);


    SELECT
				 
        IFNULL(InvoiceNo,'') as InvoiceNo,
        PeriodCover,
        InvoiceAmount,
        ' ' AS spacer,
        
      
      
       
		
		
		
	     PaymentDate,
        Amount AS payment,
        NULL AS ballence,
        CASE
        WHEN p_isExport = 0
        THEN
            PaymentsID
			END PaymentID 
    FROM tmp_AOS_
    WHERE Type = 1
    
    ORDER BY StartDate desc;

    SELECT
				 
        IFNULL(InvoiceNo,'') as InvoiceNo,
        PeriodCover,
        InvoiceAmount,
        DisputeAmount,
        ' ' AS spacer,
        PaymentDate,
        Amount AS payment,
        NULL AS ballence,
        CASE
        WHEN p_isExport = 0
        THEN
            PaymentsID
        END PaymentID
    FROM tmp_AOS_
    WHERE Type = 2
    ORDER BY StartDate desc;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getSummaryReportByCountry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getSummaryReportByCountry`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_Country` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN
    
    DECLARE v_BillingTime_ INT; 
    DECLARE v_OffSet_ int;
    
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	 SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	SELECT fnGetBillingTime(p_GatewayID,p_AccountID) INTO v_BillingTime_;
	
	CALL fnUsageDetail(p_CompanyID,p_AccountID,p_GatewayID,p_StartDate,p_EndDate,p_UserID,p_isAdmin,v_BillingTime_,'','','',0); 
  
    IF p_isExport = 0
    THEN
            SELECT
                MAX(uh.AccountName) AS AccountName,
                MAX(c.Country) AS Country,
                COUNT(UsageDetailID) AS NoOfCalls,
				Concat( Format(SUM(duration ) / 60,0), ':' , SUM(duration ) % 60) AS Duration,
		    	Concat( Format(SUM(billed_duration ) / 60,0),':' , SUM(billed_duration ) % 60) AS BillDuration,
               CONCAT(IFNULL(cc.Symbol,''),SUM(cost)) AS TotalCharges
            FROM tmp_tblUsageDetails_ uh
            LEFT JOIN wavetelwholesaleRM.tblRate r
                ON r.Code = uh.area_prefix 
			LEFT JOIN wavetelwholesaleRM.tblCountry c
                ON r.CountryID = c.CountryID
         INNER JOIN wavetelwholesaleRM.tblAccount a
         	ON a.AccountID = uh.AccountID
         LEFT JOIN wavetelwholesaleRM.tblCurrency cc
         	ON cc.CurrencyId = a.CurrencyId          	
            WHERE (p_Country = '' OR c.CountryID = p_Country)
            group by 
            c.Country,uh.AccountID
				ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN MAX(uh.AccountName)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN MAX(uh.AccountName)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryDESC') THEN MAX(c.Country)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryASC') THEN MAX(c.Country)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NoOfCallsDESC') THEN COUNT(UsageDetailID)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NoOfCallsASC') THEN COUNT(UsageDetailID)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalDurationDESC') THEN SUM(billed_duration)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalDurationASC') THEN SUM(billed_duration)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalChargesDESC') THEN SUM(cost)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalChargesASC') THEN SUM(cost)
                END ASC

        LIMIT p_RowspPage OFFSET v_OffSet_;


        SELECT count(*) as totalcount from (SELECT DISTINCT uh.AccountID ,c.Country 
        FROM tmp_tblUsageDetails_ uh
            LEFT JOIN wavetelwholesaleRM.tblRate r
                ON r.Code = uh.area_prefix 
			LEFT JOIN wavetelwholesaleRM.tblCountry c
                ON r.CountryID = c.CountryID
            WHERE (p_Country = '' OR c.CountryID = p_Country)
        ) As TBL;

    END IF;
    IF p_isExport = 1
    THEN
        
            SELECT
                MAX(AccountName) AS AccountName,
                MAX(c.Country) AS Country,
                COUNT(UsageDetailID) AS NoOfCalls,
				Concat( Format(SUM(duration ) / 60,0), ':' , SUM(duration ) % 60) AS Duration,
		    	Concat( Format(SUM(billed_duration ) / 60,0),':' , SUM(billed_duration ) % 60) AS BillDuration,
                SUM(cost) AS TotalCharges
            FROM tmp_tblUsageDetails_ uh
            LEFT JOIN wavetelwholesaleRM.tblRate r
                ON r.Code = uh.area_prefix 
			LEFT JOIN wavetelwholesaleRM.tblCountry c
                ON r.CountryID = c.CountryID
            WHERE (p_Country = '' OR c.CountryID = p_Country)
            group by 
            c.Country,uh.AccountID;
            

    END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getSummaryReportByCustomer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getSummaryReportByCustomer`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT


)
BEGIN
     
    DECLARE v_BillingTime_ INT; 
    DECLARE v_OffSet_ int;
    
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

 	 SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;

	SELECT fnGetBillingTime(p_GatewayID,p_AccountID) INTO v_BillingTime_;

  CALL fnUsageDetail(p_CompanyID,p_AccountID,p_GatewayID,p_StartDate,p_EndDate,p_UserID,p_isAdmin,v_BillingTime_,'','','',0); 

    IF p_isExport = 0
    THEN
            SELECT
                MAX(uh.AccountName) as AccountName,
                count(UsageDetailID) AS NoOfCalls,
				Concat( Format(SUM(duration ) / 60,0), ':' , SUM(duration ) % 60) AS Duration,
		    	Concat( Format(SUM(billed_duration ) / 60,0),':' , SUM(billed_duration ) % 60) AS BillDuration,
                CONCAT(IFNULL(cc.Symbol,''),SUM(cost)) AS TotalCharges
            FROM tmp_tblUsageDetails_ uh
            INNER JOIN wavetelwholesaleRM.tblAccount a
         	ON a.AccountID = uh.AccountID
         LEFT JOIN wavetelwholesaleRM.tblCurrency cc
         	ON cc.CurrencyId = a.CurrencyId
            group by 
            uh.AccountID
            ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN MAX(uh.AccountName)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN MAX(uh.AccountName)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NoOfCallsDESC') THEN count(UsageDetailID)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NoOfCallsASC') THEN count(UsageDetailID)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalDurationDESC') THEN SUM(billed_duration)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalDurationASC') THEN SUM(billed_duration)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalChargesDESC') THEN SUM(cost)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalChargesASC') THEN SUM(cost)
                END ASC
            
        LIMIT p_RowspPage OFFSET v_OffSet_;


        SELECT count(*) as totalcount from (SELECT DISTINCT AccountID  
        FROM tmp_tblUsageDetails_
        ) As TBL;
             

    END IF;
    IF p_isExport = 1
    THEN
        
            SELECT
                MAX(AccountName) as AccountName,
                count(UsageDetailID) AS NoOfCalls,
                Concat( Format(SUM(duration ) / 60,0), ':' , SUM(duration ) % 60) AS Duration,
		    	Concat( Format(SUM(billed_duration ) / 60,0),':' , SUM(billed_duration ) % 60) AS BillDuration,	
                SUM(cost) AS TotalCharges

            FROM tmp_tblUsageDetails_
            group by 
            AccountID;

    END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getSummaryReportByPrefix` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getSummaryReportByPrefix`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_GatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_Prefix` VARCHAR(50),
	IN `p_Country` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN
     
    DECLARE v_BillingTime_ INT; 
    DECLARE v_OffSet_ int;
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

 	 SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
     

	SELECT fnGetBillingTime(p_GatewayID,p_AccountID) INTO v_BillingTime_;
	
  CALL fnUsageDetail(p_CompanyID,p_AccountID,p_GatewayID,p_StartDate,p_EndDate,p_UserID,p_isAdmin,v_BillingTime_,'','','',0); 

    IF p_isExport = 0
    THEN
         
            SELECT
                MAX(uh.AccountName) AS AccountName,
                area_prefix as AreaPrefix,
                MAX(c.Country) AS Country,
                MAX(r.Description) AS Description,
                count(UsageDetailID) AS NoOfCalls,
				Concat( Format(SUM(duration ) / 60,0), ':' , SUM(duration ) % 60) AS Duration,
		    	Concat( Format(SUM(billed_duration ) / 60,0),':' , SUM(billed_duration ) % 60) AS BillDuration,
                CONCAT(IFNULL(cc.Symbol,''),SUM(cost)) AS TotalCharges
                
            FROM tmp_tblUsageDetails_ uh
            LEFT JOIN wavetelwholesaleRM.tblRate r
                ON r.Code = uh.area_prefix 
            LEFT JOIN wavetelwholesaleRM.tblCountry c
                ON r.CountryID = c.CountryID
            INNER JOIN wavetelwholesaleRM.tblAccount a
         		ON a.AccountID = uh.AccountID
         	LEFT JOIN wavetelwholesaleRM.tblCurrency cc
	         	ON cc.CurrencyId = a.CurrencyId
            WHERE 
			(p_Prefix='' OR uh.area_prefix like REPLACE(p_Prefix, '*', '%'))
			AND (p_Country=0 OR r.CountryID=p_Country)
			GROUP BY uh.area_prefix,
                     uh.AccountID
                     ORDER BY
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN MAX(uh.AccountName)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN MAX(uh.AccountName)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AreaPrefixDESC') THEN area_prefix
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AreaPrefixASC') THEN area_prefix
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryDESC') THEN MAX(c.Country)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryASC') THEN MAX(c.Country)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionDESC') THEN MAX(r.Description)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'DescriptionASC') THEN MAX(r.Description)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NoOfCallsDESC') THEN COUNT(UsageDetailID)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'NoOfCallsASC') THEN COUNT(UsageDetailID)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalDurationDESC') THEN SUM(billed_duration)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalDurationASC') THEN SUM(billed_duration)
                END ASC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalChargesDESC') THEN SUM(cost)
                END DESC,
                CASE
                    WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalChargesASC') THEN SUM(cost)
                END ASC
        LIMIT p_RowspPage OFFSET v_OffSet_;


        SELECT
            COUNT(*) AS totalcount
        FROM (
            SELECT DISTINCT
                area_prefix as AreaPrefix,
                uh.AccountID
            FROM tmp_tblUsageDetails_ uh
            LEFT JOIN wavetelwholesaleRM.tblRate r
                ON r.Code = uh.area_prefix 
            LEFT JOIN wavetelwholesaleRM.tblCountry c
                ON r.CountryID = c.CountryID
            WHERE 
			(p_Prefix='' OR uh.area_prefix like REPLACE(p_Prefix, '*', '%'))
			AND (p_Country=0 OR r.CountryID=p_Country)
        ) AS TBL;


    END IF;
    IF p_isExport = 1
    THEN

        SELECT
            MAX(AccountName) AS AccountName,
            area_prefix as AreaPrefix,
            MAX(c.Country) AS Country,
            MAX(r.Description) AS Description,
            COUNT(UsageDetailID) AS NoOfCalls,
  			Concat( Format(SUM(duration ) / 60,0), ':' , SUM(duration ) % 60) AS Duration,
		    Concat( Format(SUM(billed_duration ) / 60,0),':' , SUM(billed_duration ) % 60) AS BillDuration,
            SUM(cost) AS TotalCharges
        FROM tmp_tblUsageDetails_ uh
		
		LEFT JOIN wavetelwholesaleRM.tblRate r
                ON r.Code = uh.area_prefix 
        LEFT JOIN wavetelwholesaleRM.tblCountry c
                ON r.CountryID = c.CountryID
        WHERE 
			(p_Prefix='' OR uh.area_prefix like REPLACE(p_Prefix, '*', '%'))
			AND (p_Country=0 OR r.CountryID=p_Country)
        GROUP BY uh.area_prefix,
                 uh.AccountID;

    END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetTransactionsLogbyInterval` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetTransactionsLogbyInterval`(IN `p_CompanyID` int, IN `p_Interval` varchar(50) )
BEGIN
   
   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
 
        SELECT
			ac.AccountName,
			inv.InvoiceNumber,
            tl.Transaction,
            tl.Notes,
            tl.created_at,
            tl.Amount,
            Case WHEN tl.Status = 1 then 'Success' ELSE 'Failed'  
			END as Status
		FROM   tblTransactionLog tl
		INNER JOIN tblInvoice inv
            ON tl.CompanyID = inv.CompanyID 
            AND tl.InvoiceID = inv.InvoiceID
        INNER JOIN wavetelwholesaleRM.tblAccount ac
            ON ac.AccountID = inv.AccountID
        
        WHERE ac.CompanyID = p_CompanyID 
        AND (
			( p_Interval = 'Daily' AND tl.created_at >= DATE_FORMAT(DATE_ADD(NOW(),INTERVAL -1 DAY),'%Y-%m-%d') )
			OR
			( p_Interval = 'Weekly' AND tl.created_at >= DATE_FORMAT(DATE_ADD(NOW(),INTERVAL -1 WEEK),'%Y-%m-%d') )
			OR
			( p_Interval = 'Monthly' AND tl.created_at >= DATE_FORMAT(DATE_ADD(NOW(),INTERVAL -1 MONTH),'%Y-%m-%d') )
		);
		
		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_GetVendorCDR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_GetVendorCDR`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_start_date` DATETIME,
	IN `p_end_date` DATETIME,
	IN `p_AccountID` INT,
	IN `p_CLI` VARCHAR(50),
	IN `p_CLD` VARCHAR(50),
	IN `p_ZeroValueBuyingCost` INT,
	IN `p_CurrencyID` INT,
	IN `p_area_prefix` VARCHAR(50),
	IN `p_trunk` VARCHAR(50),
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_lSortCol` VARCHAR(50),
	IN `p_SortOrder` VARCHAR(5),
	IN `p_isExport` INT
)
BEGIN 

	DECLARE v_OffSet_ int;
	DECLARE v_BillingTime_ int;
	DECLARE v_Round_ INT;
	DECLARE v_CurrencyCode_ VARCHAR(50);
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	SELECT cr.Symbol INTO v_CurrencyCode_ from wavetelwholesaleRM.tblCurrency cr where cr.CurrencyId =p_CurrencyID;
	
	SELECT fnGetBillingTime(p_CompanyGatewayID,p_AccountID) INTO v_BillingTime_;

	Call fnVendorUsageDetail(p_CompanyID,p_AccountID,p_CompanyGatewayID,p_start_date,p_end_date,0,1,v_BillingTime_,p_CLI,p_CLD,p_ZeroValueBuyingCost);

	IF p_isExport = 0
	THEN 
	
		SELECT
			uh.VendorCDRID,	
			uh.AccountName as AccountName,
			uh.connect_time,
			uh.disconnect_time,
			uh.billed_duration,
			CONCAT(IFNULL(v_CurrencyCode_,''),uh.buying_cost) AS buying_cost,
			uh.cli,
			uh.cld,
			uh.area_prefix,
			uh.trunk,
			uh.AccountID,
			p_CompanyGatewayID as CompanyGatewayID,
			p_start_date as StartDate,
			p_end_date as EndDate  
		FROM tmp_tblVendorUsageDetails_ uh
		INNER JOIN wavetelwholesaleRM.tblAccount a
			ON uh.AccountID = a.AccountID
		WHERE 	(p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
			AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
			AND (p_trunk = '' OR trunk = p_trunk )
		LIMIT p_RowspPage OFFSET v_OffSet_;
	 
		SELECT
			COUNT(*) AS totalcount,
			fnFormateDuration(SUM(uh.billed_duration)) as total_billed_duration,
			SUM(uh.buying_cost) as total_cost,
			v_CurrencyCode_ as CurrencyCode
		FROM tmp_tblVendorUsageDetails_ uh
		INNER JOIN wavetelwholesaleRM.tblAccount a
			ON uh.AccountID = a.AccountID
		WHERE  (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
			AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
			AND (p_trunk = '' OR trunk = p_trunk );
	END IF;
	
	IF p_isExport = 1
	THEN
	
		SELECT
			uh.AccountName,        
			uh.connect_time,
			uh.disconnect_time,        
			uh.billed_duration,
			CONCAT(IFNULL(v_CurrencyCode_,''),uh.buying_cost) AS Cost,
			uh.cli,
			uh.cld,
			uh.area_prefix,
			uh.trunk
		FROM tmp_tblVendorUsageDetails_ uh
		INNER JOIN wavetelwholesaleRM.tblAccount a
			ON uh.AccountID = a.AccountID
		WHERE  (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
			AND (p_area_prefix = '' OR area_prefix LIKE REPLACE(p_area_prefix, '*', '%'))
			AND (p_trunk = '' OR trunk = p_trunk );
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_insertDailyData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_insertDailyData`(IN `p_ProcessID` VarCHAR(200), IN `p_Offset` INT)
BEGIN
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
 
	DROP TEMPORARY TABLE IF EXISTS tmp_DetailSummery_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_DetailSummery_(
			CompanyID int,
			CompanyGatewayID int,
			AccountID int,
			trunk varchar(50),			
			area_prefix varchar(50),			
			pincode varchar(50),
			extension VARCHAR(50),
			TotalCharges float,
			TotalDuration int,
			TotalBilledDuration int,
			NoOfCalls int,
			DailyDate datetime
	);
   
    CALL fnUsageDetailbyProcessID(p_ProcessID); 
    
   INSERT INTO tmp_DetailSummery_
	SELECT
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.AccountID,
		ud.trunk,
		ud.area_prefix,
		ud.pincode,
		ud.extension,
		SUM(ud.cost) AS TotalCharges,
		SUM(duration) AS TotalDuration,
		SUM(billed_duration) AS TotalBilledDuration,
		COUNT(cld) AS NoOfCalls,
		DATE_FORMAT(connect_time, '%Y-%m-%d') AS DailyDate
	from (select CompanyID,
		CompanyGatewayID,
		AccountID,
		trunk,
		area_prefix,
		pincode,
		extension,
		cost,
		duration,
		billed_duration,
		cld,
		DATE_ADD(connect_time,INTERVAL p_Offset SECOND) as connect_time
		FROM tmp_tblUsageDetailsProcess_)
		ud
	GROUP BY ud.trunk,
				area_prefix,
				pincode,
				extension,
				DATE_FORMAT(connect_time, '%Y-%m-%d'),
				ud.AccountID,
				ud.CompanyID,
				ud.CompanyGatewayID;
	INSERT INTO tblUsageDaily (CompanyID,CompanyGatewayID,AccountID,Trunk,AreaPrefix,Pincode,Extension,TotalCharges,TotalDuration,TotalBilledDuration,NoOfCalls,DailyDate) 
		SELECT ds.*
		FROM tmp_DetailSummery_ ds LEFT JOIN 
		tblUsageDaily dd  ON 
		dd.CompanyID = ds.CompanyID 
		AND dd.AccountID = ds.AccountID
		AND dd.CompanyGatewayID = ds.CompanyGatewayID
		AND dd.Trunk = ds.trunk
		AND dd.AreaPrefix = ds.area_prefix
		AND dd.DailyDate = ds.DailyDate
		WHERE dd.UsageDailyID IS NULL;

	UPDATE tblUsageDaily  dd
 INNER JOIN 
	tmp_DetailSummery_ ds 
	ON 
	dd.CompanyID = ds.CompanyID 
	AND dd.AccountID = ds.AccountID
	AND dd.CompanyGatewayID = ds.CompanyGatewayID
	AND dd.Trunk = ds.trunk
	AND dd.AreaPrefix = ds.area_prefix
	AND (dd.Pincode = ds.pincode OR (dd.Pincode IS NULL AND ds.pincode IS NULL))
   AND (dd.Extension = ds.extension OR (dd.Extension IS NULL AND ds.extension IS NULL))
	AND dd.DailyDate = ds.DailyDate
SET dd.TotalCharges =  dd.TotalCharges + ds.TotalCharges,
	dd.TotalDuration = dd.TotalDuration + ds.TotalDuration,
	dd.TotalBilledDuration = dd.TotalBilledDuration +  ds.TotalBilledDuration,
	dd.NoOfCalls = dd.NoOfCalls + ds.NoOfCalls
	WHERE (
		ds.TotalDuration != dd.TotalDuration
	OR  ds.TotalBilledDuration != dd.TotalBilledDuration
	OR  ds.NoOfCalls != dd.NoOfCalls);


  SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; 
	
 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_insertPayments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_insertPayments`(
	IN `p_CompanyID` INT,
	IN `p_ProcessID` VARCHAR(100),
	IN `p_UserID` INT

)
BEGIN

	
	DECLARE v_UserName varchar(30);
 	
 	SELECT CONCAT(u.FirstName,CONCAT(' ',u.LastName)) as name into v_UserName from wavetelwholesaleRM.tblUser u where u.UserID=p_UserID;
 	
 	INSERT INTO tblPayment (
	 		CompanyID,
	 		 AccountID,
			 InvoiceNo,
			 PaymentDate,
			 PaymentMethod,
			 PaymentType,
			 Notes,
			 Amount,
			 CurrencyID,
			 Recall,
			 `Status`,
			 created_at,
			 updated_at,
			 CreatedBy,
			 ModifyBy,
			 RecallReasoan,
			 RecallBy,
			 BulkUpload,
			 InvoiceID
			 )
 	select tp.CompanyID,
	 		 tp.AccountID,
			 COALESCE(tp.InvoiceNo,''),
			 tp.PaymentDate,
			 tp.PaymentMethod,
			 tp.PaymentType,
			 tp.Notes,
			 tp.Amount,
			 ac.CurrencyId,
			 0 as Recall,
			 tp.Status,
			 Now() as created_at,
			 Now() as updated_at,
			 v_UserName as CreatedBy,
			 '' as ModifyBy,
			 '' as RecallReasoan,
			 '' as RecallBy,
			 1 as BulkUpload,
			 InvoiceID
	from tblTempPayment tp
	INNER JOIN wavetelwholesaleRM.tblAccount ac 
		ON  ac.AccountID = tp.AccountID  and ac.AccountType = 1
	where tp.ProcessID = p_ProcessID
			AND tp.PaymentDate <= NOW()
			AND tp.CompanyID = p_CompanyID;
			
	
			
	 delete from tblTempPayment where CompanyID = p_CompanyID and ProcessID = p_ProcessID;
	 
			
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_InsertTempReRateCDR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_InsertTempReRateCDR`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AccountID` INT,
	IN `p_ProcessID` VARCHAR(50),
	IN `p_tbltempusagedetail_name` VARCHAR(50),
	IN `p_CDRType` CHAR(1),
	IN `p_CLI` VARCHAR(50),
	IN `p_CLD` VARCHAR(50),
	IN `p_zerovaluecost` INT,
	IN `p_CurrencyID` INT,
	IN `p_area_prefix` VARCHAR(50),
	IN `p_trunk` VARCHAR(50)


)
BEGIN
	DECLARE v_BillingTime_ INT;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetBillingTime(p_CompanyGatewayID,p_AccountID) INTO v_BillingTime_;

	

	set @stm1 = CONCAT('

	INSERT INTO wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` (
		CompanyID,
		CompanyGatewayID,
		GatewayAccountID,
		AccountID,
		connect_time,
		disconnect_time,
		billed_duration,
		area_prefix,
		pincode,
		extension,
		cli,
		cld,
		cost,
		remote_ip,
		duration,
		trunk,
		ProcessID,
		ID,
		is_inbound,
		billed_second,
		disposition
	)

	SELECT
	*
	FROM (SELECT
		uh.CompanyID,
		CompanyGatewayID,
		GatewayAccountID,
		uh.AccountID,
		connect_time,
		disconnect_time,
		billed_duration,
		"Other" as area_prefix,
		pincode,
		extension,
		cli,
		cld,
		cost,
		remote_ip,
		duration,
		"Other" as trunk,
		"',p_ProcessID,'",
		ID,
		is_inbound,
		billed_second,
		disposition
	FROM wavetelwholesaleCDR.tblUsageDetails  ud
	INNER JOIN wavetelwholesaleCDR.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	INNER JOIN wavetelwholesaleRM.tblAccount a
		ON uh.AccountID = a.AccountID
	WHERE
	( "' , p_CDRType , '" = "" OR  ud.is_inbound =  "' , p_CDRType , '")
	AND  StartDate >= DATE_ADD( "' , p_StartDate , '",INTERVAL -1 DAY)
	AND StartDate <= DATE_ADD( "' , p_EndDate , '",INTERVAL 1 DAY)
	AND uh.CompanyID =  "' , p_CompanyID , '"
	AND uh.AccountID is not null
	AND ( "' , p_AccountID , '" = 0 OR uh.AccountID = "' , p_AccountID , '")
	AND ( "' , p_CompanyGatewayID , '" = 0 OR CompanyGatewayID = "' , p_CompanyGatewayID , '")
	AND ( "' , p_CurrencyID ,'" = "0" OR a.CurrencyId = "' , p_CurrencyID , '")
	AND ( "' , p_CLI , '" = "" OR cli LIKE REPLACE("' , p_CLI , '", "*", "%"))	
	AND ( "' , p_CLD , '" = "" OR cld LIKE REPLACE("' , p_CLD , '", "*", "%"))
	AND ( "' , p_trunk , '" = ""  OR  trunk = "' , p_trunk , '")
	AND ( "' , p_area_prefix , '" = "" OR area_prefix LIKE REPLACE( "' , p_area_prefix , '", "*", "%"))	
	AND ( "' , p_zerovaluecost , '" = 0 OR (  "' , p_zerovaluecost , '" = 1 AND cost = 0) OR (  "' , p_zerovaluecost , '" = 2 AND cost > 0))	
	) tbl
	WHERE 
	("' , v_BillingTime_ , '" =1 and connect_time >=  "' , p_StartDate , '" AND connect_time <=  "' , p_EndDate , '")
	OR 
	("' , v_BillingTime_ , '" =2 and disconnect_time >=  "' , p_StartDate , '" AND disconnect_time <=  "' , p_EndDate , '")
	AND billed_duration > 0;
	');

	
	PREPARE stmt1 FROM @stm1;
	EXECUTE stmt1;
	DEALLOCATE PREPARE stmt1;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_ProcesssCDR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_ProcesssCDR`(
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

	
	SET @stm = CONCAT('
	INSERT INTO tblGatewayAccount (CompanyID, CompanyGatewayID, GatewayAccountID, AccountName)
	SELECT
		DISTINCT
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.GatewayAccountID,
		ud.GatewayAccountID
	FROM wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' ud
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

	
	CALL  prc_getActiveGatewayAccount(p_CompanyID,p_CompanyGatewayID,'0','1',p_NameFormat);

	
	SET @stm = CONCAT('
	UPDATE wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` uh
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
	FROM wavetelwholesaleCDR.tblUsageHeader uh
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

		
		UPDATE wavetelwholesaleCDR.tblUsageHeader uh
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

	
	DROP TEMPORARY TABLE IF EXISTS tmp_AccountTrunkCdrUpload_;
	CREATE TEMPORARY TABLE tmp_AccountTrunkCdrUpload_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		TrunkID INT
	);
	SET @stm = CONCAT('
	INSERT INTO tmp_AccountTrunkCdrUpload_(AccountID,TrunkID)
	SELECT DISTINCT AccountID,TrunkID FROM wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND TrunkID IS NOT NULL AND ud.is_inbound = 0;
	');

	SET v_CDRUpload_ = (SELECT COUNT(*) FROM tmp_AccountTrunkCdrUpload_);

	IF v_CDRUpload_ > 0
	THEN
		
		SET @stm = CONCAT('
		UPDATE wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN wavetelwholesaleRM.tblCustomerTrunk ct 
			ON ct.AccountID = ud.AccountID AND ct.TrunkID = ud.TrunkID AND ct.Status =1
		INNER JOIN wavetelwholesaleRM.tblTrunk t 
			ON t.TrunkID = ct.TrunkID  
			SET ud.UseInBilling=ct.UseInBilling,ud.TrunkPrefix = ct.Prefix
		WHERE  ud.ProcessID = "' , p_processId , '";
		');
	END IF;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	
	IF p_RateFormat = 2
	THEN

		
		SET @stm = CONCAT('
		UPDATE wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN wavetelwholesaleRM.tblCustomerTrunk ct 
			ON ct.AccountID = ud.AccountID AND ct.Status =1 
			AND ct.UseInBilling = 0 
		INNER JOIN wavetelwholesaleRM.tblTrunk t 
			ON t.TrunkID = ct.TrunkID  
			SET ud.trunk = t.Trunk,ud.TrunkID =t.TrunkID,ud.UseInBilling=ct.UseInBilling
		WHERE  ud.ProcessID = "' , p_processId , '" AND ud.is_inbound = 0 AND ud.TrunkID IS NULL;
		');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		
		SET @stm = CONCAT('
		UPDATE wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN wavetelwholesaleRM.tblCustomerTrunk ct 
			ON ct.AccountID = ud.AccountID AND ct.Status =1 
			AND ct.UseInBilling = 1 AND cld LIKE CONCAT(ct.Prefix , "%")
		INNER JOIN wavetelwholesaleRM.tblTrunk t 
			ON t.TrunkID = ct.TrunkID  
			SET ud.trunk = t.Trunk,ud.TrunkID =t.TrunkID,ud.UseInBilling=ct.UseInBilling,ud.TrunkPrefix = ct.Prefix
		WHERE  ud.ProcessID = "' , p_processId , '" AND ud.is_inbound = 0 AND ud.TrunkID IS NULL;
		');

		PREPARE stm FROM @stm;
		EXECUTE stm;
		DEALLOCATE PREPARE stm;

	END IF;

	
	IF p_RateCDR = 1
	THEN

		SET @stm = CONCAT('UPDATE   wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud SET cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND ( AccountID IS NULL OR TrunkID IS NULL ) ') ;

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

	END IF;

	
	DROP TEMPORARY TABLE IF EXISTS tmp_AccountTrunk_;
	CREATE TEMPORARY TABLE tmp_AccountTrunk_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		TrunkID INT
	);
	SET @stm = CONCAT('
	INSERT INTO tmp_AccountTrunk_(AccountID,TrunkID)
	SELECT DISTINCT AccountID,TrunkID FROM wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND TrunkID IS NOT NULL AND ud.is_inbound = 0;
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

		
		CALL wavetelwholesaleRM.prc_getCustomerCodeRate(v_AccountID_,v_TrunkID_,p_RateCDR,p_RateMethod,p_SpecifyRate);

		
		
		IF p_RateFormat = 2
		THEN
			CALL prc_updatePrefix(v_AccountID_,v_TrunkID_, p_processId, p_tbltempusagedetail_name);
		END IF;

		
		IF p_RateCDR = 1
		THEN
			CALL prc_updateOutboundRate(v_AccountID_,v_TrunkID_, p_processId, p_tbltempusagedetail_name);
		END IF;

		SET v_pointer_ = v_pointer_ + 1;
	END WHILE;

	
	IF p_RateCDR = 0 AND p_RateFormat = 2
	THEN 
		
		DROP TEMPORARY TABLE IF EXISTS tmp_Accounts_;
		CREATE TEMPORARY TABLE tmp_Accounts_  (
			RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			AccountID INT
		);
		SET @stm = CONCAT('
		INSERT INTO tmp_Accounts_(AccountID)
		SELECT DISTINCT AccountID FROM wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND TrunkID IS NOT NULL;
		');

		PREPARE stm FROM @stm;
		EXECUTE stm;
		DEALLOCATE PREPARE stm;

		
		CALL wavetelwholesaleRM.prc_getDefaultCodes(p_CompanyID);

		
		CALL prc_updateDefaultPrefix(p_processId, p_tbltempusagedetail_name);

	END IF;

	
	CALL prc_RerateInboundCalls(p_CompanyID,p_processId,p_tbltempusagedetail_name,p_RateCDR,p_RateMethod,p_SpecifyRate);

	SET @stm = CONCAT('
	INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
	SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,1,  CONCAT( "Account:  " , ga.AccountName ," - Gateway: ",cg.Title," - Doesnt exist in NEON") as Message ,DATE(NOW())
	FROM wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud
	INNER JOIN tblGatewayAccount ga 
		ON ga.CompanyGatewayID = ud.CompanyGatewayID
		AND ga.CompanyID = ud.CompanyID
		AND ga.GatewayAccountID = ud.GatewayAccountID
	INNER JOIN wavetelwholesaleRM.tblCompanyGateway cg ON cg.CompanyGatewayID = ud.CompanyGatewayID
	WHERE ud.ProcessID = "' , p_processid  , '" and ud.AccountID IS NULL');
	
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	IF p_RateCDR = 1
	THEN
		SET @stm = CONCAT('
		INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
		SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,2,  CONCAT( "Account:  " , a.AccountName ," - Trunk: ",ud.trunk," - Unable to Rerate number ",IFNULL(ud.cld,"")," - No Matching prefix found") as Message ,DATE(NOW())
		FROM  wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN wavetelwholesaleRM.tblAccount a on  ud.AccountID = a.AccountID
		WHERE ud.ProcessID = "' , p_processid  , '" and ud.is_inbound = 0 AND ud.is_rerated = 0 AND ud.billed_second <> 0 and ud.area_prefix = "Other"');
		
		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		SET @stm = CONCAT('
		INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
		SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,3,  CONCAT( "Account:  " , a.AccountName ,  " - Unable to Rerate number ",IFNULL(ud.cld,"")," - No Matching prefix found") as Message ,DATE(NOW())
		FROM  wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN wavetelwholesaleRM.tblAccount a on  ud.AccountID = a.AccountID
		WHERE ud.ProcessID = "' , p_processid  , '" and ud.is_inbound = 1 AND ud.is_rerated = 0 AND ud.billed_second <> 0 and ud.area_prefix = "Other"');
		
		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		SET @stm = CONCAT('
		INSERT INTO wavetelwholesaleRM.tblTempRateLog (CompanyID,CompanyGatewayID,MessageType,Message,RateDate,SentStatus,created_at)
		SELECT rt.CompanyID,rt.CompanyGatewayID,rt.MessageType,rt.Message,rt.RateDate,0 as SentStatus,NOW() as created_at FROM tmp_tblTempRateLog_ rt
		LEFT JOIN wavetelwholesaleRM.tblTempRateLog rt2 
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_ProcesssVCDR` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_ProcesssVCDR`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_RateCDR` INT,
	IN `p_RateFormat` INT,
	IN `p_NameFormat` VARCHAR(50)


)
BEGIN
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;	
	DECLARE v_AccountID_ INT;	
	DECLARE v_TrunkID_ INT;
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
	
	
	SET @stm = CONCAT('
	INSERT INTO tblGatewayAccount (CompanyID, CompanyGatewayID, GatewayAccountID, AccountName,IsVendor)
	SELECT
		DISTINCT
		ud.CompanyID,
		ud.CompanyGatewayID,
		ud.GatewayAccountID,
		ud.GatewayAccountID,
		1 as IsVendor
	FROM wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' ud
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
	
	
	CALL  prc_getActiveGatewayAccount(p_CompanyID,p_CompanyGatewayID,'0','1',p_NameFormat);
	
	
	SET @stm = CONCAT('
	UPDATE wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` uh
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
	FROM wavetelwholesaleCDR.tblVendorCDRHeader uh
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
		
		UPDATE wavetelwholesaleCDR.tblVendorCDRHeader uh
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
	
	
	IF p_RateFormat = 2
	THEN
		
		
		SET @stm = CONCAT('
		UPDATE wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN wavetelwholesaleRM.tblVendorTrunk ct 
			ON ct.AccountID = ud.AccountID AND ct.Status =1 
			AND ct.UseInBilling = 0 
		INNER JOIN wavetelwholesaleRM.tblTrunk t 
			ON t.TrunkID = ct.TrunkID  
			SET ud.trunk = t.Trunk,ud.TrunkID =t.TrunkID,ud.UseInBilling=ct.UseInBilling
		WHERE  ud.ProcessID = "' , p_processId , '" AND ud.TrunkID IS NULL;
		');

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		
		SET @stm = CONCAT('
		UPDATE wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN wavetelwholesaleRM.tblVendorTrunk ct 
			ON ct.AccountID = ud.AccountID AND ct.Status =1 
			AND ct.UseInBilling = 1 AND cld LIKE CONCAT(ct.Prefix , "%")
		INNER JOIN wavetelwholesaleRM.tblTrunk t 
			ON t.TrunkID = ct.TrunkID  
			SET ud.trunk = t.Trunk,ud.TrunkID =t.TrunkID,ud.UseInBilling=ct.UseInBilling,ud.TrunkPrefix = ct.Prefix
		WHERE  ud.ProcessID = "' , p_processId , '" AND ud.TrunkID IS NULL;
		');

		PREPARE stm FROM @stm;
		EXECUTE stm;
		DEALLOCATE PREPARE stm;
		
	END IF;
		
	
	IF p_RateCDR = 1
	THEN
   	SET @stm = CONCAT('UPDATE   wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud SET selling_cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND ( AccountID IS NULL OR TrunkID IS NULL ) ') ;

		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
   
   END IF;
	
	
	DROP TEMPORARY TABLE IF EXISTS tmp_AccountTrunk_;
	CREATE TEMPORARY TABLE tmp_AccountTrunk_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		TrunkID INT
	);
	SET @stm = CONCAT('
	INSERT INTO tmp_AccountTrunk_(AccountID,TrunkID)
	SELECT DISTINCT AccountID,TrunkID FROM wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND TrunkID IS NOT NULL;
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
		
		
		CALL wavetelwholesaleRM.prc_getVendorCodeRate(v_AccountID_,v_TrunkID_,p_RateCDR);
		
		
		
		IF p_RateFormat = 2
		THEN
			CALL prc_updateVendorPrefix(v_AccountID_,v_TrunkID_, p_processId, p_tbltempusagedetail_name);
		END IF;
		
		
		
		IF p_RateCDR = 1
		THEN
			CALL prc_updateVendorRate(v_AccountID_,v_TrunkID_, p_processId, p_tbltempusagedetail_name);
		END IF;
		
 	
		SET v_pointer_ = v_pointer_ + 1;
	END WHILE;
	
	
	IF p_RateCDR = 0 AND p_RateFormat = 2
	THEN 
		
		DROP TEMPORARY TABLE IF EXISTS tmp_Accounts_;
		CREATE TEMPORARY TABLE tmp_Accounts_  (
			RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			AccountID INT
		);
		SET @stm = CONCAT('
		INSERT INTO tmp_Accounts_(AccountID)
		SELECT DISTINCT AccountID FROM wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND TrunkID IS NOT NULL;
		');

		PREPARE stm FROM @stm;
		EXECUTE stm;
		DEALLOCATE PREPARE stm;
		
			
		
		CALL wavetelwholesaleRM.prc_getDefaultCodes(p_CompanyID);
		
		
		CALL prc_updateDefaultVendorPrefix(p_processId, p_tbltempusagedetail_name);

	END IF;
	
	
	SET @stm = CONCAT('
	INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
	SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,1,  CONCAT( "Account:  " , ga.AccountName ," - Gateway: ",cg.Title," - Doesnt exist in NEON") as Message ,DATE(NOW())
	FROM wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud
	INNER JOIN tblGatewayAccount ga 
		ON ga.CompanyGatewayID = ud.CompanyGatewayID
		AND ga.CompanyID = ud.CompanyID
		AND ga.GatewayAccountID = ud.GatewayAccountID
	INNER JOIN wavetelwholesaleRM.tblCompanyGateway cg ON cg.CompanyGatewayID = ud.CompanyGatewayID
	WHERE ud.ProcessID = "' , p_processid  , '" and ud.AccountID IS NULL');
	
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	IF p_RateCDR = 1
	THEN
		SET @stm = CONCAT('
		INSERT INTO tmp_tblTempRateLog_ (CompanyID,CompanyGatewayID,MessageType,Message,RateDate)
		SELECT DISTINCT ud.CompanyID,ud.CompanyGatewayID,2,  CONCAT( "Account:  " , a.AccountName ," - Trunk: ",ud.trunk," - Unable to Rerate number ",ud.cld," - No Matching prefix found") as Message ,DATE(NOW())
		FROM  wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud
		INNER JOIN wavetelwholesaleRM.tblAccount a on  ud.AccountID = a.AccountID
		WHERE ud.ProcessID = "' , p_processid  , '" AND ud.is_rerated = 0 AND ud.billed_second <> 0 and ud.area_prefix = "Other"');
		
		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		SET @stm = CONCAT('
		INSERT INTO wavetelwholesaleRM.tblTempRateLog (CompanyID,CompanyGatewayID,MessageType,Message,RateDate,SentStatus,created_at)
		SELECT rt.CompanyID,rt.CompanyGatewayID,rt.MessageType,rt.Message,rt.RateDate,0 as SentStatus,NOW() as created_at FROM tmp_tblTempRateLog_ rt
		LEFT JOIN wavetelwholesaleRM.tblTempRateLog rt2 
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_RerateInboundCalls` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_RerateInboundCalls`(
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
	
		IF (SELECT COUNT(*) FROM wavetelwholesaleRM.tblCLIRateTable WHERE CompanyID = p_CompanyID AND RateTableID > 0) > 0
		THEN
		
			
			DROP TEMPORARY TABLE IF EXISTS tmp_Account_;
			CREATE TEMPORARY TABLE tmp_Account_  (
				RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
				AccountID INT,
				cld VARCHAR(500) NULL DEFAULT NULL
			);
			SET @stm = CONCAT('
			INSERT INTO tmp_Account_(AccountID,cld)
			SELECT DISTINCT AccountID,cld FROM wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND ud.is_inbound = 1;
			');
			
			PREPARE stm FROM @stm;
			EXECUTE stm;
			DEALLOCATE PREPARE stm;
		
		ELSE
			
			
			
			DROP TEMPORARY TABLE IF EXISTS tmp_Account_;
			CREATE TEMPORARY TABLE tmp_Account_  (
				RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
				AccountID INT,
				cld VARCHAR(500) NULL DEFAULT NULL
			);
			SET @stm = CONCAT('
			INSERT INTO tmp_Account_(AccountID,cld)
			SELECT DISTINCT AccountID,"" FROM wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud WHERE ProcessID="' , p_processId , '" AND AccountID IS NOT NULL AND ud.is_inbound = 1;
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
			
			
			CALL wavetelwholesaleRM.prc_getCustomerInboundRate(v_AccountID_,p_RateCDR,p_RateMethod,p_SpecifyRate,v_cld_);
			
			
			CALL prc_updateInboundPrefix(v_AccountID_, p_processId, p_tbltempusagedetail_name,v_cld_);
			
			
			CALL prc_updateInboundRate(v_AccountID_, p_processId, p_tbltempusagedetail_name,v_cld_);
			
			SET v_pointer_ = v_pointer_ + 1;
			
		END WHILE;

	END IF;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_salesDashboard` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_salesDashboard`(IN `p_CompanyID` INT, IN `p_gatewayid` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_PrevStartDate` DATETIME, IN `p_PrevEndDate` DATETIME, IN `p_Executive` INT 
)
BEGIN
   
   DECLARE v_Round_ int;
   SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
   SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	SELECT
        ROUND(ifNull(CAST(SUM(TotalCharges) as DECIMAL(16,5)),0),v_Round_) AS TotalCharges
    FROM tblUsageDaily ud
    LEFT JOIN wavetelwholesaleRM.tblAccount a
        ON ud.AccountID = a.AccountID 
    WHERE ud.DailyDate >= p_StartDate
    AND ud.DailyDate <= p_EndDate
    AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
    AND ud.CompanyID = p_CompanyID;
    
    



    SELECT
        COUNT( DISTINCT ud.AccountID ) AS totalactive
    FROM tblUsageDaily ud
    LEFT JOIN wavetelwholesaleRM.tblAccount a
        ON ud.AccountID = a.AccountID
    WHERE ud.DailyDate >= p_StartDate
    AND ud.DailyDate <= p_EndDate
    AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
    AND ud.CompanyID = p_CompanyID;
    


    SELECT
        COUNT( DISTINCT ga.GatewayAccountID) AS totalinactive
    FROM tblGatewayAccount ga
    left join tblUsageDaily ud on ud.AccountID = ga.AccountID AND  ud.DailyDate >= p_StartDate
        AND ud.DailyDate <= p_EndDate 
        and ud.CompanyID = ga.CompanyID
         LEFT JOIN wavetelwholesaleRM.tblAccount a
        ON ga.AccountID = a.AccountID
    where ud.AccountID is null 
    and ga.AccountID is not null
    AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
    AND ga.CompanyID = p_CompanyID
    AND AccountDetailInfo like '%"blocked":false%'
    AND ga.AccountID is not null;
    

    SELECT
        ROUND(CAST(SUM(TotalCharges) as DECIMAL(16,5)),v_Round_) AS TotalCharges,
        ud.DailyDate AS sales_date
    FROM tblUsageDaily ud
    LEFT JOIN wavetelwholesaleRM.tblAccount a
        ON ud.AccountID = a.AccountID 
    WHERE ud.DailyDate >= p_StartDate
    AND ud.DailyDate <= p_EndDate
    AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
    AND ud.CompanyID = p_CompanyID
    GROUP BY ud.DailyDate
    ORDER BY ud.DailyDate;

    SELECT
        ROUND(CAST(SUM(TotalCharges) as DECIMAL(16,5) ),v_Round_) AS TotalCharges,
        max(a.AccountName) as AccountName
    FROM tblUsageDaily ud
    LEFT JOIN wavetelwholesaleRM.tblAccount a
        ON ud.AccountID = a.AccountID  
    WHERE ud.DailyDate >= p_StartDate
    AND ud.DailyDate <= p_EndDate
    AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
    AND ud.CompanyID = p_CompanyID

    GROUP BY ud.AccountID
    order by SUM(TotalCharges) desc;



    SELECT  
        Max(ifnull(c.Country,'OTHER')) as Country,
        ROUND(CAST(SUM(TotalCharges) as DECIMAL(16,5)),v_Round_) AS TotalCharges
    FROM tblUsageDaily ud
    LEFT JOIN wavetelwholesaleRM.tblAccount a
        ON ud.AccountID = a.AccountID  
    LEFT JOIN wavetelwholesaleRM.tblRate r
        ON r.Code = ud.AreaPrefix AND r.CodeDeckId = 1
    LEFT JOIN wavetelwholesaleRM.tblCountry c
        ON r.CountryID = c.CountryID
    WHERE ud.DailyDate >= p_StartDate
    AND ud.DailyDate <= p_EndDate
    AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
    AND ud.CompanyID = p_CompanyID
    GROUP BY r.CountryID
    ORDER BY SUM(TotalCharges) DESC limit 5;

    SELECT
       DISTINCT ga.GatewayAccountID,
            ga.AccountName,
            ga.AccountID
    FROM tblGatewayAccount ga
    left join tblUsageDaily ud on ud.AccountID = ga.AccountID AND  ud.DailyDate >= p_StartDate
        AND ud.DailyDate <= p_EndDate 
        and ud.CompanyID = ga.CompanyID
         LEFT JOIN wavetelwholesaleRM.tblAccount a
        ON ga.AccountID = a.AccountID
    where ud.AccountID is null 
    AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
    and ga.AccountID is not null
    AND ga.CompanyID = p_CompanyID
    AND AccountDetailInfo like '%"blocked":false%'
    AND ga.AccountID is not null
    order by AccountName;

    IF p_Executive = 1
    THEN
        SELECT
            ROUND(ifNull(CAST(SUM(TotalCharges) as DECIMAL(16,5) ),0),v_Round_) AS TotalCharges,a.Owner,(concat(max(u.FirstName),' ',max(u.LastName))) as FullName
        FROM tblUsageDaily ud
        LEFT JOIN wavetelwholesaleRM.tblAccount a
            ON ud.AccountID = a.AccountID 
        LEFT JOIN wavetelwholesaleRM.tblUser u
            ON u.UserID = a.Owner
        WHERE ud.DailyDate >= p_StartDate
        AND ud.DailyDate <= p_EndDate
        AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
        AND a.AccountID is not null
        AND ud.CompanyID = p_CompanyID
        group by a.Owner;

        IF p_PrevStartDate != ''
        THEN
        SELECT
            ROUND(IFNull(CAST(SUM(TotalCharges) as DECIMAL(16,5)),0),v_Round_) AS TotalCharges,a.Owner,(concat(max(u.FirstName),' ',max(u.LastName))) as FullName
        FROM tblUsageDaily ud
        LEFT JOIN wavetelwholesaleRM.tblAccount a
            ON ud.AccountID = a.AccountID 
        LEFT JOIN wavetelwholesaleRM.tblUser u
            ON u.UserID = a.Owner
        WHERE ud.DailyDate >= p_PrevStartDate
        AND ud.DailyDate <= p_PrevEndDate
        AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
        AND ud.CompanyID = p_CompanyID
        group by a.Owner;

        else 
            select 1 as FullName,0 as TotalCharges;
        end if;

    else
        select 1 as FullName,0 as TotalCharges;
        select 1 as FullName,0 as TotalCharges;
    end if;

    IF p_PrevStartDate != ''
    THEN
        SELECT
            ROUND(IFNull(CAST(SUM(TotalCharges) as DECIMAL(16,5) ),0),v_Round_)   AS PrevTotalCharges
        FROM tblUsageDaily ud
        LEFT JOIN wavetelwholesaleRM.tblAccount a
            ON ud.AccountID = a.AccountID  
        WHERE ud.DailyDate >= p_PrevStartDate
        AND ud.DailyDate <= p_PrevEndDate
        AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
        AND ud.CompanyID = p_CompanyID;
        


        SELECT
            COUNT( DISTINCT ud.AccountID ) AS prevtotalactive
        FROM tblUsageDaily ud
        LEFT JOIN wavetelwholesaleRM.tblAccount a
            ON ud.AccountID = a.AccountID  
        WHERE ud.DailyDate >= p_PrevStartDate
        AND ud.DailyDate <= p_PrevEndDate
        AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
        AND ud.CompanyID = p_CompanyID;
        



        SELECT
            COUNT( DISTINCT ga.GatewayAccountID ) AS prevtotalinactive
        FROM tblGatewayAccount ga
        left join tblUsageDaily ud on ud.AccountID = ga.AccountID AND
    			ud.DailyDate >= p_PrevStartDate
        AND ud.DailyDate <= p_PrevEndDate 
            and ud.CompanyID = ga.CompanyID
        LEFT JOIN wavetelwholesaleRM.tblAccount a
            ON ga.AccountID = a.AccountID  
    where ud.AccountID is null 
    and ga.AccountID is not null
    AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
    AND ud.CompanyID = p_CompanyID
    AND AccountDetailInfo like '%"blocked":false%'
    AND ga.AccountID is not null;

        SELECT
            ROUND(CAST(SUM(TotalCharges) as DECIMAL(16,5) ),v_Round_) AS prevTotalCharges,
            ud.DailyDate
        FROM tblUsageDaily ud
        LEFT JOIN wavetelwholesaleRM.tblAccount a
            ON ud.AccountID = a.AccountID  
        WHERE ud.DailyDate >= p_PrevStartDate
        AND ud.DailyDate <= p_PrevEndDate
        AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
        AND ud.CompanyID = p_CompanyID
        GROUP BY ud.DailyDate
        ORDER BY ud.DailyDate;

        SELECT
            ROUND(CAST(SUM(TotalCharges) as DECIMAL(16,5) ),v_Round_) AS prevTotalCharges,
            max(a.AccountName) as AccountName
        FROM tblUsageDaily ud
        LEFT JOIN wavetelwholesaleRM.tblAccount a
            ON ud.AccountID = a.AccountID  
        WHERE ud.DailyDate >= p_PrevStartDate
        AND ud.DailyDate <= p_PrevEndDate
        AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
        AND ud.CompanyID = p_CompanyID
        GROUP BY ud.AccountID
        order by SUM(TotalCharges) desc;



        SELECT
            Max(ifnull(c.Country,'OTHER')) as Country,
            ROUND(CAST(SUM(TotalCharges) as DECIMAL(16,5) ),v_Round_) AS prevTotalCharges
        FROM tblUsageDaily ud
        LEFT JOIN wavetelwholesaleRM.tblAccount a
            ON ud.AccountID = a.AccountID  
        LEFT JOIN wavetelwholesaleRM.tblRate r
            ON r.Code = ud.AreaPrefix AND r.CodeDeckId = 1
        LEFT JOIN wavetelwholesaleRM.tblCountry c
            ON r.CountryID = c.CountryID
        WHERE ud.DailyDate >= p_PrevStartDate
        AND ud.DailyDate <= p_PrevEndDate
        AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
        AND ud.CompanyID = p_CompanyID
        GROUP BY r.CountryID
        ORDER BY SUM(TotalCharges) DESC limit 5;
        

         SELECT
            DISTINCT ga.GatewayAccountID,
            ga.AccountName,
            ga.AccountID
        FROM tblGatewayAccount ga
        left join tblUsageDaily ud on ud.AccountID = ga.AccountID  AND
    ud.DailyDate >= p_PrevStartDate
        AND ud.DailyDate <= p_PrevEndDate 
            and ud.CompanyID = ga.CompanyID
        LEFT JOIN wavetelwholesaleRM.tblAccount a
            ON ga.AccountID = a.AccountID  
    where ud.AccountID is null 
    AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
    and ga.AccountID is not null
    AND ga.CompanyID = p_CompanyID
    AND AccountDetailInfo like '%"blocked":false%'
    AND ga.AccountID is not null
    order by AccountName;

    END IF;
    
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_StartStopRecurringInvoices` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_StartStopRecurringInvoices`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_RecurringInvoiceStatus` INT,
	IN `p_InvoiceIDs` VARCHAR(200),
	IN `p_StartStop` INT,
	IN `p_ModifiedBy` VARCHAR(50),
	IN `p_LogStatus` INT
)
BEGIN
	DECLARE v_Status_to VARCHAR(100);
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	SET v_Status_to = CASE WHEN p_StartStop=1 THEN CONCAT('Recurring Invoice Start by ',p_ModifiedBy) ELSE CONCAT('Recurring Invoice Stop by ',p_ModifiedBy) END;
	
	INSERT INTO tblRecurringInvoiceLog
	SELECT null,inv.RecurringInvoiceID,v_Status_to,p_LogStatus,Now(),Now()
	FROM tblRecurringInvoice inv
	WHERE inv.CompanyID = p_CompanyID
	AND inv.`Status`!=p_StartStop
	AND (p_InvoiceIDs='' 
			AND (p_AccountID = 0 OR inv.AccountID=p_AccountID) 
			AND (p_RecurringInvoiceStatus=2 OR inv.`Status`=p_RecurringInvoiceStatus)
		 )
	OR (p_InvoiceIDs<>'' AND FIND_IN_SET(inv.RecurringInvoiceID ,p_InvoiceIDs));
	
	UPDATE tblRecurringInvoice inv SET inv.`Status` = p_StartStop
	WHERE inv.CompanyID = p_CompanyID
	AND inv.`Status`!=p_StartStop
	AND (p_InvoiceIDs='' 
			AND (p_AccountID = 0 OR inv.AccountID=p_AccountID) 
			AND (p_RecurringInvoiceStatus=2 OR inv.`Status`=p_RecurringInvoiceStatus)
		 )
	OR (p_InvoiceIDs<>'' AND FIND_IN_SET(inv.RecurringInvoiceID ,p_InvoiceIDs));
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_start_end_time` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_start_end_time`(IN `p_ProcessID` VARCHAR(2000), IN `p_tbltempusagedetail_name` VARCHAR(50))
BEGIN
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    set @stm1 = CONCAT('select 
   MAX(disconnect_time) as max_date,MIN(connect_time)  as min_date
   from wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` where ProcessID = "' , p_ProcessID , '"');
   
   PREPARE stmt1 FROM @stm1;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_updateDefaultPrefix` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_updateDefaultPrefix`(IN `p_processId` INT, IN `p_tbltempusagedetail_name` VARCHAR(200))
BEGIN
	DECLARE v_pointer_ INT;	
	DECLARE v_partition_limit_ INT;
	
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
	

	
	
	SET v_pointer_ = 0;
	SET v_partition_limit_ = 1000;
	SET @stm = CONCAT('
		SET @rowCount = (SELECT   COUNT(*)   FROM wavetelwholesaleCDR.' , p_tbltempusagedetail_name , '  ud LEFT JOIN tmp_Accounts_ a ON a.AccountID = ud.AccountID WHERE a.AccountID IS NULL AND ProcessID = "' , p_processId , '"  );
	');
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	WHILE v_pointer_ <= @rowCount
	DO
		
			
		DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetailPart_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetailPart_(
			TempUsageDetailID int,
			cld varchar(500),
			INDEX IX_TempUsageDetailID(`TempUsageDetailID`),
			INDEX IX_cld(`cld`)
		);
		SET @stm = CONCAT('
		INSERT INTO tmp_TempUsageDetailPart_
		SELECT 
			TempUsageDetailID,
			cld
		FROM wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' ud
		LEFT JOIN tmp_Accounts_ a
			ON a.AccountID = ud.AccountID
		WHERE a.AccountID IS NULL 
			AND ProcessID = "' , p_processId , '"  
			AND area_prefix = "Other"  
		LIMIT ',v_partition_limit_,' OFFSET ',v_pointer_,';
		');
		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		INSERT INTO tmp_TempUsageDetail_
		SELECT
			TempUsageDetailID,
			c.code AS prefix
		FROM tmp_TempUsageDetailPart_ ud
		INNER JOIN wavetelwholesaleRM.tmp_codes_ c 
			ON  cld like  CONCAT(c.Code,"%");
			
		SET v_pointer_ = v_pointer_ + v_partition_limit_;
		
	END WHILE;
	
	


	INSERT INTO tmp_TempUsageDetail2_
	SELECT tbl.TempUsageDetailID,MAX(tbl.prefix)  
	FROM tmp_TempUsageDetail_ tbl
	GROUP BY tbl.TempUsageDetailID;

	SET @stm = CONCAT('UPDATE wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' tbl2
	INNER JOIN tmp_TempUsageDetail2_ tbl
		ON tbl2.TempUsageDetailID = tbl.TempUsageDetailID
	SET area_prefix = prefix
	WHERE tbl2.processId = "' , p_processId , '"
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;     

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_updateDefaultVendorPrefix` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_updateDefaultVendorPrefix`(IN `p_processId` INT, IN `p_tbltempusagedetail_name` VARCHAR(200))
BEGIN
	DECLARE v_pointer_ INT;	
	DECLARE v_partition_limit_ INT;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail_(
		TempVendorCDRID int,
		prefix varchar(50),
		INDEX IX_TempVendorCDRID(`TempVendorCDRID`)
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail2_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail2_(
		TempVendorCDRID int,
		prefix varchar(50),
		INDEX IX_TempVendorCDRID2(`TempVendorCDRID`)
	);
	

	
	
	SET v_pointer_ = 0;
	SET v_partition_limit_ = 1000;
	SET @stm = CONCAT('
		SET @rowCount = (SELECT   COUNT(*)   FROM wavetelwholesaleCDR.' , p_tbltempusagedetail_name , '  ud LEFT JOIN tmp_Accounts_ a ON a.AccountID = ud.AccountID WHERE a.AccountID IS NULL AND ProcessID = "' , p_processId , '"  );
	');
	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	WHILE v_pointer_ <= @rowCount
	DO
		
			
		DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetailPart_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetailPart_(
			TempVendorCDRID int,
			cld varchar(500),
			INDEX IX_TempVendorCDRID(`TempVendorCDRID`),
			INDEX IX_cld(`cld`)
		);
		SET @stm = CONCAT('
		INSERT INTO tmp_TempUsageDetailPart_
		SELECT 
			TempVendorCDRID,
			cld
		FROM wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' ud
		LEFT JOIN tmp_Accounts_ a
			ON a.AccountID = ud.AccountID
		WHERE a.AccountID IS NULL 
			AND ProcessID = "' , p_processId , '"  
			AND area_prefix = "Other"  
		LIMIT ',v_partition_limit_,' OFFSET ',v_pointer_,';
		');
		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		
		INSERT INTO tmp_TempUsageDetail_
		SELECT
			TempVendorCDRID,
			c.code AS prefix
		FROM tmp_TempUsageDetailPart_ ud
		INNER JOIN wavetelwholesaleRM.tmp_codes_ c 
			ON  cld like  CONCAT(c.Code,"%");
			
		SET v_pointer_ = v_pointer_ + v_partition_limit_;
		
	END WHILE;
	
	


	INSERT INTO tmp_TempUsageDetail2_
	SELECT tbl.TempVendorCDRID,MAX(tbl.prefix)  
	FROM tmp_TempUsageDetail_ tbl
	GROUP BY tbl.TempVendorCDRID;

	SET @stm = CONCAT('UPDATE wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' tbl2
	INNER JOIN tmp_TempUsageDetail2_ tbl
		ON tbl2.TempVendorCDRID = tbl.TempVendorCDRID
	SET area_prefix = prefix
	WHERE tbl2.processId = "' , p_processId , '"
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;     

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_updateInboundPrefix` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_updateInboundPrefix`(
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
		
		
		SET @stm = CONCAT('
		INSERT INTO tmp_TempUsageDetail_
		SELECT
			TempUsageDetailID,
			c.code AS prefix
		FROM wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' ud 
		INNER JOIN wavetelwholesaleRM.tmp_inboundcodes_ c 
		ON ud.ProcessID = ' , p_processId , '
			AND ud.is_inbound = 1 
			AND ud.AccountID = ' , p_AccountID , '
			AND ("' , p_CLD , '" = "" OR cld = "' , p_CLD , '")
			AND ud.area_prefix = "Other"
			AND cli like  CONCAT(c.Code,"%");
		');
		
	ELSE
		
		
		SET @stm = CONCAT('
		INSERT INTO tmp_TempUsageDetail_
		SELECT
			TempUsageDetailID,
			c.code AS prefix
		FROM wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' ud 
		INNER JOIN wavetelwholesaleRM.tmp_inboundcodes_ c 
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

	SET @stm = CONCAT('UPDATE wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' tbl2
	INNER JOIN tmp_TempUsageDetail2_ tbl
		ON tbl2.TempUsageDetailID = tbl.TempUsageDetailID
	SET area_prefix = prefix
	WHERE tbl2.processId = "' , p_processId , '"
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;     

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_updateInboundRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_updateInboundRate`(
	IN `p_AccountID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200),
	IN `p_CLD` VARCHAR(500)
)
BEGIN
	
	SET @stm = CONCAT('UPDATE   wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud SET cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND AccountID = "',p_AccountID ,'" AND ("' , p_CLD , '" = "" OR cld = "' , p_CLD , '") AND is_inbound = 1 ') ;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stm = CONCAT('
	UPDATE   wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud 
	INNER JOIN wavetelwholesaleRM.tmp_inboundcodes_ cr ON cr.Code = ud.area_prefix
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
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_updateOutboundRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_updateOutboundRate`(
	IN `p_AccountID` INT,
	IN `p_TrunkID` INT,
	IN `p_processId` INT,
	IN `p_tbltempusagedetail_name` VARCHAR(200)

)
BEGIN
	
	SET @stm = CONCAT('UPDATE   wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud SET cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND AccountID = "',p_AccountID ,'" AND TrunkID = "',p_TrunkID ,'" AND is_inbound = 0 ') ;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stm = CONCAT('
	UPDATE   wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud 
	INNER JOIN wavetelwholesaleRM.tmp_codes_ cr ON cr.Code = ud.area_prefix
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_updatePrefix` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_updatePrefix`(
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

	
	SET @stm = CONCAT('
	INSERT INTO tmp_TempUsageDetail_
	SELECT
		TempUsageDetailID,
		c.code AS prefix
	FROM wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' ud
	INNER JOIN wavetelwholesaleRM.tmp_codes_ c 
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

	
	SET @stm = CONCAT('
	INSERT INTO tmp_TempUsageDetail_
	SELECT
		TempUsageDetailID,
		c.code AS prefix
	FROM wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' ud
	INNER JOIN wavetelwholesaleRM.tmp_codes_ c 
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

	SET @stm = CONCAT('UPDATE wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' tbl2
	INNER JOIN tmp_TempUsageDetail2_ tbl
		ON tbl2.TempUsageDetailID = tbl.TempUsageDetailID
	SET area_prefix = prefix
	WHERE tbl2.processId = "' , p_processId , '"
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;     

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_updateSOAOffSet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_updateSOAOffSet`(
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

     
	INSERT into tmp_AccountSOA(AccountID,Amount,InvoiceType)
	SELECT
		tblInvoice.AccountID,
		tblInvoice.GrandTotal,
		tblInvoice.InvoiceType
	FROM tblInvoice
	WHERE tblInvoice.CompanyID = p_CompanyID
	AND ( (tblInvoice.InvoiceType = 2) OR ( tblInvoice.InvoiceType = 1 AND tblInvoice.InvoiceStatus NOT IN ( 'cancel' , 'draft' , 'awaiting') )  )
	AND (p_AccountID = 0 OR  tblInvoice.AccountID = p_AccountID);

     
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
	SELECT DISTINCT tblAccount.AccountID ,0 FROM wavetelwholesaleRM.tblAccount
	LEFT JOIN tmp_AccountSOA ON tblAccount.AccountID = tmp_AccountSOA.AccountID
	WHERE tblAccount.CompanyID = p_CompanyID
	AND tmp_AccountSOA.AccountID IS NULL
	AND (p_AccountID = 0 OR  tblAccount.AccountID = p_AccountID);
	
	UPDATE wavetelwholesaleRM.tblAccountBalance
	INNER JOIN tmp_AccountSOABal 
		ON  tblAccountBalance.AccountID = tmp_AccountSOABal.AccountID
	SET SOAOffset=tmp_AccountSOABal.Amount;
	
	UPDATE wavetelwholesaleRM.tblAccountBalance SET tblAccountBalance.BalanceAmount = COALESCE(tblAccountBalance.SOAOffset,0) + COALESCE(tblAccountBalance.UnbilledAmount,0)  - COALESCE(tblAccountBalance.VendorUnbilledAmount,0);
	
	INSERT INTO wavetelwholesaleRM.tblAccountBalance (AccountID,BalanceAmount,UnbilledAmount,SOAOffset)
	SELECT tmp_AccountSOABal.AccountID,tmp_AccountSOABal.Amount,0,tmp_AccountSOABal.Amount
	FROM tmp_AccountSOABal 
	LEFT JOIN wavetelwholesaleRM.tblAccountBalance
		ON tblAccountBalance.AccountID = tmp_AccountSOABal.AccountID
	WHERE tblAccountBalance.AccountID IS NULL;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_updateVendorPrefix` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_updateVendorPrefix`(IN `p_AccountID` INT, IN `p_TrunkID` INT, IN `p_processId` INT, IN `p_tbltempusagedetail_name` VARCHAR(200))
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail_(
		TempVendorCDRID int,
		prefix varchar(50),
		INDEX IX_TempVendorCDRID(`TempVendorCDRID`)
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_TempUsageDetail2_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TempUsageDetail2_(
		TempVendorCDRID int,
		prefix varchar(50),
		INDEX IX_TempVendorCDRID2(`TempVendorCDRID`)
	);

	
	SET @stm = CONCAT('
	INSERT INTO tmp_TempUsageDetail_
	SELECT
		TempVendorCDRID,
		c.code AS prefix
	FROM wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' ud
	INNER JOIN wavetelwholesaleRM.tmp_vcodes_ c 
	ON ud.ProcessID = ' , p_processId , '
		AND ud.AccountID = ' , p_AccountID , '
		AND ud.TrunkID = ' , p_TrunkID , '
		AND ud.UseInBilling = 0
		AND ud.area_prefix = "Other"
		AND cld like  CONCAT(c.Code,"%");
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	
	SET @stm = CONCAT('
	INSERT INTO tmp_TempUsageDetail_
	SELECT
		TempVendorCDRID,
		c.code AS prefix
	FROM wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' ud
	INNER JOIN wavetelwholesaleRM.tmp_vcodes_ c 
	ON ud.ProcessID = ' , p_processId , '
		AND ud.AccountID = ' , p_AccountID , '
		AND ud.TrunkID = ' , p_TrunkID , '
		AND ud.UseInBilling = 1 
		AND ud.area_prefix = "Other"
		AND cld like  CONCAT(ud.TrunkPrefix,c.Code,"%");
	');

	PREPARE stm FROM @stm;
	EXECUTE stm;
	DEALLOCATE PREPARE stm;

	SET @stm = CONCAT('INSERT INTO tmp_TempUsageDetail2_
	SELECT tbl.TempVendorCDRID,MAX(tbl.prefix)  
	FROM tmp_TempUsageDetail_ tbl
	GROUP BY tbl.TempVendorCDRID;');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stm = CONCAT('UPDATE wavetelwholesaleCDR.' , p_tbltempusagedetail_name , ' tbl2
	INNER JOIN tmp_TempUsageDetail2_ tbl
		ON tbl2.TempVendorCDRID = tbl.TempVendorCDRID
	SET area_prefix = prefix
	WHERE tbl2.processId = "' , p_processId , '"
	');

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;     

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_updateVendorRate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_updateVendorRate`(IN `p_AccountID` INT, IN `p_TrunkID` INT, IN `p_processId` INT, IN `p_tbltempusagedetail_name` VARCHAR(200))
BEGIN
	
	SET @stm = CONCAT('UPDATE   wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud SET selling_cost = 0,is_rerated=0  WHERE ProcessID = "',p_processId,'" AND AccountID = "',p_AccountID ,'" AND TrunkID = "',p_TrunkID ,'"') ;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @stm = CONCAT('
	UPDATE   wavetelwholesaleCDR.`' , p_tbltempusagedetail_name , '` ud 
	INNER JOIN wavetelwholesaleRM.tmp_vcodes_ cr ON cr.Code = ud.area_prefix
	SET selling_cost = 
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
	AND TrunkID = "',p_TrunkID ,'"') ;

	PREPARE stmt FROM @stm;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_validatePayments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_validatePayments`(IN `p_CompanyID` INT, IN `p_ProcessID` VARCHAR(50))
BEGIN

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET SESSION group_concat_max_len=5000;


	DROP TEMPORARY TABLE IF EXISTS tmp_error_;
	CREATE TEMPORARY TABLE tmp_error_(
		`ErrorMessage` VARCHAR(500)
	);
	
		INSERT INTO tmp_error_	
	SELECT DISTINCT CONCAT('Future payments will not be uploaded - Account: ',IFNULL(ac.AccountName,''),' Action: ' ,IFNULL(pt.PaymentType,''),' Payment Date: ',IFNULL(pt.PaymentDate,''),' Amount: ',pt.Amount) as ErrorMessage
	FROM tblTempPayment pt
	INNER JOIN wavetelwholesaleRM.tblAccount ac on ac.AccountID = pt.AccountID
	WHERE pt.CompanyID = p_CompanyID
		AND pt.PaymentDate > NOW()
		AND pt.ProcessID = p_ProcessID;

	INSERT INTO tmp_error_
	SELECT distinct CONCAT('Duplicate payment in file - Account: ',IFNULL(ac.AccountName,''),' Action: ' ,IFNULL(pt.PaymentType,''),' Payment Date: ',IFNULL(pt.PaymentDate,''),' Amount: ',pt.Amount) as ErrorMessage  
	FROM tblTempPayment pt
	INNER JOIN wavetelwholesaleRM.tblAccount ac on ac.AccountID = pt.AccountID
	INNER JOIN tblTempPayment tp on tp.ProcessID = pt.ProcessID
		AND tp.AccountID = pt.AccountID
		AND tp.PaymentDate = pt.PaymentDate
		AND tp.Amount = pt.Amount
		AND tp.PaymentType = pt.PaymentType
		AND tp.PaymentMethod = pt.PaymentMethod
	WHERE pt.CompanyID = p_CompanyID
		AND pt.ProcessID = p_ProcessID
 	GROUP BY pt.InvoiceNo,pt.AccountID,pt.PaymentDate,pt.PaymentType,pt.PaymentMethod,pt.Amount having count(*)>=2;
 	
	INSERT INTO tmp_error_	
	SELECT DISTINCT
		CONCAT('Duplicate payment in system - Account: ',IFNULL(ac.AccountName,''),' Action: ' ,IFNULL(pt.PaymentType,''),' Payment Date: ',IFNULL(pt.PaymentDate,''),' Amount: ',pt.Amount) as ErrorMessage
	FROM tblTempPayment pt
	INNER JOIN wavetelwholesaleRM.tblAccount ac on ac.AccountID = pt.AccountID
	INNER JOIN tblPayment p on p.CompanyID = pt.CompanyID 
		AND p.AccountID = pt.AccountID
		AND p.PaymentDate = pt.PaymentDate
		AND p.Amount = pt.Amount
		AND p.PaymentType = pt.PaymentType
		AND p.Recall = 0
	WHERE pt.CompanyID = p_CompanyID
		AND pt.ProcessID = p_ProcessID;
	

	
	
	IF (SELECT COUNT(*) FROM tmp_error_) > 0
	THEN
	SELECT GROUP_CONCAT(ErrorMessage SEPARATOR "\r\n" ) as ErrorMessage FROM	tmp_error_;
		
	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
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

-- Dump completed on 2017-04-03 11:35:48
