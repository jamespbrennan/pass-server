# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
devicetypes = DeviceType.create([
	{name: 'Unknown', identifier: '', manufacturer: 'Unknown'},
	{name: 'iPhone Simulator', identifier: 'i386', manufacturer: 'Apple'},
	{name: 'iPod Touch', identifier: 'iPod1,1', manufacturer: 'Apple'},
	{name: 'iPod Touch (Second Generation)', identifier: 'iPod2,1', manufacturer: 'Apple'},
	{name: 'iPod Touch (Third Generation)', identifier: 'iPod3,1', manufacturer: 'Apple'},
	{name: 'iPod Touch (Fourth Generation)', identifier: 'iPod4,1', manufacturer: 'Apple'},
	{name: 'iPhone', identifier: 'iPhone1,1', manufacturer: 'Apple'},
	{name: 'iPhone 3G', identifier: 'iPhone1,2', manufacturer: 'Apple'},
	{name: 'iPhone 3GS', identifier: 'iPhone2,1', manufacturer: 'Apple'},
	{name: 'iPad', identifier: 'iPad1,1', manufacturer: 'Apple'},
	{name: 'iPad 2', identifier: 'iPad2,1', manufacturer: 'Apple'},
	{name: 'iPad', identifier: 'iPad3,1', manufacturer: 'Apple'},
	{name: 'iPhone 4', identifier: 'iPhone3,1', manufacturer: 'Apple'},
	{name: 'iPhone 4S', identifier: 'iPhone4,1', manufacturer: 'Apple'},
	{name: 'iPhone 5', identifier: 'iPhone5,1', manufacturer: 'Apple'},
	{name: 'iPhone 5', identifier: 'iPhone5,2', manufacturer: 'Apple'},
])