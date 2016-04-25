# encoding: utf-8

require 'mkmf'
require 'pathname'

def sys(cmd, err_msg)
  p cmd
  system(cmd) || fail(err_msg)
end

def fail(msg)
  STDERR.puts msg
  exit(1)
end

RbConfig::MAKEFILE_CONFIG['CC'] = ENV['CC'] if ENV['CC']

# XXX fallbacks specific to Darwin for JRuby (does not set these values in RbConfig::CONFIG)
LIBEXT = RbConfig::CONFIG['LIBEXT'] || 'a'
DLEXT = RbConfig::CONFIG['DLEXT'] || 'bundle'

with_config('zeromq')
with_config('czmq')

## Fail early if we don't meet the following dependencies.
#
## Courtesy of EventMachine and @tmm1
#def check_libs libs = [], fatal = false
#  libs.all? { |lib| have_library(lib) || (abort("could not find library: #{lib}") if fatal) }
#end
#
#def check_heads heads = [], fatal = false
#  heads.all? { |head| have_header(head) || (abort("could not find header: #{head}") if fatal)}
#end
#
#case RUBY_PLATFORM
#when /mswin32/, /mingw32/, /bccwin32/
#  check_heads(%w[windows.h winsock.h], true)
#  check_libs(%w[kernel32 rpcrt4 gdi32], true)
#
#  if GNU_CHAIN
#    CONFIG['LDSHARED'] = "$(CXX) -shared -lstdc++"
#  else
#    $defs.push "-EHs"
#    $defs.push "-GR"
#  end
#
#when /solaris/
#
#  if CONFIG['CC'] == 'cc' and `cc -flags 2>&1` =~ /Sun/ # detect SUNWspro compiler
#    # SUN CHAIN
#    $preload = ["\nCXX = CC"] # hack a CXX= line into the makefile
#    $CFLAGS = CONFIG['CFLAGS'] = "-KPIC"
#    CONFIG['CCDLFLAGS'] = "-KPIC"
#    CONFIG['LDSHARED'] = "$(CXX) -G -KPIC -lCstd"
#  else
#    # GNU CHAIN
#    # on Unix we need a g++ link, not gcc.
#    CONFIG['LDSHARED'] = "$(CXX) -shared"
#  end
#  CZMQ_CFLAGS << "-fPIC"
#
#when /openbsd/
#  # OpenBSD branch contributed by Guillaume Sellier.
#
#  # on Unix we need a g++ link, not gcc. On OpenBSD, linking against libstdc++ have to be explicitly done for shared libs
#  CONFIG['LDSHARED'] = "$(CXX) -shared -lstdc++ -fPIC"
#  CONFIG['LDSHAREDXX'] = "$(CXX) -shared -lstdc++ -fPIC"
#
#when /darwin/
#  # on Unix we need a g++ link, not gcc.
#  # Ff line contributed by Daniel Harple.
#  CONFIG['LDSHARED'] = "$(CXX) " + CONFIG['LDSHARED'].split[1..-1].join(' ')
#
#when /aix/
#  CONFIG['LDSHARED'] = "$(CXX) -shared -Wl,-G -Wl,-brtl"
#
#when /linux/
#  CZMQ_CFLAGS << "-fPIC"
#
#else
#  # on Unix we need a g++ link, not gcc.
#  CONFIG['LDSHARED'] = "$(CXX) -shared"
#end

have_header('ruby/thread.h')
have_func('rb_thread_blocking_region')
have_func('rb_thread_call_without_gvl')

pkg_config('libzmq')
pkg_config('libczmq')

find_header('zmq.h')  or exit 1
find_header('czmq.h') or exit 1

find_library('zmq', 'zmq_version')   or exit 1
find_library('czmq', 'zsys_version') or exit 1

# Check for functions to support if they exist
have_func('zsocket_set_router_mandatory', 'czmq.h')

# Check for macros to support if they exist
$defs << '-DHAVE_ZMQ_STREAM' if have_macro('ZMQ_STREAM', 'zmq.h')

$defs << "-pedantic"

$CFLAGS  << ' -Wall -funroll-loops'
$CFLAGS  << ' -Wextra -O0 -ggdb3' if ENV['DEBUG']

create_makefile('rbczmq_ext')
