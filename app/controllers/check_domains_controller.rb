class CheckDomainsController < ApplicationController
  def index
  end

  def create
    domains = params[:domain_list].split(/\r?\n/)
    my_nameservers = params[:nameserver_list].split(/\r?\n/)
    my_nameservers = my_nameservers.map(&:downcase)
    w = Whois::Client.new

    @my_domains = Array.new
    @outside_domains = Array.new
    @result = ""

    domains.each do |domain|
      r = w.lookup(domain)
      is_mine = false
      r.nameservers.each do |nameserver|
        if my_nameservers.include? nameserver.to_s.downcase
          is_mine = true
        end
      end
      if is_mine
        @my_domains.push(domain)
      else
        @outside_domains.push(domain)
      end
    end
  end
end
