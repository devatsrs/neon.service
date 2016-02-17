#!/usr/bin/env python2

from thrift.transport import TTransport
from thrift.protocol import TBinaryProtocol

import sys
sys.path.append("/usr/local/lib/python3.4")
sys.path.append("./thrift_stub_dir")
#from ssp import ttypes
from thrift_stub_dir.thrift.ttypes import Cdrs

sippy_encodedfile = str(sys.argv[1])

fd = file(sippy_encodedfile)
t = TTransport.TFileObjectTransport(fd)
p = TBinaryProtocol.TBinaryProtocolAccelerated(t)
while True:
    obj = Cdrs()
    try:
        obj.read(p)
        print( "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" % (obj.i_cdr,obj.i_call,obj.i_account,obj.result,obj.cost,obj.delay,obj.duration,obj.billed_duration,obj.connect_time,obj.disconnect_time,obj.cld_in,obj.cli_in,obj.prefix,obj.price_1,obj.price_n,obj.interval_1,obj.interval_n,obj.post_call_surcharge,obj.connect_fee,obj.free_seconds,obj.remote_ip,obj.grace_period,obj.user_agent,obj.pdd1xx,obj.i_protocol,obj.release_source,obj.plan_duration,obj.accessibility_cost,obj.lrn_cld,obj.lrn_cld_in,obj.area_name,obj.p_asserted_id,obj.remote_party_id))
    except EOFError:
        break
