#####################################################################
# Copyright (C) 2013 Navyug Infosolutions Pvt Ltd.
# Developer : Ranu Pratap Singh
# Email : ranu.singh@navyuginfo.com
# Created Date : 17/7/15
#####################################################################

module Dwarpaal
  class RequestLog < ActiveRecord::Base
    def self.count_on_day(c_date, ip_address = nil)
      if ip_address
        where(:ip_address=>ip, :c_date => c_date).count
      else
        where(:c_date => c_date).count
      end
    end
  end
end