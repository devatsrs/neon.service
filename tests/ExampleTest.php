<?php

class ExampleTest extends TestCase {

	/**
	 * A basic functional test example.
	 *
	 * @return void
	 */
	public function testBasicExample()
	{
		//$response = $this->call('GET', '/');

		//$this->assertEquals(200, $response->getStatusCode());

		$header = "Received: (qmail 32009 invoked by uid 30297); 20 Apr 2017 11:10:00 -0000
Received: from unknown (HELO p3plibsmtp01-02.prod.phx3.secureserver.net) ([72.167.238.43])
          (envelope-sender <>)
          by p3plsmtp09-06-25.prod.phx3.secureserver.net (qmail-1.03) with SMTP
          for <neontesting@code-desk.com>; 20 Apr 2017 11:10:00 -0000
Received: from n1plsmtpa01-02.prod.ams1.secureserver.net ([188.121.53.2])
 by p3plibsmtp01-02.prod.phx3.secureserver.net with bizsmtp
 id Ab7u1v01G02raA401bA06F; Thu, 20 Apr 2017 04:10:00 -0700
Date: Thu, 20 Apr 2017 04:10:00 -0700
From: mailer-daemon@secureserver.net
To: neontesting@code-desk.com
Subject: Message Delivery Failure
MIME-Version: 1.0
Content-Type: multipart/report; boundary=\"------------I305M09060309060P_971414926866000\"
X-Nonspam: None";
		$body = "This is a multi-part message in MIME format.

--------------I305M09060309060P_971414926866000
Content-Type: text/plain; charset=UTF-8;
Content-Transfer-Encoding: 8bit

      This is an automatically generated Delivery Status Notification.

Delivery to the following recipients failed permanently:

   * test@code-desk.com

Reason: There was an error while attempting to deliver your message with [Subject: \"Test Mail Ticket unassigned - [#68] dumy ticket\"] to test@code-desk.com. MTA n1plsmtpa01-02.prod.ams1.secureserver.net received this response from the destination host IP - 68.178.213.203 -  550 , 550 5.1.1 <test@code-desk.com> Recipient not found.  <http://x.co/irbounce>
";
		if(self::check_auto_generated($header,$body)){
			echo "yes";
		}else {
			echo "no";
		}


	}

	public static function check_auto_generated($header = '',$body) {

		$find_header = [
			"Auto-Submitted:",
		];
		$find_body = [
			"Delivery to the following recipient failed permanently:",
			"Delivery to the following recipients failed permanently:",
			"This message was created automatically by mail delivery software",
		];


		foreach($find_header as $f_header){

			if(strpos(strtolower($header),strtolower($f_header)) !== false){
				//if(preg_grep(strtolower($f_header),[strtolower($header)])) {
				return true;
			}
		}
		foreach($find_body as $f_body) {

			if(strpos(strtolower($body),strtolower($f_body)) !== false){
				//if (preg_grep(strtolower($f_body), [strtolower($body)])) {
				return true;
			}
		}


		return false;


	}

}
