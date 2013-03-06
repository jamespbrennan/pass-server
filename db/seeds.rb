# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
devicetypes = DeviceType.create([
	{name: 'Unknown', identifier: '', manufacturer: 'Unknown'},
	{name: 'iPhone 5', identifier: 'A1428', manufacturer: 'Apple'}, 	# 2012 GSM model
	{name: 'iPhone 5', identifier: 'A1429', manufacturer: 'Apple'}, 	# 2012 GSM and CDMA models
	{name: 'iPhone 5', identifier: 'A1442', manufacturer: 'Apple'}, 	# 2012 CDMA China
	{name: 'iPhone 4S', identifier: 'A1387', manufacturer: 'Apple'}, 	# 2011
	{name: 'iPhone 4S', identifier: 'A1431', manufacturer: 'Apple'}, 	# 2011 GSM China
	{name: 'iPhone 4S', identifier: 'A1349', manufacturer: 'Apple'}, 	# 2011 CDMA model
	{name: 'iPhone 4S', identifier: 'A1332', manufacturer: 'Apple'}, 	# 2010 GSM model
	{name: 'iPhone 3GS', identifier: 'A1325', manufacturer: 'Apple'}, 	# 2009 China
	{name: 'iPhone 3GS', identifier: 'A1303', manufacturer: 'Apple'}, 	# 2009
	{name: 'iPhone 3G', identifier: 'A1324', manufacturer: 'Apple'}, 	# 2009 China
	{name: 'iPhone 3G', identifier: 'A1241', manufacturer: 'Apple'}, 	# 2008
	{name: 'iPhone', identifier: 'A1203', manufacturer: 'Apple'}, 		# 2007
])