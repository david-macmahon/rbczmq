# encoding: utf-8

#--
#
# Author:: Lourens Naudé
# Homepage::  http://github.com/methodmissing/rbczmq
# Date:: 20111213
#
#----------------------------------------------------------------------------
#
# Copyright (C) 2011 by Lourens Naudé. All Rights Reserved.
# Email: lourens at methodmissing dot com
#
# (The MIT License)
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#---------------------------------------------------------------------------
#
#

class ZMQ::Socket::Pub

# == ZMQ::Socket::Pub
#
# A socket of type ZMQ::Socket::Pub is used by a publisher to distribute data. Messages sent are distributed in a fan out fashion
# to all connected peers. The ZMQ::Socket#recv function is not implemented for this socket type.
#
# When a ZMQ::Socket::Pub socket enters an exceptional state due to having reached the high water mark for a subscriber, then
# any messages that would be sent to the subscriber in question shall instead be dropped until the exceptional state ends. The
# ZMQ::Socket#send function shall never block for this socket type.
#
# === Summary of ZMQ::Socket::Pub characteristics
#
# [Compatible peer sockets] ZMQ::Socket::Sub
# [Direction] Unidirectional
# [Send/receive pattern] Send only
# [Incoming routing strategy] N/A
# [Outgoing routing strategy] Fan out
# [ZMQ::Socket#hwm option action] Drop

  TYPE_STR = "PUB"

  def type
    ZMQ::PUB
  end

  include ZMQ::UpstreamSocket
end