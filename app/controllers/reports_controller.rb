require 'net/http'

class ReportsController < ApplicationController
  def age_distribution
    @country = params[:country] || "IN"
    @year = params[:year] || 2014
    uri = URI(api_end_point(@country, @year))
    data = fetch_api_data(uri)
    @data = data
  end

  def age_change
    @country = params[:country] || "IN"
    @year1 = params[:year1] || 2010
    @year2 = params[:year2] || 2014
    uri1 = URI(api_end_point(@country, @year1))
    uri2 = URI(api_end_point(@country, @year2))
    data1 = fetch_api_data(uri1)
    data2 = fetch_api_data(uri2)
    @data = []
    (0...data1.length).each do |i|
      count1 = data1[i][1]
      count2 = data2[i][1]
      perc_change = 100.0*(count2 - count1)/count1
      @data.push([data1[i][0], perc_change])
    end
  end

  def sex_compare
    @country = params[:country] || "IN"
    @year = params[:year] || 2014
    male_uri = URI(api_end_point(@country, @year, 1))
    male_data = fetch_api_data(male_uri)
    female_uri = URI(api_end_point(@country, @year, 2))
    female_data = fetch_api_data(female_uri)
    @data = [{name: "Male", data: male_data}, {name: "Female", data: female_data}]
  end

private
  def api_end_point(country, year, sex = 0)
    "http://api.census.gov/data/timeseries/idb/1year?get=AREA_KM2,NAME,AGE,POP&FIPS=#{country}&time=#{year}&SEX=#{sex}&key=d74841bef8b2042e2912fcd70e739b4c08f3213f"
  end

  def fetch_api_data(uri)
    JSON.parse(Net::HTTP.get(uri))[1..-1].collect do |datum|
      [datum[2].to_i, datum[3].to_i]
    end
  end
end
