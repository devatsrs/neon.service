<?php

class TicketImportRuleTestCase extends TestCase {


	/**
	 * A basic functional test example.
	 *
	 * @return void
	 */
	public function testBasicExample2()
	{

		$output = new Symfony\Component\Console\Output\ConsoleOutput();
		$output->writeln("now date : " . date("Y-m-d H:i:s"));


		$CompanyID=1;
		$TicketID=51;
		\Illuminate\Support\Facades\DB::beginTransaction();
		\Illuminate\Support\Facades\DB::delete("DELETE FROM `tblTickets` WHERE TicketID = ".$TicketID);
		 \Illuminate\Support\Facades\DB::insert("INSERT INTO `tblTickets` (`TicketID`, `CompanyID`, `Requester`, `RequesterName`, `RequesterCC`, `RequesterBCC`, `AccountID`, `ContactID`, `UserID`, `Subject`, `Type`, `Status`, `Priority`, `Group`, `Agent`, `Description`, `AttachmentPaths`, `TicketType`, `AccountEmailLogID`, `Read`, `EscalationEmail`, `TicketSlaID`, `RespondSlaPolicyVoilationEmailStatus`, `ResolveSlaPolicyVoilationEmailStatus`, `DueDate`, `CustomDueDate`, `AgentRepliedDate`, `CustomerRepliedDate`, `created_at`, `created_by`, `updated_at`, `updated_by`)										VALUES (".$TicketID.", 1, 'bhavin1@code-desk.com', 'aaaaa eeee', '', NULL, 449, 0, 0, 'test ticket 111', 11, 13, 1, 2, 1, '<p>asdf<br></p>', 'a:1:{i:0;a:2:{s:8:\"filename\";s:25:\"branding-logo-zendesk.png\";s:8:\"filepath\";s:70:\"1/TicketAttachment/2017/05/17/DA196351-C8C7-BAF4-026A-93F99DDB285E.png\";}}', 0, 0, 1, 0, 4, 0, 0, '2017-05-17 09:06:44', 0, '2017-05-17 08:55:40', NULL, '2017-05-17 08:51:44', 'aaaaa eeee', '2017-05-17 08:55:41', 'Sumera Khan');");
		$logData = [
			"Requester" => "bhavin1@code-desk.com",
			"Status" => "0",
			"Subject" => "DevTest123456",
			"Description" => "Hi DevTest123456"
		];

		$log = \App\Lib\TicketImportRule::check($CompanyID,array_merge($logData,["TicketID"=>$TicketID]));

		$output->writeln(print_r($log,true));

		\Illuminate\Support\Facades\DB::commit();

	}

}
