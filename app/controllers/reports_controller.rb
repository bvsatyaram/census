require 'net/http'

class ReportsController < ApplicationController
  def age_distribution
    @country = params[:country] || "IN"
    @year = params[:year] || 2014
    uri = URI("http://api.census.gov/data/timeseries/idb/1year?get=AREA_KM2,NAME,AGE,POP&FIPS=#{@country}&time=#{@year}&SEX=0&key=d74841bef8b2042e2912fcd70e739b4c08f3213f")
    data = JSON.parse(Net::HTTP.get(uri))[1..-1].collect do |datum|
      [datum[2].to_i, datum[3].to_i]
    end
    @data = data
  end
end
