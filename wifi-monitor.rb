#!/usr/bin/env ruby
require 'csv'
require 'rubygems'
require 'telegram_bot'
require 'pp'
require 'net/http'
require 'uri'

def contains_bssid(str)
  str =~ /[a-zA-Z_]/
end

def contains_essid(str)
  str =~ /[0-9]/
end

def contains_not_associated(str)
  str =~ /(not associated)/
end

def lookup_mac(clientMac)
    url = 'https://api.macvendors.com/' + clientMac.gsub("\"","").gsub(":","-").to_s
    uri = URI(url)
    brand = ""

    Net::HTTP.start(uri.host, uri.port,:use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri
      response = http.request request # Net::HTTPResponse object
      sleep (1)
      if  response.code == "200"
        brand = response.body.gsub(",","")
      else
        brand = "Vendor Not Found"
      end
    end
    return brand
end

#
# Normal configuration loading.
#

$config = JSON.parse( File.read( File.join( __dir__, File.join( "config", "config.json" ) ) ) )

ap_Map = Hash.new
client_Map = Hash.new
known_hosts = Hash.new
known_aps = Hash.new

#
# Process Data
#

token = $config['session']['token']

CSV.foreach(File.path($config['defaults']['known_aps'])) { |row|
  tmp = row[0].gsub(/\s+/, "")
  known_aps["#{tmp}"] = row[1]
}

CSV.foreach(File.path($config['defaults']['airodump_capture'])) { |row|
  if (contains_bssid(row[13]) || (!row[12].nil? && row[12].match(/0/)) ) && !row[13].match(/ESSID/)
    tmp = row[0].gsub(/\s+/, "")
    ap_Map["#{tmp}"] = row[13].gsub(/\s+/, "")
    tmp = row[0].gsub(/\s+/, "")
      if row[12].match(/0/)
        ssid = "Hidden SSID"
      else
        ssid = row[13].gsub(/\s+/, "")
      end
    ap_Map["#{tmp}"] = ssid

  elsif contains_essid(row[5]) || contains_not_associated(row[5])
    clientMac = row[0].gsub(/\s+/, "")
    apMac = row[5].gsub(/\s+/, "")

    if contains_essid(clientMac)
      if ap_Map[apMac].nil?
        bssid = "Client not associated"
      else
        bssid = ap_Map[apMac].to_s
      end

      if known_aps[apMac].nil?
        client_Map["#{clientMac}"] = "BSSID: " + bssid + ", Location: NA , Device Vendor: "
      else
        client_Map["#{clientMac}"] = "BSSID: " + bssid + ", Location: " + known_aps[apMac] + ", Device Vendor: "
      end
    else
      if known_aps[apMac].nil?
        client_Map["#{clientMac}"] = "BSSID: Client not associated, Location: NA, Device Vendor: "
      else
        client_Map["#{clientMac}"] = "BSSID: Client not associated, Location: " + known_aps[apMac] + ", Device Vendor: "
      end
    end
  end
}


CSV.foreach(File.path($config['defaults']['know_hosts'])) { |row|
  tmp = row[0].gsub(/\s+/, "")
  known_hosts["#{tmp}"] = row[1].gsub(/\s+/, "")
}

client_Map.each do |key, value|

  if !known_hosts.include? key
    vendor = lookup_mac(key)
    puts("Unknown host. MAC: " + key + ", INFO " + value.to_s + vendor)
    bot = TelegramBot.new(token: token)
    channel = TelegramBot::Channel.new(id: 42182075)
    message = TelegramBot::OutMessage.new
    message.chat = channel
    message.text = "Unknown host. MAC: " + key + ", INFO " + value.to_s + vendor
    message.send_with(bot)
    
    sleep(1)
    
    CSV.open($config['defaults']['know_hosts'], "a", force_quotes: true) do |csv|
      data = [ key  , value.to_s + vendor]
      csv << data
    end
  end
end
