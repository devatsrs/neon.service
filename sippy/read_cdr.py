#!/usr/bin/env python2

from thrift.transport import TTransport
from thrift.protocol import TBinaryProtocol

import sys
sys.path.append("/usr/local/lib/python3.4")
sys.path.append("./thrift_stub_dir")
#from ssp import ttypes
from thrift_stub_dir.thrift.ttypes import Cdrs
from thrift_stub_dir.thrift.ttypes import CdrsConnections

cdr_type = str(sys.argv[1])
sippy_encodedfile = str(sys.argv[2])

fd = file(sippy_encodedfile)
t = TTransport.TFileObjectTransport(fd)
p = TBinaryProtocol.TBinaryProtocolAccelerated(t)
while True:
    if cdr_type == 'customer':
        obj = Cdrs()
    else:
        obj = CdrsConnections()
    try:
        obj.read(p)
        if cdr_type == 'customer':
            print( "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" % (obj.i_cdr,obj.i_call,obj.i_account,obj.result,obj.cost,obj.delay,obj.duration,obj.billed_duration,obj.connect_time,obj.disconnect_time,obj.cld_in.rstrip('\n'),obj.cli_in,obj.prefix,obj.price_1,obj.price_n,obj.interval_1,obj.interval_n,obj.post_call_surcharge,obj.connect_fee,obj.free_seconds,obj.remote_ip,obj.grace_period,obj.user_agent,obj.pdd1xx,obj.i_protocol,obj.release_source,obj.plan_duration,obj.accessibility_cost,obj.lrn_cld,obj.lrn_cld_in,obj.area_name,obj.p_asserted_id,obj.remote_party_id))
        else:
            print( "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" % (obj.i_cdrs_connection,obj.i_call,obj.i_connection,obj.result,obj.cost,obj.delay,obj.duration,obj.billed_duration,obj.setup_time,obj.connect_time,obj.disconnect_time,obj.cld_out,obj.cli_out.rstrip('\n'),obj.prefix,obj.price_1,obj.price_n,obj.interval_1,obj.interval_n,obj.post_call_surcharge,obj.connect_fee,obj.free_seconds,obj.grace_period,obj.user_agent,obj.pdd100,obj.pdd1xx,obj.i_account_debug,obj.i_protocol,obj.release_source,obj.call_setup_time,obj.lrn_cld,obj.area_name,obj.i_media_relay,obj.remote_ip,obj.vendor_name))
    except EOFError:
        break
