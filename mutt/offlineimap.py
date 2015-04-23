#!/usr/bin/python
import re
from subprocess import check_output
import os
import datetime

def mailpasswd(acct):
  print datetime.datetime.now()
  path = "/Users/rsahae/.msmtp-%s.gpg" % acct
  print path
  args = ["/usr/local/bin/gpg", "--quiet", "--no-tty", "--decrypt", path]
  print args
  return check_output(args).strip()
